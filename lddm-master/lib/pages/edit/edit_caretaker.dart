import 'package:flutter/material.dart';

class EditCaretaker extends StatelessWidget {
  const EditCaretaker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: const Text('Editar responsável'),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  labelText: "Nome do responsável",
                  labelStyle: TextStyle(color: Colors.green),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // Cancel
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[400]),
                      child: const Text('Cancelar'),
                    ),
                  ),
                ),

                // Add
                Container(
                  margin: const EdgeInsets.all(0),
                  child: SizedBox(
                    width: 175,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[400]),
                      child: const Text('Editar responsável'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
