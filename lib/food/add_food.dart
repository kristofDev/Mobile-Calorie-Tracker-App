import 'package:flutter/material.dart';
import 'package:calorie_counter/database/food_model.dart';

class AddFood extends StatelessWidget {
  final Function insertFoodFunction;
  AddFood({Key? key, required this.insertFoodFunction}) : super(key: key);

  // do controller need to be final?
  final foodTitleController = TextEditingController();
  final foodCaloriesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        insetPadding: const EdgeInsets.fromLTRB(50, 100, 50, 10),
        title: const Text('Add Food'),
        content: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            TextField(
              controller: foodTitleController,
              decoration:
                  const InputDecoration.collapsed(hintText: 'Food name'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: foodCaloriesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration.collapsed(
                  hintText: 'Calories in the food'),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 120),
              padding: const EdgeInsets.all(10),
              color: Colors.orange[700],
              child: GestureDetector(
                onTap: () {
                  var newFood = FoodCalories(
                    foodTitle: foodTitleController.text,
                    calories: int.parse(foodCaloriesController.text),
                  );
                  insertFoodFunction(newFood);
                  Navigator.pop(context);
                },
                child: const Text('SUBMIT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
