import 'package:flutter/material.dart';

import '../config/calendar_form_config.dart';
import '../enumerations.dart';
import '../pages/day_view_page.dart';
import '../pages/month_view_page.dart';
import '../pages/multi_day_view_page.dart';
import '../pages/week_view_page.dart';
import '../theme/app_colors.dart';
import 'day_view_widget.dart';
import 'month_view_widget.dart';
import 'multi_day_view_widget.dart';
import 'week_view_widget.dart';

class CalendarViews extends StatelessWidget {
  final CalendarView view;

  const CalendarViews({super.key, this.view = CalendarView.month});

  @override
  Widget build(BuildContext context) {
    final config = CalendarConfigurationProvider.of(context);
    final availableWidth = MediaQuery.of(context).size.width;
    // Use full available width for all views, same as week view
    final width = availableWidth;
    final minWidthForButtons = 500.0; // Minimum width to show icon buttons
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final selectorStyle = config.viewSelectorConfig.style;
    final activeColor = selectorStyle.activeColor ??
        (isDarkMode ? Colors.lightBlue : Colors.blue);
    final inactiveColor = selectorStyle.inactiveColor ??
        (isDarkMode ? Colors.grey.shade400 : Colors.white);

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
      }
    }

    // Build small icon buttons for view selector
    Route<void> _noAnimationRoute(Widget page) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            child,
      );
    }

    Widget _buildSelectorItem(ViewSelectorItem item) {
      final isActive = view == item.view;
      final color = isActive ? activeColor : inactiveColor;
      final iconWidget = item.image != null
          ? Image(
              image: item.image!,
              width: selectorStyle.iconSize,
              height: selectorStyle.iconSize,
            )
          : Icon(
              item.icon ?? Icons.circle,
              size: selectorStyle.iconSize,
              color: color,
            );
      return Tooltip(
        message: item.label ?? item.view.name,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: !isActive
                ? () {
                    Navigator.of(context)
                        .pushReplacement(_noAnimationRoute(_pageForView(item.view)));
                  }
                : null,
            child: Padding(
                padding: selectorStyle.buttonPadding,
              child: iconWidget,
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
                    for (int i = 0;
                        i < config.viewSelectorConfig.items.length;
                        i++) ...[
                      _buildSelectorItem(config.viewSelectorConfig.items[i]),
                      if (i != config.viewSelectorConfig.items.length - 1)
                        SizedBox(width: selectorStyle.spacing),
                    ],
                  ],
                ),
              )
            : (config.showViewSelectorMenu
                ? PopupMenuButton<CalendarView>(
                    padding: EdgeInsets.zero,
                    onSelected: (selectedView) {
                      Navigator.of(context).pushReplacement(
                        _noAnimationRoute(_pageForView(selectedView)),
                      );
                    },
                    itemBuilder: (BuildContext context) => [
                      for (final item
                          in config.viewSelectorConfig.items)
                        PopupMenuItem<CalendarView>(
                          value: item.view,
                          child: Text(item.label ?? item.view.name),
                        ),
                    ],
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                  )
                : SizedBox.shrink()))
        : (config.showViewSelectorMenu
            ? PopupMenuButton<CalendarView>(
                padding: EdgeInsets.zero,
                onSelected: (selectedView) {
                  Navigator.of(context).pushReplacement(
                    _noAnimationRoute(_pageForView(selectedView)),
                  );
                },
                itemBuilder: (BuildContext context) => [
                  for (final item in config.viewSelectorConfig.items)
                    PopupMenuItem<CalendarView>(
                      value: item.view,
                      child: Text(item.label ?? item.view.name),
                    ),
                ],
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              )
            : SizedBox.shrink());

    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          color: AppColors.grey,
          child: Center(
            child: view == CalendarView.month
              ? MonthViewWidget(width: width)
              : view == CalendarView.day
                ? DayViewWidget(width: width)
                : view == CalendarView.threeDays
                  ? MultiDayViewWidget(width: width)
                  : WeekViewWidget(width: width),
          ),
        ),
        if (config.showViewSelector)
          Positioned(
            right: 8,
            child: IgnorePointer(
              ignoring: false,
              child: Padding(
                padding: EdgeInsets.only(right: 20, top: 5),
                child: viewSelectorWidget,
              ),
            ),
          ),
      ],
    );
  }
}
