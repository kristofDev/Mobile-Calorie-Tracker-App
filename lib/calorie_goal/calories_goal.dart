import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart'; //for provider

//STATUS: finished for now
class CaloriesGoal {
  static Future<int> getCalorieGoal() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getInt('calorieGoal') ?? 0;
  }

  static Future<void> setCalorieGoal(int goal) async {
    final pref = await SharedPreferences.getInstance();
    pref.setInt('calorieGoal', goal);
    if (goal > 0) {
      pref.setBool('goalExists', true);
    } else {
      pref.setBool('goalExists', false);
    }
  }

  static Future<void> removeCaloriesConsumedToday(int caloriesToRemove) async {
    final pref = await SharedPreferences.getInstance();
    int caloriesToday = await CaloriesGoal.getCaloriesConsumedToday();
    caloriesToday = caloriesToday - caloriesToRemove;

    pref.setInt('caloriesConsumedToday', caloriesToday);
  }

  static Future<void> addCaloriesConsumedToday(int calories) async {
    final pref = await SharedPreferences.getInstance();
    int caloriesToday = await CaloriesGoal.getCaloriesConsumedToday();
    caloriesToday = caloriesToday + calories;

    pref.setInt('caloriesConsumedToday', caloriesToday);
  }

  static Future<int> getCaloriesConsumedToday() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getInt('caloriesConsumedToday') ?? 0;
  }

  static Future<void> updateCaloriesConsumedOnNull() async {
    //when you end eating for the day set calories consumed on 0 for the next day and save calories consumed for this day somewhere else
    final pref = await SharedPreferences.getInstance();
    pref.setInt('caloriesConsumedToday', 0);
  }
}

class CaloriesGoalProvider extends ChangeNotifier {
  int? caloriesGoal;
  bool? goalExists;
  int? caloriesConsumedThisDay;

  int get getCaloriesGoal => caloriesGoal ?? 0;
  bool get getGoalExists => goalExists ?? false;
  int get getCaloriesConsumed => caloriesConsumedThisDay ?? 0;

  void setCalorieGoal(int newGoal) {
    caloriesGoal = newGoal;
    if (caloriesGoal! > 0) {
      goalExists = true;
    } else {
      goalExists = false;
    }
    notifyListeners();
  }

  void addCaloriesConsumed(int caloriesConsumed) {
    if (caloriesConsumedThisDay != null) {
      caloriesConsumedThisDay = caloriesConsumed + caloriesConsumedThisDay!;
    } else if (caloriesConsumedThisDay == 0 ||
        caloriesConsumedThisDay == null) {
      caloriesConsumedThisDay = caloriesConsumed;
    }
    print('TEST PROVIDER: $caloriesConsumedThisDay');
    notifyListeners();
  }

  void removeCaloriesConsumed(int caloriesToRemove) {
    if (caloriesConsumedThisDay != null) {
      print('calories consumed $caloriesConsumedThisDay');

      caloriesConsumedThisDay = caloriesConsumedThisDay! - caloriesToRemove;
      print('calories consumed $caloriesConsumedThisDay');
    }
    notifyListeners();
  }

  void updateCalorieConsumedOnNull() {
    //when you end eating for the day set calories consumed on 0 for the next day and save calories consumed for this day somewhere else
    caloriesConsumedThisDay = 0;
    notifyListeners();
  }
}
