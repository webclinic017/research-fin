import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:researchfin/models/symbol_annotation.dart';

import 'package:researchfin/theme/colors.dart';
import 'package:researchfin/views/candlestick_chart_view.dart';
import 'package:researchfin/widgets/neo_square_button.dart';
import 'package:researchfin/controller/controller.dart';
import 'package:hive/hive.dart';

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
  late bool showTimeInterval;

  @override
  void initState() {
    super.initState();

    _stockSymbol = '---.--';
    _stockSymbolController = TextEditingController(text: '');
    showTimeInterval = true;
  }

  @override
  void dispose() {
    _stockSymbolController.dispose();

    // Close the hive box
    Hive.close();
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
          physics: controller.drawAnnotation ? NeverScrollableScrollPhysics() : ClampingScrollPhysics(),
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
                  NeoSquareButton(
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
                    width: 56.0,
                    height: 56.0,
                    child: Icon(
                      Icons.search,
                      color: AppColor.stockWhite,
                      size: 24.0,
                    ),
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
            ),
            // >>> Stock Symbol Chart [END] ------------->|
            SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                showTimeInterval
                    ? SizedBox(
                        child: Row(
                          children: [
                            NeoSquareButton(
                              onTap: () {
                                controllerFalse.setFunction(TimeInterval.daily);
                              },
                              child: Text(
                                'D',
                                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                      color: controller.timeInterval == TimeInterval.daily ? AppColor.stockGreen : AppColor.stockWhite,
                                    ),
                              ),
                            ),
                            SizedBox(width: 24.0),
                            NeoSquareButton(
                              onTap: () {
                                controllerFalse.setFunction(TimeInterval.weekly);
                              },
                              child: Text(
                                'W',
                                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                      color: controller.timeInterval == TimeInterval.weekly ? AppColor.stockGreen : AppColor.stockWhite,
                                    ),
                              ),
                            ),
                            SizedBox(width: 24.0),
                            NeoSquareButton(
                              onTap: () {
                                controllerFalse.setFunction(TimeInterval.monthly);
                              },
                              child: Text(
                                'M',
                                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                                      color: controller.timeInterval == TimeInterval.monthly ? AppColor.stockGreen : AppColor.stockWhite,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : NeoSquareButton(
                        onTap: () {
                          if (controller.drawAnnotation == false) {
                            setState(() {
                              showTimeInterval = true;
                            });
                          }
                        },
                        child: Icon(
                          Icons.timeline_outlined,
                          color: AppColor.stockWhite,
                          size: 24.0,
                        ),
                      ),
                showTimeInterval
                    ? NeoSquareButton(
                        onTap: () {
                          setState(() {
                            showTimeInterval = false;
                          });
                        },
                        child: Icon(
                          Icons.edit,
                          color: controller.drawAnnotation ? AppColor.stockOrange : AppColor.stockWhite,
                          size: 24.0,
                        ),
                      )
                    : SizedBox(
                        child: Row(
                          children: [
                            NeoSquareButton(
                              onTap: () {
                                controllerFalse.changeAnnotationState();
                              },
                              child: Icon(
                                Icons.edit,
                                color: controller.drawAnnotation ? AppColor.stockOrange : AppColor.stockWhite,
                                size: 24.0,
                              ),
                            ),
                            SizedBox(width: 24.0),
                            NeoSquareButton(
                              onTap: () {
                                if (controller.annoOffsets.isNotEmpty) {
                                  controllerFalse.clearOffsets();
                                }
                              },
                              child: Icon(
                                Icons.clear,
                                color: controller.annoOffsets.isEmpty ? Colors.white30 : AppColor.stockWhite,
                                size: 24.0,
                              ),
                            ),
                            SizedBox(width: 24.0),
                            NeoSquareButton(
                              onTap: () {
                                controllerFalse.toggleVisibility();
                              },
                              child: Icon(
                                Icons.visibility,
                                color: controller.showAnnotation ? AppColor.stockOrange : AppColor.stockWhite,
                                size: 24.0,
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
            SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }
}
