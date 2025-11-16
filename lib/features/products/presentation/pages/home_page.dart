import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tugas/core/theme/app_colors.dart';
import 'package:tugas/features/cart/presentation/cubit/cubit/cart_cubit.dart';
import 'package:tugas/features/cart/presentation/pages/cart_page.dart';
import 'package:tugas/features/products/presentation/bloc/products/product_bloc.dart';
import 'package:tugas/features/favorites/presentation/cubit/Favorites/favorites_cubit.dart';
import 'package:tugas/features/products/presentation/cubit/categories/categories_cubit.dart';
import 'package:tugas/features/products/presentation/pages/category_page.dart';
import 'package:tugas/features/products/presentation/pages/detail_product.dart';
import 'package:tugas/features/theme/presentation/bloc/bloc/theme_switcher_bloc.dart';
import 'package:tugas/widgets/card_skeleton.dart';
import 'package:tugas/widgets/categories_skeleton_widget.dart';
import 'package:tugas/widgets/product_skeleton_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final _scrollController = ScrollController();
  @override
  void initState() {
    context.read<CategoriesCubit>().getCategories();
    context.read<ProductBloc>().add(FetchProductList());
    context.read<FavoritesCubit>().loadFavorites();
    context.read<CartCubit>().loadCartItems();

    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<ProductBloc>().add(FetchMoreProducts());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    // Ambil 90% dari max scroll
    return currentScroll >= (maxScroll * 0.9);
  }

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            context.read<ThemeSwitcherBloc>().add(ThemeSwithing());
          },
          icon: Icon(Icons.brightness_4_outlined, size: 24.sp),

          // Kontrol bawaan di IconButton
          padding: const EdgeInsets.all(10.0),
          splashRadius: 10.0,
          // highlightRadius: 50.0,
        ),

        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: Text(
            "Mini—\nCommerce",
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
              fontSize: 20.sp,
            ),
          ),
        ),

        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 24),
                child: Badge(
                  offset: Offset(0.sp, 2.sp),
                  label: Text(
                    '${state is CartLoaded ? state.idCartItems.length : 0}',
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CartPage();
                          },
                        ),
                      );
                    },
                    icon: Icon(Icons.shopping_cart_outlined, size: 24.sp),
                    // Kontrol bawaan di IconButton
                    padding: const EdgeInsets.all(6.0),
                    splashRadius: 10.0,
                    // highlightRadius: 50.0,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SearchBar(
              controller: _searchController,
              leading: Icon(Icons.search),
              padding: WidgetStateProperty.all(
                EdgeInsets.symmetric(horizontal: 20.sp),
              ),
              onChanged: (value) {
                context.read<ProductBloc>().add(SearchProduct(keyword: value));
              },
            ),
          ),
          BlocBuilder<CategoriesCubit, CategoriesState>(
            builder: (context, state) {
              if (state is CategoriesLoading) {
                return const CategoriesSkeletonWidget();
              }
              if (state is CategoriesLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    height: 60.sp,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        final categoriesProduct = state.categories[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(20.sp),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return CategoryPage(
                                      categoryName: categoriesProduct,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Chip(label: Text(categoriesProduct)),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
              return Text('No Data');
            },
          ),
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, productState) {
              if (productState is ProductLoading) {
                return Expanded(child: ProductSkeletonWidget());
              }
              if (productState is ProductLoaded) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 24.sp,
                      left: 24.sp,
                      // bottom: 16.sp,
                    ),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        _searchController.clear();
                        context.read<CategoriesCubit>().getCategories();
                        context.read<ProductBloc>().add(FetchProductList());
                      },
                      child: GridView.builder(
                        controller: _scrollController,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: size.height / 3,
                          mainAxisSpacing:
                              10.0, // Space between items along the main axis
                          crossAxisSpacing: 10.0,
                        ),
                        itemCount: productState.hasReachedMax
                            ? productState.listProduct.length
                            : productState.listProduct.length + 1,
                        itemBuilder: (context, index) {
                          // 8. LOGIKA UNTUK LOADER ATAU PRODUK
                          if (index >= productState.listProduct.length) {
                            // Ini adalah item terakhir (loader)
                            return CardSkeletonWidget();
                          }
                          // Ini adalah item produk
                          final product = productState.listProduct[index];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,

                                onDoubleTap: () {
                                  context.read<FavoritesCubit>().toggleFavorite(
                                    product,
                                  );
                                },
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
                                        product.image,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(height: 10.sp),
                                    Text(
                                      product.title,
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
                                      product.category.name,
                                      maxLines: 2,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10.sp,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 20.sp,
                                      ),
                                      SizedBox(width: 4.sp),
                                      Text(
                                        '${product.rating.rate}',
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
                                      BlocBuilder<
                                        FavoritesCubit,
                                        FavoritesState
                                      >(
                                        builder: (context, state) {
                                          List<int> currentFavIds = [];
                                          if (state is FavoriteLoaded) {
                                            currentFavIds = state.favorites;
                                          }
                                          final isFav = currentFavIds.contains(
                                            product.id,
                                          );
                                          return InkWell(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () {
                                              context
                                                  .read<FavoritesCubit>()
                                                  .toggleFavorite(product);
                                            },
                                            child: AnimatedSwitcher(
                                              duration: Duration(
                                                milliseconds: 300,
                                              ),
                                              child: Icon(
                                                isFav
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                key: ValueKey(isFav),
                                                color: isFav
                                                    ? Colors.red
                                                    : Colors.grey,
                                              ),
                                            ),
                                          );
                                        },
                                      ),

                                      SizedBox(width: 10),
                                      InkWell(
                                        onTap: () {
                                          context.read<CartCubit>().toggleCart(
                                            product.id,
                                          );
                                        },
                                        child: Icon(
                                          Icons.add_shopping_cart,
                                          // color: AppColors.secondaryLight,
                                          size: 18.sp,
                                        ),
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
              return Text('No Data');
            },
          ),
        ],
      ),
    );
  }
}
