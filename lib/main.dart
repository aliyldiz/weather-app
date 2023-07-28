import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_open_weather/utils/ui/my_home_page.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}


/*        Text(
          weatherData?.name.toString() ?? '',
          style: const TextStyle(shadows: <Shadow>[
            Shadow(
              blurRadius: 3.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ], fontSize: 30),
          maxLines: 1,
          textAlign: TextAlign.center,
        ),*/
//const SizedBox(height: 10),
/*        Padding(
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
        ),*/