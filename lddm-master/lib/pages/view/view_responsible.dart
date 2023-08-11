import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:lddm/shared.dart';
import 'package:intl/intl.dart';

class ViewResponsible extends StatefulWidget {
  const ViewResponsible({Key? key}) : super(key: key);

  @override
  State<ViewResponsible> createState() => _ViewResponsibleState();
}

class _ViewResponsibleState extends State<ViewResponsible> {
  int n_responsible = 0;
  final shared = SharedVariables();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: const Text('Meus responsáveis'),
        elevation: 0,
      ),
      body: Center(
          child: ListView(
            children: [
              for(int i = 0; i < n_responsible; i++)
                ExpansionTile(title: Text('Nome do responsável $i', style: TextStyle(fontSize: shared.bigFontSize)),
                    childrenPadding: const EdgeInsets.only(left:30), children: [
                      ListTile(title: Text('... informações pertinentes ...', style: TextStyle(fontSize: shared.bigFontSize))),
                      ElevatedButton(
                        onPressed: () {

                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[400]),
                        child: Text('Apagar', style: TextStyle(fontSize: shared.smallFontSize)),
                      )
                    ]
                )
            ],
          )
          ),
    );
  }
}
