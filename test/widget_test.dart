// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:researchfin/controller/controller.dart';
// import 'package:researchfin/models/stock_symbol_model.dart';

void main() {
  test('Fetch data from api', () async {
    await Controller().isSymbolValid('IBM');

    // print('result : ${result.values.elementAt(0)}');
  });
}
