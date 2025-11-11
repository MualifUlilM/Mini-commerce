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

  CategoryProductLoaded({required this.categoryProduct});

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
