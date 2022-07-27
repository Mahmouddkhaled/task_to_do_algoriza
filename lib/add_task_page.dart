import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_task/Notification_service.dart';
import 'package:to_do_task/tasks_database.dart';

class addTask extends StatefulWidget {
  const addTask({Key? key}) : super(key: key);

  @override
  State<addTask> createState() => _addTaskState();
}

class _addTaskState extends State<addTask> {
  TextEditingController TitleController = TextEditingController();
  TextEditingController DateController = TextEditingController();
  TextEditingController StartTimeController = TextEditingController();
  TextEditingController EndTimeController = TextEditingController();
  var key = GlobalKey<FormState>();
  String _reminderValue ="10 min before";
  String _repeatedValue ="non";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Add task',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Title'),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: TitleController,
                keyboardType: TextInputType.text,
                obscureText: false,
                decoration: InputDecoration(
                    hintText: 'Design team meeting',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Date'),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: DateController,
                keyboardType: TextInputType.datetime,
                obscureText: false,
                onTap: () async{
                  DateTime? selectedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2030));
                  if(selectedDate!=null){
                    final DateFormat dbFormat = DateFormat('dd / MM / yyyy');
                    String resultDate = dbFormat.format(selectedDate);
                    DateController.text = resultDate;
                  }
                  },
                readOnly: true,
                decoration: InputDecoration(
                    hintText: '2021-02-28',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Start time'),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .4,
                        child: TextFormField(
                          controller: StartTimeController,
                          keyboardType: TextInputType.datetime,
                          obscureText: false,
                          readOnly: true,
                          onTap: ()async{
                            TimeOfDay? selectedTime =  await showTimePicker(context: context, initialTime:TimeOfDay.now() ,);
                            if(selectedTime !=null){
                              StartTimeController .text = selectedTime.hour.toString() + ":"+selectedTime.minute.toString() ;
                            }
                          },
                          decoration: InputDecoration(
                              hintText: '11:00',
                              hintStyle: TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('End time'),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .4,
                        child: TextFormField(
                          controller: EndTimeController,
                          keyboardType: TextInputType.datetime,
                          obscureText: false,
                          readOnly: true,
                          onTap: ()async{
                            TimeOfDay? selectedTime =  await showTimePicker(context: context, initialTime:TimeOfDay.now() ,);
                            if(selectedTime !=null){
                              EndTimeController .text = selectedTime.hour.toString() + ":"+selectedTime.minute.toString() ;
                            }
                          },
                          decoration: InputDecoration(
                              hintText: '14:00',
                              hintStyle: TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text('Remind'),
                  SizedBox(width: 30,),
                  DropdownButton<String>(
                    elevation: 0,
                    value: _reminderValue,
                    items: <String>[
                      '10 min before',
                      '30 min before',
                      '1 hour before',
                      '1 day before'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _reminderValue =newValue!;
                      });
                    },
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text('Repeat'),
                  SizedBox(width: 30,),
                  DropdownButton<String>(
                    elevation: 0,
                    value: _repeatedValue,
                    items: <String>['non','daily', 'weekly', 'monthly', 'yearly']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _repeatedValue= newValue!;
                      });
                    },
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: ()async{
                  await TaskDatabase.addTask(title: TitleController.text, date: DateController.text, start_time: StartTimeController.text, end_time: EndTimeController.text, reminder: _reminderValue, weekly: _repeatedValue);
                  _prepareNotification(title: TitleController.text, date: DateController.text, start_time: StartTimeController.text, end_time: EndTimeController.text, reminder: _reminderValue, repeated: _repeatedValue);
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: const Text(
                    "Create a task",
                    style: const TextStyle(color: Colors.white),
                  ),
                  width: MediaQuery.of(context).size.width,
                  margin:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.green),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _prepareNotification({required String title, required String date, required String start_time, required String end_time, required String reminder, required String  repeated}) async{
   NotificationService service = NotificationService();
    if (repeated == "non"){
      switch (reminder){
        case "10 min before":
         DateTime time = DateFormat("hh:mm - dd / MM / yyyy").parse(start_time+" - "+date);
         DateTime finalTime =time.subtract(const Duration(minutes: 10));
         await service.scheduleNotification(finalTime.hashCode, "Alarm", title, finalTime);
         break;
          case "1 hour before":
            DateTime time = DateFormat("hh:mm - dd / MM / yyyy").parse(start_time+" - "+date);
            DateTime finalTime =time.subtract(const Duration(hours: 1));
            await service.scheduleNotification(finalTime.hashCode, "Alarm", title, finalTime);
          break;
          case "30 min before":
            DateTime time = DateFormat("hh:mm - dd / MM / yyyy").parse(start_time+" - "+date);
            DateTime finalTime =time.subtract(const Duration(minutes: 30));
            await service.scheduleNotification(finalTime.hashCode, "Alarm", title, finalTime);
            break;
          case "1 day before":
            DateTime time = DateFormat("hh:mm - dd / MM / yyyy").parse(start_time+" - "+date);
            DateTime finalTime =time.subtract(const Duration(days: 1));
            await service.scheduleNotification(finalTime.hashCode, "Alarm", title, finalTime);

            break;
      }
    }else {
      finalTitle = title ;
      DateTime time = DateFormat("hh:mm - dd / MM / yyyy").parse(start_time+" - "+date);
      finalTime = time;
      switch(repeated){
        case "daily":
          await AndroidAlarmManager.periodic(const Duration(days: 1),
              time.hashCode, showNotification , startAt: time , exact: true, wakeup: true, allowWhileIdle: true,rescheduleOnReboot:true );
          break;
        case "weekly":
          await AndroidAlarmManager.periodic(const Duration(days: 7),
              time.hashCode, showNotification , startAt: time , exact: true, wakeup: true, allowWhileIdle: true,rescheduleOnReboot:true );
          break;
        case "monthly":
          await AndroidAlarmManager.periodic(const Duration(days: 30),
              time.hashCode, showNotification , startAt: time , exact: true, wakeup: true, allowWhileIdle: true,rescheduleOnReboot:true );
          break;
        case "yearly":
          await AndroidAlarmManager.periodic(const Duration(days: 365),
              time.hashCode, showNotification , startAt: time , exact: true, wakeup: true, allowWhileIdle: true,rescheduleOnReboot:true );

          break;
      }
    }
  }
}
DateTime? finalTime ;
String? finalTitle ;
showNotification()async{
  NotificationService service = NotificationService();
  await service.showNotification(finalTime!.hashCode, "Alarm", finalTitle!);
}