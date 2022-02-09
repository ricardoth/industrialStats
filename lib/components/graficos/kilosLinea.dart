import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gf_industrial_stadistics/components/layout/layout.dart';
import 'package:gf_industrial_stadistics/models/DTO_Proceso_Fruta.dart';
import 'package:gf_industrial_stadistics/common/HttpHandler.dart';
import 'package:gf_industrial_stadistics/models/globals.dart' as globals;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class KilosLineaDiaScreen extends StatefulWidget {
  @override
  _KilosLineaDiaScreenState createState() => _KilosLineaDiaScreenState();

  static List<charts.Series<DTO_Proceso_FrutaType, String>> cargarDatosGrafico(
      apiData) {
    final data = apiData;
    final blue = charts.MaterialPalette.blue.makeShades(2);
    final red = charts.MaterialPalette.red.makeShades(3);
    final green = charts.MaterialPalette.green.makeShades(2);
    final gray = charts.MaterialPalette.gray.makeShades(3);
    final cyan = charts.MaterialPalette.cyan.makeShades(2);
    final indigo = charts.MaterialPalette.indigo.makeShades(2);
    final deepOrange = charts.MaterialPalette.deepOrange.makeShades(3);
    final lime = charts.MaterialPalette.lime.makeShades(3);
    final purple = charts.MaterialPalette.purple.makeShades(3);
    final teal = charts.MaterialPalette.teal.makeShades(3);

    return [
      new charts.Series<DTO_Proceso_FrutaType, String>(
        id: 'DTO_Proceso_FrutaType',
        domainFn: (DTO_Proceso_FrutaType purchases, _) =>
            purchases.glosaLineaEmbalaje,
        measureFn: (DTO_Proceso_FrutaType purchases, _) => purchases.kilos,
        data: data,
        colorFn: (DTO_Proceso_FrutaType segment, _) {
          switch (segment.lineaEmbalaje) {
            case "1":
              {
                return blue[0];
              }

            case "2":
              {
                return red[0];
              }

            case "3":
              {
                return green[0];
              }

            case "4":
              {
                return red[2];
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
                return deepOrange[1];
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
                return teal[1];
              }

            case "16":
              {
                return gray[1];
              }

            case "17":
              {
                return purple[1];
              }

            case "18":
              {
                return cyan[1];
              }

            case "19":
              {
                return deepOrange[1];
              }

            case "19":
              {
                return indigo[1];
              }

            default:
              {
                return blue[2];
              }
          }
        },
        labelAccessorFn: (DTO_Proceso_FrutaType row, _) =>
            '${row.glosaLineaEmbalaje}',
      )
    ];
  }
}

class _KilosLineaDiaScreenState extends State<KilosLineaDiaScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String diaActual = "";
  String diaFuturo = "";
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
      final List<DTO_Proceso_FrutaType> response = await HttpHandler()
          .jsonProcesoFruta("api/KilosProcesoPorDiaMovil", dtoProcesoFruta);

      if (response.length > 0) {
        if (response[0].dtoTransaction.transactionNumber == "0") {
          diaActual = response[0].fechaInicio;
          diaFuturo = response[0].fechaFin;
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
    return new Scaffold(
      key: _scaffoldKey,
      body: cargarGraficoInicial(),
    );
  }

  Widget cargarGraficoInicial() {
    return new Container(
      child: FutureBuilder(
          future: _getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null) {
              return new charts.PieChart(
                  KilosLineaDiaScreen.cargarDatosGrafico(snapshot.data),
                  behaviors: [
                    new charts.DatumLegend(
                      position: charts.BehaviorPosition.bottom,
                      outsideJustification:
                          charts.OutsideJustification.middleDrawArea,
                      horizontalFirst: false,
                      cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                      showMeasures: true,
                      desiredMaxColumns: 5,
                      desiredMaxRows: 5,
                      legendDefaultMeasure:
                          charts.LegendDefaultMeasure.firstValue,
                      measureFormatter: (num value) {
                        return value == null ? '' : '${f.format(value)} Kilos';
                      },
                      entryTextStyle: charts.TextStyleSpec(
                          color: charts.MaterialPalette.black,
                          fontFamily: 'Arial',
                          fontSize: 16),
                    ),
                    new charts.ChartTitle(
                      "Kilos Procesados: ${f.format(sumaKilos)}",
                      subTitle: "$diaActual al $diaFuturo",
                      titleOutsideJustification:
                          charts.OutsideJustification.start,
                      behaviorPosition: charts.BehaviorPosition.top,
                      innerPadding: 24,
                    ),
                  ],
                  animate: true,
                  defaultRenderer: new charts.ArcRendererConfig(
                      arcWidth: 150,
                      arcRendererDecorators: [
                        new charts.ArcLabelDecorator(
                          showLeaderLines: false,
                          outsideLabelStyleSpec: new charts.TextStyleSpec(
                              fontSize: 12, color: charts.Color.black),
                          insideLabelStyleSpec: new charts.TextStyleSpec(
                              fontSize: 12, color: charts.Color.white),
                        )
                      ]));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
