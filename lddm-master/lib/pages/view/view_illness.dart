import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lddm/shared.dart';
import 'package:lddm/services/auth.dart';
import 'package:lddm/services/database.dart';

class ViewIllness extends StatefulWidget {
  const ViewIllness({Key? key}) : super(key: key);

  @override
  State<ViewIllness> createState() => _ViewIllnessState();
}

class _ViewIllnessState extends State<ViewIllness> {
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
        title: const Text('Minhas enfermidades'),
        elevation: 0,
      ),
      body: Center(
        child: StreamBuilder(
          stream: dbService.illnesses,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                var data = snapshot.data?.docs[index];
                return ExpansionTile(
                  title: Text(data?.get("illness"), style: TextStyle(fontSize: shared.bigFontSize)),
                    childrenPadding: const EdgeInsets.only(left:30),
                  children: [
                    ListTile(title: Text('Intensidade:\t ${data?.get("intensity")}', style: TextStyle(fontSize: shared.bigFontSize))),
                    ListTile(title: Text('Notas:\t ${data?.get("notes")}', style: TextStyle(fontSize: shared.bigFontSize))),
                    ElevatedButton(
                      onPressed: () {
                        // delete on firestore using data.id
                        dbService?.deleteIllness(data?.id)
                            .then((value) => print("${data?.id} was deleted."),
                        onError: (e) => print("${data?.id} was not deleted. $e")
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400]),
                      child: Text('Apagar', style: TextStyle(fontSize: shared.smallFontSize)),
                    )
                  ],
                );
              },
            );
          },
        )
      ),
    );
  }
}
