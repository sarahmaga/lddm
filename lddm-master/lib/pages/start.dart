import 'package:flutter/material.dart';

class Start extends StatelessWidget {
  const Start({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Image(image: AssetImage('assets/oldpeople.png'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[200],
                ),
                child: const Text('Login'),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text('Não possui conta? Cadastre-se!'),
              ),
            ],
          ),
        )
      ),
    );
  }
}
