import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

class RunPage extends StatefulWidget {
  const RunPage({Key key}) : super(key: key);

  @override
  _RunPageState createState() => _RunPageState();
}

class _RunPageState extends State<RunPage> {
  Position _currentPosition;
  double _distance = 10;
  double _sec = 1;
  double _pace = 10; //in kmh
  bool _timeStarted = false;
  bool _paused = true;
  Stopwatch stopwatch = new Stopwatch();

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
               stopwatch.elapsed.inMinutes.toString() + 's',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ],
    );
  }

  void _stopAndReset(){
    stopwatch.stop();
    stopwatch.reset();
  }

  void _startStopwatchAndUI(){
    stopwatch.start();
    setState(() {});
  }

  Widget _buildStartButton(){
    return MaterialButton(
      onPressed: () => _startStopwatchAndUI(),
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
      onPressed: () => stopwatch.isRunning == true ? stopwatch.stop() : stopwatch.start(),
      color: Colors.green[400],
      textColor: Colors.lightGreenAccent[200],
      child: _paused == true
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

  Widget _buildStopButton(){
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
    return stopwatch.isRunning == false
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: _buildInfoBar(),
        ),
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
        ),
        Divider(
          height: 1,
          color: Colors.black,
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: _buildButtonBar(),
          ),
        ),
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
