import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_task/tasks_database.dart';

class TasksBloc extends Cubit<TasksState>{
  TasksBloc():super(TasksState([],[],[],[]));

  getAllData()async{
    List<Map<String , dynamic>>  tasks  = await TaskDatabase.getAllTasks();
    List<Map<String , dynamic>> completedTask  =await TaskDatabase.getAllCompletedTasks();
    List<Map<String , dynamic>> unCompletedTask  =await TaskDatabase.getAllUnCompletedTasks();
    List<Map<String , dynamic>> favoriteTask  = await TaskDatabase.getAllFavoriteTasks();
    emit(TasksState(tasks, completedTask, unCompletedTask, favoriteTask));
  }
}
class TasksState{
  List<Map<String , dynamic>> tasks;
  List<Map<String , dynamic>> completedTask;
  List<Map<String , dynamic>> unCompletedTask;
  List<Map<String , dynamic>> favoriteTask;

  TasksState(
      this.tasks, this.completedTask, this.unCompletedTask, this.favoriteTask);
}