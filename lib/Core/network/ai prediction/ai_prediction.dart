import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AiPrediction {
  static Future<String> getPrediction(List<int> features) async {
    print(features);
    const url = 'http://192.168.1.5:5001/predict';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'features': features}),
      );

      if (response.statusCode == 200) {
        final prediction = json.decode(response.body)['prediction'];
        print("AI Prediction: $prediction");
        return prediction[0] == 1
            ? "Great Weather Today ☀️\nPerfect for outdoor activities!"
            : "Bad Weather Today 🌧️\nStay indoors!";
      } else {
        return "";
      }
    } catch (e) {
      if (kDebugMode) print("AI Prediction Error: $e");
      return "";
    }
  }
}
