import 'dart:convert';
import 'package:pks/pages/item_list.dart';
import 'package:pks/components/products.dart';
import 'package:pks/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../components/api_service.dart';
import '../components/card_prew.dart';

class Favourite extends StatefulWidget{
  const Favourite({super.key});
  @override
    createState()=> FavouriteState();
}
class FavouriteState extends State<Favourite> {
  List<Product> favouriteItems = [];
  int UserId=10;

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  Future<void> _fetchFavorites() async {
    try {
      ApiService apiService = ApiService();
      List<Product> products = await apiService.getFavorites(UserId);
      setState(() {
        favouriteItems = products;
      });
    } catch (e) {
      debugPrint('Error fetching favorite items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: favouriteItems.isEmpty
            ? Center(child: Text("Тут пока ничего нет (⌐■_■)"))
            : GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1.05 / 1),
          padding: const EdgeInsets.symmetric(vertical: 0),
          itemCount: favouriteItems.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: CardPreview(
                productItem: favouriteItems[index],
                isFavorite: true,
                onEdit: () {},
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ItemView(productItem: favouriteItems[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
