import 'package:flutter/material.dart';

class SymbolAnnotation {
  String stockSymbol;
  List<AnnoOffsetModel> symbolAnnoOffsets;

  SymbolAnnotation({required this.stockSymbol, required this.symbolAnnoOffsets});
}

class AnnoOffsetModel {
  List<Offset> annoOffsets;
  TimeInterval timeInterval;

  AnnoOffsetModel({required this.annoOffsets, required this.timeInterval});
}

enum TimeInterval {
  daily,
  weekly,
  monthly,
}
