import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/extensions/side_titles_extension.dart';
import 'package:flutter/widgets.dart';

extension FlTitlesDataExtension on FlTitlesData {
  EdgeInsets allSidesPadding({bool isPaddingForChart = false}) {
    return EdgeInsets.only(
      left: show ? leftTitles.totalReservedSize : 0.0,
      top: show ? topTitles.totalReservedSize : 0.0,
      right: show ? rightTitles.totalReservedSize : 0.0,
      bottom: show
          ? isPaddingForChart && bottomTitles.isAllowOverflow
              ? 0.0
              : bottomTitles.totalReservedSize
          : 0.0,
    );
  }
}
