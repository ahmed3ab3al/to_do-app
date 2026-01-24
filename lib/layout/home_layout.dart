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
  late Database database;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    createDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scaffoldKey.currentState!.showBottomSheet(
            (context) => Container(
              width: double.infinity,
              height: 50,
              color: Colors.red,
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          currentIndex == 0
              ? 'New Task'
              : currentIndex == 1
              ? 'Done Task'
              : 'Archived Task',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: currentIndex == 0
          ? NewTaskScreen()
          : currentIndex == 1
          ? DoneTaskScreen()
          : ArchivedTaskScreen(),
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

  void createDatabase() async {
    database = await openDatabase(
      'TODO.db',
      version: 1,
      onCreate: (database, version) {
        database
            .execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY , title TEXT , data TEXT , time TEXT ,status TEXT )',
            )
            .then((value) {
              print('table created ');
            })
            .catchError((error) {
              print('error  ${error.toString()}');
            });
      },
      onOpen: (database) {
        print('database opened0');
      },
    );
  }

  void insertToDatabase() async {
    await database.transaction((txn) async {
      await txn
          .rawInsert(
            'INSERT INTO tasks(title,data,time,status) VALUES ("new Task","24-1","21-16","new")',
          )
          .then((value) {
            print("$value inserted successfully");
          })
          .catchError((error) {
            print('error ${error.toString()}');
          });
    });
  }
}
