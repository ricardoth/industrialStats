library my_prj.globals;

import 'package:gf_industrial_stadistics/models/DTO_Usuario.dart';
import 'package:gf_industrial_stadistics/models/DTO_Usuario_Planta.dart';

DTOUsuarioType dto_usuario;
// ignore: non_constant_identifier_names
int n_auditoria = 0;
// ignore: non_constant_identifier_names
bool ind_insert = false;
bool hijoauditoria = false;
bool hijopersonas = false;
bool hijoinicio = false;
String ID_ENROLAMIENTO_MOVIL;
String id_cuadrilla_add;
bool isSwitched = false;
String ID_PLANTA;
String NOMBRE_PLANTA;
List<DTO_Usuario_PlantaType> listaUsuarioPlanta;
