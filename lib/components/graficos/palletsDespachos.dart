import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gf_industrial_stadistics/components/layout/layout.dart';
import 'package:gf_industrial_stadistics/models/DTO_Despacho_Fruta.dart';
import 'package:gf_industrial_stadistics/common/HttpHandler.dart';
import 'package:gf_industrial_stadistics/models/globals.dart' as globals;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class PalletsDespachosScreen extends StatefulWidget {
  @override
  _PalletsDespachosScreenState createState() => _PalletsDespachosScreenState();

  static List<charts.Series<DTO_Despacho_FrutaType, String>> cargarDatosGrafico(
      apiData) {
    final data = apiData;
    final green = charts.MaterialPalette.green.makeShades(2);
    final red = charts.MaterialPalette.red.makeShades(2);
    final gray = charts.MaterialPalette.gray.shade500;
    final blue = charts.MaterialPalette.blue.makeShades(3);
    NumberFormat f = new NumberFormat("#,###,###", "es_CL");

    return [
      new charts.Series<DTO_Despacho_FrutaType, String>(
        id: 'DTO_Despacho_FrutaType',
        domainFn: (DTO_Despacho_FrutaType purchases, _) => purchases.paisDesc,
        measureFn: (DTO_Despacho_FrutaType purchases, _) => purchases.cantidad,
        data: data,
        colorFn: (DTO_Despacho_FrutaType segment, _) {
          switch (segment.paisDesc) {
            case "CHINA":
              {
                return red[0];
              }

            case "USA":
              {
                return blue[0];
              }

            case "BRASIL":
              {
                return green[0];
              }

            default:
              {
                return gray;
              }
          }
        },
        labelAccessorFn: (DTO_Despacho_FrutaType row, _) =>
            '${f.format(row.cantidad)}',
      )
    ];
  }
}

class _PalletsDespachosScreenState extends State<PalletsDespachosScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
      var dtoDespacho = {"ID_PLANTA": globals.dto_usuario.ID_PLANTA};
      final response = await HttpHandler()
          .jsonDespachos("api/CantidadPalletsDespachoMovil", dtoDespacho);

      if (response.length > 0) {
        if (response[0].dtoTransaction.transactionNumber == "0") {
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
    return new Scaffold(key: _scaffoldKey, body: cargarBarchartInicial());
  }

  Widget cargarBarchartInicial() {
    return new Container(
      child: FutureBuilder(
          future: _getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null)
              return new Container(
                  padding: EdgeInsets.all(8),
                  child: charts.BarChart(
                    PalletsDespachosScreen.cargarDatosGrafico(snapshot.data),
                    vertical: true,
                    animate: true,
                    behaviors: [
                      new charts.ChartTitle(
                        "                    Pallets Despachados",
                        titleOutsideJustification:
                            charts.OutsideJustification.start,
                        behaviorPosition: charts.BehaviorPosition.top,
                        innerPadding: 20,
                      ),
                      new charts.InitialHintBehavior(maxHintTranslate: 4.0),
                      new charts.PanAndZoomBehavior(),
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
                                fontSize: 10,
                                color: charts.MaterialPalette.black),
                            lineStyle: new charts.LineStyleSpec(
                                color: charts.MaterialPalette.black))),
                    primaryMeasureAxis: new charts.NumericAxisSpec(
                        renderSpec: new charts.GridlineRendererSpec(
                            labelStyle: new charts.TextStyleSpec(
                                fontSize: 12,
                                color: charts.MaterialPalette.black),
                            lineStyle: new charts.LineStyleSpec(
                                color: charts.MaterialPalette.black))),
                  ));
            else
              return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
