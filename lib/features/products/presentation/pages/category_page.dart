import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tugas/core/theme/app_colors.dart';
import 'package:tugas/features/products/presentation/bloc/category/category_product_bloc.dart';
import 'package:tugas/features/favorites/presentation/cubit/Favorites/favorites_cubit.dart';
import 'package:tugas/features/products/presentation/pages/detail_product.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key, required this.categoryName});
  final String categoryName;
  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    context.read<CategoryProductBloc>().add(
      GetCategoryProductEvent(categoryName: widget.categoryName),
    );
    context.read<FavoritesCubit>().loadFavorites();
    super.initState();
  }

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: BlocBuilder<CategoryProductBloc, CategoryProductState>(
        builder: (context, state) {
          if (state is CategoryProductLoading) {
            return skeletonProductCategoryLoading(context, size);
          }
          if (state is CategoryProductLoaded) {
            return Padding(
              padding: EdgeInsets.only(
                right: 24.sp,
                left: 24.sp,
                // bottom: 16.sp,
              ),
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<CategoryProductBloc>().add(
                    GetCategoryProductEvent(categoryName: widget.categoryName),
                  );
                },
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: size.height / 3,
                    mainAxisSpacing:
                        10.0, // Space between items along the main axis
                    crossAxisSpacing: 10.0,
                  ),
                  itemCount: state.categoryProduct.length,
                  itemBuilder: (context, index) {
                    final product = state.categoryProduct[index];
                    print('fav from category ${state.favorites}');
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return DetailProduct(product: product);
                                },
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: (size.height / 2) * 0.4,
                                child: Image.network(
                                  '${product.image}',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text(
                                '${product.title}',
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: isDark
                                      ? AppColors.primaryDark
                                      : AppColors.primaryLight,
                                ),
                              ),
                              Text(
                                '${product.category}',
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: isDark
                                      ? AppColors.secondaryDark
                                      : AppColors.secondaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Text(
                          '\$ ${product.price}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: isDark
                                ? AppColors.accentDark
                                : AppColors.accentLight,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 20),
                                SizedBox(width: 4),
                                Text(
                                  '${product.rating!.rate}',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.primaryDark
                                        : AppColors.primaryLight,
                                  ),
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
                                      product.id,
                                    );
                                    return InkWell(
                                      onTap: () {
                                        context
                                            .read<FavoritesCubit>()
                                            .toggleFavorite(product);
                                      },
                                      splashColor: Colors.transparent,
                                      radius: 200,
                                      borderRadius: BorderRadius.circular(10),
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
                                SizedBox(width: 10),
                                Icon(
                                  Icons.add_shopping_cart,
                                  color: isDark
                                      ? AppColors.secondaryDark
                                      : AppColors.secondaryLight,
                                  size: 18.sp,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          }
          return Text('No Data');
        },
      ),
    );
  }

  Skeletonizer skeletonProductCategoryLoading(BuildContext context, Size size) {
    return Skeletonizer(
      enabled: true,
      child: Padding(
        padding: EdgeInsets.only(
          right: 24.sp,
          left: 24.sp,
          // bottom: 16.sp,
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<CategoryProductBloc>().add(
              GetCategoryProductEvent(categoryName: widget.categoryName),
            );
          },
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: size.height / 3,
              mainAxisSpacing: 10.0, // Space between items along the main axis
              crossAxisSpacing: 10.0,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {},
                    child: Column(
                      children: [
                        Container(
                          height: (size.height / 2) * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        Text(
                          '{product.title}',
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '{product.category}',
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    '\$ {product.price}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: isDark
                          ? AppColors.accentDark
                          : AppColors.accentLight,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          SizedBox(width: 4),
                          Text(
                            '02',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            splashColor: Colors.transparent,
                            radius: 200,
                            borderRadius: BorderRadius.circular(10),
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              child: Icon(Icons.favorite, color: Colors.red),
                            ),
                          ),
                          SizedBox(width: 10),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
