import 'package:gf_industrial_stadistics/models/DTO_Transaction.dart';

class DTO_Detencion_ProcesoType {
  int codigoAreaTrabajo;
  String nombreAreaTrabajo;
  int cantidad;
  int semana;
  DTO_TransactionType dtoTransaction;

  factory DTO_Detencion_ProcesoType(Map jsonMap) {
    try {
      return new DTO_Detencion_ProcesoType.fromJson(jsonMap);
    } catch (ex) {
      throw ex;
    }
  }

  DTO_Detencion_ProcesoType.fromJson(Map json)
      : codigoAreaTrabajo = json["CODIGO_AREA_TRABAJO"],
        nombreAreaTrabajo = json["NOMBRE_AREA_TRABAJO"],
        cantidad = json["CANTIDAD"],
        semana = json["SEMANA"],
        dtoTransaction = json['DTO_Transaction'] == null
            ? null
            : DTO_TransactionType.fromJson(json['DTO_Transaction']);
}
