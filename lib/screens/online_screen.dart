import 'package:flutter/material.dart';

import 'package:test_offline/widgets/widgets.dart';

class OnlineScreen extends StatelessWidget {
  const OnlineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: InputFormFields(
        status: true,
      ),
    );
  }
}
