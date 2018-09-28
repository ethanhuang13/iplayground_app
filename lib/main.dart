import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:iplayground/about_page.dart';
import 'package:iplayground/main_error.dart';
import 'package:iplayground/main_loading.dart';
import 'package:iplayground/schedule_loader.dart';
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

enum _ViewState { initial, loading, error, loaded }

class _PlaygroundHomePageState extends State<PlaygroundHomePage> {
  _ViewState _viewState = _ViewState.initial;
  int _selectedIndex = 0;

  void _loadSession() async {
    ScheduleLoader.shared.didUpdate.listen((parser) {
      this.setState(() => this._viewState = _ViewState.loaded);
    });
    ScheduleLoader.shared.load();
  }

  @override
  void initState() {
    super.initState();
    this._loadSession();
  }

  TabController tabController;

  Widget buildPerfect(BuildContext context) {
    var bottom = CupertinoTabBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.schedule), title: Text('Day 1')),
        BottomNavigationBarItem(
            icon: Icon(Icons.schedule), title: Text('Day 2')),
        BottomNavigationBarItem(icon: Icon(Icons.info), title: Text('關於')),
      ],
      onTap: (index) {
        this.setState(() {
          this._selectedIndex = index;
        });
      },
      currentIndex: this._selectedIndex,
    );

    final stack = Stack(
      children: <Widget>[
        Offstage(
          offstage: this._selectedIndex != 0,
          child: SchedulePage(
            title: 'Day 1',
            schedule: ScheduleLoader.shared.day1,
          ),
        ),
        Offstage(
          offstage: this._selectedIndex != 1,
          child: SchedulePage(
            title: 'Day 2',
            schedule: ScheduleLoader.shared.day2,
          ),
        ),
        Offstage(offstage: this._selectedIndex != 2, child: AboutPage())
      ],
    );

    return new Scaffold(
      body: stack,
      bottomNavigationBar: bottom,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (this._viewState) {
      case _ViewState.initial:
      case _ViewState.loading:
        return MainLoading();
      case _ViewState.error:
        return MainError(onTap: () async => await ScheduleLoader.shared.load(),);
      default:
        break;
    }

    return this.buildPerfect(context);
  }
}
