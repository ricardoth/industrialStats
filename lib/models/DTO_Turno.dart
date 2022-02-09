// ignore: camel_case_types
class DTO_TurnoType {
  String idTurno;
  String glosaTurno;

  factory DTO_TurnoType(Map jsonMap) {
    try {
      return new DTO_TurnoType.fromJson(jsonMap);
    } catch (ex) {
      throw ex;
    }
  }

  DTO_TurnoType.fromJson(Map json)
      : idTurno = json["ID_TURNO"],
        glosaTurno = json["GLOSA_TURNO"];
}
