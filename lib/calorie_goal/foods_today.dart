import 'package:calorie_counter/calorie_goal/calories_goal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calorie_counter/database/db_model.dart';

class TodayFoods {
  //--------------------INDEX------------------------------------------
  static Future<void> setIndexTodayFoods() async {
    final pref = await SharedPreferences.getInstance();
    int currentIndex = pref.getInt('index_food_from_today') ?? 0;

    // print('index ${pref.getInt('index_food_from_today') ?? 0}');
    pref.setInt('index_food_from_today', currentIndex + 1);
  }

  static Future<int> getIndexTodayFoods() async {
    final pref = await SharedPreferences.getInstance();

    // print('index ${pref.getInt('index_food_from_today') ?? 0}');
    return pref.getInt('index_food_from_today') ?? 0;
  }

  //-------------------------DELETING-------------------------------
  static Future<void> deleteTodayFood(int id) async {
    final pref = await SharedPreferences.getInstance();
    var foods = pref.getStringList('today_foods') ?? [];
    final indexOfFood = foods.indexOf(id.toString());
    //removing id, foodTitle and its calories
    int caloriesOfTheFood = int.parse(foods[indexOfFood + 2]);
    print('caloriesOfTheFood $caloriesOfTheFood');

    foods.removeRange(indexOfFood, indexOfFood + 3);
    pref.setStringList('today_foods', foods);

    CaloriesGoal.removeCaloriesConsumedToday(caloriesOfTheFood);
  }

  static Future<void> clearAllTodayFood() async {
    final pref = await SharedPreferences.getInstance();
    pref.setStringList('today_foods', []);
    pref.setInt('index_food_from_today', 0);
    pref.setInt('caloriesConsumed', 0);
  }

  //------------------TODAY FOODS-----------------------------------
  static Future<List<String>> getTodaysFoods() async {
    final pref = await SharedPreferences.getInstance();
    //for occasions while testing uncomment function bellow:
    //WATCHING THIS IF IT IS UNCOMMENTED IS A PROBLEM!!!!!
    // TodayFoods.clearAllTodayFood();

    return pref.getStringList('today_foods') ?? [];
  }

  static Future<void> addTodayFood(String newFood) async {
    final pref = await SharedPreferences.getInstance();
    final allFood = await TodayFoods.getTodaysFoods();
    final db = DatabaseConnect();

    var tmpFood = await db.getFood(newFood);
    var tmpFoodMap = tmpFood[0].toMap();

    //make it so on the i places is id and on i+1 is foodTitle and on i + 2 are calories
    allFood.add((await TodayFoods.getIndexTodayFoods()).toString());
    TodayFoods.setIndexTodayFoods();
    // int getId = await TodayFoods.getIndexTodayFoods();
    // print('test id $getId');
    allFood.add(tmpFoodMap['foodTitle']);
    allFood.add((tmpFoodMap['calories']).toString());
    pref.setStringList('today_foods', allFood);
  }

  static Future<int> getCaloriesFromFood(int foodId) async {
    final pref = await SharedPreferences.getInstance();
    var foods = pref.getStringList('today_foods') ?? [];
    final indexOfFood = foods.indexOf(foodId.toString());

    // print('GET CALORIES ${foods[indexOfFood + 2]}');
    return int.parse(foods[indexOfFood + 2]);
  }
}
