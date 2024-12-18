import 'package:dio/dio.dart';
import 'package:pks/components/products.dart';

class ApiService {
  final Dio _dio = Dio();
  final String BaseURL = 'http://192.168.1.2:8080'; // Поменять в случае смены сети
  final int userId = 10;

  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get('$BaseURL/products');
      if (response.statusCode == 200) {
        List<Product> products = (response.data as List)
            .map((product) => Product.fromJson(product))
            .toList();
        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  Future<void> createProduct(Product product) async {
    try {
      final response = await _dio.post(
        '$BaseURL/products',
        data: product.toJson(),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to create product');
      }
    } catch (e) {
      throw Exception('Error creating product: $e');
    }
  }

  Future<void> updateProduct(int id, Product product) async {
    try {
      final response = await _dio.put(
        '$BaseURL/products/$id',
        data: product.toJson(),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update product');
      }
    } catch (e) {
      throw Exception('Error updating product: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final response = await _dio.delete(
        '$BaseURL/products/$id',
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete product');
      }
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }

  // Работа с избранным
  Future<List<Product>> getFavorites(int userId) async {
    try {
      // Получаем список избранных ID
      final response = await _dio.get('$BaseURL/favorites/$userId');
      if (response.statusCode == 200) {
        List<dynamic> favoriteIds = response.data;

        // Для каждого ID получаем данные о товаре
        List<Product> favoriteProducts = [];
        for (var favorite in favoriteIds) {
          int productId = favorite['product_id'];
          final productResponse =
          await _dio.get('$BaseURL/products/$productId');
          if (productResponse.statusCode == 200) {
            favoriteProducts.add(Product.fromJson(productResponse.data));
          }
        }
        return favoriteProducts;
      } else {
        throw Exception('Failed to load favorites');
      }
    } catch (e) {
      throw Exception('Error fetching favorites: $e');
    }
  }

  Future<void> addToFavorites(int productId, int id) async {
    try {
      final response = await _dio.post(
        '$BaseURL/favorites/$userId',
        data: {'product_id': productId},
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to add to favorites');
      }
    } catch (e) {
      throw Exception('Error adding to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(int productId, int id) async {
    try {
      final response = await _dio.delete(
        '$BaseURL/favorites/$userId/$productId',
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to remove from favorites');
      }
    } catch (e) {
      throw Exception('Error removing from favorites: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getCart(int userId) async {
    try {
      final response = await _dio.get('$BaseURL/carts/$userId');
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Не удалось загрузить корзину');
      }
    } catch (e) {
      throw Exception('Ошибка при загрузке корзины: $e');
    }
  }

  Future<List<Product>> getProductsByIds(List<int> productIds) async {
    try {
      List<Product> products = [];
      for (var productId in productIds) {
        final response = await _dio.get('$BaseURL/products/$productId');
        if (response.statusCode == 200) {
          products.add(Product.fromJson(response.data));
        } else {
          throw Exception('Не удалось загрузить продукт с id $productId');
        }
      }
      return products;
    } catch (e) {
      throw Exception('Ошибка при загрузке продуктов: $e');
    }
  }


  Future<void> addToCart(int productId, int userId) async {
    try {
      final response = await _dio.post(
        '$BaseURL/carts/$userId',
        data: {'product_id': productId, 'quantity':1},
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to add to cart');
      }
    } catch (e) {
      throw Exception('Error adding to cart: $e');
    }
  }

  Future<void> removeFromCart(int productId, int userId) async {
    try {
      final response = await _dio.delete(
        '$BaseURL/carts/$userId/$productId',
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to remove from cart');
      }
    } catch (e) {
      throw Exception('Error removing from cart: $e');
    }
  }

  Future<void> updateCart(int userId, int productId, int quantity) async {
    try {
      final data = {
        'product_id': productId,
        'quantity': quantity,
      };

      final response = await Dio().put(
        '$BaseURL/carts/$userId',
        data: data,
      );

      print('Ответ от сервера: ${response.data}');
    } catch (e) {
      if (e is DioException) {
        print('Ошибка запроса: ${e.response?.data}');
      } else {
        print('Ошибка обновления корзины: $e');
      }
    }
  }
}