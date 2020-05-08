import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedometer/pedometer.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _km = "Unknown";
  String _calories = "Unknown";

  String _stepCountValue = 'Unknown';
  StreamSubscription<int> _subscription;

  double _stepsnumber; //number steps
  double _convert;
  double _kmx;
  double burnedx;
  var difference = 0;
  var newValue = 0;

  @override
  void initState() {
    super.initState();
    setUpPedometer();
  }

  //starts pedometer code
  void setUpPedometer() {
    Pedometer pedometer = new Pedometer();
    _subscription = pedometer.pedometerStream.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: true);
  }

  void _onData(int stepCountValue) async {
    setState(() {
      newValue = stepCountValue - difference;
      _stepCountValue = "$newValue";
    });

    var dist = stepCountValue -
        difference; //we pass the integer to a variable called dist
    double y = (dist + .0); //we convert it to double a form of several

    setState(() {
      _stepsnumber =
          y; //we pass it to a state to be captured and converted to double
    });

    var long3 = (_stepsnumber);
    long3 = num.parse(y.toStringAsFixed(2));
    var long4 = (long3 / 10000);

    int decimals = 1;
    int fac = pow(10, decimals);
    double d = long4;
    d = (d * fac).round() / fac;
    print("d: $d");

    getDistanceRun(_stepsnumber);

    setState(() {
      _convert = d;
      print(_convert);
    });
  }

  void reset() {
    setState(() {
      int stepCountValue = 0;
      stepCountValue = 0;
      difference = difference + newValue;
      _stepCountValue = "$stepCountValue";
      _calories = "$stepCountValue";
      _km = "$stepCountValue";
    });
  }

  void _onDone() {}

  void _onError(error) {
    print("Flutter Pedometer Error: $error");
  }

  //function to determine the distance run in kilometers using number of steps
  void getDistanceRun(double _stepsnumber) {
    var distance = ((_stepsnumber * 78) / 100000);
    distance = num.parse(distance.toStringAsFixed(2)); //two decimal places
    var distancekmx = distance * 34;
    distancekmx = num.parse(distancekmx.toStringAsFixed(2));
    setState(() {
      _km = "$distance";
    });
    setState(() {
      _kmx = num.parse(distancekmx.toStringAsFixed(2));
    });
  }

  //function to determine the calories burned in kilometers using number of steps
  void getBurnedRun() {
    setState(() {
      var calories = _kmx; //two decimal places
      _calories = "$calories";
    });
  }

  //end code pedometer

  @override
  Widget build(BuildContext context) {
    getBurnedRun();
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Step Counter app'),
          backgroundColor: Colors.black54,
        ),
        body: new ListView(
          padding: EdgeInsets.all(5.0),
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 10.0),
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin:
                        Alignment.bottomCenter, //change the gradient lighting
                    end: Alignment.topCenter,
                    colors: [Color(0xFFA9F5F2), Color(0xFF01DFD7)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(27.0),
                    bottomRight: Radius.circular(27.0),
                    topLeft: Radius.circular(27.0),
                    topRight: Radius.circular(27.0),
                  )),
              child: new CircularPercentIndicator(
                radius: 200.0,
                lineWidth: 13.0,
                animation: true,
                center: Container(
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 50,
                        padding: EdgeInsets.only(left: 20.0),
                        child: Icon(
                          FontAwesomeIcons.walking,
                          size: 30.0,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        //color: Colors.orange,
                        child: Text(
                          '$_stepCountValue',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.purpleAccent),
                        ),
                      ),
                    ],
                  ),
                ),
                percent: 0.217,
                //percent: _convert,
                footer: new Text(
                  "Steps:  $_stepCountValue",
                  style: new TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                      color: Colors.purple),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.purpleAccent,
              ),
            ),
            Divider(
              height: 5.0,
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: RaisedButton(
                  onPressed: () => reset(),
                  child: Text(' Reset Step Counter '),
                  textColor: Colors.white,
                  color: Colors.green,
                  padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                )),
            Container(
              width: 80,
              height: 100,
              padding: EdgeInsets.only(left: 25.0, top: 10.0, bottom: 10.0),
              color: Colors.transparent,
              child: Row(
                children: <Widget>[
                  new Container(
                    child: new Card(
                      child: Container(
                        height: 80.0,
                        width: 80.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/distance.png"),
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                      color: Colors.white54,
                    ),
                  ),
                  VerticalDivider(
                    width: 20.0,
                  ),
                  new Container(
                    child: new Card(
                      child: Container(
                        height: 80.0,
                        width: 80.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/kcal.png"),
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                      color: Colors.transparent,
                    ),
                  ),
                  VerticalDivider(
                    width: 20.0,
                  ),
                  new Container(
                    child: new Card(
                      child: Container(
                        height: 80.0,
                        width: 80.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/steps.png"),
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 2,
            ),
            Container(
              padding: EdgeInsets.only(top: 2.0),
              width: 150,
              height: 30,
              color: Colors.transparent,
              child: Row(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(left: 40.0),
                    child: new Card(
                      child: Container(
                        child: Text(
                          "$_km Km",
                          textAlign: TextAlign.right,
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.white),
                        ),
                      ),
                      color: Colors.purple,
                    ),
                  ),
                  VerticalDivider(
                    width: 20.0,
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 10.0),
                    child: new Card(
                      child: Container(
                        child: Text(
                          "$_calories kCal",
                          textAlign: TextAlign.right,
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.white),
                        ),
                      ),
                      color: Colors.red,
                    ),
                  ),
                  VerticalDivider(
                    width: 5.0,
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 10.0),
                    child: new Card(
                      child: Container(
                        child: Text(
                          "$_stepCountValue Steps",
                          textAlign: TextAlign.right,
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.white),
                        ),
                      ),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
