import 'package:flutter/material.dart';

import 'package:test_offline/widgets/widgets.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: InputFormFields(
        status: false,
      ),
    );
  }
}
