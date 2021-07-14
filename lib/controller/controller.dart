import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:researchfin/models/stock_symbol_model.dart';

class Controller with ChangeNotifier {
  StockSymbolModel? _stockSymbolModel;

  StockSymbolModel? get stockSymbolModel => _stockSymbolModel;

  Future<bool> getJsonViaHttp(String stockSymbol, String function) async {
    Uri url = Uri.parse('https://www.alphavantage.co/query?function=$function&symbol=$stockSymbol&apikey=Y9JVN150E7U3U6ZV');

    try {
      http.Response response = await http.get(url);
      _stockSymbolModel = StockSymbolModel.fromJson(json.decode(response.body));

      _stockSymbolModel!.candlestickData.forEach((element) {
        print('Timestamp : ${element.timeStamp}\nOpen : ${element.open}\nClose : ${element.close}\nHigh : ${element.high}\nLow : ${element.low}\nVolume : ${element.volume}\n\n');
      });

      notifyListeners();

      return true;
    } catch (e) {
      print('Error while fetching data from https: $e');
      return false;
    }
    // return stockSymbolModel;
  }
}
