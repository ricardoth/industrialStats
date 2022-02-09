import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;

//Generate MD5 hash
generateMd5(String data) {
  var content = new AsciiEncoder().convert(data);
  var md5 = crypto.md5.convert(content);
  return new Base64Encoder().convert(md5.bytes);
}

bool validaRut(String campo) {
  if (campo.length == 0) {
    return false;
  }
  if (campo.length < 8) {
    return false;
  }

  campo = campo.replaceAll('-', '');
  campo = campo.replaceAll('.', '');

  var suma = 0;
  var caracteres = "1234567890kK";
  var contador = 0;
  for (var i = 0; i < campo.length; i++) {
    String u = campo.substring(i, i + 1);
    if (caracteres.indexOf(u) != -1) contador++;
  }
  if (contador == 0) {
    return false;
  }

  var rut = campo.substring(0, campo.length - 1);
  var drut = campo.substring(campo.length - 1);
  String dvr = '0';
  var mul = 2;

  for (int i = rut.length - 1; i >= 0; i--) {
    suma = suma + int.parse(rut[i]) * mul;
    if (mul == 7)
      mul = 2;
    else
      mul++;
  }
  int res = suma % 11;
  if (res == 1)
    dvr = 'k';
  else if (res == 0)
    dvr = '0';
  else {
    var dvi = 11 - res;
    dvr = dvi.toString();
  }
  if (dvr != drut.toLowerCase()) {
    return false;
  } else {
    return true;
  }
}

formatoRut(String rut) {
  String newRut = rut;
  if (newRut != '') {
    newRut = rut.substring(-4, -1) + '-' + rut.substring(rut.length - 1);
    for (int i = 4; i < rut.length; i += 3) {
      newRut = rut.substring(-3 - i, -i) + '.' + newRut;
    }
    return newRut;
  }
}

formatoRutGuion(String rut) {
  String newRut = rut;
  if (newRut != '') {
    newRut =
        rut.substring(0, rut.length - 1) + '-' + rut.substring(rut.length - 1);
    return newRut;
  }
}

quitarDigitoVerificador(String rut) {
  String newRut = rut;
  if (newRut != '') {
    newRut = rut.substring(0, rut.length - 2);
    return newRut;
  }
}

quitarDigitoVerificadorSinGuion(String rut) {
  String nuevoRut = rut;
  if (nuevoRut != '') {
    nuevoRut = rut.replaceAll("-", "");
    nuevoRut = nuevoRut.substring(0, nuevoRut.length - 1);
    return nuevoRut;
  }
}

quitarFormato(String rut) {
  rut = rut.replaceAll('.', "");
  rut = rut.replaceAll("-", "");
  return rut;
}
