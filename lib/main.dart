import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funda_assignment/service/funda_service.dart';
import 'package:funda_assignment/ui/app_shell.dart';

import 'logic/data_cubit.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.orange,
      ),
      home: BlocProvider(
        create: (context) => DataCubit(FundaService()),
        child:const SafeArea(top:false,child:  AppShell()),
      ),
    );
  }
}
