import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constants/api_constants.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

abstract class RemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<List<ProductModel>> getProductsByCategory(String category);
  Future<List<String>> getCategories();
  Future<UserModel> getUserById(int userId);
  Future<List<UserModel>> getAllUsers();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await client
        .get(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}'))
        .timeout(ApiConstants.connectionTimeout);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body) as List<dynamic>;
      return json
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final response = await client
        .get(Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/category/$category'))
        .timeout(ApiConstants.connectionTimeout);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body) as List<dynamic>;
      return json
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load products by category');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    final response = await client
        .get(Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.categoriesEndpoint}'))
        .timeout(ApiConstants.connectionTimeout);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body) as List<dynamic>;
      return json.map((item) => item.toString()).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Future<UserModel> getUserById(int userId) async {
    final response = await client
        .get(Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}/$userId'))
        .timeout(ApiConstants.connectionTimeout);

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load user');
    }
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final response = await client
        .get(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}'))
        .timeout(ApiConstants.connectionTimeout);

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body) as List<dynamic>;
      return json
          .map((item) => UserModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
