import 'package:flightracker2/components/flight_controller.dart';
import 'package:flightracker2/models/flight_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FlightDetailsCard extends StatelessWidget {
  final FlightController flightController = Get.find<FlightController>();
  final FlightModel flight;

  FlightDetailsCard({required this.flight});

  @override
  Widget build(BuildContext context) {
    DateTime? parsedDepartureTime = flight.departureTime;
    DateTime? parsedArrivalTime = flight.arrivalTime;

    final timeFormat = DateFormat.Hm('it_IT');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          color: Theme.of(context).colorScheme.onSecondary,
          child: SizedBox(
            width: double.infinity,
            height: 80,
            child: Center(
              child: Text(
                flight.flightIata,
                style: TextStyle(fontSize: 30, fontFamily: 'RobotoMono', color: Colors.white),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Theme.of(context).colorScheme.onSecondary,
              child: SizedBox(
                height: 100,
                width: (MediaQuery.of(context).size.width - 60) / 2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Partenza",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        timeFormat.format(parsedDepartureTime ?? DateTime.utc(0, 0, 0, 0)),
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'RobotoMono',
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Card(
              color: Theme.of(context).colorScheme.onSecondary,
              child: SizedBox(
                height: 100,
                width: (MediaQuery.of(context).size.width - 60) / 2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Gate/Terminal",
                        style: TextStyle(fontSize: 16, fontFamily: 'RobotoMono', color: Colors.white),
                      ),
                      Text(
                        "${flight.departureGate} - ${flight.departureTerminal}",
                        style: TextStyle(fontSize: 30, fontFamily: 'RobotoMono', color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Theme.of(context).colorScheme.onSecondary,
              child: SizedBox(
                height: 100,
                width: (MediaQuery.of(context).size.width - 60) / 2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Arrivo",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        timeFormat.format(parsedArrivalTime ?? DateTime.utc(0, 0, 0, 0)),
                        style: TextStyle(fontSize: 30, fontFamily: 'RobotoMono', color: Colors.white),
                        textAlign: TextAlign.start,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Card(
              color: Theme.of(context).colorScheme.onSecondary,
              child: SizedBox(
                height: 100,
                width: (MediaQuery.of(context).size.width - 60) / 2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Gate/Terminal",
                        style: TextStyle(fontSize: 16, fontFamily: 'RobotoMono', color: Colors.white),
                      ),
                      Text(
                        "${flight.arrivalGate} - ${flight.arrivalTerminal}",
                        style: TextStyle(fontSize: 30, fontFamily: 'RobotoMono', color: Colors.white),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
