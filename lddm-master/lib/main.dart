import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lddm/pages/authenticate/register.dart';
import 'package:lddm/pages/authenticate/login.dart';
import 'package:lddm/pages/profile.dart';
import 'package:lddm/pages/home/home.dart';

import 'package:lddm/pages/add/add_reminder.dart';
import 'package:lddm/pages/add/add_caretaker.dart';
import 'package:lddm/pages/add/add_prescription.dart';
import 'package:lddm/pages/add/add_illness.dart';

import 'package:lddm/pages/edit/edit_reminder.dart';
import 'package:lddm/pages/edit/edit_illness.dart';

import 'package:lddm/pages/view/view_calendar.dart';
import 'package:lddm/pages/view/view_illness.dart';
import 'package:lddm/pages/view/view_alarms.dart';
import 'package:lddm/pages/view/view_prescription.dart';
import 'package:lddm/pages/view/view_responsible.dart';

import 'package:lddm/pages/wrapper.dart';
import 'package:lddm/services/auth.dart';

import 'models/user.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(StreamProvider<User?>.value(
    value: AuthService().user,
    initialData: null,
    child: MaterialApp(
      home: const Wrapper(),
      //initialRoute: '/login',
      routes: {
        '/login': (context) => const Login(),
        '/register': (context) => const Register(),
        '/home': (context) => const Home(),
        '/add_reminder': (context) => const AddReminder(),
        '/add_caretaker': (context) => const AddCaretaker(),
        '/add_prescription': (context) => const AddPrescription(),
        '/add_illness': (context) => const AddIllness(),
        '/profile': (context) => const Profile(),
        '/calendar': (context) => const ViewCalendar(),
        '/view_alarms': (context) => const ViewAlarms(),
        '/view_responsible': (context) => const ViewResponsible(),
        '/view_illness': (context) => const ViewIllness(),
        '/view_prescription': (context) => const ViewPrescription()
      },
    ),
  ));
}
