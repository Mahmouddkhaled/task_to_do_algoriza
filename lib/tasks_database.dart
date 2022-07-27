import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
class TaskDatabase {
  static String _path = "";
  static Database? database ;

  static initializeDatabase ()async{
    var databasePath = await getDatabasesPath();
    _path = join(databasePath , "tasks.db");
    print(_path);
    await openDatabaseConnection();
  }
  static openDatabaseConnection ()async{
    await openDatabase(_path,
    version: 1,
      onCreate: (Database db , int version)async{
      await db.execute("CREATE TABLE Task (id INTEGER PRIMARY KEY , title TEXT , date TEXT ,start_time TEXT, end_time TEXT ,reminder TEXT, isCompleted BOOLEAN , isFavorite BOOLEAN ,repeated TEXT)");
      },

    ).then((value) {
      database = value ;
      print("created");
    }).catchError((error){
      print(error);
    });
  }
  static addTask({required title,required date,required start_time,required end_time,required reminder, required weekly })async{
    await database!.rawInsert("INSERT INTO Task(title, date,start_time, end_time, reminder , isCompleted,isFavorite,repeated ) VALUES (?,?,?,?,?,?,?,?)",
    [title, date,start_time, end_time, reminder, false, false,weekly]
    );
    print("added");
  }
  static deleteTask ()async{
    await database!.rawDelete("DELETE FROM Task WHERE id = ? ",[2]);
    print("delete");
  }
  static completeTask (int id )async{
    int count = await  database!.rawUpdate("UPDATE Task SET isCompleted = ? WHERE id = ?",[true , id]);
  }
  static favoriteTask (int id )async{
    int count = await  database!.rawUpdate("UPDATE Task SET isFavorite = ? WHERE id = ?",[true , id]);
  }
  static unFavoriteTask (int id )async{
    int count = await  database!.rawUpdate("UPDATE Task SET isFavorite = ? WHERE id = ?",[false , id]);
  }
  static getAllTasks ()async{
    List<Map<String , dynamic>> tasks = await database!.rawQuery("SELECT * FROM Task");
    print(tasks);
    return tasks;

  }
  static getAllCompletedTasks ()async{
    List<Map<String , dynamic>> tasks = await database!.rawQuery("SELECT * FROM Task WHERE isCompleted = ?",[1]);
    print(tasks);
    return tasks;

  }
  static getAllUnCompletedTasks ()async{
    List<Map<String , dynamic>> tasks = await database!.rawQuery("SELECT * FROM Task WHERE isCompleted = ?",[0]);
    print(tasks);
    return tasks;

  }
  static getAllFavoriteTasks ()async{
    List<Map<String , dynamic>> tasks = await database!.rawQuery("SELECT * FROM Task WHERE isFavorite = ?",[1]);
    print(tasks);
    return tasks;
  }
  static getAllTasksOnDate (String date)async{

    List<Map<String , dynamic>> tasks = await database!.rawQuery("SELECT * FROM Task");
    List<Map<String , dynamic>> result = [];
    tasks.forEach((item) {
      print(item["date"].trim()+ "      " + date.trim());
      if(item["date"].toString().trim() == date.trim()){
        result.add(item);
      }
    });
    return result;
  }
}
