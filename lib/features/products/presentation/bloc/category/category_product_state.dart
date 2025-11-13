part of 'category_product_bloc.dart';

sealed class CategoryProductState extends Equatable {
  const CategoryProductState();

  @override
  List<Object> get props => [];
}

final class CategoryProductInitial extends CategoryProductState {}

class CategoryProductLoading extends CategoryProductState {}

class CategoryProductLoaded extends CategoryProductState {
  final List<CategoryProductModel> categoryProduct;
  final List<CategoryProductModel> favorites;

  CategoryProductLoaded({
    required this.categoryProduct,
    required this.favorites,
  });

  @override
  // TODO: implement props
  List<Object> get props => [categoryProduct];
}

class CategoryProductError extends CategoryProductState {
  final String message;

  CategoryProductError({required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
