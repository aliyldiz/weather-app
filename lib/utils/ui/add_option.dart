import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_open_weather/location/location_service.dart';
import 'package:flutter_open_weather/model/weather_model.dart';
import 'package:flutter_open_weather/api/weather_api.dart';
import 'package:flutter_open_weather/utils/ui/MyHomePage.dart';
import 'package:flutter_open_weather/utils/ui/add_option.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../helpers/weather_bg.dart';

class AddOption extends StatefulWidget {
  final WeatherModel? weatherData;
  final List<WeatherModel>? forecastData;
  final List<WeatherModel>? favPlaces;
  const AddOption(this.weatherData, this.forecastData, this.favPlaces, {Key? key}) : super(key: key);

  @override
  AddOptionState createState() => AddOptionState();
}

class AddOptionState extends State<AddOption> {
  WeatherModel? _weatherData;
  List<WeatherModel>? _forecastData;
  List<WeatherModel>? _favPlaces;

  final TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    _weatherData = widget.weatherData;
    _forecastData = widget.forecastData;
    _favPlaces = widget.favPlaces;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
              onPressed: () {
                _favPlaces?.add(_weatherData!);
                Navigator.pop(context, _favPlaces);
              },
              child: const Text('Ekle')
          ),
        ],
      ),
      body: Stack(
        children: [
          _weatherData != null
              ? background(
                  _weatherData?.weather?.first.id,
                  MediaQuery.of(context).size.height,
                  MediaQuery.of(context).size.width,
                )
              : const SizedBox(),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Text(
                  _weatherData?.name.toString() ?? '',
                  //weatherApi.getWeatherData(q: searchCtrl.text).toString(),
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
                        (index) => _weatherData != null
                            ? Expanded(
                                flex: 20,
                                child: _weatherCard(_weatherData!, true))
                            : const SizedBox()),
                  ),
                ),
                Card(
                  color: Colors.lightBlue[500],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: List.generate(
                          5,
                          (index) => _forecastData != null
                              ? Expanded(
                                  flex: 20,
                                  child:
                                      _weatherCard(_forecastData![index], false))
                              : const SizedBox()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _weatherCard(WeatherModel wData, bool isToday) {
    final iconPng =
        'https://openweathermap.org/img/wn/${wData.weather?.first.icon}@2x.png';
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
        Image.network(iconPng),
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
}

extension StringExtension on String {
  String get toCap =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}
