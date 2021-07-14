class MetaDataModel {
  MetaDataModel({
    required this.information,
    required this.symbol,
    required this.lastRefreshed,
    required this.outputSize,
    required this.timeZone,
  });

  String information;
  String symbol;
  DateTime lastRefreshed;
  String outputSize;
  String timeZone;

  factory MetaDataModel.fromJson(Map<String, dynamic> json) => MetaDataModel(
    information: json["1. Information"],
    symbol: json["2. Symbol"],
    lastRefreshed: DateTime.parse(json["3. Last Refreshed"]),
    outputSize: json["4. Output Size"],
    timeZone: json["5. Time Zone"],
  );

//   Map<String, dynamic> toJson() => {
//     "1. Information": information,
//     "2. Symbol": symbol,
//     "3. Last Refreshed": "${lastRefreshed.year.toString().padLeft(4, '0')}-${lastRefreshed.month.toString().padLeft(2, '0')}-${lastRefreshed.day.toString().padLeft(2, '0')}",
//     "4. Output Size": outputSize,
//     "5. Time Zone": timeZone,
//   };
}