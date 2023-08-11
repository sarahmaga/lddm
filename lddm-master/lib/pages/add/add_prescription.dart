import 'package:flutter/material.dart';
import 'package:lddm/services/database.dart';
import 'package:lddm/shared.dart';
import 'package:lddm/shared/loading.dart';
import '../../services/auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AddPrescription extends StatefulWidget {
  const AddPrescription({Key? key}) : super(key: key);

  @override
  State<AddPrescription> createState() => _AddPrescriptionState();
}

class _AddPrescriptionState extends State<AddPrescription> {
  bool loading = false;
  String? _selectedIllness;
  @override
  Widget build(BuildContext context) {
    final shared = SharedVariables();
    final formKey = GlobalKey<FormState>();

    String medicationName = "";
    String dosage = "";
    String notes = "";

    String? loggedUserId = AuthService().getLoggedUser();

    final TextEditingController medicationNameController = TextEditingController();
    final TextEditingController dosageController = TextEditingController();
    final TextEditingController notesController = TextEditingController();

    return loading ? Loading() : Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.green[400],
        title: const Text('Adicionar receita'),
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
                    controller: medicationNameController,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      labelText: "Nome da medicação",
                      labelStyle: TextStyle(color: Colors.green,
                          fontSize: shared.bigFontSize),

                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: dosageController,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      labelText: "Dosagem",
                      hintText: 'Exemplo: 50mg',
                      labelStyle: TextStyle(color: Colors.green,
                          fontSize: shared.bigFontSize),

                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: notesController,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      labelText: 'Notas',
                      hintText: 'Frequência ou detalhes',
                      labelStyle: TextStyle(color: Colors.green,
                          fontSize: shared.bigFontSize),

                    ),
                  ),
                ),
                const SizedBox(height: 50),
                StreamBuilder<QuerySnapshot?>(
                  stream: DatabaseService(uid: shared.elderlyId ?? loggedUserId).illnesses,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text("Vazio");
                    }
                    List<DropdownMenuItem> illness = [];
                    for (var doc in snapshot.data!.docs) {
                      illness.add(
                          DropdownMenuItem(
                            value: doc.get("illness"),
                            child: Text(doc.get("illness"), style: TextStyle(
                                fontSize: shared.baseSize)),
                          )
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.medical_information, size: shared.iconSize),
                        const SizedBox(width: 10),
                        DropdownButton(
                          items: illness,
                          onChanged: (value) {
                            setState(() {
                              _selectedIllness = value;
                            });
                          },
                          value: _selectedIllness,
                        )
                      ],
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // Cancel
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: SizedBox(
                        width: 150,
                        // height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/home');
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[400]),
                          child: Text('Cancelar', style: TextStyle(
                              fontSize: shared.bigFontSize)),
                        ),
                      ),
                    ),

                    // Add
                    Container(
                      margin: const EdgeInsets.all(0),
                      child: SizedBox(
                        width: 150,
                        // height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              String? loggedUserId = AuthService().getLoggedUser();
                              DatabaseService dbService = DatabaseService(uid: loggedUserId);
                              dbService.user.listen((event) {
                                if (!event.get("isCaretaker")) {
                                  setState(() {
                                    loading = false;
                                  });
                                  dbService.createPrescription(
                                        medicationNameController.text,
                                        dosageController.text,
                                        notesController.text,
                                        _selectedIllness
                                  );
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            title: Text('Sucesso!'),
                                            content: Text('Receita adicionada com sucesso!'),
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
                                  DatabaseService(uid: shared.elderlyId)
                                      .createPrescription(
                                      medicationNameController.text,
                                      dosageController.text,
                                      notesController.text,
                                      _selectedIllness);
                                }
                              });
                            }
                            Navigator.pushNamed(context, '/home');
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[400]),
                          child: Text('Concluir', style: TextStyle(
                              fontSize: shared.bigFontSize)),
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

