import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:researchfin/models/stock_symbol_model.dart';

class Controller with ChangeNotifier {
  late http.Response responseDaily, responseWeekly, responseMonthly, responseSymbol;

  String _function = 'not_specified';

  StockSymbolModel? _stockSymbolModel;

  String get function => _function;

  Future<bool> getJsonViaHttp(String stockSymbol, String function) async {
    Uri daily = Uri.parse('https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=$stockSymbol&outputsize=full&apikey=Y9JVN150E7U3U6ZV');
    Uri weekly = Uri.parse('https://www.alphavantage.co/query?function=TIME_SERIES_WEEKLY&symbol=$stockSymbol&apikey=Y9JVN150E7U3U6ZV');
    Uri monthly = Uri.parse('https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY&symbol=$stockSymbol&apikey=Y9JVN150E7U3U6ZV');

    try {
      responseDaily = await http.get(daily);
      responseWeekly = await http.get(weekly);
      responseMonthly = await http.get(monthly);
      // _stockSymbolModel = StockSymbolModel.fromJson(json.decode(responseDaily.body));

      // _stockSymbolModel!.candlestickData.forEach((element) {
      //   print('Timestamp : ${element.timeStamp}\nOpen : ${element.open}\nClose : ${element.close}\nHigh : ${element.high}\nLow : ${element.low}\nVolume : ${element.volume}\n\n');
      // });

      // _stockSymbolModel!.candlestickData.forEach((element) {
      //   print('Timestamp : ${element.timeStamp}\nOpen : ${element.open}\nClose : ${element.close}\nHigh : ${element.high}\nLow : ${element.low}\nVolume : ${element.volume}\n\n');
      // });
      //
      // _stockSymbolModel!.candlestickDataMonthly.forEach((element) {
      //   print('Timestamp : ${element.timeStamp}\nOpen : ${element.open}\nClose : ${element.close}\nHigh : ${element.high}\nLow : ${element.low}\nVolume : ${element.volume}\n\n');
      // });

      _function = 'TIME_SERIES_DAILY';
      // _function = 'TIME_SERIES_MONTHLY';
      // _function = 'TIME_SERIES_WEEKLY';

      notifyListeners();

      // if (stockSymbolModel!.metaData.symbol == stockSymbol)
      //   return true;
      // else
      //   return false;
      return true;
    } catch (e) {
      print('Error while fetching data from https: $e');
      return false;
    }
    // return stockSymbolModel;
  }

  StockSymbolModel? get stockSymbolModel {
    if (_function.contains('TIME_SERIES_DAILY')) {
      _stockSymbolModel = StockSymbolModel.fromJson(json.decode(responseDaily.body));
    } else if (_function.contains('TIME_SERIES_WEEKLY')) {
      _stockSymbolModel = StockSymbolModel.fromJson(json.decode(responseWeekly.body));
    } else if (_function.contains('TIME_SERIES_MONTHLY')) {
      _stockSymbolModel = StockSymbolModel.fromJson(json.decode(responseMonthly.body));
    } else
      return _stockSymbolModel;

    return _stockSymbolModel;
  }

  void setFunction(String function) {
    _function = function;

    notifyListeners();
  }

  Future<bool> isSymbolValid(String stockSymbol) async {
    Uri symbolUrl = Uri.parse('https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=$stockSymbol&apikey=Y9JVN150E7U3U6ZV');

    try {
      responseSymbol = await http.get(symbolUrl);
      var sym = json.decode(responseSymbol.body);
      if (Map.from(List.from(Map.from(sym).values.first).first).values.first.toString() == stockSymbol) {
        // print(Map.from(List.from(Map.from(sym).values.first).first).values.first.toString().contains(stockSymbol));
        return true;
      } else
        return false;
    } catch (e) {
      print('Error in retrieving symbol: $e');
      return false;
    }
  }
}
