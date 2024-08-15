// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article_details_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArticleDetailsItemAdapter extends TypeAdapter<ArticleDetailsItem> {
  @override
  final int typeId = 0;

  @override
  ArticleDetailsItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArticleDetailsItem(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ArticleDetailsItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.sourceName)
      ..writeByte(3)
      ..write(obj.publishedAt)
      ..writeByte(4)
      ..write(obj.url)
      ..writeByte(5)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleDetailsItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
