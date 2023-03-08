import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../splashscreen.dart';

class DashboardEmergency extends StatefulWidget {
  const DashboardEmergency({super.key});

  @override
  State<DashboardEmergency> createState() => _DashboardEmergencyState();
}

class _DashboardEmergencyState extends State<DashboardEmergency> {
  final double _zoom = 16.5;

  final Completer<GoogleMapController> _controller = Completer();

  final List<Marker> _markers = <Marker>[];

  late LatLng currentPostion = const LatLng(
    20.0,
    20.0,
  );

  late String _postalCode = "", _cityName = "", _disasterType = "";

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
                      circles: {
                        Circle(
                          circleId: const CircleId('circleID'),
                          center: LatLng(
                            currentPostion.latitude,
                            currentPostion.longitude,
                          ),
                          radius: 120.0,
                          fillColor: Colors.red.withOpacity(0.4),
                          strokeColor: Colors.red,
                          strokeWidth: 1,
                        ),
                      },
                    ),
                  ),
                ),
              ),

              // Safe Unsafe Text
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 2.0,
                ),
                child: Text(
                  "You are currently at a disaster prone zone as detected. Likely $_disasterType.\nDon't be panic at this situation and try to get to a safer place as soon as possible.",
                  style: const TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(
                  right: 2.0,
                  left: 2.0,
                ),
                child: Text(
                  "Aashrays around you:",
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

  void getUpdateonLaction(String postalCode) {
    var docRef = FirebaseFirestore.instance
        .collection("Disaster Locations")
        .doc(postalCode);

    docRef.get().then((value) {
      if (value.exists) {
        String type = value.get("Type").toString();

        if (type.isNotEmpty) {
          setState(() {
            _disasterType = type;
          });
        }
      } else if (!value.exists) {
        getAlert("None");
      }
    }).onError((error, stackTrace) => null);
  }

  void getAlert(String type) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("You are likely to be out of danger zone now."),
        content: const Text("Continue to Home page."),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () async {
              final sharedPrefs = await SharedPreferences.getInstance();

              await sharedPrefs.setString("screenName", "AashrayDefault").then(
                (value) {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Splashscreen(),
                    ),
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 12.0,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Center(
                    child: Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                )),
              ),
            ),
          ),
        ],
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

        setState(() {
          _postalCode = postalCode;
          _cityName = "$cityName - $test,";
        });

        getUpdateonLaction(postalCode);
      },
    );
  }
}
