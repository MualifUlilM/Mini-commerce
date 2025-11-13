part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> listProduct;
  final List<ProductModel> favorites;

  const ProductLoaded({required this.listProduct, required this.favorites});

  @override
  // TODO: implement props
  List<Object> get props => [listProduct, favorites];
}

class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
