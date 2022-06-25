import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class CoordinateToAddress extends StatefulWidget {
  const CoordinateToAddress({Key? key}) : super(key: key);

  @override
  State<CoordinateToAddress> createState() => _CoordinateToAddressState();
}

class _CoordinateToAddressState extends State<CoordinateToAddress> {
  String stAddress = "";
  String stAdd = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(stAddress),
          Text(stAdd),
          GestureDetector(
            onTap: () async {
              List<Location> locations =
                  await locationFromAddress("Gronausestraat 710, Enschede");

              List<Placemark> placemarks =
                  await placemarkFromCoordinates(52.2165157, 6.9437819);

              setState(() {
                stAddress =
                    "${locations.last.longitude} ${locations.last.latitude}";

                stAdd="${placemarks.reversed.last.country} ${placemarks.reversed.last.locality}";
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 58,
                decoration: const BoxDecoration(color: Colors.lightBlueAccent),
                child: const Center(
                  child: Text('Convert'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
