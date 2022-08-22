class FoodCalories {
  int? id;
  String? foodTitle;
  int? calories;

  FoodCalories({this.id, this.foodTitle, this.calories});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'foodTitle': foodTitle,
      'calories': calories,
    };
  }

  // for debugging
  @override
  String toString() {
    return 'FOOD $foodTitle, id $id, calories: $calories';
  }
}

//-----for FoodEatenCard-----------
class FoodCaloriesEaten {
  int? id;
  String? foodTitle;
  int? calories;

  FoodCaloriesEaten({this.id, this.foodTitle, this.calories});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'foodTitle': foodTitle,
      'calories': calories,
    };
  }

  // for debugging
  @override
  String toString() {
    return 'FOOD $foodTitle, id $id, calories: $calories';
  }
}
