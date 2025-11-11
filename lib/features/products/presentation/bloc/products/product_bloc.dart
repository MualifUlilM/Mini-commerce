import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tugas/features/products/data/datasources/api_service.dart';
import 'package:tugas/features/products/data/models/product_model.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ApiService apiService;
  ProductBloc(this.apiService) : super(ProductInitial()) {
    on<FetchProductList>((event, emit) async {
      emit(ProductLoading());
      final result = await apiService.getAllProducts();

      result.fold(
        (error) => emit(ProductError(message: error)),
        (data) => emit(ProductLoaded(listProduct: data)),
      );
    });
  }
}
