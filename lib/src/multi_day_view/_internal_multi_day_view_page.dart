// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../calendar_view.dart';
import '../components/_internal_components.dart';
import '../painters.dart';

/// A single page for week view.
class InternalMultiDayViewPage<T extends Object?> extends StatefulWidget {
  /// Width of the page.
  final double width;

  /// Height of the page.
  final double height;

  /// Dates to display on page.
  final List<DateTime> dates;

  /// Builds tile for a single event.
  final EventTileBuilder<T> eventTileBuilder;

  /// A calendar controller that controls all the events and rebuilds widget
  /// if event(s) are added or removed.
  final EventController<T> controller;

  /// A builder to build time line.
  final DateWidgetBuilder timeLineBuilder;

  /// Settings for hour indicator lines.
  final HourIndicatorSettings hourIndicatorSettings;

  /// Custom painter for hour line.
  final CustomHourLinePainter hourLinePainter;

  /// Settings for half hour indicator lines.
  final HourIndicatorSettings halfHourIndicatorSettings;

  /// Settings for quarter hour indicator lines.
  final HourIndicatorSettings quarterHourIndicatorSettings;

  /// Flag to display live line.
  final bool showLiveLine;

  /// Settings for live time indicator.
  final LiveTimeIndicatorSettings liveTimeIndicatorSettings;

  ///  Height occupied by one minute time span.
  final double heightPerMinute;

  /// Width of timeline.
  final double timeLineWidth;

  /// Offset of timeline.
  final double timeLineOffset;

  /// Height occupied by one hour time span.
  final double hourHeight;

  /// Arranger to arrange events.
  final EventArranger<T> eventArranger;

  /// Flag to display vertical line or not.
  final bool showVerticalLine;

  /// Offset for vertical line offset.
  final double verticalLineOffset;

  /// Builder for week day title.
  final DateWidgetBuilder weekDayBuilder;

  /// Builder for week number.
  final WeekNumberBuilder weekNumberBuilder;

  /// Builds custom PressDetector widget
  final DetectorBuilder weekDetectorBuilder;

  /// Height of week title.
  final double weekTitleHeight;

  /// Width of week title.
  final double weekTitleWidth;

  /// Called when user taps on event tile.
  final CellTapCallback<T>? onTileTap;

  /// Called when user long press on event tile.
  final CellTapCallback<T>? onTileLongTap;

  /// Called when user double tap on any event tile.
  final CellTapCallback<T>? onTileDoubleTap;

  /// Defines which days should be displayed in one week.
  ///
  /// By default all the days will be visible.
  /// Sequence will be monday to sunday.
  final List<WeekDays> weekDays;

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

  final EventScrollConfiguration scrollConfiguration;

  /// Display full day events.
  final FullDayEventBuilder<T> fullDayEventBuilder;

  final ScrollController multiDayViewScrollController;

  /// Whether this page is the currently active page in the PageView.
  final bool isActivePage;

  /// First hour displayed in the layout
  final int startHour;

  /// If true this will show week day at bottom position.
  final bool showWeekDayAtBottom;

  /// Flag to display half hours
  final bool showHalfHours;

  /// Flag to display quarter hours
  final bool showQuarterHours;

  /// Display workday bottom line
  final bool showMutliDayBottomLine;

  /// Emulate vertical line offset from hour line starts.
  final double emulateVerticalOffsetBy;

  /// This field will be used to set end hour for week view
  final int endHour;

  /// Title of the full day events row
  final String fullDayHeaderTitle;

  /// Defines full day events header text config
  final FullDayHeaderTextConfig fullDayHeaderTextConfig;

  /// Scroll listener to set every page's last offset
  final void Function(ScrollController) scrollListener;

  /// Last scroll offset of week view page.
  final double lastScrollOffset;

  /// Flag to keep scrollOffset of pages on page change
  final bool keepScrollOffset;

  /// If true, drag/drop times snap to nearest 5-minute slot.
  final bool stickyTimeSlot;

  /// Use this field to disable the calendar scrolling
  final ScrollPhysics? scrollPhysics;

  /// This method will be called when user taps on timestamp in timeline.
  final TimestampCallback? onTimestampTap;

  /// A single page for multi-day view.
  InternalMultiDayViewPage({
    Key? key,
    required this.showVerticalLine,
    required this.weekTitleHeight,
    required this.weekDayBuilder,
    required this.weekNumberBuilder,
    required this.weekDetectorBuilder,
    required this.width,
    required this.dates,
    required this.eventTileBuilder,
    required this.controller,
    required this.timeLineBuilder,
    required this.hourIndicatorSettings,
    required this.hourLinePainter,
    required this.halfHourIndicatorSettings,
    required this.quarterHourIndicatorSettings,
    required this.showLiveLine,
    required this.liveTimeIndicatorSettings,
    required this.heightPerMinute,
    required this.timeLineWidth,
    required this.timeLineOffset,
    required this.height,
    required this.hourHeight,
    required this.eventArranger,
    required this.verticalLineOffset,
    required this.weekTitleWidth,
    required this.onTileTap,
    required this.onTileLongTap,
    required this.onTileDoubleTap,
    required this.weekDays,
    required this.onDateLongPress,
    required this.onDateTap,
    required this.minuteSlotSize,
    required this.scrollConfiguration,
    required this.fullDayEventBuilder,
    required this.multiDayViewScrollController,
    required this.isActivePage,
    required this.startHour,
    required this.showWeekDayAtBottom,
    required this.showHalfHours,
    required this.showQuarterHours,
    required this.showMutliDayBottomLine,
    required this.emulateVerticalOffsetBy,
    required this.endHour,
    required this.fullDayHeaderTextConfig,
    required this.scrollListener,
    required this.lastScrollOffset,
    required this.keepScrollOffset,
    required this.scrollPhysics,
    required this.onTimestampTap,
    this.stickyTimeSlot = true,
    this.fullDayHeaderTitle = '',
  }) : super(key: key);

  @override
  _InternalMultiDayViewPageState<T> createState() =>
      _InternalMultiDayViewPageState<T>();
  
  }

  class _InternalMultiDayViewPageState<T>
    extends State<InternalMultiDayViewPage<T>> {
  late ScrollController scrollController;
  late List<GlobalKey> _dayColumnKeys;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(
      initialScrollOffset: widget.lastScrollOffset,
    );
    scrollController.addListener(_scrollControllerListener);
    _dayColumnKeys = [];
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
    final filteredDates = _filteredDate();
    final themeColor = context.multiDayViewTheme;
    final direction = Directionality.of(context);

    return Container(
      height: widget.height + widget.weekTitleHeight,
      width: widget.width,
      child: Column(
        verticalDirection: widget.showWeekDayAtBottom
            ? VerticalDirection.up
            : VerticalDirection.down,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ColoredBox(
            color: themeColor.multiDayTileColor,
            child: SizedBox(
              width: widget.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: widget.weekTitleHeight,
                    width: widget.timeLineWidth +
                        widget.hourIndicatorSettings.offset,
                    child: widget.weekNumberBuilder.call(filteredDates[0]),
                  ),
                  ...List.generate(
                    filteredDates.length,
                    (index) => SizedBox(
                      height: widget.weekTitleHeight,
                      width: widget.weekTitleWidth,
                      child: widget.weekDayBuilder(
                        filteredDates[index],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          if (widget.showMutliDayBottomLine)
            Divider(
              thickness: 1,
              height: 1,
              color: themeColor.borderColor,
            ),
          SizedBox(
            width: widget.width,
            child: Container(
              decoration: BoxDecoration(
                      color: themeColor.pageBackgroundColor,
                border: Border(
                  bottom: BorderSide(
                    color: themeColor.borderColor,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: widget.timeLineWidth +
                        widget.hourIndicatorSettings.offset,
                    child: widget.fullDayHeaderTitle.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 1,
                            ),
                            child: Text(
                              widget.fullDayHeaderTitle,
                              textAlign:
                                  widget.fullDayHeaderTextConfig.textAlign,
                                   maxLines: widget.fullDayHeaderTextConfig.maxLines,
                                   overflow:
                                       widget.fullDayHeaderTextConfig.textOverflow,
                                   style: TextStyle(
                                     color: themeColor.multiDayTextColor,
                                   ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ),
                  ...List.generate(
                    filteredDates.length,
                    (index) {
                      final fullDayEventList = widget.controller
                          .getFullDayEvent(filteredDates[index]);
                      return Container(
                        width: widget.weekTitleWidth,
                        child: fullDayEventList.isEmpty
                            ? null
                            : widget.fullDayEventBuilder.call(
                                fullDayEventList,
                                widget.dates[index],
                              ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: widget.keepScrollOffset
                  ? scrollController
                  : (widget.isActivePage ? widget.multiDayViewScrollController : null),
              physics: widget.scrollPhysics,
              child: SizedBox(
                height: widget.height,
                width: widget.width,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(widget.width, widget.height),
                      painter: widget.hourLinePainter(
                        themeColor.hourLineColor,
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
                          lineColor: themeColor.halfHourLineColor,
                          lineHeight: widget.halfHourIndicatorSettings.height,
                          offset: widget.timeLineWidth +
                              widget.halfHourIndicatorSettings.offset,
                          minuteHeight: widget.heightPerMinute,
                          lineStyle: widget.halfHourIndicatorSettings.lineStyle,
                          dashWidth: widget.halfHourIndicatorSettings.dashWidth,
                          dashSpaceWidth:
                              widget.halfHourIndicatorSettings.dashSpaceWidth,
                          startHour: widget.halfHourIndicatorSettings.startHour,
                          endHour: widget.endHour,
                          textDirection: direction,
                        ),
                      ),
                    if (widget.showQuarterHours)
                      CustomPaint(
                        size: Size(widget.width, widget.height),
                        painter: QuarterHourLinePainter(
                          lineColor: themeColor.quarterHourLineColor,
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
                    Align(
                      alignment: direction == TextDirection.ltr
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: SizedBox(
                        width: widget.weekTitleWidth * filteredDates.length,
                        height: widget.height,
                        child: Row(
                          children: [
                              ...List.generate(
                                filteredDates.length,
                                (index) {
                                  if (_dayColumnKeys.length != filteredDates.length) {
                                    _dayColumnKeys = List.generate(
                                        filteredDates.length, (_) => GlobalKey());
                                  }
                                  return Container(
                                    key: _dayColumnKeys[index],
                                decoration: widget.showVerticalLine
                                    ? BoxDecoration(
                                        border: Border(
                                          right: direction == TextDirection.ltr
                                              ? BorderSide(
                                                  color: themeColor
                                                      .verticalLinesColor,
                                                  width: widget
                                                      .hourIndicatorSettings
                                                      .height,
                                                )
                                              : BorderSide.none,
                                          left: direction == TextDirection.rtl
                                              ? BorderSide(
                                                  color: themeColor
                                                      .verticalLinesColor,
                                                  width: widget
                                                      .hourIndicatorSettings
                                                      .height,
                                                )
                                              : BorderSide.none,
                                        ),
                                      )
                                    : null,
                                height: widget.height,
                                width: widget.weekTitleWidth,
                                child: Stack(
                                  children: [
                                    widget.weekDetectorBuilder(
                                      width: widget.weekTitleWidth,
                                      height: widget.height,
                                      heightPerMinute: widget.heightPerMinute,
                                      date: widget.dates[index],
                                      minuteSlotSize: widget.minuteSlotSize,
                                    ),
                                    EventGenerator<T>(
                                      height: widget.height,
                                      date: filteredDates[index],
                                      onTileTap: widget.onTileTap,
                                      onTileLongTap: widget.onTileLongTap,
                                      onTileDoubleTap: widget.onTileDoubleTap,
                                      width: widget.weekTitleWidth,
                                      eventArranger: widget.eventArranger,
                                      eventTileBuilder: widget.eventTileBuilder,
                                      scrollNotifier:
                                          widget.scrollConfiguration,
                                      startHour: widget.startHour,
                                      events: widget.controller.getEventsOnDay(
                                        filteredDates[index],
                                        includeFullDayEvents: false,
                                      ),
                                      heightPerMinute: widget.heightPerMinute,
                                      endHour: widget.endHour,
                                    ),
                                    DragTarget<Map<String, dynamic>>(
                                      onWillAccept: (data) => data != null,
                                      onAcceptWithDetails: (details) {
                                        final payload = details.data;
                                        final payloadEvent = payload['event'] as CalendarEventData<T>?;
                                        final start = payload['start'] as DateTime?;
                                        final end = payload['end'] as DateTime?;
                                        final occurrenceDate = payload['occurrenceDate'] as DateTime?;
                                        if (payloadEvent == null || start == null || end == null) return;

                                        final oldEvent = (payloadEvent.event is CalendarEventData<T>)
                                            ? payloadEvent.event as CalendarEventData<T>
                                            : payloadEvent;

                                        print('[MultiDayView Drag] ===== Drop Accepted =====');
                                        print('[MultiDayView Drag] Payload event: ${payloadEvent.title}');
                                        print('[MultiDayView Drag] Old event: ${oldEvent.title}, date=${oldEvent.date}, isRecurring=${oldEvent.isRecurringEvent}');
                                        if (oldEvent.recurrenceSettings != null) {
                                          print('[MultiDayView Drag] Recurrence settings: ${oldEvent.recurrenceSettings}');
                                        }

                                        final keyBox = _dayColumnKeys[index].currentContext?.findRenderObject() as RenderBox?;
                                        final box = keyBox ?? context.findRenderObject() as RenderBox;
                                        final topLeft = box.localToGlobal(Offset.zero);
                                        final dy = (details.offset.dy - topLeft.dy).clamp(0.0, widget.height);
                                        final totalMinutes = (widget.endHour - widget.startHour) * 60;
                                        final minutesFromTop = (dy / widget.height) * totalMinutes;
                                        var newStartMinutes =
                                            (widget.startHour * 60) + minutesFromTop.round();
                                        if (widget.stickyTimeSlot) {
                                          newStartMinutes = ((newStartMinutes + 2) ~/ 5) * 5;
                                        }

                                        final newStart = DateTime(
                                          widget.dates[index].year,
                                          widget.dates[index].month,
                                          widget.dates[index].day,
                                        ).add(Duration(minutes: newStartMinutes));

                                        final duration = end.difference(start);
                                        final newEnd = newStart.add(duration);

                                        print('[MultiDayView Drag] Calculated: newStart=$newStart, newEnd=$newEnd, duration=$duration');
                                        print('[MultiDayView Drag] Day check: newStart.day=${newStart.day}, newEnd.day=${newEnd.day}');
                                        print('[MultiDayView Drag] newEnd time: hour=${newEnd.hour}, minute=${newEnd.minute}, second=${newEnd.second}');

                                        // Calculate newEndDate based on actual start/end times
                                        // Check if the actual times span into the next day
                                        final DateTime newEndDate;
                                        final DateTime adjustedNewEnd;
                                        if (newEnd.day > newStart.day || (newEnd.day == 1 && newStart.day > 1)) {
                                          // Event spans into next day
                                          // Special case: if newEnd is exactly midnight, it should end on current day at 23:59:59
                                          if (newEnd.hour == 0 && newEnd.minute == 0 && newEnd.second == 0) {
                                            // Event ends exactly at midnight - adjust to previous day
                                            adjustedNewEnd = newEnd.subtract(Duration(seconds: 1));
                                            newEndDate = DateTime(adjustedNewEnd.year, adjustedNewEnd.month, adjustedNewEnd.day);
                                          } else {
                                            adjustedNewEnd = newEnd;
                                            newEndDate = DateTime(newEnd.year, newEnd.month, newEnd.day);
                                          }
                                        } else {
                                          // Single-day event
                                          adjustedNewEnd = newEnd;
                                          newEndDate = DateTime(newStart.year, newStart.month, newStart.day);
                                        }

                                        RecurrenceSettings? updatedRecurrenceSettings;
                                        if (oldEvent.isRecurringEvent && oldEvent.recurrenceSettings != null) {
                                          final oldStartDate = (occurrenceDate ?? oldEvent.date).withoutTime;
                                          final newStartDate = widget.dates[index].withoutTime;
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
                                            print('[MultiDayView Drag] Shifting weekdays by $dayShift');
                                            print('[MultiDayView Drag] Old weekdays: ${oldEvent.recurrenceSettings!.weekdays}, new: $newWeekdays');
                                          }

                                          updatedRecurrenceSettings = oldEvent.recurrenceSettings!.copyWith(
                                            startDate: newStartDate,
                                            endDate: newRecurrenceEndDate,
                                            weekdays: newWeekdays,
                                          );

                                          print('[MultiDayView Drag] Occurrence date: $occurrenceDate');
                                          print('[MultiDayView Drag] Old recurrence start: $oldStartDate, new: $newStartDate');
                                          print('[MultiDayView Drag] Old recurrence end: $oldRecurrenceEndDate, new: $newRecurrenceEndDate');
                                        }

                                        final updated = oldEvent.copyWith(
                                          date: widget.dates[index],
                                          startTime: newStart,
                                          endTime: adjustedNewEnd,
                                          endDate: newEndDate,
                                          recurrenceSettings: updatedRecurrenceSettings ?? oldEvent.recurrenceSettings,
                                        );

                                        print('[MultiDayView Drag] Updated event: ${updated.title}, date=${updated.date}, isRecurring=${updated.isRecurringEvent}');

                                        widget.controller.update(oldEvent, updated);
                                      },
                                      builder: (context, candidate, rejected) {
                                        return IgnorePointer(
                                          child: Container(
                                            color: Colors.transparent,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    TimeLine(
                      timeLineWidth: widget.timeLineWidth,
                      hourHeight: widget.hourHeight,
                      height: widget.height,
                      timeLineOffset: widget.timeLineOffset,
                      timeLineBuilder: widget.timeLineBuilder,
                      startHour: widget.startHour,
                      showHalfHours: widget.showHalfHours,
                      showQuarterHours: widget.showQuarterHours,
                      liveTimeIndicatorSettings:
                          widget.liveTimeIndicatorSettings,
                      endHour: widget.endHour,
                      onTimestampTap: widget.onTimestampTap,
                      isActivePage: widget.isActivePage,
                    ),
                    if (widget.showLiveLine &&
                        widget.liveTimeIndicatorSettings.height > 0 &&
                        (!widget.liveTimeIndicatorSettings.onlyShowToday ||
                            filteredDates.any(
                              (date) =>
                                  DateUtils.isSameDay(date, DateTime.now()),
                            )))
                      LiveTimeIndicator(
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DateTime> _filteredDate() {
    final output = <DateTime>[];

    final weekDays = widget.weekDays.toList();

    for (final date in widget.dates) {
      if (weekDays.any((weekDay) => weekDay.index + 1 == date.weekday)) {
        output.add(date);
      }
    }

    return output;
  }
}
