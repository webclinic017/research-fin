import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:researchfin/theme/colors.dart';
import 'package:researchfin/views/candlestick_chart_view.dart';
import 'package:researchfin/widgets/time_interval_button.dart';
import 'package:researchfin/widgets/annotation_tool_button.dart';
import 'package:researchfin/controller/controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _stockSymbol;
  late TextEditingController _stockSymbolController;

  late Controller controller, controllerFalse;

  final String _functionDaily = 'TIME_SERIES_DAILY';
  final String _functionWeekly = 'TIME_SERIES_WEEKLY';
  final String _functionMonthly = 'TIME_SERIES_MONTHLY';

  late bool isValidSymbol;

  @override
  void initState() {
    super.initState();

    _stockSymbol = '---';
    _stockSymbolController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _stockSymbolController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller = Provider.of<Controller>(context);
    controllerFalse = Provider.of<Controller>(context, listen: false);

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
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _stockSymbolController,
                          cursorHeight: 24.0,
                          maxLines: 1,
                          autofocus: true,
                          style: Theme.of(context).textTheme.headline6,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(0.0),
                            border: InputBorder.none,
                            hintText: 'Search Stock Symbol',
                            hintStyle: Theme.of(context).textTheme.headline6?.copyWith(color: AppColor.stockWhite.withOpacity(0.5)),
                            errorBorder: InputBorder.none,
                            errorStyle: Theme.of(context).textTheme.caption?.copyWith(color: AppColor.brightOrange),
                          ),
                          validator: (String? searchText) {
                            if (searchText!.isEmpty) {
                              // _errorMessage = 'Please enter a stock symbol!';
                              return 'Please enter a stock symbol!';
                            } else if (isValidSymbol == false) {
                              return 'Invalid Symbol';
                            }
                          },
                          onFieldSubmitted: (searchText) async {
                            isValidSymbol = await controllerFalse.isSymbolValid(searchText.toUpperCase());
                            setState(() {});
                            if (_formKey.currentState!.validate()) {
                              late bool status;
                              status = await controllerFalse.getJsonViaHttp(searchText.toUpperCase(), _functionDaily);

                              setState(() {
                                if (status) {
                                  _stockSymbol = searchText.toUpperCase();
                                  _stockSymbolController.text = '';
                                } else {
                                  _stockSymbol = 'ERROR';
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  AnnotationButton(
                    icon: Icons.search,
                    onTap: () async {
                      isValidSymbol = await controllerFalse.isSymbolValid(_stockSymbolController.text.toUpperCase());
                      setState(() {});
                      if (_formKey.currentState!.validate()) {
                        late bool status;
                        status = await controllerFalse.getJsonViaHttp(_stockSymbolController.text.toUpperCase(), _functionDaily);

                        setState(() {
                          if (status) {
                            _stockSymbol = _stockSymbolController.text.toUpperCase();
                            _stockSymbolController.text = '';
                          } else {
                            _stockSymbol = 'ERROR';
                          }
                        });
                      }
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
            // >>> [BLOCK] Stock Symbol Chart ------------->|
            Container(
              padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 8.0),
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
              // >>> Candlestick Chart Widget --------------------->|
              child: CandlestickChart(),
              // child: FutureBuilder(
              //   future: controllerFalse.getJsonViaHttp(_stockSymbolController.text.toUpperCase(), _functionDaily),
              //   builder: (BuildContext context, AsyncSnapshot snapshot) {
              //     if (snapshot.connectionState == ConnectionState.active) {
              //       return CircularProgressIndicator();
              //     } else if (snapshot.hasData) {
              //       return Container(child: Text('data fetched'));
              //     } else {
              //       return Container(child: Text('error has occurred'));
              //     }
              //   },
              // initialData: () {
              //   Container(child: Text('data not available'));
              // },
              // ),
            ),
            // >>> Stock Symbol Chart [END] ------------->|
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
                      controllerFalse.setFunction(_functionDaily);
                    },
                  ),
                  // SizedBox(width: 24.0),
                  TimeIntervalButton(
                    label: 'WEEKLY',
                    onTap: () {
                      controllerFalse.setFunction(_functionWeekly);
                    },
                  ),
                  // SizedBox(width: 24.0),
                  TimeIntervalButton(
                    label: 'MONTHLY',
                    onTap: () {
                      controllerFalse.setFunction(_functionMonthly);
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
