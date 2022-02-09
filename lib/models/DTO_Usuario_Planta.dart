import 'package:gf_industrial_stadistics/models/DTO_Transaction.dart';

// ignore: camel_case_types
class DTO_Usuario_PlantaType {
  String ID_PLANTA;
  String NOMBRE_PLANTA;
  DTO_TransactionType DTO_Transaction;

  // "DATE_CREATED_MOVIL TEXT,"
  //         "ID_PLANTA TEXT,"
  //         "ID_COLOR_AREA TEXT,"
  //         "ID_SECTOR TEXT,"
  //         "IND_SYNC BIT,"
  //         "IND_VIGENCIA BIT"

  factory DTO_Usuario_PlantaType(Map jsonMap) {
    try {
      return new DTO_Usuario_PlantaType.deserialize(jsonMap);
    } catch (ex) {
      throw ex;
    }
  }

  DTO_Usuario_PlantaType.deserialize(Map json)
      : ID_PLANTA = json["ID_PLANTA"],
        NOMBRE_PLANTA = json["NOMBRE_PLANTA"],
        DTO_Transaction = json['DTO_Transaction'] == null
            ? null
            : DTO_TransactionType.fromJson(json['DTO_Transaction']);
}
