import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas/features/products/data/datasources/api_service.dart';
import 'package:tugas/features/products/presentation/bloc/bloc/product_bloc.dart';
import 'package:tugas/features/products/presentation/pages/home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

void main() {
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
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Mini-Commerce',
            theme: ThemeData(
              // colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
            home: const HomePage(),
          ),
        );
      },
    );
  }
}
