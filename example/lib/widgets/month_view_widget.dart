import 'package:calendar_view/calendar_view.dart';
import 'package:example/extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../format_settings.dart';
import 'add_event_form.dart';

class MonthViewWidget extends StatelessWidget {
  final GlobalKey<MonthViewState>? state;
  final double? width;

  const MonthViewWidget({super.key, this.state, this.width});

  @override
  Widget build(BuildContext context) {
    final translate = context.translate;
    return MonthView(
      key: state,
      width: width,
      monthViewBuilders: MonthViewBuilders(
        headerStringBuilder: (date, {secondaryDate}) =>
          DateFormat('MMMM yyyy').format(date),
        //When user tries to scroll beyond the max month or min month
        // these callbacks will be triggered.
        onHasReachedEnd: (date, page) {
          SnackBar snackBar = SnackBar(
            content: Text(translate.reachedTheEndPage),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        onHasReachedStart: (date, page) {
          SnackBar snackBar = SnackBar(
            content: Text(translate.reachedTheStartPage),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        onDateLongPress: (date) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Add Event'),
              content: SingleChildScrollView(
                child: AddOrEditEventForm(
                  initialDateTime: date,
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
        onEventTap: (event, date) {
          String formatTime(DateTime? dt) {
            if (dt == null) return '';
            return dt.getTimeInFormat(
                FormatSettingsController.notifier.value.timeFormat);
          }

          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(event.title),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(date.dateToStringWithDateStampFormat(
                      format:
                          FormatSettingsController.notifier.value.dateFormat,
                    )),
                    if (event.startTime != null || event.endTime != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          event.isFullDayEvent
                              ? 'All day'
                              : '${formatTime(event.startTime)} - ${formatTime(event.endTime)}',
                        ),
                      ),
                    if (event.description?.isNotEmpty ?? false)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(event.description!),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('Close'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    showDialog(
                      context: context,
                      builder: (editCtx) => AlertDialog(
                        title: Text('Edit Event'),
                        content: SingleChildScrollView(
                          child: AddOrEditEventForm(
                            event: event,
                            onEventAdd: (updatedEvent) {
                              Navigator.of(editCtx).pop();
                              CalendarControllerProvider.of(context)
                                  .controller
                                  .update(event, updatedEvent);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  child: Text('Edit'),
                ),
              ],
            ),
          );
        },
        onEventLongTap: (event, date) {
          SnackBar snackBar = SnackBar(content: Text("on LongTap"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      ),
      monthViewThemeSettings: MonthViewThemeSettings(
        cellsInMonthHighlightColor: Colors.blue,
      ),
      monthViewStyle: MonthViewStyle(
        startDay: WeekDays.friday,
        useAvailableVerticalSpace: true,
        hideDaysNotInMonth: true,
        // Define the range of months to display
        maxMonth: DateTime(2027, 12, 31),
        minMonth: DateTime(2020, 1, 1),
        pagePhysics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}
