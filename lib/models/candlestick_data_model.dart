class CandlestickDataModel {
  CandlestickDataModel({
    required this.timeStamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  DateTime timeStamp;
  double open;
  double high;
  double low;
  double close;
  double volume;

  factory CandlestickDataModel.fromJson(String timeStamp, Map<String, dynamic> json) => CandlestickDataModel(
    timeStamp: DateTime.parse(timeStamp),
    open: double.parse(json["1. open"]),
    high: double.parse(json["2. high"]),
    low: double.parse(json["3. low"]),
    close: double.parse(json["4. close"]),
    volume: double.parse(json["5. volume"]),
  );

// Map<String, dynamic> toJson() => {
//   "1. open": open,
//   "2. high": high,
//   "3. low": low,
//   "4. close": close,
//   "5. volume": volume,
// };
}