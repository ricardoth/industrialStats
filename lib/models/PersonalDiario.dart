class PersonalDiario {
  String planta;
  String cargo;
  String turno;
  int totalEmpleados;

  factory PersonalDiario(Map jsonMap) {
    try {
      return new PersonalDiario.fromJson(jsonMap);
    } catch (ex) {
      throw ex;
    }
  }

  PersonalDiario.fromJson(Map json)
      : planta = json["planta"],
        cargo = json["cargo"],
        turno = json["turno"],
        totalEmpleados = json["totalEmpleados"];
}
