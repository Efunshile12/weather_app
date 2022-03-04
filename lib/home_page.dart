// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:weather4/dataset.dart';
import 'package:weather4/extra_weather.dart';


Weather currentTemp;
Weather tomorrowTemp;
List<Weather> todayWeather;
List<Weather> sevenDay;
String lat = "6.464422";
String lon = "3.406448";
String city = "Lagos";

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getData() async {
    fetchData(lat, lon, city).then((value) {
      currentTemp = value[0];
      todayWeather = value[1];
      tomorrowTemp = value[2];
      sevenDay = value[3];
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff030317),
      body: currentTemp == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [CurrentWeather(getData), TodayWeather()],
            ),
    );
  }
}

class CurrentWeather extends StatefulWidget {
  final Function() updateData;
  const CurrentWeather(this.updateData);
  @override
  _CurrentWeatherState createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends State<CurrentWeather> {
  bool searchBar = false;
  bool updating = false;
  var focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        if (searchBar) {
          setState(() {
            searchBar = true;
          });
        }
      },
      child: GlowContainer(
        width: MediaQuery.of(context).size.width * 2,
        height: MediaQuery.of(context).size.height - 230,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.only(top: 50, left: 5, right:5,bottom:50),
        glowColor: Colors.white.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(80), bottomLeft: Radius.circular(80)),
        color: Colors.blue.shade700,
        spreadRadius: 3,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: searchBar
                  ? TextField(
                      focusNode: focusNode,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          fillColor: Colors.black26,
                          filled: true,
                          hintText: "Enter a city Name",),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) async {
                        CityModel temp = await fetchCity(value);
                        if (temp == null) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: const Color(0xff030317),
                                  title: const Text("City not found"),
                                  content:
                                      const Text("Please check the city name"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Ok"))
                                  ],
                                );
                              });
                          searchBar = false;
                          return;
                        }
                        city = temp.name;
                        lat = temp.lat;
                        lon = temp.lon;
                        updating = true;
                        setState(() {});
                        widget.updateData();
                        searchBar = false;
                        updating = false;
                        setState(() {});
                      },
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            searchBar = true;
                            setState(() {});
                            focusNode.requestFocus();
                          },
                          child: const Icon(CupertinoIcons.search,
                              color: Colors.white, size: 30),
                        ),
                        Row(
                          children: [
                            const Icon(CupertinoIcons.placemark,
                                color: Colors.white),
                            GestureDetector(
                              onTap: () {
                                searchBar = false;
                                setState(() {});
                                focusNode.requestFocus();
                              },
                              child: Text(
                                
                                " " + city  ,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                            ),
                          ],
                        ),
                        const Icon(Icons.menu, color: Colors.white)
                      ]
                    ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.2, color: Colors.white),
                  color: Colors.yellow.shade400,
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                updating ? "Updating" : "Updated",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Expanded(
                    child: Row(
                      
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image(
                          image: AssetImage(currentTemp.image),
                          fit: BoxFit.fill,
                        ),
                      
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GlowText(
                                currentTemp.current.toString(),
                                style: TextStyle(
                                    height: 0.1,
                                    fontSize:120,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                currentTemp.name,
                                style: TextStyle(
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                currentTemp.day,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                       
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
            ExtraWeather(currentTemp)
          ],
        ),
      ),
    );
  }
}

class TodayWeather extends StatelessWidget {
  const TodayWeather({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Text(
                  "Today",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (BuildContext context) {
              //       return DetailPage(tomorrowTemp, sevenDay);
              //     }));
              //   },
              //   child: Row(
              //     children: const [
              //       Text(
              //         '',
              //         style: TextStyle(
              //             fontSize: 18,
              //             fontWeight: FontWeight.bold,
              //             color: Colors.grey),
              //       ),
              //       Icon(
              //         Icons.arrow_forward_ios_outlined,
              //         color: Colors.grey,
              //         size: 15,
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 10,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WeatherWidget(todayWeather[0]),
                  WeatherWidget(todayWeather[1]),
                  WeatherWidget(todayWeather[2]),
                  WeatherWidget(todayWeather[3])
                ]),
          )
        ],
      ),
    );
  }
}

class WeatherWidget extends StatelessWidget {
  final Weather weather;
  const WeatherWidget(this.weather, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          border: Border.all(width: 0.2, color: Colors.white),
          borderRadius: BorderRadius.circular(35)),
      child: Column(
        children: [
          Text(
            weather.current.toString() + "\u00B0",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 5,
          ),
          Image(
            image: AssetImage(weather.image),
            width: 50,
            height: 50,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            weather.time,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          )
        ],
      ),
    );
  }
}
