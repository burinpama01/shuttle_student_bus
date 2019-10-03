part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class InitialAuthenticationState extends AuthenticationState {}


class Uninitialized extends AuthenticationState {
  @override
  String toString() => 'Uninitialized';
}

class AuthenticatedState extends AuthenticationState {

  FirebaseUser user;

  AuthenticatedState(this.user);

  @override
  String toString() => 'AuthenticatedState';
}

class UnauthenticatedState extends AuthenticationState {
  @override
  String toString() => 'UnauthenticatedState';
}

class AuthenticatingState extends AuthenticationState {
  @override
  String toString() => 'AuthenticatingState';
}

class ErrorState extends AuthenticationState {
  @override
  String toString() => 'ErrorState';
}
