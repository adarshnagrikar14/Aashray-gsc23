import 'dart:async';

import 'package:aashray/Classes/provide_aashray/provide_aashray_one.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Tile: Volunteer
              Padding(
                padding: const EdgeInsets.only(
                  top: 12.0,
                ),
                child: GestureDetector(
                  onTap: (() => showVolunteerDialog(context)),
                  child: Card(
                    color: Colors.grey.shade100,
                    elevation: 2.0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                        child: Text(
                          "\nVolunteer\n",
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

              // Tile: Donate
              GestureDetector(
                onTap: () => showDonateDialog(context),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 17.0,
                  ),
                  child: Card(
                    color: Colors.grey.shade100,
                    elevation: 2.0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                        child: Text(
                          "\nDonate\n",
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

              // Tile: Helpline
              Padding(
                padding: const EdgeInsets.only(
                  top: 12.0,
                ),
                child: Card(
                  color: Colors.grey.shade100,
                  elevation: 2.0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                      child: Text(
                        "\nHelpline\n",
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Tile: T&C
              Padding(
                padding: const EdgeInsets.only(
                  top: 12.0,
                ),
                child: Card(
                  color: Colors.grey.shade100,
                  elevation: 2.0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                      child: Text(
                        "\nTerms of Use\n",
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Tile: Test
              Padding(
                padding: const EdgeInsets.only(
                  top: 12.0,
                ),
                child: Card(
                  color: Colors.grey.shade100,
                  elevation: 2.0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                      child: Text(
                        "\nPhoto and quote as decided.\n",
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 50.0,
                    bottom: 10.0,
                  ),
                  child: Text("Aur kuchh dalna hai to daal sakte hai "),
                ),
              ),

              // Center(
              //   child: Padding(
              //     padding: const EdgeInsets.only(
              //       top: 50.0,
              //       bottom: 10.0,
              //     ),
              //     child: Text(getDist()),
              //   ),
              // )
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
              ],
            ),
          ),
        );
      },
    );
  }

  showDonateDialog(BuildContext context) {
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
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(
              5.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Card(
                  color: Colors.grey,
                  child: SizedBox(
                    height: 5.0,
                    width: 50.0,
                  ),
                ),

                // Tile: Donate
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12.0,
                  ),
                  child: Card(
                    color: Colors.grey.shade100,
                    elevation: 2.0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                        child: Text(
                          "\nDonate\n",
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Donate Button
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8.0,
                  ),
                  child: ElevatedButton(
                    onPressed: () => launchUrlDonation(context),
                    style: ElevatedButton.styleFrom(
                      elevation: 2.0,
                      textStyle: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: SizedBox(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: const Center(
                        child: Text(
                          'Donate',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
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

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
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
        title: const Text("You are likely to be in a disaster prone zone"),
        content: const Text("Please continue to seek Aashray"),
        // backgroundColor: Colors.green.shade100,
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
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
