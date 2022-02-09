import 'package:flutter/material.dart';
import 'package:gf_industrial_stadistics/components/login/login.dart';
import 'package:gf_industrial_stadistics/components/layout/layout.dart';
// import 'package:gf_industrial_stadistics/splashScreen.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'common/constantes.dart';

void main() async {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: new ThemeData(
            primaryColor: new Color(0xff673ab7),
            accentColor: new Color(0xffbf360c)),
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
        routes: <String, WidgetBuilder>{
          LOGIN_SCREEN: (BuildContext context) => new LoginScreen(),
          LAYOUT_SCREEN: (BuildContext context) => new LayoutScreen()
        });
  }
}
