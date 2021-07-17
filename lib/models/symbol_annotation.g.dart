// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symbol_annotation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimeIntervalAdapter extends TypeAdapter<TimeInterval> {
  @override
  final int typeId = 3;

  @override
  TimeInterval read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TimeInterval.daily;
      case 1:
        return TimeInterval.weekly;
      case 2:
        return TimeInterval.monthly;
      default:
        return TimeInterval.daily;
    }
  }

  @override
  void write(BinaryWriter writer, TimeInterval obj) {
    switch (obj) {
      case TimeInterval.daily:
        writer.writeByte(0);
        break;
      case TimeInterval.weekly:
        writer.writeByte(1);
        break;
      case TimeInterval.monthly:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeIntervalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SymbolAnnotationAdapter extends TypeAdapter<SymbolAnnotation> {
  @override
  final int typeId = 1;

  @override
  SymbolAnnotation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SymbolAnnotation(
      stockSymbol: fields[0] as String,
      symbolAnnoOffsets: (fields[1] as List).cast<AnnoOffsetModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, SymbolAnnotation obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.stockSymbol)
      ..writeByte(1)
      ..write(obj.symbolAnnoOffsets);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SymbolAnnotationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AnnoOffsetModelAdapter extends TypeAdapter<AnnoOffsetModel> {
  @override
  final int typeId = 2;

  @override
  AnnoOffsetModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnnoOffsetModel(
      annoOffsets: (fields[0] as List).cast<Offset>(),
      timeInterval: fields[1] as TimeInterval,
    );
  }

  @override
  void write(BinaryWriter writer, AnnoOffsetModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.annoOffsets)
      ..writeByte(1)
      ..write(obj.timeInterval);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnnoOffsetModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
