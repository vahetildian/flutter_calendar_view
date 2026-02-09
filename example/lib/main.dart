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
import 'pages/web/web_home_page.dart';
import 'theme/app_colors.dart';
import 'theme/dark_app_colors.dart';

const bool defaultIsDarkMode = false;

// View selector & Today button
final Color viewSelectorActiveColor = defaultIsDarkMode ? AppColors.white : AppColors.white;
final Color viewSelectorInactiveColor = defaultIsDarkMode ? DarkAppColors.outlineVariant : AppColors.outlineVariant;
final bool showTodayButton = true;
final TodayButtonPosition todayButtonPosition = TodayButtonPosition.left;
final double minWidthForViewSelectorButtons = 500.0; // Minimum screen width to show icon buttons vs menu

//Header background Color. Is set to every view for now. But you can change the header background color for each view in the following code.
final Color headerBackgroundColorLight = const Color(0xFF2196F3);
final Color headerBackgroundColorDark = const Color(0xFF1976D2);

// Day view colors
final Color dayHourLineColor = defaultIsDarkMode ? DarkAppColors.outlineVariant : AppColors.outlineVariant;
final Color dayHalfHourLineColor = dayHourLineColor;
final Color dayQuarterHourLineColor = dayHourLineColor;
final Color dayPageBackgroundColor = defaultIsDarkMode ? Colors.black : AppColors.white;
final Color dayLiveIndicatorColor = defaultIsDarkMode ? DarkAppColors.primary : AppColors.primary;
final Color dayHeaderIconColor = defaultIsDarkMode ? DarkAppColors.onPrimary : AppColors.onPrimary;
final Color dayHeaderTextColor = dayHeaderIconColor;
final Color dayHeaderBackgroundColor = defaultIsDarkMode ? headerBackgroundColorDark : headerBackgroundColorLight;
final Color dayTimelineTextColor = defaultIsDarkMode ? Colors.white : AppColors.black;

// Week view colors
final Color weekDayTileColor = defaultIsDarkMode ? DarkAppColors.outlineVariant : AppColors.bluishGrey;
final Color weekDayTextColor = defaultIsDarkMode ? Colors.white : AppColors.black;
final Color weekHourLineColor = defaultIsDarkMode ? DarkAppColors.outlineVariant : AppColors.outlineVariant;
final Color weekHalfHourLineColor = weekHourLineColor;
final Color weekQuarterHourLineColor = weekHourLineColor;
final Color weekLiveIndicatorColor = defaultIsDarkMode ? DarkAppColors.primary : AppColors.primary;
final Color weekPageBackgroundColor = defaultIsDarkMode ? Colors.black : AppColors.white;
final Color weekHeaderIconColor = defaultIsDarkMode ? DarkAppColors.onPrimary : AppColors.onPrimary;
final Color weekHeaderTextColor = weekHeaderIconColor;
final Color weekHeaderBackgroundColor = defaultIsDarkMode ? headerBackgroundColorDark : headerBackgroundColorLight;
final Color weekTimelineTextColor = weekDayTextColor;
final Color weekBorderColor = weekHourLineColor;
final Color weekVerticalLinesColor = weekHourLineColor;

// Month view colors
final Color monthCellInMonthColor = defaultIsDarkMode ? Colors.black : AppColors.white;
final Color monthCellNotInMonthColor = defaultIsDarkMode ? DarkAppColors.outlineVariant : AppColors.grey;
final Color monthCellTextColor = defaultIsDarkMode ? Colors.white : AppColors.black;
final Color monthCellBorderColor = defaultIsDarkMode ? DarkAppColors.outlineVariant : AppColors.outlineVariant;
final Color monthWeekDayTileColor = weekDayTileColor;
final Color monthWeekDayTextColor = weekDayTextColor;
final Color monthWeekDayBorderColor = monthCellBorderColor;
final Color monthHeaderIconColor = defaultIsDarkMode ? DarkAppColors.onPrimary : AppColors.onPrimary;
final Color monthHeaderTextColor = monthHeaderIconColor;
final Color monthHeaderBackgroundColor = defaultIsDarkMode ? headerBackgroundColorDark : headerBackgroundColorLight;
final Color monthCellHighlightColor = defaultIsDarkMode ? DarkAppColors.primary : AppColors.primary;
final WeekDays monthStartDay = WeekDays.monday; // Start week on Monday in month view

// Multi-day view colors
final Color multiDayTileColor = weekDayTileColor;
final Color multiDayTextColor = weekDayTextColor;
final Color multiDayHourLineColor = weekHourLineColor;
final Color multiDayHalfHourLineColor = weekHalfHourLineColor;
final Color multiDayQuarterHourLineColor = weekQuarterHourLineColor;
final Color multiDayLiveIndicatorColor = weekLiveIndicatorColor;
final Color multiDayPageBackgroundColor = weekPageBackgroundColor;
final Color multiDayHeaderIconColor = defaultIsDarkMode ? DarkAppColors.onPrimary : AppColors.onPrimary;
final Color multiDayHeaderTextColor = multiDayHeaderIconColor;
final Color multiDayHeaderBackgroundColor = defaultIsDarkMode ? headerBackgroundColorDark : headerBackgroundColorLight;
final Color multiDayTimelineTextColor = weekTimelineTextColor;
final Color multiDayBorderColor = weekBorderColor;
final Color multiDayVerticalLinesColor = weekVerticalLinesColor;

// Year view colors
final Color yearCurrentMonthBorderColor = defaultIsDarkMode ? DarkAppColors.primary : AppColors.primary;
final Color yearOtherMonthsBorderColor = defaultIsDarkMode ? DarkAppColors.outlineVariant : AppColors.outlineVariant;
final Color yearTodayCircleColor = defaultIsDarkMode ? DarkAppColors.primary : AppColors.primary;
final bool yearShowMonthBorders = true;
final bool yearShowCurrentMonthBorder = true;
final bool yearShowTodayCircle = true;
final WeekDays yearStartDay = WeekDays.monday;
final TextAlign yearLabelAlignment = TextAlign.left; // left, center, or right
final EdgeInsets yearLabelPadding = const EdgeInsets.symmetric(horizontal: 100.0);
final TextStyle? yearLabelTextStyle = null;
final double yearScrollOffset = 0.0; // tune if year top is off (pixels)
// Background color for YearView (hosts can change this)
final Color yearBackgroundColor = defaultIsDarkMode ? Colors.black : Colors.white;

/// Threshold (in pixels) for switching YearView to display only month names (no grid).
/// If the month tile width is less than this value, only the month name is shown.
final double yearViewMonthNamesOnlyWidthThreshold = 375.0;

// View layout & interaction
final int multiDayDaysInView = 3;
final int multiDayPageStep = 1;
final int dragSnapMinutes = 30;
final int? multiDayDragSnapMinutes = null;
final int? dayDragSnapMinutes = null;
final int? weekDragSnapMinutes = null;
final double dayHeightPerMinute = 1;
final double weekHeightPerMinute = 1;
final double multiDayHeightPerMinute = 1;

// Current time indicator controlsDon
final bool showCurrentTimeText = true;
final bool showCurrentTimeBackground = true;
final Color currentTimeLineColor = defaultIsDarkMode ? AppColors.primary : AppColors.primary;
final double currentTimeLineHeight = 1.0;
final double currentTimeLineStartInset = 0.0;
final double currentTimeLineEndInset = 0.0;

final Color currentTimeTextColor = defaultIsDarkMode ? AppColors.white : AppColors.white;
final double currentTimeTextSize = 12.0;
final double currentTimeBackgroundWidth = 60.0;
final double currentTimeBulletRadius = 5.0;
final bool showCurrentTimeBullet = false;

final LiveTimeIndicatorSettings dayLiveTimeIndicatorSettings = LiveTimeIndicatorSettings(color: currentTimeLineColor, height: currentTimeLineHeight, showBullet: showCurrentTimeBullet, showTime: showCurrentTimeText, showTimeBackgroundView: showCurrentTimeBackground, timeTextColor: currentTimeTextColor, timeTextSize: currentTimeTextSize, timeBackgroundViewWidth: currentTimeBackgroundWidth, bulletRadius: currentTimeBulletRadius, lineStartInset: currentTimeLineStartInset, lineEndInset: currentTimeLineEndInset, currentTimeProvider: () => FormatSettingsController.applyTimezone(DateTime.now()));

final LiveTimeIndicatorSettings weekLiveTimeIndicatorSettings = LiveTimeIndicatorSettings(color: currentTimeLineColor, height: currentTimeLineHeight, showBullet: true, showTime: showCurrentTimeText, showTimeBackgroundView: showCurrentTimeBackground, timeTextColor: currentTimeTextColor, timeTextSize: currentTimeTextSize, timeBackgroundViewWidth: currentTimeBackgroundWidth, bulletRadius: currentTimeBulletRadius, lineStartInset: currentTimeLineStartInset, lineEndInset: currentTimeLineEndInset, currentTimeProvider: () => FormatSettingsController.applyTimezone(DateTime.now()));

final LiveTimeIndicatorSettings multiDayLiveTimeIndicatorSettings = LiveTimeIndicatorSettings(color: currentTimeLineColor, height: currentTimeLineHeight, showBullet: true, showTime: showCurrentTimeText, showTimeBackgroundView: showCurrentTimeBackground, timeTextColor: currentTimeTextColor, timeTextSize: currentTimeTextSize, timeBackgroundViewWidth: currentTimeBackgroundWidth, bulletRadius: currentTimeBulletRadius, lineStartInset: currentTimeLineStartInset, lineEndInset: currentTimeLineEndInset, onlyShowToday: true, currentTimeProvider: () => FormatSettingsController.applyTimezone(DateTime.now()));

final CalendarConfiguration calendarConfig = CalendarConfiguration(
  isDescriptionRequired: false,
  isDarkMode: defaultIsDarkMode,
  showViewSelector: true,
  showViewSelectorIcons: true,
  showViewSelectorMenu: true,
  viewSelectorConfig: ViewSelectorConfig(
    items: [
      ViewSelectorItem(view: CalendarView.day, icon: Icons.view_day, label: 'Day View'),
      ViewSelectorItem(view: CalendarView.threeDays, icon: Icons.view_column_rounded, label: 'Multi-Day View'),
      ViewSelectorItem(view: CalendarView.week, icon: Icons.calendar_view_week, label: 'Week View'),
      ViewSelectorItem(view: CalendarView.month, icon: Icons.calendar_month, label: 'Month View'),
      ViewSelectorItem(view: CalendarView.year, icon: Icons.calendar_view_month, label: 'Year View'),
    ],
    style: ViewSelectorStyle(iconSize: 30, spacing: 10, padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6), buttonPadding: EdgeInsets.all(4), position: ViewSelectorPosition.right, activeColor: viewSelectorActiveColor, inactiveColor: viewSelectorInactiveColor, showTodayButton: showTodayButton, todayButtonPosition: todayButtonPosition),
  ),
  showAddEventFab: false,
  showSettingsFab: false,
  initialView: CalendarViewType.year,
  initialLocale: 'en',
  dateFormat: DateStampFormat.month_name_day_year_long,
  timeFormat: TimeStampFormat.parse_24,
  timezone: TimezoneDatabase.allTimezones[12],
  dayViewColors: DayViewColors(hourLineColor: dayHourLineColor, halfHourLineColor: dayHalfHourLineColor, quarterHourLineColor: dayQuarterHourLineColor, pageBackgroundColor: dayPageBackgroundColor, liveIndicatorColor: dayLiveIndicatorColor, headerIconColor: dayHeaderIconColor, headerTextColor: dayHeaderTextColor, headerBackgroundColor: dayHeaderBackgroundColor, timelineTextColor: dayTimelineTextColor),
  dayLiveTimeIndicatorSettings: dayLiveTimeIndicatorSettings,
  stickyTimeSlot: true,
  weekViewColors: WeekViewColors(weekDayTileColor: weekDayTileColor, weekDayTextColor: weekDayTextColor, hourLineColor: weekHourLineColor, halfHourLineColor: weekHalfHourLineColor, quarterHourLineColor: weekQuarterHourLineColor, liveIndicatorColor: weekLiveIndicatorColor, pageBackgroundColor: weekPageBackgroundColor, headerIconColor: weekHeaderIconColor, headerTextColor: weekHeaderTextColor, headerBackgroundColor: weekHeaderBackgroundColor, timelineTextColor: weekTimelineTextColor, borderColor: weekBorderColor, verticalLinesColor: weekVerticalLinesColor),
  weekLiveTimeIndicatorSettings: weekLiveTimeIndicatorSettings,
  monthViewColors: MonthViewColors(cellInMonthColor: monthCellInMonthColor, cellNotInMonthColor: monthCellNotInMonthColor, cellTextColor: monthCellTextColor, cellBorderColor: monthCellBorderColor, weekDayTileColor: monthWeekDayTileColor, weekDayTextColor: monthWeekDayTextColor, weekDayBorderColor: monthWeekDayBorderColor, headerIconColor: monthHeaderIconColor, headerTextColor: monthHeaderTextColor, headerBackgroundColor: monthHeaderBackgroundColor, cellHighlightColor: monthCellHighlightColor),
  multiDayViewColors: MultiDayViewColors(multiDayTileColor: multiDayTileColor, multiDayTextColor: multiDayTextColor, hourLineColor: multiDayHourLineColor, halfHourLineColor: multiDayHalfHourLineColor, quarterHourLineColor: multiDayQuarterHourLineColor, liveIndicatorColor: multiDayLiveIndicatorColor, pageBackgroundColor: multiDayPageBackgroundColor, headerIconColor: multiDayHeaderIconColor, headerTextColor: multiDayHeaderTextColor, headerBackgroundColor: multiDayHeaderBackgroundColor, timelineTextColor: multiDayTimelineTextColor, borderColor: multiDayBorderColor, verticalLinesColor: multiDayVerticalLinesColor),
  multiDayLiveTimeIndicatorSettings: multiDayLiveTimeIndicatorSettings,
  dayHeightPerMinute: dayHeightPerMinute,
  weekHeightPerMinute: weekHeightPerMinute,
  multiDayHeightPerMinute: multiDayHeightPerMinute,
  multiDayDaysInView: multiDayDaysInView,
  multiDayPageStep: multiDayPageStep,
  dragSnapMinutes: dragSnapMinutes,
  multiDayDragSnapMinutes: multiDayDragSnapMinutes,
  dayDragSnapMinutes: dayDragSnapMinutes,
  weekDragSnapMinutes: weekDragSnapMinutes,
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

DateTime get _now => DateTime.now();

class HomePage extends StatefulWidget {
  const HomePage({this.onChangeTheme, super.key});

  /// Return true for dark mode
  /// false for light mode
  final void Function(bool)? onChangeTheme;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  EventController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final controller = CalendarControllerProvider.of(context).controller;

    // Initialize events only when controller is first accessed
    if (_controller != controller) {
      _controller = controller;

      final translate = context.translate;
      final events = [
        CalendarEventData(date: _now, title: translate.projectMeetingTitle, description: translate.projectMeetingDesc, startTime: DateTime(_now.year, _now.month, _now.day, 18, 30), endTime: DateTime(_now.year, _now.month, _now.day, 22)),
        CalendarEventData(
          date: _now.subtract(Duration(days: 3)),
          recurrenceSettings: RecurrenceSettings.withCalculatedEndDate(startDate: _now.subtract(Duration(days: 3))),
          title: translate.leetcodeContestTitle,
          description: translate.leetcodeContestDesc,
        ),
        CalendarEventData(
          date: _now.subtract(Duration(days: 3)),
          recurrenceSettings: RecurrenceSettings.withCalculatedEndDate(startDate: _now.subtract(Duration(days: 3)), frequency: RepeatFrequency.daily, recurrenceEndOn: RecurrenceEnd.after, occurrences: 5),
          title: translate.physicsTestTitle,
          description: translate.physicsTestDesc,
        ),
        CalendarEventData(
          date: _now.add(Duration(days: 1)),
          startTime: DateTime(_now.year, _now.month, _now.day, 18),
          endTime: DateTime(_now.year, _now.month, _now.day, 19),
          recurrenceSettings: RecurrenceSettings(startDate: _now, endDate: _now.add(Duration(days: 5)), frequency: RepeatFrequency.daily, recurrenceEndOn: RecurrenceEnd.after, occurrences: 5),
          title: translate.weddingAnniversaryTitle,
          description: translate.weddingAnniversaryDesc,
        ),
        CalendarEventData(date: _now, startTime: DateTime(_now.year, _now.month, _now.day, 14), endTime: DateTime(_now.year, _now.month, _now.day, 17), title: translate.footballTournamentTitle, description: translate.footballTournamentDesc),
        CalendarEventData(date: _now.add(Duration(days: 3)), startTime: DateTime(_now.add(Duration(days: 3)).year, _now.add(Duration(days: 3)).month, _now.add(Duration(days: 3)).day, 10), endTime: DateTime(_now.add(Duration(days: 3)).year, _now.add(Duration(days: 3)).month, _now.add(Duration(days: 3)).day, 14), title: translate.sprintMeetingTitle, description: translate.sprintMeetingDesc),
        CalendarEventData(date: _now.subtract(Duration(days: 2)), startTime: DateTime(_now.subtract(Duration(days: 2)).year, _now.subtract(Duration(days: 2)).month, _now.subtract(Duration(days: 2)).day, 14), endTime: DateTime(_now.subtract(Duration(days: 2)).year, _now.subtract(Duration(days: 2)).month, _now.subtract(Duration(days: 2)).day, 16), title: translate.teamMeetingTitle, description: translate.teamMeetingDesc),
        CalendarEventData(date: _now.subtract(Duration(days: 2)), startTime: DateTime(_now.subtract(Duration(days: 2)).year, _now.subtract(Duration(days: 2)).month, _now.subtract(Duration(days: 2)).day, 10), endTime: DateTime(_now.subtract(Duration(days: 2)).year, _now.subtract(Duration(days: 2)).month, _now.subtract(Duration(days: 2)).day, 12), title: translate.chemistryVivaTitle, description: translate.chemistryVivaDesc),
      ];
      _controller!.addAll(events);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebHomePage(onThemeChange: widget.onChangeTheme);
  }
}
