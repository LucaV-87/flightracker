import 'package:flightracker2/pages/flight_details_page.dart';
import 'package:flightracker2/pages/new_flight_page.dart';
import 'package:flutter/material.dart';
import 'package:flightracker2/components/flight_controller.dart';
import 'package:flightracker2/models/flight_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FlightTrackerPage extends StatefulWidget {
  static const route = "/";

  @override
  State<FlightTrackerPage> createState() => _FlightTrackerPageState();
}

class _FlightTrackerPageState extends State<FlightTrackerPage> {
  FlightController flightController = Get.find<FlightController>();

  List<FlightModel> flightsToday = [];

  List<FlightModel> flightsNext = [];

  List<FlightModel> flightsPast = [];

  List<FlightModel> flightsMissingDates = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: flightController.loadFlights(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Errore nel caricamento dei voli.'));
            } else {
              return Obx(
                () {
                  flightsToday.clear();
                  flightsNext.clear();
                  flightsPast.clear();
                  flightsMissingDates.clear();

                  DateTime now = DateTime.now();

                  for (FlightModel flight in flightController.flights) {
                    DateTime? flightDate = flight.departureTime;

                    if (flightDate == null) {
                      flightsMissingDates.add(flight);
                    } else {
                      if (flightDate.day == now.day && flightDate.month == now.month && flightDate.year == now.year) {
                        flightsToday.add(flight);
                      } else if (flightDate.isBefore(now)) {
                        flightsPast.add(flight);
                      } else {
                        flightsNext.add(flight);
                      }
                    }
                  }
                  print("Voli nella lista: ${flightController.flights.length}");
                  for (FlightModel flight in flightController.flights) {
                    print("Volo: ${flight.departureAirport} - ${flight.arrivalAirport}");
                    print("Data di partenza: ${flight.departureTime}");
                  }

                  List<Widget> allChildren = [];

                  allChildren.addAll(buildCategory(context, 'Oggi', flightsToday, flightController));
                  allChildren.addAll(buildCategory(context, 'Prossimi', flightsNext, flightController));
                  allChildren.addAll(buildCategory(context, 'Passati', flightsPast, flightController));

                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        backgroundColor: Theme.of(context).colorScheme.background,
                        expandedHeight: 150,
                        pinned: true,
                        floating: true,
                        snap: true,
                        surfaceTintColor: Theme.of(context).colorScheme.background,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Container(
                            color: Theme.of(context).colorScheme.background,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Fligh",
                                    style: TextStyle(
                                        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
                                  ),
                                  Text(
                                    "tracker",
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          allChildren,
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, NewFlightPage.route);
        },
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        label: Row(
          children: [
            Icon(
              FontAwesomeIcons.planeDeparture,
              color: Colors.grey.shade200,
            ),
            SizedBox(width: 16),
            Text(
              "Nuovo Volo",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildCategory(
      BuildContext context, String title, List<FlightModel> flights, FlightController controller) {
    bool isValidFlight(FlightModel flight) {
      return flight.flightIata != null &&
          flight.departureAirport != null &&
          flight.arrivalAirport != null &&
          flight.departureTime != null &&
          flight.arrivalTime != null;
    }

    List<FlightModel> validFlights = flights.where((flight) => isValidFlight(flight)).toList();

    List<Widget> children = [];

    children.add(
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );

    for (FlightModel flight in validFlights) {
      children.add(buildFlightCard(context, flight, title, controller));
    }

    children.add(SizedBox(height: 100));

    return children;
  }

  Widget buildFlightCard(BuildContext context, FlightModel flight, String category, FlightController controller) {
    final timeFormat = DateFormat.Hm();
    final dateFormat = DateFormat('dd/MM/yyyy', 'it_IT');

    DateTime? parsedDepartureTime = flight.departureTime;
    DateTime? parsedArrivalTime = flight.arrivalTime;

    Color cardColor = Colors.transparent;
    double textOpacity = 1.0;

    switch (category) {
      case 'Oggi':
        cardColor = Theme.of(context).colorScheme.primary;
        break;
      case 'Prossimamente':
        cardColor = Theme.of(context).colorScheme.inversePrimary;
        break;
      case 'Passate':
        cardColor = Theme.of(context).colorScheme.onInverseSurface;
        textOpacity = 0.5;
        break;
    }

    return Column(
      children: [
        Slidable(
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  controller.removeFlight(flight);
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete_outline,
                spacing: 3,
                label: 'Elimina',
              ),
            ],
          ),
          child: Card(
            color: cardColor,
            elevation: 5,
            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: ListTile(
              title: Text('${flight.departureAirport} - ${flight.arrivalAirport}',
                  style: TextStyle(fontSize: 18, color: Colors.black12.withOpacity(textOpacity))),
              subtitle: category == 'Passate'
                  ? Text(dateFormat.format(parsedDepartureTime!),
                      style: TextStyle(fontSize: 18, color: Colors.black12.withOpacity(textOpacity)))
                  : Text(
                      '${parsedDepartureTime != null ? timeFormat.format(parsedDepartureTime) : "N/A"} - ${parsedArrivalTime != null ? timeFormat.format(parsedArrivalTime) : "N/A"}',
                      style: TextStyle(fontSize: 16),
                    ),
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.black45),
                onPressed: () {
                  Get.toNamed('/flight_details_page', arguments: flight);
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
