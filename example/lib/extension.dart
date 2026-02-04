import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'enumerations.dart';
import 'l10n/app_localizations.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme_extension.dart';

enum TimeStampFormat { parse_12, parse_24 }

enum DateStampFormat {
  yy_mm_dd,
  yyyy_mm_dd,
  dd_mm_yy,
  dd_mm_yyyy,
  mm_dd_yy,
  mm_dd_yyyy,
  month_name_day_year_long, // "February 4, 2026"
  month_abbrev_day_year, // "Feb 4, 2026"
  day_month_name_year, // "4 February 2026"
  day_name_day_month_year, // "Wed, 4 Feb 2026"
  day_name_full_day_month_year, // "Wednesday, 4 February 2026"
  month_name_year, // "February 2026"
  month_abbrev_year, // "Feb 2026"
  day_number_only, // "4"
  day_name_and_number, // "Wed 4"
}

extension NavigationExtension on State {
  void pushRoute(Widget page) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}

extension NavigatorExtention on BuildContext {
  Future<T?> pushRoute<T>(Widget page) =>
      Navigator.of(this).push<T>(MaterialPageRoute(builder: (context) => page));

  void pop([dynamic value]) => Navigator.of(this).pop(value);

  void showSnackBarWithText(String text) => ScaffoldMessenger.of(this)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

extension DateUtils on DateTime {
  String get weekdayToFullString {
    switch (weekday) {
      case DateTime.monday:
        return "Monday";
      case DateTime.tuesday:
        return "Tuesday";
      case DateTime.wednesday:
        return "Wednesday";
      case DateTime.thursday:
        return "Thursday";
      case DateTime.friday:
        return "Friday";
      case DateTime.saturday:
        return "Saturday";
      case DateTime.sunday:
        return "Sunday";
      default:
        return "Error";
    }
  }

  String get weekdayToAbbreviatedString {
    switch (weekday) {
      case DateTime.monday:
        return "M";
      case DateTime.tuesday:
        return "T";
      case DateTime.wednesday:
        return "W";
      case DateTime.thursday:
        return "T";
      case DateTime.friday:
        return "F";
      case DateTime.saturday:
        return "S";
      case DateTime.sunday:
        return "S";
      default:
        return "Err";
    }
  }

  int get totalMinutes => hour * 60 + minute;

  TimeOfDay get timeOfDay => TimeOfDay(hour: hour, minute: minute);

  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) => DateTime(
    year ?? this.year,
    month ?? this.month,
    day ?? this.day,
    hour ?? this.hour,
    minute ?? this.minute,
    second ?? this.second,
    millisecond ?? this.millisecond,
    microsecond ?? this.microsecond,
  );

  String dateToStringWithFormat({String format = 'y-M-d'}) {
    return DateFormat(format).format(this);
  }

  String dateToStringWithDateStampFormat({
    DateStampFormat format = DateStampFormat.month_name_day_year_long,
  }) {
    switch (format) {
      case DateStampFormat.yyyy_mm_dd:
        return DateFormat('yyyy-MM-dd').format(this);
      case DateStampFormat.yy_mm_dd:
        return DateFormat('yy-MM-dd').format(this);
      case DateStampFormat.dd_mm_yyyy:
        return DateFormat('dd-MM-yyyy').format(this);
      case DateStampFormat.dd_mm_yy:
        return DateFormat('dd-MM-yy').format(this);
      case DateStampFormat.mm_dd_yyyy:
        return DateFormat('MM-dd-yyyy').format(this);
      case DateStampFormat.mm_dd_yy:
        return DateFormat('MM-dd-yy').format(this);
      case DateStampFormat.month_name_day_year_long:
        return DateFormat('MMMM d, yyyy').format(this);
      case DateStampFormat.month_abbrev_day_year:
        return DateFormat('MMM d, yyyy').format(this);
      case DateStampFormat.day_month_name_year:
        return DateFormat('d MMMM yyyy').format(this);
      case DateStampFormat.day_name_day_month_year:
        return DateFormat('EEE, d MMM yyyy').format(this);
      case DateStampFormat.day_name_full_day_month_year:
        return DateFormat('EEEE, d MMMM yyyy').format(this);
      case DateStampFormat.month_name_year:
        return DateFormat('MMMM yyyy').format(this);
      case DateStampFormat.month_abbrev_year:
        return DateFormat('MMM yyyy').format(this);
      case DateStampFormat.day_number_only:
        return DateFormat('d').format(this);
      case DateStampFormat.day_name_and_number:
        return DateFormat('EEE d').format(this);
      default:
        return DateFormat('yyyy-MM-dd').format(this);
    }
  }

  DateTime stringToDateWithFormat({
    required String format,
    required String dateString,
  }) => DateFormat(format).parse(dateString);

  String getTimeInFormat(TimeStampFormat format) {
    if (format == TimeStampFormat.parse_12) {
      return DateFormat('h:mm a').format(this).toUpperCase();
    } else {
      return DateFormat('HH:mm').format(this);
    }
  }

  bool compareWithoutTime(DateTime date) =>
      day == date.day && month == date.month && year == date.year;

  bool compareTime(DateTime date) =>
      hour == date.hour && minute == date.minute && second == date.second;
}

extension ColorExtension on Color {
  /// TODO(Shubham): Update this getter as it uses `computeLuminance()`
  /// which is computationally expensive
  Color get accentColor {
    final brightness = ThemeData.estimateBrightnessForColor(this);
    return brightness == Brightness.light ? AppColors.black : AppColors.white;
  }
}

extension StringExt on String {
  String get capitalized => toBeginningOfSentenceCase(this) ?? "";
}

extension ViewNameExt on CalendarView {
  String get name => toString().split(".").last;
}

extension BuildContextExtension on BuildContext {
  AppThemeExtension get appColors =>
      Theme.of(this).extension<AppThemeExtension>() ??
      AppThemeExtension.light();
}

extension Translate on BuildContext {
  AppLocalizations get translate => AppLocalizations.of(this)!;
}
