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
  final bool hasReachedMax;

  const ProductLoaded({required this.listProduct, this.hasReachedMax = false});

  ProductLoaded copyWith({
    List<ProductModel>? listProduct,
    bool? hasReachedMax,
  }) {
    return ProductLoaded(
      listProduct: listProduct ?? this.listProduct,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  // TODO: implement props
  List<Object> get props => [listProduct, hasReachedMax];
}

class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
