import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  final double _zoom = 16.5;

  final Completer<GoogleMapController> _controller = Completer();

  final List<Marker> _markers = <Marker>[];

  late LatLng currentPostion = const LatLng(
    20.0,
    20.0,
  );

  late String _postalCode = "", _cityName = "";

  final User? user = FirebaseAuth.instance.currentUser;
  // uid
  late String _userId;

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
    setState(() {
      _userId = user!.uid;
    });

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
                  "You are at a safe place and you have chosen to provide the Aashray for needy person.",
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 2.0,
                ),
                child: Text(
                  "Your Aashray Details:",
                  style: TextStyle(
                    fontSize: 18.5,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),

              SizedBox(
                height: 400.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Aashrays")
                        .where("userID", isEqualTo: _userId)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Text("No Data Found!");
                      } else if (snapshot.hasData) {
                        return ListView(
                          shrinkWrap: false,
                          primary: false,
                          children: snapshot.data!.docs.map(
                            (documents) {
                              return Card(
                                child: Column(
                                  children: [
                                    Text(documents["Address"] + "\n"),
                                    Text(documents["Accomodation"]),
                                  ],
                                ),
                              );
                            },
                          ).toList(),
                        );
                      } else {
                        return const Text("No Data Found!");
                      }
                    },
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
        controller
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        List<Placemark> placemarks = await placemarkFromCoordinates(
          value.latitude,
          value.longitude,
        );

        setState(() {
          currentPostion = LatLng(value.latitude, value.longitude);
          String postalCode = placemarks[0].postalCode as String;
          String cityName = placemarks[0].locality as String;
          String test = placemarks[0].subAdministrativeArea as String;

          setState(() {
            _postalCode = postalCode;
            _cityName = "$cityName - $test,";
          });
        });
      },
    );
  }
}
