import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:to_do_task/main.dart';
import 'package:to_do_task/schedule_bloc.dart';
import 'package:to_do_task/tasks_database.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String _selectedDay ="" ;
  String _selectedDate ="" ;
  DateTime selected  = DateTime.now();
  ScheduleBloc bloc = ScheduleBloc();
  @override
  void initState() {

    _selectedDay =DateFormat('EEEE').format(selected);
    final DateFormat formatter = DateFormat('dd MMM,yyyy');
    _selectedDate = formatter.format(selected);
    final DateFormat dbFormat = DateFormat('dd / MM / yyyy');
    String resultDate = dbFormat.format(selected);
    bloc.getTasksByDate(resultDate);
    super.initState();
  }
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(context, "Schedule",null,true),
        body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
          TableCalendar(
            headerVisible: true,
            firstDay: DateTime.utc(2010, 10, 16),
           lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: selected,
            currentDay:selected,

            calendarFormat: CalendarFormat.week,
            onDaySelected: (DateTime selectedDay, DateTime focusedDay){
              _selectedDay =DateFormat('EEEE').format(selectedDay);
              final DateFormat formatter = DateFormat('dd MMM,yyyy');
              _selectedDate = formatter.format(selectedDay);
              selected = selectedDay;
              print(_selectedDate);
              final DateFormat dbFormat = DateFormat('dd / MM / yyyy');
              String resultDate = dbFormat.format(selected);
              bloc.getTasksByDate(resultDate);
              setState(() {

              });},

          ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("$_selectedDay",style: TextStyle(fontWeight: FontWeight.bold), ),
                    Text("$_selectedDate")
                  ],
                ),
              ),
              SizedBox(height: 10,),
              BlocBuilder<ScheduleBloc , ScheduleState>(
                bloc: bloc,
                builder: (context, snapshot) {
                  return Container(
                    height: MediaQuery.of(context).size.height * .7,
                    child: ListView.builder(
                        itemCount: snapshot.tasks.length,
                        itemBuilder: (c, index){
                      return Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colors[Random().nextInt(9)],
                          borderRadius: BorderRadius.circular(16)
                        ),
                        child: Row(

                          children: [
                            Expanded(
                              flex: 8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.tasks[index]["start_time"] , style: TextStyle(color: Colors.white),),
                                  SizedBox(height: 5,),
                                  Text(snapshot.tasks[index]["title"],style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                             Expanded(
                                flex: 1,
                                child: GestureDetector(
                                    onTap: ()async{
                                      await TaskDatabase.completeTask(snapshot.tasks[index]["id"]);
                                      final DateFormat dbFormat = DateFormat('dd / MM / yyyy');
                                      String resultDate = dbFormat.format(selected);
                                      bloc.getTasksByDate(resultDate);
                                    },
                                    child: Icon(snapshot.tasks[index]["isCompleted"] == 0 ? Icons.circle_outlined : Icons.check_circle_rounded, color: Colors.white,))),
                             Expanded(
                                flex: 1,
                                child: GestureDetector(
                                    onTap: ()async{
                                      await TaskDatabase.favoriteTask(snapshot.tasks[index]["id"]);
                                      final DateFormat dbFormat = DateFormat('dd / MM / yyyy');
                                      String resultDate = dbFormat.format(selected);
                                      bloc.getTasksByDate(resultDate);
                                    },
                                    child: Icon(snapshot.tasks[index]["isFavorite"] == 0 ?Icons.favorite_border : Icons.favorite, color: Colors.white,))),
                          ],
                        ),
                      );
                    }),
                  );
                }
              )
            ],
          ),
        )
    );
  }
}
