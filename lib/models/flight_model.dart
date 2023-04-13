import 'package:uuid/uuid.dart';

class FlightModel {
  String uuid;
  String status;
  String flightDate;
  String flightIata;
  String departureAirport;
  String departureIata;
  String departureGate;
  String departureTerminal;
  String arrivalAirport;
  String arrivalIata;
  String arrivalGate;
  String arrivalTerminal;
  DateTime? departureTime;
  DateTime? arrivalTime;

  FlightModel({
    required this.uuid,
    required this.status,
    required this.flightDate,
    required this.flightIata,
    required this.departureAirport,
    required this.departureIata,
    required this.departureGate,
    required this.departureTerminal,
    required this.arrivalAirport,
    required this.arrivalIata,
    required this.arrivalGate,
    required this.arrivalTerminal,
    required this.departureTime,
    required this.arrivalTime,
  });

  factory FlightModel.fromMap(Map<String, dynamic> data) {
    return FlightModel(
      uuid: data['uuid'] as String? ?? Uuid().v4(),
      status: data['flight_status'] as String? ?? '',
      flightDate: data['flight_date'] as String? ?? '',
      flightIata: data['flight']?['iata'] as String? ?? '',
      departureAirport: data['departure']?['airport'] as String? ?? '',
      departureIata: data['departure']?['iata'] as String? ?? '',
      departureGate: data['departure']?['gate'] as String? ?? '',
      departureTerminal: data['departure']?['terminal'] as String? ?? '',
      arrivalAirport: data['arrival']?['airport'] as String? ?? '',
      arrivalIata: data['arrival']?['iata'] as String? ?? '',
      arrivalGate: data['arrival']?['gate'] as String? ?? '',
      arrivalTerminal: data['arrival']?['terminal'] as String? ?? '',
      departureTime:
          data['departure']?['actual'] != null ? DateTime.parse(data['departure']['actual'] as String) : null,
      arrivalTime: data['arrival']?['actual'] != null ? DateTime.parse(data['arrival']['actual'] as String) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'flight_status': status,
      'flight_date': flightDate,
      'flight_iata': flightIata,
      'departure_airport': departureAirport,
      'departure_iata': departureIata,
      'departure_gate': departureGate,
      'departure_terminal': departureTerminal,
      'arrival_airport': arrivalAirport,
      'arrival_iata': arrivalIata,
      'arrival_gate': arrivalGate,
      'arrival_terminal': arrivalTerminal,
      'departure_time': departureTime?.toIso8601String(),
      'arrival_time': arrivalTime?.toIso8601String(),
    };
  }
}
