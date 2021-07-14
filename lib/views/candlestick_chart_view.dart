import 'dart:math';

import 'package:flutter/material.dart';

class CandlestickChart extends StatefulWidget {
  const CandlestickChart({Key? key}) : super(key: key);

  @override
  _CandlestickChartState createState() => _CandlestickChartState();
}

class _CandlestickChartState extends State<CandlestickChart> {

  late double _candlestickWidth;
  // _candlestickWidth : width of an individual candlestick

  late double _candlestickAxisWidth;
  // _candlestickAreaWidth : width occupied by the candlesticks (excludes the width occupied by priceLabel of stock
  double? _previousCandlestickAxisWidth;
  // _previousCandlestickAxisWidth : previous value of DOUBLE _candlestickAxisWidth.

  late double _selectedDataStartOffset;
  /*
    _selectedDataStartOffset : x offset of the selected data
    for e.g., out of total 180 datapoint, if one chooses to show only recent 90 datapoints,
    this will store the calculated offset for the data ranging from (180 - 90 + 1) to 180 datapoints.
  */

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size drawableArea = constraints.biggest;
        // drawableArea : area available to draw the chart.

        _candlestickAxisWidth = drawableArea.width - priceLabelWidth;

        late double previousCandlestickAxisWidth;
        // _previousCandlestickAxisWidth : store previous value of DOUBLE _candlestickAxisWidth.

        _handleChartResize(_candlestickAxisWidth);

        // Isolating the 90 or less datapoints to be displayed. to create a list
        // Should be done withing controller.
        final int startIndex = totalValues - 90 + 1;
        final int endIndex = totalValues - 1;



        return Container();
      }
    );
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
      _selectedDataStartOffset = _selectedDataStartOffset.clamp(
        0,
        _getMaxSelectedDataStartOffset(width, _candlestickWidth),
      );
    } else {
      // Default 90 datapoints chart. If data is shorter, we use the whole range.
      final count = min(widget.candles.length, 90);
      _candlestickWidth = width / count;
      // Default show the latest available data, e.g. the most recent 90 datapoints.
      _selectedDataStartOffset = (widget.candles.length - count) * _candlestickWidth;
    }
    _previousCandlestickAxisWidth = width;
  }

  /*
    FUNCTION _getMaxCandlestickWidth
    FUNCTION _getMinCandlestickWidth
      Returns the min and max possible values for DOUBLE _candlestickWidth.
      Used by FUNCTION _handleChartResize.
  */
  double _getMaxCandlestickWidth(double width) => width / widget.candles.length;

  double _getMinCandlestickWidth(double width) => width / min(14, widget.candles.length);

  /*
    FUNCTION _getMaxSelectedDataStartOffset
      Calculates DOUBLE _selectedDataStartOffset.
      Used by FUNCTION _handleChartResize.
  */
  double _getMaxSelectedDataStartOffset(double width, double candlestickWidth) {
    final count = width / candlestickWidth; // candlesticks of selected data points in the window
    final start = widget.candles.length - count;
    return max(0, candlestickWidth * start);
  }
// Chart Size Calculation [END] ----------------------------->|
}
