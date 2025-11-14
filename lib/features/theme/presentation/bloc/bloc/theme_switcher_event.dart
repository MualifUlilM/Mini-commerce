part of 'theme_switcher_bloc.dart';

sealed class ThemeSwitcherEvent extends Equatable {
  const ThemeSwitcherEvent();

  @override
  List<Object> get props => [];
}

class SetInitialTheme extends ThemeSwitcherEvent {}

class ThemeSwithing extends ThemeSwitcherEvent {}
