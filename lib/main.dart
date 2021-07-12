import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:researchfin/screens/home_screen.dart';
import 'package:researchfin/theme/theme_data.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(ResearchFin());
}

class ResearchFin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
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
    );
  }
}