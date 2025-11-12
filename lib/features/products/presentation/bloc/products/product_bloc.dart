import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tugas/features/products/data/datasources/api_service.dart';
import 'package:tugas/features/products/data/models/product_model.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ApiService apiService;
  Timer? _debounce;
  List<ProductModel> _allProducts = [];
  ProductBloc(this.apiService) : super(ProductInitial()) {
    on<FetchProductList>((event, emit) async {
      emit(ProductLoading());
      final result = await apiService.getAllProducts();

      result.fold((error) => emit(ProductError(message: error)), (data) {
        _allProducts = data;
        emit(ProductLoaded(listProduct: data));
      });
    });
    on<SearchProduct>((event, emit) async {
      emit(ProductLoading());
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () async {
        if (event.keyword.isEmpty) {
          add(SearchResult(results: _allProducts));
        } else {
          final filtered = _allProducts
              .where(
                (item) => item.title.toLowerCase().contains(
                  event.keyword.toLowerCase(),
                ),
              )
              .toList();
          add(SearchResult(results: filtered));
        }
      });
    });
    on<SearchResult>((event, emit) async {
      if (event.results.isEmpty) {
        emit(ProductError(message: 'Not found'));
      } else {
        emit(ProductLoaded(listProduct: event.results));
      }
    });
  }
}
