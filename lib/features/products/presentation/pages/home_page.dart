import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tugas/core/theme/app_colors.dart';
import 'package:tugas/features/products/presentation/bloc/products/product_bloc.dart';
import 'package:tugas/features/favorites/presentation/cubit/Favorites/favorites_cubit.dart';
import 'package:tugas/features/products/presentation/cubit/categories/categories_cubit.dart';
import 'package:tugas/features/products/presentation/pages/category_page.dart';
import 'package:tugas/features/products/presentation/pages/detail_product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    context.read<CategoriesCubit>().getCategories();
    context.read<ProductBloc>().add(FetchProductList());
    context.read<FavoritesCubit>().loadFavorites();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.transparent,
        // backgroundColor: Colors.amber,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: Text(
            "Mini—\nCommerce",
            textAlign: TextAlign.justify,
            style: TextStyle(color: AppColors.primaryLight),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 0),
            child: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/icons/shopping_bag.svg',
                height: 24.sp,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: IconButton(onPressed: () {}, icon: Icon(Icons.light_mode)),
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
                return skeletonCategoriesLoading();
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
                return Expanded(child: skeletonProductLoading(context, size));
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
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: size.height / 3,
                          mainAxisSpacing:
                              10.0, // Space between items along the main axis
                          crossAxisSpacing: 10.0,
                        ),
                        itemCount: productState.listProduct.length,
                        itemBuilder: (context, index) {
                          final product = productState.listProduct[index];
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
                                      style: TextStyle(fontSize: 16.sp),
                                    ),
                                    Text(
                                      product.category.name,
                                      maxLines: 2,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 10.sp),
                                    ),
                                  ],
                                ),
                              ),

                              Text(
                                '\$ ${product.price}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: AppColors.accentLight,
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
              return Text('No Data');
            },
          ),
        ],
      ),
    );
  }

  Skeletonizer skeletonProductLoading(BuildContext context, Size size) {
    return Skeletonizer(
      enabled: true,
      child: Padding(
        padding: EdgeInsets.only(right: 24.sp, left: 24.sp),
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<CategoriesCubit>().getCategories();
            context.read<ProductBloc>().add(FetchProductList());
          },
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: size.height / 3,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
            ),
            itemCount: 6, // jumlah dummy skeleton
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
                        SizedBox(height: 10.sp),
                        Text(
                          "product.title",
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        Text(
                          "product.category",
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 10.sp),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    '\$ 200',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: AppColors.accentLight,
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20.sp),
                          SizedBox(width: 4.sp),
                          Text(
                            '02',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {},
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

  Skeletonizer skeletonCategoriesLoading() {
    return Skeletonizer(
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          height: 60.sp,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            // itemCount: state.categories.length,
            itemBuilder: (context, index) {
              // final categoriesProduct = state.categories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(20.sp),
                  onTap: () {},
                  child: Chip(label: Text("loading...")),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
