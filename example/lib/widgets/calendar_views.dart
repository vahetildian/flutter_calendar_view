import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../config/calendar_form_config.dart';
import '../enumerations.dart';
import '../main.dart';
import '../pages/day_view_page.dart';
import '../pages/month_view_page.dart';
import '../pages/multi_day_view_page.dart';
import '../pages/week_view_page.dart';
import '../pages/year_view_page.dart';
import '../theme/app_colors.dart';
import 'day_view_widget.dart';
import 'month_view_widget.dart';
import 'multi_day_view_widget.dart';
import 'week_view_widget.dart';
import 'year_view_widget.dart';

class CalendarViews extends StatefulWidget {
  final CalendarView view;
  final void Function(CalendarView)? onViewSelected;
  final bool cacheViews;

  const CalendarViews({super.key, this.view = CalendarView.month, this.onViewSelected, this.cacheViews = false});

  @override
  State<CalendarViews> createState() => _CalendarViewsState();
}

class _CalendarViewsState extends State<CalendarViews> {
  static DateTime? _targetMonthDate;
  static DateTime? _targetMultiDayDate;

  final GlobalKey<DayViewState> _dayViewKey = GlobalKey<DayViewState>();
  final GlobalKey<WeekViewState> _weekViewKey = GlobalKey<WeekViewState>();
  final GlobalKey<MultiDayViewState> _multiDayViewKey = GlobalKey<MultiDayViewState>();
  final GlobalKey<MonthViewState> _monthViewKey = GlobalKey<MonthViewState>();
  final GlobalKey<YearViewState> _yearViewKey = GlobalKey<YearViewState>();

  void _jumpToToday() {
    final now = DateTime.now();
    switch (widget.view) {
      case CalendarView.day:
        _dayViewKey.currentState?.jumpToDate(now);
        break;
      case CalendarView.week:
        _weekViewKey.currentState?.jumpToWeek(now);
        break;
      case CalendarView.threeDays:
        _multiDayViewKey.currentState?.jumpToWeek(now);
        break;
      case CalendarView.month:
        _monthViewKey.currentState?.jumpToMonth(now);
        break;
      case CalendarView.year:
        _yearViewKey.currentState?.jumpToMonth(now);
        break;
    }
  }

  void _onMonthTapFromYearView(DateTime date) {
    // Store the target date
    _targetMonthDate = date;

    // Navigate to month view page
    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => MonthViewPageDemo(), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero, transitionsBuilder: (context, animation, secondaryAnimation, child) => child)).then((_) {
      // Clear the target date after navigation
      _targetMonthDate = null;
    });
  }

  void _onDayTapFromMonthView(DateTime date) {
    // Store the target date, but subtract 1 day so the clicked day appears in the middle
    // of the multi-day view (assuming 3 days: day1, clickedDay, day3)
    _targetMultiDayDate = date.subtract(const Duration(days: 1));

    // Navigate to multiday view page
    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => MultiDayViewDemo(), transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero, transitionsBuilder: (context, animation, secondaryAnimation, child) => child)).then((_) {
      // Clear the target date after navigation
      _targetMultiDayDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if we need to jump to a specific month
    if (_targetMonthDate != null && widget.view == CalendarView.month) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_targetMonthDate != null) {
          _monthViewKey.currentState?.jumpToMonth(_targetMonthDate!);
        }
      });
    }

    // Check if we need to jump to a specific day in multiday view
    if (_targetMultiDayDate != null && widget.view == CalendarView.threeDays) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_targetMultiDayDate != null) {
          _multiDayViewKey.currentState?.jumpToWeek(_targetMultiDayDate!);
        }
      });
    }

    final config = CalendarConfigurationProvider.of(context);
    final availableWidth = MediaQuery.of(context).size.width;
    // Use full available width for all views, same as week view
    final width = availableWidth;
    final minWidthForButtons = minWidthForViewSelectorButtons; // From main.dart
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final selectorStyle = config.viewSelectorConfig.style;
    final activeColor = selectorStyle.activeColor ?? (isDarkMode ? Colors.lightBlue : Colors.blue);
    final inactiveColor = selectorStyle.inactiveColor ?? (isDarkMode ? Colors.grey.shade400 : Colors.white);

    Widget _pageForView(CalendarView view) {
      switch (view) {
        case CalendarView.day:
          return DayViewPageDemo();
        case CalendarView.week:
          return WeekViewDemo();
        case CalendarView.threeDays:
          return MultiDayViewDemo();
        case CalendarView.month:
          return MonthViewPageDemo();
        case CalendarView.year:
          return YearViewDemo();
      }
    }

    // Build small icon buttons for view selector
    Route<void> _noAnimationRoute(Widget page) {
      return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => page, transitionDuration: Duration.zero, reverseTransitionDuration: Duration.zero, transitionsBuilder: (context, animation, secondaryAnimation, child) => child);
    }

    Widget _buildSelectorItem(ViewSelectorItem item) {
      final isActive = widget.view == item.view;
      final color = isActive ? activeColor : inactiveColor;
      final iconWidget = item.image != null
          ? Image(image: item.image!, width: selectorStyle.iconSize, height: selectorStyle.iconSize)
          : Icon(item.icon ?? Icons.circle, size: selectorStyle.iconSize, color: color);

      return Tooltip(
        message: item.label ?? item.view.name,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: !isActive
                ? () {
                    if (widget.onViewSelected != null) {
                      widget.onViewSelected!(item.view);
                    } else {
                      Navigator.of(context).push(_noAnimationRoute(_pageForView(item.view)));
                    }
                  }
                : null,
            child: Padding(padding: selectorStyle.buttonPadding, child: iconWidget),
          ),
        ),
      );
    }

    Widget _buildTodayButton() {
      final color = activeColor;
      return Tooltip(
        message: 'Today',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _jumpToToday,
            child: Padding(
              padding: selectorStyle.buttonPadding,
              child: Icon(Icons.today, size: selectorStyle.iconSize, color: color),
            ),
          ),
        ),
      );
    }

    final viewSelectorWidget = availableWidth > minWidthForButtons
        ? (config.showViewSelectorIcons
              ? Padding(
                  padding: selectorStyle.padding,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (selectorStyle.showTodayButton && selectorStyle.todayButtonPosition == TodayButtonPosition.left) ...[_buildTodayButton(), if (config.viewSelectorConfig.items.isNotEmpty) SizedBox(width: selectorStyle.spacing)],
                      for (int i = 0; i < config.viewSelectorConfig.items.length; i++) ...[_buildSelectorItem(config.viewSelectorConfig.items[i]), if (i != config.viewSelectorConfig.items.length - 1) SizedBox(width: selectorStyle.spacing)],
                      if (selectorStyle.showTodayButton && selectorStyle.todayButtonPosition == TodayButtonPosition.right) ...[if (config.viewSelectorConfig.items.isNotEmpty) SizedBox(width: selectorStyle.spacing), _buildTodayButton()],
                    ],
                  ),
                )
              : (config.showViewSelectorMenu
                    ? PopupMenuButton<CalendarView>(
                        padding: EdgeInsets.zero,
                        onSelected: (selectedView) {
                          if (widget.onViewSelected != null) {
                            widget.onViewSelected!(selectedView);
                          } else {
                            Navigator.of(context).push(_noAnimationRoute(_pageForView(selectedView)));
                          }
                        },
                        itemBuilder: (BuildContext context) => [for (final item in config.viewSelectorConfig.items) PopupMenuItem<CalendarView>(value: item.view, child: Text(item.label ?? item.view.name))],
                        icon: Icon(Icons.menu, color: Colors.white),
                      )
                    : SizedBox.shrink()))
        : (config.showViewSelectorMenu
              ? PopupMenuButton<CalendarView>(
                  padding: EdgeInsets.zero,
                  onSelected: (selectedView) {
                    if (widget.onViewSelected != null) {
                      widget.onViewSelected!(selectedView);
                    } else {
                      Navigator.of(context).push(_noAnimationRoute(_pageForView(selectedView)));
                    }
                  },
                  itemBuilder: (BuildContext context) => [for (final item in config.viewSelectorConfig.items) PopupMenuItem<CalendarView>(value: item.view, child: Text(item.label ?? item.view.name))],
                  icon: Icon(Icons.menu, color: Colors.white),
                )
              : SizedBox.shrink());

    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          color: AppColors.grey,
          child: Center(
            child: widget.cacheViews
                ? IndexedStack(
                    index: [CalendarView.day, CalendarView.threeDays, CalendarView.week, CalendarView.month, CalendarView.year].indexOf(widget.view),
                    children: [
                      DayViewWidget(state: _dayViewKey, width: width, viewSelector: config.showViewSelector ? viewSelectorWidget : null),
                      MultiDayViewWidget(state: _multiDayViewKey, width: width, viewSelector: config.showViewSelector ? viewSelectorWidget : null),
                      WeekViewWidget(state: _weekViewKey, width: width, viewSelector: config.showViewSelector ? viewSelectorWidget : null),
                      MonthViewWidget(state: _monthViewKey, width: width, onDayTap: _onDayTapFromMonthView, viewSelector: config.showViewSelector ? viewSelectorWidget : null),
                      YearViewWidget(state: _yearViewKey, width: width, onMonthTap: _onMonthTapFromYearView, currentMonthBorderColor: yearCurrentMonthBorderColor, otherMonthsBorderColor: yearOtherMonthsBorderColor, todayCircleColor: yearTodayCircleColor, showMonthBorders: yearShowMonthBorders, showCurrentMonthBorder: yearShowCurrentMonthBorder, showTodayCircle: yearShowTodayCircle, viewSelector: config.showViewSelector ? viewSelectorWidget : null, startDay: yearStartDay, yearLabelAlignment: yearLabelAlignment, yearLabelPadding: yearLabelPadding, yearLabelTextStyle: yearLabelTextStyle, yearScrollOffset: yearScrollOffset, backgroundColor: yearBackgroundColor),
                    ],
                  )
                : (widget.view == CalendarView.month
                    ? MonthViewWidget(state: _monthViewKey, width: width, onDayTap: _onDayTapFromMonthView, viewSelector: config.showViewSelector ? viewSelectorWidget : null)
                    : widget.view == CalendarView.day
                        ? DayViewWidget(state: _dayViewKey, width: width, viewSelector: config.showViewSelector ? viewSelectorWidget : null)
                        : widget.view == CalendarView.threeDays
                            ? MultiDayViewWidget(state: _multiDayViewKey, width: width, viewSelector: config.showViewSelector ? viewSelectorWidget : null)
                            : widget.view == CalendarView.year
                                      ? YearViewWidget(state: _yearViewKey, width: width, onMonthTap: _onMonthTapFromYearView, currentMonthBorderColor: yearCurrentMonthBorderColor, otherMonthsBorderColor: yearOtherMonthsBorderColor, todayCircleColor: yearTodayCircleColor, showMonthBorders: yearShowMonthBorders, showCurrentMonthBorder: yearShowCurrentMonthBorder, showTodayCircle: yearShowTodayCircle, viewSelector: config.showViewSelector ? viewSelectorWidget : null, startDay: yearStartDay, yearLabelAlignment: yearLabelAlignment, yearLabelPadding: yearLabelPadding, yearLabelTextStyle: yearLabelTextStyle, yearScrollOffset: yearScrollOffset, backgroundColor: yearBackgroundColor)
                                : WeekViewWidget(state: _weekViewKey, width: width, viewSelector: config.showViewSelector ? viewSelectorWidget : null)),
          ),
        ),
      ],
    );
  }
}
