import 'package:flutter/material.dart';
import 'package:lddm/services/auth.dart';
import 'package:lddm/shared/loading.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _Register();
}

class _Register extends State<Register> {
  final AuthService _auth = AuthService();

  String _name = '';
  String _email = '';
  String _username = '';
  String _password1 = '';
  String _password2 = '';
  bool _isCaretaker = false;

  String _errorMsg = '';
  bool loading = false;

  final String _fillField = "Esse campo precisa ser preenchido";
  final String _sizeLessThan6 = "A senha deve ter no mínimo 6 caracteres";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() :Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: const Text('Registrar'),
        elevation: 0,
      ),
      body: ListView(semanticChildCount: 1, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Cadastre-se',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // name
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          _name = val;
                        });
                      },
                      validator: (val) {
                        dynamic res = val!.isEmpty ? _fillField : null;
                        return res;
                      },
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        labelText: "Name",
                        labelStyle: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
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
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        labelText: "E-mail",
                        labelStyle: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),

                  // username
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          _username = val;
                        });
                      },
                      validator: (val) {
                        dynamic res = val!.isEmpty ? _fillField : null;
                        return res;
                      },
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        labelText: "Username",
                        labelStyle: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),

                  // password
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          _password1 = val;
                        });
                      },
                      validator: (val) {
                        dynamic res;
                        if (val!.isEmpty) {
                          res = _fillField;
                        } else if (val!.length < 6) {
                          res = _sizeLessThan6;
                        }
                        return res;
                      },
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),

                  // repeat password
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          _password2 = val;
                        });
                      },
                      validator: (val) {
                        dynamic res;
                        if (val!.isEmpty) {
                          res = _fillField;
                        } else if (val!.length < 6) {
                          res = _sizeLessThan6;
                        }
                        return res;
                      },
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        labelText: "Repeat password",
                        labelStyle: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),

                  CheckboxListTile(
                    //only check box
                    title: const Text("Cadastrar como responsável",
                        style: TextStyle(color: Colors.green)),
                    checkColor: Colors.white,
                    activeColor: Colors.green,
                    value: _isCaretaker, //unchecked
                    onChanged: (bool? value) {
                      //value returned when checkbox is clicked
                      setState(() {
                        _isCaretaker = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),

                  // register
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                          setState(() => loading = true);
                            dynamic result = await _auth.registerWithEmailAndPassword(
                                    _name,
                                    _username,
                                    _email,
                                    _password1,
                                    _password2,
                                    _isCaretaker);

                            if (_password1 != _password2) {
                              setState(() {
                                loading = false;
                              });
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        title: Text('Senhas diferentes!'),
                                        content: Text(
                                            'A senha repetida é diferente da primeira'),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Ok')),
                                        ]);
                                  });
                            } else if (result != null) {
                              setState(() {
                                loading = false;
                              });
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        title: Text('Sucesso'),
                                        content:
                                            Text('Usuário criado com sucesso'),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Ok')),
                                        ]);
                                  });
                            } else {
                                setState(() {
                                loading = false;
                                });
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        title: Text('Algo deu errado!'),
                                        content: Text('Ocorreu um problema'),
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
                          // Navigator.pushNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[400]),
                        child: const Text('Criar conta'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
