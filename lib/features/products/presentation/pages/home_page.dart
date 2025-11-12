import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tugas/core/constants/app_colors.dart';
import 'package:tugas/features/products/presentation/bloc/products/product_bloc.dart';
import 'package:tugas/features/products/presentation/cubit/categories/categories_cubit.dart';
import 'package:tugas/features/products/presentation/pages/category_page.dart';
import 'package:tugas/features/products/presentation/pages/detail_product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<CategoriesCubit>().getCategories();
    context.read<ProductBloc>().add(FetchProductList());
    super.initState();
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
            style: TextStyle(color: AppColors.primary),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                'assets/icons/shopping_bag.svg',
                height: 24.sp,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SearchBar(
              leading: Icon(Icons.search),
              padding: WidgetStateProperty.all(
                EdgeInsets.symmetric(horizontal: 20),
              ),
              onChanged: (value) {
                context.read<ProductBloc>().add(SearchProduct(keyword: value));
              },
            ),
          ),
          BlocBuilder<CategoriesCubit, CategoriesState>(
            builder: (context, state) {
              if (state is CategoriesLoading) {
                // return Center(child: CircularProgressIndicator());
                return Text('');
              }
              if (state is CategoriesLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        final categoriesProduct = state.categories[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: InkWell(
                            splashColor: Colors.transparent,
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
            builder: (context, state) {
              if (state is ProductLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is ProductLoaded) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 24.sp,
                      left: 24.sp,
                      // bottom: 16.sp,
                    ),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: size.height / 3,
                        mainAxisSpacing:
                            10.0, // Space between items along the main axis
                        crossAxisSpacing: 10.0,
                      ),
                      itemCount: state.listProduct.length,
                      itemBuilder: (context, index) {
                        final product = state.listProduct[index];
                        return InkWell(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: SizedBox(
                                  height: (size.height / 2) * 0.4,
                                  child: Image.network(
                                    product.image,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Text(
                                product.title,
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                product.category.name,
                                maxLines: 2,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 10),
                              ),
                              Text(
                                '\$ ${product.price}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.accent,
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
                                        size: 20,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '${product.rating.rate}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
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
                                        child: Icon(
                                          Icons.favorite_border,
                                          color: Colors.red,
                                          size: 18.sp,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(
                                        Icons.add_shopping_cart,
                                        color: AppColors.secondary,
                                        size: 18.sp,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
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
        ],
      ),
    );
  }
}
