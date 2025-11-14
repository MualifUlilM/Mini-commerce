part of 'theme_switcher_bloc.dart';

sealed class ThemeSwitcherState extends Equatable {
  const ThemeSwitcherState();
  
  @override
  List<Object> get props => [];
}

final class ThemeSwitcherInitial extends ThemeSwitcherState {}
