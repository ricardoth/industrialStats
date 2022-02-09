import 'dart:async'; //para las llamadas asincronas
import 'package:gf_industrial_stadistics/models/DTO_Despacho_Fruta.dart';
import 'package:gf_industrial_stadistics/models/DTO_Detencion_Proceso.dart';
import 'package:gf_industrial_stadistics/models/DTO_Kpi_Layout.dart';
import 'package:gf_industrial_stadistics/models/DTO_Prefrio.dart';
import 'package:gf_industrial_stadistics/models/DTO_Proceso_Fruta.dart';
import 'package:gf_industrial_stadistics/models/DTO_Usuario_Planta.dart';
import 'package:gf_industrial_stadistics/models/DTO_Proceso_Unitec.dart';
import 'package:gf_industrial_stadistics/models/PersonalDiario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gf_industrial_stadistics/common/constantes.dart';

class HttpHandler {
  final String _basicAuthorization =
      base64Encode(utf8.encode('$usrWEBAPI:$passWEBAPI'));

  //future es como el promise en js
  //await indica que espera la llamada y respuesta de la misma
  Future<dynamic> getJson(String uri) async {
    http.Response response = await http.get(urlWEBAPI + uri, headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'POST',
      'Accept': 'application/json',
      'content-type': 'application/json',
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': 'Basic $_basicAuthorization'
    });
    return json.decode(response.body);
  }

  Future<dynamic> postJson(String uri, Map data) async {
    http.Response response = await http.post(urlWEBAPI + uri,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'POST',
          'Accept': 'application/json',
          'content-type': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': 'Basic $_basicAuthorization'
        },
        body: json.encode(data),
        encoding: Encoding.getByName("utf-8"));
    print(json.encode(data));

    return json.decode(response.body);
  }

  Future<dynamic> postJsonWithoutAuth(String uri, Map data) async {
    http.Response response = await http.post(urlApiDotacion + uri,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'POST',
          'Accept': 'application/json',
          'content-type': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(data),
        encoding: Encoding.getByName("utf-8"));
    print(json.encode(data));

    return json.decode(response.body);
  }

  Future<dynamic> postJsonLista(String uri, List<Map> data) async {
    http.Response response = await http.post(urlWEBAPI + uri,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'POST',
          'Accept': 'application/json',
          'content-type': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': 'Basic $_basicAuthorization'
        },
        body: json.encode(data),
        encoding: Encoding.getByName("utf-8"));
    print(json.encode(data));

    return json.decode(response.body);
  }

  Future<List<DTO_Usuario_PlantaType>> jsonUsuarioPlanta(String uri, Map data) {
    return postJson(uri, data).then(((data) => data
        .map<DTO_Usuario_PlantaType>((item) => new DTO_Usuario_PlantaType(item))
        .toList()));
  }

  Future<List<DTO_Proceso_FrutaType>> jsonProcesoFruta(String uri, Map data) {
    return postJson(uri, data).then(((data) => data
        .map<DTO_Proceso_FrutaType>((item) => new DTO_Proceso_FrutaType(item))
        .toList()));
  }

  Future<List<DTO_Despacho_FrutaType>> jsonDespachos(String uri, Map data) {
    return postJson(uri, data).then(((data) => data
        .map<DTO_Despacho_FrutaType>((item) => new DTO_Despacho_FrutaType(item))
        .toList()));
  }

  Future<List<DTO_Detencion_ProcesoType>> jsonDetenciones(
      String uri, Map data) {
    return postJson(uri, data).then(((data) => data
        .map<DTO_Detencion_ProcesoType>(
            (item) => new DTO_Detencion_ProcesoType(item))
        .toList()));
  }

  Future<List<DTO_Kpi_LayoutType>> jsonKpis(String uri, Map data) {
    return postJson(uri, data).then(((data) => data
        .map<DTO_Kpi_LayoutType>((item) => new DTO_Kpi_LayoutType(item))
        .toList()));
  }

  Future<List<PersonalDiario>> jsonDotacion(String uri, Map data) {
    return postJsonWithoutAuth(uri, data).then(((data) =>
        data.map<PersonalDiario>((item) => new PersonalDiario(item)).toList()));
  }

  Future<List<DTO_PrefrioType>> jsonPrefrio(String uri, Map data) {
    return postJson(uri, data).then(((data) => data
        .map<DTO_PrefrioType>((item) => new DTO_PrefrioType(item))
        .toList()));
  }

  Future<List<DTO_Proceso_UnitecType>> jsonUnitec(String uri, Map data) {
    return postJson(uri, data).then(((data) => data
        .map<DTO_Proceso_UnitecType>((item) => new DTO_Proceso_UnitecType(item))
        .toList()));
  }
}
