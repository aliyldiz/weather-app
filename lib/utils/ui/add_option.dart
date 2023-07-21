import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_open_weather/location/location_service.dart';
import 'package:flutter_open_weather/model/search_model.dart';
import 'package:flutter_open_weather/model/weather_model.dart';
import 'package:flutter_open_weather/api/weather_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';

import 'my_home_page.dart';

class AddOption extends StatefulWidget {
  final String? name;
  final WeatherModel? weatherData;
  final List<WeatherModel>? forecastData;
  final List<WeatherModel>? favPlaces;

  const AddOption(this.weatherData, this.forecastData, this.favPlaces,
      {Key? key, this.name})
      : super(key: key);

  @override
  AddOptionState createState() => AddOptionState();
}

class AddOptionState extends State<AddOption> {
  bool isSearching = false;
  final WeatherApi weatherApi = WeatherApi();
  WeatherModel? _weatherData;
  List<WeatherModel>? _forecastData;
  List<WeatherModel>? _favPlaces = [];
  late final LocSvc _locSvc;


  // ignore: prefer_typing_uninitialized_variables
  var city;
  final TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    _weatherData = widget.weatherData;
    _favPlaces = widget.favPlaces;
    _locSvc = LocSvc(context);
    getWeatherData();
    super.initState();
  }

  getWeatherData({String? q}) async {
    Position cPosition = await _locSvc.getCurrentPosition();
    (WeatherModel, List<WeatherModel>) tempData;
    if (q == null) {
      tempData = await weatherApi.getWeatherData(pos: cPosition);
    } else {
      tempData = await weatherApi.getWeatherData(q: q);
    }
    _weatherData = tempData.$1;
    _forecastData = tempData.$2;
    city = await weatherApi.getLocation(cPosition);
    setState(() {});
  }

  getCitySearch(String? q) async {
    var response = (await http.get(Uri.parse(
        'https://api.geoapify.com/v1/geocode/autocomplete?text=$q&type=city&format=json&apiKey=552e057cf7694553818c4b2cf3ccd1f7')));
    return SearchModel.fromJson(jsonDecode(response.body));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isSearching) {
          setState(() {
            searchCtrl.text = '';
          });
        } else {
          return true;
        }
        return false;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 55, left: 320)),
              TextButton(
                  onPressed: () {
                    _favPlaces?.add(_weatherData!);
                    Navigator.pop(context, _favPlaces);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyHomePage(),
                      ),
                    );
                  },
                  child: const Text('Ekle')),
              Text(
                _weatherData?.name.toString() ?? '',
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
          )),
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
