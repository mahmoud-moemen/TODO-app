
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../shared/component/components.dart';
import '../shared/cubit/cubit.dart';
import '../shared/cubit/states.dart';



class HomeLayout extends StatelessWidget {


  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
      AppCubit()
        ..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if(state is AppInsertDatabaseState)
          {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(AppCubit
                  .get(context)
                  .titles[AppCubit
                  .get(context)
                  .CurrentIndex]),
            ),
            body: //tasks.length==0?CircularProgressIndicator(): screens[CurrentIndex],
            ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) =>
              AppCubit
                  .get(context)
                  .screens[AppCubit
                  .get(context)
                  .CurrentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                print(formKey.currentState);
                if (AppCubit.get(context).isBottomSheetShowen) {
                  if (formKey.currentState!.validate())
                  {
                    AppCubit.get(context).insertToDatabase(
                        title:titleController.text ,
                        time: timeController.text,
                        date: dateController.text);
                    //   insertToDatabase(
                    //       title: titleController.text,
                    //       date: dateController.text,
                    //       time: timeController.text)
                    //       .then((value) {
                    //     getDataFromDatabase(database).then((value) {
                    //       Navigator.pop(context);
                    //       // setState(()
                    //       // {
                    //       //
                    //       //   isBottomSheetShowen=false;
                    //       //   fabIcon=Icons.edit;
                    //       //
                    //       //   tasks=value;
                    //       // });
                    //     });
                    //   });
                    // } else {
                    //   print('the data is not valid');
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) =>
                        Container(
                          color: Colors.grey[100],
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validator: (String? value) {
                                    if (value!.isEmpty)
                                    {
                                      return 'title must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'task title',
                                  prefix: Icons.title,
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                defaultFormField(
                                  controller: timeController,
                                  type: TextInputType.none,
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeController.text =
                                          value!.format(context);
                                      //print(value.format(context));
                                    });
                                  },
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'time must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'task Time',
                                  prefix: Icons.watch_later_outlined,
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                defaultFormField(
                                  controller: dateController,
                                  type: TextInputType.none,
                                  onTap: () {
                                    showDatePicker(
                                        context:context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2022-07-01'))
                                        .then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                      //print(DateFormat.yMMMd().format(value));
                                    });
                                  },
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'date must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'task Date',
                                  prefix: Icons.calendar_today,
                                ),
                              ],
                            ),
                          ),
                        ),
                  )
                      .closed
                      .then((value) {
                    AppCubit.get(context).changeBottomSheetState(isShow: false, icon: Icons.edit);

                  });
                  AppCubit.get(context).changeBottomSheetState(isShow: true, icon: Icons.add);

                }
              },
              child: Icon(
                AppCubit.get(context).fabIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              //backgroundColor:Colors.red ,
              //showSelectedLabels: false,
              currentIndex: AppCubit
                  .get(context)
                  .CurrentIndex, //0 is the default value
              onTap: (index) {
                AppCubit.get(context).changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
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
        },
      ),
    );
  }


}




