import 'package:app_notes/Pages/Home.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splashscreen/splashscreen.dart';

import 'controllers/theme_controller.dart';

void main() {
  Get.lazyPut<ThemeController>(() => ThemeController());
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeController.to.loadThemeMode();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
      theme: ThemeData(
        primaryColor: Color(0xff028090),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Color(0xffedffec),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xff00204a),
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: Brightness.dark,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xff53435b),
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Color(0xff151515),
        dividerColor: Colors.black45,
        accentColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: ThemeMode.system,
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: HomePage(),
      title: Text(
        'Bem Vindo ao App Notes',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontStyle: FontStyle.italic,
        ),
      ),
      backgroundColor: Color(0xff2E2A36),
      loaderColor: Colors.white,
    );
  }
}
