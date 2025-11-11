part of 'detail_product_bloc.dart';

sealed class DetailProductState extends Equatable {
  const DetailProductState();

  @override
  List<Object> get props => [];
}

final class DetailProductInitial extends DetailProductState {}

class DetailProductLoading extends DetailProductState {}

class DetailProductLoaded extends DetailProductState {
  final ProductDetailModel detailProduct;

  const DetailProductLoaded({required this.detailProduct});

  @override
  // TODO: implement props
  List<Object> get props => [detailProduct];
}

class DetailProductError extends DetailProductState {
  final String message;

  const DetailProductError({required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
