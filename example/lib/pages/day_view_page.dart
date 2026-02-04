import 'package:flutter/material.dart';

import '../enumerations.dart';
import 'web/web_home_page.dart';

class DayViewPageDemo extends StatefulWidget {
  const DayViewPageDemo({super.key});

  @override
  _DayViewPageDemoState createState() => _DayViewPageDemoState();
}

class _DayViewPageDemoState extends State<DayViewPageDemo> {
  @override
  Widget build(BuildContext context) {
    return WebHomePage(
      selectedView: CalendarView.day,
      useConfigInitialView: false,
    );
  }
}
