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
  ProductLoaded({required this.listProduct});

  @override
  List<Object> get props => [listProduct];
}

class ProductError extends ProductState {
  final String message;

  ProductError({required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
