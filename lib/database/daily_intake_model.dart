class DailyIntake {
  int? id;
  DateTime? date;
  int? calorieIntake;
  int? calorieGoalThatDay;
  String? description;

  DailyIntake({
    this.id,
    this.date,
    this.calorieIntake,
    this.calorieGoalThatDay,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toString(),
      'calorieIntake': calorieIntake,
      'calorieGoalThatDay': calorieGoalThatDay,
      'description': description,
    };
  }

  int getCalorieIntake() {
    return calorieIntake!;
  }

  int getCalorieGoal() {
    return calorieGoalThatDay!;
  }

  String getDescription() {
    return description!;
  }
}
