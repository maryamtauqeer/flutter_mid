import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mid/model/product_model.dart';
import 'package:flutter_mid/widgets/bottom_sheet.dart';
import 'package:http/http.dart' as http;

class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Products',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Center(
            child: FutureBuilder<List<Products>>(
                future: fetchProducts(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (contxt, i) {
                        var item = snapshot.data![i];
                        return productListItem(item);
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Text("Error");
                  }

                  return const CircularProgressIndicator(
                    color: Color.fromARGB(255, 3, 100, 90),
                  );
                })));
  }

  Widget productListItem(Products obj) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
            child: Image.network(
              obj.thumbnail ?? '',
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                shortenName(obj.title, nameLimit: 20),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    obj.price.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 13,
                  ),
                  const Text(
                    'USD',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.remove_red_eye_sharp,
                      semanticLabel: 'eye',
                    ),
                    onPressed: () {
                      print('Eye button');
                      showModalBottomSheet<void>(
                        context: context,
                        // isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Wrap(
                            children: <Widget>[
                              Material(
                                color: Colors.transparent,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Container(
                                    color: Colors.white,
                                    width: MediaQuery.of(context).size.width,
                                    child:
                                        ProductDetailsBottomSheet(product: obj),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          Text(obj.description ?? ''),
        ],
      ),
    );
  }
}

// Widget productListItem(Products obj) {
//   return Card(
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(8.0),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(8.0),
//             topRight: Radius.circular(8.0),
//           ),
//           child: Image.network(
//             obj.thumbnail ?? '',
//             fit: BoxFit.cover,
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               shortenName(obj.title, nameLimit: 20),
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             Row(
//               children: [
//                 Text(
//                   obj.price.toString(),
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(
//                   width: 5, // Adjust the width to your desired spacing
//                 ),
//                 Text(
//                   'USD',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 IconButton(
//                   icon: const Icon(
//                     Icons.remove_red_eye_sharp,
//                     semanticLabel: 'eye',
//                   ),
//                   onPressed: () {
//                     print('Eye button');
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//         Text(obj.description ?? ''),
//       ],
//     ),
//   );
// }

// taken from stack overflow
String shortenName(String nameRaw, {int nameLimit = 10, bool addDots = false}) {
  //* Limiting val should not be gt input length (.substring range issue)
  final max = nameLimit < nameRaw.length ? nameLimit : nameRaw.length;
  //* Get short name
  final name = nameRaw.substring(0, max);
  //* Return with '..' if input string was sliced
  if (addDots && nameRaw.length > max) return name + '..';
  return name;
}

Future<List<Products>> fetchProducts() async {
  final response = await http.get(Uri.parse('https://dummyjson.com/products'));

  if (response.statusCode == 200) {
    Map<String, dynamic> _parsedJson = jsonDecode(response.body);
    if (_parsedJson.containsKey('products')) {
      List<dynamic> productListJson = _parsedJson['products'];
      List<Products> _itemsList = productListJson
          .map((json) => Products.fromJson(json))
          .cast<Products>()
          .toList();
      return _itemsList;
    } else {
      throw Exception('Products key not found in the JSON response');
    }
  } else {
    throw Exception('Failed to load Products');
  }
}
