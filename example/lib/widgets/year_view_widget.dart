import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class YearViewWidget extends StatelessWidget {
  final GlobalKey<YearViewState>? state;
  final double? width;
  final ValueChanged<DateTime>? onMonthTap;
  final Color? currentMonthBorderColor;
  final Color? otherMonthsBorderColor;
  final Color? todayCircleColor;
  final bool showMonthBorders;
  final bool showCurrentMonthBorder;
  final bool showTodayCircle;
  final Widget? viewSelector;
  final Color? backgroundColor;
  final WeekDays startDay;
  final bool keepAlive;
  final TextAlign yearLabelAlignment;
  final EdgeInsets? yearLabelPadding;
  final TextStyle? yearLabelTextStyle;
  final double yearScrollOffset;

  const YearViewWidget({
    super.key,
    this.state,
    this.width,
    this.onMonthTap,
    this.currentMonthBorderColor,
    this.otherMonthsBorderColor,
    this.todayCircleColor,
    this.showMonthBorders = true,
    this.showCurrentMonthBorder = true,
    this.showTodayCircle = true,
    this.viewSelector,
    this.keepAlive = true,
    this.yearLabelAlignment = TextAlign.center,
    this.yearLabelPadding,
    this.yearLabelTextStyle,
    this.yearScrollOffset = 0.0,
    this.backgroundColor,
    this.startDay = WeekDays.monday,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return YearView(
      key: state,
      backgroundColor: backgroundColor,
      width: width,
      yearLabelAlignment: yearLabelAlignment,
      yearLabelPadding: yearLabelPadding,
      yearLabelTextStyle: yearLabelTextStyle,
      yearScrollOffset: yearScrollOffset,
      showYearLabel: true,
      keepAlive: keepAlive,
      onMonthTap: onMonthTap,
      currentMonthBorderColor: currentMonthBorderColor,
      otherMonthsBorderColor: otherMonthsBorderColor,
      todayCircleColor: todayCircleColor,
      showMonthBorders: showMonthBorders,
      showCurrentMonthBorder: showCurrentMonthBorder,
      showTodayCircle: showTodayCircle,
      startDay: startDay,
      monthNamesOnlyWidthThreshold: yearViewMonthNamesOnlyWidthThreshold,
      headerBuilder: (date) {
        final yearViewState = state?.currentState;
        final minYear = yearViewState?.widget.minYear?.year;
        final maxYear = yearViewState?.widget.maxYear?.year;
        final currentYear = yearViewState?.currentYear ?? date.year;

        return CalendarPageHeader(
          date: DateTime(yearViewState?.currentYear ?? date.year),
          dateStringBuilder: (date, {secondaryDate}) => date.year.toString(),
          headerStyle: HeaderStyle(
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1976D2) : const Color(0xFF2196F3),
            ),
          ),
          onPreviousDay: () {
            final nowYear = yearViewState?.currentYear ?? date.year;
            final targetYear = nowYear - 1;
            if (minYear == null || targetYear >= minYear) {
              yearViewState?.jumpToYear(DateTime(targetYear, 1, 1));
            }
          },
          onNextDay: () {
            final nowYear = yearViewState?.currentYear ?? date.year;
            final targetYear = nowYear + 1;
            if (maxYear == null || targetYear <= maxYear) {
              yearViewState?.jumpToYear(DateTime(targetYear, 1, 1));
            }
          },
          showPreviousIcon: minYear == null || currentYear > minYear,
          showNextIcon: maxYear == null || currentYear < maxYear,
          onTitleTapped: () async {
            yearViewState?.jumpToYear(DateTime.now());
          },
          viewSelector: viewSelector,
        );
      },
    );
  }
}
