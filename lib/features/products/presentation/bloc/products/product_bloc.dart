import 'dart:async';

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
  List<ProductModel> _favorites = [];
  bool isSearching = false;
  ProductBloc(this.apiService) : super(ProductInitial()) {
    on<FetchProductList>((event, emit) async {
      emit(ProductLoading());
      final result = await apiService.getAllProducts();

      final favIds = await _loadFavorites();
      // print(favIds);

      result.fold((error) => emit(ProductError(message: error)), (data) {
        _allProducts = data;
        _favorites = _allProducts.where((p) => favIds.contains(p.id)).toList();
        emit(ProductLoaded(listProduct: data, favorites: _favorites));
      });
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
        emit(ProductLoaded(listProduct: event.results, favorites: _favorites));
      }
    });
  }

  Future<List<int>> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favStringList = prefs.getStringList('favorite_products') ?? [];
      return favStringList.map((e) => int.parse(e)).toList();
    } catch (_) {
      return [];
    }
  }

  // Future
}
