import 'package:hive/hive.dart';

part 'symbol_annotation.g.dart';

@HiveType(typeId: 1)
class SymbolAnnotation {
  @HiveField(0)
  String stockSymbol;

  @HiveField(1)
  List<AnnoOffsetModel> symbolAnnoOffsets;

  SymbolAnnotation({required this.stockSymbol, required this.symbolAnnoOffsets});
}

@HiveType(typeId: 2)
class AnnoOffsetModel {
  @HiveField(0)
  List<SymbolOffset> annoOffsets;

  @HiveField(1)
  TimeInterval timeInterval;

  AnnoOffsetModel({required this.annoOffsets, required this.timeInterval});
}

@HiveType(typeId: 3)
class SymbolOffset {
  @HiveField(0)
  double dx;

  @HiveField(1)
  double dy;

  SymbolOffset({required this.dx, required this.dy});
}

@HiveType(typeId: 4)
enum TimeInterval {
  @HiveField(0)
  daily,

  @HiveField(1)
  weekly,

  @HiveField(2)
  monthly,
}