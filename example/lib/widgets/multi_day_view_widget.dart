import 'dart:math';
import 'dart:ui' as ui;

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../config/calendar_form_config.dart';
import '../extension.dart';
import '../format_settings.dart';
import 'add_event_form.dart';

class MultiDayViewWidget extends StatelessWidget {
  final GlobalKey<MultiDayViewState>? state;
  final double? width;

  const MultiDayViewWidget({super.key, this.state, this.width});

  String _formatHeader(DateTime start, DateTime? end, FormatSettings formats) {
    if (end == null) {
      return start.dateToStringWithDateStampFormat(format: formats.dateFormat);
    }
    return '${start.dateToStringWithDateStampFormat(format: formats.dateFormat)} - ${end.dateToStringWithDateStampFormat(format: formats.dateFormat)}';
  }

  Widget _timeLineBuilder(DateTime date, bool isLtr) {
    if (date.minute != 0) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            top: -8,
            right: 8,
            left: 8,
            child: Text(
              date.getTimeInFormat(FormatSettingsController.notifier.value.timeFormat),
              textAlign: isLtr ? TextAlign.right : TextAlign.left,
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ),
          ),
        ],
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          top: -8,
          right: 8,
          left: 8,
          child: Text(
            date.getTimeInFormat(FormatSettingsController.notifier.value.timeFormat),
            textAlign: isLtr ? TextAlign.right : TextAlign.left,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLtr = Directionality.of(context) == ui.TextDirection.ltr;
    final effectiveWidth = width ?? MediaQuery.of(context).size.width;
    // Allow event tiles to expand on wider layouts. MultiDayView here
    // displays 3 days, so divide available width accordingly and set
    // a reasonable minimum for max width.
    final maxEventWidth = max(120.0, effectiveWidth / 3);

    void showEventSummary(List<CalendarEventData> events, DateTime date) {
      final event = events.first;
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
                  format: FormatSettingsController.notifier.value.dateFormat,
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
    }

    void showLongTapNotice() {
      SnackBar snackBar = SnackBar(content: Text("on LongTap"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return ValueListenableBuilder<FormatSettings>(
      valueListenable: FormatSettingsController.notifier,
      builder: (context, formats, _) {
        final config = CalendarConfigurationProvider.of(context);
        return MultiDayView(
          key: state,
          stickyTimeSlot: CalendarConfigurationProvider.of(context).stickyTimeSlot,
          daysInView: config.multiDayDaysInView,
          pageStep: config.multiDayPageStep,
            dragSnapMinutes:
              config.multiDayDragSnapMinutes ?? config.dragSnapMinutes,
          heightPerMinute: config.multiDayHeightPerMinute,
          width: width,
          timeLineBuilder: (date) => _timeLineBuilder(date, isLtr),
          headerStringBuilder: (date, {secondaryDate}) =>
              _formatHeader(date, secondaryDate, formats),
          showLiveTimeLineInAllDays: true,
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
          eventTileBuilder: (date, events, boundary, startDuration, endDuration) {
            if (events.isEmpty) return SizedBox.shrink();
            final event = events.first;
            String formatTime(DateTime? dt) {
              if (dt == null) return '';
              return dt.getTimeInFormat(
                  FormatSettingsController.notifier.value.timeFormat);
            }

            final timePrefix = event.isFullDayEvent
                ? 'All day'
                : "${formatTime(event.startTime)} - ${formatTime(event.endTime)}";

            final fullDescription = [
              if (timePrefix.isNotEmpty) timePrefix,
              if (event.description?.isNotEmpty ?? false) event.description!,
            ].join("\n");

            return RoundedEventTile(
              borderRadius: BorderRadius.circular(10.0),
              title: event.title,
              totalEvents: events.length - 1,
              description: fullDescription,
              padding: EdgeInsets.all(10.0),
              backgroundColor: event.color,
              margin: EdgeInsets.all(2.0),
              titleStyle: event.titleStyle,
              descriptionStyle: event.descriptionStyle,
              onTap: () => showEventSummary(events, date),
              onLongPress: showLongTapNotice,
            );
          },
          eventArranger: SideEventArranger(maxWidth: maxEventWidth),
          timeLineWidth: 65,
          scrollPhysics: const BouncingScrollPhysics(),
          liveTimeIndicatorSettings: LiveTimeIndicatorSettings(
            color: Colors.redAccent,
            onlyShowToday: true,
            currentTimeProvider: () {
              return FormatSettingsController.applyTimezone(DateTime.now());
            },
          )
              .merge(config.multiDayLiveTimeIndicatorSettings),
          onEventTap: showEventSummary,
          onEventLongTap: (events, date) => showLongTapNotice(),
        );
      },
    );
  }
}
