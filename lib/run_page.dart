import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

class RunPage extends StatefulWidget {
  const RunPage({ Key key }) : super(key: key);

  @override
  _RunPageState createState() => _RunPageState();
}

class _RunPageState extends State<RunPage> {

  Position _currentPosition;
  double _distance = 0;
  double _sec = 1;
  double _pace = 0; //in kmh

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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '49.148488, 8.214469',
          ),
          Text(
            'CurrentPos: ' + '$_currentPosition',
          ),
          Text(
            'Distance: ' +  '$_distance' + 'm',
          ),
          Text(
            'Pace: ' + _getPace().toString() + 'km/h',
          ),
          MaterialButton(
            child: Text('calculate distance'),
            onPressed: _calculateDistance,
            color: Colors.amber[400],
          ),
          MaterialButton(
            onPressed: () {},
            color: Colors.green[400],
            textColor: Colors.lightGreenAccent[200],
            child: Icon(
              Icons.pause,
              size: 40,
            ),
            padding: EdgeInsets.all(12),
            shape: CircleBorder(),
          ),
          MaterialButton(
            onPressed: () {},
            color: Colors.red[400],
            textColor: Colors.red[200],
            child: Icon(
              Icons.stop,
              size: 40,
            ),
            padding: EdgeInsets.all(12),
            shape: CircleBorder(),
          ),
        ],
      ),
    );
  }
}