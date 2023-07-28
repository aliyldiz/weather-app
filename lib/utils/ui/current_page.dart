import 'package:flutter/material.dart';
import 'package:flutter_open_weather/utils/ui/globals.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../api/weather_api.dart';
import '../../location/location_service.dart';
import '../../model/weather_model.dart';
import 'dart:core';

class CurrentPage extends StatefulWidget {
  const CurrentPage({super.key});

  @override
  State<CurrentPage> createState() => _CurrentPageState();
}

class _CurrentPageState extends State<CurrentPage> {
  final WeatherApi weatherApi = WeatherApi();
  WeatherModel? weatherData;
  List<WeatherModel>? forecastData;
  late final LocSvc locSvc;

  // ignore: prefer_typing_uninitialized_variables
  var city;

  @override
  void initState() {
    locSvc = LocSvc(context);
    getWeatherData();
    super.initState();
  }

  getWeatherData({String? q}) async {
    Position cPosition = await locSvc.getCurrentPosition();
    (WeatherModel, List<WeatherModel>) tempData;
    if (q == null) {
      tempData = await weatherApi.getWeatherData(pos: cPosition);
    } else {
      tempData = await weatherApi.getWeatherData(q: q);
    }
    weatherData = tempData.$1;
    forecastData = tempData.$2;
    city = await weatherApi.getLocation(cPosition);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          weatherData?.name.toString() ?? '',
          style: const TextStyle(shadows: <Shadow>[
            Shadow(
              blurRadius: 3.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ], fontSize: 30),
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            children: List.generate(
                1,
                (index) => weatherData != null
                    ? Expanded(
                        flex: 20,
                        child: _currentWeatherCard(weatherData!, true))
                    : const SizedBox()),
          ),
        ),
        Card(
          color: Colors.lightBlue[500],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: List.generate(
                  5,
                  (index) => forecastData != null
                      ? Expanded(
                          flex: 20,
                          child: _weatherCard(forecastData![index], false))
                      : const SizedBox()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _weatherCard(WeatherModel wData, bool isToday) {
    initializeDateFormatting('tr_TR', null);
    Intl.defaultLocale = 'tr_TR';
    DateFormat dateFormat = isToday ? DateFormat('EEEE') : DateFormat('E');
    final dateText = dateFormat
        .format(DateTime.fromMillisecondsSinceEpoch(wData.dt?.toInt() * 1000))
        .toString();
    var mainTemp = wData.main?.temp.runtimeType != double
        ? double.parse(wData.main!.temp.toString())
        : wData.main?.temp;
    var tmpTemp = ((mainTemp) * 2).round() / 2;
    final tempText = '$tmpTemp °C';
    List<String>? tmpDesc =
        wData.weather?.first.description.toString().split(' ');
    for (int i = 0; i < tmpDesc!.length; i++) {
      tmpDesc[i] = StringExtension(tmpDesc[i]).toCap;
    }
    final descText = tmpDesc.join(' ');

    return Column(
      children: [
        Text(
          dateText,
          style: TextStyle(shadows: const <Shadow>[
            Shadow(
              blurRadius: 3.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ], color: Colors.white, fontSize: isToday ? 45 : 20),
        ),
        const SizedBox(height: 8.0),
        Text(
          tempText,
          style: TextStyle(shadows: const <Shadow>[
            Shadow(
              blurRadius: 3.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ], color: Colors.white, fontSize: isToday ? 35 : 14),
          textAlign: TextAlign.center,
        ),
        iconL(wData),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SizedBox(
            height: 50,
            child: Text(
              descText,
              style: TextStyle(shadows: const <Shadow>[
                Shadow(
                  blurRadius: 3.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ], fontSize: isToday ? 25 : 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _currentWeatherCard(WeatherModel wData, bool isToday) {
    initializeDateFormatting('tr_TR', null);
    Intl.defaultLocale = 'tr_TR';
    DateFormat dateFormat = isToday ? DateFormat('EEEE') : DateFormat('E');
    final dateText = dateFormat
        .format(DateTime.fromMillisecondsSinceEpoch(wData.dt?.toInt() * 1000))
        .toString();
    var mainTemp = wData.main?.temp.runtimeType != double
        ? double.parse(wData.main!.temp.toString())
        : wData.main?.temp;
    var tmpTemp = ((mainTemp) * 2).round() / 2;
    final tempText = '$tmpTemp °C';
    List<String>? tmpDesc =
        wData.weather?.first.description.toString().split(' ');
    for (int i = 0; i < tmpDesc!.length; i++) {
      tmpDesc[i] = StringExtension(tmpDesc[i]).toCap;
    }
    final descText = tmpDesc.join(' ');

    return Column(
      children: [
        Text(
          dateText,
          style: TextStyle(shadows: const <Shadow>[
            Shadow(
              blurRadius: 3.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ], color: Colors.white, fontSize: isToday ? 45 : 20),
        ),
        const SizedBox(height: 8.0),
        Text(
          tempText,
          style: TextStyle(shadows: const <Shadow>[
            Shadow(
              blurRadius: 3.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ], color: Colors.white, fontSize: isToday ? 35 : 14),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 250, width: 250, child: iconL(wData)),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SizedBox(
            height: 50,
            child: Text(
              descText,
              style: TextStyle(shadows: const <Shadow>[
                Shadow(
                  blurRadius: 3.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ], fontSize: isToday ? 25 : 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget iconL(WeatherModel wData) {
    Map<String, String> descL = {
      'açık': clearSkyL,
      'parçalı az bulutlu': fewbrokenCloudsL,
      'few clouds': fewbrokenCloudsL,
      'scattered clouds': scatteredCloudsL,
      'shower rain': showerRainL,
      'rain': rainL,
      'thunderstorm': thunderstormL,
      'snow': snowL,
      'mist': mistL
    };

    return Lottie.network(descL[weatherData?.weather?.first.description]!);
  }
}

extension StringExtension on String {
  String get toCap =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}
