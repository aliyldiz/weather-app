import 'package:flutter/material.dart';
import '../../api/weather_api.dart';
import '../../model/weather_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'dart:core';
import 'package:flutter_open_weather/utils/ui/globals.dart' as globals;
import 'package:flutter_open_weather/utils/ui/globals.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class AddOption extends StatefulWidget {
  String qSelect;

  AddOption({Key? key, required this.qSelect}) : super(key: key);

  @override
  State<AddOption> createState() => _AddOptionState();
}

class _AddOptionState extends State<AddOption> {
  final WeatherApi weatherApi = WeatherApi();
  WeatherModel? weatherData;
  List<WeatherModel>? forecastData;

  @override
  void initState() {
    getWeatherData();
    super.initState();
  }

  getWeatherData({String? q}) async {
    (WeatherModel, List<WeatherModel>) tempData;
    tempData = await weatherApi.getWeatherData(q: widget.qSelect);
    weatherData = tempData.$1;
    forecastData = tempData.$2;
    setState(() {});
  }

  void addItemToList() {
    setState(() {
      globals.favPlaces?.insert(0, weatherData!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 55, left: 320)),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.keyboard_arrow_left)),
              const Padding(padding: EdgeInsets.only(left: 275)),
              TextButton(
                  onPressed: () {
                    //debugPrint(widget.qSelect);
                    addItemToList();
                    Navigator.pop(context);
                  },
                  child: const Text('Ekle'))
            ],
          ),
          Column(
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
                              flex: 20, child: _currentWeatherCard(weatherData!, true))
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
                        (index) => forecastData != null
                            ? Expanded(
                                flex: 20,
                                child:
                                    _weatherCard(forecastData![index], false))
                            : const SizedBox()),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _weatherCard(WeatherModel wData, bool isToday) {
    initializeDateFormatting('tr_TR', null);
    Intl.defaultLocale = 'tr_TR';
    DateFormat dateFormat = isToday ? DateFormat('EEEE') : DateFormat('E');
    final dateText = dateFormat
        .format(DateTime.fromMillisecondsSinceEpoch((wData.dt?.toInt() + 86400) * 1000))
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
        SizedBox(height:150, width: 150,child: iconL(wData)),
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

    var tempData = wData.weather?.first.id == 800 ? 0 : wData.weather?.first.id % 100;

    List<String> descL = [
      clearSkyL, fewbrokenCloudsL, fewbrokenCloudsL, fewbrokenCloudsL,
      scatteredCloudsL, showerRainL, rainL, thunderstormL, snowL, mistL
    ];

    return Lottie.network(descL[tempData]);

  }
}

extension StringExtension on String {
  String get toCap =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}


