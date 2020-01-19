import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;
import 'package:intl/intl.dart' show DateFormat;
import 'dart:math';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: TextTheme(
          display1: TextStyle(color: Colors.black38, fontSize: 30),
        ),
        fontFamily: 'Roboto',
      ),
      home: Scaffold(
        body: Clock(),
      ),
    );
  }
}

class Clock extends StatefulWidget {
  Clock({Key key}) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> with TickerProviderStateMixin {
  AnimationController _animation;
  AnimationController _animation2;

  DateTime _time = new DateTime.now();

  String _now = new DateFormat('hh:mm:ss a').format(new DateTime.now());

  @override
  void initState() {
    _animation = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _animation2 = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    Timer.periodic(Duration(seconds: 1), (v) {
      setState(() {
        _time = new DateTime.now();
        _now = new DateFormat('hh:mm:ss a').format(new DateTime.now());

        if (_time.second == 59) {
          _animation.forward();
        }
        if (_time.second == 0) {
          _animation.reset();
          _animation2.reset();
        }

        if ((_time.second == 59) && (_now.split(':')[1] == '59')) {
          _animation2.forward();
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CustomPaint(
          painter: DesignPainter(),
          child: Center(
            child: Stack(
              children: <Widget>[
                RotationTransition(
                    turns: _animation2,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          alignment: FractionalOffset(0.09, 0.5),
                          child: Text('${_now.split(':')[0]}',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 100)),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
        CustomPaint(
          painter: DesignPainterMinutes(),
          child: Center(
            child: Stack(
              children: <Widget>[
                RotationTransition(
                    turns: _animation,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          alignment: FractionalOffset(0.36, 0.5),
                          child: Text('${_now.split(':')[1]}',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 100)),
                        ),
                        Container(
                          alignment: FractionalOffset(0.64, 0.5),
                          child: Transform.rotate(
                            angle: pi,
                            child: Text('${_now.split(':')[1]}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 100)),
                          ),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
        CustomPaint(
          painter: DesignPainterSeconds(),
          child: Center(
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: FractionalOffset(0.65, 0.5),
                  child: Text('${_time.second}',
                      style: TextStyle(color: Colors.white, fontSize: 100)),
                ),
              ],
            ),
          ),
        ),
        Container(
          alignment: FractionalOffset(0.95, 0.5),
          child: Text('${_now.split(' ')[1]}',
              style: TextStyle(color: Colors.white, fontSize: 50)),
        )
      ],
    );
  }
}

class DesignPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(width, 0, width, height));
    paint.color = Colors.black45;
    canvas.drawPath(mainBackground, paint);

    Path timePath = Path();
    timePath.moveTo(width, 0);
    timePath.quadraticBezierTo(width * 0.5, height * 0.5, width, height);

    paint.color = Colors.black;
    canvas.drawPath(timePath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class DesignPainterSeconds extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(width, 0, width, height));
    paint.color = Colors.black45;
    canvas.drawPath(mainBackground, paint);

    const colorsec = const Color(0xff121212);
    Path secPath = Path();
    secPath.moveTo(width, 0);
    secPath.lineTo(width * 0.7, 0);
    secPath.quadraticBezierTo(
        width * 0.5, height * 0.2, width * 0.5, height * 0.5);
    secPath.quadraticBezierTo(width * 0.5, height * 0.8, width * 0.7, height);
    secPath.lineTo(width, height);
    paint.color = colorsec;
    canvas.drawPath(secPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

class DesignPainterMinutes extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(width, 0, width, height));
    paint.color = Colors.black45;
    canvas.drawPath(mainBackground, paint);

    const colormmin = const Color(0xff252525);
    Path minPath = Path();
    minPath.moveTo(width, 0);
    minPath.lineTo(width * 0.5, 0);
    minPath.quadraticBezierTo(
        width * 0.25, height * 0.2, width * 0.25, height * 0.5);
    minPath.quadraticBezierTo(width * 0.25, height * 0.8, width * 0.5, height);
    minPath.lineTo(width, height);
    paint.color = colormmin;
    canvas.drawPath(minPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
