import 'package:flutter/material.dart';
import 'package:lddm/services/database.dart';
import 'package:lddm/shared.dart';
import 'package:lddm/shared/loading.dart';
import '../../services/auth.dart';

class AddIllness extends StatefulWidget {
  const AddIllness({Key? key}) : super(key: key);

  @override
  State<AddIllness> createState() => _AddIllnessState();
}

class _AddIllnessState extends State<AddIllness> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final shared = SharedVariables();

    final formKey = GlobalKey<FormState>();

    String illness = "";
    String intensity = "";
    String notes = "";

    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: const Text('Adicionar enfermidade'),
        elevation: 0,
      ),
      body: Form(
        key: formKey,
        child: ListView(
            semanticChildCount: 1,
            children: [Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    onChanged: (val) {
                      illness = val;
                    },
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      labelText: "Enfermidade",
                      hintText: "Exemplo: pressão alta",
                      labelStyle: TextStyle(color: Colors.green,
                          fontSize: shared.inputFontSize),

                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    onChanged: (val) {
                      intensity = val;
                    },
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      labelText: "Intensidade",
                      hintText: 'Exemplo: alta',
                      labelStyle: TextStyle(color: Colors.green,
                          fontSize: shared.inputFontSize),

                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    onChanged: (val) {
                      notes = val;
                    },
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      labelText: 'Notas',
                      hintText: 'Frequência ou detalhes',
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
                                  fontSize: shared.bigFontSize)),
                            )
                        ),
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
                                DatabaseService dbService = DatabaseService(uid: loggedUserId);
                                dbService.user.listen((event) {
                                  if (!event.get("isCaretaker")) {
                                    dbService.createIllness(illness, intensity, notes);
                                    setState(() {
                                      loading = false;
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              title: Text('Sucesso!'),
                                              content: Text('Enfermidade adicionada com sucesso!'),
                                              actions: <Widget>[
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Ok')),
                                              ]);
                                        });
                                  } else {
                                    DatabaseService(uid: shared.elderlyId)
                                        .createIllness(illness, intensity, notes);
                                    setState(() {
                                      loading = false;
                                    });

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

                            )
                        ),
                      ),
                    ),
                  ],
                ),


              ],
            ),]
        ),
      ),
    );
  }
}

