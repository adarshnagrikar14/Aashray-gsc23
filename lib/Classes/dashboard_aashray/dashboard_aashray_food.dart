// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:aashray/Classes/provide_food/provide_food_one.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  "You are at a safe place and you have chosen to provide the Food for needy people.",
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
                  bottom: 25.0,
                  top: 10.0,
                ),
                child: Text(
                  "Provided Details:",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(
                height: 600.0,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Food Providers")
                      .where("userID", isEqualTo: _userId)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Text("No Data Found!");
                    } else if (snapshot.hasData) {
                      return ListView(
                        shrinkWrap: true,
                        primary: false,
                        children: snapshot.data!.docs.map(
                          (documents) {
                            return Card(
                              color: Colors.grey.shade100,
                              elevation: 3.0,
                              child: Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 200.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/teamwork-in-homeless-shelter-royalty-free-image-1608327313.?crop=1.00xw:0.755xh;0,0.142xh&resize=1200:*",
                                          ),
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12.0),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 20.0,
                                      ),
                                      child: Text(
                                        // ignore: prefer_interpolation_to_compose_strings
                                        "Food Provider:\t\t" +
                                            documents["Name"].toString(),
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8.0,
                                      ),
                                      child: Text(
                                        // ignore: prefer_interpolation_to_compose_strings
                                        "Mobile No.:\t\t" +
                                            documents["Mobile"].toString(),
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8.0,
                                        bottom: 15.0,
                                      ),
                                      child: Text(
                                        // ignore: prefer_interpolation_to_compose_strings
                                        "Address:\t\t" +
                                            documents["Address"].toString(),
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8.0,
                                      ),
                                      child: Text(
                                        // ignore: prefer_interpolation_to_compose_strings
                                        "Meal type:\t\t" +
                                            documents["Meal Type"].toString(),
                                        style: const TextStyle(
                                          fontSize: 17.5,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8.0,
                                      ),
                                      child: Text(
                                        // ignore: prefer_interpolation_to_compose_strings
                                        "Average capacity to feed:\t\t" +
                                            documents["Average"].toString() +
                                            "\t people",
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8.0,
                                      ),
                                      child: Text(
                                        // ignore: prefer_interpolation_to_compose_strings
                                        "Preferred Dates:\n" +
                                            documents["Initial Date"]
                                                .toString() +
                                            " to " +
                                            documents["End Date"].toString(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 30.0,
                                          bottom: 10.0,
                                        ),
                                        child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                // Login
                                                builder: (context) =>
                                                    const ProvideFoodOne(),
                                              ),
                                            );
                                          },
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                              width: 2.0,
                                              color: Colors.green,
                                            ),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(15.0),
                                            child: Text(
                                              "Edit Details",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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

              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: Colors.green.shade100,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                    8.0,
                  ),
                  child: Text(
                    "\"It's not how much we give\nbut how much love we put into giving\"\n-Mother Teresa",
                    style: GoogleFonts.lobster(
                      textStyle: const TextStyle(
                        fontSize: 28,
                        // fontWeight: FontWeight.bold,

                        color: Colors.black,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              SizedBox(
                height: 40.0,
              ),

              Card(
                elevation: 2.0,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.grey.shade100,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Text(
                          "\nFurther more, you can even contribute to the disaster relief fund. To know more, click below.\n",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Center(
                          child: Image.asset(
                            "assets/images/donation.png",
                            height: 200.0,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 60.0,
                              bottom: 10.0,
                            ),
                            child: OutlinedButton(
                              onPressed: (() => launchUrlDonation(context)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  width: 2.0,
                                  color: Color.fromARGB(255, 187, 169, 5),
                                ),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text(
                                  "Donate Now",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 118, 103, 3),
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
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
        _markers.add(
          Marker(
            markerId: const MarkerId("2"),
            position: LatLng(value.latitude, value.longitude),
            infoWindow: const InfoWindow(
              title: 'Current Location',
            ),
          ),
        );

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

  launchUrlDonation(BuildContext context) async {
    final Uri urlDonationSite = Uri.parse(
      "https://pmnrf.gov.in/en/online-donation",
    );
    if (!await launchUrl(
      urlDonationSite,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception("Could not launch $urlDonationSite");
    }
  }
}
