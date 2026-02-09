// Year view widget (clean, minimal, compile-safe implementation)
// Restores public YearViewState and jumpToYear API used by examples.

import 'dart:async';

// dart:math not required here
import 'package:flutter/material.dart';

import '../enumerations.dart';
import '../localization/package_locals.dart';
import '../theme/month_view_theme_data.dart';

class YearView extends StatefulWidget {
  final double? width;
  /// Threshold (in pixels) for switching to month-names-only display.
  final double monthNamesOnlyWidthThreshold;
  final EdgeInsets padding;
  final int monthsPerRow;
  final bool showYearLabel;
  final bool showMonthBorders;
  final bool showCurrentMonthBorder;
  final Color? currentMonthBorderColor;
  final Color? otherMonthsBorderColor;
  final Color? monthTileBorderColor;
  final TextStyle? yearLabelTextStyle;
  final TextStyle? monthLabelTextStyle;
  final TextStyle? weekdayTextStyle;
  final TextStyle? dayTextStyle;
  final DateTime? minYear;
  final DateTime? maxYear;
  final DateTime? initialYear;
  final ValueChanged<int>? onYearChanged;
  final Widget Function(DateTime)? headerBuilder;
  final Widget Function(int)? yearLabelBuilder;
  final Widget Function(int)? monthLabelBuilder;
  final void Function(DateTime)? onMonthTap;
  final bool showTodayCircle;
  final Color? todayCircleColor;
  final bool showMonthNamesOnly;
  final bool showMonthGrid;
  final WeekDays startDay;
  /// When true, keeps the YearView State alive when removed from the
  /// widget tree (used by hosts that want cached views).
  final bool keepAlive;
  /// Alignment for the year label shown above the months.
  /// Uses `TextAlign` values: `TextAlign.left`, `TextAlign.center`, `TextAlign.right`.
  final TextAlign yearLabelAlignment;
  /// Padding around the year label widget.
  final EdgeInsets? yearLabelPadding;
  /// Additional pixel offset applied when revealing a year. Positive
  /// values move the revealed top down; negative move it up.
  final double yearScrollOffset;
  /// Optional background color painted behind the year view content.
  final Color? backgroundColor;

  YearView({
    Key? key,
    this.width,
    this.padding = const EdgeInsets.all(8),
    this.monthsPerRow = 3,
    this.showYearLabel = true,
    this.showMonthBorders = false,
    this.showCurrentMonthBorder = true,
    this.currentMonthBorderColor,
    this.otherMonthsBorderColor,
    this.monthTileBorderColor,
    this.yearLabelTextStyle,
    this.monthLabelTextStyle,
    this.weekdayTextStyle,
    this.dayTextStyle,
    this.minYear,
    this.maxYear,
    DateTime? initialYear,
    this.onYearChanged,
    this.headerBuilder,
    this.yearLabelBuilder,
    this.monthLabelBuilder,
    this.onMonthTap,
    this.showTodayCircle = true,
    this.todayCircleColor,
    this.showMonthNamesOnly = false,
    this.showMonthGrid = true,
    this.startDay = WeekDays.monday,
    this.keepAlive = true,
    this.yearLabelAlignment = TextAlign.center,
    this.yearLabelPadding,
    this.yearScrollOffset = 0.0,
    this.backgroundColor,
    this.monthNamesOnlyWidthThreshold = 375.0,
  }) : initialYear = initialYear, super(key: key);

  @override
  YearViewState createState() => _YearViewState();
}

/// Public state type kept for external GlobalKey usage in examples.
class YearViewState extends State<YearView> {
  /// Jump to a particular year (DateTime.year used).
  /// Implemented in subclass.
  void jumpToYear(DateTime date) {}
  /// Jump to a particular month (convenience wrapper).
  void jumpToMonth(DateTime date) => jumpToYear(date);

  /// Currently visible year according to the YearView's state tracking.
  /// Hosts can read this to make navigation decisions.
  int? get currentYear => null;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _YearViewState extends YearViewState with AutomaticKeepAliveClientMixin<YearView> {
  late int _currentYear;
  late int _minYearInt;
  late int _maxYearInt;
  late double _width;
  late PageController _pageController;
  late int _totalYears;
  final Map<int, GlobalKey> _yearKeys = {};
  final GlobalKey _headerKey = GlobalKey();
  double? _lastBuildWidth;
  bool _hasScrolledToInitial = false;
  // Removed unused fields
  double? _itemExtent;

  static const List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
      _currentYear = widget.initialYear?.year ?? DateTime.now().year;
    _minYearInt = widget.minYear?.year ?? (_currentYear - 50);
    _maxYearInt = widget.maxYear?.year ?? (_currentYear + 50);
    for (int y = _minYearInt; y <= _maxYearInt; y++) {
      _yearKeys[y] = GlobalKey();
    }
    _totalYears = _maxYearInt - _minYearInt + 1;
    int initialPage = _currentYear - _minYearInt;
    if (initialPage < 0) initialPage = 0;
    if (initialPage > _totalYears - 1) initialPage = _totalYears - 1;
    _pageController = PageController(initialPage: initialPage);
  }

  void _measureItemExtent([int attempt = 0]) {
    // If already measured and still valid, skip.
    if (_itemExtent != null) return;
    // Prefer measuring the currently visible year; fall back to the min
    // year key. This increases the chance of finding a mounted RenderBox
    // during resize/rebuilds.
    final preferredKeys = [_yearKeys[_currentYear], _yearKeys[_minYearInt]];
    GlobalKey? sampleKey;
    for (final k in preferredKeys) {
      if (k != null && k.currentContext != null) {
        sampleKey = k;
        break;
      }
    }
    if (sampleKey == null) {
      // Try to find any available key as a last resort.
      for (final entry in _yearKeys.entries) {
        if (entry.value.currentContext != null) {
          sampleKey = entry.value;
          break;
        }
      }
    }
    if (sampleKey == null) {
      // If we couldn't find a mounted item yet, retry a few frames later.
      if (attempt < 3) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _measureItemExtent(attempt + 1));
      }
      return;
    }

    try {
      final ctx = sampleKey.currentContext!;
      final rb = ctx.findRenderObject() as RenderBox?;
      if (rb == null || !rb.hasSize) {
        if (attempt < 3) WidgetsBinding.instance.addPostFrameCallback((_) => _measureItemExtent(attempt + 1));
        return;
      }
      final newExtent = rb.size.height;
      _itemExtent = newExtent;
      // debugPrint removed
      // After measuring, align the current year so resize doesn't change
      // which year is visible. Use a jump to avoid animation during resize.
      final key = _yearKeys[_currentYear];
      if (key?.currentContext != null && _pageController.hasClients) {
        // Mark programmatic update to avoid listener churn.
        // Removed: _suspendScrollUpdates, _lastProgrammaticUpdate
        _revealYearTop(key, duration: Duration.zero).then((_) {
          // Removed: _lastProgrammaticUpdate, _suspendScrollUpdates
          // Re-measure once more in case layout adjusted during reveal.
          WidgetsBinding.instance.addPostFrameCallback((_) => _measureItemExtent(attempt + 1));
        });
      }
    } catch (_) {
      if (attempt < 3) WidgetsBinding.instance.addPostFrameCallback((_) => _measureItemExtent(attempt + 1));
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    int year = _minYearInt + page;
    if (year < _minYearInt) year = _minYearInt;
    if (year > _maxYearInt) year = _maxYearInt;
    if (year != _currentYear) {
      setState(() => _currentYear = year);
      try {
        widget.onYearChanged?.call(_currentYear);
      } catch (_) {}
    }
  }

  // Scroll-listener logic removed in favor of PageView-based paging.

  void _syncCurrentYearToScroll() {
    int page = _currentYear - _minYearInt;
    if (page < 0) page = 0;
    if (page > _totalYears - 1) page = _totalYears - 1;
    if (_pageController.hasClients && (_pageController.page?.round() ?? _pageController.initialPage) != page) {
      _pageController.jumpToPage(page);
    }
    try {
      widget.onYearChanged?.call(_currentYear);
    } catch (_) {}
  }

  // Page-based implementation does not use per-scroll visible candidate.

  // Debounced candidate handling removed for PageView implementation.

  void _applyCandidateImmediate(int? candidateYear) {
    // Intentionally clear any external debounce/candidate state (no-op
    // in this simplified implementation).
    if (candidateYear != null && candidateYear != _currentYear) {
      setState(() {
        _currentYear = candidateYear;
      });
      // debugPrint removed
      try {
        widget.onYearChanged?.call(_currentYear);
      } catch (_) {}
    }
  }

  // Per-scroll visible update removed; PageView onPageChanged drives updates.

  Future<void> _revealYearTop(GlobalKey? key, {Duration? duration}) async {
    if (key == null) return;
    final ctx = key.currentContext;
    if (ctx == null) return;
    try {
      // For page-based layout, find the year for this key and compute
      // the page index.
      int? targetYear;
      for (final entry in _yearKeys.entries) {
        if (entry.value == key) {
          targetYear = entry.key;
          break;
        }
      }
      if (targetYear == null) return;
      final int targetYearValue = targetYear;
      int targetPage = targetYearValue - _minYearInt;
      if (targetPage < 0) targetPage = 0;
      if (targetPage > _totalYears - 1) targetPage = _totalYears - 1;
      // Removed: _suspendScrollUpdates, _lastProgrammaticUpdate
      try {
        if (duration == null || duration == Duration.zero) {
          _pageController.jumpToPage(targetPage);
        } else {
          await _pageController.animateToPage(targetPage, duration: duration, curve: Curves.easeInOut);
        }
      } finally {
        // Removed: _suspendScrollUpdates, _lastProgrammaticUpdate
        _syncCurrentYearToScroll();
        // debugPrint removed
      }
      return;
    } catch (e) {
      // debugPrint removed
    }
  }

  @override
  Widget build(BuildContext context) {
    // Register keep-alive if requested by host.
    super.build(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        _width = widget.width ?? constraints.maxWidth;
        // If layout width changed (e.g. window resized), re-align the
        // currently visible year to the top so resizing doesn't leave
        // the view scrolled to a mid-year position. If width changed we
        // should re-measure item extents and re-align the visible year.
        if (_lastBuildWidth == null || (_lastBuildWidth! - _width).abs() > 0.5) {
          _lastBuildWidth = _width;
          // Invalidate cached item extent so we re-measure for new layout
          _itemExtent = null;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _measureItemExtent();
            _revealYearTop(_yearKeys[_currentYear], duration: Duration.zero).then((_) {
              _syncCurrentYearToScroll();
              // Run one more sync on the next frame to catch any late
              // layout adjustments so header and content remain consistent.
              WidgetsBinding.instance.addPostFrameCallback((_) => _syncCurrentYearToScroll());
            });
          });
        }
        final theme = Theme.of(context);
        final dividerColor = widget.monthTileBorderColor ?? theme.dividerColor;

        final yearLabelStyle = widget.yearLabelTextStyle ?? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600);
        final monthLabelStyle = widget.monthLabelTextStyle ?? theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);
        final weekdayTextStyle = widget.weekdayTextStyle ?? theme.textTheme.labelSmall?.copyWith(color: theme.hintColor);
        final dayTextStyle = widget.dayTextStyle ?? theme.textTheme.labelSmall;

        final totalYears = _maxYearInt - _minYearInt + 1;

        final headerWidget = widget.headerBuilder?.call(DateTime(_currentYear));

        Widget _buildYearPage(int year) {
          return SingleChildScrollView(
            key: _yearKeys[year],
            padding: const EdgeInsets.symmetric(vertical: 8),
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.showYearLabel)
                  Padding(
                    padding: widget.yearLabelPadding ?? const EdgeInsets.only(top: 8, bottom: 8),
                    child: Align(
                      alignment: (widget.yearLabelAlignment == TextAlign.left)
                          ? Alignment.centerLeft
                          : (widget.yearLabelAlignment == TextAlign.right)
                              ? Alignment.centerRight
                              : Alignment.center,
                      child: widget.yearLabelBuilder?.call(year) ?? Text('$year', style: widget.yearLabelTextStyle ?? yearLabelStyle),
                    ),
                  ),
                Padding(
                  padding: widget.padding,
                  child: Builder(builder: (context) {
                    // Compute a tile width so we can create fixed-width month
                    // tiles that are free to size vertically to their content.
                    final gaps = 6.0 * (widget.monthsPerRow - 1);
                    final available = (_width - widget.padding.horizontal - gaps).clamp(0.0, _width);
                    final tileWidth = (available / widget.monthsPerRow);
                    // Calculate the maximum number of week rows needed by any
                    // month in this year (5 or 6). Use that to size tiles
                    // exactly (avoid an extra unused row).
                    int maxRows = 0;
                    for (int m = 1; m <= 12; m++) {
                      final firstDay = DateTime(year, m, 1);
                      final daysInMonth = DateTime(year, m + 1, 0).day;
                      final leadingEmpty = (firstDay.weekday - widget.startDay.index - 1) % 7;
                      final totalCells = ((leadingEmpty + daysInMonth + 6) ~/ 7) * 7;
                      final rows = totalCells ~/ 7;
                      if (rows > maxRows) maxRows = rows;
                    }
                    if (maxRows <= 0) maxRows = 6;
                    final double cellSize = tileWidth / 7.0;
                    final double minHeightForDays = cellSize * maxRows;
                    // Estimate header reserve from the month label font size to
                    // avoid over-allocating vertical space.
                    final double labelFontSize = monthLabelStyle?.fontSize ?? 14.0;
                    final double headerReserve = labelFontSize + 8.0; // label + spacing
                    // Bottom padding inside the month tile; this must be
                    // accounted for in the computed tile height so the last
                    // row isn't clipped.
                    const double bottomPadding = 5.0;
                    final double tileHeight = (minHeightForDays + headerReserve + bottomPadding).clamp(cellSize * 3, double.infinity);

                    return Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: List.generate(12, (monthIndex) {
                        final month = monthIndex + 1;
                        return SizedBox(
                          width: tileWidth,
                          height: tileHeight,
                          child: _buildMonthTile(
                              context,
                              year,
                              month,
                              dividerColor,
                              monthLabelStyle,
                              weekdayTextStyle,
                              dayTextStyle),
                        );
                      }),
                    );
                  }),
                ),
              ],
            ),
          );
        }

        final pageView = PageView.builder(
          controller: _pageController,
          physics: const ClampingScrollPhysics(),
          onPageChanged: _onPageChanged,
          itemCount: totalYears,
          itemBuilder: (context, index) {
            final year = _minYearInt + index;
            return _buildYearPage(year);
          },
        );

        if (!_hasScrolledToInitial) {
          _hasScrolledToInitial = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_pageController.hasClients) {
              int page = _currentYear - _minYearInt;
              if (page < 0) page = 0;
              if (page > totalYears - 1) page = totalYears - 1;
              _pageController.jumpToPage(page);
            }
          });
        }

        final child = SizedBox(
          width: _width,
          height: constraints.maxHeight,
          child: headerWidget == null ? pageView : Column(children: [Container(key: _headerKey, child: headerWidget), Expanded(child: pageView)]),
        );
        return widget.backgroundColor != null
            ? Container(color: widget.backgroundColor, child: child)
            : child;
      },
    );
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  int? get currentYear => _currentYear;

  Widget _buildMonthTile(
    BuildContext context,
    int year,
    int month,
    Color dividerColor,
    TextStyle? monthLabelStyle,
    TextStyle? weekdayTextStyle,
    TextStyle? dayTextStyle,
  ) {
      final monthNameLabel = widget.monthLabelBuilder?.call(month);
      final monthName = _monthNames[(month - 1) % _monthNames.length];
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final leadingEmpty = (firstDay.weekday - widget.startDay.index - 1) % 7;
    final totalCells = ((leadingEmpty + daysInMonth + 6) ~/ 7) * 7;
    // localized weekday strings available via PackageStrings.currentLocale.weekdays
    final now = DateTime.now();
    final isCurrentMonth = now.year == year && now.month == month;
    final currentDay = now.day;
    final themeColors = Theme.of(context).extension<MonthViewThemeData>() ?? MonthViewThemeData.light();

    if (_width < widget.monthNamesOnlyWidthThreshold || widget.showMonthNamesOnly) {
      return InkWell(
        onTap: widget.onMonthTap != null ? () => widget.onMonthTap!(DateTime(year, month, 1)) : null,
        child: Container(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 5),
          decoration: BoxDecoration(
            border: widget.showMonthBorders || (isCurrentMonth && widget.showCurrentMonthBorder)
                ? Border.all(
                    color: isCurrentMonth && widget.showCurrentMonthBorder ? (widget.currentMonthBorderColor ?? themeColors.cellHighlightColor) : (widget.otherMonthsBorderColor ?? dividerColor),
                    width: isCurrentMonth && widget.showCurrentMonthBorder ? 2 : 1,
                  )
                : null,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
            child: monthNameLabel ?? Text(monthName, style: monthLabelStyle),
        ),
      );
    }
    return InkWell(
      onTap: widget.onMonthTap != null ? () => widget.onMonthTap!(DateTime(year, month, 1)) : null,
        child: Container(
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 5),
        decoration: BoxDecoration(
          border: widget.showMonthBorders || (isCurrentMonth && widget.showCurrentMonthBorder)
              ? Border.all(
                  color: isCurrentMonth && widget.showCurrentMonthBorder ? (widget.currentMonthBorderColor ?? themeColors.cellHighlightColor) : (widget.otherMonthsBorderColor ?? dividerColor),
                  width: isCurrentMonth && widget.showCurrentMonthBorder ? 2 : 1,
                )
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            monthNameLabel ?? Text(monthName, style: monthLabelStyle),
            const SizedBox(height: 4),
            Expanded(
              child: GridView.builder(
                shrinkWrap: false,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1),
                itemCount: totalCells,
                itemBuilder: (context, index) {
                  final dayNumber = index - leadingEmpty + 1;
                  if (index < leadingEmpty || dayNumber > daysInMonth) return const SizedBox.shrink();
                  final isToday = isCurrentMonth && dayNumber == currentDay;
                  return Center(
                    child: isToday && widget.showTodayCircle
                        ? CircleAvatar(
                            radius: 12,
                            backgroundColor: widget.todayCircleColor ?? themeColors.cellHighlightColor,
                            child: Text(PackageStrings.localizeNumber(dayNumber), style: dayTextStyle?.copyWith(color: Colors.white)),
                          )
                        : Text(PackageStrings.localizeNumber(dayNumber), style: dayTextStyle),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void jumpToYear(DateTime date) {
    final int targetYear = date.year < _minYearInt
        ? _minYearInt
        : (date.year > _maxYearInt ? _maxYearInt : date.year);
    final int index = targetYear - _minYearInt;
    if (!_pageController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) => jumpToYear(date));
      return;
    }
    final key = _yearKeys[targetYear];
    final ctx = key?.currentContext;
    // Cancel any pending candidate application so our optimistic update
    // isn't immediately overwritten by the debounce handler.
    // (no-op for current implementation)
    if (ctx != null) {
      // Optimistically update the header/year so the UI responds to the
      // user's tap immediately, then animate the scroll to align the
      // target year's top.
      _applyCandidateImmediate(targetYear);
      _revealYearTop(key, duration: const Duration(milliseconds: 300));
      return;
    }
    // Fallback: animate page controller to the calculated page index.
    int page = index;
    if (page < 0) page = 0;
    if (page > _totalYears - 1) page = _totalYears - 1;
    _applyCandidateImmediate(targetYear);
    // Removed: _suspendScrollUpdates, _lastProgrammaticUpdate
    _pageController.animateToPage(page, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut).whenComplete(() {
      WidgetsBinding.instance.addPostFrameCallback((_) => _syncCurrentYearToScroll());
    });
  }
}
