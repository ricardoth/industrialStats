import 'package:flutter/material.dart';

class Rutas {
  static void goToInicio(BuildContext context) {
    Navigator.pushNamed(context, "/inicio");
  }

  static void goToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/login");
  }
}
