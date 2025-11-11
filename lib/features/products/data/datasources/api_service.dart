import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'package:tugas/features/products/data/models/product_model.dart';
import 'package:tugas/features/products/data/models/detail_product_model.dart';
import 'package:tugas/features/products/presentation/pages/detail_product.dart';

class ApiService {
  final http.Client client;

  ApiService({required this.client});

  Future<Either<String, List<ProductModel>>> getAllProducts() async {
    try {
      final response = await client.get(
        Uri.parse('https://fakestoreapi.com/products'),
      );
      return Right(
        List<ProductModel>.from(
          jsonDecode(
            response.body,
          ).map((x) => ProductModel.fromJson(x)).toList(),
        ),
      );
    } catch (e) {
      return Left((e).toString());
    }
  }

  Future<Either<String, ProductDetailModel>> getProduct(int idProduct) async {
    try {
      final response = await client.get(
        Uri.parse('https://fakestoreapi.com/products/$idProduct'),
      );
      return Right(ProductDetailModel.fromJson(jsonDecode(response.body)));
    } catch (e) {
      return Left((e).toString());
    }
  }

  Future<Either<String, List<String>>> getCategories() async {
    try {
      final response = await client.get(
        Uri.parse('https://fakestoreapi.com/products/categories'),
      );
      return Right(List<String>.from(jsonDecode(response.body)));
    } catch (e) {
      return Left((e).toString());
    }
  }
}
