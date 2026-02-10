import 'package:calendar_view/calendar_view.dart';
import 'package:example/extension.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../format_settings.dart';
import 'add_event_form.dart';

class MonthViewWidget extends StatelessWidget {
  final GlobalKey<MonthViewState>? state;
  final double? width;
  final ValueChanged<DateTime>? onDayTap;
  final Widget? viewSelector;

  const MonthViewWidget({super.key, this.state, this.width, this.onDayTap, this.viewSelector});

  @override
  Widget build(BuildContext context) {
    final translate = context.translate;
    // Dynamically adjust maxMonth if a later month is selected or if a target month is set from YearView
    // Check for a target month from year view navigation
    DateTime? effectiveMaxMonth;
    DateTime? initialMonth;
    if (state?.currentState != null && state!.currentState!.currentDate != null) {
      final selected = state!.currentState!.currentDate;
      final staticMax = DateTime(2027, 12, 31);
      effectiveMaxMonth = selected.isAfter(staticMax) ? DateTime(selected.year, selected.month, 28) : staticMax;
      if (selected.isAfter(effectiveMaxMonth)) {
        effectiveMaxMonth = DateTime(selected.year, selected.month, 28);
      }
      initialMonth = selected;
    } else {
      effectiveMaxMonth = DateTime(2100, 12, 31); // Allow navigation far into the future
      initialMonth = DateTime.now();
    }
    // Set minMonth to a very early date to allow navigation to any past month
    final effectiveMinMonth = DateTime(1900, 1, 1);
    return MonthView(
      key: state,
      width: width,
      monthViewStyle: MonthViewStyle(
        headerStyle: HeaderStyle(decoration: BoxDecoration(color: monthHeaderBackgroundColor)),
        startDay: monthStartDay,
        useAvailableVerticalSpace: true,
        hideDaysNotInMonth: true,
        maxMonth: effectiveMaxMonth,
        minMonth: effectiveMinMonth,
        initialMonth: initialMonth,
        showBorder: true,
        showWeekends: true,
      ),
      monthViewBuilders: MonthViewBuilders(
        headerBuilder: viewSelector != null
            ? (date) {
                final state = this.state?.currentState;
                return CalendarPageHeader(
                  date: date,
                  dateStringBuilder: (date, {secondaryDate}) => DateFormat('MMMM yyyy').format(date),
                  headerStyle: HeaderStyle(decoration: BoxDecoration(color: monthHeaderBackgroundColor)),
                  viewSelector: viewSelector,
                  onPreviousDay: state?.previousPage,
                  onNextDay: state?.nextPage,
                  showPreviousIcon: date != state?.minDate,
                  showNextIcon: date != state?.maxDate,
                );
              }
            : null,
        headerStringBuilder: (date, {secondaryDate}) => DateFormat('MMMM yyyy').format(date),
        //When user tries to scroll beyond the max month or min month
        // these callbacks will be triggered.
        onHasReachedEnd: (date, page) {
          SnackBar snackBar = SnackBar(content: Text(translate.reachedTheEndPage));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        onHasReachedStart: (date, page) {
          SnackBar snackBar = SnackBar(content: Text(translate.reachedTheStartPage));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        onCellTap: (events, date) {
          if (onDayTap != null) {
            onDayTap!(date);
          }
        },
        // onDateLongPress: (date) {
        //   showDialog(
        //     context: context,
        //     builder: (ctx) => AlertDialog(
        //       title: Text('Add Event'),
        //       content: SingleChildScrollView(
        //         child: AddOrEditEventForm(
        //           initialDateTime: date,
        //           onEventAdd: (event) {
        //             Navigator.of(ctx).pop();
        //             CalendarControllerProvider.of(context)
        //                 .controller
        //                 .add(event);
        //           },
        //         ),
        //       ),
        //     ),
        //   );
        // },
        onEventTap: (event, date) {
          String formatTime(DateTime? dt) {
            if (dt == null) return '';
            return dt.getTimeInFormat(FormatSettingsController.notifier.value.timeFormat);
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
                    Text(date.dateToStringWithDateStampFormat(format: FormatSettingsController.notifier.value.dateFormat)),
                    if (event.startTime != null || event.endTime != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(event.isFullDayEvent ? 'All day' : '${formatTime(event.startTime)} - ${formatTime(event.endTime)}')),
                    if (event.description?.isNotEmpty ?? false) Padding(padding: const EdgeInsets.only(top: 12), child: Text(event.description!)),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text('Close')),
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
                              CalendarControllerProvider.of(context).controller.update(event, updatedEvent);
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
      monthViewThemeSettings: MonthViewThemeSettings(cellsInMonthHighlightColor: Colors.blue),
    );
  }
}
