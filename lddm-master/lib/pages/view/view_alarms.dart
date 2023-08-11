import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:lddm/shared.dart';
import 'package:intl/intl.dart';

import '../../services/auth.dart';
import '../../services/database.dart';

class ViewAlarms extends StatefulWidget {
  const ViewAlarms({Key? key}) : super(key: key);

  @override
  State<ViewAlarms> createState() => _ViewAlarmsState();
}

class _ViewAlarmsState extends State<ViewAlarms> {
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
        title: const Text('Meus alarmes'),
        elevation: 0,
      ),
      body: Center(
        child: StreamBuilder(
        stream: dbService.reminders,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data?.docs[index];
              return ExpansionTile(
                title: Text(data?.get("description"), style: TextStyle(fontSize: shared.bigFontSize)),
                childrenPadding: const EdgeInsets.only(left:30),
                children: [
                  ListTile(title: Text('É diário? :\t ${
                      data?.get("isRecurrent") ? "Sim" : "Não"
                  }.', style: TextStyle(fontSize: shared.bigFontSize))),
                  ListTile(title: Text('Horário/Data:\t ${
                    // if recurrent, show only hours
                    data?.get("datetime")
                  }.', style: TextStyle(fontSize: shared.bigFontSize))),
                  ElevatedButton(
                    onPressed: () {
                      // delete on firestore using data.id
                      dbService?.deleteReminder(data?.id)
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
      ),
          ),
    );
  }
}
