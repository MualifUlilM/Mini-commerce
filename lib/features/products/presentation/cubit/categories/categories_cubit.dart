import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tugas/features/products/data/datasources/api_service.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(this.apiService) : super(CategoriesInitial());
  final ApiService apiService;

  void getCategories() async {
    emit(CategoriesLoading());
    final result = await apiService.getCategories();

    result.fold(
      (l) => emit(CategoriesError(message: l)),
      (r) => emit(CategoriesLoaded(categories: r)),
    );
  }
}
