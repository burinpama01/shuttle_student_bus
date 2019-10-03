part of 'navigator_bloc.dart';

@immutable
abstract class NavigatorState {}

class InitialNavigatorState extends NavigatorState {}

class NavigatorLoginState extends NavigatorState {
  @override
  String toString() => 'NavigatorLoginState';
}
class ExitToAppState extends NavigatorState {
  @override
  String toString() => 'ExitToAppState';
}