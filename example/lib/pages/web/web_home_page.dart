import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../../config/calendar_form_config.dart';
import '../../enumerations.dart';
import '../../format_settings.dart';
import '../../widgets/add_event_form.dart';
import '../../widgets/calendar_views.dart';
import '../settings_page.dart';

class WebHomePage extends StatefulWidget {
  WebHomePage({
    this.selectedView = CalendarView.month,
    this.onThemeChange,
    this.useConfigInitialView = true,
  });

  final CalendarView selectedView;
  final void Function(bool)? onThemeChange;
  final bool useConfigInitialView;

  @override
  _WebHomePageState createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage> {
  late var _selectedView = widget.selectedView;

  CalendarView _convertViewType(CalendarViewType viewType) {
    switch (viewType) {
      case CalendarViewType.day:
        return CalendarView.day;
      case CalendarViewType.week:
        return CalendarView.week;
      case CalendarViewType.multiDay:
        return CalendarView.threeDays;
      case CalendarViewType.month:
        return CalendarView.month;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.useConfigInitialView) {
      final config = CalendarConfigurationProvider.of(context);
      _selectedView = _convertViewType(config.initialView);
    } else {
      _selectedView = widget.selectedView;
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = CalendarConfigurationProvider.of(context);
    return Scaffold(
      body: CalendarViews(view: _selectedView),
      floatingActionButton:
          (config.showAddEventFab || config.showSettingsFab)
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (config.showAddEventFab)
                      FloatingActionButton(
                        heroTag: 'add_event',
                        tooltip: 'Add event',
                        child: Icon(Icons.add),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Add Event'),
                              content: SingleChildScrollView(
                                child: AddOrEditEventForm(
                                  onEventAdd: (event) {
                                    Navigator.of(ctx).pop();
                                    CalendarControllerProvider.of(context)
                                        .controller
                                        .add(event);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    if (config.showAddEventFab && config.showSettingsFab)
                      SizedBox(height: 12),
                    if (config.showSettingsFab)
                      FloatingActionButton(
                        heroTag: 'settings',
                        tooltip: 'Settings',
                        child: Icon(Icons.settings),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) =>
                                  SettingsPage(onThemeChange: widget.onThemeChange)),
                        ),
                      ),
                  ],
                )
              : null,
    );
  }
}
