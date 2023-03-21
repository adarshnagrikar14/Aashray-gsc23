// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:aashray/Classes/locate_aashray/locate_aashray.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: library_prefixes
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

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

  int _current = 0;
  final CarouselController _controllerCarousel = CarouselController();

  late bool _visibleAashray = true;
  late bool _visibleFood = false;

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

              Padding(
                padding: const EdgeInsets.only(
                  top: 25.0,
                  bottom: 20.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                  child: ListTile(
                    leading: null,
                    title: Text(
                      "\t\tAashrays around you",
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(
                      _visibleAashray
                          ? Icons.arrow_drop_up_rounded
                          : Icons.arrow_drop_down_rounded,
                      size: 50.0,
                    ),
                    onTap: () {
                      setState(() {
                        _visibleAashray = !_visibleAashray;
                      });
                    },
                    contentPadding: EdgeInsets.all(5.0),
                  ),
                ),
              ),

              Visibility(
                visible: _visibleAashray,
                child: SizedBox(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Aashrays")
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

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Card(
                                  color: Colors.grey.shade100,
                                  // color: Colors.green.shade100,
                                  elevation: 3.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.green,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
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
                                                margin:
                                                    const EdgeInsets.symmetric(
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
                                            top: 1.0,
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
                                                documents[
                                                        "Maximum Accomodation"]
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
                                            "Availability:\t" +
                                                documents["Max Period"]
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
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.hotel_outlined),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                  documents["Rooms"] +
                                                      " Room(s) with " +
                                                      documents["Beds"] +
                                                      " Bed(s)",
                                                  style: const TextStyle(
                                                    fontSize: 17.5,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
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
                                                    builder: (context) =>
                                                        LocateAashray(
                                                      documents,
                                                    ),
                                                    // Home(),
                                                  ),
                                                );
                                              },
                                              style: OutlinedButton.styleFrom(
                                                side: const BorderSide(
                                                  width: 2.0,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(15.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Icon(
                                                      Icons.location_on,
                                                      size: 30.0,
                                                      color: Colors.green,
                                                    ),
                                                    Text(
                                                      "\t\tLocate Aashray",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.0,
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

              Padding(
                padding: const EdgeInsets.only(
                  top: 25.0,
                  bottom: 20.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.all(
                      Radius.circular(12.0),
                    ),
                  ),
                  child: ListTile(
                    leading: null,
                    title: Text(
                      "\t\tFood providers around you:",
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(
                      _visibleFood
                          ? Icons.arrow_drop_up_rounded
                          : Icons.arrow_drop_down_rounded,
                      size: 50.0,
                    ),
                    onTap: () {
                      setState(() {
                        _visibleFood = !_visibleFood;
                      });
                    },
                    contentPadding: EdgeInsets.all(5.0),
                  ),
                ),
              ),

              Visibility(
                visible: _visibleFood,
                child: SizedBox(
                  // height: 600.0,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Food Providers")
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
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Card(
                                  color: Colors.grey.shade100,
                                  elevation: 3.0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
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
                                                documents["Meal Type"]
                                                    .toString(),
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
                                                documents["Average"]
                                                    .toString() +
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
                                                documents["End Date"]
                                                    .toString(),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 30.0,
                                              bottom: 10.0,
                                            ),
                                            child: OutlinedButton(
                                              onPressed: () {
                                                // ignore: deprecated_member_use
                                                UrlLauncher.launch(
                                                    "tel://+91${documents["Mobile"]}");
                                              },
                                              style: OutlinedButton.styleFrom(
                                                side: const BorderSide(
                                                  width: 2.0,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(15.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: const [
                                                    Icon(
                                                      Icons.call,
                                                      size: 30.0,
                                                      color: Colors.green,
                                                    ),
                                                    Text(
                                                      "\t\tContact them",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18.0,
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
