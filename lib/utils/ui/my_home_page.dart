import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_open_weather/location/location_service.dart';
import 'package:flutter_open_weather/model/search_model.dart';
import 'package:flutter_open_weather/model/weather_model.dart';
import 'package:flutter_open_weather/api/weather_api.dart';
import 'package:flutter_open_weather/utils/ui/current_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'add_option.dart';
import 'package:flutter_open_weather/utils/ui/globals.dart' as globals;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:flutter_map/plugin_api.dart' as mapplugin;

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
  WeatherModel? weatherData;
  List<WeatherModel>? forecastData;
  late final LocSvc locSvc;

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

  getCitySearch(String? q) async {
    var response = (await http.get(Uri.parse(
        'https://api.geoapify.com/v1/geocode/autocomplete?text=$q&type=city&format=json&apiKey=552e057cf7694553818c4b2cf3ccd1f7')));
    return SearchModel.fromJson(jsonDecode(response.body));
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
              getWeatherData(q: displayStringForOption(text));
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddOption(
                          qSelect: displayStringForOption(text),
                        )),
              );
              debugPrint('You just selected ${displayStringForOption(text)}');
            },
          )
        : const SizedBox();
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
          drawer: drawer(),
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Column(
              children: [
                searchButton(),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: CurrentPage(),
                ),
                map()
              ],
            ),
          )),
    );
  }

  Widget searchButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 220.0, top: 40),
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
    );
  }

  Widget drawer() {
    return Drawer(
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
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    locSvc.getCurrentPosition();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.location_on)),
              const Text('Mevcut Konum'),
            ],
          ),
          favCard(),
        ]));
  }

  Widget map() {
    return Stack(children: [
      Column(
        children: [
          SizedBox(
            width: 400,
            height: 400,
            child: FlutterMap(
              options: MapOptions(
                center: const latlng.LatLng(38.2, 29.3),
                zoom: 6.5,
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
                        'https://tile.openweathermap.org/map/temp_new/{z}/{x}/{y}.png',
                    tileProvider: NetworkTileProvider(
                        headers: {}, httpClient: MapClient()),
                  ),
                  MarkerLayer(
                    markers: [
                      mapplugin.Marker(
                        point: const latlng.LatLng(40.2, 29.3),
                        width: 80,
                        height: 80,
                        builder: (context) => LottieBuilder.network(clearSkyL),
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ),
          //CurrentPage(),
        ],
      ),
    ]);
  }

  Widget favCard() {
    return SizedBox(
      height: double.maxFinite,
      width: double.infinity,
      child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: globals.favPlaces?.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: Slidable(
                key: const ValueKey(1),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  dismissible: DismissiblePane(onDismissed: () {}),
                  children: const [
                    SlidableAction(
                      onPressed: doNothing,
                      backgroundColor: Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 103,
                  width: 300,
                  child: Text(
                    '${globals.favPlaces?[index].name}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

void doNothing(BuildContext context) {}

class MapClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    //request.url.queryParameters.putIfAbsent('appid',()=> '7b0b2395e0a953df1afeeb7ae7626527');
    //http.BaseRequest tempReq = request;
    //print(request.url.toString());
    return http.Request('GET',
            Uri.parse("${request.url}?appid=7b0b2395e0a953df1afeeb7ae7626527"))
        .send();

    //tempReq.finalize();
    //throw UnimplementedError();
  }
}