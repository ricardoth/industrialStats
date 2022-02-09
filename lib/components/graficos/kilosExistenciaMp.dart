import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gf_industrial_stadistics/components/layout/layout.dart';
import 'package:gf_industrial_stadistics/models/DTO_Proceso_Fruta.dart';
import 'package:gf_industrial_stadistics/common/HttpHandler.dart';
import 'package:gf_industrial_stadistics/models/globals.dart' as globals;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class KilosExistenciaMpScreen extends StatefulWidget {
  @override
  _KilosExistenciaMpScreenState createState() =>
      _KilosExistenciaMpScreenState();

  static List<charts.Series<DTO_Proceso_FrutaType, String>> cargarDatosGrafico(
      apiData) {
    final data = apiData;
    final purple = charts.MaterialPalette.purple.makeShades(2);
    final red = charts.MaterialPalette.red.makeShades(3);
    final orange = charts.MaterialPalette.deepOrange.makeShades(2);
    final yellow = charts.MaterialPalette.yellow.makeShades(3);
    final green = charts.MaterialPalette.green.makeShades(2);

    return [
      new charts.Series<DTO_Proceso_FrutaType, String>(
        id: 'DTO_Proceso_FrutaType',
        domainFn: (DTO_Proceso_FrutaType purchases, _) =>
            purchases.glosaEspecie,
        measureFn: (DTO_Proceso_FrutaType purchases, _) => purchases.kilos,
        data: data,
        colorFn: (DTO_Proceso_FrutaType segment, _) {
          switch (segment.glosaEspecie) {
            case "CEREZAS":
              {
                return red[0];
              }

            case "CIRUELA":
              {
                return purple[0];
              }

            case "NECTARINES":
              {
                return orange[0];
              }
            case "DURAZNOS":
              {
                return yellow[0];
              }
            default:
              {
                return green[2];
              }
          }
        },
        labelAccessorFn: (DTO_Proceso_FrutaType row, _) =>
            '${row.glosaEspecie}',
      )
    ];
  }
}

class _KilosExistenciaMpScreenState extends State<KilosExistenciaMpScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double sumaKilos = 0;
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
          label: 'Ok',
          onPressed: () {
            print('press Ok on SnackBar');
          }),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _getData() async {
    try {
      var dtoProcesoFruta = {"ID_PLANTA": globals.dto_usuario.ID_PLANTA};
      final response = await HttpHandler().jsonProcesoFruta(
          "api/KilosExistenciaMateriaPrimaMovil", dtoProcesoFruta);

      if (response.length > 0) {
        if (response[0].dtoTransaction.transactionNumber == "0") {
          double suma = 0;
          for (var i = 0; i < response.length; i++) {
            suma += response[i].kilos;
          }
          sumaKilos = suma;
          return response;
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
    return new Scaffold(key: _scaffoldKey, body: cargarAreachartInicial());
  }

  Widget cargarAreachartInicial() {
    return new Container(
      child: FutureBuilder(
          future: _getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null) {
              return new Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: charts.PieChart(
                      KilosExistenciaMpScreen.cargarDatosGrafico(snapshot.data),
                      behaviors: [
                        new charts.DatumLegend(
                          position: charts.BehaviorPosition.bottom,
                          outsideJustification:
                              charts.OutsideJustification.startDrawArea,
                          horizontalFirst: false,
                          cellPadding:
                              new EdgeInsets.only(right: 4.0, bottom: 4.0),
                          showMeasures: true,
                          desiredMaxColumns: 10,
                          desiredMaxRows: 10,
                          legendDefaultMeasure:
                              charts.LegendDefaultMeasure.firstValue,
                          measureFormatter: (num value) {
                            return value == null
                                ? ''
                                : '${f.format(value)} Kilos';
                          },
                          entryTextStyle: charts.TextStyleSpec(
                              color: charts.MaterialPalette.black,
                              fontFamily: 'Arial',
                              fontSize: 16),
                        ),
                        new charts.ChartTitle(
                          "Kilos en Existencia: ${f.format(sumaKilos)}",
                          titleOutsideJustification:
                              charts.OutsideJustification.start,
                          behaviorPosition: charts.BehaviorPosition.top,
                          innerPadding: 10,
                        ),
                      ],
                      animate: true,
                      defaultRenderer: new charts.ArcRendererConfig(
                          arcWidth: 120,
                          arcRendererDecorators: [
                            new charts.ArcLabelDecorator(
                              showLeaderLines: false,
                              outsideLabelStyleSpec: new charts.TextStyleSpec(
                                  fontSize: 12, color: charts.Color.black),
                              insideLabelStyleSpec: new charts.TextStyleSpec(
                                  fontSize: 12, color: charts.Color.white),
                            )
                          ])));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
