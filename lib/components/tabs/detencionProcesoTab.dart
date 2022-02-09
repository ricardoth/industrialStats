import 'package:flutter/material.dart';
import 'package:gf_industrial_stadistics/components/graficos/detencionProceso.dart';

class DetencionProcesoTab extends StatefulWidget {
  @override
  _DetencionProcesoTabState createState() => _DetencionProcesoTabState();
}

class _DetencionProcesoTabState extends State<DetencionProcesoTab> {
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
        children: <Widget>[tabMenu()],
      ),
    );
  }

  Widget tabMenu() {
    return new DefaultTabController(
        length: 1,
        child: new Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: AppBar(
                backgroundColor: Colors.red,
                bottom: TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.bubble_chart_rounded)),
                  ],
                ),
              )),
          body: TabBarView(children: [
            DetencionProcesoScreen(),
          ]),
        ));
  }
}
