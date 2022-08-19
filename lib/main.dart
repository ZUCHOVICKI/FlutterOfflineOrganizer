import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:test_offline/provider/db_provider.dart';
import 'package:test_offline/provider/forms_provider.dart';
import 'package:test_offline/screens/screens.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FormsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DataBaseProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        initialRoute: 'home',
        routes: {
          'home': (context) => const HomeScreen(),
          'offline': (context) => const OfflineScreen(),
          'online': (context) => const OnlineScreen(),
          'allItems': (context) => const AllItemsScreen(),
          'oneItem': (context) => const OneItemScreen(),
          'fullImage': (context) => const FullImage(),
        },
      ),
    );
  }
}
