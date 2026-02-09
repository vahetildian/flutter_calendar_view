import 'package:flutter/material.dart';

import '../enumerations.dart';
import 'web/web_home_page.dart';

class YearViewDemo extends StatefulWidget {
  const YearViewDemo({super.key});

  @override
  _YearViewDemoState createState() => _YearViewDemoState();
}

class _YearViewDemoState extends State<YearViewDemo> {
  @override
  Widget build(BuildContext context) {
    return WebHomePage(
      selectedView: CalendarView.year,
      useConfigInitialView: false,
    );
  }
}
