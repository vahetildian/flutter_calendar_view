// Copyright (c) 2021 Simform Solutions. All rights reserved.
// Use of this source code is governed by a MIT-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../calendar_view.dart';
import '../components/_internal_components.dart';
import '../constants.dart';
import '../painters.dart';

/// [Widget] to display week view.
class MultiDayView<T extends Object?> extends StatefulWidget {
  /// Builder to build tile for events.
  final EventTileBuilder<T>? eventTileBuilder;

  /// Builder for timeline.
  final DateWidgetBuilder? timeLineBuilder;

  /// Header builder for week page header.
  ///
  /// If there are some configurations that is not directly available
  /// in [MultiDayView], override this to create your custom header or reuse,
  /// [CalendarPageHeader] | [DayPageHeader] | [MonthPageHeader] |
  /// [WeekPageHeader] widgets provided by this package with your custom
  /// configurations.
  ///
  final WeekPageHeaderBuilder? weekPageHeaderBuilder;

  /// Builds custom PressDetector widget
  ///
  /// If null, internal PressDetector will be used to handle onDateLongPress()
  ///
  final DetectorBuilder? weekDetectorBuilder;

  /// This function will generate dateString int the calendar header.
  /// Useful for I18n
  final StringProvider? headerStringBuilder;

  /// This function will generate the TimeString in the timeline.
  /// Useful for I18n
  final StringProvider? timeLineStringBuilder;

  /// This function will generate WeekDayString in the weekday.
  /// Useful for I18n
  final String Function(int)? weekDayStringBuilder;

  /// This function will generate WeekDayDateString in the weekday.
  /// Useful for I18n
  final String Function(int)? weekDayDateStringBuilder;

  /// Arrange events.
  final EventArranger<T>? eventArranger;

  /// Called whenever user changes week.
  final CalendarPageChangeCallBack? onPageChange;

  /// Minimum day to display in week view.
  ///
  /// In calendar first date of the week that contains this data will be
  /// minimum date.
  ///
  /// ex, If minDay is 16th March, 2022 then week containing this date will have
  /// dates from 14th to 20th (Monday to Sunday). adn 14th date will
  /// be the actual minimum date.
  final DateTime? minDay;

  /// Maximum day to display in week view.
  ///
  /// In calendar last date of the week that contains this data will be
  /// maximum date.
  ///
  /// ex, If maxDay is 16th March, 2022 then week containing this date will have
  /// dates from 14th to 20th (Monday to Sunday). adn 20th date will
  /// be the actual maximum date.
  final DateTime? maxDay;

  /// Initial week to display in week view.
  final DateTime? initialDay;

  /// Settings for hour indicator settings.
  final HourIndicatorSettings? hourIndicatorSettings;

  /// A funtion that returns a [CustomPainter].
  ///
  /// Use this if you want to paint custom hour lines.
  final CustomHourLinePainter? hourLinePainter;

  /// Settings for half hour indicator settings.
  final HourIndicatorSettings? halfHourIndicatorSettings;

  /// Settings for quarter hour indicator settings.
  final HourIndicatorSettings? quarterHourIndicatorSettings;

  /// Settings for live time indicator settings.
  final LiveTimeIndicatorSettings? liveTimeIndicatorSettings;

  /// duration for page transition while changing the week.
  final Duration pageTransitionDuration;

  /// Transition curve for transition.
  final Curve pageTransitionCurve;

  /// Controller for Week view thia will refresh view when user adds or removes
  /// event from controller.
  final EventController<T>? controller;

  /// Defines height occupied by one minute of time span. This parameter will
  /// be used to calculate total height of Week view.
  final double heightPerMinute;

  /// Width of time line.
  final double? timeLineWidth;

  /// Flag to show live time indicator in all day or only [initialDay]
  final bool showLiveTimeLineInAllDays;

  /// Offset of time line
  final double timeLineOffset;

  /// Width of week view. If null provided device width will be considered.
  final double? width;

  /// If true this will display vertical lines between each day.
  final bool showVerticalLines;

  /// Height of week day title,
  final double weekTitleHeight;

  /// Builder to build week day.
  final DateWidgetBuilder? weekDayBuilder;

  /// Builder to build week number.
  final WeekNumberBuilder? weekNumberBuilder;

  /// Background color of week view page.
  final Color? backgroundColor;

  /// Scroll offset of week view page.
  final double scrollOffset;

  /// This method will be called when user taps on timestamp in timeline.
  final TimestampCallback? onTimestampTap;

  /// Called when user taps on event tile.
  final CellTapCallback<T>? onEventTap;

  /// Called when user long press on event tile.
  final CellTapCallback<T>? onEventLongTap;

  /// Called when user double taps on any event tile.
  final CellTapCallback<T>? onEventDoubleTap;

  /// This method will be called when user long press on calendar.
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

  /// Style for MultiDayView header.
  final HeaderStyle? headerStyle;

  /// Option for SafeArea.
  final SafeAreaOption safeAreaOption;

  /// Display full day event builder.
  final FullDayEventBuilder<T>? fullDayEventBuilder;

  /// First hour displayed in the layout, goes from 0 to 24
  final int startHour;

  /// This field will be used to set end hour for week view
  final int endHour;

  ///Show half hour indicator
  final bool showHalfHours;

  ///Show quarter hour indicator
  final bool showQuarterHours;

  /// If true, drag/drop times snap to nearest 5-minute slot.
  final bool stickyTimeSlot;

  /// Minute interval for sticky drag-and-drop snapping.
  ///
  /// Used only when [stickyTimeSlot] is true.
  final int dragSnapMinutes;

  ///Emulates offset of vertical line from hour line starts.
  final double emulateVerticalOffsetBy;

  /// Callback for the Header title
  final HeaderTitleCallback? onHeaderTitleTap;

  /// If true this will show week day at bottom position.
  final bool showWeekDayAtBottom;

  /// Use this field to disable the calendar scrolling
  final ScrollPhysics? scrollPhysics;

  /// Defines scroll physics for a page of a week view.
  ///
  /// This can be used to disable the horizontal scroll of a page.
  final ScrollPhysics? pageViewPhysics;

  /// Title of the full day events row
  final String fullDayHeaderTitle;

  /// Defines full day events header text config
  final FullDayHeaderTextConfig? fullDayHeaderTextConfig;

  /// Flag to keep scrollOffset of pages on page change
  final bool keepScrollOffset;

  /// Number of days to display in the view, Default to 3 days.
  final int daysInView;

  /// Number of days to step when changing pages.
  ///
  /// If null, defaults to [daysInView].
  final int? pageStep;

  /// Display workday bottom line
  final bool showWeekDayBottomLine;

  /// Main widget for week view.
  const MultiDayView({
    Key? key,
    this.controller,
    this.eventTileBuilder,
    this.pageTransitionDuration = const Duration(milliseconds: 300),
    this.pageTransitionCurve = Curves.ease,
    this.heightPerMinute = 1,
    this.timeLineOffset = 0,
    this.showLiveTimeLineInAllDays = false,
    this.showVerticalLines = true,
    this.width,
    this.minDay,
    this.maxDay,
    this.initialDay,
    this.hourIndicatorSettings,
    this.hourLinePainter,
    this.halfHourIndicatorSettings,
    this.quarterHourIndicatorSettings,
    this.timeLineBuilder,
    this.timeLineWidth,
    this.liveTimeIndicatorSettings,
    this.onPageChange,
    this.weekPageHeaderBuilder,
    this.eventArranger,
    this.weekTitleHeight = 50,
    this.weekDayBuilder,
    this.weekNumberBuilder,
    this.backgroundColor,
    this.scrollPhysics,
    this.scrollOffset = 0.0,
    this.onEventTap,
    this.onEventLongTap,
    this.onDateLongPress,
    this.onDateTap,
    this.minuteSlotSize = MinuteSlotSize.minutes60,
    this.weekDetectorBuilder,
    this.headerStringBuilder,
    this.timeLineStringBuilder,
    this.weekDayStringBuilder,
    this.weekDayDateStringBuilder,
    this.headerStyle,
    this.safeAreaOption = const SafeAreaOption(),
    this.fullDayEventBuilder,
    this.startHour = 0,
    this.onHeaderTitleTap,
    this.showHalfHours = false,
    this.showQuarterHours = false,
    this.stickyTimeSlot = true,
    this.emulateVerticalOffsetBy = 0,
    this.showWeekDayAtBottom = false,
    this.pageViewPhysics,
    this.onEventDoubleTap,
    this.endHour = Constants.hoursADay,
    this.fullDayHeaderTitle = '',
    this.fullDayHeaderTextConfig,
    this.keepScrollOffset = false,
    this.onTimestampTap,
    this.daysInView = 3,
    this.pageStep,
    this.dragSnapMinutes = 5,
    this.showWeekDayBottomLine = true,
  })  : assert(!(onHeaderTitleTap != null && weekPageHeaderBuilder != null),
            "can't use [onHeaderTitleTap] & [weekPageHeaderBuilder] simultaneously"),
        assert((timeLineOffset) >= 0,
            "timeLineOffset must be greater than or equal to 0"),
        assert(width == null || width > 0,
            "Calendar width must be greater than 0."),
        assert(timeLineWidth == null || timeLineWidth > 0,
            "Time line width must be greater than 0."),
        assert(
            heightPerMinute > 0, "Height per minute must be greater than 0."),
        assert(
          weekDetectorBuilder == null || onDateLongPress == null,
          """If you use [weekPressDetectorBuilder] 
          do not provide [onDateLongPress]""",
        ),
        assert(
          startHour <= 0 || startHour != endHour,
          "startHour must be greater than 0 or startHour should not equal to endHour",
        ),
        assert(
          endHour <= Constants.hoursADay || endHour < startHour,
          "End hour must be less than 24 or startHour must be less than endHour",
        ),
        assert(daysInView > 0, "daysInView must be greater than 0"),
        assert(pageStep == null || pageStep > 0,
            "pageStep must be greater than 0"),
        assert(dragSnapMinutes > 0,
            "dragSnapMinutes must be greater than 0"),
        super(key: key);

  @override
  MultiDayViewState<T> createState() => MultiDayViewState<T>();
}

class MultiDayViewState<T extends Object?> extends State<MultiDayView<T>> {
    /// Public getter for minimum date
    DateTime get minDate => _minDate;

    /// Public getter for maximum date
    DateTime get maxDate => _maxDate;
  late double _width;
  late double _height;
  late double _timeLineWidth;
  late double _hourHeight;
  late DateTime _currentStartDate;
  late DateTime _currentEndDate;
  late DateTime _maxDate;
  late DateTime _minDate;
  late DateTime _currentWeek;
  late int _totalWeeks;
  late int _currentIndex;
  late String _fullDayHeaderTitle;

  late EventArranger<T> _eventArranger;

  late HourIndicatorSettings _hourIndicatorSettings;
  late CustomHourLinePainter _hourLinePainter;

  late HourIndicatorSettings _halfHourIndicatorSettings;
  late LiveTimeIndicatorSettings _liveTimeIndicatorSettings;
  late HourIndicatorSettings _quarterHourIndicatorSettings;

  late PageController _pageController;

  late DateWidgetBuilder _timeLineBuilder;
  late EventTileBuilder<T> _eventTileBuilder;
  late WeekPageHeaderBuilder _weekHeaderBuilder;
  late DateWidgetBuilder _weekDayBuilder;
  late WeekNumberBuilder _weekNumberBuilder;
  late FullDayEventBuilder<T> _fullDayEventBuilder;
  late DetectorBuilder _weekDetectorBuilder;
  late FullDayHeaderTextConfig _fullDayHeaderTextConfig;

  late double _weekTitleWidth;
  late int _totalDaysInWeek;

  late VoidCallback _reloadCallback;

  final Map<int, GlobalKey> _dayColumnKeys = {};

  EventController<T>? _controller;

  late ScrollController _scrollController;

  ScrollController get scrollController => _scrollController;

  late List<WeekDays> _weekDays;

  late int _startHour;
  late int _endHour;

  final _scrollConfiguration = EventScrollConfiguration();

  int get _pageStep => widget.pageStep ?? widget.daysInView;

  int _pageStartOffsetDays = 0;

  double get _pageViewportFraction =>
      _pageStep == 1 ? 1 / widget.daysInView : 1.0;

  @override
  void initState() {
    super.initState();
    _scrollController =
        ScrollController(initialScrollOffset: widget.scrollOffset);

    _startHour = widget.startHour;
    _endHour = widget.endHour;

    _reloadCallback = _reload;

    _setWeekDays();
    _setDateRange();

    _currentWeek = (widget.initialDay ?? DateTime.now()).withoutTime;

    _regulateCurrentDate();

    _calculateHeights();

    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: _pageViewportFraction,
    );
    _eventArranger = widget.eventArranger ?? SideEventArranger<T>();

    _assignBuilders();
    _fullDayHeaderTitle = widget.fullDayHeaderTitle;
    _fullDayHeaderTextConfig =
        widget.fullDayHeaderTextConfig ?? FullDayHeaderTextConfig();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newController = widget.controller ??
        CalendarControllerProvider.of<T>(context).controller;

    if (_controller != newController) {
      _controller = newController;

      _controller!
        // Removes existing callback.
        ..removeListener(_reloadCallback)

        // Reloads the view if there is any change in controller or
        // user adds new events.
        ..addListener(_reloadCallback);
    }
  }

  @override
  void didUpdateWidget(MultiDayView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller.
    final newController = widget.controller ??
        CalendarControllerProvider.of<T>(context).controller;

    if (newController != _controller) {
      _controller?.removeListener(_reloadCallback);
      _controller = newController;
      _controller?.addListener(_reloadCallback);
    }

    _setWeekDays();

    // Update date range.
    if (widget.minDay != oldWidget.minDay ||
      widget.maxDay != oldWidget.maxDay ||
      widget.daysInView != oldWidget.daysInView ||
      widget.pageStep != oldWidget.pageStep) {
      _setDateRange();
      _regulateCurrentDate();
      // updateRange();

      _pageController.dispose();
      _pageController = PageController(
        initialPage: _currentIndex,
        viewportFraction: _pageViewportFraction,
      );
    }

    _eventArranger = widget.eventArranger ?? SideEventArranger<T>();
    _startHour = widget.startHour;
    _endHour = widget.endHour;

    // Update heights.
    _calculateHeights();

    // Update builders and callbacks
    _assignBuilders();

    if (widget.scrollOffset != oldWidget.scrollOffset) {
      _scrollController.jumpTo(widget.scrollOffset);
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_reloadCallback);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaWrapper(
      option: widget.safeAreaOption,
      child: LayoutBuilder(builder: (context, constraint) {
        _width = widget.width ?? constraint.maxWidth;
        _updateViewDimensions();
        final themeColor = context.multiDayViewTheme;
        final direction = Directionality.of(context);
        final visibleDates = _getVisibleDates();

        bool isValidDay(DateTime dayDate) {
          return !dayDate.isBefore(_minDate) &&
              !dayDate.isAfter(_maxDate) &&
              _weekDays.any(
                (weekDay) => weekDay.index + 1 == dayDate.weekday,
              );
        }

        Widget buildDayColumn(DateTime dayDate, int keyIndex) {
          final columnKey = _dayColumnKeys[keyIndex] ??= GlobalKey();
          return SizedBox(
            width: _weekTitleWidth,
            height: _height,
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(_weekTitleWidth, _height),
                  painter: _hourLinePainter(
                    themeColor.hourLineColor,
                    _hourIndicatorSettings.height,
                    0,
                    widget.heightPerMinute,
                    false,
                    0,
                    _hourIndicatorSettings.lineStyle,
                    _hourIndicatorSettings.dashWidth,
                    _hourIndicatorSettings.dashSpaceWidth,
                    widget.emulateVerticalOffsetBy,
                    _startHour,
                    _endHour,
                  ),
                ),
                if (widget.showHalfHours)
                  CustomPaint(
                    size: Size(_weekTitleWidth, _height),
                    painter: HalfHourLinePainter(
                      lineColor: themeColor.halfHourLineColor,
                      lineHeight: _halfHourIndicatorSettings.height,
                      offset: 0,
                      minuteHeight: widget.heightPerMinute,
                      lineStyle: _halfHourIndicatorSettings.lineStyle,
                      dashWidth: _halfHourIndicatorSettings.dashWidth,
                      dashSpaceWidth:
                          _halfHourIndicatorSettings.dashSpaceWidth,
                      startHour: _halfHourIndicatorSettings.startHour,
                      endHour: _endHour,
                      textDirection: direction,
                    ),
                  ),
                if (widget.showQuarterHours)
                  CustomPaint(
                    size: Size(_weekTitleWidth, _height),
                    painter: QuarterHourLinePainter(
                      lineColor: themeColor.quarterHourLineColor,
                      lineHeight: _quarterHourIndicatorSettings.height,
                      offset: 0,
                      minuteHeight: widget.heightPerMinute,
                      lineStyle: _quarterHourIndicatorSettings.lineStyle,
                      dashWidth: _quarterHourIndicatorSettings.dashWidth,
                      dashSpaceWidth:
                          _quarterHourIndicatorSettings.dashSpaceWidth,
                      textDirection: direction,
                    ),
                  ),
                Container(
                  key: columnKey,
                  decoration: widget.showVerticalLines
                      ? BoxDecoration(
                          border: Border(
                            right: direction == TextDirection.ltr
                                ? BorderSide(
                                    color: themeColor.verticalLinesColor,
                                    width: _hourIndicatorSettings.height,
                                  )
                                : BorderSide.none,
                            left: direction == TextDirection.rtl
                                ? BorderSide(
                                    color: themeColor.verticalLinesColor,
                                    width: _hourIndicatorSettings.height,
                                  )
                                : BorderSide.none,
                          ),
                        )
                      : null,
                  height: _height,
                  width: _weekTitleWidth,
                  child: Stack(
                    children: [
                      _weekDetectorBuilder(
                        width: _weekTitleWidth,
                        height: _height,
                        heightPerMinute: widget.heightPerMinute,
                        date: dayDate,
                        minuteSlotSize: widget.minuteSlotSize,
                      ),
                      EventGenerator<T>(
                        height: _height,
                        date: dayDate,
                        onTileTap: widget.onEventTap,
                        onTileLongTap: widget.onEventLongTap,
                        onTileDoubleTap: widget.onEventDoubleTap,
                        width: _weekTitleWidth,
                        eventArranger: _eventArranger,
                        eventTileBuilder: _eventTileBuilder,
                        scrollNotifier: _scrollConfiguration,
                        startHour: _startHour,
                        events: controller.getEventsOnDay(
                          dayDate,
                          includeFullDayEvents: false,
                        ),
                        heightPerMinute: widget.heightPerMinute,
                        endHour: _endHour,
                      ),
                      if (_showLiveTimeIndicator(visibleDates) &&
                          _liveTimeIndicatorSettings.height > 0 &&
                          dayDate.compareWithoutTime(DateTime.now()))
                        LiveTimeIndicator(
                          liveTimeIndicatorSettings:
                              _liveTimeIndicatorSettings.copyWith(
                            showTime: false,
                            showTimeBackgroundView: false,
                            showBullet: false,
                            lineStartInset:
                                -_weekTitleWidth * (widget.daysInView - 1),
                            lineEndInset: 0.0,
                            offset: 0.0,
                          ),
                          width: _weekTitleWidth,
                          height: _height,
                          heightPerMinute: widget.heightPerMinute,
                          timeLineWidth: 0,
                          startHour: _startHour,
                          endHour: _endHour,
                          isActivePage: true,
                        ),
                      Positioned.fill(
                        child: DragTarget<Map<String, dynamic>>(
                          onWillAcceptWithDetails: (_) => true,
                          onAcceptWithDetails: (details) {
                            final payload = details.data;
                            final event = payload['event']
                                as CalendarEventData<T>?;
                            final start = payload['start'] as DateTime?;
                            final end = payload['end'] as DateTime?;
                            if (event == null || start == null || end == null) {
                              return;
                            }

                            final renderObject = columnKey.currentContext
                                ?.findRenderObject();
                            if (renderObject is! RenderBox) {
                              return;
                            }

                            final localOffset = renderObject
                                .globalToLocal(details.offset);
                            final dy =
                                localOffset.dy.clamp(0.0, _height);
                            final totalMinutes =
                                (_endHour - _startHour) * 60;
                            final minutesFromTop =
                                (dy / _height) * totalMinutes;
                            var newStartMinutes =
                                (_startHour * 60) + minutesFromTop.round();
                            if (widget.stickyTimeSlot) {
                              final snap = widget.dragSnapMinutes;
                              final halfSnap = snap ~/ 2;
                              newStartMinutes =
                                  ((newStartMinutes + halfSnap) ~/ snap) *
                                      snap;
                            }

                            final newStart = DateTime(
                              dayDate.year,
                              dayDate.month,
                              dayDate.day,
                            ).add(Duration(minutes: newStartMinutes));

                            final duration = end.difference(start);
                            final newEnd = newStart.add(duration);

                            final DateTime newEndDate;
                            final DateTime adjustedNewEnd;
                            if (newEnd.day > newStart.day ||
                                (newEnd.day == 1 && newStart.day > 1)) {
                              if (newEnd.hour == 0 &&
                                  newEnd.minute == 0 &&
                                  newEnd.second == 0) {
                                adjustedNewEnd = newEnd
                                    .subtract(const Duration(seconds: 1));
                                newEndDate = DateTime(
                                  adjustedNewEnd.year,
                                  adjustedNewEnd.month,
                                  adjustedNewEnd.day,
                                );
                              } else {
                                adjustedNewEnd = newEnd;
                                newEndDate = DateTime(
                                  newEnd.year,
                                  newEnd.month,
                                  newEnd.day,
                                );
                              }
                            } else {
                              adjustedNewEnd = newEnd;
                              newEndDate = DateTime(
                                newStart.year,
                                newStart.month,
                                newStart.day,
                              );
                            }

                            final updated = event.copyWith(
                              date: dayDate,
                              startTime: newStart,
                              endTime: adjustedNewEnd,
                              endDate: newEndDate,
                            );

                            controller.update(event, updated);
                          },
                          builder: (context, candidate, rejected) {
                            return const SizedBox.expand();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return SizedBox(
          width: _width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _weekHeaderBuilder(
                _currentStartDate,
                _currentEndDate,
              ),
              ColoredBox(
                color: themeColor.multiDayTileColor,
                child: SizedBox(
                  width: _width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: widget.weekTitleHeight,
                        width: _timeLineWidth +
                            _hourIndicatorSettings.offset,
                        child: visibleDates.isEmpty
                            ? const SizedBox.shrink()
                            : _weekNumberBuilder.call(visibleDates[0]),
                      ),
                      ...List.generate(
                        visibleDates.length,
                        (index) => SizedBox(
                          height: widget.weekTitleHeight,
                          width: _weekTitleWidth,
                          child: _weekDayBuilder(
                            visibleDates[index],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              if (widget.showWeekDayBottomLine)
                Divider(
                  thickness: 1,
                  height: 1,
                  color: themeColor.borderColor,
                ),
              SizedBox(
                width: _width,
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
                        width: _timeLineWidth +
                            _hourIndicatorSettings.offset,
                        child: _fullDayHeaderTitle.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 1,
                                ),
                                child: Text(
                                  _fullDayHeaderTitle,
                                  textAlign:
                                      _fullDayHeaderTextConfig.textAlign,
                                  style: TextStyle(
                                    color: themeColor.multiDayTextColor,
                                  ),
                                  maxLines:
                                      _fullDayHeaderTextConfig.maxLines,
                                  overflow:
                                      _fullDayHeaderTextConfig.textOverflow,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                      ...List.generate(
                        visibleDates.length,
                        (index) {
                          final date = visibleDates[index];
                          final fullDayEventList =
                              controller.getFullDayEvent(date);
                          return Container(
                            width: _weekTitleWidth,
                            child: fullDayEventList.isEmpty
                                ? null
                                : _fullDayEventBuilder.call(
                                    fullDayEventList,
                                    date,
                                  ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: widget.backgroundColor ??
                        themeColor.pageBackgroundColor,
                  ),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: widget.scrollPhysics,
                    child: SizedBox(
                      height: _height,
                      width: _width,
                      child: Stack(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: _timeLineWidth +
                                    _hourIndicatorSettings.offset,
                                height: _height,
                                child: TimeLine(
                                  timeLineWidth: _timeLineWidth,
                                  hourHeight: _hourHeight,
                                  height: _height,
                                  timeLineOffset: widget.timeLineOffset,
                                  timeLineBuilder: _timeLineBuilder,
                                  startHour: _startHour,
                                  showHalfHours: widget.showHalfHours,
                                  showQuarterHours: widget.showQuarterHours,
                                  liveTimeIndicatorSettings:
                                      _liveTimeIndicatorSettings,
                                  endHour: _endHour,
                                  onTimestampTap: widget.onTimestampTap,
                                  isActivePage: true,
                                  hideOverlappingTimeLabel:
                                      _showLiveTimeIndicator(visibleDates),
                                ),
                              ),
                              SizedBox(
                                width: _weekTitleWidth * widget.daysInView,
                                height: _height,
                                child: PageView.builder(
                                  itemCount: _totalWeeks,
                                  controller: _pageController,
                                  physics: widget.pageViewPhysics,
                                  onPageChanged: _onPageChange,
                                  padEnds: false,
                                  itemBuilder: (_, index) {
                                    final date = _pageStartDateForIndex(index);
                                    if (date.isBefore(_minDate) ||
                                        date.isAfter(_maxDate)) {
                                      return const SizedBox.shrink();
                                    }
                                    return ValueListenableBuilder(
                                      valueListenable: _scrollConfiguration,
                                      builder: (_, __, ___) {
                                        if (_pageStep == 1) {
                                          if (!isValidDay(date)) {
                                            return SizedBox(
                                              width: _weekTitleWidth,
                                              height: _height,
                                            );
                                          }
                                          return buildDayColumn(date, index);
                                        }

                                        return SizedBox(
                                          width:
                                              _weekTitleWidth * widget.daysInView,
                                          height: _height,
                                          child: Row(
                                            children: List.generate(
                                              widget.daysInView,
                                              (dayOffset) {
                                                final dayDate = date
                                                    .add(Duration(days: dayOffset));
                                                if (!isValidDay(dayDate)) {
                                                  return SizedBox(
                                                    width: _weekTitleWidth,
                                                    height: _height,
                                                  );
                                                }

                                                final keyIndex =
                                                    (index * widget.daysInView) +
                                                        dayOffset;
                                                return buildDayColumn(
                                                    dayDate, keyIndex);
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          if (_showLiveTimeIndicator(visibleDates) &&
                              _liveTimeIndicatorSettings.height > 0)
                            LiveTimeIndicator(
                              liveTimeIndicatorSettings:
                                  _liveTimeIndicatorSettings.copyWith(
                                lineStartInset: 0.0,
                                lineEndInset: 0.0,
                              ),
                              width: _width,
                              height: _height,
                              heightPerMinute: widget.heightPerMinute,
                              timeLineWidth:
                                  _timeLineWidth + _hourIndicatorSettings.offset,
                              startHour: _startHour,
                              endHour: _endHour,
                              isActivePage: true,
                              onlyShowToday: true,
                              showLine: false,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Returns [EventController] associated with this Widget.
  ///
  /// This will throw [AssertionError] if controller is called before its
  /// initialization is complete.
  EventController<T> get controller {
    if (_controller == null) {
      throw "EventController is not initialized yet.";
    }

    return _controller!;
  }

  /// Reloads page.
  void _reload() {
    if (mounted) {
      setState(() {});
    }
  }

  void _setWeekDays() {
    _weekDays = WeekDays.values.toSet().toList();

    // if (!widget.showWeekends) {
    //   _weekDays
    //     ..remove(WeekDays.saturday)
    //     ..remove(WeekDays.sunday);
    // }

    assert(
        _weekDays.isNotEmpty,
        "weekDays can not be empty.\n"
        "Make sure you are providing weekdays in initialization of "
        "MultiDayView. or showWeekends is true if you are providing only "
        "saturday or sunday in weekDays.");
    _totalDaysInWeek = widget.daysInView;
  }

  void _updateViewDimensions() {
    final borderColor = context.multiDayViewTheme.borderColor;
    _timeLineWidth = widget.timeLineWidth ?? _width * 0.13;

    _liveTimeIndicatorSettings = widget.liveTimeIndicatorSettings ??
        LiveTimeIndicatorSettings(
          color: context.multiDayViewTheme.liveIndicatorColor,
          height: widget.heightPerMinute,
        );

    assert(_liveTimeIndicatorSettings.height < _hourHeight,
        "liveTimeIndicator height must be less than minuteHeight * 60");

    _hourIndicatorSettings = widget.hourIndicatorSettings ??
        HourIndicatorSettings(
          height: widget.heightPerMinute,
          color: borderColor,
          offset: 5,
        );

    assert(_hourIndicatorSettings.height < _hourHeight,
        "hourIndicator height must be less than minuteHeight * 60");

    _weekTitleWidth =
        (_width - _timeLineWidth - _hourIndicatorSettings.offset) /
            _totalDaysInWeek;

    _halfHourIndicatorSettings = widget.halfHourIndicatorSettings ??
        HourIndicatorSettings(
          height: widget.heightPerMinute,
          color: borderColor,
          offset: 5,
        );

    assert(_halfHourIndicatorSettings.height < _hourHeight,
        "halfHourIndicator height must be less than minuteHeight * 60");

    _quarterHourIndicatorSettings = widget.quarterHourIndicatorSettings ??
        HourIndicatorSettings(color: borderColor);

    assert(_quarterHourIndicatorSettings.height < _hourHeight,
        "quarterHourIndicator height must be less than minuteHeight * 60");
  }

  void _calculateHeights() {
    _hourHeight = widget.heightPerMinute * 60;
    _height = _hourHeight * (_endHour - _startHour);
  }

  void _assignBuilders() {
    _timeLineBuilder = widget.timeLineBuilder ?? _defaultTimeLineBuilder;
    _eventTileBuilder = widget.eventTileBuilder ?? _defaultEventTileBuilder;
    _weekHeaderBuilder =
        widget.weekPageHeaderBuilder ?? _defaultWeekPageHeaderBuilder;
    _weekDayBuilder = widget.weekDayBuilder ?? _defaultWeekDayBuilder;
    _weekDetectorBuilder =
        widget.weekDetectorBuilder ?? _defaultPressDetectorBuilder;
    _weekNumberBuilder = widget.weekNumberBuilder ?? _defaultWeekNumberBuilder;
    _fullDayEventBuilder =
        widget.fullDayEventBuilder ?? _defaultFullDayEventBuilder;
    _hourLinePainter = widget.hourLinePainter ?? _defaultHourLinePainter;
  }

  Widget _defaultFullDayEventBuilder(
      List<CalendarEventData<T>> events, DateTime dateTime) {
    return FullDayEventView(
      events: events,
      boxConstraints: BoxConstraints(maxHeight: 65),
      date: dateTime,
      onEventTap: widget.onEventTap,
      onEventDoubleTap: widget.onEventDoubleTap,
      onEventLongPress: widget.onEventLongTap,
    );
  }

  /// Sets the current date of this month.
  ///
  /// This method is used in initState and onUpdateWidget methods to
  /// regulate current date in Month view.
  ///
  /// If maximum and minimum dates are change then first call _setDateRange
  /// and then _regulateCurrentDate method.
  ///
  void _regulateCurrentDate() {
    if (_currentWeek.isBefore(_minDate)) {
      _currentWeek = _minDate;
    } else if (_currentWeek.isAfter(_maxDate)) {
      _currentWeek = _maxDate;
    }
    _currentStartDate = _currentWeek;
    _currentEndDate = _currentStartDate
        .add(Duration(days: (widget.daysInView - 1)));
    _currentIndex = _getPageIndexForDate(_currentWeek);
  }

  /// Sets the minimum and maximum dates for current view.
  void _setDateRange() {
    _minDate = (widget.minDay ?? CalendarConstants.epochDate)
        .firstDayOfMultiDay(
            startDate: (widget.minDay ?? CalendarConstants.epochDate),
            daysInView: widget.daysInView)
        .withoutTime;

    _maxDate = (widget.maxDay ?? CalendarConstants.maxDate)
        .lastDayOfMultiDay(
            endDate: (widget.maxDay ?? CalendarConstants.maxDate),
            daysInView: widget.daysInView)
        .withoutTime;

    assert(
      _minDate.isBefore(_maxDate),
      "Minimum date must be less than maximum date.\n"
      "Provided minimum date: $_minDate, maximum date: $_maxDate",
    );
    _normalizePageStartOffset();
    _totalWeeks = _calculateTotalPages();
  }

  int _calculateTotalPages() {
    final totalDays = _maxDate.difference(_minDate).inDays + 1;
    final totalDaysAfterOffset = totalDays - _pageStartOffsetDays;
    if (totalDaysAfterOffset <= 1) {
      return 1;
    }
    return ((totalDaysAfterOffset - 1) ~/ _pageStep) + 1;
  }

  int _getPageIndexForDate(DateTime date) {
    final normalizedDate = date.withoutTime;
    final daysFromMin =
        normalizedDate.difference(_minDate).inDays - _pageStartOffsetDays;
    final rawIndex = (daysFromMin / _pageStep).floor();
    final maxIndex = _totalWeeks - 1;
    if (rawIndex < 0) return 0;
    if (rawIndex > maxIndex) return maxIndex;
    return rawIndex;
  }

  DateTime _pageStartDateForIndex(int index) {
    return _minDate.add(
      Duration(days: (index * _pageStep) + _pageStartOffsetDays),
    );
  }

  void _normalizePageStartOffset() {
    if (_pageStep <= 1) {
      _pageStartOffsetDays = 0;
      return;
    }
    _pageStartOffsetDays = _pageStartOffsetDays % _pageStep;
    if (_pageStartOffsetDays < 0) {
      _pageStartOffsetDays += _pageStep;
    }
  }

  void _setPageStartOffsetForDate(DateTime date) {
    if (_pageStep <= 1) {
      _pageStartOffsetDays = 0;
      return;
    }
    final daysFromMin = date.withoutTime.difference(_minDate).inDays;
    _pageStartOffsetDays = daysFromMin % _pageStep;
    _normalizePageStartOffset();
  }

  /// Default press detector builder. This builder will be used if
  /// [widget.weekDetectorBuilder] is null.
  ///
  Widget _defaultPressDetectorBuilder({
    required DateTime date,
    required double height,
    required double width,
    required double heightPerMinute,
    required MinuteSlotSize minuteSlotSize,
  }) =>
      DefaultPressDetector(
        date: date,
        height: height,
        width: width,
        heightPerMinute: heightPerMinute,
        minuteSlotSize: minuteSlotSize,
        onDateTap: widget.onDateTap,
        onDateLongPress: widget.onDateLongPress,
        startHour: _startHour,
      );

  /// Default builder for week line.
  Widget _defaultWeekDayBuilder(DateTime date) {
    final textColor = context.multiDayViewTheme.multiDayTextColor;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.weekDayStringBuilder?.call(date.weekday - 1) ??
                PackageStrings.currentLocale.weekdays[date.weekday - 1],
            style: TextStyle(
              color: textColor,
            ),
          ),
          Text(
            widget.weekDayDateStringBuilder?.call(date.day) ??
                PackageStrings.localizeNumber(date.day),
            style: TextStyle(
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Default builder for week number.
  Widget _defaultWeekNumberBuilder(DateTime date) {
    final daysToAdd = DateTime.thursday - date.weekday;
    final thursday = daysToAdd > 0
        ? date.add(Duration(days: daysToAdd))
        : date.subtract(Duration(days: daysToAdd.abs()));
    final weekNumber =
        (date.difference(DateTime(thursday.year)).inDays / 7).floor() + 1;
    return Center(
      child: Text(
        PackageStrings.localizeNumber(weekNumber),
        style: TextStyle(
          color: context.multiDayViewTheme.multiDayTextColor,
        ),
      ),
    );
  }

  /// Default timeline builder this builder will be used if
  /// [widget.eventTileBuilder] is null
  ///
  Widget _defaultTimeLineBuilder(DateTime date) => DefaultTimeLineMark(
        date: date,
        timeStringBuilder: widget.timeLineStringBuilder,
        markingStyle: TextStyle(
          color: context.multiDayViewTheme.timelineTextColor,
          fontSize: 15.0,
        ),
      );

  /// Default timeline builder. This builder will be used if
  /// [widget.eventTileBuilder] is null
  Widget _defaultEventTileBuilder(
    DateTime date,
    List<CalendarEventData<T>> events,
    Rect boundary,
    DateTime startDuration,
    DateTime endDuration,
  ) =>
      DefaultEventTile(
        date: date,
        events: events,
        boundary: boundary,
        startDuration: startDuration,
        endDuration: endDuration,
        onTap: widget.onEventTap != null
            ? () => widget.onEventTap!.call(events, date)
            : null,
        onLongPress: widget.onEventLongTap != null
            ? () => widget.onEventLongTap!.call(events, date)
            : null,
        onDoubleTap: widget.onEventDoubleTap != null
            ? () => widget.onEventDoubleTap!.call(events, date)
            : null,
      );

  /// Default view header builder. This builder will be used if
  /// [widget.dayTitleBuilder] is null.
  Widget _defaultWeekPageHeaderBuilder(
    DateTime startDate,
    DateTime endDate,
  ) {
    final themeColors = context.multiDayViewTheme;
    return WeekPageHeader(
      startDate: _currentStartDate,
      endDate: _currentEndDate,
      onNextDay: nextPage,
      showNextIcon: endDate != _maxDate,
      onPreviousDay: previousPage,
      showPreviousIcon: startDate != _minDate,
      onTitleTapped: () async {
        if (widget.onHeaderTitleTap != null) {
          widget.onHeaderTitleTap!(startDate);
        } else {
          final selectedDate = await showDatePicker(
            context: context,
            initialDate: startDate,
            firstDate: _minDate,
            lastDate: _maxDate,
            locale: Locale(PackageStrings.selectedLocale),
          );

          if (selectedDate == null) return;
          _jumpToStartDate(selectedDate);
        }
      },
      headerStringBuilder: widget.headerStringBuilder,
      headerStyle: widget.headerStyle ??
          HeaderStyle(
            decoration: BoxDecoration(
              color: themeColors.headerBackgroundColor,
            ),
            leftIconConfig: IconDataConfig(
              color: themeColors.headerIconColor,
            ),
            rightIconConfig: IconDataConfig(
              color: themeColors.headerIconColor,
            ),
            headerTextStyle: TextStyle(
              color: themeColors.headerTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
    );
  }

  HourLinePainter _defaultHourLinePainter(
    Color lineColor,
    double lineHeight,
    double offset,
    double minuteHeight,
    bool showVerticalLine,
    double verticalLineOffset,
    LineStyle lineStyle,
    double dashWidth,
    double dashSpaceWidth,
    double emulateVerticalOffsetBy,
    int startHour,
    int endHour,
  ) {
    final directionality = Directionality.of(context);

    return HourLinePainter(
      lineColor: lineColor,
      lineHeight: lineHeight,
      offset: offset,
      minuteHeight: minuteHeight,
      verticalLineOffset: verticalLineOffset,
      showVerticalLine: showVerticalLine,
      lineStyle: lineStyle,
      dashWidth: dashWidth,
      dashSpaceWidth: dashSpaceWidth,
      emulateVerticalOffsetBy: emulateVerticalOffsetBy,
      startHour: startHour,
      endHour: endHour,
      timelineWidth: widget.timeLineWidth,
      textDirection: directionality,
    );
  }

  /// Called when user change page using any gesture or inbuilt functions.
  void _onPageChange(int index) {
    if (mounted) {
      setState(() {
        _currentStartDate = _pageStartDateForIndex(index);
        _currentEndDate =
            _currentStartDate.add(Duration(days: (widget.daysInView - 1)));
        _currentIndex = index;
      });
    }
    widget.onPageChange?.call(_currentStartDate, _currentIndex);
  }

  /// Animate to next page
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [DayView.pageTransitionDuration] and [DayView.pageTransitionCurve]
  /// respectively.
  void nextPage({Duration? duration, Curve? curve}) {
    _pageController.nextPage(
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }

  /// Animate to previous page
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [DayView.pageTransitionDuration] and [DayView.pageTransitionCurve]
  /// respectively.
  void previousPage({Duration? duration, Curve? curve}) {
    _pageController.previousPage(
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }

  /// Jumps to page number [page]
  ///
  ///
  void jumpToPage(int page) => _pageController.jumpToPage(page);

  /// Animate to page number [page].
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [DayView.pageTransitionDuration] and [DayView.pageTransitionCurve]
  /// respectively.
  Future<void> animateToPage(int page,
      {Duration? duration, Curve? curve}) async {
    await _pageController.animateToPage(page,
        duration: duration ?? widget.pageTransitionDuration,
        curve: curve ?? widget.pageTransitionCurve);
  }

  /// Returns current page number.
  int get currentPage => _currentIndex;

  /// Jumps to page which gives day calendar for [week]
  void jumpToWeek(DateTime week) {
    if (week.isBefore(_minDate) || week.isAfter(_maxDate)) {
      throw "Invalid date selected.";
    }

    final index = _getPageIndexForDate(week);
    _pageController.jumpToPage(index);
  }

  void _jumpToStartDate(DateTime date) {
    if (date.isBefore(_minDate) || date.isAfter(_maxDate)) {
      throw "Invalid date selected.";
    }

    setState(() {
      _setPageStartOffsetForDate(date);
      _totalWeeks = _calculateTotalPages();
      _currentStartDate = date.withoutTime;
      _currentEndDate = _currentStartDate
          .add(Duration(days: (widget.daysInView - 1)));
      _currentIndex = _getPageIndexForDate(date);
    });

    _pageController.jumpToPage(_currentIndex);
  }

  /// Animate to page which gives day calendar for [week].
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [MultiDayView.pageTransitionDuration] and [MultiDayView.pageTransitionCurve]
  /// respectively.
  Future<void> animateToWeek(DateTime week,
      {Duration? duration, Curve? curve}) async {
    if (week.isBefore(_minDate) || week.isAfter(_maxDate)) {
      throw "Invalid date selected.";
    }
    await _pageController.animateToPage(
      _getPageIndexForDate(week),
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }

  /// Returns the current visible week's first date.
  DateTime get currentDate => DateTime(
      _currentStartDate.year, _currentStartDate.month, _currentStartDate.day);

  /// Jumps to page which contains given events and make event
  /// tile visible to user.
  ///
  Future<void> jumpToEvent(CalendarEventData<T> event) async {
    jumpToWeek(event.date);

    await _scrollConfiguration.setScrollEvent(
      event: event,
      duration: Duration.zero,
      curve: Curves.ease,
    );
  }

  /// Animate to page which contains given events and make event
  /// tile visible to user.
  ///
  /// Arguments [duration] and [curve] will override default values provided
  /// as [DayView.pageTransitionDuration] and [DayView.pageTransitionCurve]
  /// respectively.
  ///
  /// Actual duration will be 2 times the given duration.
  ///
  /// Ex, If provided duration is 200 milliseconds then this function will take
  /// 200 milliseconds for animate to page then 200 milliseconds for
  /// scroll to event tile.
  ///
  ///
  Future<void> animateToEvent(CalendarEventData<T> event,
      {Duration? duration, Curve? curve}) async {
    await animateToWeek(event.date, duration: duration, curve: curve);
    await _scrollConfiguration.setScrollEvent(
      event: event,
      duration: duration ?? widget.pageTransitionDuration,
      curve: curve ?? widget.pageTransitionCurve,
    );
  }

  /// Animate to specific scroll controller offset
  void animateTo(
    double offset, {
    Duration duration = const Duration(milliseconds: 200),
    Curve curve = Curves.linear,
  }) {
    _scrollController.animateTo(
      offset,
      duration: duration,
      curve: curve,
    );
  }

  /// check if any dates contains current date or not.
  /// Returns true if it does else false.
  bool _showLiveTimeIndicator(List<DateTime> dates) =>
      dates.any((date) => date.compareWithoutTime(DateTime.now()));

  List<DateTime> _filteredDates(List<DateTime> dates) {
    final output = <DateTime>[];
    final weekDays = _weekDays.toList();

    for (final date in dates) {
      if (date.isBefore(_minDate) || date.isAfter(_maxDate)) {
        continue;
      }
      if (weekDays.any((weekDay) => weekDay.index + 1 == date.weekday)) {
        output.add(date);
      }
    }

    return output;
  }

  List<DateTime> _getVisibleDates() {
    final baseDates = List.generate(
      widget.daysInView,
      (i) => _currentStartDate.add(Duration(days: i)),
    );
    return _filteredDates(baseDates);
  }
}
