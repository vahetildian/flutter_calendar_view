import 'package:flutter/material.dart';

import '../enumerations.dart';
import 'web/web_home_page.dart';

class MultiDayViewDemo extends StatefulWidget {
  const MultiDayViewDemo({super.key});

  @override
  _MultiDayViewDemoState createState() => _MultiDayViewDemoState();
}

class _MultiDayViewDemoState extends State<MultiDayViewDemo> {
  @override
  Widget build(BuildContext context) {
    return WebHomePage(
      selectedView: CalendarView.threeDays,
      useConfigInitialView: false,
    );
  }
}
