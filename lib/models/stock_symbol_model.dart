// import 'package:researchfin/models/meta_data_model.dart';
import 'package:researchfin/models/candlestick_data_model.dart';

class StockSymbolModel {
  StockSymbolModel({
    // required this.metaData,
    required this.candlestickData,
  });

  // MetaDataModel metaData;
  List<CandlestickDataModel> candlestickData;

  factory StockSymbolModel.fromJson(Map<String, dynamic> json) => StockSymbolModel(
    // metaData: MetaDataModel.fromJson(json.values.elementAt(0)),
    // candlestickData: Map.from(json["Time Series (Daily)"]).map((k, v) => MapEntry<String, CandlestickDataModel>(k, CandlestickDataModel.fromJson(k,v))),
    candlestickData: List.from(Map.from(json.values.elementAt(1)).entries.map((element) => CandlestickDataModel.fromJson(element.key, element.value)).toList().reversed),
  );

  // Map<String, dynamic> toJson() => {
  //   "Meta Data": metaData.toJson(),
  //   "Time Series (Daily)": Map.from(timeSeries).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  // };
}



