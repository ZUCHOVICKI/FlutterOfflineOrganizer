import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_offline/models/test_model.dart';
import 'package:test_offline/provider/providers.dart';

class AllItemsScreen extends StatelessWidget {
  const AllItemsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DataBaseProvider dataBaseProvider = Provider.of<DataBaseProvider>(context);
    FormsProvider formsProvider = Provider.of<FormsProvider>(context);
    final colorsStatus =
        formsProvider.currentConnectionState ? Colors.green : Colors.red;
    formsProvider.reDraw;
    final tests = dataBaseProvider.test;
    if (tests.isNotEmpty) {
      return Scaffold(
          appBar: _localAppBar(formsProvider.currentConnectionState),
          body: ListView.builder(
            itemBuilder: (context, index) => Dismissible(
              background: Container(
                color: Colors.red,
                child: Stack(
                  children: const [
                    Positioned(
                      top: 0,
                      left: 50,
                      child: Icon(
                        Icons.delete_forever,
                        size: 60,
                      ),
                    ),
                  ],
                ),
              ),
              key: UniqueKey(),
              onDismissed: (direction) {
                dataBaseProvider.deleteTestDB(tests[index].id!);
                // print(tests[index].id);
              },
              confirmDismiss: (direction) async {
                return await dialogConfirm(context);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ListTile(
                  leading: const Icon(Icons.save),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () => Navigator.pushNamed(context, 'oneItem',
                      arguments: tests[index]),
                  title: Text(tests[index].title),
                  subtitle: Text(tests[index].description),
                ),
              ),
            ),
            itemCount: tests.length,
          ),
          floatingActionButton: formsProvider.currentConnectionState
              ? FloatingActionButton(
                  backgroundColor: Colors.green,
                  onPressed: () {
                    if (!formsProvider.offlineActionSubmitted()) {
                      onlineFunction(tests, dataBaseProvider);
                    }
                  },
                  child: const Icon(Icons.send),
                )
              : FloatingActionButton(
                  backgroundColor: colorsStatus,
                  onPressed: () {
                    if (!formsProvider.onlineActionSubmitted()) {
                      offlineFunction(context);
                    }
                  },
                  child: const Icon(Icons.send),
                ));
    } else {
      return Scaffold(
          appBar: _localAppBar(formsProvider.currentConnectionState),
          body: const Center(
            child: Text("No Items"),
          ));
    }
  }

  void offlineFunction(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cant Upload While Offline")));
  }

  void onlineFunction(
      List<TestModel> tests, DataBaseProvider dataBaseProvider) {
    for (TestModel element in tests) {
      //TODO BACKUP HTTP CALLS
      print("Envio a Servidor Http ${element.id}");
      dataBaseProvider.deleteTestDB(element.id!);
      dataBaseProvider.getAllTestDB();
    }
  }

  AppBar _localAppBar(bool status) {
    return AppBar(
      title: const Text("All Items"),
      backgroundColor: status ? Colors.green : Colors.red,
    );
  }

  Future<bool?> dialogConfirm(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm"),
          content: const Text("Are you sure you wish to delete this item?"),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("DELETE")),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("CANCEL"),
            ),
          ],
        );
      },
    );
  }
}
