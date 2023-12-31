import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_open_weather/location/location_service.dart';
import 'package:flutter_open_weather/model/search_model.dart';
import 'package:flutter_open_weather/model/weather_model.dart';
import 'package:flutter_open_weather/api/weather_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_open_weather/utils/ui/globals.dart' as globals;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:flutter_map/plugin_api.dart' as mapplugin;
import 'package:intl/date_symbol_data_local.dart';
import 'globals.dart';

class MyHomePage extends StatefulWidget {
  final String? name;

  const MyHomePage({Key? key, this.name}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  Icon _searchIcon = const Icon(Icons.search);
  bool isSearching = false;
  final WeatherApi weatherApi = WeatherApi();
  static WeatherModel? weatherData;
  List<WeatherModel>? forecastData;
  late final LocSvc locSvc;
  static Position? cPosition;
  static Position? currentPosition;
  bool isAddOption = false;
  static bool isFavBg = false;
  static String mapSelected = 'temp_new';
  static double? markerLat = cPosition!.latitude;
  static double? markerLon = cPosition!.longitude;
  late Results selectedCity;

  static String displayStringForOption(Results option) =>
      '${option.city}, ${option.country}';

  // ignore: prefer_typing_uninitialized_variables
  var city;
  final TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    locSvc = LocSvc(context);
    getWeatherData();
    super.initState();
  }

  getWeatherData({String? q}) async {
    cPosition = await locSvc.getCurrentPosition();
    currentPosition = cPosition;
    (WeatherModel, List<WeatherModel>) tempData;
    if (q == null) {
      tempData = await weatherApi.getWeatherData(pos: cPosition);
    } else {
      tempData = await weatherApi.getWeatherData(q: q);
    }
    weatherData = tempData.$1;
    forecastData = tempData.$2;
    city = await weatherApi.getLocation(cPosition!);
    markerLat = weatherData?.coord?.lat;
    markerLon = weatherData?.coord?.lon;

    setState(() {
      currentPosition;
    });
  }

  getCitySearch(String? q) async {
    var response = (await http.get(Uri.parse(
        'https://api.geoapify.com/v1/geocode/autocomplete?text=$q&type=city&format=json&apiKey=552e057cf7694553818c4b2cf3ccd1f7')));
    return SearchModel.fromJson(jsonDecode(response.body));
  }

  void _onSearchPressed() {
    setState(() {
      if (searchCtrl.text == "") {
        isSearching = isSearching ? false : true;
        if (isSearching) {
          _searchIcon = const Icon(Icons.close);
        } else {
          _searchIcon = const Icon(Icons.search);
          searchCtrl.clear();
        }
      } else {
        searchCtrl.text = "";
      }
    });
  }

  void addItemToList() {
    setState(() {
      //for or toList;

      bool haveCity = false;
      for (var e in globals.favPlaces!) {
        if (e.name!.toLowerCase() ==
            selectedCity.city.toString().toLowerCase()) {
          haveCity = true;
          break;
        }
      }

      if (!haveCity) {
        globals.favPlaces?.insert(0, weatherData!);
      } else {}
    });
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
      child: weatherData != null
          ? Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0x44000000),
                elevation: 0,
              ),
              drawer: drawer(),
              resizeToAvoidBottomInset: false,
              body: Stack(children: [
                Image(
                  image: background(),
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      isAddOption ? addOption() : searchButton(),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                        child: currentPage(),
                      ),
                      detail(),
                      map(),
                    ],
                  ),
                ),
              ]))
          : const Padding(
              padding: EdgeInsets.only(top: 188.0),
              child: Column(
                children: [
                  SizedBox(
                      height: 90,
                      width: 90,
                      child: Image(
                          image:
                              AssetImage('assets/images/detail/welcome.png'))),
                  Padding(
                    padding: EdgeInsets.only(top: 100.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget addOption() {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                setState(() {
                  isAddOption = false;
                });
              },
              icon: const Icon(Icons.keyboard_arrow_left)),
          const Spacer(),
          TextButton(
              onPressed: () {
                addItemToList();
                isAddOption = false;
                isSearching = false;
                _searchIcon = const Icon(Icons.search);
                markerLat = weatherData?.coord?.lat;
                markerLon = weatherData?.coord?.lon;
                map();
              },
              child: const Text('Ekle')),
        ],
      ),
    );
  }

  Widget currentPage() {
    return Column(
      children: [
        Text(
          weatherData?.name.toString() ?? '',
          style: const TextStyle(shadows: <Shadow>[
            Shadow(
              blurRadius: 3.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ], fontSize: 35),
          maxLines: 1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.only(bottom: 35),
          child: Row(
            children: List.generate(
                1,
                (index) => weatherData != null
                    ? Expanded(
                        flex: 20, child: _weatherCard(weatherData!, true))
                    : const SizedBox()),
          ),
        ),
        Card(
          color: Colors.transparent,
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
                          child: Column(
                            children: [
                              _weatherCard(forecastData![index], false),
                            ],
                          ))
                      : const SizedBox()),
            ),
          ),
        ),
      ],
    );
  }

  Widget _searchTextField() {
    return isSearching
        ? Autocomplete<Results>(
            displayStringForOption: displayStringForOption,
            optionsBuilder: (TextEditingValue searchCtrl) async {
              if (searchCtrl.text.length > 2) {
                SearchModel tempApi =
                    await getCitySearch(searchCtrl.text.toLowerCase());
                if (searchCtrl.text == '') {
                  return const Iterable<Results>.empty();
                }
                return tempApi.results!
                    .where((Results option) => option.city
                        .toLowerCase()
                        .startsWith(searchCtrl.text.toLowerCase()))
                    .toList();
              } else {
                return const Iterable<Results>.empty();
              }
            },
            onSelected: (Results text) {
              selectedCity = text;
              getWeatherData(q: displayStringForOption(text));
              isAddOption = true;
              isSearching = false;
              _searchIcon = const Icon(Icons.search);
              markerLat = weatherData?.coord?.lat;
              markerLon = weatherData?.coord?.lon;
              map();
              debugPrint('You just selected ${displayStringForOption(text)}');
            },
          )
        : const SizedBox();
  }

  static AssetImage background() {
    String bgTheme = '';
    var backGra = weatherData?.weather?.first.icon;

    if ((backGra?.substring(0, 2) == '02') ||
        (backGra?.substring(0, 2) == '03')) {
      bgTheme = 'assets/images/background/02-03.jpg';
    } else if (backGra?.substring(0, 2) == '04') {
      bgTheme = 'assets/images/background/04.jpg';
    } else if ((backGra?.substring(0, 2) == '09') ||
        (backGra?.substring(0, 2) == '10')) {
      bgTheme = 'assets/images/background/09-10.jpg';
    } else if (backGra?.substring(0, 2) == '11') {
      bgTheme = 'assets/images/background/11.jpg';
    } else if (backGra?.substring(0, 2) == '13') {
      bgTheme = 'assets/images/background/13.jpg';
    } else if (backGra?.substring(0, 2) == '50') {
      bgTheme = 'assets/images/background/50.jpg';
    } else {
      bgTheme = 'assets/images/background/01.jpg';
    }
    return AssetImage(bgTheme);
  }

  static AssetImage favBackground(String icon) {
    String bgTheme = 'assets/images/background/01.jpg';

    if ((icon.substring(0, 2) == '02') || (icon.substring(0, 2) == '03')) {
      bgTheme = 'assets/images/background/02-03.jpg';
    } else if (icon.substring(0, 2) == '04') {
      bgTheme = 'assets/images/background/04.jpg';
    } else if ((icon.substring(0, 2) == '09') ||
        (icon.substring(0, 2) == '10')) {
      bgTheme = 'assets/images/background/09-10.jpg';
    } else if (icon.substring(0, 2) == '11') {
      bgTheme = 'assets/images/background/11.jpg';
    } else if (icon.substring(0, 2) == '13') {
      bgTheme = 'assets/images/background/13.jpg';
    } else if (icon.substring(0, 2) == '50') {
      bgTheme = 'assets/images/background/50.jpg';
    } else {
      bgTheme = 'assets/images/background/01.jpg';
    }

    return AssetImage(bgTheme);
  }

  Widget detail() {
    DateFormat sunsetFormat = DateFormat('Hm');
    String? sunsetText = sunsetFormat
        .format(DateTime.fromMillisecondsSinceEpoch(
            (((weatherData?.sys?.sunset?.toInt())! + weatherData?.timezone) *
                1000),
            isUtc: true))
        .toString();

    DateFormat sunriseFormat = DateFormat('Hm');
    String? sunriseText = sunriseFormat
        .format(DateTime.fromMillisecondsSinceEpoch(
            (((weatherData?.sys?.sunrise?.toInt())! + weatherData?.timezone) *
                1000),
            isUtc: true))
        .toString();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 180,
                  width: 180,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 30, top: 4),
                          child: Opacity(
                            opacity: 0.7,
                            child: Text(
                              'Gün Doğumu',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            children: [
                              const Spacer(),
                              Column(
                                children: [
                                  Opacity(
                                      opacity: 0.7,
                                      child: Text(
                                        sunriseText,
                                        style: const TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ),
                              const Spacer(),
                              const SizedBox(
                                  height: 90,
                                  width: 90,
                                  child: Image(
                                      image: AssetImage(
                                          'assets/images/detail/sunrise.png'))),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 180,
                width: 180,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 50.0, top: 4),
                        child: Opacity(
                          opacity: 0.7,
                          child: Text(
                            'Gün Batımı',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          children: [
                            const Spacer(),
                            Column(
                              children: [
                                Opacity(
                                    opacity: 0.7,
                                    child: Text(
                                      sunsetText,
                                      style: const TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                            const Spacer(),
                            const SizedBox(
                                height: 90,
                                width: 90,
                                child: Image(
                                    image: AssetImage(
                                        'assets/images/detail/sunset.png'))),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 180,
                  width: 180,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 50.0, top: 4),
                          child: Opacity(
                            opacity: 0.7,
                            child: Text(
                              'Nem Oranı',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            children: [
                              const Spacer(),
                              Opacity(
                                  opacity: 0.7,
                                  child: Text(
                                    '${weatherData?.main?.humidity}',
                                    style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold),
                                  )),
                              const Spacer(),
                              const SizedBox(
                                  height: 90,
                                  width: 90,
                                  child: Image(
                                      image: AssetImage(
                                          'assets/images/detail/humidity.png'))),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 180,
                width: 180,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 80.0, top: 4),
                        child: Opacity(
                          opacity: 0.7,
                          child: Text(
                            'Basınç',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          children: [
                            const Spacer(),
                            Opacity(
                                opacity: 0.7,
                                child: Text(
                                  '${weatherData?.main?.pressure}',
                                  style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                )),
                            const Spacer(),
                            const SizedBox(
                                height: 90,
                                width: 90,
                                child: Image(
                                    image: AssetImage(
                                        'assets/images/detail/pressure.png'))),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 180,
                  width: 180,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 10.0, top: 4),
                          child: Opacity(
                            opacity: 0.7,
                            child: Text(
                              'Görüş Mesafesi',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            children: [
                              const Spacer(),
                              Column(
                                children: [
                                  Opacity(
                                      opacity: 0.7,
                                      child: Text(
                                        '${(weatherData?.visibility / 1000)}',
                                        style: const TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const Opacity(
                                      opacity: 0.7,
                                      child: Text(
                                        'km',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ),
                              const Spacer(),
                              const SizedBox(
                                  height: 90,
                                  width: 90,
                                  child: Image(
                                      image: AssetImage(
                                          'assets/images/detail/visibility.png'))),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 180,
                width: 180,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 30.0, top: 4),
                        child: Opacity(
                          opacity: 0.7,
                          child: Text(
                            'Max - Min °C',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          children: [
                            const Spacer(),
                            Column(
                              children: [
                                Opacity(
                                    opacity: 0.7,
                                    child: Text(
                                      '${weatherData?.main?.tempMax}',
                                      style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold),
                                    )),
                                Opacity(
                                    opacity: 0.7,
                                    child: Text(
                                      '${weatherData?.main?.tempMin}',
                                      style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                            const Spacer(),
                            const SizedBox(
                                height: 90,
                                width: 90,
                                child: Image(
                                    image: AssetImage(
                                        'assets/images/detail/max-min.png'))),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 180,
                  width: 180,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 45.0, top: 4),
                          child: Opacity(
                            opacity: 0.7,
                            child: Text(
                              'Rüzgar Hızı',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            children: [
                              const Spacer(),
                              Column(
                                children: [
                                  Opacity(
                                      opacity: 0.7,
                                      child: Text(
                                        '${weatherData?.wind?.speed}',
                                        style: const TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const Opacity(
                                      opacity: 0.7,
                                      child: Text(
                                        'km/sa',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ),
                              const Spacer(),
                              const SizedBox(
                                  height: 90,
                                  width: 90,
                                  child: Image(
                                      image: AssetImage(
                                          'assets/images/detail/wind-speed.png'))),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 180,
                width: 180,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 10.0, top: 4),
                        child: Opacity(
                          opacity: 0.7,
                          child: Text(
                            'Deniz Seviyesi',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          children: [
                            const Spacer(),
                            Column(
                              children: [
                                Opacity(
                                    opacity: 0.7,
                                    child: Text(
                                      '${weatherData?.main?.seaLevel}',
                                      style: const TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                            const Spacer(),
                            const SizedBox(
                                height: 90,
                                width: 90,
                                child: Image(
                                    image: AssetImage(
                                        'assets/images/detail/sea-level.png'))),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget searchButton() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: IconButton(
              onPressed: () {
                setState(() {
                  getWeatherData(q: city);
                  markerLat = cPosition?.latitude;
                  markerLon = cPosition?.longitude;
                });
              },
              icon: const Icon(Icons.location_on)),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Row(
            children: [
              SizedBox(
                width: 120,
                child: _searchTextField(),
              ),
              IconButton(
                onPressed: _onSearchPressed,
                icon: _searchIcon,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget drawer() {
    return Drawer(
        backgroundColor: Colors.white10,
        elevation: 0.0,
        child: ListView(children: [
          const Padding(padding: EdgeInsets.only(top: 15)),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Text(
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    'Hava Durumu'),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          SizedBox(height: 750, width: 300, child: favCard()),
        ]));
  }

  Widget map() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.transparent,
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              mapTile()
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10, bottom: 30, top: 10),
            child: Stack(children: [
              Column(
                children: [
                  SizedBox(
                    width: 1700,
                    height: 500,
                    child: FlutterMap(
                      options: MapOptions(
                        center: latlng.LatLng((markerLat! - 2), markerLon!),
                        zoom: 6,
                      ),
                      children: [
                        Stack(children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app',
                          ),
                          TileLayer(
                            backgroundColor: Colors.transparent,
                            urlTemplate:
                                'https://tile.openweathermap.org/map/$mapSelected/{z}/{x}/{y}.png',
                            tileProvider: NetworkTileProvider(
                                headers: {}, httpClient: MapClient()),
                          ),
                          MarkerLayer(
                            markers: [
                              mapplugin.Marker(
                                point: latlng.LatLng(markerLat!, markerLon!),
                                width: 40,
                                height: 40,
                                builder: (context) => const Image(
                                    image: AssetImage(
                                        'assets/images/detail/map.png')),
                              ),
                            ],
                          ),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          )
        ],
      ),
    );
  }

  Widget mapTile() {
    return Expanded(
      flex: 20,
      child: Row(
        children: [
          const Spacer(),
          TextButton(
              onPressed: () {
                setState(() {
                  mapSelected = 'clouds_new';
                });
              },
              child: const Text('Bulut')),
          const Spacer(),
          TextButton(
              onPressed: () {
                setState(() {
                  mapSelected = 'precipitation_new';
                });
              },
              child: const Text('Yağış')),
          const Spacer(),
          TextButton(
              onPressed: () {
                setState(() {
                  mapSelected = 'pressure_new';
                });
              },
              child: const Text('Basınç')),
          const Spacer(),
          TextButton(
              onPressed: () {
                setState(() {
                  mapSelected = 'wind_new';
                });
              },
              child: const Text('Rüzgar')),
          const Spacer(),
          TextButton(
              onPressed: () {
                setState(() {
                  mapSelected = 'temp_new';
                });
              },
              child: const Text('Sıcaklık')),
          const Spacer(),
        ],
      ),
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
      tmpDesc[i] = globals.StringExtension(tmpDesc[i]).toCap;
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
          ], color: Colors.white, fontSize: isToday ? 0 : 24),
          textAlign: TextAlign.center,
        ),
        const Padding(padding: EdgeInsets.only(top: 5)),
        Text(
          tempText,
          style: TextStyle(shadows: const <Shadow>[
            Shadow(
              blurRadius: 3.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ], color: Colors.white, fontSize: isToday ? 50 : 16),
          textAlign: TextAlign.center,
        ),
        Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 20),
            child: iconL(wData)),
        SizedBox(
          height: 50,
          child: Text(
            descText,
            style: TextStyle(shadows: const <Shadow>[
              Shadow(
                blurRadius: 3.0,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ], fontSize: isToday ? 40 : 14),
          ),
        ),
      ],
    );
  }

  Widget iconL(WeatherModel wData) {
    Map<String, String> descL = {
      '01d': 'assets/images/icon/01d.png',
      '01n': 'assets/images/icon/01n.png',
      '02d': 'assets/images/icon/03d.png',
      '02n': 'assets/images/icon/03n.png',
      '03d': 'assets/images/icon/03d.png',
      '03n': 'assets/images/icon/03d.png',
      '04d': 'assets/images/icon/04d.png',
      '04n': 'assets/images/icon/04d.png',
      '09d': 'assets/images/icon/09d.png',
      '09n': 'assets/images/icon/09d.png',
      '10d': 'assets/images/icon/10d.png',
      '10n': 'assets/images/icon/10n.png',
      '11d': 'assets/images/icon/11d.png',
      '11n': 'assets/images/icon/11d.png',
      '13d': 'assets/images/icon/13d.png',
      '13n': 'assets/images/icon/13d.png',
      '50d': 'assets/images/icon/50d.png',
      '50n': 'assets/images/icon/50d.png',
    };

    return Image(image: AssetImage(descL[wData.weather?.first.icon]!));
  }

  Widget favCard() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(8),
              itemCount: globals.favPlaces?.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    globals.favDelCity = globals.favPlaces?[index].name;
                    Navigator.pop(context);
                    getWeatherData(q: globals.favDelCity);
                  },
                  child: Slidable(
                    key: const ValueKey(1),
                    endActionPane: ActionPane(
                      extentRatio: 0.25,
                      motion: const ScrollMotion(),
                      dismissible: DismissiblePane(onDismissed: () {}),
                      children: [
                        SlidableAction(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          flex: 3,
                          onPressed: (context) {
                            setState(() {
                              (globals.favPlaces)
                                  ?.remove((globals.favPlaces)?[index]);
                            });
                          },
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                        ),
                      ],
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: favBackground(
                                globals.favPlaces![index].weather!.first.icon!),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: SizedBox(
                          height: 103,
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${globals.favPlaces?[index].name}',
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${globals.favPlaces?[index].weather?.first.description}',
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                        const SizedBox(
                                          height: 18,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${globals.favPlaces?[index].main?.temp}',
                                            style:
                                                const TextStyle(fontSize: 22),
                                          ),
                                          const Text(
                                            ' °C',
                                            style: TextStyle(fontSize: 22),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class MapClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return http.Request('GET',
            Uri.parse("${request.url}?appid=7b0b2395e0a953df1afeeb7ae7626527"))
        .send();
  }
}
