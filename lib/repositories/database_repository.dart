import 'package:flightracker2/models/flight_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabaseRepository {
  final Database database;
  DatabaseRepository({required this.database});

  static Future<DatabaseRepository> newConnection() async {
    final databasesPath = await getDatabasesPath();
    final databasePath = path.join(databasesPath, 'flights.db');

    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (Database db, int version) async {
        db.execute("""
        CREATE TABLE flights (
          uuid TEXT PRIMARY KEY,
          flight_status REAL,
          flight_date REAL,
          flight_iata REAL,
          departure_airport REAL,
          departure_iata REAL,
          departure_gate REAL,
          departure_Terminal REAL,
          arrival_airport REAL,
          arrival_iata REAL,
          arrival_gate REAL,
          arrival_terminal REAL,
          departure_time REAL,
          arrival_time REAL
        );
        """);
      },
    );

    return DatabaseRepository(database: database);
  }

  Future<void> insertOrUpdateFlight(FlightModel flight) async {
    await database.insert(
      "flights",
      flight.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FlightModel>> allFlights() async {
    final flightList = await database.query("flights");
    print('All Flights from Database: $flightList');
    return flightList.map((flight) => FlightModel.fromMap(flight)).toList();
  }

  Future<void> updateFlight(FlightModel flight) async {
    await database.update(
      "flights",
      flight.toMap(),
      where: "uuid = ?",
      whereArgs: [flight.uuid],
    );
  }

  void deleteFlight(FlightModel flightModel) async {
    await database.delete(
      "flights",
      where: "uuid = ?",
      whereArgs: [flightModel.uuid],
    );
  }
}
