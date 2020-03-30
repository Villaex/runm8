import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

class RunPage extends StatefulWidget {
  const RunPage({Key key}) : super(key: key);

  @override
  _RunPageState createState() => _RunPageState();
}

enum RunState { notStarted, running, paused, stopped }

class _RunPageState extends State<RunPage> {
  //calculations for speed etc
  Position _currentPosition;
  double _distance = 10;
  double _sec = 1;
  double _pace = 10; //in kmh

  //logical variables to allow navigation of buttons
  Stopwatch stopwatch;
  Duration _second = Duration(seconds: 1);
  Duration _duration;
  RunState _runState = RunState.notStarted;

  void _startTimer() {
    Timer(_second, _keepRunning);
  }

  void _keepRunning() {
    if (stopwatch.isRunning) {
      _startTimer();
    }
    setState(() {
      _duration = Duration(
          hours: stopwatch.elapsed.inHours,
          minutes: stopwatch.elapsed.inMinutes % 60,
          seconds: stopwatch.elapsed.inSeconds % 60);
    });
  }

  void _calculateDistance() async {
    double _distanceInMeters = await Geolocator().distanceBetween(49.148488,
        8.214469, _currentPosition.latitude, _currentPosition.longitude);
    _distanceInMeters = _distanceInMeters.floorToDouble();
    setState(() {
      _distance = _distanceInMeters;
    });
  }

  void _getCurrentPosition() async {
    Position _p = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      _currentPosition = _p;
    });
  }

  double _getPace() {
    _pace = ((_distance / _sec) * 3.6).floorToDouble();
    return _pace;
  }



  void _stopAndReset() {
    stopwatch.stop();
    stopwatch.reset();
    _duration = Duration(hours: 0, minutes: 0, seconds: 0);
    setState(() {
      _runState = RunState.stopped;
    });
  }

  void _startRun() {
    stopwatch.start();
    _startTimer();
    setState(() {
      _runState = RunState.running;
    });
  }

  void _pauseOrResumeRun() {
    if (_runState == RunState.running) {
      setState(() {
        _runState = RunState.paused;
      });
      stopwatch.stop();
    } else {
      setState(() {
        _runState = RunState.running;
      });
      stopwatch.start();
      _startTimer();
    }
  }

  Widget _buildStartButton() {
    stopwatch = new Stopwatch();
    return MaterialButton(
      onPressed: () => _startRun(),
      color: Colors.green[400],
      textColor: Colors.white,
      height: 30.0,
      child: Icon(
        Icons.play_arrow,
        size: 40,
      ),
      padding: EdgeInsets.all(12),
      shape: CircleBorder(),
    );
  }

  Widget _buildPauseButton() {
    return MaterialButton(
      onPressed: () => _pauseOrResumeRun(),
      color: Colors.green[400],
      textColor: Colors.lightGreenAccent[200],
      child: stopwatch.isRunning == true
          ? Icon(
              Icons.pause,
              size: 40,
            )
          : Icon(
              Icons.play_arrow,
              size: 40,
            ),
      padding: EdgeInsets.all(12),
      shape: CircleBorder(),
    );
  }

  Widget _buildStopButton() {
    return MaterialButton(
      onPressed: () => _stopAndReset(),
      color: Colors.red[600],
      textColor: Colors.red[200],
      child: Icon(
        Icons.stop,
        size: 40,
      ),
      padding: EdgeInsets.all(12),
      shape: CircleBorder(),
    );
  }

  Widget _buildButtonBar() {
    return _runState == RunState.notStarted || _runState == RunState.stopped
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildStartButton(),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildPauseButton(),
              _buildStopButton(),
            ],
          );
  }

  Widget _buildInfoBar() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
            alignment: Alignment.center,
            color: Colors.blue,
            child: Text(
              '$_distance m',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            alignment: Alignment.center,
            color: Colors.green,
            child: Text(
              _getPace().toString() + ' km/h',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            alignment: Alignment.center,
            color: Colors.red,
            child: Text(
              _duration == null
                  ? '0:00:00'
                  : _duration.toString().substring(0, 7),
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: _buildInfoBar(),
        ),//InfoBarExpanded
        Divider(
          height: 1,
          color: Colors.black,
        ),
        Expanded(
          flex: 4,
          child: Container(
            child: Text('Map'),
            color: Colors.blueGrey,
          ),
        ),//MapExpanded
        Divider(
          height: 1,
          color: Colors.black,
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: _buildButtonBar(),
          ),
        ),//ButtonBarExpanded
        /*Text(
            '49.148488, 8.214469',
          ),
          Text(
            'CurrentPos: ' + '$_currentPosition',
          ),
          Text(
            'Distance: ' + '$_distance' + 'm',
          ),
          Text(
            'Pace: ' + _getPace().toString() + 'km/h',
          ),
          MaterialButton(
            child: Text('calculate distance'),
            onPressed: _calculateDistance,
            color: Colors.amber[400],
          ),
          */
      ],
    );
  }
}
