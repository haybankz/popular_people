import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:popular_people/core/core.dart';
import 'package:popular_people/domain/domain.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({Key? key, required this.image}) : super(key: key);
  final ImageEntity image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CachedNetworkImage(
          imageUrl: "${Strings.imageStorageUrl}${image.filePath}",
          width: image.width?.toDouble(),
          height: image.height?.toDouble(),
        ),
      ),
    );
  }
}
