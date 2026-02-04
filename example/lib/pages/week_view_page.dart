import 'package:flutter/material.dart';

import '../enumerations.dart';
import 'web/web_home_page.dart';

class WeekViewDemo extends StatefulWidget {
  const WeekViewDemo({super.key});

  @override
  _WeekViewDemoState createState() => _WeekViewDemoState();
}

class _WeekViewDemoState extends State<WeekViewDemo> {
  @override
  Widget build(BuildContext context) {
    return WebHomePage(
      selectedView: CalendarView.week,
      useConfigInitialView: false,
    );
  }
}
