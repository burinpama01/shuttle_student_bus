part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

abstract class AuthenticationDelegate{
  void onSucess(String message);
  void onError(String message);

}

class AppStarted extends AuthenticationEvent {
  BuildContext context ;
  AppStarted(this.context);

  @override
  String toString() => 'AppStarted';
}

class LoggedIn extends AuthenticationEvent {
  @override
  String toString() => 'LoggedIn';
}

class LoggedOut extends AuthenticationEvent {
  @override
  String toString() => 'LoggedOut';
}

class EmailLogin extends AuthenticationEvent {
  @override
  String toString() => 'EmailLogin';
}

class GoogleLogin extends AuthenticationEvent {
  BuildContext context ;
  GoogleLogin(this.context);
  @override
  String toString() => 'GoogleLogin';
}

class LogOut extends AuthenticationEvent {
  @override
  String toString() => 'LogOut';
}
