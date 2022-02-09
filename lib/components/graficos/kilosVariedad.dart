import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gf_industrial_stadistics/components/layout/layout.dart';
import 'package:gf_industrial_stadistics/models/DTO_Proceso_Fruta.dart';
import 'package:gf_industrial_stadistics/common/HttpHandler.dart';
import 'package:gf_industrial_stadistics/models/globals.dart' as globals;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class KilosVariedadScreen extends StatefulWidget {
  @override
  _KilosVariedadScreenState createState() => _KilosVariedadScreenState();

  static List<charts.Series<DTO_Proceso_FrutaType, String>> cargarDatosGrafico(
      apiData) {
    final data = apiData;
    final green = charts.MaterialPalette.green.makeShades(2);
    NumberFormat f = new NumberFormat("#,###,###", "es_CL");

    return [
      new charts.Series<DTO_Proceso_FrutaType, String>(
        id: 'DTO_Proceso_FrutaType',
        domainFn: (DTO_Proceso_FrutaType purchases, _) =>
            purchases.glosaVariedad,
        measureFn: (DTO_Proceso_FrutaType purchases, _) => purchases.kilos,
        data: data,
        colorFn: (DTO_Proceso_FrutaType segment, _) {
          switch (segment.glosaVariedad) {
            default:
              {
                return green[2];
              }
          }
        },
        labelAccessorFn: (DTO_Proceso_FrutaType row, _) =>
            '${f.format(row.kilos)} Kilos',
      )
    ];
  }
}

class _KilosVariedadScreenState extends State<KilosVariedadScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  NumberFormat f = new NumberFormat("#,###,###", "es_CL");

  String diaActual = "";
  String diaFuturo = "";
  double sumaKilos = 0;

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
          "api/KilosProcesoDiaVariedadMovil", dtoProcesoFruta);

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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LayoutScreen()),
            );
          });
        }
      } else {
        _showSnackBar(
            new Text("No se han encontrado resultados"), Colors.redAccent);
        Timer(Duration(seconds: 2), () {
          Navigator.push(
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LayoutScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(key: _scaffoldKey, body: cargarBarchartInicial());
  }

  Widget cargarBarchartInicial() {
    return new Container(
      child: FutureBuilder(
          future: _getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null)
              return new charts.BarChart(
                KilosVariedadScreen.cargarDatosGrafico(snapshot.data),
                vertical: false,
                animate: true,
                behaviors: [
                  new charts.ChartTitle(
                    "Kilos Procesados: ${f.format(sumaKilos)}",
                    subTitle: "$diaActual al $diaFuturo",
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
                primaryMeasureAxis: new charts.NumericAxisSpec(
                    renderSpec: new charts.NoneRenderSpec()),
              );
            else
              return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
