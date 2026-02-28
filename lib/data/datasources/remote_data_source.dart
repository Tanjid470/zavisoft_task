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

  // Helper to safely extract string values
  String _safeString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  // Build a normalized user map that matches UserModel fields
  Map<String, dynamic> _normalizeUserMap(Map<String, dynamic> raw) {
    final name = raw['name'];
    String firstName = '';
    String lastName = '';
    if (name is Map<String, dynamic>) {
      firstName = _safeString(name['firstname'] ?? name['firstName']);
      lastName = _safeString(name['lastname'] ?? name['lastName']);
    } else {
      // some APIs might provide flat fields
      firstName = _safeString(raw['firstName']);
      lastName = _safeString(raw['lastName']);
    }

    return {
      'id': raw['id'] ?? 0,
      'username': _safeString(raw['username']),
      'email': _safeString(raw['email']),
      'firstName': firstName,
      'lastName': lastName,
      'phone': _safeString(raw['phone']),
    };
  }

  @override
  Future<UserModel> getUserById(int userId) async {
    final response = await client
        .get(Uri.parse(
            '${ApiConstants.baseUrl}${ApiConstants.usersEndpoint}/$userId'))
        .timeout(ApiConstants.connectionTimeout);

    if (response.statusCode == 200) {
      final raw = jsonDecode(response.body);
      if (raw is Map<String, dynamic>) {
        final normalized = _normalizeUserMap(raw);
        return UserModel.fromJson(normalized);
      }
      throw Exception('Unexpected user format');
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
      return json.map((item) {
        if (item is Map<String, dynamic>) {
          final normalized = _normalizeUserMap(item);
          return UserModel.fromJson(normalized);
        }
        // If the item isn't a map, attempt to convert to string map defensively
        return UserModel.fromJson({
          'id': 0,
          'username': '',
          'email': '',
          'firstName': '',
          'lastName': '',
          'phone': '',
        });
      }).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
