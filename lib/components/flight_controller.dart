import 'package:flightracker2/models/flight_model.dart';
import 'package:flightracker2/repositories/database_repository.dart';
import 'package:flightracker2/repositories/flight_repository.dart';
import 'package:get/get.dart';

class FlightController extends GetxController {
  RxList<FlightModel> flights = <FlightModel>[].obs;
  final DatabaseRepository _databaseRepository;
  FlightModel? currentFlight;

  FlightController() : _databaseRepository = Get.find<DatabaseRepository>();

  @override
  void onInit() {
    super.onInit();
    loadFlights();
    update();
  }

  Future<void> searchFlight(String flightIata) async {
    try {
      List<FlightModel> fetchedFlights = await FlightApi().fetchFlights(flightIata);
      flights.addAll(fetchedFlights);
      saveFlights();
      currentFlight = fetchedFlights.isNotEmpty ? fetchedFlights.last : null;
    } catch (e) {
      print(e);
    }
  }

  void saveFlights() async {
    for (FlightModel flight in flights) {
      _databaseRepository.insertOrUpdateFlight(flight);
      update();
    }
  }

  Future<void> loadFlights() async {
    print("Inizio caricamento voli...");
    List<FlightModel> flightsFromDB = await _databaseRepository.allFlights(); // Modifica questa riga
    flights.value = flightsFromDB;
    flights.forEach((flight) => print("Volo caricato: ${flight.toString()}"));
    print("Caricamento voli completato.");
    print("Voli caricati: ${flightsFromDB.length}");
    print('All Flights Loaded in Controller: ${flights.value}');
    update();
  }

  void removeFlight(FlightModel flight) {
    flights.remove(flight);
    update();
  }
}
