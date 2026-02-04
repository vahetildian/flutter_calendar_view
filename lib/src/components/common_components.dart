// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../calendar_view.dart';
import '../constants.dart';

/// This will be used in day and week view
class DefaultPressDetector extends StatefulWidget {
  /// default press detector builder used in week and day view
  const DefaultPressDetector({
    required this.date,
    required this.height,
    required this.width,
    required this.heightPerMinute,
    required this.minuteSlotSize,
    this.onDateTap,
    this.onDateLongPress,
    this.startHour = 0,
  });

  final DateTime date;
  final double height;
  final double width;
  final double heightPerMinute;
  final MinuteSlotSize minuteSlotSize;
  final DateTapCallback? onDateTap;
  final DatePressCallback? onDateLongPress;
  final int startHour;

  @override
  State<DefaultPressDetector> createState() => _DefaultPressDetectorState();
}

class _DefaultPressDetectorState extends State<DefaultPressDetector> {
  Offset? _tapDownPosition;
  bool _longPressReady = false;
  static const double _maxMoveDistance = 6.0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final heightPerSlot = widget.minuteSlotSize.minutes * widget.heightPerMinute;
    final slots = (Constants.hoursADay * 60) ~/ widget.minuteSlotSize.minutes;

    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Stack(
        children: [
          for (int i = 0; i < slots; i++)
            Positioned(
              top: heightPerSlot * i,
              left: 0,
              right: 0,
              bottom: widget.height - (heightPerSlot * (i + 1)),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTapDown: (details) {
                  _tapDownPosition = details.localPosition;
                  _longPressReady = widget.onDateLongPress != null;
                },
                onTapUp: (details) {
                  if (!_longPressReady || _tapDownPosition == null) return;
                  final moved = (details.localPosition - _tapDownPosition!).distance;
                  if (moved > _maxMoveDistance) return;
                  final clickPosition = details.localPosition.dy;
                  final minutesOffset =
                      (clickPosition / widget.heightPerMinute).round();
                  widget.onDateLongPress?.call(
                    _getSlotDateTime(i, minutesOffset: minutesOffset),
                  );
                },
                onTapCancel: () {
                  _longPressReady = false;
                },
                child: SizedBox(
                  width: widget.width,
                  height: heightPerSlot,
                ),
              ),
            ),
        ],
      ),
    );
  }

  DateTime _getSlotDateTime(int slot, {int minutesOffset = 0}) {
    // Round to nearest 5-minute interval
    final roundedMinutesOffset = ((minutesOffset + 2) ~/ 5) * 5;
    final totalMinutes = (widget.minuteSlotSize.minutes * slot) +
        (widget.startHour * 60) +
        roundedMinutesOffset;
    final hour = totalMinutes ~/ 60;
    final minute = totalMinutes % 60;
    return DateTime(
      widget.date.year,
      widget.date.month,
      widget.date.day,
      hour,
      minute,
    );
  }
}

/// This will be used in day and week view
class DefaultEventTile<T> extends StatelessWidget {
  const DefaultEventTile({
    required this.date,
    required this.events,
    required this.boundary,
    required this.startDuration,
    required this.endDuration,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
  });

  final DateTime date;
  final List<CalendarEventData<T>> events;
  final Rect boundary;
  final DateTime startDuration;
  final DateTime endDuration;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    if (events.isNotEmpty) {
      final event = events[0];
      String _formatTime(DateTime? dt) {
        if (dt == null) return '';
        final hour12 = ((dt.hour - 1) % 12) + 1;
        final minute = dt.minute;
        final localizedHour = PackageStrings.localizeNumber(hour12);
        final localizedMinute = PackageStrings.localizeNumber(minute);
        final paddedMinute = minute < 10 ? '0$localizedMinute' : localizedMinute;
        if (minute != 0) {
          return "$localizedHour:$paddedMinute";
        }
        final suffix = dt.hour ~/ 12 == 0
            ? PackageStrings.currentLocale.am
            : PackageStrings.currentLocale.pm;
        return "$localizedHour $suffix";
      }

        final timePrefix = event.isFullDayEvent
          ? 'All day'
          : "${_formatTime(event.startTime)} - ${_formatTime(event.endTime)}";

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
        onTap: onTap,
        onLongPress: onLongPress,
        onDoubleTap: onDoubleTap,
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
