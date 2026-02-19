import 'package:flutter/material.dart';
import 'package:plc_controller/src/rust/frb_generated.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  runApp(const PlcControllerApp());
}

class PlcControllerApp extends StatelessWidget {
  const PlcControllerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PLC Controller',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00BFA5),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          elevation: 2,
          centerTitle: true,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}