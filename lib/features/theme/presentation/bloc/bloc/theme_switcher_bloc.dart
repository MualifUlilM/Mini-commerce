import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_switcher_event.dart';
part 'theme_switcher_state.dart';

class ThemeSwitcherBloc extends Bloc<ThemeSwitcherEvent, ThemeData> {
  ThemeSwitcherBloc() : super(ThemeData.light()) {
    on<SetInitialTheme>((event, emit) async {
      bool hasThemeDark = await isDark();
      emit(hasThemeDark ? ThemeData.dark() : ThemeData.light());
    });
    on<ThemeSwithing>((event, emit) async {
      bool hasThemeDark = state == ThemeData.dark();
      emit(hasThemeDark ? ThemeData.light() : ThemeData.dark());
      setTheme(!hasThemeDark);
    });
  }
}

Future<bool> isDark() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  return sharedPreferences.getBool('is_dark') ?? false;
}

Future<void> setTheme(bool isDark) async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.setBool('is_dark', isDark);
}
