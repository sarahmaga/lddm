import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lddm/models/user.dart';

class DatabaseService {

  late final String? uid;
  DatabaseService({ required this.uid });

  // collection reference

  final CollectionReference _userCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference _illnessCollection = FirebaseFirestore.instance.collection("illness");
  final CollectionReference _reminderCollection = FirebaseFirestore.instance.collection("reminders");
  final CollectionReference _prescriptionCollection = FirebaseFirestore.instance.collection("prescriptions");


  Future createUser(String? name, String? username, String? email,
      String? password, bool? isCaretaker, bool? isSelfSufficient, String? caretaker, bool merge) async {

    return _userCollection.doc(uid).set({
      "name": name,
      "username": username,
      "email": email,
      "password": password,
      "isCaretaker": isCaretaker,
      "isSelfSufficient": isSelfSufficient,
      "caretaker": caretaker,
      "profile_photo_URL": ""
    }, SetOptions(merge: merge));
  }

  Future createIllness(String? illness, String? intensity, String? notes) async {
    return _illnessCollection.doc(uid).collection("allData").add({
      "illness": illness,
      "intensity": intensity,
      "notes": notes
    });
  }

  Future createReminder(String? description, DateTime? dateTime, bool? isRecurrent) async {
    return _reminderCollection.doc(uid).collection("allData").add({
      "description": description,
      "datetime": dateTime,
      "isRecurrent": isRecurrent
    });
  }

  Future createPrescription(String? name, String? dosage, String? notes, String? illness) async {
    return _prescriptionCollection.doc(uid).collection("allData").add({
      "medicationName": name,
      "dosage": dosage,
      "notes": notes,
      "illness": illness
    });
  }

  Future updateCaretaker(String? caretaker) async {
    return _userCollection.doc(uid).set({
      "caretaker": caretaker
    }, SetOptions(merge: true));
  }
  Future updateProfilePhoto(String? imageURL) async {
    return _userCollection.doc(uid).set({
      "profile_photo_URL": imageURL
    }, SetOptions(merge: true));
  }

  Future deleteIllness(String? id) async {
    return _illnessCollection.doc(uid).collection("allData").doc(id).delete();
  }

  Future deleteReminder(String? id) async {
    return _reminderCollection.doc(uid).collection("allData").doc(id).delete();
  }

  Future deletePrescription(String? id) async {
    return _prescriptionCollection.doc(uid).collection("allData").doc(id).delete();
  }

  /// get all users
  Stream<QuerySnapshot> get users {
    return _userCollection.snapshots();
  }

  Stream<DocumentSnapshot<Object?>> get user {
    return _userCollection.doc(uid).snapshots();
  }

  /// Get all elderly users that have the logged user as caretaker
  Stream<QuerySnapshot> get elderly {
    return _userCollection.where("caretaker", isEqualTo: uid).snapshots();
  }

  Stream<QuerySnapshot> get illnesses {
    return _illnessCollection.doc(uid).collection("allData").snapshots();
  }

  Stream<QuerySnapshot> get reminders {
    return _reminderCollection.doc(uid).collection("allData").snapshots();
  }

  Stream<QuerySnapshot> get prescriptions {
    return _prescriptionCollection.doc(uid).collection("allData").snapshots();
  }
}