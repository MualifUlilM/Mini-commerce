import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas/features/products/data/datasources/api_service.dart';
import 'package:tugas/features/products/data/models/category_product_model.dart';

part 'category_product_event.dart';
part 'category_product_state.dart';

class CategoryProductBloc
    extends Bloc<CategoryProductEvent, CategoryProductState> {
  final ApiService apiService;
  List<CategoryProductModel> _productfavorites = [];
  CategoryProductBloc(this.apiService) : super(CategoryProductInitial()) {
    on<GetCategoryProductEvent>((event, emit) async {
      emit(CategoryProductLoading());
      final favIds = await _loadFavorites();

      final result = await apiService.getProductByCategory(event.categoryName);
      result.fold((l) => emit(CategoryProductError(message: l)), (data) {
        _productfavorites = data.where((p) => favIds.contains(p.id)).toList();
        emit(
          CategoryProductLoaded(
            categoryProduct: data,
            favorites: _productfavorites,
          ),
        );
      });
    });
  }

  Future<List<int>> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favStringList = prefs.getStringList('favorite_products') ?? [];
      return favStringList.map((e) => int.parse(e)).toList();
    } catch (e) {
      return [];
    }
  }
}
