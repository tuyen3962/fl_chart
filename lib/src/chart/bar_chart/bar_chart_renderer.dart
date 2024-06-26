import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/chart/bar_chart/bar_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/base_chart_painter.dart';
import 'package:fl_chart/src/chart/base/base_chart/render_base_chart.dart';
import 'package:fl_chart/src/extensions/side_titles_extension.dart';
import 'package:fl_chart/src/utils/canvas_wrapper.dart';
import 'package:flutter/cupertino.dart';

// coverage:ignore-start

/// Low level BarChart Widget.
class BarChartLeaf extends LeafRenderObjectWidget {
  const BarChartLeaf({
    super.key,
    required this.data,
    required this.targetData,
    this.isDrawBasePaint = true,
    this.isDrawBarChart = true,
  });

  final bool isDrawBasePaint;
  final bool isDrawBarChart;
  final BarChartData data;
  final BarChartData targetData;

  @override
  RenderBarChart createRenderObject(BuildContext context) => RenderBarChart(
        context,
        data,
        targetData,
        MediaQuery.of(context).textScaler,
        isDrawBasePaint,
        isDrawBarChart,
      );

  @override
  void updateRenderObject(BuildContext context, RenderBarChart renderObject) {
    renderObject
      ..data = data
      ..targetData = targetData
      ..textScaler = MediaQuery.of(context).textScaler
      ..buildContext = context;
  }
}
// coverage:ignore-end

/// Renders our BarChart, also handles hitTest.
class RenderBarChart extends RenderBaseChart<BarTouchResponse> {
  RenderBarChart(
    BuildContext context,
    BarChartData data,
    BarChartData targetData,
    TextScaler textScaler,
    this.isDrawBasePaint,
    this.isDrawBarChart,
  )   : _data = data,
        _targetData = targetData,
        _textScaler = textScaler,
        super(targetData.barTouchData, context);

  final bool isDrawBarChart;
  final bool isDrawBasePaint;
  BarChartData get data => _data;
  BarChartData _data;

  set data(BarChartData value) {
    if (_data == value) return;
    _data = value;
    markNeedsPaint();
  }

  BarChartData get targetData => _targetData;
  BarChartData _targetData;

  set targetData(BarChartData value) {
    if (_targetData == value) return;
    _targetData = value;
    super.updateBaseTouchData(_targetData.barTouchData);
    markNeedsPaint();
  }

  TextScaler get textScaler => _textScaler;
  TextScaler _textScaler;

  set textScaler(TextScaler value) {
    if (_textScaler == value) return;
    _textScaler = value;
    markNeedsPaint();
  }

  // We couldn't mock [size] property of this class, that's why we have this
  @visibleForTesting
  Size? mockTestSize;

  @visibleForTesting
  late BarChartPainter painter =
      BarChartPainter(isDrawBasePaint, isDrawBarChart);

  PaintHolder<BarChartData> get paintHolder =>
      PaintHolder(data, targetData, textScaler);

  Size get canvasSize {
    if (!isDrawBarChart) {
      return mockTestSize ?? size;
    }
    final reversize = data.titlesData.bottomTitles.isAllowOverflow
        ? data.titlesData.bottomTitles.totalReservedSize
        : 0;
    final baseSize = mockTestSize ?? size;
    final newSize = Size(baseSize.width, baseSize.height - reversize);
    return newSize;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas
      ..save()
      ..translate(offset.dx, offset.dy);

    painter.paint(
      buildContext,
      CanvasWrapper(canvas, canvasSize),
      paintHolder,
    );
    canvas.restore();
  }

  @override
  BarTouchResponse getResponseAtLocation(Offset localPosition) {
    // final reversize = data.titlesData.bottomTitles.isAllowOverflow
    //     ? data.titlesData.bottomTitles.totalReservedSize
    //     : 0;
    // final position = isDrawBarChart
    //     ? Offset(localPosition.dx, localPosition.dy)
    //     : localPosition;

    final touchedSpot = painter.handleTouch(
      localPosition,
      canvasSize,
      paintHolder,
    );
    return BarTouchResponse(touchedSpot);
  }
}
