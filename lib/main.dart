import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shuttle_student_bus/Bloc/authentication/authentication_bloc.dart';
import 'package:shuttle_student_bus/Bloc/authentication/flow_bloc_delegate.dart';
import 'package:shuttle_student_bus/Design/home.dart';

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
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        builder: (BuildContext context) => AuthenticationBloc(),
        child: HomePage(),
      ),
    );
  }
}



class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Hello'),
      ),
      body: Center(
      ),
      floatingActionButton: Column(
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {

            },
            tooltip: 'Test',
            child: Icon(Icons.refresh),
          ),
          FloatingActionButton(
            onPressed: () {

            },
            tooltip: 'Test',
            child: Icon(Icons.exit_to_app),
          )
        ],
      ) , // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
