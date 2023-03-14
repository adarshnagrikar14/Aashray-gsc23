// ignore_for_file: no_logic_in_create_state, must_be_immutable, avoid_print, deprecated_member_use

import 'dart:async';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: library_prefixes
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class LocateAashray extends StatefulWidget {
  final QueryDocumentSnapshot document;
  const LocateAashray(this.document, {super.key});
  @override
  State<StatefulWidget> createState() {
    return LocateAashrayState(document);
  }
}

class LocateAashrayState extends State<LocateAashray> {
  final QueryDocumentSnapshot document;
  LocateAashrayState(this.document);

  final String googleAPiKey = "AIzaSyDhZIxVTj8be4Qfr8gqP06NPVhNJxVKn6c";

  PolylinePoints polylinePoints = PolylinePoints();

  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};

  late LatLng startLocation;
  late LatLng endLocation;

  double distance = 0.0;

  final double _zoom = 16.5;

  final Completer<GoogleMapController> _controller = Completer();

  int _current = 0;
  final CarouselController _controllerCarousel = CarouselController();

  @override
  void initState() {
    getLocationAndAdd();
    super.initState();
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {}).onError(
      (error, stackTrace) async {
        await Geolocator.requestPermission();
      },
    );
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> imageURLs = document["ImageLists"].toList();

    // body
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text("${document["Name"]}'s Aashray"),
        actions: [
          // settings
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: GestureDetector(
              child: const Tooltip(
                triggerMode: TooltipTriggerMode.longPress,
                message: "Help",
                child: Icon(
                  Icons.help,
                  size: 25.0,
                ),
              ),
              onTap: () {
                Fluttertoast.showToast(
                  msg: "Helping...",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.black87,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: GoogleMap(
                  zoomGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  compassEnabled: true,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(21.1761918, 79.0446728),
                    zoom: 16.0,
                  ),
                  markers: markers,
                  polylines: Set<Polyline>.of(polylines.values),
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  }),
            ),
            SizedBox(
              child: Card(
                elevation: 2.5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Total Distance from your location: ${distance.toStringAsFixed(2)} KM",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "${document["Name"]}'s Aashray is ${distance.toStringAsFixed(2)} KM away from your location.",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: OutlinedButton(
                  onPressed: () {
                    UrlLauncher.launch("tel://+91${document["Mobile"]}");
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      width: 2.0,
                      color: Colors.green,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "\nDetails of Aashray:",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Card(
                color: Colors.grey.shade100,
                // color: Colors.green.shade100,
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
                        itemBuilder:
                            (BuildContext context, int index, int realIndex) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: imageURLs.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () =>
                                _controllerCarousel.animateToPage(entry.key),
                            child: Container(
                              width: 8.0,
                              height: 8.0,
                              margin: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 4.0,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black)
                                    .withOpacity(
                                        _current == entry.key ? 0.9 : 0.4),
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
                              document["Address"].toString().toLowerCase(),
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
                          document["Name"] + "'s Aashray\n",
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
                              document["Accomodation"].toString().toLowerCase(),
                          style: const TextStyle(
                            fontSize: 17.5,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 10.0,
                        ),
                        child: Text(
                          // ignore: prefer_interpolation_to_compose_strings
                          "Max. Accomodation:\t" +
                              document["Maximum Accomodation"]
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
                              document["Max Period"].toString().toLowerCase(),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.hotel_outlined),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                document["Rooms"] +
                                    " Room(s) with " +
                                    document["Beds"] +
                                    " Bed(s)",
                                style: const TextStyle(
                                  fontSize: 17.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      )
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Please follow the terms and conditions before reaching to any of the Aashray mentioned.",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: OutlinedButton(
                  onPressed: () async {
                    String googleUrl =
                        "https://www.google.com/maps/search/?api=1&query=${endLocation.latitude},${endLocation.longitude}";
                    if (await UrlLauncher.canLaunch(googleUrl)) {
                      await UrlLauncher.launch(googleUrl);
                    } else {
                      throw 'Could not open the map.';
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      width: 2.0,
                      color: Colors.green,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.location_on,
                          size: 30.0,
                          color: Colors.green,
                        ),
                        Text(
                          "\t\tLocate on Google Map",
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
            const SizedBox(
              height: 25.0,
            ),
          ],
        ),
      ),
    );
  }

  void getLocationAndAdd() {
    getUserCurrentLocation().then(
      (value) async {
        CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude),
          zoom: _zoom,
        );

        final GoogleMapController controller = await _controller.future;
        controller
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        setState(() {
          double lat = document["CoordinatesLat"];
          double long = document["CoordinatesLong"];

          endLocation = LatLng(lat, long);
          startLocation = LatLng(value.latitude, value.longitude);
        });

        markers.add(Marker(
          markerId: MarkerId(startLocation.toString()),
          position: startLocation,
          infoWindow: const InfoWindow(
            title: "Your Location",
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));

        markers.add(Marker(
          markerId: MarkerId(endLocation.toString()),
          position: endLocation,
          infoWindow: InfoWindow(
            title: "${document["Name"]}'s Aashray",
            snippet: "Destination",
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));

        getDirections();
      },
    );
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
      // travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates = [];
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
    } else {
      print("Error:  ${result.errorMessage}");
    }

    double totalDistance = 0;
    for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude);
    }
    print(totalDistance);

    setState(() {
      distance = totalDistance;
    });

    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId(polylineCoordinates.toString());
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.green,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
