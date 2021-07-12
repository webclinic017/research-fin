import 'package:flutter/material.dart';

import 'package:researchfin/theme/colors.dart';
import 'package:researchfin/widgets/time_interval_button.dart';
import 'package:researchfin/widgets/annotation_tool_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _stockSymbol;
  late TextEditingController _stockSymbolController;

  @override
  void initState() {
    super.initState();

    _stockSymbol = 'AGB';
    _stockSymbolController = TextEditingController();
  }

  @override
  void dispose() {
    _stockSymbolController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          // shrinkWrap: true,
          children: [
            SizedBox(height: 16.0),
            // >>> [BLOCK] Search Bar ------------------------>|
            SizedBox(
              height: 56.0,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: TextFormField(
                        controller: _stockSymbolController,
                        cursorHeight: 24.0,
                        maxLines: 1,
                        // autofocus: true,
                        style: Theme.of(context).textTheme.headline6,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0.0),
                          border: InputBorder.none,
                          hintText: 'Search Stock Symbol',
                          hintStyle: Theme.of(context).textTheme.headline6?.copyWith(color: AppColor.stockWhite.withOpacity(0.5)),
                          errorBorder: InputBorder.none,
                          errorText: 'Invalid Stock Symbol',
                          errorStyle: Theme.of(context).textTheme.caption?.copyWith(color: AppColor.stockRed),
                        ),
                        validator: (searchText) {
                          // TODO : Validate Inputs
                        },
                        onFieldSubmitted: (searchText) {
                          // TODO : Search for stock symbol
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  AnnotationButton(
                    icon: Icons.search,
                    onTap: () {
                      // TODO : Search for stock symbol
                    },
                  ),
                ],
              ),
            ),
            // >>> Search Bar [END] ------------------------>|
            SizedBox(height: 32.0),
            // >>> Stock Symbol ------------------------>|
            Text(
              _stockSymbol,
              style: Theme.of(context).textTheme.headline4,
            ),
            // >>> Stock Symbol [END] ------------------>|
            SizedBox(height: 20.0),
            // >>> [BLOCK] Stock Symbol Graph ------------->|
            Container(
              width: double.infinity,
              height: 420.0,
              decoration: BoxDecoration(
                color: AppColor.stockBlack,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(4.0, 4.0),
                    blurRadius: 8.0,
                    spreadRadius: 1.0,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    offset: Offset(-4.0, -4.0),
                    blurRadius: 8.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
            ),
            // >>> Stock Symbol Graph [END] ------------->|
            SizedBox(height: 32.0),
            // >>> [BLOCK] Time Interval Section ------------->|
            Text(
              'Time Interval',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16.0),
            SizedBox(
              child: Wrap(
                spacing: 24.0,
                runSpacing: 24.0,
                children: [
                  TimeIntervalButton(
                    label: 'DAILY',
                    onTap: () {
                      // TODO : Toggle graph values based on time interval selected
                    },
                  ),
                  // SizedBox(width: 24.0),
                  TimeIntervalButton(
                    label: 'WEEKLY',
                    onTap: () {
                      // TODO : Toggle graph values based on time interval selected
                    },
                  ),
                  // SizedBox(width: 24.0),
                  TimeIntervalButton(
                    label: 'MONTHLY',
                    onTap: () {
                      // TODO : Toggle graph values based on time interval selected
                    },
                  ),
                ],
              ),
            ),
            // >>> Time Interval Section [END] ------------->|
            SizedBox(height: 32.0),
            // >>> [BLOCK] Annotation Tools Section ------------->|
            Text(
              'Annotation Tools',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16.0),
            SizedBox(
              // height: 40.0,
              child: Row(
                children: [
                  AnnotationButton(
                    icon: Icons.edit,
                    onTap: () {
                      // TODO : Toggle annotation on/off
                    },
                  ),
                  SizedBox(width: 32.0),
                  AnnotationButton(
                    icon: Icons.edit_off,
                    onTap: () {
                      // TODO : Toggle annotation on/off
                    },
                  ),
                  SizedBox(width: 32.0),
                  AnnotationButton(
                    icon: Icons.visibility,
                    onTap: () {
                      // TODO : Toggle annotation on/off
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }
}






