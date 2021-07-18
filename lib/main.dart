import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:researchfin/screens/home_screen.dart';
import 'package:researchfin/theme/theme_data.dart';
import 'package:researchfin/controller/controller.dart';
import 'package:researchfin/models/symbol_annotation.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  Hive.registerAdapter(TimeIntervalAdapter());
  Hive.registerAdapter(SymbolAnnotationAdapter());
  Hive.registerAdapter(AnnoOffsetModelAdapter());
  Hive.registerAdapter(SymbolOffsetAdapter());

  await Hive.initFlutter();
  await Hive.openBox<SymbolAnnotation>('annoBox');

  runApp(ResearchFin());
}

class ResearchFin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider<Controller>(
      create: (context) => Controller(),
      child: MaterialApp(
        title: 'Research',
        theme: researchFinTheme,
        home: HomeScreen(),
        builder: (BuildContext context, Widget? child) {
          final MediaQueryData data = MediaQuery.of(context);
          return MediaQuery(
            data: data.copyWith(
              textScaleFactor: 1.0,
            ),
            child: child!,
          );
        },
      ),
    );
  }
}