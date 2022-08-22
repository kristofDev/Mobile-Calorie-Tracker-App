import 'package:calorie_counter/database/daily_intake_model.dart';
import 'package:calorie_counter/database/db_model.dart';
import 'package:calorie_counter/database/food_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../calorie_goal/calories_goal.dart';
import 'all_daily_intakes.dart';
import 'package:calorie_counter/homescreen.dart';
import 'package:dropdown_search/dropdown_search.dart'; //testing => THIS ONE FOR NOW
import 'all_foods_this_day.dart';
import 'package:calorie_counter/calorie_goal/foods_today.dart';

//TODO make it better looking
//TODO make some sort of a calculator that calculates how much you ate that depends on parameters of which food and quantities of it
//TODO implement counter for macronutrients (fat, carbohydrates and protein)

//adding meal and calories to the day
class AddMeal extends StatefulWidget {
  final Function getMealToAdd;
  const AddMeal({required this.getMealToAdd, Key? key}) : super(key: key);

  @override
  State<AddMeal> createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {
  final db = DatabaseConnect();
  String foodNameDropdown =
      ""; //give them deafult values so there is no problems with null
  int? goalThisDay;
  int? caloriesThisDay;
  List<String> foodOptions = [];

  Future<int> getCaloriesFromFood(String nameOfTheFood) async {
    List<FoodCalories> tmp = await db.getFood(nameOfTheFood);
    return tmp[0].calories!;
  }

  //DAILY_INTAKE FUNCTIONS:
  void deleteIntakeDaily(DailyIntake intake) async {
    await db.deleteDailyIntake(intake);
    setState(() {});
  }

  void addNewDailyIntake(DailyIntake intake) async {
    await db.insertDailyIntake(intake);
    setState(() {});
  }

  //DROPDOWN FUNCTIONS:
  Future<List<String>> getDropDownOptions() async {
    final result = await db.getAllFood();

    return List.generate(
      result.length,
      (index) => result[index].foodTitle!,
    );
  }

  Future<void> setDropDown() async {
    foodOptions = await getDropDownOptions();
    print("TEST FOOD OPTIONS : $foodOptions");
  }

  void deleteFoodEaten(String foodName) async {
    var foodFromToday = await TodayFoods.getTodaysFoods();

    int index = foodFromToday.indexOf('foodName');
    foodFromToday.removeAt(index);
    foodFromToday.removeAt(index + 1);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setDropDown();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // setDropDown();
    int caloriesThisDay =
        Provider.of<CaloriesGoalProvider>(context).getCaloriesConsumed;
    int goalThisDay =
        Provider.of<CaloriesGoalProvider>(context).getCaloriesGoal;
    // print('test caloriesthisday : $caloriesThisDay');
    // print('goalThisday : $goalThisDay');
    return Scaffold(
      appBar: defaultAppBar(),
      body: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          //DEAlLT WITH: deal with null issue: "null check operator used on a null value. => I gave some variables some default values
          //--------------DROPDOWN----------------------
          //TODO sometimes dropdown content doesn't show, maybe foodOptions don't load or something
          DropdownSearch<String>(
            popupProps: const PopupProps.menu(
              showSelectedItems: true,
              showSearchBox: true,
            ),
            items: foodOptions,
            //TODO try to use asyncItems instead (maybe it will work better)
            onChanged: (value) {
              foodNameDropdown = value!;
              // print('test value: $foodNameDropdown');
            },
            enabled: true,
          ),
          //------------------------INSERT BUTTON-------------------------------
          Container(
            margin: const EdgeInsets.only(left: 240),
            child: ElevatedButton(
              onPressed: () async {
                int tmpCalories = await getCaloriesFromFood(foodNameDropdown);
                TodayFoods.addTodayFood(foodNameDropdown);
                final foods = await TodayFoods.getTodaysFoods();
                //TEST
                print("TEST INSERT: $foods}");
                setState(
                  () {
                    Provider.of<CaloriesGoalProvider>(context, listen: false)
                        .addCaloriesConsumed(tmpCalories);
                    CaloriesGoal.addCaloriesConsumedToday(tmpCalories);
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                primary: const Color.fromARGB(255, 142, 112, 52),
              ),
              child: const Text('INSERT'),
            ),
          ),
          //----------------------LIST OF EATEN FOODS---------------------------
          FoodsTodayList(deleteFunction: deleteFoodEaten),
          //----------------------END THE DAY BUTTON----------------------------
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: const SizedBox(
              height: 70,
              child: EndTheDayButton(),
            ),
          ),
          //------------------ALL DAILY INTAKES BUTTON--------------------------
          Padding(
            padding: const EdgeInsets.only(left: 50.0, right: 50),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DailyIntakesList(
                      deleteFunction: deleteIntakeDaily,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 117, 151, 155),
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
              child: const Text('All Daily Intakes'),
            ),
          ),
        ],
      ),
    );
  }
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//End The Day
class EndTheDayButton extends StatefulWidget {
  const EndTheDayButton({Key? key}) : super(key: key);

  @override
  State<EndTheDayButton> createState() => _EndTheDayButtonState();
}

class _EndTheDayButtonState extends State<EndTheDayButton> {
  final db = DatabaseConnect();
  //for food description
  String foodFromToday = '';

  void setFoodFromToday() async {
    final foods = await TodayFoods.getTodaysFoods();

    foodFromToday = '';
    for (int i = 0; i < foods.length; i += 3) {
      foodFromToday = 'Food: ${foods[i + 1]}, kcal: ${foods[i + 2]}';
      // print('test $foodFromToday');
    }
  }

  void addNewDailyIntake(DailyIntake intake) async {
    await db.insertDailyIntake(intake);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    setFoodFromToday();
    int caloriesThisDay1 =
        Provider.of<CaloriesGoalProvider>(context).getCaloriesConsumed;
    int goalThisDay1 =
        Provider.of<CaloriesGoalProvider>(context).getCaloriesGoal;

    return ElevatedButton(
      onPressed: () {
        setFoodFromToday();

        var tmpDailyIntake = DailyIntake(
          date: DateTime.now(),
          calorieIntake: caloriesThisDay1,
          calorieGoalThatDay: goalThisDay1,
          description: foodFromToday,
        );
        addNewDailyIntake(tmpDailyIntake);

        CaloriesGoal.updateCaloriesConsumedOnNull();
        Provider.of<CaloriesGoalProvider>(context, listen: false)
            .updateCalorieConsumedOnNull();
        TodayFoods.clearAllTodayFood();
      },
      style: ElevatedButton.styleFrom(
        // primary: const Color.fromARGB(255, 119, 136, 104),
        primary: const Color.fromARGB(255, 142, 112, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: const Text(
        'End The Day',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 237, 234, 227),
        ),
      ),
    );
  }
}
