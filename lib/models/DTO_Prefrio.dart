import 'package:gf_industrial_stadistics/models/DTO_Transaction.dart';

class DTO_PrefrioType {
  String idPlanta;
  int nroFolio;
  int codTunel;
  String horaInicio;
  DTO_TransactionType dtoTransaction;

  factory DTO_PrefrioType(Map jsonMap) {
    try {
      return new DTO_PrefrioType.fromJson(jsonMap);
    } catch (ex) {
      throw ex;
    }
  }

  DTO_PrefrioType.fromJson(Map json)
      : idPlanta = json["ID_PLANTA"],
        nroFolio = json["NROFOLIO"],
        codTunel = json["CODTUNEL"],
        horaInicio = json["HORAINICIO"],
        dtoTransaction = json['DTO_Transaction'] == null
            ? null
            : DTO_TransactionType.fromJson(json['DTO_Transaction']);
}
