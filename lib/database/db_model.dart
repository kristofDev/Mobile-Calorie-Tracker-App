import 'package:calorie_counter/database/daily_intake_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'food_model.dart';

class DatabaseConnect {
  // ignore: unused_field
  Database? _database;

  Future<Database> get database async {
    final dbpath = await getDatabasesPath();
    const dbname = 'calorie_counter3.db';

    final path = join(dbpath, dbname);

    _database = await openDatabase(path, version: 1, onCreate: _createDB);
    return _database!;
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE food_calories(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      foodTitle TEXT NOT NULL,
      calories INT NOT NULL,
      protein INT,
      fat INT, 
      carbohydrates INT
    );
    ''');
    await db.execute('''
    CREATE TABLE daily_intake(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      date TEXT NOT NULL,
      calorieIntake INTEGER NOT NULL,
      calorieGoalThatDay INTEGER NOT NULL,
      description TEXT 
    );
    ''');
  }
  //TODO implement everything so it works with protein, fat, carbohydrates + description

  //-----------------------------------------------------------------------------
  // FoodCalories
  Future<void> insertNewFood(FoodCalories food) async {
    // this is calling first "function" here not the variable _database
    final db = await database;
    await db.insert(
      'food_calories',
      food.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteFood(FoodCalories food) async {
    final db = await database;
    await db.delete(
      'food_calories',
      where: 'id == ?',
      whereArgs: [food.id],
    );
  }

  // fetching one of the foods data from database
  Future<List<FoodCalories>> getFood(String nameOfTheFood) async {
    final db = await database;

    List<Map<String, dynamic>> result = await db.query(
      'food_calories',
      where: 'foodTitle == ?',
      whereArgs: [nameOfTheFood],
      limit: 1, // if I want strictly just one I could use this
    );

    // print('TEST DATABASE CALORIES: $result');

    return List.generate(
      result.length,
      (index) => FoodCalories(
        id: result[index]['id'],
        foodTitle: result[index]['foodTitle'],
        calories: result[index]['calories'],
      ),
    );
  }

  Future<List<FoodCalories>> getAllFood() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'food_calories',
      orderBy: 'id DESC',
    );

    return List.generate(
      result.length,
      (index) => FoodCalories(
        id: result[index]['id'],
        foodTitle: result[index]['foodTitle'],
        calories: result[index]['calories'],
      ),
    );
  }

  //-----------------------------------------------------------------------------
  //DailyIntake
  Future<void> insertDailyIntake(DailyIntake intake) async {
    final db = await database;
    await db.insert(
      'daily_intake',
      intake.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteDailyIntake(DailyIntake intake) async {
    final db = await database;
    await db.delete(
      'daily_intake',
      where: 'id == ?',
      whereArgs: [intake.id],
    );
  }

  Future<List<DailyIntake>> getDailyIntake() async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'daily_intake',
      orderBy: 'id DESC',
    );

    return List.generate(
      result.length,
      (index) => DailyIntake(
        id: result[index]['id'],
        date: DateTime.parse(result[index]['date']),
        calorieIntake: result[index]['calorieIntake'],
        calorieGoalThatDay: result[index]['calorieGoalThatDay'],
        description: result[index]['description'],
      ),
    );
  }
}
