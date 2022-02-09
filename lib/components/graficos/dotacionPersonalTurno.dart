import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gf_industrial_stadistics/components/layout/layout.dart';
import 'package:gf_industrial_stadistics/models/PersonalDiario.dart';
import 'package:gf_industrial_stadistics/common/HttpHandler.dart';
import 'package:gf_industrial_stadistics/models/globals.dart' as globals;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class DotacionPersonalTurnoScreen extends StatefulWidget {
  @override
  _DotacionPersonalTurnoScreenState createState() =>
      _DotacionPersonalTurnoScreenState();

  static List<charts.Series<PersonalDiario, String>> cargarDatosGrafico(
      apiData) {
    final data = apiData;
    final green = charts.MaterialPalette.green.makeShades(2);
    final blue = charts.MaterialPalette.blue.makeShades(2);
    final red = charts.MaterialPalette.red.makeShades(3);
    final purple = charts.MaterialPalette.purple.makeShades(3);
    NumberFormat f = new NumberFormat("#,###,###", "es_CL");

    return [
      new charts.Series<PersonalDiario, String>(
        id: 'PersonalDiario',
        domainFn: (PersonalDiario purchases, _) => purchases.turno,
        measureFn: (PersonalDiario purchases, _) => purchases.totalEmpleados,
        data: data,
        colorFn: (PersonalDiario segment, _) {
          switch (segment.turno) {
            case "TURNO 1":
              {
                return red[0];
              }

            case "TURNO 2":
              {
                return blue[0];
              }

            case "TURNO 3":
              {
                return green[0];
              }

            case "default":
              {
                return purple[0];
              }

            default:
              {
                return green[2];
              }
          }
        },
        labelAccessorFn: (PersonalDiario row, _) =>
            '${f.format(row.totalEmpleados)}',
      )
    ];
  }
}

class _DotacionPersonalTurnoScreenState
    extends State<DotacionPersonalTurnoScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
      var params = {"planta": globals.dto_usuario.NOMBRE_PLANTA};
      final response =
          await HttpHandler().jsonDotacion("api/PersonalDiarioTurno", params);

      if (response.length > 0) {
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
    return new Scaffold(key: _scaffoldKey, body: barChartTurno());
  }

  Widget barChartTurno() {
    return new Container(
      child: FutureBuilder(
          future: _getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null) {
              return new charts.PieChart(
                  DotacionPersonalTurnoScreen.cargarDatosGrafico(snapshot.data),
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
                        return value == null ? '' : '${f.format(value)}';
                      },
                      entryTextStyle: charts.TextStyleSpec(
                          color: charts.MaterialPalette.black,
                          fontFamily: 'Arial',
                          fontSize: 16),
                    ),
                    new charts.ChartTitle(
                      "Dotación Personal por Turno",
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
