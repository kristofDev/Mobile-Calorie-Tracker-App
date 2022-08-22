import 'package:calorie_counter/food/add_food.dart';
import 'package:calorie_counter/food/all_food.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calorie_goal/calories_goal.dart';
import 'package:provider/provider.dart';
import 'calorie_goal/calorie_goal_setting.dart';
import 'package:calorie_counter/database/db_model.dart';
import 'database/food_model.dart';
import 'food/add_meal.dart';

//******************************************************************************
class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({Key? key}) : super(key: key);

  @override
  State<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  //connecting to database
  final db = DatabaseConnect();
  //for navigation bar
  int _indexNavigation = 0;

  int caloriesDailyGoal = 0;
  bool goalExists = false;
  int caloriesConsumedToday = 0;

  @override
  void initState() {
    loadSharedPref();
    super.initState();
  }

  void loadSharedPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      caloriesDailyGoal =
          pref.getInt('calorieGoal') ?? 0; // if null => returns 0
      goalExists = pref.getBool('goalExists') ?? false;
      caloriesConsumedToday = pref.getInt('caloriesConsumedToday') ?? 0;
    });
  }

  // //FUNCTIONS FOR DATABASE:
  void addNewFood(FoodCalories newFood) async {
    await db.insertNewFood(newFood);
    setState(() {});
  }

  void deleteFoodEntry(FoodCalories food) async {
    await db.deleteFood(food);
    setState(() {});
  }

  Future<List<FoodCalories>> getMealFromDatabase(String foodName) async {
    List<FoodCalories> food = await db.getFood(foodName);
    return food;
  }

  @override
  Widget build(BuildContext context) {
//------------------------------------------------------------------------------
    List<Widget> pages = [
      const HomeScreen(),
      AllFoodEntries(
        addFoodFunction: addNewFood,
        deleteFoodFunction: deleteFoodEntry,
      ),
      AddMeal(getMealToAdd: getMealFromDatabase),
    ];
//------------------------------------------------------------------------------
    return Scaffold(
      body: Center(
        child: pages[_indexNavigation],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indexNavigation,
        onDestinationSelected: (int newIndex) {
          setState(
            () {
              _indexNavigation = newIndex;
            },
          );
        },
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_max_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.apps),
            icon: Icon(Icons.apps_outlined),
            label: 'All Food Entries',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.add_circle),
            icon: Icon(Icons.add_circle_outlined),
            label: 'Add Daily Meal',
          ),
        ],
      ),
    );
  }
}

//******************************************************************************
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //connecting to database
  final db = DatabaseConnect();

  int caloriesDailyGoal = 0;
  bool goalExists = false;
  int caloriesConsumedToday = 0;

  @override
  void initState() {
    loadSharedPref();
    // loadProvider();
    super.initState();
  }

  void loadSharedPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      caloriesDailyGoal =
          pref.getInt('calorieGoal') ?? 0; // if null => returns 0
      goalExists = pref.getBool('goalExists') ?? false;
      caloriesConsumedToday = pref.getInt('caloriesConsumedToday') ?? 0;
    });
  }

  //FUNCTIONS FOR DATABASE:
  void addNewFood(FoodCalories newFood) async {
    await db.insertNewFood(newFood);
    setState(() {});
  }

  //FUNCTION FOR DIALOG
  Future openDialog(Widget open) => showDialog(
        context: context,
        builder: (context) => open,
      );

  @override
  Widget build(BuildContext context) {
    //connecting caloriesDailyGoal and provider value of caloriesGoal
    //TODO try this calling somewhere else
    if (Provider.of<CaloriesGoalProvider>(context).getCaloriesGoal == 0) {
      Provider.of<CaloriesGoalProvider>(context, listen: false)
          .setCalorieGoal(caloriesDailyGoal);
    }
    if (Provider.of<CaloriesGoalProvider>(context).getCaloriesGoal != 0) {
      caloriesDailyGoal =
          Provider.of<CaloriesGoalProvider>(context).getCaloriesGoal;
      // line for goalExists was just added not tested yet
      goalExists = Provider.of<CaloriesGoalProvider>(context).getGoalExists;
    }

    // TODO see it that is even needed:
    Provider.of<CaloriesGoalProvider>(context)
        .addCaloriesConsumed(caloriesConsumedToday);
    return Scaffold(
      appBar: defaultAppBar(),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 70, top: 50, bottom: 50),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    openDialog(const CalorieGoalSetting());
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 82, 81, 76),
                  ),
                  child: const Text('SET CALORIE GOAL'),
                ),
              ),
            ),
            //-------------------------------------------------------------------------------------------
            if (Provider.of<CaloriesGoalProvider>(context).getGoalExists)
              //costum widget
              TextAboutCalories(
                  text:
                      'Today\'s calorie goal: ${Provider.of<CaloriesGoalProvider>(context).getCaloriesGoal}'),
            if (goalExists &&
                !Provider.of<CaloriesGoalProvider>(context).getGoalExists)
              TextAboutCalories(
                  text:
                      'Today\'s calorie goal: ${Provider.of<CaloriesGoalProvider>(context).getCaloriesGoal}'),
            if (!Provider.of<CaloriesGoalProvider>(context).getGoalExists &&
                !goalExists)
              const TextAboutCalories(text: 'Calorie goal is not set yet'),
            //-------------------------------------------------------------------------------------------
            TextAboutCalories(
                text: 'Calories consumed today: $caloriesConsumedToday'),
            //------------------------------------------------------------------------------
            Container(
              margin: const EdgeInsets.only(left: 70, top: 40),
              child: ElevatedButton(
                onPressed: () {
                  openDialog(
                    AddFood(insertFoodFunction: addNewFood),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[700],
                ),
                child: const Text('ADDING FOOD'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//******************************************************************************
//Custom widget for texts about calories at the middle of homepage
class TextAboutCalories extends StatelessWidget {
  final String text;
  const TextAboutCalories({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.only(left: 80),
      margin: const EdgeInsets.only(left: 60, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 177, 197, 212),
          // fontFamily: ,
        ),
      ),
    );
  }
}

//******************************************************************************
//Custom appbar
AppBar defaultAppBar() {
  return AppBar(
    title: const Text(
      'Calorie Counter',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    backgroundColor: const Color.fromARGB(255, 33, 33, 33),
  );
}
