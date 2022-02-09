import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gf_industrial_stadistics/common/constantes.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  bool val;
  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    // val = await DBProvider.db.getValidarUsuario();
    // await validarusuario();
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  validarusuario() async {
    // var lista = await DBProvider.db.getUsuarios();
    // if (lista.length > 0) {
    //   globals.dto_usuario = lista[0];
    // }
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed(LOGIN_SCREEN);
    // if (!val) {
    //   Navigator.of(context).pushReplacementNamed(LOGIN_SCREEN);
    // } else {
    //   Navigator.of(context).pushReplacementNamed(LAYOUT);
    // }
  }

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[],
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/icons/icon.png',
                width: animation.value * 250,
                height: animation.value * 250,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
