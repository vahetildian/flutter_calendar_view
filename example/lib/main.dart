import 'dart:ui';

import 'package:calendar_view/calendar_view.dart';
import 'package:example/config/calendar_form_config.dart';
import 'package:example/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'enumerations.dart';
import 'extension.dart';
import 'format_settings.dart';
import 'l10n/app_localizations.dart';
import 'localization/calendar_locales.dart';
import 'localization/locale_controller.dart';
import 'pages/home_page.dart';
import 'theme/app_colors.dart';
import 'theme/dark_app_colors.dart';

// Configure these parameters to control the calendar behavior
const bool defaultIsDarkMode = false;

// View selector colors
final Color viewSelectorActiveColor =
  defaultIsDarkMode ? DarkAppColors.primary : AppColors.primary;
final Color viewSelectorInactiveColor = defaultIsDarkMode
  ? DarkAppColors.outlineVariant
  : AppColors.outlineVariant;

// Day view colors
final Color dayHourLineColor =
  defaultIsDarkMode ? DarkAppColors.outlineVariant : AppColors.outlineVariant;
final Color dayHalfHourLineColor = dayHourLineColor;
final Color dayQuarterHourLineColor = dayHourLineColor;
final Color dayPageBackgroundColor =
  defaultIsDarkMode ? Colors.black : AppColors.white;
final Color dayLiveIndicatorColor =
  defaultIsDarkMode ? DarkAppColors.primary : AppColors.primary;
final Color dayHeaderIconColor =
  defaultIsDarkMode ? DarkAppColors.onPrimary : AppColors.onPrimary;
final Color dayHeaderTextColor = dayHeaderIconColor;
final Color dayHeaderBackgroundColor =
  defaultIsDarkMode ? DarkAppColors.primary : AppColors.primary;
final Color dayTimelineTextColor =
  defaultIsDarkMode ? Colors.white : AppColors.black;

// Week view colors
final Color weekDayTileColor = defaultIsDarkMode
  ? DarkAppColors.outlineVariant
  : AppColors.bluishGrey;
final Color weekDayTextColor =
  defaultIsDarkMode ? Colors.white : AppColors.black;
final Color weekHourLineColor =
  defaultIsDarkMode ? DarkAppColors.outlineVariant : AppColors.outlineVariant;
final Color weekHalfHourLineColor = weekHourLineColor;
final Color weekQuarterHourLineColor = weekHourLineColor;
final Color weekLiveIndicatorColor =
  defaultIsDarkMode ? DarkAppColors.primary : AppColors.primary;
final Color weekPageBackgroundColor =
  defaultIsDarkMode ? Colors.black : AppColors.white;
final Color weekHeaderIconColor =
  defaultIsDarkMode ? DarkAppColors.onPrimary : AppColors.onPrimary;
final Color weekHeaderTextColor = weekHeaderIconColor;
final Color weekHeaderBackgroundColor =
  defaultIsDarkMode ? DarkAppColors.primary : AppColors.primary;
final Color weekTimelineTextColor = weekDayTextColor;
final Color weekBorderColor = weekHourLineColor;
final Color weekVerticalLinesColor = weekHourLineColor;

// Month view colors
final Color monthCellInMonthColor =
  defaultIsDarkMode ? Colors.black : AppColors.white;
final Color monthCellNotInMonthColor = defaultIsDarkMode
  ? DarkAppColors.outlineVariant
  : AppColors.grey;
final Color monthCellTextColor =
  defaultIsDarkMode ? Colors.white : AppColors.black;
final Color monthCellBorderColor =
  defaultIsDarkMode ? DarkAppColors.outlineVariant : AppColors.outlineVariant;
final Color monthWeekDayTileColor = weekDayTileColor;
final Color monthWeekDayTextColor = weekDayTextColor;
final Color monthWeekDayBorderColor = monthCellBorderColor;
final Color monthHeaderIconColor = weekHeaderIconColor;
final Color monthHeaderTextColor = weekHeaderTextColor;
final Color monthHeaderBackgroundColor = weekHeaderBackgroundColor;
final Color monthCellHighlightColor =
  defaultIsDarkMode ? DarkAppColors.primary : AppColors.primary;

// Multi-day view colors
final Color multiDayTileColor = weekDayTileColor;
final Color multiDayTextColor = weekDayTextColor;
final Color multiDayHourLineColor = weekHourLineColor;
final Color multiDayHalfHourLineColor = weekHalfHourLineColor;
final Color multiDayQuarterHourLineColor = weekQuarterHourLineColor;
final Color multiDayLiveIndicatorColor = weekLiveIndicatorColor;
final Color multiDayPageBackgroundColor = weekPageBackgroundColor;
final Color multiDayHeaderIconColor = weekHeaderIconColor;
final Color multiDayHeaderTextColor = weekHeaderTextColor;
final Color multiDayHeaderBackgroundColor = weekHeaderBackgroundColor;
final Color multiDayTimelineTextColor = weekTimelineTextColor;
final Color multiDayBorderColor = weekBorderColor;
final Color multiDayVerticalLinesColor = weekVerticalLinesColor;

final CalendarConfiguration calendarConfig = CalendarConfiguration(
  isDescriptionRequired: false,
  isDarkMode: defaultIsDarkMode,
  showViewSelector: true,
  showViewSelectorIcons: true,
  showViewSelectorMenu: true,
  viewSelectorConfig: ViewSelectorConfig(
    items: [
      ViewSelectorItem(view: CalendarView.day, icon: Icons.view_day, label: 'Day View'),
      ViewSelectorItem(view: CalendarView.week, icon: Icons.view_week, label: 'Week View'),
      ViewSelectorItem(view: CalendarView.threeDays, icon: Icons.view_carousel, label: 'Multi-Day View'),
      ViewSelectorItem(view: CalendarView.month, icon: Icons.calendar_month, label: 'Month View'),
    ],
    style: ViewSelectorStyle(iconSize: 30, spacing: 10, padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6), buttonPadding: EdgeInsets.all(4), position: ViewSelectorPosition.right, activeColor: viewSelectorActiveColor, inactiveColor: viewSelectorInactiveColor),
  ),
  showAddEventFab: false,
  showSettingsFab: false,
  initialView: CalendarViewType.week,
  initialLocale: 'en',
  dateFormat: DateStampFormat.month_name_day_year_long,
  timeFormat: TimeStampFormat.parse_24,
  timezone: TimezoneDatabase.allTimezones[14],
  dayViewColors: DayViewColors(
    hourLineColor: dayHourLineColor,
    halfHourLineColor: dayHalfHourLineColor,
    quarterHourLineColor: dayQuarterHourLineColor,
    pageBackgroundColor: dayPageBackgroundColor,
    liveIndicatorColor: dayLiveIndicatorColor,
    headerIconColor: dayHeaderIconColor,
    headerTextColor: dayHeaderTextColor,
    headerBackgroundColor: dayHeaderBackgroundColor,
    timelineTextColor: dayTimelineTextColor,
  ),
  stickyTimeSlot: true,
  weekViewColors: WeekViewColors(
    weekDayTileColor: weekDayTileColor,
    weekDayTextColor: weekDayTextColor,
    hourLineColor: weekHourLineColor,
    halfHourLineColor: weekHalfHourLineColor,
    quarterHourLineColor: weekQuarterHourLineColor,
    liveIndicatorColor: weekLiveIndicatorColor,
    pageBackgroundColor: weekPageBackgroundColor,
    headerIconColor: weekHeaderIconColor,
    headerTextColor: weekHeaderTextColor,
    headerBackgroundColor: weekHeaderBackgroundColor,
    timelineTextColor: weekTimelineTextColor,
    borderColor: weekBorderColor,
    verticalLinesColor: weekVerticalLinesColor,
  ),
  monthViewColors: MonthViewColors(
    cellInMonthColor: monthCellInMonthColor,
    cellNotInMonthColor: monthCellNotInMonthColor,
    cellTextColor: monthCellTextColor,
    cellBorderColor: monthCellBorderColor,
    weekDayTileColor: monthWeekDayTileColor,
    weekDayTextColor: monthWeekDayTextColor,
    weekDayBorderColor: monthWeekDayBorderColor,
    headerIconColor: monthHeaderIconColor,
    headerTextColor: monthHeaderTextColor,
    headerBackgroundColor: monthHeaderBackgroundColor,
    cellHighlightColor: monthCellHighlightColor,
  ),
  multiDayViewColors: MultiDayViewColors(
    multiDayTileColor: multiDayTileColor,
    multiDayTextColor: multiDayTextColor,
    hourLineColor: multiDayHourLineColor,
    halfHourLineColor: multiDayHalfHourLineColor,
    quarterHourLineColor: multiDayQuarterHourLineColor,
    liveIndicatorColor: multiDayLiveIndicatorColor,
    pageBackgroundColor: multiDayPageBackgroundColor,
    headerIconColor: multiDayHeaderIconColor,
    headerTextColor: multiDayHeaderTextColor,
    headerBackgroundColor: multiDayHeaderBackgroundColor,
    timelineTextColor: multiDayTimelineTextColor,
    borderColor: multiDayBorderColor,
    verticalLinesColor: multiDayVerticalLinesColor,
  ),
);

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkMode;
  final String initialLocale = 'en';
  final EventController _eventController = EventController();

  @override
  void initState() {
    super.initState();
    PackageStrings.setLocale(calendarConfig.initialLocale);
    CalendarLocales.initialize();
    isDarkMode = calendarConfig.isDarkMode;
    FormatSettingsController.notifier.value = FormatSettings(dateFormat: calendarConfig.dateFormat, timeFormat: calendarConfig.timeFormat, timezone: calendarConfig.timezone);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LocaleController(
      initialLocale: calendarConfig.initialLocale,
      child: Builder(
        builder: (context) {
          final localeController = LocaleController.of(context);
          return CalendarThemeProvider(
            calendarTheme: (() {
              final weekTheme = isDarkMode ? WeekViewThemeData.dark() : WeekViewThemeData.light();
              final baseTheme = CalendarThemeData(
                monthViewTheme: isDarkMode ? MonthViewThemeData.dark() : MonthViewThemeData.light(),
                dayViewTheme: isDarkMode ? DayViewThemeData.dark() : DayViewThemeData.light(),
                weekViewTheme: weekTheme,
                multiDayViewTheme: MultiDayViewThemeData(multiDayTileColor: weekTheme.weekDayTileColor, multiDayTextColor: weekTheme.weekDayTextColor, hourLineColor: weekTheme.hourLineColor, halfHourLineColor: weekTheme.halfHourLineColor, quarterHourLineColor: weekTheme.quarterHourLineColor, liveIndicatorColor: weekTheme.liveIndicatorColor, pageBackgroundColor: weekTheme.pageBackgroundColor, headerIconColor: weekTheme.headerIconColor, headerTextColor: weekTheme.headerTextColor, headerBackgroundColor: weekTheme.headerBackgroundColor, timelineTextColor: weekTheme.timelineTextColor, borderColor: weekTheme.borderColor, verticalLinesColor: weekTheme.verticalLinesColor),
              );

              return CalendarThemeData(monthViewTheme: calendarConfig.monthViewColors?.apply(baseTheme.monthViewTheme) ?? baseTheme.monthViewTheme, dayViewTheme: calendarConfig.dayViewColors?.apply(baseTheme.dayViewTheme) ?? baseTheme.dayViewTheme, weekViewTheme: calendarConfig.weekViewColors?.apply(baseTheme.weekViewTheme) ?? baseTheme.weekViewTheme, multiDayViewTheme: calendarConfig.multiDayViewColors?.apply(baseTheme.multiDayViewTheme) ?? baseTheme.multiDayViewTheme);
            })(),
            child: CalendarControllerProvider(
              controller: _eventController,
              child: CalendarConfigurationProvider(
                configuration: calendarConfig,
                child: MaterialApp(
                  title: 'Flutter Calendar Page Demo',
                  debugShowCheckedModeBanner: false,
                  locale: Locale(localeController.currentLocale),
                  theme: AppTheme.light,
                  darkTheme: AppTheme.dark,
                  themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
                  localizationsDelegates: [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
                  supportedLocales: [Locale('en', ''), Locale('es', ''), Locale('ar', '')],
                  scrollBehavior: ScrollBehavior().copyWith(dragDevices: {PointerDeviceKind.trackpad, PointerDeviceKind.mouse, PointerDeviceKind.touch}),
                  home: HomePage(onChangeTheme: (isDark) => setState(() => isDarkMode = isDark)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
