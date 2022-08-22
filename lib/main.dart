import 'package:calorie_counter/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'calorie_goal/calories_goal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      //for working with provider
      providers: [
        ChangeNotifierProvider(create: (_) => CaloriesGoalProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //true for now
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromARGB(255, 52, 57, 62),
        textTheme: const TextTheme(),
      ),
      home: const HomeScreenPage(),
    );
  }
}
