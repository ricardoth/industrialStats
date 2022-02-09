import 'package:flutter/material.dart';
import 'package:gf_industrial_stadistics/common/HttpHandler.dart';
import 'package:gf_industrial_stadistics/components/layout/layout.dart';
import 'package:gf_industrial_stadistics/components/tabs/despachoTab.dart';
import 'package:gf_industrial_stadistics/components/tabs/detencionProcesoTab.dart';
import 'package:gf_industrial_stadistics/components/tabs/dotacionPersonalTab.dart';
import 'package:gf_industrial_stadistics/components/tabs/kilostTab.dart';
import 'package:gf_industrial_stadistics/components/tabs/existenciaMpTab.dart';
import 'package:gf_industrial_stadistics/components/tabs/prefrioTab.dart';
import 'package:gf_industrial_stadistics/models/DTO_Usuario_Planta.dart';
import 'package:gf_industrial_stadistics/models/globals.dart' as globals;

class DrawerStug extends StatefulWidget {
  @override
  _DrawerStugState createState() => _DrawerStugState();
}

class _DrawerStugState extends State<DrawerStug> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool loading = false;
  bool _valorInicial = false;
  String _currentIndex = "";

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

  mostrarDialog(BuildContext context,
      List<DTO_Usuario_PlantaType> lstUsuarioPlanta) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Seleccione"),
            content: new Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.3,
              child: new ListView.builder(
                shrinkWrap: true,
                itemCount: lstUsuarioPlanta.length,
                itemBuilder: (context, index) => new Column(
                  children: <Widget>[
                    Container(
                      child: RadioListTile(
                        title: Text(lstUsuarioPlanta[index].NOMBRE_PLANTA),
                        groupValue: _currentIndex,
                        value: lstUsuarioPlanta[index].ID_PLANTA,
                        onChanged: (val) {
                          setState(() {
                            _currentIndex = val;
                          });

                          Navigator.of(context).pop();
                          mostrarDialog(context, lstUsuarioPlanta);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                  child: new Text("Siguiente"),
                  onPressed: () async {
                    if (_currentIndex != "") {
                      for (var item in lstUsuarioPlanta) {
                        if (item.ID_PLANTA == _currentIndex) {
                          globals.ID_PLANTA = item.ID_PLANTA;
                          globals.NOMBRE_PLANTA = item.NOMBRE_PLANTA;
                        }
                      }
                      globals.dto_usuario.ID_PLANTA = globals.ID_PLANTA;
                      globals.dto_usuario.NOMBRE_PLANTA = globals.NOMBRE_PLANTA;

                      if (_valorInicial) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LayoutScreen()),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LayoutScreen()),
                          (Route<dynamic> route) => false,
                        );
                      }
                    } else {
                      _showSnackBar(new Text("Debe Seleccionar una Planta"),
                          Colors.redAccent);
                    }
                  })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: new Container(
                decoration: BoxDecoration(color: Colors.transparent),
                child: Image.asset(
                  'assets/logos/stugblanco.png',
                  fit: BoxFit.contain,
                  height: 8,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
            Expanded(
              child: Column(children: <Widget>[
                ListTile(
                  title: Text(
                    'Proceso Kilos',
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  leading: Icon(
                    Icons.donut_small_outlined,
                    size: 20.0,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => KilosTabController()));
                  },
                ),
                ListTile(
                  title: Text(
                    'Materia Prima',
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  leading: Icon(
                    Icons.eco_outlined,
                    size: 20.0,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExistenciaMpTab()));
                  },
                ),
                ListTile(
                  title: Text(
                    'Despachos',
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  leading: Icon(
                    Icons.show_chart_outlined,
                    size: 20.0,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DespachoTab()));
                  },
                ),
                ListTile(
                  title: Text(
                    'Detención Proceso',
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  leading: Icon(
                    Icons.stop_circle_outlined,
                    size: 20.0,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetencionProcesoTab()));
                  },
                ),
                ListTile(
                  title: Text(
                    'Dotación Personal',
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  leading: Icon(
                    Icons.people_alt,
                    size: 20.0,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DotacionPersonalTab()));
                  },
                ),
                ListTile(
                  title: Text(
                    'Prefrío',
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  leading: Icon(
                    Icons.ac_unit,
                    size: 20.0,
                    color: Colors.black,
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PrefrioTab()));
                  },
                ),
              ]),
            ),
            Container(
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Column(
                      children: <Widget>[
                        // Divider(),
                        // ListTile(
                        //     leading: Icon(Icons.corporate_fare_sharp),
                        //     title: Text(globals.dto_usuario.NOMBRE_PLANTA)),
                        footer()
                      ],
                    ))),
          ],
        ),
      ),
    );
  }

  Widget footer() {
    return BottomAppBar(
      child: Container(
        decoration: new BoxDecoration(
          color: Colors.red,
        ),
        height: MediaQuery.of(context).size.height * 0.15,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: IconButton(
                    icon: new Icon(
                      Icons.person_pin,
                      color: Colors.white,
                    ),
                  ),
                ),
                Flexible(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      globals.dto_usuario.usuarioNOMBRE.toString() +
                          ' ' +
                          globals.dto_usuario.usuarioAPELLIDOS.toString(),
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  child: IconButton(
                      icon: new Icon(
                        Icons.room,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        try {
                          setState(() {
                            loading = true;
                          });
                          var rut = globals.dto_usuario.usuarioRUTDV.substring(
                              0, globals.dto_usuario.usuarioRUTDV.length - 1);
                          var dto = {"RUT_USUARIO": rut};

                          List<DTO_Usuario_PlantaType> lista =
                              await HttpHandler().jsonUsuarioPlanta(
                                  "api/ListaPlantadeUsuarioMovil", dto);

                          this.mostrarDialog(context, lista);
                        } catch (e) {
                          this._showSnackBar(
                              Text(
                                  "Error de Conexión, Verifique el acceso a Internet"),
                              Colors.red);
                        }
                      }),
                ),
                Flexible(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      globals.dto_usuario.NOMBRE_PLANTA,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
