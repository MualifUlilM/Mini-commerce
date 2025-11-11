part of 'detail_product_bloc.dart';

sealed class DetailProductEvent extends Equatable {
  const DetailProductEvent();

  @override
  List<Object> get props => [];
}

class GetDetailProduct extends DetailProductEvent {
  final int idProduct;

  GetDetailProduct({required this.idProduct});
}
