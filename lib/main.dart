import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shuttle_student_bus/Bloc/authentication/authentication_bloc.dart';
import 'package:shuttle_student_bus/Bloc/flow_bloc_delegate.dart';
import 'package:shuttle_student_bus/Design/signinPage.dart';

void main() {
  BlocSupervisor.delegate = FlowBlocDelegate();
  return runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        builder: (BuildContext context) => AuthenticationBloc(),
        child: RegisterPage(),
        //child: MyHomePage(),
      ),
    );
  }
}



