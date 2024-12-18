import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pks/components/products.dart';

import 'api_service.dart';

class CardPreview extends StatefulWidget {
  const CardPreview({
    Key? key,
    required this.productItem,
    required this.isFavorite,
    required this.onEdit,
  }) : super(key: key);

  final Product productItem;
  final bool isFavorite;
  final VoidCallback onEdit;

  @override
  _CardPreviewState createState() => _CardPreviewState();
}

class _CardPreviewState extends State<CardPreview> {
  late bool isFavorite;
  final ApiService _apiService = ApiService();
  final int userId = 10;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
    _checkIfFavorite();
  }
  Future<void> _checkIfFavorite() async {
    try {
      // Получаем список избранных товаров
      List<Product> favoriteProducts = await _apiService.getFavorites(userId);

      // Проверяем, есть ли текущий товар в списке избранных
      setState(() {
        isFavorite = favoriteProducts.any((product) => product.id == widget.productItem.id);
      });
    } catch (e) {
      debugPrint('Error checking favorite status: $e');

    }
  }
  // Добавление товара в избранное через API
  Future<void> _addToFavorites() async {
    try {
      await _apiService.addToFavorites(widget.productItem.id, userId);
      setState(() {
        isFavorite = true;
      });
      debugPrint('Product added to favorites');
    } catch (e) {
      debugPrint('Error adding to favorites: $e');
    }
  }

  // Удаление товара из избранного через API
  Future<void> _removeFromFavorites() async {
    try {
      await _apiService.removeFromFavorites(widget.productItem.id, userId);
      setState(() {
        isFavorite = false;
      });
      debugPrint('Product removed from favorites');
    } catch (e) {
      debugPrint('Error removing from favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child:  Image.network(
                  widget.productItem.img,
                  height: 100,
                  width:150,
                  fit: BoxFit.fill,
                )
              ),
              Text(
                widget.productItem.Name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Flexible(
                child: Text(
                  widget.productItem.Description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Positioned(
            left: 8,
            top: 8,
            child: GestureDetector(
              onTap: () {
                debugPrint('Edit icon tapped for ${widget.productItem.Name}');
                widget.onEdit();
              },
              child: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isFavorite) {
                    _removeFromFavorites();
                  } else {
                    _addToFavorites();
                  }

                });
                debugPrint(
                    'Heart icon tapped for ${widget.productItem.Name}, favorite: $isFavorite');
              },
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
