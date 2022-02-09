import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gf_industrial_stadistics/common/HttpHandler.dart';
import 'package:gf_industrial_stadistics/components/layout/layout.dart';
import 'package:gf_industrial_stadistics/models/DTO_Prefrio.dart';
import 'package:gf_industrial_stadistics/models/globals.dart' as globals;

class PrefrioScreen extends StatefulWidget {
  @override
  _PrefrioScreenState createState() => _PrefrioScreenState();
}

class _PrefrioScreenState extends State<PrefrioScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<DTO_PrefrioType> prefrios = new List();

  @override
  void initState() {
    super.initState();
  }

  _showSnackBar(Text texto, Color color) {
    final snackBar = new SnackBar(
      content: texto,
      duration: new Duration(seconds: 3),
      backgroundColor: color,
      action: new SnackBarAction(
          label: "Ok",
          onPressed: () {
            print('press Ok on SnackBar');
          }),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<List<DTO_PrefrioType>> _getData() async {
    try {
      var params = {"ID_PLANTA": globals.dto_usuario.ID_PLANTA};
      var response =
          await HttpHandler().jsonPrefrio("api/PrefrioDetalleMovil", params);

      if (response.length > 0) {
        if (response[0].dtoTransaction.transactionNumber == "0") {
          for (var u in response) {
            DTO_PrefrioType prefrio = u;
            prefrios.add(prefrio);
          }
          return prefrios;
        } else {}
      } else {
        _showSnackBar(
            new Text("No se han encontrado resultados"), Colors.redAccent);
        Timer(Duration(seconds: 2), () {
          Navigator.pop(
            context,
            MaterialPageRoute(builder: (context) => LayoutScreen()),
          );
        });
      }
    } catch (e) {
      _showSnackBar(
          new Text(
              "Error: No se ha podido establecer una conexión con el servidor"),
          Colors.redAccent);
      Timer(Duration(seconds: 2), () {
        Navigator.pop(
          context,
          MaterialPageRoute(builder: (context) => LayoutScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: cargarListView(),
    );
  }

  Widget cargarListView() {
    return new Container(
      child: FutureBuilder(
        future: _getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return loadingCircular();
          } else {
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Prefríos en Uso",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListView.builder(
                    padding: EdgeInsets.only(top: 45),
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          child: ListTile(
                        title: Text("N° Folio: " +
                            snapshot.data[index].nroFolio.toString()),
                        subtitle: Text("Túnel: " +
                            snapshot.data[index].codTunel.toString() +
                            "\n" +
                            "Hora Inicio: " +
                            snapshot.data[index].horaInicio),
                        onTap: () {},
                      ));
                    })
              ],
            );
          }
        },
      ),
    );
  }

  Widget loadingCircular() {
    return new Center(
      child: CircularProgressIndicator(),
    );
  }
}
