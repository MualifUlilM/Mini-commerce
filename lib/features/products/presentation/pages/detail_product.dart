import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tugas/core/theme/app_colors.dart';
import 'package:tugas/features/products/presentation/bloc/detailproduct/detail_product_bloc.dart';
import 'package:tugas/features/favorites/presentation/cubit/Favorites/favorites_cubit.dart';

class DetailProduct extends StatefulWidget {
  const DetailProduct({super.key, required this.product});
  final product;

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  @override
  void initState() {
    context.read<DetailProductBloc>().add(
      GetDetailProduct(idProduct: widget.product.id),
    );
    context.read<FavoritesCubit>().loadFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.title)),
      body: BlocBuilder<DetailProductBloc, DetailProductState>(
        builder: (context, state) {
          if (state is DetailProductLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is DetailProductLoaded) {
            final detailProduct = state.detailProduct;
            final size = MediaQuery.of(context).size;
            return Center(
              child: SizedBox(
                // height: 180.h,
                width: size.width - 24.w - 24.w,
                child: Column(
                  children: [
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: (size.height / 2) * 0.4,
                          child: Image.network(
                            '${detailProduct.image}',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 20.sp),
                        Text(
                          '${detailProduct.title}',
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '${detailProduct.category}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.secondaryLight,
                          ),
                        ),
                        Text(
                          '\$ ${detailProduct.price}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: AppColors.accentLight,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 4.sp),
                                Text(
                                  '${detailProduct.rating!.rate}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                BlocBuilder<FavoritesCubit, FavoritesState>(
                                  builder: (context, state) {
                                    List<int> _currentFavIds = [];
                                    if (state is FavoriteLoaded) {
                                      _currentFavIds = state.favorites;
                                    }
                                    final isFav = _currentFavIds.contains(
                                      detailProduct.id,
                                    );
                                    return InkWell(
                                      onTap: () {
                                        // Contex.add<FavoritesCubit>().
                                        context
                                            .read<FavoritesCubit>()
                                            .toggleFavorite(detailProduct);
                                      },
                                      splashColor: Colors.transparent,
                                      child: AnimatedSwitcher(
                                        duration: Duration(milliseconds: 300),
                                        child: Icon(
                                          isFav
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isFav
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(width: 10.sp),
                                Icon(
                                  Icons.add_shopping_cart,
                                  color: AppColors.secondaryLight,
                                  size: 18.sp,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20.sp),
                    Text('${state.detailProduct.description}'),
                  ],
                ),
              ),
            );
          }
          return Center(child: Text('No Data'));
        },
      ),
    );
  }
}
