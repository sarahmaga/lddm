import 'dart:ffi';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lddm/pages/camera2.dart';
import 'package:lddm/shared.dart';

import 'package:lddm/services/auth.dart';
import 'package:lddm/services/database.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {

  String? _selectedElderly;

  @override
  Widget build(BuildContext context) {
    final shared = SharedVariables();

    DatabaseService(uid: AuthService().getLoggedUser()).user.listen((event) {
      if (event.get("isCaretaker") || event.get("caretaker") != null) {
        shared.hasCaretaker = true;
      }
    });

    return StreamProvider<QuerySnapshot?>.value(
      value: DatabaseService(uid: AuthService().getLoggedUser()).users,
      initialData: null,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[400],
          title: const Text('Página inicial'),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () => Navigator.pushNamed(context, '/profile'),
              icon: const Icon(Icons.account_circle),
            ),
          ],
          leading: Builder(builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu)
          )
        )),
        drawer: Drawer(
            backgroundColor: Colors.green,
            width: 325,
            child: SizedBox(height: double.infinity,
                child: Column(children: [Container(
                    color: Colors.white, child: const SizedBox(
                    height: 200, width: double.infinity)
                ),
                  // responsáveis
                  const SizedBox(height: 20),
                  ListTile(title: Row(children: [
                    Icon(Icons.people, size: shared.iconSize),
                    const SizedBox(width: 5),
                    Text('Meus responsáveis',
                        style: TextStyle(fontSize: shared.bigFontSize))]),
                      onTap: () => Navigator.pushNamed(context, '/view_responsible')
                  ),

                  // alarmes
                  const SizedBox(height: 10),
                  ListTile(title: Row(children: [
                    Icon(Icons.alarm, size: shared.iconSize),
                    const SizedBox(width: 5),
                    Text('Meus alarmes',
                        style: TextStyle(fontSize: shared.bigFontSize))]),
                      onTap: () => Navigator.pushNamed(context, '/view_alarms')
                  ),

                  // receitas
                  const SizedBox(height: 10),
                  ListTile(title: Row(children: [
                    Icon(Icons.wysiwyg, size: shared.iconSize),
                    const SizedBox(width: 5),
                    Text('Minhas receitas',
                        style: TextStyle(fontSize: shared.bigFontSize))]),
                      onTap: () => Navigator.pushNamed(context, '/view_prescription')
                  ),

                  // enfermidades
                  const SizedBox(height: 10),
                  ListTile(title: Row(children: [
                    Icon(Icons.medical_information, size: shared.iconSize),
                    const SizedBox(width: 5),
                    Text('Minhas enfermidades',
                        style: TextStyle(fontSize: shared.bigFontSize))]),
                      onTap: () => Navigator.pushNamed(context, '/view_illness')
                  ),

                  const SizedBox(height: 30),
                  Column(children: [
                    SizedBox(
                      width: 280, height: 60, child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white),
                        onPressed: () {
                          if(shared.baseSize == null) {
                            setState(() {
                              shared.baseSize = 0;
                              shared.iconSize = 24;
                              shared.bigFontSize = 16;
                              shared.smallFontSize = 14;
                              shared.inputFontSize = 18;
                            });
                          }
                          if(shared.baseSize! < 10) {
                            setState(() {
                              shared.baseSize = shared.baseSize! + 1;
                              shared.iconSize = 24 + shared.baseSize!;
                              shared.bigFontSize = 16 + shared.baseSize!;
                              shared.smallFontSize = 14 + shared.baseSize!;
                              shared.inputFontSize = 18 + shared.baseSize!;
                            });
                          }},
                        child: const Icon(Icons.zoom_in, color: Colors.black, size: 50)),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 280, height: 60, child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white),
                        onPressed: () {
                          if(shared.baseSize == null) {
                            setState(() {
                              shared.baseSize = 0;
                              shared.iconSize = 24;
                              shared.bigFontSize = 16;
                              shared.smallFontSize = 14;
                              shared.inputFontSize = 18;
                            });
                          }
                          if(shared.baseSize! > 0) {
                            setState(() {
                              shared.baseSize = shared.baseSize! - 1;
                              shared.iconSize = 24 + shared.baseSize!;
                              shared.bigFontSize = 16 + shared.baseSize!;
                              shared.smallFontSize = 14 + shared.baseSize!;
                              shared.inputFontSize = 18 + shared.baseSize!;
                            });
                          }},
                        child: const Icon(Icons.zoom_out, color: Colors.black, size: 50)),
                    )]),
                ])
            )),
        body: ListView(
          children: [Column(
            children: [
              const SizedBox(height: 50),
              StreamBuilder<QuerySnapshot?>(
                stream: DatabaseService(uid: AuthService().getLoggedUser()).elderly,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text("Vazio");
                  }
                  List<DropdownMenuItem> elderly = [];
                  for (var doc in snapshot.data!.docs) {
                    elderly.add(
                      DropdownMenuItem(
                        value: doc.id,
                        child: Text(doc.get("username"), style: TextStyle(
                            fontSize: shared.baseSize)),
                      )
                    );
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_circle, size: shared.iconSize),
                      const SizedBox(width: 10),
                      DropdownButton(
                        items: elderly,
                        onChanged: (value) {
                          setState(() {
                            _selectedElderly = value;
                            shared.elderlyId = _selectedElderly;
                          });
                        },
                        value: _selectedElderly,

                      )
                    ],
                  );
                },
              ),
              const SizedBox(height: 30),
              // reminder button
              Container(
                margin: const EdgeInsets.all(10),
                child: SizedBox(
                  width: 250,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/add_reminder');
                    },
                    icon: Icon(
                      Icons.add_alarm,
                      size: shared.iconSize,
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400]),
                    label: Container(
                      margin: const EdgeInsets.fromLTRB(5,15,0,15),
                      child: Text('Adicionar alarme',
                        style: TextStyle(fontSize: shared.bigFontSize)),
                    )),
                ),
              ),

              // add caretaker
              Container(
                margin: const EdgeInsets.all(10),
                child: SizedBox(
                  width: 250,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final id = AuthService().getLoggedUser();
                      DatabaseService(uid: id).users.listen((event) {
                        print("How many values: ${event.size}");
                        for (var doc in event.docs) {
                          print(doc.data());
                          if (doc.get("email") == "teste2@gmail.com") {
                            print(doc.id);
                            print("DONE");
                            break;
                          }
                        }
                      });
                      Navigator.pushNamed(context, '/add_caretaker');
                    },
                    icon: Icon(
                      Icons.accessibility,
                      size: shared.iconSize,
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400]),
                    label: Container(
                      margin: const EdgeInsets.fromLTRB(5,15,0,15),
                      child: Text('Adicionar responsável',
                        style: TextStyle(fontSize: shared.bigFontSize)),
                  )),
                ),
              ),

              // add prescription
              Container(
                margin: const EdgeInsets.all(10),
                child: SizedBox(
                  width: 250,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/add_prescription');
                    },
                    icon: Icon(
                      Icons.wysiwyg,
                      size: shared.iconSize,
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400]),
                    label: Container(
                      margin: const EdgeInsets.fromLTRB(5,15,0,15),
                      child: Text('Adicionar receitas',
                        style: TextStyle(fontSize: shared.bigFontSize)),
                  )),
                ),
              ),

              // add prescription using row instead of ElevatedButton.icon
              // Container(
              //   margin: const EdgeInsets.all(10),
              //   child: SizedBox(
              //     width: 250,
              //     height: 50,
              //     child: ElevatedButton(
              //       onPressed: () {
              //         Navigator.pushNamed(context, '/add_prescription');
              //       },
              //       style: ElevatedButton.styleFrom(
              //           backgroundColor: Colors.green[400]),
              //       child:  Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         // Cancel
              //         children: [
              //           Container(
              //             margin: const EdgeInsets.all(10),
              //             child: const Icon(
              //               Icons.wysiwyg,
              //               size: 24.0,
              //             ),
              //           ),
              //
              //           // Add
              //           Container(
              //             margin: const EdgeInsets.all(10),
              //             child: Text('Adicionar receita',
              //                 style: TextStyle(fontSize: shared.bigFontSize)),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),

              // add illness
              Container(
                margin: const EdgeInsets.all(10),
                child: SizedBox(
                  width: 250,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.medical_information,
                      size: shared.iconSize,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/add_illness');
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400]),
                    label: Container(
                      margin: const EdgeInsets.fromLTRB(5,15,0,15),
                      child: Text('Adicionar enfermidade',
                        style: TextStyle(fontSize: shared.bigFontSize)),
                  )),
                ),
              ),

              // calendar
              // Container(
              //   margin: const EdgeInsets.all(10),
              //   child: SizedBox(
              //     width: 250,
              //     child: ElevatedButton.icon(
              //       icon: Icon(
              //         Icons.calendar_month,
              //         size: shared.iconSize,
              //       ),
              //       onPressed: () {
              //         Navigator.pushNamed(context, '/calendar');
              //       },
              //       style: ElevatedButton.styleFrom(
              //           backgroundColor: Colors.green[400]),
              //       label: Container(
              //          margin: const EdgeInsets.fromLTRB(5,15,0,15),
              //          child: Text('Ver calendário',
              //             style: TextStyle(fontSize: shared.bigFontSize)),),
              //     )),
              //   ),
              // ),

              Container(
                margin: const EdgeInsets.all(20),
                child: SizedBox(
                  width: 300,
                  child: Column(
                      children: [
                        ElevatedButton.icon(
                            onPressed: () async {
                              await availableCameras().then((value) => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => CameraPage(cameras: value))));
                            },
                          icon: const Icon(
                            Icons.camera_enhance,
                            size: 65.0,
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightGreen[400]),
                          label: Container(
                            margin: const EdgeInsets.fromLTRB(0,10,0,10),
                            child: Text('Ver embalagem',
                              style: TextStyle(fontSize: shared.bigFontSize)),
                        )),]
                  )
                ),
              ),


              const SizedBox(height: 60,)
            ],
          )],
        ),
      ),
    );
  }
}
