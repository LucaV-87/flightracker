import 'package:auto_size_text/auto_size_text.dart';
import 'package:flightracker2/components/flight_details_card.dart';
import 'package:flightracker2/models/flight_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class FlightDetailsPage extends StatefulWidget {
  static const route = "/flight/details";

  final FlightModel? flight;

  const FlightDetailsPage(this.flight);

  @override
  State<FlightDetailsPage> createState() => _FlightDetailsPageState();
}

class _FlightDetailsPageState extends State<FlightDetailsPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.flight == null) {
      return Scaffold(
        body: Center(
          child: Text("Errore"),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          header(),
          body(),
          SizedBox(height: 16),
          note(),
        ],
      ),
    );
  }

  Widget header() {
    String extractAirportName(String fullAirportName) {
      final startIndex = fullAirportName.indexOf('(');
      final endIndex = fullAirportName.indexOf(')');
      if (startIndex == -1 || endIndex == -1) {
        return fullAirportName; // Se non ci sono parentesi, restituisce il nome completo
      }
      return fullAirportName.substring(startIndex + 1, endIndex);
    }

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/rettangolo-verde.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 60,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            Positioned(
              top: 100,
              left: 32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    widget.flight!.departureAirport,
                    style: TextStyle(fontSize: 35, color: Colors.black87, fontFamily: 'RobotoMono-Bold'),
                    maxLines: 1,
                  ),
                  Text(
                    widget.flight!.departureIata,
                    style: TextStyle(fontSize: 30, color: Colors.black54, fontFamily: 'RobotoMono-Bold'),
                  )
                ],
              ),
            ),
            Center(
              child: Image.asset(
                'assets/images/linea.png',
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Transform.rotate(
                angle: 180 * math.pi / 180,
                child: Icon(
                  FontAwesomeIcons.planeUp,
                  size: 40,
                  color: Colors.black87,
                ),
              ),
            ),
            Positioned(
              bottom: 32,
              right: 32,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AutoSizeText(
                    extractAirportName(widget.flight!.arrivalAirport),
                    style: TextStyle(fontSize: 35, color: Colors.black87, fontFamily: 'RobotoMono-Bold'),
                    maxLines: 1,
                  ),
                  Text(
                    widget.flight!.arrivalIata,
                    style: TextStyle(fontSize: 30, color: Colors.black54, fontFamily: 'RobotoMono-Bold'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget body() => Padding(
        padding: EdgeInsets.only(
          top: 16,
          bottom: 0,
          left: 8,
          right: 8,
        ),
        child: FlightDetailsCard(
          flight: widget.flight!,
        ),
      );

  Widget note() => Container(
        width: double.infinity,
        height: 200,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 16,
                  bottom: 16,
                ),
                child: Text(
                  "Note",
                  style: TextStyle(fontSize: 24, fontFamily: 'RobotoMono-Bold'),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Center(
                  child: TextField(
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'RobotoMono',
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
