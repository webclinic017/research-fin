import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:researchfin/controller/controller.dart';
import 'package:researchfin/models/stock_symbol_model.dart';

import 'package:researchfin/painter_params.dart';

import '../chart_painter.dart';

class CandlestickChart extends StatefulWidget {
  CandlestickChart({Key? key}) : super(key: key);

  @override
  _CandlestickChartState createState() => _CandlestickChartState();
}

class _CandlestickChartState extends State<CandlestickChart> {
  late double _candlestickWidth;
  // _candlestickWidth : width of an individual candlestick
  late double _previousCandlestickWidth;

  late double _candlestickAxisWidth;
  // _candlestickAreaWidth : width occupied by the candlesticks (excludes the width occupied by priceLabel of stock
  double? _previousCandlestickAxisWidth;
  // _previousCandlestickAxisWidth : previous value of DOUBLE _candlestickAxisWidth.

  late double _startOffset;
  /*
    _startOffset : x offset of the selected data
    for e.g., out of total 180 datapoint, if one chooses to show only recent 90 datapoints,
    this will store the calculated offset for the data ranging from (180 - 90 + 1) to 180 datapoints.
  */
  late double _previousStartOffset;

  // The position that user is currently tapping, null if user let go.
  Offset? _tapPosition;

  late Offset _initialFocalPoint;

  StockSymbolModel? stockSymbolModel;
  @override
  Widget build(BuildContext context) {
    stockSymbolModel = Provider.of<Controller>(context).stockSymbolModel;

    if (stockSymbolModel == null) {
      return Center(
        child: Text(
          'No data to display.',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      );
    }

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final Size drawableArea = constraints.biggest;
      // drawableArea : area available to draw the chart.

      _candlestickAxisWidth = drawableArea.width - PainterParams.priceLabelWidth;
      // _candlestickAxisWidth = drawableArea.width;

      // late double previousCandlestickAxisWidth;
      // // _previousCandlestickAxisWidth : store previous value of DOUBLE _candlestickAxisWidth.

      _handleChartResize(_candlestickAxisWidth);

      // Isolating the 90 or less data points to be displayed. to create a list
      // Should be done withing controller.
      // final int startIndex = totalValues - 90 + 1;
      // final int endIndex = totalValues - 1;

      final double xShift = _candlestickWidth / 2;

      // Calculate the min and max for price and volume
      final maxPrice = stockSymbolModel!.candlestickData.map((c) => c.high).whereType<double>().reduce(max);
      final minPrice = stockSymbolModel!.candlestickData.map((c) => c.low).whereType<double>().reduce(min);

      final maxVol = stockSymbolModel!.candlestickData.map((c) => c.volume).whereType<double>().reduce(max);
      final minVol = stockSymbolModel!.candlestickData.map((c) => c.volume).whereType<double>().reduce(min);

      return GestureDetector(
        // Tap and hold to view candle details
        onTapDown: (tapDownDetails) {
          setState(() => _tapPosition = tapDownDetails.localPosition);
        },
        onTapCancel: () => setState(() => _tapPosition = null),
        onTapUp: (_) => setState(() => _tapPosition = null),
        // Pan and zoom
        onScaleStart: (details) {
          _previousCandlestickWidth = _candlestickWidth;
          _previousStartOffset = _startOffset;
          _initialFocalPoint = details.localFocalPoint;
        },
        onScaleUpdate: (details) => _onScaleUpdate(details, _candlestickAxisWidth),
        child: TweenAnimationBuilder(
          tween: PainterParamsTween(
            end: PainterParams(
              candles: stockSymbolModel!.candlestickData,
              size: drawableArea,
              candleWidth: _candlestickWidth,
              startOffset: _startOffset,
              maxPrice: maxPrice,
              minPrice: minPrice,
              maxVol: maxVol,
              minVol: minVol,
              xShift: xShift,
              tapPosition: _tapPosition,
              // maLeading: maLeading,
              // maTrailing: maTrailing,
            ),
          ),
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
          builder:
              (BuildContext context, PainterParams params, Widget? child) {
            return CustomPaint(
              size: drawableArea,
              painter: ChartPainter(params),
            );
          },
        ),
      );
    });
  }

  // [BLOCK] Chart Size Calculation ----------------------------->|

  /*
    FUNCTION _handleChartResize
      Handles the size of the area where chart is being drawn and adjusts it when size changes.
      Covers 3 conditions.
      1. if DOUBLE _candlestickAxisWidth is unchanged, do nothing.
      2. if DOUBLE _candlestickAxisWidth has changed, resize.
      3. if its first build, calculate DOUBLE _candlestickWidth, DOUBLE _selectedDataStartOffset
  */
  _handleChartResize(double width) {
    // Size is unchanged.
    if (width == _previousCandlestickAxisWidth) return;
    if (_previousCandlestickAxisWidth != null) {
      // Re-clamp when size changes (e.g. screen rotation)
      _candlestickWidth = _candlestickWidth.clamp(
        _getMaxCandlestickWidth(width),
        _getMinCandlestickWidth(width),
      );
      _startOffset = _startOffset.clamp(0, _getMaxStartOffset(width, _candlestickWidth));
    } else {
      // Default 90 datapoints chart. If data is shorter, we use the whole range.
      final count = min(stockSymbolModel!.candlestickData.length, 90);
      _candlestickWidth = width / count;
      // Default show the latest available data, e.g. the most recent 90 datapoints.
      _startOffset = (stockSymbolModel!.candlestickData.length - count) * _candlestickWidth;
    }
    _previousCandlestickAxisWidth = width;
  }

  /*
    FUNCTION _getMaxCandlestickWidth
    FUNCTION _getMinCandlestickWidth
      Returns the min and max possible values for DOUBLE _candlestickWidth.
      Used by FUNCTION _handleChartResize.
  */
  double _getMaxCandlestickWidth(double width) => width / stockSymbolModel!.candlestickData.length;

  double _getMinCandlestickWidth(double width) => width / min(14, stockSymbolModel!.candlestickData.length);

  /*
    FUNCTION _getMaxSelectedDataStartOffset
      Calculates DOUBLE _selectedDataStartOffset.
      Used by FUNCTION _handleChartResize.
  */
  double _getMaxStartOffset(double width, double candlestickWidth) {
    final count = width / candlestickWidth; // candlesticks of selected data points in the window
    final start = stockSymbolModel!.candlestickData.length - count;
    return max(0, candlestickWidth * start);
  }

  /*
    FUNCTION _onScaleUpdate
  */
  _onScaleUpdate(details, double width) {
    // Handle zoom
    final candleWidth = (_previousCandlestickWidth * details.scale).clamp(_getMaxCandlestickWidth(width), _getMinCandlestickWidth(width));
    final clampedScale = candleWidth / _previousCandlestickWidth;
    var startOffset = _previousStartOffset * clampedScale;
    // Handle pan
    final dx = (details.localFocalPoint - _initialFocalPoint).dx * -1;
    startOffset += dx;
    // Adjust pan when zooming
    final focalPointFactor = details.localFocalPoint.dx / width;
    final double prevCount = width / _previousCandlestickWidth;
    final double currCount = width / _candlestickWidth;
    final zoomAdjustment = (currCount - prevCount) * _candlestickWidth;
    startOffset -= zoomAdjustment * focalPointFactor;
    startOffset = startOffset.clamp(0, _getMaxStartOffset(width, candleWidth)) as double;
    // Apply changes
    setState(() {
      _candlestickWidth = candleWidth;
      _startOffset = startOffset;
    });
  }
// Chart Size Calculation [END] ----------------------------->|
}
