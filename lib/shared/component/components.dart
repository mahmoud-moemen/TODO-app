
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import '../cubit/cubit.dart';





Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  bool isPassword=false,
  Function(String)? onSubmitted,
  Function(String)? onChanged,
  VoidCallback? onTap,


  //required String Function(String?) validate ,
  required String? Function(String? val)? validator,

  required String label,
  required IconData prefix,
   IconData? suffix,
  VoidCallback? suffixPressed,
  bool isClickable=true,


}) => TextFormField(
  controller: controller,
  keyboardType: type,
  obscureText: isPassword,
  onFieldSubmitted: onSubmitted,
  onChanged:onChanged,
  onTap:onTap ,
  enabled:isClickable ,
  validator:validator,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(
      prefix,
    ), //icon in the start
    suffixIcon:suffix !=null ? IconButton(
      onPressed:suffixPressed ,
      icon : Icon(
        suffix,
      ),
    ):null, //icon in the start
    border: OutlineInputBorder(),
  ),
);


Widget buildTaskItem(Map model, context)=>Dismissible(
  key: Key(model['id'].toString()),
  child:Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children:

      [

        CircleAvatar(

          radius: 40.0,

          child: Text(

            '${model['time']} ',

          ),

        ),

        SizedBox(

          width: 20.0,

        ),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children:

            [

              Text(

                '${model['title']}',

                style: TextStyle(

                  fontSize: 18.0,

                  fontWeight: FontWeight.bold,

                ),

              ),

              Text(

                '${model['date']}',

                style: TextStyle(

                  color: Colors.grey,

                ),

              ),

            ],

          ),

        ),

        SizedBox(

          width: 20.0,

        ),

        IconButton(onPressed: ()

        {

          AppCubit.get(context).updateData

            (

              status: 'done',

              id:model['id'],

          );

        }, icon:Icon(

          Icons.check_box,

          color: Colors.green,

        )),



        IconButton(onPressed: ()

      {

      AppCubit.get(context).updateData

      (

      status: 'archive',

      id:model['id'],

      );

      }, icon:Icon(

            Icons.archive,

          color: Colors.black38,

        )),

      ],

    ),

  ),
  onDismissed: (direction)
  {
    if(direction == DismissDirection.endToStart){
    AppCubit.get(context).deleteData(id:model['id']);
    }
  },
);


Widget tasksBuilder({
  required List<Map> tasks,

})=> ConditionalBuilder(
  condition: tasks.length >0,
  builder:(context)=> ListView.separated(
    itemBuilder:(context,index)=>buildTaskItem(tasks[index],context),
    separatorBuilder: (context,index)=>Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    ),
    itemCount: tasks.length,),
  fallback:(context)=>Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu,size: 100.0,color: Colors.grey),
        Text(
          'No Tasks Yet, Please Add Some Tasks',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ) ,

);