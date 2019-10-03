import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shuttle_student_bus/Bloc/authentication/authentication_bloc.dart';

class SigninPage extends StatefulWidget {
  _signinPage createState() => new _signinPage();
}

class _signinPage extends State<SigninPage>
    implements AuthenticationDelegate {
  AuthenticationBloc _authenticationBloc;

  @override
  Widget build(BuildContext context) {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return BlocBuilder(
      bloc: _authenticationBloc,
      builder: (BuildContext _context, AuthenticationState _state) {
        if (_state is InitialAuthenticationState) {
          _authenticationBloc.dispatch(AppStarted(context));
          return Container(
            color: Colors.red,
          );
        }
        if (_state is AuthenticatingState) {
          print("AuthenticatingState");
          return _authenticatingPage();
        } else if (_state is UnauthenticatedState) {
          return _authenticationPage(context, _state);
        } else if (_state is AuthenticatedState) {
          return _homePage(_state);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _homePage(AuthenticationState _state) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Home Page"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              color: Colors.white,
              onPressed: () {
                _authenticationBloc.dispatch(LogOut());
              })
        ],
      ),
      body: Center(
        child: _state is AuthenticatedState
            ? SizedBox(
                height: 50,
                width: 50,
                child: Image.network(_state.user.photoUrl),
              )
            : Container(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _authenticationPage(
      BuildContext _context, AuthenticationState _state) {
    return Scaffold(
      body: Container(
        color: Colors.orange[50],
        child: Center(
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                      colors: [Colors.yellow[100], Colors.orangeAccent[100]])),
              margin: EdgeInsets.all(32),
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildTextFieldEmail(),
                  buildTextFieldPassword(),
                  buildButtonSignIn(),
                  buildButtonGoogleSignIn(_context, _state),
                ],
              )),
        ),
      ),
    );
  }

  Container buildButtonGoogleSignIn(
      BuildContext _context, AuthenticationState _state) {
    return Container(
      child: Container(
        constraints: BoxConstraints.expand(height: 50),
        margin: EdgeInsets.only(top: 16),

        width: MediaQuery.of(context).size.width,

        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: Colors.red[200]),
        child: FlatButton(
            onPressed: () {
              //handleSignIn(widget, context);
              _authenticationBloc.dispatch(GoogleLogin(_context));
            },
            child: Stack(
              children: <Widget>[
                Center(
                  child: Text("Google Sign in",
                      style: TextStyle(
                          fontFamily: 'SukhumvitSet',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white)),
                )
              ],
            )),
      ),
    );
  }

  Container buildButtonSignIn() {
    return Container(
        constraints: BoxConstraints.expand(height: 50),
        child: Text("Sign in",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: Colors.green[200]),
        margin: EdgeInsets.only(top: 16),
        padding: EdgeInsets.all(12));
  }



  Container buildTextFieldEmail() {
    return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
        child: TextField(
            decoration: InputDecoration.collapsed(hintText: "Email"),
            style: TextStyle(fontSize: 18)));
  }

  Container buildTextFieldPassword() {
    return Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
            color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
        child: TextField(
            obscureText: true,
            decoration: InputDecoration.collapsed(hintText: "Password"),
            style: TextStyle(fontSize: 18)));
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
