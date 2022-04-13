import 'package:equatable/equatable.dart';

class PersonImageEntity extends Equatable {
  const PersonImageEntity({
    this.id,
    this.images,
  });

  final int? id;
  final List<ImageEntity>? images;

  @override
  List<Object?> get props => [id, images];
}

class ImageEntity extends Equatable {
  const ImageEntity({
    this.aspectRatio,
    this.height,
    this.iso6391,
    this.filePath,
    this.voteAverage,
    this.voteCount,
    this.width,
  });

  final double? aspectRatio;
  final int? height;
  final dynamic iso6391;
  final String? filePath;
  final double? voteAverage;
  final int? voteCount;
  final int? width;

  @override
  List<Object?> get props =>
      [aspectRatio, height, iso6391, filePath, voteAverage, voteCount, width];
}
