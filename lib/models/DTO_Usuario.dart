import 'package:gf_industrial_stadistics/models/DTO_Transaction.dart';

class DTOUsuarioType {
  String usuarioSESION;
  int usuarioRUT;
  String usuarioDV;
  String usuarioRUTDV;
  String usuarioNOMBRE;
  String usuarioAPELLIDOS;
  String usuarioCODIGOPERFIL;
  String dtoPerfil;
  String usuarioCODIGOAREATRABAJO;
  String dtoAreaTrabajo;
  String usuarioMAIL;
  String usuarioTELEFONO;
  String usuarioCLAVE;
  String ID_ENROLAMIENTO_MOVIL;
  bool IND_PROPIO;
  bool usuarioINDVIGENCIA;
  String usuarioAVATAR;
  int userCREATED;
  String dateCREATED;
  int userMODIFIED;
  String dateMODIFIED;
  String ID_PLANTA;
  String NOMBRE_PLANTA;
  List<String> listaMenu;
  String dtoSesion;

  DTO_TransactionType dtoTransaction;

  DTOUsuarioType(
      {this.usuarioSESION,
      this.usuarioRUT,
      this.usuarioDV,
      this.usuarioRUTDV,
      this.usuarioNOMBRE,
      this.usuarioAPELLIDOS,
      this.usuarioCODIGOPERFIL,
      this.dtoPerfil,
      this.ID_ENROLAMIENTO_MOVIL,
      this.usuarioCODIGOAREATRABAJO,
      this.dtoAreaTrabajo,
      this.usuarioMAIL,
      this.usuarioTELEFONO,
      this.usuarioCLAVE,
      this.usuarioINDVIGENCIA,
      this.usuarioAVATAR,
      this.userCREATED,
      this.dateCREATED,
      this.userMODIFIED,
      this.dateMODIFIED,
      this.IND_PROPIO,
      this.listaMenu,
      this.dtoSesion,
      this.ID_PLANTA,
      this.NOMBRE_PLANTA,
      this.dtoTransaction});

  factory DTOUsuarioType.fromJson(Map<String, dynamic> json) {
    return DTOUsuarioType(
        usuarioSESION: json['SESION'],
        usuarioRUT: json['RUT_USUARIO'],
        usuarioDV: json['DV_USUARIO'],
        usuarioRUTDV: json['RUT_DV_USUARIO'],
        usuarioNOMBRE: json['NOMBRE_USUARIO'],
        usuarioAPELLIDOS: json['APELLIDOS_USUARIO'],
        usuarioCODIGOPERFIL: json['CODIGO_PERFIL'],
        usuarioCODIGOAREATRABAJO: json['CODIGO_AREA_TRABAJO'],
        usuarioMAIL: json['MAIL_USUARIO'],
        usuarioTELEFONO: json['TELEFONO'],
        usuarioCLAVE: json['CLAVE_USUARIO'],
        usuarioINDVIGENCIA: json['IND_VIGENCIA'],
        ID_ENROLAMIENTO_MOVIL: json['ID_ENROLAMIENTO_MOVIL'],
        usuarioAVATAR: json['AVATAR'],
        userCREATED: json['USER_CREATED'],
        dateCREATED: json['DATE_CREATED'],
        userMODIFIED: json['USER_MODIFIED'],
        dateMODIFIED: json['DATE_MODIFIED'],
        IND_PROPIO: json["IND_PROPIO"] == 1 ? true : false,
        listaMenu: json['ListaMenu'],
        ID_PLANTA: json['ID_PLANTA'],
        NOMBRE_PLANTA: json['NOMBRE_PLANTA'],
        dtoTransaction: json['DTO_Transaction'] == null
            ? null
            : DTO_TransactionType.fromJson(json['DTO_Transaction']));
  }
}
