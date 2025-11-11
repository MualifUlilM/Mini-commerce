import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'package:tugas/features/products/data/models/product_model.dart';

class ApiService {
  final http.Client client;

  ApiService({required this.client});

  Future<Either<String, List<ProductModel>>> getAllProduct() async {
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
}
