import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../enumerations.dart';
import '../extension.dart';
import '../format_settings.dart';

class CalendarConfiguration {
  final bool isDescriptionRequired;
  final bool isDarkMode;
  final bool showViewSelector;
  final bool showViewSelectorIcons;
  final bool showViewSelectorMenu;
  final ViewSelectorConfig viewSelectorConfig;
  final bool showAddEventFab;
  final bool showSettingsFab;
  final bool stickyTimeSlot;
  final CalendarViewType initialView;
  final String initialLocale;
  final DateStampFormat dateFormat;
  final TimeStampFormat timeFormat;
  final Timezone timezone;
  final DayViewColors? dayViewColors;
  final WeekViewColors? weekViewColors;
  final MonthViewColors? monthViewColors;
  final MultiDayViewColors? multiDayViewColors;

  const CalendarConfiguration({
    this.isDescriptionRequired = false,
    this.isDarkMode = false,
    this.showViewSelector = true,
    this.showViewSelectorIcons = true,
    this.showViewSelectorMenu = true,
    this.viewSelectorConfig = const ViewSelectorConfig(),
    this.showAddEventFab = true,
    this.showSettingsFab = true,
    this.stickyTimeSlot = true,
    this.initialView = CalendarViewType.week,
    this.initialLocale = 'en',
    this.dateFormat = DateStampFormat.month_name_day_year_long,
    this.timeFormat = TimeStampFormat.parse_12,
    this.timezone = const Timezone(
      name: 'UTC',
      offsetHours: 0,
      displayName: 'UTC',
    ),
    this.dayViewColors,
    this.weekViewColors,
    this.monthViewColors,
    this.multiDayViewColors,
  });
}

class ViewSelectorItem {
  final CalendarView view;
  final IconData? icon;
  final ImageProvider? image;
  final String? label;

  const ViewSelectorItem({
    required this.view,
    this.icon,
    this.image,
    this.label,
  });
}

class ViewSelectorStyle {
  final double iconSize;
  final double spacing;
  final EdgeInsets buttonPadding;
  final EdgeInsets padding;
  final Color? activeColor;
  final Color? inactiveColor;

  const ViewSelectorStyle({
    this.iconSize = 18,
    this.spacing = 4,
    this.buttonPadding = const EdgeInsets.all(4),
    this.padding = const EdgeInsets.only(top: 6),
    this.activeColor,
    this.inactiveColor,
  });
}

class ViewSelectorConfig {
  final List<ViewSelectorItem> items;
  final ViewSelectorStyle style;

  const ViewSelectorConfig({
    this.items = const [
      ViewSelectorItem(
        view: CalendarView.day,
        icon: Icons.view_day,
        label: 'Day View',
      ),
      ViewSelectorItem(
        view: CalendarView.week,
        icon: Icons.view_week,
        label: 'Week View',
      ),
      ViewSelectorItem(
        view: CalendarView.threeDays,
        icon: Icons.view_carousel,
        label: 'Multi-Day View',
      ),
      ViewSelectorItem(
        view: CalendarView.month,
        icon: Icons.calendar_month,
        label: 'Month View',
      ),
    ],
    this.style = const ViewSelectorStyle(),
  });
}

class DayViewColors {
  final Color? hourLineColor;
  final Color? halfHourLineColor;
  final Color? quarterHourLineColor;
  final Color? pageBackgroundColor;
  final Color? liveIndicatorColor;
  final Color? headerIconColor;
  final Color? headerTextColor;
  final Color? headerBackgroundColor;
  final Color? timelineTextColor;

  const DayViewColors({
    this.hourLineColor,
    this.halfHourLineColor,
    this.quarterHourLineColor,
    this.pageBackgroundColor,
    this.liveIndicatorColor,
    this.headerIconColor,
    this.headerTextColor,
    this.headerBackgroundColor,
    this.timelineTextColor,
  });

  DayViewThemeData apply(DayViewThemeData base) {
    return base.copyWith(
      hourLineColor: hourLineColor,
      halfHourLineColor: halfHourLineColor,
      quarterHourLineColor: quarterHourLineColor,
      pageBackgroundColor: pageBackgroundColor,
      liveIndicatorColor: liveIndicatorColor,
      headerIconColor: headerIconColor,
      headerTextColor: headerTextColor,
      headerBackgroundColor: headerBackgroundColor,
      timelineTextColor: timelineTextColor,
    ) as DayViewThemeData;
  }
}

class WeekViewColors {
  final Color? weekDayTileColor;
  final Color? weekDayTextColor;
  final Color? hourLineColor;
  final Color? halfHourLineColor;
  final Color? quarterHourLineColor;
  final Color? liveIndicatorColor;
  final Color? pageBackgroundColor;
  final Color? headerIconColor;
  final Color? headerTextColor;
  final Color? headerBackgroundColor;
  final Color? timelineTextColor;
  final Color? borderColor;
  final Color? verticalLinesColor;

  const WeekViewColors({
    this.weekDayTileColor,
    this.weekDayTextColor,
    this.hourLineColor,
    this.halfHourLineColor,
    this.quarterHourLineColor,
    this.liveIndicatorColor,
    this.pageBackgroundColor,
    this.headerIconColor,
    this.headerTextColor,
    this.headerBackgroundColor,
    this.timelineTextColor,
    this.borderColor,
    this.verticalLinesColor,
  });

  WeekViewThemeData apply(WeekViewThemeData base) {
    return base.copyWith(
      weekDayTileColor: weekDayTileColor,
      weekDayTextColor: weekDayTextColor,
      hourLineColor: hourLineColor,
      halfHourLineColor: halfHourLineColor,
      quarterHourLineColor: quarterHourLineColor,
      liveIndicatorColor: liveIndicatorColor,
      pageBackgroundColor: pageBackgroundColor,
      headerIconColor: headerIconColor,
      headerTextColor: headerTextColor,
      headerBackgroundColor: headerBackgroundColor,
      timelineTextColor: timelineTextColor,
      borderColor: borderColor,
      verticalLinesColor: verticalLinesColor,
    ) as WeekViewThemeData;
  }
}

class MonthViewColors {
  final Color? cellInMonthColor;
  final Color? cellNotInMonthColor;
  final Color? cellTextColor;
  final Color? cellBorderColor;
  final Color? weekDayTileColor;
  final Color? weekDayTextColor;
  final Color? weekDayBorderColor;
  final Color? headerIconColor;
  final Color? headerTextColor;
  final Color? headerBackgroundColor;
  final Color? cellHighlightColor;

  const MonthViewColors({
    this.cellInMonthColor,
    this.cellNotInMonthColor,
    this.cellTextColor,
    this.cellBorderColor,
    this.weekDayTileColor,
    this.weekDayTextColor,
    this.weekDayBorderColor,
    this.headerIconColor,
    this.headerTextColor,
    this.headerBackgroundColor,
    this.cellHighlightColor,
  });

  MonthViewThemeData apply(MonthViewThemeData base) {
    return base.copyWith(
      cellInMonthColor: cellInMonthColor,
      cellNotInMonthColor: cellNotInMonthColor,
      cellTextColor: cellTextColor,
      cellBorderColor: cellBorderColor,
      weekDayTileColor: weekDayTileColor,
      weekDayTextColor: weekDayTextColor,
      weekDayBorderColor: weekDayBorderColor,
      headerIconColor: headerIconColor,
      headerTextColor: headerTextColor,
      headerBackgroundColor: headerBackgroundColor,
      highlightColor: cellHighlightColor,
    ) as MonthViewThemeData;
  }
}

class MultiDayViewColors {
  final Color? multiDayTileColor;
  final Color? multiDayTextColor;
  final Color? hourLineColor;
  final Color? halfHourLineColor;
  final Color? quarterHourLineColor;
  final Color? liveIndicatorColor;
  final Color? pageBackgroundColor;
  final Color? headerIconColor;
  final Color? headerTextColor;
  final Color? headerBackgroundColor;
  final Color? timelineTextColor;
  final Color? borderColor;
  final Color? verticalLinesColor;

  const MultiDayViewColors({
    this.multiDayTileColor,
    this.multiDayTextColor,
    this.hourLineColor,
    this.halfHourLineColor,
    this.quarterHourLineColor,
    this.liveIndicatorColor,
    this.pageBackgroundColor,
    this.headerIconColor,
    this.headerTextColor,
    this.headerBackgroundColor,
    this.timelineTextColor,
    this.borderColor,
    this.verticalLinesColor,
  });

  MultiDayViewThemeData apply(MultiDayViewThemeData base) {
    return base.copyWith(
      multiDayTileColor: multiDayTileColor,
      multiDayTextColor: multiDayTextColor,
      hourLineColor: hourLineColor,
      halfHourLineColor: halfHourLineColor,
      quarterHourLineColor: quarterHourLineColor,
      liveIndicatorColor: liveIndicatorColor,
      pageBackgroundColor: pageBackgroundColor,
      headerIconColor: headerIconColor,
      headerTextColor: headerTextColor,
      headerBackgroundColor: headerBackgroundColor,
      timelineTextColor: timelineTextColor,
      borderColor: borderColor,
      verticalLinesColor: verticalLinesColor,
    ) as MultiDayViewThemeData;
  }
}

class CalendarConfigurationProvider extends InheritedWidget {
  final CalendarConfiguration configuration;

  const CalendarConfigurationProvider({
    required this.configuration,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  static CalendarConfiguration of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<
        CalendarConfigurationProvider>();
    if (provider == null) {
      return const CalendarConfiguration();
    }
    return provider.configuration;
  }

  @override
  bool updateShouldNotify(CalendarConfigurationProvider oldWidget) {
    return configuration.isDescriptionRequired !=
            oldWidget.configuration.isDescriptionRequired ||
        configuration.isDarkMode != oldWidget.configuration.isDarkMode ||
        configuration.showViewSelector !=
            oldWidget.configuration.showViewSelector ||
      configuration.showViewSelectorIcons !=
        oldWidget.configuration.showViewSelectorIcons ||
      configuration.showViewSelectorMenu !=
        oldWidget.configuration.showViewSelectorMenu ||
      configuration.viewSelectorConfig !=
        oldWidget.configuration.viewSelectorConfig ||
      configuration.showAddEventFab !=
        oldWidget.configuration.showAddEventFab ||
      configuration.showSettingsFab !=
        oldWidget.configuration.showSettingsFab ||
      configuration.stickyTimeSlot !=
        oldWidget.configuration.stickyTimeSlot ||
      configuration.initialView != oldWidget.configuration.initialView ||
      configuration.initialLocale !=
        oldWidget.configuration.initialLocale ||
      configuration.dateFormat != oldWidget.configuration.dateFormat ||
      configuration.timeFormat != oldWidget.configuration.timeFormat ||
      configuration.timezone != oldWidget.configuration.timezone ||
      configuration.dayViewColors != oldWidget.configuration.dayViewColors ||
      configuration.weekViewColors != oldWidget.configuration.weekViewColors ||
      configuration.monthViewColors !=
        oldWidget.configuration.monthViewColors ||
      configuration.multiDayViewColors !=
        oldWidget.configuration.multiDayViewColors;
  }
}

