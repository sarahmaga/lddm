import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../../shared.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.picture}) : super(key: key);

  final XFile picture;


  Future getImageText() async {
    final shared = SharedVariables();
    String path = picture.path;

    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage = InputImage.fromFilePath(path);

    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    String text = recognizedText.text;
    print(text);
    String pictureText = "";
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        pictureText += line.text;
      }
    }
    shared.pictureText = pictureText;
    return pictureText;
  }
  
  @override
  Widget build(BuildContext context) {
    getImageText();
    final shared = SharedVariables();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green[400],
          title: const Text('Visualizar foto')
      ),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.file(File(picture.path), fit: BoxFit.cover, width: 250),
          const SizedBox(height: 24),
          Text(picture.name),
          Text("Texto identificado: ${shared.pictureText}",style: TextStyle(fontSize: shared.bigFontSize))
        ]),
      ),
    );
  }
}