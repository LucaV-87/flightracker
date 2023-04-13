import 'package:flightracker2/components/flight_controller.dart';
import 'package:flightracker2/models/flight_model.dart';
import 'package:flightracker2/pages/flight_details_page.dart';
import 'package:flightracker2/pages/flight_tracker_page.dart';
import 'package:flightracker2/pages/new_flight_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flight Tracker',
      theme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case FlightDetailsPage.route:
            final flightModel = settings.arguments as FlightModel?;
            return MaterialPageRoute(
              builder: (context) => FlightDetailsPage(flightModel),
            );
          case NewFlightPage.route:
            return MaterialPageRoute(
              builder: (context) => NewFlightPage(),
            );
          default:
            return MaterialPageRoute(
              builder: (context) => FlightTrackerPage(),
            );
        }
      },
      initialBinding: BindingsBuilder(
        () {
          Get.put<FlightController>(FlightController());
        },
      ),
    );
  }
}
