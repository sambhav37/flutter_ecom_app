import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product.dart';

import 'package:provider/provider.dart';
import './product_item.dart';

import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {

  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    // we want to set connection to the provider that provides intsnace of Product class
    // this like will look at parent Products grid, no product, then the above parent
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favouriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // create: (c) => products[i],
        value: products[i],
        child: ProductItem(
          // products[i].id,
          // products[i].title,
          // products[i].imageUrl,
        ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
