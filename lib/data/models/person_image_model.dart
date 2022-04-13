import 'package:popular_people/domain/domain.dart';

class PersonImageModel extends PersonImageEntity {
  const PersonImageModel({
    required int id,
    required List<ImageModel> images,
  }) : super(id: id, images: images);

  factory PersonImageModel.fromJson(dynamic json) {
    return PersonImageModel(
        id: json['id'],
        images: json['profiles'] != null
            ? json['profiles'].map((e) => ImageModel.fromJson(e))
            : "");
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (images != null) {
      map['profiles'] = images?.map((v) => (v as ImageModel).toJson()).toList();
    }
    return map;
  }
}

class ImageModel extends ImageEntity {
  const ImageModel(
      {required double? aspectRatio,
      required int? height,
      required dynamic iso6391,
      required String? filePath,
      required double? voteAverage,
      required int? voteCount,
      required int? width})
      : super(
            aspectRatio: aspectRatio,
            height: height,
            iso6391: iso6391,
            filePath: filePath,
            voteAverage: voteAverage,
            voteCount: voteCount,
            width: width);

  factory ImageModel.fromJson(dynamic json) {
    return ImageModel(
        aspectRatio: json['aspect_ratio'],
        height: json['height'],
        iso6391: json['iso_639_1'],
        filePath: json['file_path'],
        voteAverage: json['vote_average'],
        voteCount: json['vote_count'],
        width: json['width']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['aspect_ratio'] = aspectRatio;
    map['height'] = height;
    map['iso_639_1'] = iso6391;
    map['file_path'] = filePath;
    map['vote_average'] = voteAverage;
    map['vote_count'] = voteCount;
    map['width'] = width;
    return map;
  }
}
