// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:aashray/Classes/provide_aashray/provide_aashray_one.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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

  int _current = 0;
  final CarouselController _controllerCarousel = CarouselController();

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
                height: 500.0,
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
                        shrinkWrap: true,
                        primary: false,
                        children: snapshot.data!.docs.map(
                          (documents) {
                            final List<dynamic> imageURLs =
                                documents["ImageLists"].toList();

                            return Card(
                              color: Colors.grey.shade100,
                              elevation: 3.0,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CarouselSlider.builder(
                                      options: CarouselOptions(
                                        height: 180.0,
                                        disableCenter: true,
                                        // aspectRatio: 16 / 9,
                                        autoPlayInterval: const Duration(
                                          seconds: 3,
                                        ),
                                        viewportFraction: 1.0,
                                        autoPlay: true,
                                        enableInfiniteScroll: false,
                                        onPageChanged: (index, reason) {
                                          setState(
                                            () {
                                              _current = index;
                                            },
                                          );
                                        },
                                      ),
                                      itemCount: imageURLs.length,
                                      itemBuilder: (BuildContext context,
                                          int index, int realIndex) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.green,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Image.network(
                                                  imageURLs[index],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: imageURLs
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        return GestureDetector(
                                          onTap: () => _controllerCarousel
                                              .animateToPage(entry.key),
                                          child: Container(
                                            width: 8.0,
                                            height: 8.0,
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 8.0,
                                              horizontal: 4.0,
                                            ),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: (Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? Colors.white
                                                      : Colors.black)
                                                  .withOpacity(
                                                      _current == entry.key
                                                          ? 0.9
                                                          : 0.4),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8.0,
                                      ),
                                      child: Text(
                                        // ignore: prefer_interpolation_to_compose_strings
                                        "Address: " +
                                            documents["Address"]
                                                .toString()
                                                .toLowerCase(),
                                        style: const TextStyle(
                                          fontSize: 17.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8.0,
                                      ),
                                      child: Text(
                                        documents["Name"] + "'s Aashray\n",
                                        style: const TextStyle(
                                          fontSize: 17.0,
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
                                        "Preference: " +
                                            documents["Accomodation"]
                                                .toString()
                                                .toLowerCase(),
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
                                        "Max. Accomodation:\t" +
                                            documents["Maximum Accomodation"]
                                                .toString()
                                                .toLowerCase(),
                                        style: const TextStyle(
                                          fontSize: 17.5,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 18.0,
                                          bottom: 10.0,
                                          left: 10.0,
                                          right: 10.0,
                                        ),
                                        child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                // Login
                                                builder: (context) =>
                                                    const ProvideAashrayOne(),
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
                                            padding: EdgeInsets.all(12.0),
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
              // Image.asset("assets/images/grass.png"),
            ],
          ),
        ),
      ),
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
