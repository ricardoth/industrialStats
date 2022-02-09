import 'package:flutter/material.dart';
import 'package:gf_industrial_stadistics/components/graficos/kilosLinea.dart';
import 'package:gf_industrial_stadistics/components/graficos/kilosVariedad.dart';
import 'package:gf_industrial_stadistics/components/graficos/procesoUnitecLinea.dart';

// ignore: must_be_immutable
class KilosTabController extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            backgroundColor: Colors.red,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                }),
            title: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 70),
                  child: Image.asset('assets/logos/logo2.png',
                      fit: BoxFit.contain, height: 50),
                ),
              ],
            ),
          )),
      body: Stack(
        children: <Widget>[tabBarKilos()],
      ),
    );
  }

  Widget tabBarKilos() {
    return new DefaultTabController(
        length: 3,
        child: new Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: AppBar(
                backgroundColor: Colors.red,
                bottom: TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.pie_chart)),
                    Tab(icon: Icon(Icons.bar_chart)),
                    Tab(icon: Icon(Icons.list_outlined)),
                  ],
                ),
              )),
          body: TabBarView(children: [
            KilosLineaDiaScreen(),
            KilosVariedadScreen(),
            ProcesoUnitecLineaScreen()
          ]),
        ));
  }
}
