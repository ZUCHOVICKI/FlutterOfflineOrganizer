import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_offline/models/test_model.dart';
import 'package:test_offline/provider/providers.dart';

class FullImage extends StatelessWidget {
  const FullImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final test = ModalRoute.of(context)!.settings.arguments as TestModel;
    Uint8List bytes = base64Decode(test.image);
    FormsProvider formsProvider = Provider.of<FormsProvider>(context);
    final colorsStatus =
        formsProvider.currentConnectionState ? Colors.green : Colors.red;
    formsProvider.reDraw;

    return Scaffold(
      appBar: AppBar(
        title: Text(test.title),
        backgroundColor: colorsStatus,
      ),
      body: Image.memory(
        bytes,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
    );
  }
}
