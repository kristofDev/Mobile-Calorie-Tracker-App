import 'package:flutter/material.dart';
import 'package:calorie_counter/database/daily_intake_model.dart';
import 'package:calorie_counter/database/db_model.dart';

class DailyIntakesList extends StatelessWidget {
  final db = DatabaseConnect();

  final Function deleteFunction;
  DailyIntakesList({required this.deleteFunction, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(31, 140, 61, 61),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: db.getDailyIntake(),
              initialData: const [],
              builder: (context, snapshot) {
                var data = snapshot.data;
                var dataLenght = data!.length;

                return dataLenght == 0
                    ? const Center(
                        child: Text('No daily entries'),
                      )
                    : ListView.builder(
                        itemCount: dataLenght,
                        itemBuilder: (context, index) => DailyIntakeCard(
                          id: data[index].id,
                          date: data[index].date,
                          caloriesIntake: data[index].calorieIntake,
                          calorieGoalThatDay: data[index].calorieGoalThatDay,
                          description: data[index].description,
                          deleteFunction: deleteFunction,
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}

//******************************************************************************
class DailyIntakeCard extends StatefulWidget {
  final int id;
  final DateTime date;
  final int caloriesIntake;
  final int calorieGoalThatDay;
  final String description;
  final Function deleteFunction;

  const DailyIntakeCard({
    required this.id,
    required this.date,
    required this.caloriesIntake,
    required this.calorieGoalThatDay,
    required this.description,
    required this.deleteFunction,
    Key? key,
  }) : super(key: key);

  @override
  State<DailyIntakeCard> createState() => _DailyIntakeCardState();
}

class _DailyIntakeCardState extends State<DailyIntakeCard> {
  bool reachedGoal(DailyIntake intake) {
    int goal = intake.getCalorieGoal();
    int consumed = intake.getCalorieIntake();
    bool calorieGoalReached = goal == consumed ||
        (consumed > (goal - goal * 0.05) && consumed < (goal + goal * 0.05));

    if (calorieGoalReached) {
      return true;
    }
    return false;
  }

  bool isIntakeVeryWrong(DailyIntake intake) {
    int goal = intake.getCalorieGoal();
    int consumed = intake.getCalorieIntake();

    bool intakeVeryWrong =
        consumed < (goal - goal * 0.15) || consumed > (goal + goal * 0.15);
    if (intakeVeryWrong) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final anotherDailyIntake = DailyIntake(
      id: widget.id,
      date: widget.date,
      calorieIntake: widget.caloriesIntake,
      calorieGoalThatDay: widget.calorieGoalThatDay,
      description: widget.description,
    );

    Color? containerColor;
    if (reachedGoal(anotherDailyIntake)) {
      containerColor = Colors.green[400];
    } else if (isIntakeVeryWrong(anotherDailyIntake)) {
      containerColor = Colors.red[600];
    } else {
      containerColor = Colors.red[200];
    }

    return Container(
      color: containerColor,
      child: Column(
        children: [
          Text(
            widget.date.toString(),
          ),
          const SizedBox(height: 10),
          Text('calorie intake that day: ${widget.caloriesIntake}'),
          const SizedBox(height: 10),
          Text('CALORIE GOAL THAT DAY : ${widget.calorieGoalThatDay}'),
          Text('Eaten: ${widget.description}'),
          IconButton(
            onPressed: () {
              widget.deleteFunction(anotherDailyIntake);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
