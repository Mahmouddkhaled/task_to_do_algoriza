import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/subjects.dart';
import 'package:to_do_task/Notification_service.dart';
import 'package:to_do_task/add_task_page.dart';
import 'package:to_do_task/schedule_screen.dart';
import 'package:to_do_task/tasks_bloc.dart';
import 'package:to_do_task/tasks_database.dart';
printHello(){
  print("Hello");
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  await NotificationService().init();
  await NotificationService().requestIOSPermissions();
  await TaskDatabase.initializeDatabase();
  runApp(const MyApp());


}

getAppBar(context,String title , Icon? icon , bool isBack){
  return AppBar(
    backgroundColor: Colors.white,
    leading: isBack ?  GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back_ios , color: Colors.black,)): Container(),
    title:  Text(title , style: const TextStyle(color: Colors.black),),
    actions: [
      GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (c)=>ScheduleScreen()));
          },
          child :icon != null ? Padding(
            padding: const EdgeInsets.only(right:16.0),
            child: icon,
          ): Container())
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',

      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Board'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> categories = [
    "All",
    "Completed",
    "Uncompleted",
    "Favorite"
  ];
  List<Color> colors = [
    Colors.orange,
    Colors.green,
    Colors.red,
    Colors.blueAccent,
    Colors.yellow,
    Colors.black,
    Colors.grey,
    Colors.lightGreenAccent,
    Colors.greenAccent
  ];
  TasksBloc bloc = TasksBloc();
  @override
  initState(){
    bloc.getAllData();
    rxActiveIndex.sink.add(0);
    super.initState();
  }
  int activeIndex = 0;
  BehaviorSubject<int> rxActiveIndex = BehaviorSubject();
  BehaviorSubject<int> rxTaskCheckBox = BehaviorSubject();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:  Text("Board" , style: const TextStyle(color: Colors.black),),
        actions: [
          GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (c)=>ScheduleScreen())).then((value) {
                  bloc.getAllData();
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.calendar_month , color: Colors.grey.shade700,
                ),
              ))
        ],
      ),
      body:
      StreamBuilder<int>(
          stream: rxActiveIndex.stream,
        builder: (context, snapshot) {
          return Column(
            children: [
              Expanded(
                flex: 9,
                child: Column(
                  children: [
                    const SizedBox(height: 30,),
                    SizedBox(
                      height: 35,
                      width: MediaQuery.of(context).size.width ,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey.shade300,
                              height: 3,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  activeIndex = 0;
                                  rxActiveIndex.sink.add(activeIndex);
                                },
                                child: Column(
                                  children:  [
                                    Text(categories[0],style: TextStyle(color:activeIndex == 0? Colors.black:Colors.grey.shade600   )),
                                    const SizedBox(height: 14,),
                                    activeIndex == 0 ? Container(
                                      height: 4,
                                      width: categories[0].length * 6,
                                      color: Colors.black54,
                                    ) : Container(),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  activeIndex = 1;
                                  rxActiveIndex.sink.add(activeIndex);
                                },
                                child: Column(
                                  children:  [
                                    Text(categories[1],style: TextStyle(color:activeIndex == 1? Colors.black:Colors.grey.shade600   )),
                                    const SizedBox(height: 14,),
                                    activeIndex == 1 ? Container(
                                      height: 4,
                                      width: categories[1].length * 6,
                                      color: Colors.black54,
                                    ):Container(),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  activeIndex = 2;
                                  rxActiveIndex.sink.add(activeIndex);
                                },
                                child: Column(
                                  children:  [
                                    Text(categories[2], style: TextStyle(color:activeIndex == 2? Colors.black:Colors.grey.shade600   ),),
                                    const SizedBox(height: 14,),

                                    activeIndex == 2 ? Container(
                                      height: 4,
                                      width: categories[2].length * 6,
                                      color: Colors.black54,
                                    ):Container(),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  activeIndex = 3;
                                  rxActiveIndex.sink.add(activeIndex);
                                },
                                child: Column(
                                  children:  [
                                    Text(categories[3],style: TextStyle(color:activeIndex == 3? Colors.black:Colors.grey.shade600   )),
                                    const SizedBox(height: 14,),
                                    activeIndex == 3 ? Container(
                                      height: 4,
                                      width: categories[3].length * 6,
                                      color: Colors.black54,
                                    ):Container(),
                                  ],
                                ),
                              ),

                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: BlocBuilder<TasksBloc , TasksState>(
                        bloc: bloc,
                        builder: (context, snapshot) {
                          List<Map<String , dynamic>> usedData = [];
                         switch( rxActiveIndex.value){
                           case 0:
                             usedData = snapshot.tasks;
                             break;
                             case 1:
                             usedData = snapshot.completedTask;
                             break;
                             case 2:
                             usedData = snapshot.unCompletedTask;
                             break;
                             case 3:
                             usedData = snapshot.favoriteTask;
                             break;
                         }
                          return ListView.builder(
                              itemCount: usedData.length,
                              shrinkWrap: true,
                              itemBuilder: (con , index){
                                Color selected = colors[Random().nextInt(8)];
                            return StreamBuilder<int>(
                              stream: rxTaskCheckBox.stream,
                              builder: (context, snapshot) {
                                return Row(
                                  children: [
                                    Theme(
                                      data:ThemeData(
                                        unselectedWidgetColor: selected, // <-- your color
                                      ),
                                      child: Checkbox(
                                        value: usedData[index]["isCompleted"] == 0 ? false : true,
                                        onChanged: (newValue){
                                          if(usedData[index]["isCompleted"] == 0){
                                            TaskDatabase.completeTask(usedData[index]["id"]);
                                            rxTaskCheckBox.sink.add(index);
                                            bloc.getAllData();
                                          }
                                        },
                                        activeColor: selected,
                                      checkColor: Colors.white,

                                      ),
                                    ),
                                    const SizedBox(width: 8,),
                                    Text(usedData[index]["title"] ),
                                  ],
                                );
                              }
                            );
                          });
                        }
                      ),
                    ),

                  ],
                ),
              ),
              Expanded(
                  flex: 1,
                  child:
              GestureDetector(
                onTap: ()async{
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return addTask();
                  })).then((value) {
                    bloc.getAllData();
                  });
                //  await TaskDatabase.deleteTask();
                  },
                child: Container(
                  alignment: Alignment.center,
                  child: const Text("Add a task" ,
                    style: const TextStyle(color: Colors.white),
                  ),
                  width: MediaQuery.of(context).size.width,
                  margin:const  EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.green
                  ),
                ),
              ))
            ],
          );
        }
      )
    );
  }

}
