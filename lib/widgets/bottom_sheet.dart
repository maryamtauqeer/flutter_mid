import 'package:flutter/material.dart';
import 'package:flutter_mid/model/product_model.dart';

class ProductDetailsBottomSheet extends StatelessWidget {
  final Products product;

  const ProductDetailsBottomSheet({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: description(product),
    );
  }

  // Widget description(Products obj) {
  //   return Container(
  //     color: Colors.white,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             SizedBox(
  //               width: 50, // Set the width of the image as needed
  //               height: 50, // Set the height of the image as needed
  //               child: Image.network(
  //                 obj.imageLink ?? '',
  //                 fit: BoxFit.cover, // Adjust the fit as needed
  //               ),
  //             ),
  //             Expanded(
  //               child: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: ListTile(
  //                   tileColor: Colors.white,
  //                   title: Text(obj.name ?? ''),
  //                   subtitle: Text(obj.description?.trim() ?? ''),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //         Row(
  //           children: [
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text('Brand: ${obj.brand ?? ''}'),
  //                   Text('Product Type: ${obj. ?? ''}'),
  //                 ],
  //               ),
  //             ),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.end,
  //                 children: [
  //                   Text('Price: \$${obj.price ?? ''}'),
  //                   Text('Rating: ${obj.rating ?? ''}'),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget description(Products obj) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: obj.images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    obj.images[index] ?? '',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          Text(
            obj.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(obj.description ?? ''),
          Text(
            '\$${obj.price ?? ''}.00',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.star,
                      color: Colors.yellow,
                      semanticLabel: 'star',
                    ),
                    onPressed: () {},
                  ),
                  Text(
                    obj.rating.toString(),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${obj.discountPercentage.toString()}%',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.discount,
                      color: Colors.lightBlue,
                      semanticLabel: 'discount',
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
