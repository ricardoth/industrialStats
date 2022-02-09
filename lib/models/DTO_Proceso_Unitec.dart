import 'package:gf_industrial_stadistics/models/DTO_Transaction.dart';

class DTO_Proceso_UnitecType {
  String idPlanta;
  int nroProceso;
  int codEspecie;
  String glosaEspecie;
  int codVariedad;
  String glosaVariedad;
  int codProductor;
  String csg;
  String razonSocial;
  String pesoCalibrado;
  String pesoDeclarado;
  String pesoEntrada;
  String idLinea;
  String glosaLinea;
  String estado;
  String fechaInicio;
  DTO_TransactionType dtoTransaction;

  factory DTO_Proceso_UnitecType(Map jsonMap) {
    try {
      return new DTO_Proceso_UnitecType.deserialize(jsonMap);
    } catch (ex) {
      throw ex;
    }
  }

  DTO_Proceso_UnitecType.deserialize(Map json)
      : idPlanta = json['ID_PLANTA'],
        nroProceso = json['NROPROCESO'],
        codEspecie = json['CODESPECIE'],
        glosaEspecie = json['GLOSA_ESPECIE'],
        codVariedad = json['COD_VARIEDAD'],
        glosaVariedad = json['GLOSA_VARIEDAD'],
        codProductor = json['CODPRODUCTOR'],
        csg = json['CSG'],
        razonSocial = json['RAZON_SOCIAL'],
        pesoCalibrado = json['PESO_CALIBRADO'],
        pesoDeclarado = json['PESO_DECLARADO'],
        pesoEntrada = json['PESO_ENTRADA'],
        idLinea = json['ID_LINEA'],
        glosaLinea = json['GLOSA_LINEA'],
        estado = json['ESTADO'],
        fechaInicio = json['FECHAINICIO'],
        dtoTransaction = json['DTO_Transaction'] == null
            ? null
            : DTO_TransactionType.fromJson(json['DTO_Transaction']);
}
