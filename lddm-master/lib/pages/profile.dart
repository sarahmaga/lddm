import 'package:flutter/material.dart';
import 'package:lddm/services/auth.dart';
import 'package:lddm/shared.dart';
import '../services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lddm/shared/loading.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {
  XFile? image;
  bool loading = false;

  final ImagePicker picker = ImagePicker();
  final shared = SharedVariables();
  String imageUrl = '';

  //we can upload image from camera or from gallery based on parameter
  void getImage(ImageSource media) async {
    // Pick image
    var img = await picker.pickImage(source: media);
    if (img == null) return;
    // Reference for the root on firebase
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDir = referenceRoot.child('profile_photos');

    // Reference to the image on firebase
    Reference referenceImageToUpload = referenceDir.child('${img?.name}');
    // Upload images to firebase
    try {
      await referenceImageToUpload.putFile(File(img!.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
      String? loggedUserId = AuthService().getLoggedUser();
      DatabaseService(uid: loggedUserId).updateProfilePhoto(imageUrl);
    } catch (error) {}
    setState(() {
      image = img;
    });
  }

  //show popup dialog
  void  myAlert() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            // shape:
            // RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Escolha uma imagem para sua foto de perfil',
                style: TextStyle(fontSize: shared.bigFontSize)),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400]),
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image, size: shared.iconSize),
                        Text('Galeria',
                            style: TextStyle(fontSize: shared.bigFontSize)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[400]),
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera, size: shared.iconSize),
                        Text(' Camera',
                            style: TextStyle(fontSize: shared.bigFontSize)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final shared = SharedVariables();
    final AuthService auth = AuthService();

    String? loggedUserId = AuthService().getLoggedUser();
    DatabaseService dbService = DatabaseService(uid: loggedUserId);

    final formKey = GlobalKey<FormState>();

    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green[400],
              title: const Text('Perfil'),
              elevation: 0,
            ),
            body: Center(
                child: StreamBuilder(
              stream: dbService.user,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                return ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    var data = snapshot.data;
                    return Form(
                      key: formKey,
                      child: Column(
                        children: [

                          data?.get("profile_photo_URL") != ""
                              ? Container(
                                  margin: const EdgeInsets.all(10),
                                  child: SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        //to show image, you type like this.
                                        data?.get("profile_photo_URL"),
                                        fit: BoxFit.cover,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 300,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  margin: const EdgeInsets.all(20),
                                  child: const SizedBox(
                                    width: 200,
                                    height: 200,
                                    child: Image(
                                      image: AssetImage(
                                          'assets/profile_photo2.png'),
                                      width: 310,
                                    ),
                                  ),
                                ),
                          ElevatedButton(
                            onPressed: () {
                                myAlert();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[400]),
                            child: Text('Modificar foto',
                                style: TextStyle(fontSize: shared.bigFontSize)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              initialValue: data?.get("name"),
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                                labelText: "Seu nome",
                                labelStyle: TextStyle(
                                    color: Colors.green,
                                    fontSize: shared.bigFontSize),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              initialValue: data?.get("username"),
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                                labelText: "Seu nome de usuário",
                                labelStyle: TextStyle(
                                    color: Colors.green,
                                    fontSize: shared.bigFontSize),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              initialValue: data?.get("email"),
                              enabled: false,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                                labelText: "Seu E-mail",
                                labelStyle: TextStyle(
                                    color: Colors.green,
                                    fontSize: shared.bigFontSize),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(20),
                            child: SizedBox(
                              width: 250,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await auth.signOut();
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[400]),
                                child: Text('Sair',
                                    style: TextStyle(
                                        fontSize: shared.bigFontSize)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            )),
          );
  }
}
