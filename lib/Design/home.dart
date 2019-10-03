import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shuttle_student_bus/Bloc/authentication/authentication_bloc.dart';


class HomeRoute extends PageRoute<void> {
  HomeRoute({
    @required this.builder,
    RouteSettings settings,
  })  : assert(builder != null),
        super(settings: settings, fullscreenDialog: false);

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    //dialog = new ProgressDialog(context, ProgressDialogType.Normal);
    //dialog.setMessage('กำลังโหลด...');

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: result,
      ),
    );
/*
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: result,
      ),
    );*/
  }
}


class HomePage extends StatefulWidget {
  _homePage createState() => new _homePage();
}

class _homePage extends State<HomePage> implements AuthenticationDelegate {
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
        child: _state is Authenticated
            ? SizedBox(
                height: 50,
                width: 50,
                child: Image.network(_state.user.photoUrl),
              )
            : Container(),
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
