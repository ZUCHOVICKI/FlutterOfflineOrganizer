import 'package:flutter/material.dart';
import 'package:test_offline/provider/providers.dart';

import '../UI/ui.dart';

class FormFieldTitle extends StatelessWidget {
  const FormFieldTitle({
    Key? key,
    required this.formsProvider,
  }) : super(key: key);

  final FormsProvider formsProvider;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: formsProvider.titleText,
      autocorrect: false,
      decoration: InputDecorationsUI.uIInputDecoration(
          hintText: 'Title',
          labelText: 'Title',
          prefixIcon: Icons.person,
          status: formsProvider.currentConnectionState),
      // initialValue: formsProvider.title,
      onChanged: (value) {
        formsProvider.title = value;
      },
    );
  }
}
