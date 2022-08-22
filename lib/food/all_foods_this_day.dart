import 'package:flutter/material.dart';
import 'package:calorie_counter/database/food_model.dart';
import 'package:calorie_counter/calorie_goal/foods_today.dart';
import 'package:provider/provider.dart';
import '../calorie_goal/calories_goal.dart';

//TODO make it pretty
class FoodEatenCard extends StatefulWidget {
  final int id;
  final String foodTitle;
  final int calories;
  final Function deleteFunction;

  const FoodEatenCard({
    required this.id,
    required this.calories,
    required this.foodTitle,
    required this.deleteFunction,
    Key? key,
  }) : super(key: key);

  @override
  State<FoodEatenCard> createState() => _FoodEatenCardState();
}

class _FoodEatenCardState extends State<FoodEatenCard> {
  @override
  Widget build(BuildContext context) {
    // final tmpFood = Food;
    return Row(
      children: [
        Text(widget.foodTitle),
        const SizedBox(width: 10),
        Text('kcal: ${widget.calories}'),
        IconButton(
          onPressed: () {
            // widget.deleteFunction(widget.foodTitle, widget.id);
            widget.deleteFunction(widget.id);
          },
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }
}

//------------------------------------------------------------------------------
//ListView of all foods this day
class FoodsTodayList extends StatefulWidget {
  final Function deleteFunction;

  const FoodsTodayList({required this.deleteFunction, Key? key})
      : super(key: key);

  @override
  State<FoodsTodayList> createState() => _FoodsTodayListState();
}

class _FoodsTodayListState extends State<FoodsTodayList> {
  Future<List<FoodCaloriesEaten>> getFoodFromToday() async {
    List<Map<String, dynamic>> foods = [];
    final foodToday = await TodayFoods.getTodaysFoods();

    for (int i = 0; i < foodToday.length; i += 3) {
      Map<String, dynamic> tmpMap = {
        'id': foodToday[i],
        'foodTitle': foodToday[i + 1],
        'calories': foodToday[i + 2]
      };
      // print(tmpMap);
      foods.add(tmpMap);
    }
    // print(foods);

    return List.generate(
      foods.length,
      (index) => FoodCaloriesEaten(
        id: int.parse(foods[index]['id']),
        calories: int.parse(foods[index]['calories']),
        foodTitle: foods[index]['foodTitle'],
      ),
    );
  }

  int caloriesToDelete = 0;

  void setCaloriesForDelete(int foodId) async {
    caloriesToDelete = await TodayFoods.getCaloriesFromFood(foodId);
  }

  void deleteFoodForToday(int idFood) {
    setCaloriesForDelete(idFood);

    TodayFoods.deleteTodayFood(idFood);

    Provider.of<CaloriesGoalProvider>(context, listen: false)
        .removeCaloriesConsumed(caloriesToDelete);

    setState(() {}); //is that needed?
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50.0, right: 50),
      child: SizedBox(
        height: 150,
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          decoration:
              const BoxDecoration(color: Color.fromARGB(31, 140, 132, 132)),
          child: FutureBuilder(
            future: getFoodFromToday(),
            initialData: const [],
            builder: ((context, snapshot) {
              var data = snapshot.data;
              var dataLenght = data!.length;

              return dataLenght == 0
                  ? const Center(
                      child: Text('no food entries'),
                    )
                  : ListView.builder(
                      itemCount: dataLenght,
                      itemBuilder: (context, index) => FoodEatenCard(
                        id: data[index].id,
                        calories: data[index].calories,
                        foodTitle: data[index].foodTitle,
                        deleteFunction: deleteFoodForToday,
                      ),
                    );
            }),
          ),
        ),
      ),
    );
  }
}
