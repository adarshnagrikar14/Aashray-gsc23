// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:aashray/Classes/provide_aashray/provide_aashray_one.dart';
import 'package:aashray/Classes/provide_food/provide_food_one.dart';
import 'package:aashray/splashscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardDefault extends StatefulWidget {
  const DashboardDefault({super.key});

  @override
  State<DashboardDefault> createState() => _DashboardDefaultState();
}

class _DashboardDefaultState extends State<DashboardDefault> {
  final double _zoom = 16.5;

  final Completer<GoogleMapController> _controller = Completer();

  final List<Marker> _markers = <Marker>[];

  late LatLng currentPostion = const LatLng(
    20.0,
    20.0,
  );

  late String _postalCode = "", _cityName = "";

  final Uri _urlDonationSite =
      Uri.parse("https://pmnrf.gov.in/en/online-donation");

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
                  "You are at a safe place. But you can help the needy people by clicking any of the facility below.",
                  style: TextStyle(
                    fontSize: 17.0,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(
                  top: 15.0,
                  bottom: 2.0,
                  right: 2.0,
                  left: 2.0,
                ),
                child: Text(
                  "Volunteer Options below:",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Tile: Volunteer
              Padding(
                padding: const EdgeInsets.only(
                  top: 18.0,
                  bottom: 50.0,
                ),
                child: GestureDetector(
                  onTap: (() => showVolunteerDialog(context)),
                  child: Card(
                    color: Colors.grey.shade100,
                    elevation: 2.0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.green,
                      child: Center(
                        // child: Text(
                        //   "\nVolunteer\n",
                        //   style: TextStyle(
                        //     fontSize: 25.0,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: SizedBox(
                              child:
                                  Image.asset("assets/images/volunteer.png")),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.only(
                  bottom: 20.0,
                  right: 2.0,
                  left: 2.0,
                ),
                child: Text(
                  "Donation Options below:",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
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
              const SizedBox(
                height: 20.0,
              ),

              const Padding(
                padding: EdgeInsets.only(
                  top: 15.0,
                  bottom: 2.0,
                  right: 2.0,
                  left: 2.0,
                ),
                child: Text(
                  "More Options below:",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Tile: T&C
              Padding(
                padding: const EdgeInsets.only(
                  top: 12.0,
                  bottom: 25.0,
                ),
                child: Card(
                  color: Colors.grey.shade100,
                  elevation: 2.0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 22.0,
                        horizontal: 20.0,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.import_contacts_rounded,
                            size: 30.0,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Terms of Use",
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
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

  showVolunteerDialog(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            20.0,
          ),
          topRight: Radius.circular(
            20.0,
          ),
        ),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(
              5.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Card(
                  color: Colors.grey,
                  child: SizedBox(
                    height: 5.0,
                    width: 50.0,
                  ),
                ),

                // Tile: Aashray
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12.0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProvideAashrayOne(),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.grey.shade100,
                      elevation: 2.0,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Center(
                          child: Text(
                            "\nProvide Aashray\n",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Tile: Food
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12.0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProvideFoodOne(),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.grey.shade100,
                      elevation: 2.0,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Center(
                          child: Text(
                            "\nProvide Food\n",
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
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
    );
  }

  launchUrlDonation(BuildContext context) async {
    if (!await launchUrl(
      _urlDonationSite,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception("Could not launch $_urlDonationSite");
    }
  }

  void getUpdateonLaction(String postalCode) {
    var docRef = FirebaseFirestore.instance
        .collection("Disaster Locations")
        .doc(postalCode);

    docRef.get().then((value) {
      if (value.exists) {
        String type = value.get("Type").toString();

        if (type.isNotEmpty) {
          getAlert(type);
        }
      }
    }).onError((error, stackTrace) => null);
  }

  void getAlert(String type) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          "You are likely to be in a disaster prone zone.\nType: $type",
        ),
        content: const Text(
          "Please continue to seek Aashray.",
        ),
        // backgroundColor: Colors.green.shade100,
        actions: <Widget>[
          ElevatedButton(
            onPressed: () async {
              final sharedPrefs = await SharedPreferences.getInstance();

              await sharedPrefs
                  .setString("screenName", "AashrayEmergency")
                  .then(
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
              backgroundColor: Colors.red,
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

  // String getDist() {
  //   double dist = Geolocator.distanceBetween(
  //       21.131327, 79.110804, 21.1761918, 79.0446728);

  //   return dist.toString();
  // }
}
