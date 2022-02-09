import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gf_industrial_stadistics/common/HttpHandler.dart';
import 'package:gf_industrial_stadistics/components/layout/layout.dart';
import 'package:gf_industrial_stadistics/models/DTO_Detencion_Proceso.dart';
import 'package:gf_industrial_stadistics/models/globals.dart' as globals;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class DetencionProcesoScreen extends StatefulWidget {
  @override
  _DetencionProcesoScreenState createState() => _DetencionProcesoScreenState();

  static List<charts.Series<DTO_Detencion_ProcesoType, String>>
      cargarDatosGrafico(apiData) {
    final data = apiData;
    final blue = charts.MaterialPalette.blue.makeShades(2);
    final red = charts.MaterialPalette.red.makeShades(3);
    final green = charts.MaterialPalette.green.makeShades(2);
    final yellow = charts.MaterialPalette.yellow.makeShades(2);
    final gray = charts.MaterialPalette.gray.makeShades(3);
    final cyan = charts.MaterialPalette.cyan.makeShades(2);
    final indigo = charts.MaterialPalette.indigo.makeShades(2);
    final deepOrange = charts.MaterialPalette.deepOrange.makeShades(3);
    final lime = charts.MaterialPalette.lime.makeShades(3);
    final purple = charts.MaterialPalette.purple.makeShades(3);
    final teal = charts.MaterialPalette.teal.makeShades(3);
    NumberFormat f = new NumberFormat("#,###,###", "es_CL");

    return [
      new charts.Series<DTO_Detencion_ProcesoType, String>(
        id: 'DTO_Detencion_ProcesoType',
        domainFn: (DTO_Detencion_ProcesoType purchases, _) =>
            purchases.nombreAreaTrabajo,
        measureFn: (DTO_Detencion_ProcesoType purchases, _) =>
            purchases.cantidad,
        data: data,
        colorFn: (DTO_Detencion_ProcesoType segment, _) {
          switch (segment.codigoAreaTrabajo.toString()) {
            case "1":
              {
                return blue[0];
              }

            case "2":
              {
                return deepOrange[1];
              }

            case "3":
              {
                return green[0];
              }

            case "4":
              {
                return yellow[0];
              }

            case "5":
              {
                return gray[0];
              }

            case "6":
              {
                return cyan[0];
              }

            case "7":
              {
                return deepOrange[0];
              }

            case "8":
              {
                return indigo[0];
              }

            case "9":
              {
                return lime[0];
              }

            case "10":
              {
                return purple[0];
              }

            case "11":
              {
                return teal[0];
              }

            case "12":
              {
                return blue[1];
              }

            case "13":
              {
                return red[1];
              }

            case "14":
              {
                return green[1];
              }

            case "15":
              {
                return yellow[1];
              }

            case "16":
              {
                return gray[1];
              }

            case "17":
              {
                return cyan[1];
              }

            case "18":
              {
                return red[0];
              }

            case "19":
              {
                return indigo[1];
              }

            case "19":
              {
                return lime[1];
              }

            default:
              {
                return blue[2];
              }
          }
        },
        labelAccessorFn: (DTO_Detencion_ProcesoType row, _) =>
            '${f.format(row.cantidad)}',
      )
    ];
  }
}

class _DetencionProcesoScreenState extends State<DetencionProcesoScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  NumberFormat f = new NumberFormat("#,###,###", "es_CL");
  int semanaActual;

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
      var dtoDetencion = {"ID_PLANTA": globals.dto_usuario.ID_PLANTA};
      final response = await HttpHandler()
          .jsonDetenciones("api/CantidadDetencionAreaMovil", dtoDetencion);

      if (response.length > 0) {
        if (response[0].dtoTransaction.transactionNumber == "0") {
          semanaActual = response[0].semana;
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
                      DetencionProcesoScreen.cargarDatosGrafico(snapshot.data),
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
                            return value == null ? '' : '${f.format(value)}';
                          },
                          entryTextStyle: charts.TextStyleSpec(
                              color: charts.MaterialPalette.black,
                              fontFamily: 'Arial',
                              fontSize: 16),
                        ),
                        new charts.ChartTitle(
                          "Detenciones de Proceso",
                          subTitle: "Semana ${semanaActual}",
                          titleOutsideJustification:
                              charts.OutsideJustification.start,
                          behaviorPosition: charts.BehaviorPosition.top,
                          innerPadding: 10,
                        ),
                      ],
                      animate: true,
                      defaultRenderer: new charts.ArcRendererConfig(
                          arcWidth: 80,
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
