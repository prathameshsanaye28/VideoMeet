import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/breakpoint.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:videosdk_flutter_example/firebase_options.dart';
import 'package:videosdk_flutter_example/resources/user_provider.dart';
import 'package:window_manager/window_manager.dart';

import 'constants/colors.dart';
import 'navigator_key.dart';
import 'screens/common/splash_screen.dart';

void main() async {
  // Run Flutter App
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows)) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(900, 700),
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    windowManager.setResizable(false);
    windowManager.setMaximizable(false);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Material App
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
        title: 'VideoMeet',
        theme: ThemeData.dark().copyWith(
          appBarTheme: const AppBarTheme().copyWith(
            color: primaryColor,
          ),
          primaryColor: primaryColor,
          scaffoldBackgroundColor: secondaryColor,
        ),
        home: const SplashScreen(),
        navigatorKey: navigatorKey,
      ),
    );
  }
}
