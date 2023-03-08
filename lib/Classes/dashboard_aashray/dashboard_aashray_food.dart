import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DashboardFood extends StatefulWidget {
  const DashboardFood({super.key});

  @override
  State<DashboardFood> createState() => _DashboardFoodState();
}

class _DashboardFoodState extends State<DashboardFood> {
  final double _zoom = 16.5;

  final Completer<GoogleMapController> _controller = Completer();

  final List<Marker> _markers = <Marker>[];

  late LatLng currentPostion = const LatLng(
    20.0,
    20.0,
  );

  late String _postalCode = "", _cityName = "";

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError(
      (error, stackTrace) async {
        await Geolocator.requestPermission();
      },
    );
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();

    getLocationAndAdd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // City
              Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                  bottom: 10.0,
                  left: 2.0,
                ),
                child: Text(
                  "City: $_cityName $_postalCode",
                  style: const TextStyle(
                    fontSize: 17.0,
                  ),
                ),
              ),

              // Map
              Center(
                child: SizedBox(
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      15.0,
                    ),
                    child: GoogleMap(
                      mapType: MapType.satellite,
                      myLocationEnabled: false,
                      compassEnabled: true,
                      zoomGesturesEnabled: false,
                      rotateGesturesEnabled: false,
                      tiltGesturesEnabled: false,
                      scrollGesturesEnabled: false,
                      myLocationButtonEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      initialCameraPosition: CameraPosition(
                        target: currentPostion,
                        zoom: _zoom,
                      ),
                      markers: Set<Marker>.of(_markers),
                      zoomControlsEnabled: false,
                    ),
                  ),
                ),
              ),

              // Safe Unsafe Text
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 2.0,
                ),
                child: Text(
                  "You are at a safe place and you have chosen to provide the Food for needy person.",
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(
                  right: 2.0,
                  left: 2.0,
                ),
                child: Text(
                  "Provided Details:",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getLocationAndAdd() {
    getUserCurrentLocation().then(
      (value) async {
        _markers.add(Marker(
          markerId: const MarkerId("2"),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: const InfoWindow(
            title: 'Current Location',
          ),
        ));

        // specified current users location
        CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude),
          zoom: _zoom,
        );

        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition),
        );

        List<Placemark> placemarks = await placemarkFromCoordinates(
          value.latitude,
          value.longitude,
        );

        currentPostion = LatLng(value.latitude, value.longitude);
        String postalCode = placemarks[0].postalCode as String;
        String cityName = placemarks[0].locality as String;
        String test = placemarks[0].subAdministrativeArea as String;

        setState(
          () {
            _postalCode = postalCode;
            _cityName = "$cityName - $test,";
          },
        );
      },
    );
  }
}
