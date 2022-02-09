import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/animation.dart';
import 'package:gf_industrial_stadistics/common/HttpHandler.dart';
import 'package:gf_industrial_stadistics/components/layout/layout.dart';
import 'package:gf_industrial_stadistics/common/comunes.dart';
import 'package:gf_industrial_stadistics/models/DTO_Usuario.dart';
import 'package:gf_industrial_stadistics/models/DTO_Usuario_Planta.dart';
import 'package:flutter/cupertino.dart';
import 'package:gf_industrial_stadistics/models/globals.dart' as globals;

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  AnimationController _loginButtonController;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _passwordVisible;
  bool _valorInicial = false;
  bool isSelected = true;
  String _currentIndex = "";
  bool _loading = false;

  _showSnackBar(Text texto, Color color) {
    final snackBar = new SnackBar(
      content: texto,
      duration: new Duration(seconds: 3),
      backgroundColor: color,
      action: new SnackBarAction(
          label: 'Ok',
          onPressed: () {
            print('press Ok on SnackBar');
          }),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _loginButtonController = new AnimationController(
        duration: new Duration(seconds: 2), vsync: this);
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    super.dispose();
  }

  void _onLoading() {
    setState(() {
      _loading = true;
    });
  }

  void cambiarValor(bool val) => setState(() {
        _valorInicial = val;
        print(val);
      });

  // Future<bool> _onWillPop() {
  //   return showDialog(
  //         context: context,
  //         child: new AlertDialog(
  //           title: new Text('¿Está seguro?'),
  //           actions: <Widget>[
  //             new FlatButton(
  //               onPressed: () => Navigator.of(context).pop(false),
  //               child: new Text('No'),
  //             ),
  //             new FlatButton(
  //               onPressed: () =>
  //                   Navigator.pushReplacementNamed(context, "/login"),
  //               child: new Text('Yes'),
  //             ),
  //           ],
  //         ),
  //       ) ??
  //       false;
  // }

  void loginApi(String user, String pass, BuildContext context) async {
    pass = generateMd5(pass);
    if (validaRut(user)) {
      try {
        var rut = quitarDigitoVerificadorSinGuion(user);
        _onLoading();

        var responseContentLogin = await HttpHandler().postJson(
            "api/ValidaUsuario",
            {"RUT_USUARIO": rut, "CLAVE_USUARIO": pass, "ID_TIPO_APP": 1});
        DTOUsuarioType dtoLogin = DTOUsuarioType.fromJson(responseContentLogin);
        globals.dto_usuario = null;
        if (dtoLogin.dtoTransaction.transactionNumber == "0") {
          globals.dto_usuario = dtoLogin;

          var dto = {"RUT_USUARIO": globals.dto_usuario.usuarioRUT};
          List<DTO_Usuario_PlantaType> lstPlantasPorUsuario =
              await HttpHandler()
                  .jsonUsuarioPlanta("api/ListaPlantadeUsuarioMovil", dto);

          setState(() {
            _loading = false;
          });

          if (lstPlantasPorUsuario != null) {
            this.mostrarDialog(context, lstPlantasPorUsuario);
          } else {
            _showSnackBar(new Text("Usuario no posee plantas asignadas"),
                Colors.redAccent);
          }
        } else {
          setState(() {
            _loading = false;
          });
          _showSnackBar(new Text(dtoLogin.dtoTransaction.transactionMessage),
              Colors.redAccent);
        }
      } catch (e) {
        setState(() {
          _loading = false;
        });
        _showSnackBar(
            new Text(
                "Error: No se ha podido establecer una conexión con el servidor"),
            Colors.redAccent);
      }
    } else {
      _showSnackBar(new Text("Rut ingresado no es válido"), Colors.redAccent);
    }
  }

  mostrarDialog(BuildContext context,
      List<DTO_Usuario_PlantaType> lstUsuarioPlanta) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Seleccione"),
            content: new Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.3,
              child: new ListView.builder(
                shrinkWrap: true,
                itemCount: lstUsuarioPlanta.length,
                itemBuilder: (context, index) => new Column(
                  children: <Widget>[
                    Container(
                      child: RadioListTile(
                        title: Text(lstUsuarioPlanta[index].NOMBRE_PLANTA),
                        groupValue: _currentIndex,
                        value: lstUsuarioPlanta[index].ID_PLANTA,
                        onChanged: (val) {
                          setState(() {
                            _currentIndex = val;
                          });

                          Navigator.of(context).pop();
                          mostrarDialog(context, lstUsuarioPlanta);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                  child: new Text("Siguiente"),
                  onPressed: () async {
                    if (_currentIndex != "") {
                      for (var item in lstUsuarioPlanta) {
                        if (item.ID_PLANTA == _currentIndex) {
                          globals.ID_PLANTA = item.ID_PLANTA;
                          globals.NOMBRE_PLANTA = item.NOMBRE_PLANTA;
                        }
                      }
                      globals.dto_usuario.ID_PLANTA = globals.ID_PLANTA;
                      globals.dto_usuario.NOMBRE_PLANTA = globals.NOMBRE_PLANTA;

                      if (_valorInicial) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LayoutScreen()),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LayoutScreen()),
                          (Route<dynamic> route) => false,
                        );
                      }
                    } else {
                      _showSnackBar(new Text("Debe Seleccionar una Planta"),
                          Colors.redAccent);
                    }
                  })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/login': (_) => new LoginScreen(),
        '/layout': (_) => new LayoutScreen()
      },
      theme: new ThemeData(
          primaryColor: new Color(0xff673ab7),
          accentColor: new Color(0xffbf360c)),
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
          key: _scaffoldKey,
          // resizeToAvoidBottomPadding: true,
          backgroundColor: Colors.white,
          body: _loading
              ? loadingScreenInicial()
              : loadingScreenLoginRememberPass()),
    );
  }

  Widget iconCorporation() {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Image.asset(
          "assets/logos/stug.png",
          height: 150.0,
          width: 200.0,
          fit: BoxFit.scaleDown,
        )
      ],
    );
  }

  Widget userNameTextInput() {
    return new Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: TextFormField(
          controller: _usernameController,
          decoration: InputDecoration(
              icon: Icon(Icons.person),
              hintText: "Rut",
              fillColor: Colors.black,
              labelText: "Usuario"),
          maxLength: 9,
          // ignore: missing_return
          validator: (value) {
            RegExp regExp = new RegExp(
              r"[0-9]{7,8}[0-9Kk]{1}",
              caseSensitive: false,
              multiLine: false,
            );
            if (!regExp.hasMatch(value)) {
              return 'Formato del Rut 111111111';
            }
          },
        ));
  }

  Widget passwordTextInput() {
    return new Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
      child: new TextFormField(
        obscureText: !_passwordVisible,
        controller: _passwordController,
        decoration: InputDecoration(
          icon: Icon(Icons.vpn_key),
          fillColor: Colors.white.withOpacity(0.5),
          labelText: "Contraseña",
          suffixIcon: GestureDetector(
              onLongPress: () {
                setState(() {
                  _passwordVisible = true;
                });
              },
              onLongPressUp: () {
                setState(() {
                  _passwordVisible = true;
                });
              },
              child: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
              )),
        ),
      ),
    );
  }

  Widget buttonLoginInput() {
    return new RaisedButton(
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0)),
      onPressed: () async {
        if (_usernameController.text != "" && _passwordController.text != "") {
          loginApi(_usernameController.text, _passwordController.text, context);
        } else {
          _showSnackBar(
              new Text(
                "Debe completar los campos para iniciar sesión",
                style: TextStyle(color: Colors.black),
              ),
              Colors.yellow);
        }
      },
      child: new Text(
        "Ingresar",
        style: new TextStyle(fontWeight: FontWeight.bold),
      ),
      color: Colors.red,
      textColor: Colors.white,
      elevation: 5.0,
      padding:
          EdgeInsets.only(left: 80.0, right: 80.0, top: 15.0, bottom: 15.0),
    );
  }

  Widget loadingScreenInicial() {
    return new Container(
      child: new Stack(
        children: <Widget>[
          new ListView(
            shrinkWrap: true,
            reverse: false,
            children: <Widget>[
              new SizedBox(
                height: 20.0,
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Row(),
                  new SizedBox(
                    height: 30.0,
                  ),
                  iconCorporation(),
                  new Center(
                    child: new Center(
                      child: new Stack(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 30.0, right: 30.0),
                            child: new Form(
                              key: _formKey,
                              // ignore: deprecated_member_use
                              autovalidate: true,
                              child: new Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  userNameTextInput(),
                                  passwordTextInput(),
                                  new Row(),
                                  new SizedBox(
                                    height: 30.0,
                                  ),
                                  buttonLoginInput()
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          circularLoadingState()
        ],
      ),
    );
  }

  Widget loadingScreenLoginRememberPass() {
    return new ListView(
      shrinkWrap: true,
      reverse: false,
      children: <Widget>[
        new SizedBox(
          height: 20.0,
        ),
        new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Row(),
            new SizedBox(
              height: 30.0,
            ),
            iconCorporation(),
            new Center(
              child: new Center(
                child: new Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: new Form(
                        key: _formKey,
                        // ignore: deprecated_member_use
                        autovalidate: true,
                        child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            userNameTextInput(),
                            passwordTextInput(),
                            new Row(),
                            new SizedBox(
                              height: 30.0,
                            ),
                            buttonLoginInput(),
                            // new Align(
                            //     child: Row(
                            //   mainAxisAlignment: MainAxisAlignment.end,
                            //   children: <Widget>[
                            //     new Text("¿Recordar contraseña?"),
                            //     new Switch(
                            //         value: _valorInicial,
                            //         activeColor: Colors.red,
                            //         onChanged: cambiarValor),
                            //   ],
                            // )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget circularLoadingState() {
    return new Container(
      alignment: AlignmentDirectional.center,
      decoration: new BoxDecoration(
        color: Colors.white70,
      ),
      child: new Container(
        decoration: new BoxDecoration(
            color: Colors.transparent,
            borderRadius: new BorderRadius.circular(10.0)),
        width: 250.0,
        height: 150.0,
        alignment: AlignmentDirectional.center,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Center(
              child: new SizedBox(
                height: 50.0,
                width: 50.0,
                child: new CircularProgressIndicator(
                  value: null,
                  strokeWidth: 7.0,
                ),
              ),
            ),
            new Container(
              margin: const EdgeInsets.only(top: 25.0),
              child: new Center(
                child: new Text(
                  "Cargando",
                  style: new TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
