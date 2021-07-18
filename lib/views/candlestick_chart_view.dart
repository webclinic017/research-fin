import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:researchfin/controller/controller.dart';
import 'package:researchfin/models/stock_symbol_model.dart';

import 'package:researchfin/painter/painter_params.dart';

import '../painter/chart_painter.dart';

class CandlestickChart extends StatefulWidget {
  CandlestickChart({Key? key}) : super(key: key);

  @override
  _CandlestickChartState createState() => _CandlestickChartState();
}

class _CandlestickChartState extends State<CandlestickChart> {
  /*
    DOUBLE _candlestickWidth : width of an individual candlestick.
    DOUBLE _previousCandlestickWidth : Duh!.
    DOUBLE _startOffset : Offset of the data currently being displayed.
    DOUBLE _previousStartOffset: Save the current value of DOUBLE _previousStartOffset before calculating new value.
    OFFSET _tapPosition : Save the tap offset when user taps.
    STOCKSYMBOLMODEL _stockSymbolModel : Save incoming time-interval based stock symbol data.
  */

  late double _candlestickWidth;
  late double _startOffset;
  late double _previousCandlestickWidth;
  late double _previousStartOffset;
  late Offset _initialFocalPoint;
  // late bool isAnnotationEnabled;

  Offset? _tapPosition;

  double? _previousChartWidth;

  StockSymbolModel? stockSymbolModel;

  // List<Offset> _anoteOffsets = [];

  late Controller controller, controllerFalse;

  @override
  Widget build(BuildContext context) {
    stockSymbolModel = Provider.of<Controller>(context).stockSymbolModel;
    controller = Provider.of<Controller>(context);
    controllerFalse = Provider.of<Controller>(context, listen: false);

    if (stockSymbolModel == null) {
      return Center(
        child: Text(
          'No data to display.',
          style: Theme.of(context).textTheme.subtitle1,
        ),
      );
    }

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      final size = constraints.biggest;
      final _timelineAxisWidth = size.width - PainterParams.priceLabelWidth;
      _handleChartResize(_timelineAxisWidth);

      // Find the visible data range
      final int start = (_startOffset / _candlestickWidth).floor();
      final int count = (_timelineAxisWidth / _candlestickWidth).ceil();
      final int end = (start + count).clamp(start, stockSymbolModel!.candlestickData.length);
      final visibleCandlestickRange = stockSymbolModel!.candlestickData.getRange(start, end).toList();
      if (end < stockSymbolModel!.candlestickData.length) {
        final nextItem = stockSymbolModel!.candlestickData[end];
        visibleCandlestickRange.add(nextItem);
      }

      // Find the horizontal shift needed when drawing the candles
      final xShift = _candlestickWidth / 2 - (_startOffset - start * _candlestickWidth);

      // Calculate min and max among the visible data
      final maxPrice = visibleCandlestickRange.map((c) => c.high).whereType<double>().reduce(max);
      final minPrice = visibleCandlestickRange.map((c) => c.low).whereType<double>().reduce(min);
      final maxVol = visibleCandlestickRange.map((c) => c.volume).whereType<double>().reduce(max);
      final minVol = visibleCandlestickRange.map((c) => c.volume).whereType<double>().reduce(min);

      return GestureDetector(
        // Tap and hold to view candle details
        onTapDown: (details) {
          if (controller.drawAnnotation) {
            controllerFalse.addOffset(details.localPosition);
          } else {
            setState(() => _tapPosition = details.localPosition);
          }
        },
        onTapCancel: () => setState(() => _tapPosition = null),
        onTapUp: (_) => setState(() => _tapPosition = null),
        // Pan and zoom
        onScaleStart: (details) {
          if (controller.drawAnnotation) {
            setState(() {
              controllerFalse.addOffset(details.localFocalPoint);
            });
          } else {
            _previousCandlestickWidth = _candlestickWidth;
            _previousStartOffset = _startOffset;
            _initialFocalPoint = details.localFocalPoint;
          }
        },
        onScaleUpdate: (details) => _onScaleUpdate(details, _timelineAxisWidth, controller.drawAnnotation),
        onScaleEnd: (details) {
          if (controller.drawAnnotation) {
            setState(() {
              controllerFalse.addOffset(Offset.infinite);
            });
          }
        },
        child: TweenAnimationBuilder(
          tween: PainterParamsTween(
            end: PainterParams(
              candles: visibleCandlestickRange,
              size: size,
              candleWidth: _candlestickWidth,
              startOffset: _startOffset,
              maxPrice: maxPrice,
              minPrice: minPrice,
              maxVol: maxVol,
              minVol: minVol,
              xShift: xShift,
              tapPosition: _tapPosition,
              // anoteOffsets: _anoteOffsets,
              // isAnnotationEnabled: controller.isAnnotationEnabled,
            ),
          ),
          // duration: Duration.zero,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
          builder: (BuildContext context, PainterParams params, Widget? child) {
            return CustomPaint(
              size: size,
              painter: ChartPainter(params, controller.annoOffsets, controller.drawAnnotation, controller.showAnnotation, controller.getOldOffsets()),
            );
          },
        ),
      );
    });
  }

  // [BLOCK] Chart Size Calculation ----------------------------->|

  /*
    FUNCTION _onScaleUpdate
      Handles the chart panning and zooming.
  */
  _onScaleUpdate(ScaleUpdateDetails details, double width, bool isAnnotationEnabled) {
    if (isAnnotationEnabled) {
      setState(() {
        controllerFalse.addOffset(details.localFocalPoint);
      });
    } else {
      // Handle zoom
      final candleWidth = (_previousCandlestickWidth * details.scale).clamp(_getMaxCandleWidth(width), _getMinCandleWidth(width));
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
      startOffset = startOffset.clamp(
        0,
        _getMaxStartOffset(width, candleWidth),
      );
      // Apply changes
      setState(() {
        _candlestickWidth = candleWidth;
        _startOffset = startOffset;
      });
    }
  }

  /*
    FUNCTION _handleChartResize
      Handles the size of the area where chart is being drawn and adjusts it when size changes.
      Covers 2 conditions.
      1. if DOUBLE _candlestickAxisWidth has changed(DOUBLE _startOffset need to be recalculated when 'Time Interval' is switched.), resize.
      2. if its first build, calculate DOUBLE _candlestickWidth, DOUBLE _startOffset
  */
  _handleChartResize(double width) {
    // if (w == _prevChartWidth) return;
    if (_previousChartWidth != null) {
      // Re-clamp when size changes (e.g. screen rotation)
      _candlestickWidth = _candlestickWidth.clamp(
        _getMaxCandleWidth(width),
        _getMinCandleWidth(width),
      );
      _startOffset = _startOffset.clamp(
        0,
        _getMaxStartOffset(width, _candlestickWidth),
      );

      controllerFalse.updateStartOffset(_startOffset);
    } else {
      // Default 30 day chart. If data is shorter, we use the whole range.
      final count = min(stockSymbolModel!.candlestickData.length, 30);
      _candlestickWidth = width / count;
      // Default show the latest available data, e.g. the most recent 90 days.
      _startOffset = (stockSymbolModel!.candlestickData.length - count) * _candlestickWidth;
      controllerFalse.updateStartOffset(_startOffset);
    }
    _previousChartWidth = width;
  }

  /*
    FUNCTION _getMaxCandleWidth
    FUNCTION _getMinCandleWidth
    FUNCTION _getMaxStartOffset
      Helper functions for FUNCTION _handleChartResize and FUNCTION _onScaleUpdate
  */
  double _getMaxCandleWidth(double width) => width / stockSymbolModel!.candlestickData.length;

  double _getMinCandleWidth(double width) => width / min(14, stockSymbolModel!.candlestickData.length);

  double _getMaxStartOffset(double width, double candleWidth) {
    final count = width / candleWidth; // visible candles in the window
    final start = stockSymbolModel!.candlestickData.length - count;
    return max(0, candleWidth * start);
  }
// Chart Size Calculation [END] ----------------------------->|
}
