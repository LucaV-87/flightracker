import 'dart:convert';
import 'package:flightracker2/models/flight_model.dart';
import 'package:http/http.dart' as http;

class FlightApi {
  static const String accessKey = '4ba803e717bbe67c27af945129e5a58d';
  static const String url = 'http://api.aviationstack.com/v1/flights';

  Future<List<FlightModel>> fetchFlights(String flightIata) async {
    try {
      final response = await http.get(
        Uri.parse('$url?access_key=$accessKey&flight_iata=$flightIata'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("API response: $jsonResponse");
        final flightsList = jsonResponse['data'] as List;

        return flightsList.map((flight) => FlightModel.fromMap(flight as Map<String, dynamic>)).toList();
      } else {
        print('HTTP status code: ${response.statusCode}');
        throw Exception('Failed to load flights');
      }
    } catch (error) {
      print('Error fetching flights: $error');
      throw Exception('Failed to load flights');
    }
  }
}
