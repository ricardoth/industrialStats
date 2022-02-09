import 'dart:convert';

import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gf_industrial_stadistics/common/constantes.dart';
import 'package:gf_industrial_stadistics/components/layout/drawer.dart';
import 'package:gf_industrial_stadistics/components/tabs/despachoTab.dart';
import 'package:gf_industrial_stadistics/components/tabs/detencionProcesoTab.dart';
import 'package:gf_industrial_stadistics/components/tabs/dotacionPersonalTab.dart';
import 'package:gf_industrial_stadistics/components/tabs/existenciaMpTab.dart';
import 'package:gf_industrial_stadistics/components/tabs/kilostTab.dart';
import 'package:gf_industrial_stadistics/common/HttpHandler.dart';
import 'package:gf_industrial_stadistics/components/tabs/prefrioTab.dart';
import 'package:gf_industrial_stadistics/models/DTO_Usuario_Planta.dart';
import 'package:gf_industrial_stadistics/models/PersonalDiario.dart';
import 'package:gf_industrial_stadistics/models/globals.dart' as globals;

class LayoutScreen extends StatefulWidget {
  @override
  _LayoutScreenState createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen>
    with SingleTickerProviderStateMixin {
  String version = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AnimationController animationController;
  int touchedIndex;
  double kilosProceso = 0;
  double kilosExistencia = 0;
  double cantidadCajas = 0;
  double cantidadDetenciones = 0;
  double cantidadPersonal = 0;
  double tunelOcupado = 0;
  double tunelTotal = 0;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loading = false;
    _getData();
    _getDataPersonalDiario();
  }

  _showSnackBar(Text texto, Color color) {
    final snackBar = new SnackBar(
      content: texto,
      duration: new Duration(seconds: 3),
      backgroundColor: color,
      action: new SnackBarAction(
          label: 'Ok',
          onPressed: () {
            print('press Ok on SnackBar');
          }),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _getDataPersonalDiario() async {
    try {
      setState(() {
        loading = false;
      });

      var parameters = {"Planta": globals.dto_usuario.NOMBRE_PLANTA};
      var response = await HttpHandler()
          .postJsonWithoutAuth("api/PersonalDiarioTotal", parameters);

      PersonalDiario pesonalDiario = new PersonalDiario.fromJson(response);

      setState(() {
        cantidadPersonal = pesonalDiario.totalEmpleados.roundToDouble();
        loading = true;
      });
    } catch (e) {
      setState(() {
        loading = true;
      });
      _showSnackBar(
          new Text(
              "Error: No se ha podido establecer una conexión con el servidor"),
          Colors.redAccent);
      print(e);
    }
  }

  _getData() async {
    try {
      setState(() {
        loading = false;
      });

      var dtoProcesoFruta = {"ID_PLANTA": globals.dto_usuario.ID_PLANTA};
      final response =
          await HttpHandler().jsonKpis("api/KpiLayoutMovil", dtoProcesoFruta);

      if (response.length > 0) {
        if (response[0].dtoTransaction.transactionNumber == "0") {
          setState(() {
            kilosProceso = response[0].kilosProceso.roundToDouble();
            kilosExistencia = response[0].kilosExistencia.roundToDouble();
            cantidadCajas = response[0].cantidadCajas.roundToDouble();
            cantidadDetenciones =
                response[0].cantidadDetenciones.roundToDouble();
            tunelOcupado = response[0].tunelOcupado.roundToDouble();
            tunelTotal = response[0].tunelTotal.roundToDouble();
            loading = true;
          });

          return response;
        } else {
          setState(() {
            loading = true;
          });
          _showSnackBar(
              new Text("No se han encontrado resultados"), Colors.redAccent);
        }
      } else {
        setState(() {
          loading = true;
        });
        _showSnackBar(
            new Text("No se han encontrado resultados"), Colors.redAccent);
      }
    } catch (e) {
      setState(() {
        loading = true;
      });
      _showSnackBar(
          new Text(
              "Error: No se ha podido establecer una conexión con el servidor"),
          Colors.redAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: MediaQuery.of(context).size.height * 1,
      child: new Scaffold(
        key: _scaffoldKey,
        drawer: DrawerStug(),
        appBar: appBar(),
        body: loading ? cuerpo() : loadingCircular(),
      ),
    );
  }

  Widget appBar() {
    return new AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.red,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        onPressed: () {
          _scaffoldKey.currentState.openDrawer();
        },
      ),
      title: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 70),
            child: Image.asset('assets/logos/logo2.png',
                fit: BoxFit.contain, height: 50),
          ),
        ],
      ),
      actions: <Widget>[
        IconButton(
            icon: new Icon(Icons.power_settings_new),
            onPressed: () async {
              Navigator.pushReplacementNamed(context, LOGIN_SCREEN);
            })
      ],
    );
  }

  Widget cuerpo() {
    return new Stack(
      children: <Widget>[
        new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                  child: GridView.count(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                crossAxisCount: 2,
                children: <Widget>[
                  componenteKilosProceso(),
                  componenteKilosExistenciaMp(),
                  componenteCajasDespachadas(),
                  componenteDetencionesProceso(),
                  componenteDotacionPersonal(),
                  componentePrefrio()
                ],
              )),
            ]),
      ],
    );
  }

  Widget componenteKilosProceso() {
    return new InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => KilosTabController()),
        );
      },
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(6.0)),
                  boxShadow: [
                    const BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 4.0))
                  ]),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.donut_small_outlined,
                      size: 20.0,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text("Kilos Diarios"),
                    ),
                    Countup(
                      begin: 0,
                      end: kilosProceso,
                      duration: Duration(seconds: 2),
                      separator: '.',
                      style: TextStyle(fontSize: 30, color: Colors.green),
                      curve: Curves.fastOutSlowIn,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text("Totales Proceso",
                            style: TextStyle(fontWeight: FontWeight.normal)))
                  ]))),
    );
  }

  Widget componenteKilosExistenciaMp() {
    return new InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ExistenciaMpTab()),
        );
      },
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(6.0)),
                  boxShadow: [
                    const BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 4.0))
                  ]),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.eco_outlined,
                      size: 20.0,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text("Materia Prima"),
                    ),
                    Countup(
                      begin: 0,
                      end: kilosExistencia,
                      duration: Duration(seconds: 2),
                      separator: '.',
                      style: TextStyle(fontSize: 30, color: Colors.green),
                      curve: Curves.fastOutSlowIn,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text("Kilos en Existencia",
                            style: TextStyle(fontWeight: FontWeight.normal)))
                  ]))),
    );
  }

  Widget componenteCajasDespachadas() {
    return new InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DespachoTab()),
        );
      },
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(6.0)),
                  boxShadow: [
                    const BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 4.0))
                  ]),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.show_chart_outlined,
                      size: 20.0,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text("Cajas Diarias"),
                    ),
                    Countup(
                      begin: 0,
                      end: cantidadCajas,
                      duration: Duration(seconds: 2),
                      separator: '.',
                      style: TextStyle(fontSize: 30, color: Colors.green),
                      curve: Curves.fastOutSlowIn,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text("Total Despachadas",
                            style: TextStyle(fontWeight: FontWeight.normal)))
                  ]))),
    );
  }

  Widget componenteDetencionesProceso() {
    return new InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetencionProcesoTab()),
        );
      },
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(6.0)),
                  boxShadow: [
                    const BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 4.0))
                  ]),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.stop_circle_outlined,
                      size: 20.0,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text("Detenciones Proceso"),
                    ),
                    Countup(
                      begin: 0,
                      end: cantidadDetenciones,
                      duration: Duration(seconds: 2),
                      separator: '.',
                      style: TextStyle(fontSize: 30, color: Colors.green),
                      curve: Curves.fastOutSlowIn,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text("Total Semana",
                            style: TextStyle(fontWeight: FontWeight.normal)))
                  ]))),
    );
  }

  Widget componenteDotacionPersonal() {
    return new InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DotacionPersonalTab()),
        );
      },
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(6.0)),
                  boxShadow: [
                    const BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 4.0))
                  ]),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.people_alt,
                      size: 20.0,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text("Dotación Personal"),
                    ),
                    Countup(
                      begin: 0,
                      end: cantidadPersonal,
                      duration: Duration(seconds: 2),
                      separator: '.',
                      style: TextStyle(fontSize: 30, color: Colors.green),
                      curve: Curves.fastOutSlowIn,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text("Total Diario",
                            style: TextStyle(fontWeight: FontWeight.normal)))
                  ]))),
    );
  }

  Widget componentePrefrio() {
    return new InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PrefrioTab()),
        );
      },
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(6.0)),
                  boxShadow: [
                    const BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 4.0))
                  ]),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.ac_unit,
                      size: 20.0,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text(
                        "Túneles Prefrío",
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Countup(
                          begin: 0,
                          end: tunelOcupado,
                          duration: Duration(seconds: 2),
                          separator: '.',
                          style: TextStyle(fontSize: 30, color: Colors.green),
                          curve: Curves.fastOutSlowIn,
                        ),
                        Text(" / "),
                        Countup(
                          begin: 0,
                          end: tunelTotal,
                          duration: Duration(seconds: 2),
                          separator: '.',
                          style: TextStyle(fontSize: 30, color: Colors.green),
                          curve: Curves.fastOutSlowIn,
                        ),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text("En Uso/Total",
                            style: TextStyle(fontWeight: FontWeight.normal)))
                  ]))),
    );
  }

  Widget loadingCircular() {
    return new Center(
      child: CircularProgressIndicator(),
    );
  }
}
