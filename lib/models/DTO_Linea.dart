// ignore: camel_case_types
class DTO_LineaType {
  String idLinea;
  String glosaLinea;

  factory DTO_LineaType(Map jsonMap) {
    try {
      return new DTO_LineaType.fromJson(jsonMap);
    } catch (ex) {
      throw ex;
    }
  }

  DTO_LineaType.fromJson(Map json)
      : idLinea = json["ID_LINEA"],
        glosaLinea = json["ID_LINEA"];
}
