import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ar_furniture_app/Controller/ProductController.dart';
import 'package:ar_furniture_app/Views/AllProducts.dart';
import 'package:ar_furniture_app/Views/ProductDetailsPage.dart';
import 'package:ar_furniture_app/Views/cartPage.dart';
import 'package:ar_furniture_app/Widgets/DividerHeading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:ar_furniture_app/Widgets/ProductCard.dart';
import 'package:get/get.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:http/http.dart' as http;

import '../Controller/CartController.dart';
import '../Widgets/NavDrawer.dart';
import '../Widgets/SmallerDivider.dart';
import 'ProductPageCategoryWise.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ProductController product = Get.find();
  CartController cart = Get.find();
  List<dynamic> responseData = [];

  // Future<void> sendDataToApi(String furniture, int user) async {
  //   print('Sending HTTP request...');
  //   // API endpoint URL
  //   final apiUrl = 'https://color-recommendation-api.onrender.com/hybrid';
  //
  //   // Create multipart request
  //   var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
  //
  //   request.fields['furniture'] = furniture;
  //   request.fields['user_id'] = user.toString();
  //
  //   print(request.fields);
  //   // Send request
  //   http.StreamedResponse response = await request.send();
  //
  //   // Handle response
  //   if (response.statusCode == 200) {
  //     final responseBody = await response.stream.bytesToString();
  //     responseData = jsonDecode(responseBody);
  //     print(responseData);
  //   }
  //   else {
  //     print('Error: ${response.reasonPhrase}');
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // sendDataToApi("so01 so17", 0);
  }
  // initializeFirebase() async{
  //   FirebaseApp app=await Firebase.initializeApp();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: NavDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Welcome',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => Cart());
              },
              icon: Icon(Icons.add_shopping_cart)),
          Builder(builder: (context) {
            return IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          })
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Future.delayed(Duration(seconds: 2), () async {
          //   await product.catGet();
          //
          //   print(product.categories);
          // });
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SmallerDividerHeading(
              //   heading: 'Featured Products',
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() => ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: product.products.length > 6
                          ? 6
                          : product.products.length,
                      //itemCount: product.products.length,

                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          Get.to(() => ProductDetails(), arguments: [
                            '${product.products[index].name}',
                            '${product.products[index].description}',
                            '${product.products[index].modelUrl}',
                            '${product.products[index].price}',
                            '${product.products[index].imageUrl}'
                          ]);
                        },
                        child: Card(
                          elevation: 8,
                          shadowColor:
                              Get.isDarkMode ? Colors.black45 : Colors.black45,
                          margin: EdgeInsets.all(6),
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.black26)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 110,
                                  width: 110,
                                  child: Image.network(
                                      product.products[index].imageUrl!),
                                  // child: ModelViewer(
                                  //       src: '${product.products[index].modelUrl}', // a bundled asset file
                                  //
                                  //   ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${product.products[index].name!} \n',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '\Rs ${product.products[index].price.toString()} \t',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 28.0, top: 10),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      Get.to(() => AllProducts());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'See All Products',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded)
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
// Future<RxList> catGet(){
//   for(int i=0;i<product.products.length;i++){
//
//   var contain = product.categories.where((element) => element['Category'] == "${product.products[i].category.toString()}");
//   if(contain.isEmpty){
//     Map catMap={
//       'Category':product.products[i].category,
//       'imageUrl':product.products[i].imageUrl
//     };product.categories.add(catMap);
//   }
//
// }
//   return Future(() => product.categories);
// }
}






// class _MainPageState extends State<MainPage> {
//   ProductController product = Get.find();
//   CartController cart = Get.find();
//   List<dynamic> responseData = [];
//
//   Future<void> fetchDataFromApi() async {
//     print('Sending HTTP request...');
//     // API endpoint URL
//     final apiUrl = 'https://color-recommendation-api.onrender.com/hybrid';
//
//     // Send request
//     http.Response response = await http.post(Uri.parse(apiUrl), body: {
//       'furniture': "so01 so17",
//       'user_id': "0",
//     });
//
//     // Handle response
//     if (response.statusCode == 200) {
//       responseData = jsonDecode(response.body);
//       print(responseData);
//       setState(() {}); // Trigger a rebuild after data is fetched
//     } else {
//       print('Error: ${response.reasonPhrase}');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchDataFromApi();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       endDrawer: NavDrawer(),
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text(
//           'Welcome',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Get.to(() => Cart());
//               },
//               icon: Icon(Icons.add_shopping_cart)),
//           Builder(builder: (context) {
//             return IconButton(
//               icon: Icon(Icons.settings),
//               onPressed: () {
//                 Scaffold.of(context).openEndDrawer();
//               },
//               tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
//             );
//           })
//         ],
//       ),
//       // Your existing scaffold code here...
//       body: RefreshIndicator(
//         onRefresh: () async {
//           // Fetch data again on refresh
//           await fetchDataFromApi();
//         },
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               // Your existing code for app bar, drawer, etc.
//               SmallerDividerHeading(
//                 heading: 'Featured Products',
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: responseData.length,
//                   itemBuilder: (context, index) {
//                     var item = responseData[index];
//                     return InkWell(
//                       onTap: () {
//                         // Navigate to product details page
//                       },
//                       child: Card(
//                         elevation: 8,
//                         shadowColor: Get.isDarkMode ? Colors.black45 : Colors.black45,
//                         margin: EdgeInsets.all(6),
//                         shape: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide(color: Colors.black26),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Container(
//                                 height: 110,
//                                 width: 110,
//                                 child: Image.network(item['image link']),
//                               ),
//                               SizedBox(width: 10),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     item['product name'],
//                                     style: TextStyle(fontSize: 16),
//                                   ),
//                                   Text(
//                                     'Rs ${item['price'].toString()}',
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.green,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 28.0, top: 10),
//                 child: Center(
//                   child: InkWell(
//                     onTap: () {
//                       Get.to(() => AllProducts());
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           'See All Products',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Icon(Icons.arrow_forward_ios_rounded),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

