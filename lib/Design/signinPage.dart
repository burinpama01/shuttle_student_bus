import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shuttle_student_bus/Bloc/authentication/authentication_bloc.dart';




class RegisterPage extends StatefulWidget {
  _registerPage createState() => new _registerPage();
}

class _registerPage extends State<RegisterPage>
    implements AuthenticationDelegate {
  AuthenticationBloc _authenticationBloc;

  @override
  Widget build(BuildContext context) {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return BlocBuilder(
      bloc: _authenticationBloc,
      builder: (BuildContext _context, AuthenticationState _state) {
        if (_state is AuthenticatingState) {
          return _authenticatingPage();
        } else if (_state is AuthenticationState ||
            _state is Unauthenticated ||
            _state is Authenticated) {
          return _authenticationPage(_state);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _authenticationPage(AuthenticationState _state) {
    return Scaffold(
      body: Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Center(
              child: Text("SIGNIN",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Poppins-Bold",
                      fontSize: 18,
                      letterSpacing: 1.0)),
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              _authenticationBloc.dispatch(GoogleLogin(context));
            },
            backgroundColor: Colors.red,
            tooltip: 'Test',
            child: Icon(Icons.refresh),
          ),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            onPressed: () {
              _authenticationBloc.dispatch(LogOut());
            },
            backgroundColor: Colors.red,
            tooltip: 'Test',
            child: Icon(Icons.exit_to_app),
          )
        ],
      ), // Th// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _authenticatingPage() {
    return Container(
      color: Colors.orange,
    );
  }

  @override
  void onError(String message) {
    print("onError");
  }

  @override
  void onSucess(String message) {
    print("onSuccess");
  }
}
