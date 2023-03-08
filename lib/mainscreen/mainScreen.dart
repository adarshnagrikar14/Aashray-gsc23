// ignore_for_file: file_names, no_logic_in_create_state

import 'dart:async';

import 'package:aashray/Classes/dashboard_aashray/dashboard_aashray_default.dart';
import 'package:aashray/Classes/dashboard_aashray/dashboard_aashray_emergency.dart';
import 'package:aashray/Classes/dashboard_aashray/dashboard_aashray_food.dart';
import 'package:aashray/Classes/dashboard_aashray/dashboard_aashray_home.dart';
import 'package:aashray/Classes/my_aashray.dart';
import 'package:aashray/Classes/my_food_profile.dart';
import 'package:aashray/Classes/notifications.dart';
import 'package:aashray/Classes/profile.dart';
import 'package:aashray/Classes/settings.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class MainScreen extends StatefulWidget {
  String screenName;

  MainScreen({super.key, required this.screenName});

  @override
  State<MainScreen> createState() {
    return _MainScreenState(screenName);
  }
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  String screenName = "";
  _MainScreenState(this.screenName);

  @override
  void initState() {
    super.initState();

    // Customisation
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  Future<bool> onBackPress() {
    if (_selectedIndex > 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // list of widgets

    final List<Widget> widgetOptions = <Widget>[
      getDashboard(screenName),
      getDashboardTwo(screenName),
      const Notifications(),
    ];

    // return widget

    return WillPopScope(
      onWillPop: () => onBackPress(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: const Text(
            "Aashray",
            style: TextStyle(
              fontSize: 22.0,
            ),
          ),
          actions: <Widget>[
            // profile
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                child: const Tooltip(
                  triggerMode: TooltipTriggerMode.longPress,
                  message: "Profile",
                  child: Icon(
                    Icons.account_circle_outlined,
                    size: 25.0,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Login
                      builder: (context) => const Profile(),
                    ),
                  );
                },
              ),
            ),

            // settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: GestureDetector(
                child: const Tooltip(
                  triggerMode: TooltipTriggerMode.longPress,
                  message: "Settings",
                  child: Icon(
                    Icons.settings,
                    size: 25.0,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Login
                      builder: (context) => const Settings(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        // Bottom nav bar
        bottomNavigationBar: SizedBox(
          height: 85.0,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: FloatingNavbar(
              onTap: (int val) {
                setState(() {
                  _selectedIndex = val;
                });
              },
              currentIndex: _selectedIndex,
              backgroundColor: Colors.green,
              borderRadius: 10.0,
              itemBorderRadius: 50.0,
              iconSize: 28.0,
              unselectedItemColor: Colors.white,
              selectedItemColor: Colors.black87,
              selectedBackgroundColor: Colors.white,
              items: [
                FloatingNavbarItem(
                  icon: Icons.dashboard_rounded,
                  title: 'Dashboard',
                ),
                getIcon(screenName),
                FloatingNavbarItem(
                  icon: Icons.notifications,
                  title: 'Notification',
                ),
              ],
            ),
          ),
        ),
        body: widgetOptions.elementAt(_selectedIndex),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     final sharedPrefs = await SharedPreferences.getInstance();

        //     List<String> names = [
        //       "AashrayDefault",
        //       "AashrayHome",
        //       "AashrayFood",
        //       "AashrayEmergency"
        //     ];
        //     // String randomItem = (names.toList()..shuffle()).first;

        //     await sharedPrefs.setString(
        //         "screenName", names[Random().nextInt(names.length)]);
        //   },
        //   child: const Icon(
        //     Icons.refresh,
        //   ),
        // ),
      ),
    );
  }

  static getDashboard(String screenName) {
    switch (screenName) {
      case "AashrayDefault":
        return const DashboardDefault();

      case "AashrayHome":
        return const DashboardHome();

      case "AashrayFood":
        return const DashboardFood();

      case "AashrayEmergency":
        return const DashboardEmergency();

      default:
        return const DashboardDefault();
    }
  }

  getIcon(String screenName) {
    switch (screenName) {
      case "AashrayFood":
        return FloatingNavbarItem(
          icon: Icons.food_bank_rounded,
          title: 'Food Provider',
        );

      default:
        return FloatingNavbarItem(
          icon: Icons.home_filled,
          title: 'My Aashray',
        );
    }
  }

  getDashboardTwo(String screenName) {
    switch (screenName) {
      case "AashrayFood":
        return const MyFoodProfile();

      default:
        return const MyAashray();
    }
  }
}
