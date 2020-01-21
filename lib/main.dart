import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toy_snake_game',
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
      home: MyHomePage(title: 'Snake Game'),
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
  Point _apple = Point(9, 5);
  var _snake = new List<Point>();
  int _gameState = 0; // 0=시작 , 1=진행중, 2=게임오버
  Timer timer;

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
      timer.cancel();
    });
  }

  void start() {
    setState(() {
      _gameState = 1;
    });
    timer = new Timer.periodic(new Duration(milliseconds: 500), onTimeTick);
  }

  void end() {
    setState(() {
      _gameState = 0;
      _score = 0;
      timer.cancel();
    });
  }

  void onTimeTick(Timer timer) {
    setState(() {
      _snake.insert(0, getLatestSnake());
      _snake.removeLast();
    });

    var currentHeadPos = _snake.first;
    if (currentHeadPos.x < 0 ||
        currentHeadPos.y < 0 ||
        currentHeadPos.x > 11 ||
        currentHeadPos.y > 11) {
      setState(() {
        _gameState = 2;
      });
      return;
    }
    if (_snake.contains(getLatestSnake())) {
      setState(() {
        _gameState = 2;
      });
      return;
    }

    if (_snake.first.x == _apple.x && _snake.first.y == _apple.y) {
      _incrementScore();
      generateApple();
      setState(() {
        _snake.insert(0, getLatestSnake());
      });
    }
  }

  Point getLatestSnake() {
    var newHeadPos;

    switch (_direction) {
      case 2:
        var currentHeadPos = _snake.first;
        newHeadPos = Point(currentHeadPos.x - 1, currentHeadPos.y);
        break;

      case 3:
        var currentHeadPos = _snake.first;
        newHeadPos = Point(currentHeadPos.x + 1, currentHeadPos.y);
        break;

      case 0:
        var currentHeadPos = _snake.first;
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y - 1);
        break;

      case 1:
        var currentHeadPos = _snake.first;
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y + 1);
        break;
    }

    return newHeadPos;
  }

  void generateApple() {
    setState(() {
      Random rng = new Random();
      var nextX = rng.nextInt(9) + 1;
      var nextY = rng.nextInt(9) + 1;
      var newApple = Point(nextX, nextY);
      while (_snake.contains(newApple)) {
        nextX = rng.nextInt(11);
        nextY = rng.nextInt(11);
        newApple = Point(nextX, nextY);
      }
      setState(() {
        _apple = newApple;
      });
    });
  }

  Widget snakeJoint() {
    var child = Container(
      width: mapSize / 11,
      height: mapSize / 11,
      decoration: new BoxDecoration(
        color: Colors.blue,
        border: Border.all(width: 1.5, color: Colors.lightBlueAccent),
        shape: BoxShape.rectangle,
      ),
    );
    return child;
  }

  Widget apple() {
    var child = Container(
      width: mapSize / 11,
      height: mapSize / 11,
      decoration: new BoxDecoration(
        border: Border.all(width: 2.0, color: Colors.redAccent),
        color: Colors.red,
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
                    if (_gameState == 0) {
                      start();
                    } else if (_gameState == 2) {
                      end();
                    } else {
                      _direction = 2;
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
                    if (_gameState == 0) {
                      start();
                    } else if (_gameState == 2) {
                      end();
                    } else {
                      _direction = 3;
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
                    if (_gameState == 0) {
                      start();
                    } else if (_gameState == 2) {
                      end();
                    } else {
                      _direction = 0;
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
                    if (_gameState == 0) {
                      start();
                    } else if (_gameState == 2) {
                      end();
                    } else {
                      _direction = 1;
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
        _snake = [Point(4, 5), Point(3, 5), Point(2, 5)];
        _score = 0;
        _direction = 3;
        _apple = Point(8, 5);
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
          // Positioned(
          //     child: apple(),
          //     left: _apple.x * mapSize / 11,
          //     top: _apple.y * mapSize / 11),
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
          Positioned(
              child: apple(),
              left: _apple.x * mapSize / 11,
              top: _apple.y * mapSize / 11),
          //조작 버튼
          directionButton(),
        ],
      );
    } else {
      timer.cancel();
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
              Text(
                'Score: $_score',
                style: Theme.of(context).textTheme.display1,
              ),
              Text(
                'Record: $_scoreHigh',
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
