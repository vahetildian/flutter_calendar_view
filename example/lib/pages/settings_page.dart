import 'package:flutter/material.dart';

import '../extension.dart';
import '../format_settings.dart';
import '../localization/locale_controller.dart';

class SettingsPage extends StatefulWidget {
  final void Function(bool)? onThemeChange;

  const SettingsPage({this.onThemeChange});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;

  // Map of supported locales with their display names
  final Map<String, String> supportedLocales = {
    'en': 'English',
    'es': 'Spanish',
    'ar': 'Arabic',
  };
  @override
  Widget build(BuildContext context) {
    final formats = FormatSettingsController.notifier;
    final localeController = LocaleController.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder(
          valueListenable: formats,
          builder: (context, FormatSettings value, _) {
            return ListView(
              children: [
                Text('Language', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 8),
                DropdownButton<String>(
                  value: localeController.currentLocale,
                  icon: const Icon(Icons.language),
                  elevation: 16,
                  isExpanded: true,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  onChanged: (String? value) {
                    if (value != null) {
                      localeController.setLocale(value);
                    }
                  },
                  items: supportedLocales.entries
                      .map<DropdownMenuItem<String>>((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      })
                      .toList(),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Dark Mode', style: Theme.of(context).textTheme.titleMedium),
                    Switch(
                      value: isDarkMode,
                      onChanged: (value) {
                        setState(() => isDarkMode = value);
                        if (widget.onThemeChange != null) {
                          widget.onThemeChange!(isDarkMode);
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text('Date format', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 8),
                DropdownButton<DateStampFormat>(
                  value: value.dateFormat,
                  onChanged: (v) {
                    if (v == null) return;
                    formats.value = FormatSettings(
                      dateFormat: v,
                      timeFormat: formats.value.timeFormat,
                      timezone: formats.value.timezone,
                      viewType: formats.value.viewType,
                    );
                  },
                  items: DateStampFormat.values.map((f) {
                    String label;
                    switch (f) {
                      case DateStampFormat.yyyy_mm_dd:
                        label = 'YYYY-MM-DD';
                        break;
                      case DateStampFormat.yy_mm_dd:
                        label = 'YY-MM-DD';
                        break;
                      case DateStampFormat.dd_mm_yyyy:
                        label = 'DD-MM-YYYY';
                        break;
                      case DateStampFormat.dd_mm_yy:
                        label = 'DD-MM-YY';
                        break;
                      case DateStampFormat.mm_dd_yyyy:
                        label = 'MM-DD-YYYY';
                        break;
                      case DateStampFormat.mm_dd_yy:
                        label = 'MM-DD-YY';
                        break;
                      case DateStampFormat.month_name_day_year_long:
                        label = 'Month name, day, YYYY (e.g. February 4, 2026)';
                        break;
                      case DateStampFormat.month_abbrev_day_year:
                        label = 'Abbrev month day YYYY (e.g. Feb 4, 2026)';
                        break;
                      case DateStampFormat.day_month_name_year:
                        label = 'Day number Month name YYYY (e.g. 4 February 2026)';
                        break;
                      case DateStampFormat.day_name_day_month_year:
                        label = 'Day name (abbr), day Month YYYY (e.g. Wed, 4 Feb 2026)';
                        break;
                      case DateStampFormat.day_name_full_day_month_year:
                        label = 'Day name (full), day Month YYYY (e.g. Wednesday, 4 February 2026)';
                        break;
                      
                      case DateStampFormat.month_name_year:
                        label = 'Month name YYYY (e.g. February 2026)';
                        break;
                      case DateStampFormat.month_abbrev_year:
                        label = 'Abbrev month YYYY (e.g. Feb 2026)';
                        break;
                      case DateStampFormat.day_number_only:
                        label = 'Day number only (e.g. 4)';
                        break;
                      case DateStampFormat.day_name_and_number:
                        label = 'Day name and number (e.g. Wed 4)';
                        break;
                      default:
                        label = f.toString().split('.').last;
                    }
                    return DropdownMenuItem(value: f, child: Text(label));
                  }).toList(),
                ),
                SizedBox(height: 24),
                Text('Time format', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<TimeStampFormat>(
                        title: Text('24-hour'),
                        value: TimeStampFormat.parse_24,
                        groupValue: value.timeFormat,
                        onChanged: (v) => formats.value = FormatSettings(
                          dateFormat: formats.value.dateFormat,
                          timeFormat: v ?? TimeStampFormat.parse_24,
                          timezone: formats.value.timezone,
                          viewType: formats.value.viewType,
                        ),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<TimeStampFormat>(
                        title: Text('12-hour'),
                        value: TimeStampFormat.parse_12,
                        groupValue: value.timeFormat,
                        onChanged: (v) => formats.value = FormatSettings(
                          dateFormat: formats.value.dateFormat,
                          timeFormat: v ?? TimeStampFormat.parse_24,
                          timezone: formats.value.timezone,
                          viewType: formats.value.viewType,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text('Timezone', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 8),
                DropdownButton<Timezone>(
                  value: value.timezone,
                  onChanged: (v) {
                    if (v == null) return;
                    formats.value = FormatSettings(
                      dateFormat: formats.value.dateFormat,
                      timeFormat: formats.value.timeFormat,
                      timezone: v,
                      viewType: formats.value.viewType,
                    );
                  },
                  items: TimezoneDatabase.allTimezones.map((tz) {
                    return DropdownMenuItem(
                      value: tz,
                      child: Row(
                        children: [
                          Text('${tz.formattedOffset} - ${tz.displayName} - ${tz.getCurrentTimeString()}'),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
