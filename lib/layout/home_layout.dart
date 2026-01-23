import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../modules/archived_tasks/archived_task_screen.dart';
import '../modules/done_tasks/done_task_screen.dart';
import '../modules/new_tasks/new_task_screen.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  @override
  void initState() {
    createDatabase();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          currentIndex==0?
          'New Task':
          currentIndex==1?
          'Done Task':
          'Archived Task',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: currentIndex == 0 ? NewTaskScreen() :
      currentIndex == 1 ? DoneTaskScreen() :
      ArchivedTaskScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive_outlined),
            label: 'Archived',
          ),
        ],
      ),
    );
  }

  void createDatabase() async{
    var database = await openDatabase(
      'TODO.db',
      version:1,
      onCreate: (database,version)
      {
         database.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY , title TEXT , data TEXT , tme TEXT ,status TEXT )'
        ).then((value){
          print('table created ');
        }).catchError((error){
          print('error  ${error.toString()}');
        });
      },
      onOpen: (database){

      }
    );
  }
}

