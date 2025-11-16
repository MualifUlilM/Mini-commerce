import 'dart:convert';
import 'dart:developer' as DevTool;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'package:tugas/features/products/data/models/category_product_model.dart';
import 'package:tugas/features/products/data/models/product_model.dart';
import 'package:tugas/features/products/data/models/detail_product_model.dart';

class ApiService {
  final http.Client client;
  final String baseUrl = 'https://fakestoreapi.com';
  ApiService({required this.client});

  Future<Either<String, List<ProductModel>>> getPaginatedProducts({
    required int limit,
    required int offset,
  }) async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/products'));
      final List data = jsonDecode(response.body);

      final paginated = data.skip(offset).take(limit).toList();
      DevTool.log('Paginated data length: ${paginated}');
      return Right(paginated.map((x) => ProductModel.fromJson(x)).toList());
    } catch (e) {
      return Left((e).toString());
    }
  }

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

  Future<Either<String, List<CategoryProductModel>>> getProductByCategory(
    String categoryName,
  ) async {
    try {
      final response = await client.get(
        Uri.parse('https://fakestoreapi.com/products/category/$categoryName'),
      );
      return Right(
        List<CategoryProductModel>.from(
          jsonDecode(
            response.body,
          ).map((x) => CategoryProductModel.fromJson(x)).toList(),
        ),
      );
    } catch (e) {
      return Left((e).toString());
    }
  }
}
