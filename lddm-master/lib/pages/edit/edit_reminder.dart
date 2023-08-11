import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditReminder extends StatefulWidget {
  const EditReminder({Key? key}) : super(key: key);

  @override
  State<EditReminder> createState() => _EditReminderState();
}

class _EditReminderState extends State<EditReminder> {
  bool checkbox = false;
  late DateTime date1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: const Text('Editar alarme'),
        elevation: 0,
      ),
      body: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                    labelText: "Descrição do alarme",
                    labelStyle: TextStyle(color: Colors.green),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                child: SizedBox(
                  child: DateTimeField(
                    format: DateFormat("yyyy-MM-dd HH:mm"),
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
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
                title: const Text("Lembrete recorrente",
                    style: TextStyle(color: Colors.green)),
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
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/home');
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[400]),
                        child: const Text('Cancelar'),
                      ),
                    ),
                  ),

                  // Add
                  Container(
                    margin: const EdgeInsets.all(0),
                    child: SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/home');
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[400]),
                        child: const Text('Editar alarme'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
