// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../calendar_view.dart';
import '../components/_internal_components.dart';
import '../painters.dart';

/// Defines a single day page.
class InternalDayViewPage<T extends Object?> extends StatefulWidget {
  /// Width of the page
  final double width;

  /// Height of the page.
  final double height;

  /// Date for which we are displaying page.
  final DateTime date;

  /// A builder that returns a widget to show event on screen.
  final EventTileBuilder<T> eventTileBuilder;

  /// Controller for calendar
  final EventController<T> controller;

  /// A builder that builds time line.
  final DateWidgetBuilder timeLineBuilder;

  /// Builds custom PressDetector widget
  final DetectorBuilder dayDetectorBuilder;

  /// Settings for hour indicator lines.
  final HourIndicatorSettings hourIndicatorSettings;

  /// Custom painter for hour line.
  final CustomHourLinePainter hourLinePainter;

  /// Flag to display live time indicator.
  /// If true then indicator will be displayed else not.
  final bool showLiveLine;

  /// Settings for live time indicator.
  final LiveTimeIndicatorSettings liveTimeIndicatorSettings;

  /// Height occupied by one minute of time span.
  final double heightPerMinute;

  /// Width of time line.
  final double timeLineWidth;

  /// Offset for time line widgets.
  final double timeLineOffset;

  /// Height occupied by one hour of time span.
  final double hourHeight;

  /// event arranger to arrange events.
  final EventArranger<T> eventArranger;

  /// Flag to display vertical line.
  final bool showVerticalLine;

  /// Offset  of vertical line.
  final double verticalLineOffset;

  /// Called when user taps on event tile.
  final CellTapCallback<T>? onTileTap;

  /// Called when user long press on event tile.
  final CellTapCallback<T>? onTileLongTap;

  /// Called when user double tap on any event tile.
  final CellTapCallback<T>? onTileDoubleTap;

  /// Called when user long press on calendar.
  final DatePressCallback? onDateLongPress;

  /// Called when user taps on day view page.
  ///
  /// This callback will have a date parameter which
  /// will provide the time span on which user has tapped.
  ///
  /// Ex, User Taps on Date page with date 11/01/2022 and time span is 1PM to 2PM.
  /// then DateTime object will be  DateTime(2022,01,11,1,0)
  final DateTapCallback? onDateTap;

  /// Defines size of the slots that provides long press callback on area
  /// where events are not there.
  final MinuteSlotSize minuteSlotSize;

  /// Notifies if there is any event that needs to be visible instantly.
  final EventScrollConfiguration scrollNotifier;

  /// Display full day events.
  final FullDayEventBuilder<T> fullDayEventBuilder;

  final ScrollController dayViewScrollController;

  /// Flag to display half hours.
  final bool showHalfHours;

  /// Flag to display quarter hours.
  final bool showQuarterHours;

  /// Settings for half hour indicator lines.
  final HourIndicatorSettings halfHourIndicatorSettings;

  /// First hour displayed in the layout
  final int startHour;

  /// Settings for half hour indicator lines.
  final HourIndicatorSettings quarterHourIndicatorSettings;

  /// Scroll listener to set every page's last offset
  final void Function(ScrollController) scrollListener;

  /// Last scroll offset of day view page.
  final double lastScrollOffset;

  /// Emulate vertical line offset from hour line starts.
  final double emulateVerticalOffsetBy;

  /// This field will be used to set end hour for day view
  final int endHour;

  /// Whether this page is the currently active page in the PageView.
  final bool isActivePage;

  /// Flag to keep scrollOffset of pages on page change
  final bool keepScrollOffset;

  /// If true, drag/drop times snap to nearest 5-minute slot.
  final bool stickyTimeSlot;

  /// Minute interval for sticky drag-and-drop snapping.
  ///
  /// Used only when [stickyTimeSlot] is true.
  final int dragSnapMinutes;

  /// Use this field to disable the calendar scrolling
  final ScrollPhysics? scrollPhysics;

  final TimestampCallback? onTimestampTap;

  /// Defines a single day page.
  const InternalDayViewPage({
    Key? key,
    required this.showVerticalLine,
    required this.width,
    required this.date,
    required this.eventTileBuilder,
    required this.controller,
    required this.timeLineBuilder,
    required this.hourIndicatorSettings,
    required this.hourLinePainter,
    required this.showLiveLine,
    required this.liveTimeIndicatorSettings,
    required this.heightPerMinute,
    required this.timeLineWidth,
    required this.timeLineOffset,
    required this.height,
    required this.hourHeight,
    required this.eventArranger,
    required this.verticalLineOffset,
    required this.onTileTap,
    required this.onTileLongTap,
    required this.onDateLongPress,
    required this.onDateTap,
    required this.minuteSlotSize,
    required this.scrollNotifier,
    required this.fullDayEventBuilder,
    required this.dayViewScrollController,
    required this.scrollPhysics,
    required this.scrollListener,
    this.lastScrollOffset = 0.0,
    required this.dayDetectorBuilder,
    required this.showHalfHours,
    required this.showQuarterHours,
    required this.halfHourIndicatorSettings,
    required this.startHour,
    required this.endHour,
    required this.quarterHourIndicatorSettings,
    required this.emulateVerticalOffsetBy,
    required this.onTileDoubleTap,
    required this.onTimestampTap,
    this.keepScrollOffset = false,
    this.isActivePage = true,
    this.stickyTimeSlot = true,
    this.dragSnapMinutes = 5,
  }) : super(key: key);

  @override
  _InternalDayViewPageState<T> createState() => _InternalDayViewPageState<T>();
}

class _InternalDayViewPageState<T extends Object?>
    extends State<InternalDayViewPage<T>> {
  late ScrollController scrollController;
  final GlobalKey _dayKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(
      initialScrollOffset: widget.lastScrollOffset,
    );
    scrollController.addListener(_scrollControllerListener);
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(_scrollControllerListener)
      ..dispose();
    super.dispose();
  }

  void _scrollControllerListener() {
    widget.scrollListener(scrollController);
  }

  @override
  Widget build(BuildContext context) {
    final fullDayEventList = widget.controller.getFullDayEvent(widget.date);
    final direction = Directionality.of(context);

    return Container(
      height: widget.height,
      width: widget.width,
      child: Column(
        children: [
          fullDayEventList.isEmpty
              ? SizedBox.shrink()
              : widget.fullDayEventBuilder(
                  widget.controller.getFullDayEvent(widget.date),
                  widget.date,
                ),
          Expanded(
            child: SingleChildScrollView(
              controller: widget.keepScrollOffset
                  ? scrollController
                  : (widget.isActivePage
                      ? widget.dayViewScrollController
                      : null),
              physics: widget.scrollPhysics,
              child: SizedBox(
                height: widget.height,
                width: widget.width,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(widget.width, widget.height),
                      painter: widget.hourLinePainter(
                        widget.hourIndicatorSettings.color,
                        widget.hourIndicatorSettings.height,
                        widget.timeLineWidth +
                            widget.hourIndicatorSettings.offset,
                        widget.heightPerMinute,
                        widget.showVerticalLine,
                        widget.verticalLineOffset,
                        widget.hourIndicatorSettings.lineStyle,
                        widget.hourIndicatorSettings.dashWidth,
                        widget.hourIndicatorSettings.dashSpaceWidth,
                        widget.emulateVerticalOffsetBy,
                        widget.startHour,
                        widget.endHour,
                      ),
                    ),
                    if (widget.showHalfHours)
                      CustomPaint(
                        size: Size(widget.width, widget.height),
                        painter: HalfHourLinePainter(
                          lineColor: widget.halfHourIndicatorSettings.color,
                          lineHeight: widget.halfHourIndicatorSettings.height,
                          offset: widget.timeLineWidth +
                              widget.halfHourIndicatorSettings.offset,
                          minuteHeight: widget.heightPerMinute,
                          lineStyle: widget.halfHourIndicatorSettings.lineStyle,
                          dashWidth: widget.halfHourIndicatorSettings.dashWidth,
                          dashSpaceWidth:
                              widget.halfHourIndicatorSettings.dashSpaceWidth,
                          startHour: widget.startHour,
                          endHour: widget.endHour,
                          textDirection: direction,
                        ),
                      ),
                    if (widget.showQuarterHours)
                      CustomPaint(
                        size: Size(widget.width, widget.height),
                        painter: QuarterHourLinePainter(
                          lineColor: widget.quarterHourIndicatorSettings.color,
                          lineHeight:
                              widget.quarterHourIndicatorSettings.height,
                          offset: widget.timeLineWidth +
                              widget.quarterHourIndicatorSettings.offset,
                          minuteHeight: widget.heightPerMinute,
                          lineStyle:
                              widget.quarterHourIndicatorSettings.lineStyle,
                          dashWidth:
                              widget.quarterHourIndicatorSettings.dashWidth,
                          dashSpaceWidth: widget
                              .quarterHourIndicatorSettings.dashSpaceWidth,
                          textDirection: direction,
                        ),
                      ),
                    widget.dayDetectorBuilder(
                      width: widget.width,
                      height: widget.height,
                      heightPerMinute: widget.heightPerMinute,
                      date: widget.date,
                      minuteSlotSize: widget.minuteSlotSize,
                    ),
                    Align(
                      alignment: direction == TextDirection.rtl
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: EventGenerator<T>(
                        height: widget.height,
                        date: widget.date,
                        onTileLongTap: widget.onTileLongTap,
                        onTileDoubleTap: widget.onTileDoubleTap,
                        onTileTap: widget.onTileTap,
                        eventArranger: widget.eventArranger,
                        events: widget.controller.getEventsOnDay(
                          widget.date,
                          includeFullDayEvents: false,
                        ),
                        heightPerMinute: widget.heightPerMinute,
                        eventTileBuilder: widget.eventTileBuilder,
                        scrollNotifier: widget.scrollNotifier,
                        startHour: widget.startHour,
                        endHour: widget.endHour,
                        width: widget.width -
                            widget.timeLineWidth -
                            widget.hourIndicatorSettings.offset -
                            widget.verticalLineOffset,
                      ),
                    ),
                    // Drop target overlay for day view — placed above events so
                    // it catches drops even when landing on top of event tiles.
                    Positioned.fill(
                      child: DragTarget<Map<String, dynamic>>(
                        builder: (context, candidateData, rejectedData) =>
                            IgnorePointer(
                          child: Container(
                            key: _dayKey,
                            color: Colors.transparent,
                          ),
                        ),
                        onWillAcceptWithDetails: (details) =>
                          details.data.containsKey('event'),
                        onAcceptWithDetails: (details) {
                          try {
                            final payload = details.data;
                            final payloadEvent = payload['event'] as CalendarEventData<T>;
                            final oldEvent = (payloadEvent.event is CalendarEventData<T>)
                                ? payloadEvent.event as CalendarEventData<T>
                                : payloadEvent;
                            final originalStart = payload['start'] as DateTime;
                            final originalEnd = payload['end'] as DateTime;
                            final occurrenceDateRaw = payload['occurrenceDate'] as DateTime?;
                            final occurrenceDate = occurrenceDateRaw?.withoutTime;

                          
                            final renderBox = _dayKey.currentContext?.findRenderObject() as RenderBox?;
                            if (renderBox == null) return;

                            final topLeft = renderBox.localToGlobal(Offset.zero);
                            final dy = details.offset.dy - topLeft.dy;

                            final totalMinutes = (widget.endHour - widget.startHour) * 60;
                            final minutesFromTop = (dy / widget.height * totalMinutes).round();

                            var newStartMinutes = widget.startHour * 60 + minutesFromTop;
                            if (widget.stickyTimeSlot) {
                              final snap = widget.dragSnapMinutes;
                              final halfSnap = snap ~/ 2;
                              newStartMinutes =
                                  ((newStartMinutes + halfSnap) ~/ snap) *
                                      snap;
                            }
                            final newStart = DateTime(
                              widget.date.year,
                              widget.date.month,
                              widget.date.day,
                            ).copyFromMinutes(newStartMinutes);

                            final duration = originalEnd.difference(originalStart);
                            final newEnd = newStart.add(duration);

                            // Calculate newEndDate accounting for events that span multiple days
                            DateTime newEndDate;
                            if (oldEvent.endDate != oldEvent.date) {
                              // Multi-day event: preserve the day span
                              final daySpan = oldEvent.endDate.difference(oldEvent.date).inDays;
                              newEndDate = DateTime(newStart.year, newStart.month, newStart.day).add(Duration(days: daySpan));
                            } else {
                              // Single-day event: check if newEnd crosses into the next day
                              if (newEnd.day != newStart.day) {
                                newEndDate = DateTime(newEnd.year, newEnd.month, newEnd.day);
                              } else {
                                newEndDate = DateTime(newStart.year, newStart.month, newStart.day);
                              }
                            }

                            RecurrenceSettings? updatedRecurrenceSettings;
                            if (oldEvent.isRecurringEvent && oldEvent.recurrenceSettings != null) {
                                final oldStartDate =
                                  (oldEvent.recurrenceSettings?.startDate ??
                                      oldEvent.date)
                                    .withoutTime;
                              final newStartDate = newStart.withoutTime;
                              final startDateDelta = newStartDate.difference(oldStartDate);
                              final oldRecurrenceEndDate = oldEvent.recurrenceSettings!.endDate;
                              final newRecurrenceEndDate = oldRecurrenceEndDate != null
                                  ? oldRecurrenceEndDate.add(startDateDelta)
                                  : null;

                              List<int>? newWeekdays;
                              if (oldEvent.recurrenceSettings!.frequency == RepeatFrequency.weekly) {
                                final dayShift = startDateDelta.inDays % 7;
                                newWeekdays = oldEvent.recurrenceSettings!.weekdays.map((weekday) {
                                  return (weekday + dayShift) % 7;
                                }).toList();
                              }

                              updatedRecurrenceSettings = oldEvent.recurrenceSettings!.copyWith(
                                startDate: newStartDate,
                                endDate: newRecurrenceEndDate,
                                weekdays: newWeekdays,
                              );
   }

                            final updated = oldEvent.copyWith(
                              date: newStart.withoutTime,
                              startTime: newStart,
                              endTime: newEnd,
                              endDate: newEndDate,
                              recurrenceSettings: updatedRecurrenceSettings ?? oldEvent.recurrenceSettings,
                            );

                      
                            widget.controller.update(oldEvent, updated);
                          } catch (_) {}
                        },
                      ),
                    ),
                    TimeLine(
                      height: widget.height,
                      hourHeight: widget.hourHeight,
                      timeLineBuilder: widget.timeLineBuilder,
                      timeLineOffset: widget.timeLineOffset,
                      timeLineWidth: widget.timeLineWidth,
                      showHalfHours: widget.showHalfHours,
                      startHour: widget.startHour,
                      endHour: widget.endHour,
                      showQuarterHours: widget.showQuarterHours,
                      key: ValueKey(widget.heightPerMinute),
                      liveTimeIndicatorSettings:
                          widget.liveTimeIndicatorSettings,
                      onTimestampTap: widget.onTimestampTap,
                      isActivePage: widget.isActivePage,
                      hideOverlappingTimeLabel: widget.showLiveLine,
                    ),
                    if (widget.showLiveLine &&
                        widget.liveTimeIndicatorSettings.height > 0)
                      IgnorePointer(
                        child: LiveTimeIndicator(
                          liveTimeIndicatorSettings:
                              widget.liveTimeIndicatorSettings,
                          width: widget.width,
                          height: widget.height,
                          heightPerMinute: widget.heightPerMinute,
                          timeLineWidth: widget.timeLineWidth,
                          startHour: widget.startHour,
                          endHour: widget.endHour,
                          isActivePage: widget.isActivePage,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
