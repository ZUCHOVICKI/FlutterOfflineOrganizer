import 'package:flutter/material.dart';
import 'package:test_offline/provider/providers.dart';

import '../UI/ui.dart';

class FormFieldDesc extends StatelessWidget {
  const FormFieldDesc({
    Key? key,
    required this.formsProvider,
  }) : super(key: key);

  final FormsProvider formsProvider;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: formsProvider.descText,
      autocorrect: false,
      decoration: InputDecorationsUI.uIInputDecoration(
          hintText: 'Description',
          labelText: 'Description',
          prefixIcon: Icons.description,
          status: formsProvider.currentConnectionState),
      onChanged: (value) {
        formsProvider.description = value;
      },
    );
  }
}
