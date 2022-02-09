import 'package:gf_industrial_stadistics/models/DTO_Linea.dart';
import 'package:gf_industrial_stadistics/models/DTO_Transaction.dart';
import 'package:gf_industrial_stadistics/models/DTO_Turno.dart';

// ignore: camel_case_types
class DTO_Proceso_FrutaType {
  String idPlanta;
  String lineaEmbalaje;
  String glosaLineaEmbalaje;
  int codEspecie;
  String glosaEspecie;
  int codVariedad;
  String glosaVariedad;
  double kilos;
  String fechaInicio;
  String fechaFin;
  DTO_LineaType dtoLinea;
  DTO_TurnoType dtoTurno;
  DTO_TransactionType dtoTransaction;

  factory DTO_Proceso_FrutaType(Map jsonMap) {
    try {
      return new DTO_Proceso_FrutaType.deserialize(jsonMap);
    } catch (ex) {
      throw ex;
    }
  }

  DTO_Proceso_FrutaType.deserialize(Map json)
      : idPlanta = json['ID_PLANTA'],
        lineaEmbalaje = json['LINEA_EMBALAJE'],
        glosaLineaEmbalaje = json['GLOSA_LINEA_EMBALAJE'],
        codEspecie = json['CODESPECIE'],
        glosaEspecie = json['GLOSA_ESPECIE'],
        codVariedad = json['COD_VARIEDAD'],
        glosaVariedad = json['GLOSA_VARIEDAD'],
        kilos = json['KILOS'],
        fechaInicio = json['HORA_INI_PROCESO'],
        fechaFin = json['HORA_FIN_PROCESO'],
        dtoLinea = json['DTO_Linea'] == null
            ? null
            : DTO_LineaType.fromJson(json['DTO_Linea']),
        dtoTurno = json['DTO_Turno'] == null
            ? null
            : DTO_TurnoType.fromJson(json['DTO_Turno']),
        dtoTransaction = json['DTO_Transaction'] == null
            ? null
            : DTO_TransactionType.fromJson(json['DTO_Transaction']);
}
