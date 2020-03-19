import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

const BASE_URL = 'http://10.0.2.2:8000/api';

Future<Map<String, dynamic>> fetchOverview() async {
  final response = await http.get(BASE_URL);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return json.decode(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}

Future<Map<String, dynamic>> fetchPatientObservation(String patientid) async {
  final response = await http.get(BASE_URL + "/observations/" + patientid);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return json.decode(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}

Future<List<Map<dynamic, dynamic>>> fetchPatientList() async {
  final response = await http.get(BASE_URL + "/names");
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List result = json.decode(response.body);

    return result.map((item) => Map.from(item)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}
//
//void main() async {
//  var result = await fetchOverview();
//  Map<String, dynamic> race = result["race"];
//  result.forEach((k,v) => print('$k $v\n'));
//  print(race);
//}