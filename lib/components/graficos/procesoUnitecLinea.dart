import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gf_industrial_stadistics/common/HttpHandler.dart';
import 'package:gf_industrial_stadistics/components/layout/layout.dart';
import 'package:gf_industrial_stadistics/models/DTO_Proceso_Unitec.dart';
import 'package:gf_industrial_stadistics/models/globals.dart' as globals;
import 'package:intl/intl.dart';

class ProcesoUnitecLineaScreen extends StatefulWidget {
  @override
  _ProcesoUnitecLineaScreenState createState() =>
      _ProcesoUnitecLineaScreenState();
}

class _ProcesoUnitecLineaScreenState extends State<ProcesoUnitecLineaScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<DTO_Proceso_UnitecType> procesos = new List();
  NumberFormat f = new NumberFormat("#,###,###", "es_CL");

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

  Future<List<DTO_Proceso_UnitecType>> _getData() async {
    try {
      var params = {"ID_PLANTA": globals.dto_usuario.ID_PLANTA};
      var response =
          await HttpHandler().jsonUnitec("api/ProcesoUnitecMovil", params);

      if (response.length > 0) {
        if (response[0].dtoTransaction.transactionNumber == "0") {
          for (var u in response) {
            DTO_Proceso_UnitecType unitec = u;
            procesos.add(unitec);
          }
          return procesos;
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
    return new Scaffold(key: _scaffoldKey, body: cargarListViewUnitec());
  }

  Widget cargarListViewUnitec() {
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
                    "Proceso Unitec",
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
                        title: Text("N° Proceso: " +
                            snapshot.data[index].nroProceso.toString()),
                        subtitle: Text("Especie: " +
                            snapshot.data[index].glosaEspecie +
                            "\n" +
                            "Variedad: " +
                            snapshot.data[index].glosaVariedad +
                            "\n" +
                            "Productor: " +
                            snapshot.data[index].razonSocial +
                            "\n" +
                            "Línea: " +
                            snapshot.data[index].glosaLinea +
                            "\n" +
                            "Peso Declarado: " +
                            f.format(
                                int.parse(snapshot.data[index].pesoDeclarado)) +
                            "\n" +
                            "Fecha Inicio: " +
                            snapshot.data[index].fechaInicio +
                            "\n" +
                            "Estado: " +
                            snapshot.data[index].estado),
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
