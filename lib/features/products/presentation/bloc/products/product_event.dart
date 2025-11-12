part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchProductList extends ProductEvent {}

class SearchProduct extends ProductEvent {
  final String keyword;

  SearchProduct({required this.keyword});

  @override
  // TODO: implement props
  List<Object> get props => [keyword];
}

class SearchResult extends ProductEvent {
  final List<ProductModel> results;

  SearchResult({required this.results});

  @override
  // TODO: implement props
  List<Object> get props => [results];
}
