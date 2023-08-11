import 'package:flutter/material.dart';
import 'package:lddm/services/auth.dart';
import 'package:lddm/shared.dart';
import 'package:lddm/shared/loading.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  double _slider = 0;
  String _sliderLabel = "";

  final shared = SharedVariables();

  bool _hidden = false;

  String _email = '';
  String _password = '';
  String _error = '';
  bool loading = false;
  // authentication

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  final String _fillField = "Esse campo precisa ser preenchido";
  final String _sizeLessThan6 = "A senha deve ter no mínimo 6 caracteres";

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green[400],
        title: const Text('Entrar'),
        elevation: 0,
      ),
      body: ListView(
        semanticChildCount: 1,
        children: [Column(
          children: [
            const SizedBox(height: 20),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  IconButton(
                      icon: const Icon(Icons.zoom_out),
                      onPressed: () {
                        if(_slider > 0) {
                          setState(() {
                            _slider--;
                            shared.inputFontSize = 18 + _slider;
                            shared.bigFontSize = 16 + _slider;
                            shared.smallFontSize = 14 + _slider;
                            shared.iconSize = 24 + _slider;
                            _sliderLabel = "font size:+${_slider.toString()}";
                            shared.baseSize = _slider;
                          });
                        }
                      }
                  ),
                  Expanded(child: Slider(
                      activeColor: Colors.green,
                      inactiveColor: Colors.green,
                      secondaryActiveColor: Colors.green,
                      thumbColor: Colors.green,

                      value: _slider, min: 0, max: 10,
                      onChanged: (double value) {
                        setState(() {
                          _slider = value;
                          shared.inputFontSize = 18 + value;
                          shared.bigFontSize = 16 + value;
                          shared.smallFontSize = 14 + value;
                          shared.iconSize = 24 + _slider;
                          _sliderLabel = "font size: +${value.toString()}";
                          shared.baseSize = _slider;
                        });
                      },
                      divisions: 10, label: _sliderLabel
                  )),
                  IconButton(
                      icon: const Icon(Icons.zoom_in),
                      onPressed: () {
                        if(_slider < 10) {
                          setState(() {
                            _slider++;
                            shared.inputFontSize = 18 + _slider;
                            shared.bigFontSize = 16 + _slider;
                            shared.smallFontSize = 14 + _slider;
                            shared.iconSize = 24 + _slider;
                            _sliderLabel = "font size:+${_slider.toString()}";
                            shared.baseSize = _slider;
                          });
                        }
                      }
                  ),
                ]),

            const Image(
              image: AssetImage('assets/oldpeople.png'),
              width: 310,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // email
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          _email = val;
                        });
                      },
                      validator: (val) {
                        dynamic res = val!.isEmpty ? _fillField : null;
                        return res;
                      },
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        labelText: "E-mail",
                        labelStyle: TextStyle(color: Colors.green, fontSize: shared.inputFontSize),
                        icon: const Icon(Icons.people,
                            color: Colors.green), //icon at head of input
                      ),
                    ),
                  ),
                  // password
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          _password = val;
                        });
                      },
                      validator: (val) {
                        dynamic res;
                        if (val!.isEmpty){
                          res = _fillField;
                        }else if(val!.length < 6){
                          res = _sizeLessThan6;
                        }
                        return res;
                      },
                      obscureText: !_hidden,
                      // obscureText: true,
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          icon: const Icon(Icons.lock,
                              color: Colors.green), //icon at head of input
                          //prefixIcon: Icon(Icons.people), //you can use prefixIcon property too.
                          labelText: "Password",
                          labelStyle: TextStyle(
                              color: Colors.green,
                              fontSize: shared.inputFontSize
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() => _hidden = !_hidden);
                              },
                              icon: Icon(
                                  color: Colors.green,
                                  _hidden ?
                                  Icons.visibility :
                                  Icons.visibility_off
                              )
                          ) //icon at tail of input
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth.signInWithEmailAndPassword(_email, _password);
                            if (result == null) {
                              _error = "Algo deu errado";
                              setState(() {
                                loading = false;
                              });
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        title: Text('Algo deu errado!'),
                                        content: Text('Usuário/senha incorretos'),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Ok')),
                                        ]);
                                  });
                            }
                          }
                          // Navigator.pushNamed(context, '/home');
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[400]),
                        child: Text('Login', style: TextStyle(
                            fontSize: shared.inputFontSize)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                          'Não possui conta? Cadastre-se!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: shared.smallFontSize,
                              color: Colors.blue,
                              decoration: TextDecoration.underline
                          )),

                    ),
                  ),
                ],
              ),
            ),
          ],
        ),]
      ),
    );
  }
}
