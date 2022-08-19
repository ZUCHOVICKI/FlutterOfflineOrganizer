import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:test_offline/helpers/actual_time.dart';
import 'package:test_offline/provider/db_provider.dart';
import 'package:test_offline/provider/forms_provider.dart';

import '../UI/ui.dart';
import '../models/test_model.dart';

class OneItemScreen extends StatelessWidget {
  const OneItemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FormsProvider formsProvider = Provider.of<FormsProvider>(context);
    DataBaseProvider dataBaseProvider = Provider.of<DataBaseProvider>(context);
    final colorsStatus =
        formsProvider.currentConnectionState ? Colors.green : Colors.red;
    final test = ModalRoute.of(context)!.settings.arguments as TestModel;
    Uint8List bytes = base64Decode(test.image);
    formsProvider.reDraw;
    return Scaffold(
      appBar: AppBar(
        title: Text(test.title),
        backgroundColor: colorsStatus,
        actions: [
          IconButton(
              onPressed: () {
                _deleteAlert(context, dataBaseProvider, test);
              },
              icon: const Icon(Icons.delete_forever))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _ImgStack(test: test, bytes: bytes, formsProvider: formsProvider),
            _EditableTitleInput(formsProvider: formsProvider, test: test),
            const SizedBox(
              height: 40,
            ),
            _EditableDescriptionInput(formsProvider: formsProvider, test: test),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorsStatus,
        onPressed: () {
          TestModel newTest = TestModel(
              title: test.title,
              description: test.description,
              image: test.image,
              id: test.id,
              date: test.date);
          dataBaseProvider.updateTestDB(newTest);

          Navigator.pop(context);
        },
        child: const Icon(Icons.save),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<dynamic> _deleteAlert(
      BuildContext context, DataBaseProvider dataBaseProvider, TestModel test) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm"),
        content: const Text("Are you sure you wish to delete this item?"),
        actions: <Widget>[
          ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.red),
              onPressed: () {
                dataBaseProvider.deleteTestDB(test.id!);
                // Navigator.pushReplacementNamed(context, 'home');
                Navigator.pushNamedAndRemoveUntil(
                    context, 'home', (_) => false);
              },
              child: const Text("DELETE")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.green),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("CANCEL"),
          ),
        ],
      ),
    );
  }
}

class _EditableDescriptionInput extends StatelessWidget {
  const _EditableDescriptionInput({
    Key? key,
    required this.formsProvider,
    required this.test,
  }) : super(key: key);

  final FormsProvider formsProvider;
  final TestModel test;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      decoration: InputDecorationsUI.uIInputDecoration(
          hintText: 'Description',
          labelText: 'Description',
          prefixIcon: Icons.person,
          status: formsProvider.currentConnectionState),
      initialValue: test.description,
      onChanged: (value) {
        test.description = value;
      },
    );
  }
}

class _EditableTitleInput extends StatelessWidget {
  const _EditableTitleInput({
    Key? key,
    required this.formsProvider,
    required this.test,
  }) : super(key: key);

  final FormsProvider formsProvider;
  final TestModel test;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      decoration: InputDecorationsUI.uIInputDecoration(
          hintText: 'Title',
          labelText: 'Title',
          prefixIcon: Icons.person,
          status: formsProvider.currentConnectionState),
      initialValue: test.title,
      onChanged: (value) {
        test.title = value;
      },
    );
  }
}

class _ImgStack extends StatelessWidget {
  const _ImgStack({
    Key? key,
    required this.test,
    required this.bytes,
    required this.formsProvider,
  }) : super(key: key);

  final TestModel test;
  final Uint8List bytes;
  final FormsProvider formsProvider;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(children: [
      GestureDetector(
        onTap: () => Navigator.pushNamed(context, 'fullImage', arguments: test),
        child: SizedBox(
          width: double.infinity,
          height: size.height * .4,
          child: Image.memory(
            bytes,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Positioned(
        top: 0,
        right: 0,
        child: IconButton(
          onPressed: () {
            _getFromCamera(formsProvider, test);
          },
          icon: const Icon(
            Icons.photo_camera,
          ),
        ),
      ),
      Positioned(
        top: 0,
        left: 0,
        child: IconButton(
          onPressed: () {
            _getFromGallery(formsProvider, test);
          },
          icon: const Icon(Icons.photo),
        ),
      ),
      Positioned(bottom: 0, right: 0, child: Text(test.date!))
    ]);
  }
}

_getFromCamera(FormsProvider formsProvider, TestModel test) async {
  XFile? pickedFile = await ImagePicker().pickImage(
    source: ImageSource.camera,
    maxWidth: 1800,
    maxHeight: 1800,
  );
  if (pickedFile != null) {
    String img64 = base64Encode(File(pickedFile.path).readAsBytesSync());
    formsProvider.editableImage = img64;
    test.image = img64;
    test.date = actualTime();
  }
}

_getFromGallery(FormsProvider formsProvider, TestModel test) async {
  XFile? pickedFile = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    maxWidth: 1800,
    maxHeight: 1800,
  );
  if (pickedFile != null) {
    String img64 = base64Encode(File(pickedFile.path).readAsBytesSync());
    formsProvider.editableImage = img64;
    test.image = img64;
    test.date = actualTime();
  }
}
