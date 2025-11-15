import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tugas/features/cart/presentation/cubit/cubit/cart_cubit.dart';
import 'package:tugas/features/products/presentation/bloc/products/product_bloc.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProductList());
    context.read<CartCubit>().loadCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart Page')),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is ProductLoaded) {
            final products = state.listProduct;
            return BlocBuilder<CartCubit, CartState>(
              builder: (context, cartState) {
                if (cartState is CartLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (cartState is CartLoaded) {
                  final cartItems = cartState.idCartItems;
                  final cartProducts = products
                      .where((product) => cartItems.contains(product.id))
                      .toList();

                  final totalPrice = cartProducts.fold(
                    0.0,
                    (double currentTotal, product) =>
                        currentTotal + product.price,
                  );

                  return Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            context.read<ProductBloc>().add(FetchProductList());
                            context.read<CartCubit>().loadCartItems();
                          },
                          child: ListView.builder(
                            itemCount: cartProducts.length,
                            itemBuilder: (context, index) {
                              final product = cartProducts[index];
                              return Column(
                                children: [
                                  ListTile(
                                    leading: Image.network(
                                      product.image,
                                      width: 50,
                                      height: 50,
                                    ),
                                    title: Text(product.title),
                                    subtitle: Text('\$${product.price}'),
                                  ),
                                  Text(
                                    'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Center(child: Text('Failed to load cart items'));
              },
            );
          }
          return ListView(
            children: [Center(child: Text('This is the cart page'))],
          );
        },
      ),
    );
  }
}
