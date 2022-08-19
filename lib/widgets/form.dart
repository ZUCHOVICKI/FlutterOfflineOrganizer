import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:test_offline/helpers/actual_time.dart';
import 'package:test_offline/provider/providers.dart';
import 'package:test_offline/widgets/widgets.dart';

class InputFormFields extends StatelessWidget {
  final bool status;

  const InputFormFields({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorsStatus = status ? Colors.green : Colors.red;
    FormsProvider formsProvider = Provider.of<FormsProvider>(context);
    String? imageFile = formsProvider.imagefile;
    Uint8List bytes = base64Decode(imageFile!);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(status ? 'Online' : 'Offline'),
        backgroundColor: colorsStatus,
        actions: [
          IconButton(
              onPressed: () {
                DataBaseProvider dataBaseProvider =
                    Provider.of<DataBaseProvider>(context, listen: false);

                dataBaseProvider.getAllTestDB();
                Navigator.pushNamed(context, 'allItems');
              },
              icon: const Icon(Icons.all_inbox))
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              Stack(children: [
                SizedBox(
                  width: double.infinity,
                  height: size.height * .4,
                  child: Image.memory(
                    bytes,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () {
                      _getFromCamera(formsProvider);
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
                      _getFromGallery(formsProvider);
                    },
                    icon: const Icon(
                      Icons.photo,
                    ),
                  ),
                )
              ]),
              const SizedBox(height: 25),
              FormFieldTitle(formsProvider: formsProvider),
              const SizedBox(height: 25),
              FormFieldDesc(formsProvider: formsProvider),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorsStatus,
        onPressed: () {
          if (status) {
            //TODO CHANGE TO ACUTAL REST CALL
            print("Realizando Llamada HTTP");
          } else {
            String datetime = actualTime();
            if (formsProvider.title != '') {
              DataBaseProvider dataBaseProvider =
                  Provider.of<DataBaseProvider>(context, listen: false);

              dataBaseProvider.nuevoTestDB(
                  formsProvider.title,
                  formsProvider.description,
                  formsProvider.imagefile!,
                  datetime);

              formsProvider.cleanInputs();
            }
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

_getFromCamera(FormsProvider formsProvider) async {
  XFile? pickedFile = await ImagePicker().pickImage(
    source: ImageSource.camera,
    maxWidth: 1800,
    maxHeight: 1800,
  );
  if (pickedFile != null) {
    String img64 = base64Encode(File(pickedFile.path).readAsBytesSync());
    formsProvider.imagefile = img64;
  }
}

_getFromGallery(FormsProvider formsProvider) async {
  XFile? pickedFile = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    maxWidth: 1800,
    maxHeight: 1800,
  );
  if (pickedFile != null) {
    String img64 = base64Encode(File(pickedFile.path).readAsBytesSync());
    formsProvider.imagefile = img64;
  }
}
