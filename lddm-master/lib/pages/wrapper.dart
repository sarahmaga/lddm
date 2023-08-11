import 'package:flutter/material.dart';
import 'package:lddm/models/user.dart';
import 'package:provider/provider.dart';

import 'home/home.dart';
import 'authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);
    print(user);
    if (user == null) {
      return const Authenticate();
    } else {
      return const Home();
    }
  }
}
