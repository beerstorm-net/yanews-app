part of 'app_navigator_bloc.dart';

abstract class AppNavigatorEvent extends Equatable {
  const AppNavigatorEvent();

  @override
  List<Object> get props => [];
}

class AnonymousSigninEvent extends AppNavigatorEvent {}

class LoadItemsEvent extends AppNavigatorEvent {
  final Map<String, String> reqParams;
  const LoadItemsEvent({this.reqParams});

  @override
  List<Object> get props => [reqParams];

  @override
  String toString() => 'LoadItemsEvent {reqParams: $reqParams}';
}

class AppPageEvent extends AppNavigatorEvent {
  final AppNavigatorPage tab;

  const AppPageEvent({this.tab});

  @override
  List<Object> get props => [tab];

  @override
  String toString() => 'AppPageEvent {tab: $tab}';
}

class WarnUserEvent extends AppNavigatorEvent {
  final List<String> actions;
  final String message;
  final Duration duration;

  const WarnUserEvent(this.actions, {this.message, this.duration = const Duration(seconds: 2)});

  @override
  List<Object> get props => [actions, message, duration];

  @override
  String toString() =>
      'WarnUserEvent { actions: $actions, message: $message, duration: $duration }';
}
