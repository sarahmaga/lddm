import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lddm/services/database.dart';
import 'package:lddm/shared.dart';
import 'package:lddm/shared/loading.dart';
import '../../services/auth.dart';

class AddReminder extends StatefulWidget {
  const AddReminder({Key? key}) : super(key: key);

  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {

  bool checkbox = false;
  bool loading = false;
  final formKey = GlobalKey<FormState>();

  DateTime date1 = DateTime(2023);
  DateTime? dateTime = DateTime(2023);
  String description = "";

  @override
  Widget build(BuildContext context) {
    final shared = SharedVariables();

    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: const Text('Adicionar alarme'),
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
                  setState(() {
                    description = val;
                  });
                },
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  labelText: "Descrição do alarme",
                  labelStyle: TextStyle(color: Colors.green,
                    fontSize: shared.inputFontSize),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: SizedBox(
                child: DateTimeField(
                  style: TextStyle(color: Colors.green,
                      fontSize: shared.inputFontSize),
                  format: DateFormat("yyyy-MM-dd HH:mm"),
                  onShowPicker: (context, currentValue) async {
                    final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2022),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()),
                      );
                      return DateTimeField.combine(date, time);
                    } else {
                      return currentValue;
                    }
                  },
                  onChanged: (val) {
                    dateTime = val;
                  },
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    labelText: "Data e hora do alarme",
                    labelStyle: TextStyle(color: Colors.green),
                  ),
                ),
              ),
            ),

            CheckboxListTile(
              //only check box
              title: Text("Lembrete recorrente",
                  style: TextStyle(color: Colors.green,
                      fontSize: shared.smallFontSize)),
              checkColor: Colors.white,
              activeColor: Colors.green,
              value: checkbox, //unchecked
              onChanged: (bool? value) {
                //value returned when checkbox is clicked
                setState(() {
                  checkbox = value!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
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
                          DatabaseService dbService = DatabaseService(uid: loggedUserId);
                          dbService.user.listen((event) {
                            if (!event.get("isCaretaker")) {
                              dbService.createReminder(description, date1, checkbox);
                              setState(() {
                                loading = false;
                              });
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        title: Text('Sucesso!'),
                                        content: Text('Alarme adicionado com sucesso!'),
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
                                  .createReminder(description, date1, checkbox);
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
        )]),
      ),
    );
  }
}
