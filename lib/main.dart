import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:music_project/Controller/bottomNavigation_Controller.dart';
import 'package:music_project/widgets/FavoriteListing.dart';
import 'package:music_project/widgets/home.dart';
import 'package:music_project/widgets/miniPlayer.dart';
import 'package:music_project/widgets/playlist.dart';
import 'package:music_project/widgets/settings.dart';
import 'package:music_project/widgets/splash_Screen.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:get/get.dart';

int selectedIndex = 0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await GetStorage.init;
  OnAudioRoom().initRoom();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: "/SplashScreen",
      getPages: [
        GetPage(name: "/SplashScreen", page: () => SplashScreen()),
        GetPage(name: "/Home", page: () => Home()),
        GetPage(name: "/Playlist", page: () => Playlist()),
        GetPage(name: "/Settings", page: () => Settings()),
        GetPage(name: "/Favorites", page: () => Favorite()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}

// Home page

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  BottomController controller = Get.put(BottomController());
  static const List<Widget> _widgetOptions = <Widget>[
    HomeView(),
    Playlist(),
    Settings(),
  ];

  _onItemTapped(int index) {
    controller.changeTabIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomController>(
      builder: (controller) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: 30,
                  ),
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.playlist_play_rounded,
                    size: 30,
                  ),
                  label: "Playlist"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings,
                    size: 30,
                  ),
                  label: "Settings")
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            iconSize: 30,
            onTap: _onItemTapped,
            elevation: 0,
            backgroundColor: Colors.black,
            showSelectedLabels: true,
            selectedIconTheme: IconThemeData(size: 40),
          ),
          body: Column(
            children: [
              Expanded(child: _widgetOptions.elementAt(selectedIndex)),
              BottomPlaying(),
            ],
          ),
        );
      },
    );
  }
}
