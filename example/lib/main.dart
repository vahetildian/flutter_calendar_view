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

// Configure these parameters to control the calendar behavior
final calendarConfig = CalendarConfiguration(
  isDescriptionRequired: false,
  isDarkMode: false,
  showViewSelector: true,
  showViewSelectorIcons: true,
  showViewSelectorMenu: true,
  viewSelectorConfig: ViewSelectorConfig(
    items: [
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
    style: ViewSelectorStyle(
      iconSize: 18,
      spacing: 10,
      padding: EdgeInsets.fromLTRB(0, 5, 50, 0),
      buttonPadding: EdgeInsets.all(4),
    ),
  ),
  showAddEventFab: false,
  showSettingsFab: false,
  initialView: CalendarViewType.week,
  initialLocale: 'en',
  dateFormat: DateStampFormat.month_name_day_year_long,
  timeFormat: TimeStampFormat.parse_12,
  timezone: TimezoneDatabase.allTimezones[14],
  dayViewColors: DayViewColors(
    hourLineColor: AppColors.primary,
  ),
  stickyTimeSlot: true,
  weekViewColors: WeekViewColors(),
  monthViewColors: MonthViewColors(),
  multiDayViewColors: MultiDayViewColors(),
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
    FormatSettingsController.notifier.value = FormatSettings(
      dateFormat: calendarConfig.dateFormat,
      timeFormat: calendarConfig.timeFormat,
      timezone: calendarConfig.timezone,
    );
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
              final weekTheme = isDarkMode
                  ? WeekViewThemeData.dark()
                  : WeekViewThemeData.light();
              final baseTheme = CalendarThemeData(
                monthViewTheme: isDarkMode
                    ? MonthViewThemeData.dark()
                    : MonthViewThemeData.light(),
                dayViewTheme:
                    isDarkMode ? DayViewThemeData.dark() : DayViewThemeData.light(),
                weekViewTheme: weekTheme,
                multiDayViewTheme: MultiDayViewThemeData(
                  multiDayTileColor: weekTheme.weekDayTileColor,
                  multiDayTextColor: weekTheme.weekDayTextColor,
                  hourLineColor: weekTheme.hourLineColor,
                  halfHourLineColor: weekTheme.halfHourLineColor,
                  quarterHourLineColor: weekTheme.quarterHourLineColor,
                  liveIndicatorColor: weekTheme.liveIndicatorColor,
                  pageBackgroundColor: weekTheme.pageBackgroundColor,
                  headerIconColor: weekTheme.headerIconColor,
                  headerTextColor: weekTheme.headerTextColor,
                  headerBackgroundColor: weekTheme.headerBackgroundColor,
                  timelineTextColor: weekTheme.timelineTextColor,
                  borderColor: weekTheme.borderColor,
                  verticalLinesColor: weekTheme.verticalLinesColor,
                ),
              );

              return CalendarThemeData(
                monthViewTheme: calendarConfig.monthViewColors
                        ?.apply(baseTheme.monthViewTheme) ??
                    baseTheme.monthViewTheme,
                dayViewTheme: calendarConfig.dayViewColors
                        ?.apply(baseTheme.dayViewTheme) ??
                    baseTheme.dayViewTheme,
                weekViewTheme: calendarConfig.weekViewColors
                        ?.apply(baseTheme.weekViewTheme) ??
                    baseTheme.weekViewTheme,
                multiDayViewTheme: calendarConfig.multiDayViewColors
                        ?.apply(baseTheme.multiDayViewTheme) ??
                    baseTheme.multiDayViewTheme,
              );
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
                  localizationsDelegates: [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: [
                    Locale('en', ''),
                    Locale('es', ''),
                    Locale('ar', ''),
                  ],
                  scrollBehavior: ScrollBehavior().copyWith(
                    dragDevices: {
                      PointerDeviceKind.trackpad,
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.touch,
                    },
                  ),
                  home: HomePage(
                    onChangeTheme: (isDark) =>
                        setState(() => isDarkMode = isDark),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
