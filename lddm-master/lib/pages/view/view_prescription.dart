import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:lddm/shared.dart';
import 'package:intl/intl.dart';

import '../../services/auth.dart';
import '../../services/database.dart';

class ViewPrescription extends StatefulWidget {
  const ViewPrescription({Key? key}) : super(key: key);

  @override
  State<ViewPrescription> createState() => _ViewPrescriptionState();
}

class _ViewPrescriptionState extends State<ViewPrescription> {
  final shared = SharedVariables();

  @override
  Widget build(BuildContext context) {
    String? loggedUserId = AuthService().getLoggedUser();
    DatabaseService? dbService;

    if (shared.elderlyId == null) {
      dbService = DatabaseService(uid: loggedUserId);
    } else {
      dbService = DatabaseService(uid: shared.elderlyId);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: const Text('Minhas receitas'),
        elevation: 0,
      ),
      body: Center(
        child: StreamBuilder(
          stream: dbService.prescriptions,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data?.docs[index];
                return ExpansionTile(
                  title: Text(data?.get("medicationName"), style: TextStyle(fontSize: shared.bigFontSize)),
                  childrenPadding: const EdgeInsets.only(left:30),
                  children: [
                    ListTile(title: Text('Dosagem:\t ${data?.get("dosage")}.', style: TextStyle(fontSize: shared.bigFontSize))),
                    ListTile(title: Text('Notas:\t ${data?.get("notes")}.', style: TextStyle(fontSize: shared.bigFontSize))),
                    ListTile(title: Text('Enfermidade associada:\t ${data?.get("illness")}.', style: TextStyle(fontSize: shared.bigFontSize))),
                    ElevatedButton(
                      onPressed: () {
                        // delete on firestore using data.id
                        dbService?.deletePrescription(data?.id)
                            .then((value) => print("${data?.id} was deleted."),
                            onError: (e) => print("${data?.id} was not deleted. $e")
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400]),
                      child: Text('Apagar', style: TextStyle(fontSize: shared.bigFontSize)),
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
