import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:researchfin/models/stock_symbol_model.dart';

class Controller with ChangeNotifier {

  late StockSymbolModel _stockSymbolModel;

  StockSymbolModel get stockSymbolModel => _stockSymbolModel;

  void getJsonViaHttp(String stockSymbol, String function) async {

    // StockSymbolModel? stockSymbolModel;
    Uri url = Uri.parse('https://www.alphavantage.co/query?function=$function&symbol=$stockSymbol&apikey=Y9JVN150E7U3U6ZV');

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      // stockSymbolModel = json.decode(response.body);
      _stockSymbolModel = StockSymbolModel.fromJson(json.decode(response.body));

      _stockSymbolModel.candlestickData.forEach((element) {
        print('Timestamp : ${element.timeStamp}\nOpen : ${element.open}\nClose : ${element.close}\nHigh : ${element.high}\nLow : ${element.low}\nVolume : ${element.volume}\n\n');
      });
    }

    notifyListeners();

    // return stockSymbolModel;
  }
}
