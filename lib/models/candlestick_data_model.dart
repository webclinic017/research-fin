class CandlestickDataModel {
  CandlestickDataModel({
    required this.timeStamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  String timeStamp;
  String open;
  String high;
  String low;
  String close;
  String volume;

  factory CandlestickDataModel.fromJson(String timeStamp, Map<String, dynamic> json) => CandlestickDataModel(
    timeStamp: timeStamp,
    open: json["1. open"],
    high: json["2. high"],
    low: json["3. low"],
    close: json["4. close"],
    volume: json["5. volume"],
  );

// Map<String, dynamic> toJson() => {
//   "1. open": open,
//   "2. high": high,
//   "3. low": low,
//   "4. close": close,
//   "5. volume": volume,
// };
}

class Temp {
  String timeStamp;
  List<CandlestickDataModel> candlestickValues;

  Temp({required this.timeStamp, required this.candlestickValues});
}