import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  static Future<String> getCityName() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          return 'Permission denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        return 'Enable location in settings';
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      final response = await http.get(Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&accept-language=en'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['address'];
        return data['city'] ?? data['town'] ?? data['village'] ?? data['state'] ?? 'Unknown';
      }

      return 'Location service error';
    } on LocationServiceDisabledException {
      return 'Enable location services';
    } on TimeoutException {
      return 'Location timeout';
    } catch (e) {
      if (kDebugMode) {
        print('Location error: $e');
      }
      return 'Could not get location';
    }
  }
}
