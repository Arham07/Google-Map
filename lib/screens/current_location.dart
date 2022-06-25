import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({Key? key}) : super(key: key);

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {

  String address='';

  static const CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(24.968908, 67.064789), zoom: 14.0);

  final Completer<GoogleMapController> _controller = Completer();

  final List<Marker> _marker = [];

  final List<Marker> list = [
    const Marker(
      markerId: MarkerId('1'),
      position: LatLng(24.965954, 67.058156),
      infoWindow: InfoWindow(title: 'Hospital'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _marker.addAll(list);
    // loadData();
  }

  Future<Position> getCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print(error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  // loadData() {
  //   getCurrentLocation().then((value) async {
  //     _marker.add(Marker(
  //         markerId: const MarkerId('2'),
  //         position: LatLng(value.latitude, value.longitude),
  //         infoWindow: const InfoWindow(title: 'My current Location')));
  //
  //     final GoogleMapController controller = await _controller.future;
  //     CameraPosition kGooglePlex = CameraPosition(
  //       target: LatLng(value.latitude, value.longitude),
  //       zoom: 14,
  //     );
  //     controller.animateCamera(CameraUpdate.newCameraPosition(kGooglePlex));
  //     setState(() {});
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        title: const Text('Flutter Google Map'),
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GoogleMap(
              initialCameraPosition: _kGooglePlex,
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              markers: Set<Marker>.of(_marker),
              onMapCreated: (GoogleMapController controller){
                _controller.complete(controller);
              },
            ),
            Container(
              height: MediaQuery.of(context).size.height * .15,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      getCurrentLocation().then((value) async {
                        print('My current location');
                        print(value.latitude.toString());
                        _marker.add(
                          Marker(
                              markerId: const MarkerId('2'),
                              position: LatLng(value.latitude, value.longitude),
                              infoWindow: const InfoWindow(title: 'My Current Location')),
                        );
                        CameraPosition _kGooglePlex = CameraPosition(
                          target: LatLng(value.latitude, value.longitude),
                          zoom: 14,
                        );
                        GoogleMapController controller = await _controller.future;
                        controller.animateCamera(
                          CameraUpdate.newCameraPosition(_kGooglePlex),
                        );
                        List<Placemark> placemarks = await placemarkFromCoordinates(value.latitude ,value.longitude);


                        final add = placemarks.first;
                        address = "${add.name} ${add.subAdministrativeArea} ${add.administrativeArea} ${add.country}";

                        setState(() {});
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10 , horizontal: 20),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: const Center(child: Text('Current Location' , style: TextStyle(color: Colors.white),)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(address),
                  )
                ],
              ),
            )
          ],
        ),

      ),
    );
  }


}
