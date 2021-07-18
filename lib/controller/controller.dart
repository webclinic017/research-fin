import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

import 'package:researchfin/models/stock_symbol_model.dart';
import 'package:researchfin/models/symbol_annotation.dart';

class Controller with ChangeNotifier {
  double _startOffset = 0.0;

  // String _function = 'not_specified';
  String _stockSymbol = '';
  TimeInterval? _timeInterval;

  List<Offset> _annoOffsets = [];

  StockSymbolModel? _stockSymbolModel;
  late http.Response responseDaily, responseWeekly, responseMonthly, responseSymbol;

  bool _drawAnnotation = false;
  bool _showAnnotation = false;

  TimeInterval? get timeInterval => _timeInterval;

  List<Offset> get annoOffsets => _annoOffsets;

  bool get drawAnnotation => _drawAnnotation;
  bool get showAnnotation => _showAnnotation;

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

      // _function = 'TIME_SERIES_DAILY';
      _timeInterval = TimeInterval.daily;
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
    // if (_function.contains('TIME_SERIES_DAILY')) {
    if (_timeInterval == TimeInterval.daily) {
      _stockSymbolModel = StockSymbolModel.fromJson(json.decode(responseDaily.body));
    // } else if (_function.contains('TIME_SERIES_WEEKLY')) {
    } else if (_timeInterval == TimeInterval.weekly) {
      _stockSymbolModel = StockSymbolModel.fromJson(json.decode(responseWeekly.body));
    // } else if (_function.contains('TIME_SERIES_MONTHLY')) {
    } else if (_timeInterval == TimeInterval.monthly) {
      _stockSymbolModel = StockSymbolModel.fromJson(json.decode(responseMonthly.body));
    } else
      return _stockSymbolModel;

    return _stockSymbolModel;
  }

  void setFunction(TimeInterval timeInterval) {
    _timeInterval = timeInterval;

    notifyListeners();
  }

  Future<bool> isSymbolValid(String stockSymbol) async {
    Uri symbolUrl = Uri.parse('https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=$stockSymbol&apikey=Y9JVN150E7U3U6ZV');

    try {
      responseSymbol = await http.get(symbolUrl);
      var sym = json.decode(responseSymbol.body);
      String fetchedSymbol = Map.from(List.from(Map.from(sym).values.first).first).values.first.toString();
      if (fetchedSymbol == stockSymbol) {
        // print(Map.from(List.from(Map.from(sym).values.first).first).values.first.toString().contains(stockSymbol));
        _stockSymbol = fetchedSymbol;
        return true;
      } else
        return false;
    } catch (e) {
      print('Error in retrieving symbol: $e');
      return false;
    }
  }

  void changeAnnotationState() {
    if (_drawAnnotation == false) {
      _drawAnnotation = true;
    } else {
      if (_annoOffsets.isNotEmpty) {
        List<SymbolOffset> symbolOffset = [];
        _annoOffsets.forEach((element) => symbolOffset.add(SymbolOffset(dx: _startOffset + element.dx, dy: element.dy)));
        var writeObject = SymbolAnnotation(
          stockSymbol: _stockSymbol,
          symbolAnnoOffsets: [
            AnnoOffsetModel(annoOffsets: symbolOffset, timeInterval: _timeInterval! ),
          ],
        );

        writeToBox(writeObject);
        _annoOffsets.clear();
      }
      _drawAnnotation = false;
    }

    notifyListeners();
  }

  void toggleVisibility() {
    if (_showAnnotation == false) {
      _showAnnotation = true;
    } else {
      _showAnnotation = false;
    }

    notifyListeners();
  }

  void addOffset(Offset offset) {
    _annoOffsets.add(offset);

    notifyListeners();
  }

  void clearOffsets() {
    _annoOffsets.clear();

    notifyListeners();
  }

  void updateStartOffset(double dx) {
    _startOffset = dx;
  }

  // Read and write from hive
  Box<SymbolAnnotation> _researchBox = Hive.box<SymbolAnnotation>('annoBox');

  void writeToBox(SymbolAnnotation object) {
    if (_researchBox.isEmpty) {
      _researchBox.add(object);
    } else if (existsInHive(object.stockSymbol)) {
      int index = getIndex(object.stockSymbol);
      writeToBoxAt(index, object);
    } else {
      _researchBox.add(object);
    }
  }

  void writeToBoxAt(int index, SymbolAnnotation object) {
    var temp = _researchBox.getAt(index);

    if (temp!.symbolAnnoOffsets.isNotEmpty) {
      object.symbolAnnoOffsets.insertAll(0, temp.symbolAnnoOffsets);
    }
    _researchBox.putAt(index, object);
  }

  bool existsInHive(String stockSymbol) {
    bool flag = false;
    if (_researchBox.isEmpty) {
      return flag;
    } else {
      _researchBox.values.forEach((element) {
        if (element.stockSymbol == stockSymbol) {
          flag = true;
        }
      });
    }

    return flag;
  }

  int getIndex(String stockSymbol) {
    return _researchBox.values.toList().indexWhere((element) => element.stockSymbol == stockSymbol);
  }

  // call FUNCTION existsInHive before FUNCTION readFromBoxAt to check whether value exists in hive box
  SymbolAnnotation? readFromBoxAt(int index) {
    return _researchBox.getAt(index);
  }

  List<Offset> getOldOffsets() {
    List<SymbolOffset> temp = [];
    List<Offset> offsets = [];

    if (existsInHive(_stockSymbol)) {
      _researchBox.getAt(getIndex(_stockSymbol))!.symbolAnnoOffsets.forEach((element) {
        if (element.timeInterval == _timeInterval) {
          temp.addAll(element.annoOffsets);
        }});
    }

    temp.forEach((element) {offsets.add(Offset(element.dx, element.dy));});

    return offsets;
  }
}
