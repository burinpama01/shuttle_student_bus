part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class InitialAuthenticationState extends AuthenticationState {}


class Uninitialized extends AuthenticationState {
  @override
  String toString() => 'Uninitialized';
}

class Authenticated extends AuthenticationState {

  FirebaseUser user;

  Authenticated(this.user);

  @override
  String toString() => 'Authenticated';
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'Unauthenticated';
}

class AuthenticatingState extends AuthenticationState {
  @override
  String toString() => 'AuthenticatingState';
}

class ErrorState extends AuthenticationState {
  @override
  String toString() => 'ErrorState';
}
