part of 'navigator_bloc.dart';

@immutable
abstract class NavigatorEvent {}

class NavigatorLogin extends NavigatorState {
  @override
  String toString() => 'NavigatorLogin';
}
