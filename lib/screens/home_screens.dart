import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(24.971723, 67.065707), zoom: 14.0);

  final Completer<GoogleMapController> _controller = Completer();

  final List<Marker> _marker = [];

  final List<Marker> list = [
    const Marker(
      markerId: MarkerId('1'),
      position: LatLng(24.971723, 67.065707),
      infoWindow: InfoWindow(title: 'My current location'),
    ),
    const Marker(
      markerId: MarkerId('2'),
      position: LatLng(24.972420, 67.065857),
      infoWindow: InfoWindow(title: 'My areas location'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _marker.addAll(list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set<Marker>.of(_marker),
        initialCameraPosition: _kGooglePlex,
        // mapType: MapType.hybrid,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
      ),
    );
  }
}
