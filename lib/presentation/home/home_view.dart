import 'package:alertapp_admin/core/styles/color_theme.dart';
import 'package:alertapp_admin/presentation/about_alertapp/about_alertapp_view.dart';
import 'package:alertapp_admin/presentation/map/map_view.dart';
import 'package:alertapp_admin/presentation/notifications/notifications_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    // ignore_for_file: avoid_print
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
  }

  int selectedIndex = 1;

  List<Widget> pages = const [
    NotificationsView(),
    MapView(),
    AboutAlertappView(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Offstage(
            offstage: selectedIndex != 0,
            child: const NotificationsView(),
          ),
          Offstage(
            offstage: selectedIndex != 1,
            child: const MapView(),
          ),
          Offstage(
            offstage: selectedIndex != 2,
            child: const AboutAlertappView(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 20,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Notificaciones"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Mapa"),
          BottomNavigationBarItem(
              icon: Icon(Icons.book), label: "Sobre Alertapp")
        ],
        selectedItemColor: ColorsTheme.redColor,
        unselectedItemColor: ColorsTheme.blackColor,
        onTap: onItemTapped,
        currentIndex: selectedIndex,
      ),
    );
  }
}
