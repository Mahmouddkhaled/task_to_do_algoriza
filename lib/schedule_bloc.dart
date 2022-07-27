import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_task/tasks_database.dart';

class ScheduleBloc extends Cubit<ScheduleState>{
  ScheduleBloc():super(ScheduleState([]));
  getTasksByDate (String date)async{
    List<Map<String , dynamic>>  tasks =await TaskDatabase.getAllTasksOnDate(date);
  emit(ScheduleState(tasks));
  }

}
class ScheduleState {
  List<Map<String , dynamic>>  tasks ;

  ScheduleState(this.tasks);
}