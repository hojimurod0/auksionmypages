import 'package:auksion/model/product.dart';
import 'package:auksion/services/products_http_services.dart';

class ProductsController {
  final productsHttpServices = ProductsHttpServices();

  List<Product> _list = [];

  Future<List<Product>> get list async {
    _list = await productsHttpServices.getProducts();
    return [..._list];
  }
}
