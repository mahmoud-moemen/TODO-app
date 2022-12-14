import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/cubit/states.dart';


import '../../modules/archived_tasks/archived_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit(): super(AppInitialState());

  static AppCubit get(context)=>BlocProvider.of(context);

  int CurrentIndex = 0;

  List<Widget> screens =
  [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index)
  {
    CurrentIndex=index;
    emit(AppChangeBottomNavBarState());
  }

  late Database database;
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];


  void createDatabase()  {
     openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created ');
        database
            .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status Text)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error when creating table ${error.toString()}');
        });
        ;
      },
      onOpen: (database) {
         getDataFromDatabase(database);
        print('database opened ');
        //print(database);
      },
    ).then((value) {
      database=value;
      emit(AppCreateDatabaseState());
     });
  }

   insertToDatabase({
    required String title,
    required String time,
    required String date,

  }) async
   {
     await database.transaction((txn) {
      print("wait im inserting the data");
      txn.rawInsert(
          'INSERT INTO TASKS(title , date , time , status ) VALUES("${title}","${date}","${time}","new") ')
          .then((value) {
        print('${value} inserted successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);

      }).catchError((error) {
        print('error when inserting new row ${error.toString()}');
      });
      return Future(() => null);
    });
  }

  void getDataFromDatabase(database)  {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];

    emit(AppGetDatabaseLoadingState());
     database.rawQuery('SELECT *FROM tasks').then((value) {


       value.forEach((element)
       {
        if(element['status']=='new'){newTasks.add(element);}
        else if(element['status']=='done'){doneTasks.add(element);}
        else archivedTasks.add(element);

       });

       emit(AppGetDatabaseState());


     });
  }


  void updateData({
  required String status,
  required int id,
})async
  {
    database.rawUpdate(
      'UPDATE tasks SET status=?  WHERE id =?',
      ['${status}',id]).then((value) {
        getDataFromDatabase(database);
        emit(AppUpdateDatabaseState());
    });
  }


  void deleteData({
    required int id,
  })async
  {
    database.rawDelete(
        'DELETE FROM tasks WHERE    id =?', [id])
        .then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  bool isBottomSheetShowen = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
  required bool isShow,
  required IconData icon,})
  {
    isBottomSheetShowen=isShow;
    fabIcon=icon;
    emit(AppChangeBottomSheetState());
  }


}

