import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';

WeatherBg background(int id, double height, double width){
  if(id == 800) {
    return WeatherBg(weatherType: WeatherType.sunny,width: width,height: height,);
  }
  switch (id ~/100) {
    case 2 :
      return WeatherBg(weatherType: WeatherType.thunder,width: width,height: height,);
    case 3 :
      return WeatherBg(weatherType: WeatherType.lightRainy,width: width,height: height,);
    case 5 :
      return WeatherBg(weatherType: WeatherType.heavyRainy,width: width,height: height,);
    case 6 :
      return WeatherBg(weatherType: WeatherType.heavySnow,width: width,height: height,);
    case 7 :
      return WeatherBg(weatherType: WeatherType.foggy,width: width,height: height,);
    case 8 :
      return WeatherBg(weatherType: WeatherType.cloudy,width: width,height: height,);
    default: {
      return WeatherBg(weatherType: WeatherType.sunny,width: width,height: height,);
    }
  }
}