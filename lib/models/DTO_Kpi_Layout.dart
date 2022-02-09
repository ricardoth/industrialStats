import 'package:gf_industrial_stadistics/models/DTO_Transaction.dart';

class DTO_Kpi_LayoutType {
  String idPlanta;
  int kilosProceso;
  int kilosExistencia;
  int cantidadCajas;
  int cantidadDetenciones;
  int tunelOcupado;
  int tunelTotal;
  DTO_TransactionType dtoTransaction;

  factory DTO_Kpi_LayoutType(Map jsonMap) {
    try {
      return new DTO_Kpi_LayoutType.deserialize(jsonMap);
    } catch (ex) {
      throw ex;
    }
  }

  DTO_Kpi_LayoutType.deserialize(Map json)
      : idPlanta = json['ID_PLANTA'],
        kilosProceso = json['KILOS_PROCESO'],
        kilosExistencia = json['KILOS_EXISTENCIA'],
        cantidadCajas = json['CANTIDAD_CAJAS'],
        cantidadDetenciones = json['CANTIDAD_DETENCIONES'],
        tunelOcupado = json['TUNEL_OCUPADO'],
        tunelTotal = json['TUNEL_TOTAL'],
        dtoTransaction = json['DTO_Transaction'] == null
            ? null
            : DTO_TransactionType.fromJson(json['DTO_Transaction']);
}
