import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dataset.dart';


class ExtraWeather extends StatelessWidget {
  final Weather temp;
  const ExtraWeather(this.temp);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            const Icon(
              CupertinoIcons.wind,
              color: Colors.white,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              temp.wind.toString() + " Km/h",
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Wind",
              style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold),
            )
          ],
        ),
        Column(
          children: [
          const  Icon(
              CupertinoIcons.drop,
              color: Colors.white,
            ),
           const SizedBox(
              height: 10,
            ),
            Text(
              temp.humidity.toString() + " %",
              style:const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
           const SizedBox(
              height: 10,
            ),
            const Text(
              "Humidity",
              style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold, fontSize: 16),
            )
          ],
        ),
        Column(
          children: [
          const  Icon(
              CupertinoIcons.cloud_rain,
              color: Colors.white,
            ),
           const SizedBox(
              height: 10,
            ),
            Text(
              temp.chanceRain.toString() + " %",
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
           const SizedBox(
              height: 10,
            ),
           const Text(
              "Rain",
              style: TextStyle(color: Colors.black54, fontSize: 16,
                  fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    );
  }
}
