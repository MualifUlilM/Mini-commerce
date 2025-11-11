import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tugas/features/products/data/datasources/api_service.dart';
import 'package:tugas/features/products/data/models/category_product_model.dart';

part 'category_product_event.dart';
part 'category_product_state.dart';

class CategoryProductBloc
    extends Bloc<CategoryProductEvent, CategoryProductState> {
  final ApiService apiService;
  CategoryProductBloc(this.apiService) : super(CategoryProductInitial()) {
    on<GetCategoryProductEvent>((event, emit) async {
      emit(CategoryProductLoading());

      final result = await apiService.getProductByCategory(event.categoryName);
      result.fold(
        (l) => emit(CategoryProductError(message: l)),
        (r) => emit(CategoryProductLoaded(categoryProduct: r)),
      );
    });
  }
}
