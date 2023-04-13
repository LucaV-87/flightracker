import 'package:flightracker2/components/flight_controller.dart';
import 'package:flightracker2/models/flight_model.dart';
import 'package:flightracker2/pages/flight_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NewFlightPage extends StatefulWidget {
  static const route = "/flight/new";

  @override
  State<NewFlightPage> createState() => _NewFlightPageState();
}

class _NewFlightPageState extends State<NewFlightPage> {
  final FlightController flightController = Get.find<FlightController>();

  final TextEditingController flightNumberController = TextEditingController();
  final TextEditingController flightDateController = TextEditingController();

  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Nuo",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
                ),
                Text(
                  "volo",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text("Numero di Volo",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start),
            ),
            SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: Icon(Icons.flight),
                ),
                title: TextField(
                  textCapitalization: TextCapitalization.characters,
                  style: TextStyle(fontSize: 18),
                  controller: flightNumberController,
                  decoration: InputDecoration(
                    hintText: "es. AZA123",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text("Data del Volo",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start),
            ),
            SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: Icon(Icons.date_range),
                title: Text(
                  selectedDate == null ? 'Seleziona la data' : DateFormat('dd/MM/yyyy').format(selectedDate!),
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                onTap: () => selectDate(context),
              ),
            ),
            SizedBox(height: 32),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () async {
                  if (flightNumberController.text.isNotEmpty && selectedDate != null) {
                    try {
                      await flightController.searchFlight(flightNumberController.text);
                      flightController.update();
                      if (flightController.currentFlight?.flightIata != null) {
                        Get.toNamed(FlightDetailsPage.route, arguments: flightController.currentFlight!.flightIata);
                      }
                    } catch (e) {
                      Get.snackbar('Errore', 'Non è stato possibile caricare i dati del volo.');
                    }
                  } else {
                    Get.snackbar('Errore', 'Inserisci il numero di volo e la data del volo.');
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.onPrimary),
                ),
                child: Text('Cerca volo', style: TextStyle(fontSize: 24, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                selectedDate = newDate;
              });
            },
            initialDateTime: selectedDate,
          ),
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        flightDateController.text = _formatDate(selectedDate!);
      });
    }
  }

  String _formatDate(DateTime newDate) {
    return '${newDate.year.toString()}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}';
  }
}
