import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_open_weather/location/location_service.dart';
import 'package:flutter_open_weather/model/weather_model.dart';
import 'package:flutter_open_weather/api/weather_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'helpers/weather_bg.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final WeatherApi _weatherApi = WeatherApi();
  WeatherModel? weatherData;
  List<WeatherModel>? forecastData;
  Future? fetchData;
  late final LocSvc _locSvc;
  // ignore: prefer_typing_uninitialized_variables
  var city;
  final TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    _locSvc = LocSvc(context);
    getWeatherData();
    super.initState();
  }

  void getWeatherData({String? q}) async{
    Position cPosition = await _locSvc.getCurrentPosition();
    (WeatherModel, List<WeatherModel>) tempData;
    if(q == null) {
      tempData = await _weatherApi.getWeatherData(pos: cPosition);
    } else {
      tempData = await _weatherApi.getWeatherData(q: q);
    }
    weatherData = tempData.$1;
    forecastData = tempData.$2;
    city = await _weatherApi.getLocation(cPosition);
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hava Durumu'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {

            },)
        ],
      ),
      drawer: Drawer(
          child: ListView(
            children: [
              const Padding(padding: EdgeInsets.only(top: 10)),
              SearchBar(
                hintText: 'Şehir arayın',
                controller: searchCtrl,
                leading: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      getWeatherData(q: searchCtrl.text);
                    }),
              ),
              const Padding(padding: EdgeInsets.only(top: 8)),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 100,
                        padding: const EdgeInsets.all(1.0),
                        decoration: BoxDecoration(
                            border: Border.all(width: 2.0, color: Colors.blue),
                            borderRadius: const BorderRadius.all(Radius.circular(3.0))
                        ),
                        child: Stack(
                            children: [
                              weatherData != null ? background(weatherData?.weather?.first.id, MediaQuery.of(context).size.height, MediaQuery.of(context).size.width) : const SizedBox(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(city ?? ''),
                              ),
                            ]
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
      ),
      body: Stack(
        children: [
          weatherData != null ? background(
            weatherData?.weather?.first.id,
            MediaQuery.of(context).size.height,
            MediaQuery.of(context).size.width,
          ) : const SizedBox(),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Text(
                  weatherData?.name.toString() ?? '',
                  style: const TextStyle(
                      shadows: <Shadow>[
                        Shadow(
                          blurRadius: 3.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ],
                      fontSize: 30),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: List.generate(1, (index) => weatherData != null
                        ? Expanded(flex: 20, child: _weatherCard(weatherData!, true))
                        : const SizedBox()),
                  ),
                ),
                Card(
                  color: Colors.lightBlue[500],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: List.generate(5, (index) => forecastData != null
                          ? Expanded(flex: 20, child: _weatherCard(forecastData![index], false))
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
    final iconPng ='https://openweathermap.org/img/wn/${wData.weather?.first.icon}@2x.png';
    initializeDateFormatting('tr_TR', null);
    Intl.defaultLocale = 'tr_TR';
    DateFormat dateFormat = isToday ? DateFormat('EEEE') : DateFormat('E');
    final dateText = dateFormat.format(DateTime.fromMillisecondsSinceEpoch(wData.dt?.toInt() * 1000)).toString();
    var mainTemp = wData.main?.temp.runtimeType != double ? double.parse(wData.main!.temp.toString()) : wData.main?.temp;
    var tmpTemp = ((mainTemp) * 2).round() / 2;
    final tempText = '$tmpTemp °C';
    List<String>? tmpDesc = wData.weather?.first.description.toString().split(' ');
    for (int i = 0;i < tmpDesc!.length; i++) {
      tmpDesc[i] = tmpDesc[i].toCap;
    }
    final descText = tmpDesc.join(' ');

    return Column(
      children: [
        Text(
          dateText,
          style: TextStyle(
              shadows: const <Shadow>[
                Shadow(
                  blurRadius: 3.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ],
              color: Colors.white,fontSize: isToday ? 45 : 20),
        ),
        const SizedBox(height: 8.0),
        Text(
          tempText,
          style: TextStyle(
              shadows: const <Shadow>[
                Shadow(
                  blurRadius: 3.0,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ],
              color: Colors.white, fontSize: isToday ? 35 : 14),
          textAlign: TextAlign.center,
        ),
        Image.network(iconPng),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SizedBox(
            height: 50,
            child: Text(
              descText,
              style: TextStyle(
                  shadows: const <Shadow>[
                    Shadow(
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                  fontSize:  isToday ? 25 : 14),
            ),
          ),
        ),
      ],
    );
  }
}

extension StringExtension on String {
  String get toCap => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}