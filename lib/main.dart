import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _score = 0;
  int _scoreHigh = 0;
  int _direction = 0; // 0~4: 상하좌우
  var _directionScore = [0, 0, 0, 0]; // 상하좌우 터치 개수
  // Point _apple = Point(5, 5);
  // var _snake = new List<Point>();
  // int _gameState = 0; // 0=시작 , 1=진행중, 2=게임오버

  double mapSize = 330.0;

  void _incrementScore() {
    setState(() {
      _score++;
      if (_score > _scoreHigh) _scoreHigh = _score;
    });
  }

  void _clearScoreHigh() {
    setState(() {
      _scoreHigh = 0;
      _score = 0;
    });
  }

  Widget directionButton() {
    var child;
    if (_direction == 0 || _direction == 1) {
      child = Container(
        height: mapSize,
        width: mapSize,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: mapSize,
              width: mapSize / 2,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: (tapUpDetails) {
                  setState(() {
                    _directionScore[2]++;
                    _direction = 2;
                  });
                },
              ),
            ),
            Container(
              height: mapSize,
              width: mapSize / 2,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: (tapUpDetails) {
                  setState(() {
                    _directionScore[3]++;
                    _direction = 3;
                  });
                },
              ),
            ),
          ],
        ),
      );
    } else if (_direction == 2 || _direction == 3) {
      child = Container(
        height: mapSize,
        width: mapSize,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: mapSize / 2,
              width: mapSize,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: (tapUpDetails) {
                  setState(() {
                    _directionScore[0]++;
                    _direction = 0;
                  });
                },
              ),
            ),
            Container(
              height: mapSize / 2,
              width: mapSize,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: (tapUpDetails) {
                  setState(() {
                    _directionScore[1]++;
                    _direction = 1;
                  });
                },
              ),
            ),
          ],
        ),
      );
    } else {
      child = Container(
          height: mapSize, width: mapSize, child: Text('direction error!'));
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          // 점수 칸
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                child: Text(
                  "Add",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red,
                onPressed: _incrementScore,
              ),
              Text(
                '$_score',
                style: Theme.of(context).textTheme.display1,
              ),
              Text(
                '$_scoreHigh',
                style: Theme.of(context).textTheme.display1,
              ),
              // direction확인용 테스트 코드
              Text(
                '$_direction' + ' ' + '$_directionScore',
                style: Theme.of(context).textTheme.display1,
              ),
            ],
          ),
          //게임 판
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(children: [
                  Container(
                    height: mapSize,
                    width: mapSize,
                    child: Image.asset('images/background.png'),
                  ),
                  directionButton(),
                ]),
              ],
            ),
          ),
        ],
      ),
      //새로고침 버튼 (플로팅 버튼)
      floatingActionButton: FloatingActionButton(
        onPressed: _clearScoreHigh,
        tooltip: 'Increment',
        child: Icon(Icons.autorenew),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
