import 'package:flutter/material.dart';
import '../database/db_model.dart';
import '../database/food_model.dart';
import 'package:calorie_counter/homescreen.dart';

class AllFoodEntries extends StatelessWidget {
  AllFoodEntries({
    required this.addFoodFunction,
    required this.deleteFoodFunction,
    Key? key,
  }) : super(key: key);

  final db = DatabaseConnect();
  final Function addFoodFunction;
  final Function deleteFoodFunction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(),
      body: Container(
        padding: const EdgeInsets.only(left: 30, top: 50, bottom: 50),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 71, 108, 73),
          ),
        ),
        child: Column(
          children: [
            const Text(
              'FOODS',
              style: TextStyle(
                fontSize: 30,
                color: Color.fromARGB(255, 224, 201, 201),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: FutureBuilder(
                future: db.getAllFood(),
                initialData: const [],
                builder: (context, snapshot) {
                  var data = snapshot.data;
                  var dataLenght = data!.length;

                  return dataLenght == 0
                      ? const Center(
                          child: Text('no food entries'),
                        )
                      : ListView.builder(
                          itemCount: dataLenght,
                          itemBuilder: (context, index) => FoodCard(
                            id: data[index].id,
                            foodName: data[index].foodTitle,
                            calories: data[index].calories,
                            insertFunction: addFoodFunction,
                            deleteFunction: deleteFoodFunction,
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//------------------------------------------------------------------------------
class FoodCard extends StatefulWidget {
  final int id;
  final String foodName;
  final int calories;
  final Function insertFunction;
  final Function deleteFunction;

  const FoodCard({
    required this.id,
    required this.foodName,
    required this.calories,
    required this.insertFunction,
    required this.deleteFunction,
    Key? key,
  }) : super(key: key);

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  @override
  Widget build(BuildContext context) {
    final anotherFood = FoodCalories(
      id: widget.id,
      foodTitle: widget.foodName,
      calories: widget.calories,
    );
    return Container(
      color: const Color.fromARGB(255, 90, 78, 36),
      margin: const EdgeInsets.only(bottom: 5, right: 20),
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Row(
        children: [
          Expanded(child: Text(widget.foodName)),
          const Spacer(), //puts next widget to the end
          Text(' CALORIES: ${widget.calories}'),
          IconButton(
            onPressed: () {
              widget.deleteFunction(anotherFood);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
