import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:lddm/models/user.dart';
import 'package:lddm/services/database.dart';

class AuthService {

  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  // get user from firebase user

  User? _userFromFireBaseUser(fb.User? user) {
    dynamic result;
    if (user != null) {
      result = User.basic(user.uid);
    }
    return result;
  }

  // change user stream
  Stream<User?> get user {
    return _auth.authStateChanges().map((fb.User? user) => _userFromFireBaseUser(user));
  }

  // sign in with e-mail and password

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      dynamic result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result;
    } catch (e) {
      print(e.toString());
    }
  }
  // register with e-mail and password

  Future registerWithEmailAndPassword(String name, String username, String email,
      String password1, String password2,
      bool isCaretaker) async {
    try {
      if (password1 != password2) {
        throw Exception("Passwords don't match.");
      }
      final result = await _auth.createUserWithEmailAndPassword(email: email, password: password1);
      fb.User? user = result.user;
      await DatabaseService(uid: user!.uid).createUser(name, username, email, password1, isCaretaker, true, null, false);
      return _userFromFireBaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  // sign out

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  // fb.User?
  String getLoggedUser() {
    print('id logado: ${_auth.currentUser}');
    return _auth.currentUser!.uid;
  }
}