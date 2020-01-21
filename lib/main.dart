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
  int _direction = 3; // 0~4: 상하좌우
  var _directionScore = [0, 0, 0, 0]; // 상하좌우 터치 개수
  Point _apple = Point(9, 5);
  var _snake = new List<Point>();
  int _gameState = 0; // 0=시작 , 1=진행중, 2=게임오버

  final double mapSize = 330.0;

  // functions
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
      _gameState = 0;
    });
  }

  Widget snakeJoint() {
    var child = Container(
      width: mapSize / 11,
      height: mapSize / 11,
      decoration: new BoxDecoration(
        color: const Color(0xFFFF0000),
        shape: BoxShape.rectangle,
      ),
    );
    return child;
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
                    if (_gameState == 0) {
                      setState(() {
                        _gameState = 1;
                      });
                    }
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
                    if (_gameState == 0) {
                      setState(() {
                        _gameState = 1;
                      });
                    }
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
                    if (_gameState == 0) {
                      setState(() {
                        _gameState = 1;
                      });
                    }
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
                    if (_gameState == 0) {
                      setState(() {
                        _gameState = 1;
                      });
                    }
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

  Widget childByGameState() {
    if (_gameState == 0) {
      setState(() {
        _snake = [Point(2, 5), Point(3, 5), Point(4, 5)];
        _score = 0;
        _direction = 2;
        _apple = Point(9, 5);
      });
      return Stack(
        children: [
          Container(
            height: mapSize,
            width: mapSize,
            child: Image.asset('images/background.png'),
          ),
          // 게임 상태에 따른 위젯
          Container(
            height: mapSize,
            width: mapSize,
            child: Center(child: Text('Tap to Start!')),
          ),
          directionButton(),
        ],
      );
    } else if (_gameState == 1) {
      List<Positioned> snakePositioned = List();
      _snake.forEach(
        (p) {
          snakePositioned.add(Positioned(
              child: snakeJoint(),
              left: p.x * mapSize / 11,
              top: p.y * mapSize / 11));
        },
      );
      // // 마지막 마디 추가
      // // snakePositioned.add(
      // //   Pointed(
      // //     child: snakeJoint(),

      // //   )
      // // )
      // child = snakePositioned.forEach((p) {
      //   return p;
      // });
      return Stack(
        children: [
          Container(
            height: mapSize,
            width: mapSize,
            child: Image.asset('images/background.png'),
          ),
          // 게임 상태에 따른 위젯
          for (var item in snakePositioned) item,
          //조작 버튼
          directionButton(),
        ],
      );
    } else {
      return Stack(
        children: [
          Container(
            height: mapSize,
            width: mapSize,
            child: Image.asset('images/background.png'),
          ),
          // 게임 상태에 따른 위젯
          Container(
            height: mapSize,
            width: mapSize,
            child: Center(child: Text('Game Over!')),
          ),
          directionButton(),
        ],
      );
    }
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
                childByGameState(),
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
