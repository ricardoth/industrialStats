import 'package:gf_industrial_stadistics/models/DTO_Transaction.dart';

class DTO_Despacho_FrutaType {
  int paisDestino;
  String paisDesc;
  int cantidad;
  DTO_TransactionType dtoTransaction;

  factory DTO_Despacho_FrutaType(Map jsonMap) {
    try {
      return new DTO_Despacho_FrutaType.fromJson(jsonMap);
    } catch (ex) {
      throw ex;
    }
  }

  DTO_Despacho_FrutaType.fromJson(Map json)
      : paisDestino = json["PAIS_DESTINO"],
        paisDesc = json["PAISDESC"],
        cantidad = json["CANTIDAD"],
        dtoTransaction = json['DTO_Transaction'] == null
            ? null
            : DTO_TransactionType.fromJson(json['DTO_Transaction']);
}
