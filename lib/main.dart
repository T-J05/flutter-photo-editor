import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:photo_editor/pages/camara.dart';
import 'package:photo_editor/pages/editor.dart';
import 'package:photo_editor/pages/prueba.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  XFile? photo;

  Future getImageFromCamara(context) async {
    photo = await ImagePicker().pickImage(source: ImageSource.camera);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyWidget(
                  photo: photo,
                )));
    setState(() {});
  }

  Future getImageFromGallery(context) async {
    photo = await ImagePicker().pickImage(source: ImageSource.gallery);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyWidget(
                  photo: photo,
                )));
    setState(() {});
  }

  Future editing(context) async {
    photo = await ImagePicker().pickImage(source: ImageSource.gallery);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PreviewPage(
                  photo: photo,
                )));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  getImageFromCamara(context);
                },
                child: const Text("Picker camara")),
            ElevatedButton(
                onPressed: () {
                  getImageFromGallery(context);
                },
                child: const Text("Picker galeria")),
            ElevatedButton(
                onPressed: () {
                  editing(context);
                },
                child: const Text("editor")),
            const SizedBox(
              height: 50,
            ),
            photo == null
                ? const Icon(Icons.image)
                : Image.file(
                    File(photo!.path),
                    width: 100,
                    height: 100,
                  )
          ],
        ),
      ),
    );
  }
}
