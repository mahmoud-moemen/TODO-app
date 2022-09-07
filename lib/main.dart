import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/bloc_observer.dart';

import 'layout/todo_layout.dart';

void main() {
  BlocOverrides.runZoned(
        () {
      runApp(MyApp());
    },
    blocObserver: MyBlocObserver(),
  );


}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context)
  {
    return   MaterialApp(
      debugShowCheckedModeBanner: false,
      home:HomeLayout(),
    );
  }
}

