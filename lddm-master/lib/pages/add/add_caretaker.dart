import 'package:flutter/material.dart';
import 'package:lddm/services/auth.dart';
import 'package:lddm/services/database.dart';
import 'package:lddm/shared.dart';
import 'package:lddm/shared/loading.dart';
import '../../models/user.dart';

class AddCaretaker extends StatefulWidget {
  const AddCaretaker({Key? key}) : super(key: key);

  @override
  State<AddCaretaker> createState() => _AddCaretakerState();
}

class _AddCaretakerState extends State<AddCaretaker> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final shared = SharedVariables();

    // String caretakerEmail = '';
    String error = '';

    const String fillField = "Esse campo precisa ser preenchido";
    const String emailNotFoundMsg = "Esse e-mail não foi encontrado na nossa base de dados";

    // final AuthService _auth = AuthService();
    final formKey = GlobalKey<FormState>();
    final TextEditingController caretakerEmail = TextEditingController();

    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: const Text('Adicionar responsável'),
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: ListView(
            semanticChildCount: 1,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: caretakerEmail,
                      // onChanged: (val) {
                      //   setState(() {
                      //     caretakerEmail = val;
                      //   });
                      // },
                      // validator: (_) {
                      //   dynamic res = caretakerEmail.text!.isNotEmpty ? fillField : null;
                      //   return res;
                      // },
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        labelText: "E-mail do responsável",
                        labelStyle: TextStyle(color: Colors.green,
                            fontSize: shared.inputFontSize),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // Cancel
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: SizedBox(
                          width: 150,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/home');
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[400]),
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Text('Cancelar', style: TextStyle(
                                    fontSize: shared.bigFontSize
                                )),
                              )),
                        ),
                      ),
                      // Add
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: SizedBox(
                          width: 150,
                          child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  setState(() => loading = true);
                                  String? loggedUserId = AuthService().getLoggedUser();
                                  String caretakerId = "";

                                  DatabaseService(uid: loggedUserId).users.listen((event) {
                                    for (var doc in event.docs) {
                                      if (doc.get("email") == caretakerEmail.text) {
                                        caretakerId = doc.id;
                                        setState(() {
                                          loading = false;
                                        });
                                        if (caretakerId == "") {
                                          error = emailNotFoundMsg;
                                          setState(() {
                                            loading = false;
                                          });
                                        } else {
                                          // email was found, set caretaker value for logged user
                                          DatabaseService(uid: loggedUserId)
                                              .updateCaretaker(caretakerId);
                                          setState(() {
                                            loading = false;
                                          });
                                        }
                                        // show success or error msg

                                        break;
                                      }
                                    }
                                  });
                                }
                                 Navigator.pushNamed(context, '/home');
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[400]),
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Text('Concluir', style: TextStyle(
                                    fontSize: shared.bigFontSize
                                )),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ]
        ),
      ),
    );
  }
}
