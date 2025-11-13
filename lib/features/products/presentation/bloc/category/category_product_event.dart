part of 'category_product_bloc.dart';

sealed class CategoryProductEvent extends Equatable {
  const CategoryProductEvent();

  @override
  List<Object> get props => [];
}

class GetCategoryProductEvent extends CategoryProductEvent {
  final String categoryName;

  GetCategoryProductEvent({required this.categoryName});
}

class loadFavoritesEvent extends CategoryProductEvent {
  final List<CategoryProductModel> allProducts;

  loadFavoritesEvent({required this.allProducts});
}
