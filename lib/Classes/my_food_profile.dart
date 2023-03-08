// ignore_for_file: use_build_context_synchronously

import 'package:aashray/Classes/provide_aashray/provide_aashray_one.dart';
import 'package:aashray/Classes/provide_food/provide_food_one.dart';
import 'package:aashray/splashscreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyFoodProfile extends StatefulWidget {
  const MyFoodProfile({super.key});

  @override
  State<MyFoodProfile> createState() => _MyFoodProfileState();
}

class _MyFoodProfileState extends State<MyFoodProfile> {
  final User? user = FirebaseAuth.instance.currentUser;
  // uid
  late String _userId;

  int _current = 0;
  final CarouselController _controllerCarousel = CarouselController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _userId = user!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Food Providers")
              .where("userID", isEqualTo: _userId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: Colors.green,
                ),
              );
            } else if (snapshot.data?.size == 0) {
              return const Center(
                  child: Text("No Food provider details found!"));
            } else {
              return ListView(
                shrinkWrap: true,
                primary: false,
                children: snapshot.data!.docs.map(
                  (documents) {
                    // final List<dynamic> imageURLs =
                    //     documents["ImageLists"].toList();

                    return Card(
                      color: Colors.grey.shade100,
                      elevation: 3.0,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // CarouselSlider.builder(
                            //   options: CarouselOptions(
                            //     height: 180.0,
                            //     disableCenter: true,
                            //     autoPlayInterval: const Duration(
                            //       seconds: 3,
                            //     ),
                            //     viewportFraction: 1.0,
                            //     autoPlay: true,
                            //     enableInfiniteScroll: false,
                            //     onPageChanged: (index, reason) {
                            //       setState(
                            //         () {
                            //           _current = index;
                            //         },
                            //       );
                            //     },
                            //   ),
                            //   itemCount: imageURLs.length,
                            //   itemBuilder: (BuildContext context, int index,
                            //       int realIndex) {
                            //     return Builder(
                            //       builder: (BuildContext context) {
                            //         return Container(
                            //           decoration: const BoxDecoration(
                            //             color: Colors.green,
                            //           ),
                            //           child: Padding(
                            //             padding: const EdgeInsets.all(2.0),
                            //             child: Image.network(
                            //               imageURLs[index],
                            //               fit: BoxFit.cover,
                            //             ),
                            //           ),
                            //         );
                            //       },
                            //     );
                            //   },
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: imageURLs.asMap().entries.map((entry) {
                            //     return GestureDetector(
                            //       onTap: () => _controllerCarousel
                            //           .animateToPage(entry.key),
                            //       child: Container(
                            //         width: 8.0,
                            //         height: 8.0,
                            //         margin: const EdgeInsets.symmetric(
                            //             vertical: 8.0, horizontal: 4.0),
                            //         decoration: BoxDecoration(
                            //           shape: BoxShape.circle,
                            //           color: (Theme.of(context).brightness ==
                            //                       Brightness.dark
                            //                   ? Colors.white
                            //                   : Colors.black)
                            //               .withOpacity(
                            //             _current == entry.key ? 0.9 : 0.4,
                            //           ),
                            //         ),
                            //       ),
                            //     );
                            //   }).toList(),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //     top: 8.0,
                            //   ),
                            //   child: Text(
                            //     // ignore: prefer_interpolation_to_compose_strings
                            //     "Address: " +
                            //         documents["Address"]
                            //             .toString()
                            //             .toLowerCase(),
                            //     style: const TextStyle(
                            //       fontSize: 17.5,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            // ),
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
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //     top: 8.0,
                            //   ),
                            //   child: Text(
                            //     // ignore: prefer_interpolation_to_compose_strings
                            //     "Preference: " +
                            //         documents["Accomodation"]
                            //             .toString()
                            //             .toLowerCase(),
                            //     style: const TextStyle(
                            //       fontSize: 17.5,
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //     top: 8.0,
                            //   ),
                            //   child: Text(
                            //     // ignore: prefer_interpolation_to_compose_strings
                            //     "Max. Accomodation:\t" +
                            //         documents["Maximum Accomodation"]
                            //             .toString()
                            //             .toLowerCase(),
                            //     style: const TextStyle(
                            //       fontSize: 17.5,
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //     top: 8.0,
                            //   ),
                            //   child: Text(
                            //     // ignore: prefer_interpolation_to_compose_strings
                            //     "Availability:\t" +
                            //         documents["Max Period"]
                            //             .toString()
                            //             .toLowerCase(),
                            //     style: const TextStyle(
                            //       fontSize: 17.5,
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //     top: 8.0,
                            //   ),
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.center,
                            //     children: [
                            //       const Icon(Icons.hotel_outlined),
                            //       Padding(
                            //         padding: const EdgeInsets.only(left: 8.0),
                            //         child: Text(
                            //           documents["Rooms"] +
                            //               " Room(s) with " +
                            //               documents["Beds"] +
                            //               " Bed(s)",
                            //           style: const TextStyle(
                            //             fontSize: 17.5,
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 28.0,
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
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                  left: 10.0,
                                  right: 10.0,
                                ),
                                child: OutlinedButton(
                                  onPressed: () => deleteAashray(),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      width: 2.0,
                                      color: Colors.red,
                                    ),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Text(
                                      "Delete Food Profile",
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
              // }  else {
              //   return const Center(child: Text("No Data Found!"));
            }
          },
        ),
      ),
    );
  }

  deleteAashray() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Your food profile?"),
          content: const Text("Confirm deleting the Profile."),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  width: 2.0,
                  color: Colors.green,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                var docRef = FirebaseFirestore.instance
                    .collection("Food Providers")
                    .doc(_userId);

                docRef.delete().whenComplete(
                  () async {
                    final sharedPrefs = await SharedPreferences.getInstance();
                    await sharedPrefs.setString("screenName", "AashrayDefault");

                    Navigator.pop(context);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        // Main
                        builder: (context) => const Splashscreen(),
                      ),
                    );
                  },
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  width: 2.0,
                  color: Colors.red,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
