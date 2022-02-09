import 'package:flutter/material.dart';
import 'package:gf_industrial_stadistics/components/graficos/cajasDespachos.dart';
import 'package:gf_industrial_stadistics/components/graficos/palletsDespachos.dart';

class DespachoTab extends StatefulWidget {
  DespachoTab({Key key}) : super(key: key);

  @override
  _DespachoTabState createState() => _DespachoTabState();
}

class _DespachoTabState extends State<DespachoTab> {
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
        length: 2,
        child: new Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: AppBar(
                backgroundColor: Colors.red,
                bottom: TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.insert_chart_outlined_outlined)),
                    Tab(icon: Icon(Icons.stacked_bar_chart)),
                  ],
                ),
              )),
          body: TabBarView(
              children: [CajasDespachosScreen(), PalletsDespachosScreen()]),
        ));
  }
}
