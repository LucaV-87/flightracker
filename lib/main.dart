import 'package:flightracker2/app.dart';
import 'package:flightracker2/repositories/database_repository.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';

void main() async {
  // final flights = await FlightApi().all();
  // print(flights);
  WidgetsFlutterBinding.ensureInitialized();

  final database = await DatabaseRepository.newConnection();
  Get.put(database);

  await initializeDateFormatting('it_IT', null);

  runApp(App());
}
