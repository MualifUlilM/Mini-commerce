import 'dart:async';
import 'dart:developer' as Developer;

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
        final hasReachedMax = data.length < _productLimit;
        Developer.log(
          'Fetched products: ${data.length}, hasReachedMax: $hasReachedMax',
        );
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
        Developer.log('Fetching more products at offset $result');

        result.fold((error) => emit(ProductError(message: error)), (data) {
          Developer.log(
            'Fetched more products: ${data.length} at offset $currentOffset',
          );
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
      isSearching = event.keyword.isNotEmpty;
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
  // Future
}
