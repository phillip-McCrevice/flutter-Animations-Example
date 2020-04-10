import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'dart:math';

// void main() {
// debugPaintSizeEnabled = true;
// runApp(App());
// }

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(home: Home());
}

class Cat extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SizedBox(
        width: 200.0,
        child: Image.network(
          'https://i.imgur.com/QwhZRyL.png',
        ),
      );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  AnimationController catController;
  AnimationController boxController;
  Animation<double> catAnimation;
  Animation<double> boxAnimation;

  initState() {
    super.initState();

    // cat animations
    catController =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);

    catAnimation = Tween(begin: -35.0, end: -83.0)
        .animate(CurvedAnimation(parent: catController, curve: Curves.easeIn));

    // box animations
    boxController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);

    boxAnimation = Tween(begin: pi * 0.6, end: pi * 0.65).animate(
        CurvedAnimation(parent: boxController, curve: Curves.easeInOut));

    boxAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // boxController.repeat();
        boxController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxController.forward();
      }
    });
    boxController.forward();
  }

  onTap() {
    if (catController.status == AnimationStatus.completed) {
      boxController.forward();
      catController.reverse();
    } else if (catController.status == AnimationStatus.dismissed) {
      boxController.stop();
      catController.forward();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.red[500],
          title: Text(
            'Animations',
            style: TextStyle(
              fontFamily: 'bangers',
              fontSize: 40,
              color: Colors.yellowAccent,
            ),
          ),
          centerTitle: false,
        ),
        body: GestureDetector(
          onTap: onTap,
          child: Center(
            child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                buildCatAnimation(),
                buildBox(),
                buildLeftFlap(),
                buildRightFlap(),
              ],
            ),
          ),
        ),
      );

  Widget buildCatAnimation() => AnimatedBuilder(
        child: Cat(),
        animation: catAnimation,
        builder: (context, child) => Positioned(
          right: 0.0,
          left: 0.0,
          top: catAnimation.value,
          child: child,
        ),
      );

  Widget buildBox() => Container(
        height: 200.0,
        width: 200.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/box.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      );

  Widget buildLeftFlap() => Positioned(
        left: 3.0,
        child: AnimatedBuilder(
          animation: boxAnimation,
          builder: (context, child) => Transform.rotate(
            angle: boxAnimation.value,
            child: child,
            alignment: Alignment.topLeft,
          ),
          child: Container(
            height: 10.0,
            width: 125.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/box.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );

  Widget buildRightFlap() => Positioned(
        right: 3.0,
        child: AnimatedBuilder(
          animation: boxAnimation,
          builder: (context, child) => Transform.rotate(
            angle: -boxAnimation.value,
            child: child,
            alignment: Alignment.topRight,
          ),
          child: Container(
            height: 10.0,
            width: 125.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/box.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
}
