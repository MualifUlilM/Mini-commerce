import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas/features/cart/presentation/cubit/cubit/cart_cubit.dart';
import 'package:tugas/features/products/data/datasources/api_service.dart';
import 'package:tugas/features/products/presentation/bloc/category/category_product_bloc.dart';
import 'package:tugas/features/products/presentation/bloc/detailproduct/detail_product_bloc.dart';
import 'package:tugas/features/products/presentation/bloc/products/product_bloc.dart';
import 'package:tugas/features/favorites/presentation/cubit/Favorites/favorites_cubit.dart';
import 'package:tugas/features/products/presentation/cubit/categories/categories_cubit.dart';
import 'package:tugas/features/products/presentation/pages/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas/features/theme/presentation/bloc/bloc/theme_switcher_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  ProductBloc(ApiService(client: http.Client())),
            ),
            BlocProvider(
              create: (context) =>
                  DetailProductBloc(ApiService(client: http.Client())),
            ),
            BlocProvider(
              create: (context) =>
                  CategoryProductBloc(ApiService(client: http.Client())),
            ),
            BlocProvider(
              create: (context) =>
                  CategoriesCubit(ApiService(client: http.Client())),
            ),
            BlocProvider(create: (context) => FavoritesCubit()),
            BlocProvider(
              create: (context) => ThemeSwitcherBloc()..add(SetInitialTheme()),
            ),
            BlocProvider(create: (context) => CartCubit()),
          ],
          child: BlocBuilder<ThemeSwitcherBloc, ThemeData>(
            builder: (context, state) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Mini-Commerce',
                theme: state.copyWith(
                  textTheme: GoogleFonts.poppinsTextTheme(
                    Theme.of(context).textTheme,
                  ),
                ),
                home: const HomePage(),
              );
            },
          ),
        );
      },
    );
  }
}
