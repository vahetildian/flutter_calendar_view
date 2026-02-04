import 'package:flutter/material.dart';

import '../enumerations.dart';
import 'web/web_home_page.dart';

class MonthViewPageDemo extends StatefulWidget {
  const MonthViewPageDemo({super.key});

  @override
  _MonthViewPageDemoState createState() => _MonthViewPageDemoState();
}

class _MonthViewPageDemoState extends State<MonthViewPageDemo> {
  @override
  Widget build(BuildContext context) {
    return WebHomePage(
      selectedView: CalendarView.month,
      useConfigInitialView: false,
    );
  }
}
