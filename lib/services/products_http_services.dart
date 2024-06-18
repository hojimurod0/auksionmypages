import 'dart:convert';

import 'package:auksion/model/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductsHttpServices {
  Future<List<Product>> getProducts() async {
    Uri url = Uri.parse(
        'https://examproject-6ab96-default-rtdb.firebaseio.com/categories.json');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Product> loadedProducts = [];
        if (data != null && data is Map<String, dynamic>) {
          if (data.containsKey('cars') && data['cars'] is List) {
            for (var item in data['cars']) {
              loadedProducts.add(Product.fromJson(item));
            }
          }

          if (data.containsKey('computer') && data['computer'] is List) {
            for (var item in data['computer']) {
              loadedProducts.add(Product.fromJson(item));
            }
          }

          if (data.containsKey('uylar') &&
              data['uylar'] is Map<String, dynamic>) {
            var uylarData = data['uylar'];
            if (uylarData.containsKey('0') &&
                uylarData['0'] is Map<String, dynamic>) {
              var item = uylarData['0'];
              item['id'] = '0';
              loadedProducts.add(Product.fromJson(item));
            }
            if (uylarData.containsKey('images') &&
                uylarData['images'] is List) {
              var images = uylarData['images'];

              if (loadedProducts.isNotEmpty) {
                loadedProducts.last.images = images;
              }
            }
          }
        }
        return loadedProducts;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }
}
