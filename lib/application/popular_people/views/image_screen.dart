import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:popular_people/core/core.dart';
import 'package:popular_people/data/data.dart';
import 'package:popular_people/domain/domain.dart';

class ImageScreen extends StatelessWidget {
  ImageScreen({Key? key, required this.image}) : super(key: key);
  final ImageEntity image;

  final GlobalKey _imageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    print((image as ImageModel).toJson());
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
              onPressed: () async => _capturePng(context),
              label: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(
                Icons.download,
                color: Colors.white,
              )),
        ],
      ),
      body: Center(
        child: RepaintBoundary(
          key: _imageKey,
          child: Image.network(
            "${Strings.imageStorageUrl}${image.filePath}",
            width: image.width?.toDouble(),
            height: image.height?.toDouble(),
          ),
        ),
      ),
    );
  }

  Future<void> _capturePng(BuildContext context) async {
    try {
      String imagePath;
      File capturedFile;
      print('inside');
      RenderRepaintBoundary boundary = _imageKey.currentContext!
          .findRenderObject()! as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
//create file
      final String dir = (await getApplicationDocumentsDirectory()).path;
      imagePath = '$dir/popular_people${DateTime.now()}.png';
      capturedFile = File(imagePath);
      await capturedFile.writeAsBytes(pngBytes);
      print(capturedFile.path);
      final result = await ImageGallerySaver.saveImage(pngBytes,
          quality: 100, name: "file_name${DateTime.now()}");
      print(result);
      print('png done');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Download Completed")));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Download Failed")));
    }
  }
}
