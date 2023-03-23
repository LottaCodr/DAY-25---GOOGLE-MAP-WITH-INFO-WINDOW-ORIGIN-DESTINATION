import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import '.env.dart';
import 'model/directions_model.dart';

class DirectionsRepo {
  static const String _baseUrl =
      'https://maps.googlapis.com/maps/api/directions/json';

  final Dio _dio;

  DirectionsRepo({required Dio dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
  required LatLng origin,
    required LatLng destination,
}) async {
    final response = await _dio.get(
      queryParameters: {
        'origin': '${origin.latitude}, ${origin.longitude}',
        'destination': '${destination.latitude}, ${destination.longitude}',
        'key': googleAPIKey,
      }
    );

    //check if response is successful
    if (response.statusCode == 200){
      return Directions.fromMap(response.data);
    } return null;
  }



}


