import 'dart:core';
import 'package:flutter_open_weather/model/weather_model.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart';


class WeatherApi {
  static const baseUrl = 'api.openweathermap.org';
  static const apiWeather = '/data/2.5/weather';
  static const apiForecast = '/data/2.5/forecast';
  static const appId = '7b0b2395e0a953df1afeeb7ae7626527';
  static const baseLocUrl = 'opencage-geocoder.p.rapidapi.com';
  static const locPath = '/geocode/v1/json';

  static const mBaseUrl = 'maps.openweathermap.org';
  static const mapApi = '/maps/2.0/weather/{op}/{2}/{2}/{2}';

  Map<String, dynamic> mapApiPrm = {
    'lat' : '26',
    'lon' : '45'
  };

  Map<String, String> geoHeader = {
    'X-RapidAPI-Key' : '1adc78278dmshd9d49a61e7fc226p1fd8d9jsnd1ba7af1865f',
    'X-RapidAPI-Host': 'opencage-geocoder.p.rapidapi.com'
  };

  Map<String, dynamic> apiLocPrm = {
    'q' : '40.23, 28.93',
    'key' : '5d910a065f79434f812aa62ece997ea1'
  };

  Map<String, dynamic> apiParameter = {
    'appid': appId,
    'units': 'metric',
    'cnt': '40',
    'lang': 'tr',
    'lat' : '26',
    'lon' : '45'
  };

  Future<(WeatherModel, List<WeatherModel>)> getWeatherData(
      {Position? pos, String? q}) async {
    if(pos != null) {
      apiParameter.update('lat', (value) => pos.latitude.toString());
      apiParameter.update('lon', (value) => pos.longitude.toString());
    } else {
      apiParameter.remove('lat');
      apiParameter.remove('lon');
      apiParameter.addAll({'q': q});
    }
    var countryResponse =
    await get(Uri.https(baseUrl, apiWeather, apiParameter));

    var forecastResponse =
    await get(Uri.https(baseUrl, apiForecast, apiParameter));

    List forecastList =
    jsonDecode(forecastResponse.body)['list'];

    List<WeatherModel> tempList = List.generate(forecastList.length, (index) => WeatherModel.fromJson(forecastList[index]));
    tempList.removeWhere((fData) => !fData.dt_txt.toString().contains('12:00:00'));

    return (WeatherModel.fromJson(jsonDecode(countryResponse.body)), tempList);
  }

  Future<String> getLocation(Position pos) async {
    apiLocPrm.update('q', (value) => '${pos.latitude.toString()}, ${pos.longitude.toString()}');
    var geoReq = Request('GET', Uri.https(baseLocUrl, locPath, apiLocPrm));
    geoReq.headers.addAll(geoHeader);
    StreamedResponse geoResponse = await geoReq.send();
    var responseLoc = await geoResponse.stream.bytesToString();
    var locJson = jsonDecode(responseLoc)['results'][0]['components'];
    if(locJson['province'] != null) {
      return locJson['province'];
    } else if(locJson['city'] != null) {
      return locJson['city'];
    } else if(locJson['state'] != null) {
      return locJson['state'];
    } else if(locJson['village'] != null) {
      return locJson['village'];
    } else {
      return locJson['country'];
    }
  }
}