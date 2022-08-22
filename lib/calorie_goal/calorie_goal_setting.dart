import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calories_goal.dart';
import 'package:provider/provider.dart';

//STATUS: finished for now
//...............................................................................
class CalorieGoalSetting extends StatefulWidget {
  const CalorieGoalSetting({super.key});

  @override
  State<CalorieGoalSetting> createState() => _CalorieGoalSettingState();
}

class _CalorieGoalSettingState extends State<CalorieGoalSetting> {
  var dailyCalorieGoal = TextEditingController();
  int? caloriesDailyGoal;
  bool goalExists = false;
  int? caloriesConsumedToday;

  void loadPreferences() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      caloriesDailyGoal = pref.getInt('calorieGoal') ?? 0; // if null returns 0
      goalExists = pref.getBool('goalExists') ?? false;
      caloriesConsumedToday = pref.getInt('caloriesConsumed') ?? 0;
    });
  }

  @override
  void initState() {
    loadPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: AlertDialog(
          title: const Text('Set The Goal'),
          content: Column(
            children: [
              const SizedBox(height: 20.0),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: TextField(
                  controller: dailyCalorieGoal,
                  keyboardType: TextInputType.number,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    caloriesDailyGoal = int.parse(dailyCalorieGoal.text);
                    goalExists = true;
                  });
                  Provider.of<CaloriesGoalProvider>(context, listen: false)
                      .setCalorieGoal(caloriesDailyGoal!);
                  CaloriesGoal.setCalorieGoal(
                      caloriesDailyGoal!); //for shared_preferences
                  Navigator.pop(context);
                },
                child: const Text('SET GOAL'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
