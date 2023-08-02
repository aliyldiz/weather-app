library globals;

import '../../model/weather_model.dart';

List<WeatherModel>? favPlaces = [];
String? favDelCity;

extension StringExtension on String {
  String get toCap =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}