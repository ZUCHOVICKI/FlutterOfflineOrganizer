import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:provider/provider.dart';
import 'package:test_offline/provider/forms_provider.dart';
import 'package:test_offline/screens/screens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FormsProvider formsProvider = Provider.of<FormsProvider>(context);
    return OfflineBuilder(
      connectivityBuilder:
          (BuildContext context, ConnectivityResult value, Widget child) {
        final bool connected = value != ConnectivityResult.none;
        if (connected) {
          formsProvider.currentConnectionState = true;
          return const OnlineScreen();
        } else {
          formsProvider.currentConnectionState = false;
          return const OfflineScreen();
        }
      },
      child: const SizedBox(),
    );
  }
}
