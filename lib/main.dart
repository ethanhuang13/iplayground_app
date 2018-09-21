import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:iplayground/about_page.dart';
import 'package:iplayground/schedule_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'iPlayground',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new PlaygroundHomePage(title: 'iPlayground'),
    );
  }
}

class PlaygroundHomePage extends StatefulWidget {
  PlaygroundHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PlaygroundHomePageState createState() => new _PlaygroundHomePageState();
}

class _PlaygroundHomePageState extends State<PlaygroundHomePage> {
  List<dynamic> day1 = [];
  List<dynamic> day2 = [];
  int selectedIndex = 0;

  void _loadSchedule() async {
    var scheduleString = await rootBundle.loadString('assets/schedule.json');
    Map schedule = json.decode(scheduleString);
    setState(() {
//      print(schedule);
      day1 = schedule["day_1"];
      day2 = schedule["day_2"];
    });
  }

  @override
  void initState() {
    super.initState();
    this._loadSchedule();
  }

  @override
  Widget build(BuildContext context) {
    var bottom = BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.schedule), title: Text('Day 1')),
        BottomNavigationBarItem(
            icon: Icon(Icons.schedule), title: Text('Day 2')),
        BottomNavigationBarItem(icon: Icon(Icons.info), title: Text('About')),
      ],
      onTap: (index) {
        this.setState(() {
          this.selectedIndex = index;
        });
      },
      currentIndex: this.selectedIndex,
    );
    final bodies = [
      SchedulePage(
        title: 'Day 1',
        schedule: day1,
      ),
      SchedulePage(
        title: 'Day 2',
        schedule: day2,
      ),
      AboutPage()
    ];

    return new Scaffold(
      body: bodies[selectedIndex],
      bottomNavigationBar: bottom,
    );
  }
}
