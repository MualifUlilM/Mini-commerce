part of 'cart_cubit.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

final class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<int> idCartItems;
  final int totalPrice;
  const CartLoaded({required this.idCartItems, required this.totalPrice});

  @override
  // TODO: implement props
  List<Object> get props => [idCartItems, totalPrice];
}
