import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gf_industrial_stadistics/components/layout/layout.dart';
import 'package:gf_industrial_stadistics/models/PersonalDiario.dart';
import 'package:gf_industrial_stadistics/common/HttpHandler.dart';
import 'package:gf_industrial_stadistics/models/globals.dart' as globals;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class DotacionPersonalCargoScreen extends StatefulWidget {
  @override
  _DotacionPersonalCargoScreenState createState() =>
      _DotacionPersonalCargoScreenState();

  static List<charts.Series<PersonalDiario, String>> cargarDatosGrafico(
      apiData) {
    final data = apiData;
    final green = charts.MaterialPalette.green.makeShades(2);
    NumberFormat f = new NumberFormat("#,###,###", "es_CL");

    return [
      new charts.Series<PersonalDiario, String>(
        id: 'PersonalDiario',
        domainFn: (PersonalDiario purchases, _) => purchases.cargo,
        measureFn: (PersonalDiario purchases, _) => purchases.totalEmpleados,
        data: data,
        colorFn: (PersonalDiario segment, _) {
          switch (segment.cargo) {
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

class _DotacionPersonalCargoScreenState
    extends State<DotacionPersonalCargoScreen> {
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
          await HttpHandler().jsonDotacion("api/PersonalDiarioCargo", params);

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
    return new Scaffold(
      key: _scaffoldKey,
      body: barChartCargo(),
    );
  }

  Widget barChartCargo() {
    return new Container(
      child: FutureBuilder(
          future: _getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null)
              return new charts.BarChart(
                DotacionPersonalCargoScreen.cargarDatosGrafico(snapshot.data),
                vertical: false,
                animate: true,
                behaviors: [
                  new charts.ChartTitle(
                    "Dotación Personal por Cargo",
                    titleOutsideJustification:
                        charts.OutsideJustification.start,
                    behaviorPosition: charts.BehaviorPosition.top,
                    innerPadding: 24,
                  ),
                ],
                barRendererDecorator: new charts.BarLabelDecorator(
                  outsideLabelStyleSpec: new charts.TextStyleSpec(
                      fontSize: 12, color: charts.Color.black),
                  insideLabelStyleSpec: new charts.TextStyleSpec(
                      fontSize: 12, color: charts.Color.white),
                ),
                barGroupingType: charts.BarGroupingType.grouped,
                domainAxis: new charts.OrdinalAxisSpec(
                    renderSpec: new charts.SmallTickRendererSpec(
                        labelStyle: new charts.TextStyleSpec(
                            fontSize: 10, color: charts.MaterialPalette.black),
                        lineStyle: new charts.LineStyleSpec(
                            color: charts.MaterialPalette.black))),
                primaryMeasureAxis: new charts.NumericAxisSpec(
                    renderSpec: new charts.GridlineRendererSpec(
                        labelStyle: new charts.TextStyleSpec(
                            fontSize: 12, color: charts.MaterialPalette.black),
                        lineStyle: new charts.LineStyleSpec(
                            color: charts.MaterialPalette.black))),
              );
            else
              return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
