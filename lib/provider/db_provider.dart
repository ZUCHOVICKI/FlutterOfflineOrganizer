import 'package:flutter/material.dart';
import 'package:test_offline/models/test_model.dart';
import 'package:test_offline/services/db_service.dart';

class DataBaseProvider extends ChangeNotifier {
  List<TestModel> test = [];

  nuevoTestDB(
      String title, String description, String image, String date) async {
    final nuevoTest = TestModel(
        title: title, description: description, image: image, date: date);
    final id = await DBProvider.db.newTest(nuevoTest);

    nuevoTest.id = id;

    notifyListeners();
  }

  getAllTestDB() async {
    final allTest = await DBProvider.db.getAllTest();

    test = [...?allTest];

    notifyListeners();
  }

  deleteTestDB(int id) async {
    await DBProvider.db.deleteTest(id);
  }

  updateTestDB(TestModel testmodel) async {
    await DBProvider.db.updateTest(testmodel);
    notifyListeners();
  }
}
