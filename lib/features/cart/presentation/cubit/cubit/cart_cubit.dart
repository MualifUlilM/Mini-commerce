import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());
  List<int> _cartItems = [];
  Future<void> loadCartItems() async {
    emit(CartLoading());
    final idCartItems = await _loadCartLocal();
    final _cartItems = idCartItems;
    print(' Loaded cart items: $_cartItems');
    emit(CartLoaded(idCartItems: _cartItems, totalPrice: 0));
  }

  Future<void> decrementCart(int productId) async {
    final idCartItems = await _loadCartLocal();
    print('ini cart items sebelum decrement: $idCartItems');
    _cartItems = idCartItems;
    _cartItems.remove(productId);
    print('Removed product $productId from cart');
    print('ini cart items: $_cartItems');
    await _saveCartLocal();
    emit(CartLoaded(idCartItems: _cartItems, totalPrice: 0));
  }

  Future<void> incrementCart(int productId) async {
    List<int> updatedCart = List.from(_cartItems);
    updatedCart.add(productId);
    _cartItems = updatedCart;

    emit(CartLoaded(idCartItems: List.from(_cartItems), totalPrice: 0));
    await _saveCartLocal();
  }

  Future<void> toggleCart(int productId) async {
    final idCartItems = await _loadCartLocal();
    print('ini cart items sebelum toggle: $idCartItems');
    _cartItems = idCartItems;
    if (_cartItems.contains(productId)) {
      _cartItems.remove(productId);
      print('Removed product $productId from cart');
    } else {
      _cartItems.add(productId);
      print('Added product $productId to cart');
    }
    print('ini cart items: $_cartItems');
    await _saveCartLocal();
    emit(CartLoaded(idCartItems: _cartItems, totalPrice: 0));
  }

  Future<void> _saveCartLocal() async {
    final prefs = await SharedPreferences.getInstance();
    print('Saving cart items to local storage $_cartItems');
    final cartIds = _cartItems;
    print('Saving cart items: $cartIds');
    prefs.setStringList(
      'cart_items',
      cartIds.map((e) => e.toString()).toList(),
    );
  }

  Future<List<int>> _loadCartLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartStringList = prefs.getStringList('cart_items') ?? [];
      return cartStringList.map((e) => int.parse(e)).toList();
    } catch (_) {
      return [];
    }
  }
}
