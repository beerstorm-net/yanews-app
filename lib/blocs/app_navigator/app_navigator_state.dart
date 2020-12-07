part of 'app_navigator_bloc.dart';

abstract class AppNavigatorState extends Equatable {
  const AppNavigatorState();

  @override
  List<Object> get props => [];
}

class InitialAppNavigatorState extends AppNavigatorState {}

class AppPageState extends AppNavigatorState {
  final AppNavigatorPage tab;

  const AppPageState({this.tab});

  @override
  List<Object> get props => [tab];

  @override
  String toString() => 'AppPageState {tab: $tab}';
}

class WarnUserState extends AppNavigatorState {
  final List<String> actions;
  final String message;
  final Duration duration;

  const WarnUserState(this.actions, {this.message, this.duration = const Duration(seconds: 2)});

  @override
  List<Object> get props => [actions, message, duration];

  @override
  String toString() =>
      'WarnUserState { actions: $actions, message: $message, duration: $duration }';
}

class ItemsLoaded extends AppNavigatorState {
  final List<NewsItem> items;
  const ItemsLoaded({this.items});

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'ItemsLoaded {items: $items}';
}
