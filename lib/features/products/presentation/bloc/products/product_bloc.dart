import 'dart:async';
import 'dart:developer' as Developer;
import 'dart:developer' as Dev;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas/features/products/data/datasources/api_service.dart';
import 'package:tugas/features/products/data/models/product_model.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ApiService apiService;
  Timer? _debounce;
  List<ProductModel> _loadedProducts = [];
  List<ProductModel> _allProducts = [];
  bool isSearching = false;
  final int _productLimit = 5;
  ProductBloc(this.apiService) : super(ProductInitial()) {
    on<FetchProductList>((event, emit) async {
      emit(ProductLoading());
      final result = await apiService.getPaginatedProducts(
        limit: _productLimit,
        offset: 0,
      );

      result.fold((error) => emit(ProductError(message: error)), (data) {
        _loadedProducts = data;
        final hasReachedMax = data.length < _productLimit;
        emit(ProductLoaded(listProduct: data, hasReachedMax: hasReachedMax));
      });
    });
    on<FetchMoreProducts>((event, emit) async {
      final currentState = state;
      if (currentState is ProductLoaded && !currentState.hasReachedMax) {
        final currentOffset = currentState.listProduct.length;
        final result = await apiService.getPaginatedProducts(
          limit: _productLimit,
          offset: currentOffset,
        );

        result.fold((error) => emit(ProductError(message: error)), (data) {
          if (data.isEmpty) {
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            emit(
              currentState.copyWith(
                listProduct: currentState.listProduct + data,
                hasReachedMax: data.length < _productLimit,
              ),
            );
          }
        });
      }
    });
    on<SearchProduct>((event, emit) async {
      emit(ProductLoading());
      _debounce?.cancel();
      isSearching = event.keyword.isNotEmpty;
      _debounce = Timer(const Duration(milliseconds: 300), () async {
        if (event.keyword.isEmpty) {
          Dev.log('Clearing search, loading all products');
          Dev.log('All products: ${_loadedProducts.length}');
          add(SearchResult(results: _loadedProducts));
        } else {
          if (_allProducts.isEmpty) {
            final result = await apiService.getAllProducts();
            result.fold((l) => ProductError(message: l), (data) {
              _allProducts = data;
            });
          }
          final filtered = _allProducts
              .where(
                (item) => item.title.toLowerCase().contains(
                  event.keyword.toLowerCase(),
                ),
              )
              .toList();
          Dev.log('Searching products with keyword: ${filtered}');
          add(SearchResult(results: filtered));
        }
      });
    });
    on<SearchResult>((event, emit) async {
      if (event.results.isEmpty) {
        emit(ProductError(message: 'Not found'));
      } else {
        emit(ProductLoaded(listProduct: event.results, hasReachedMax: true));
      }
    });
  }
  // Future
}
