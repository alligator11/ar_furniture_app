import 'package:flutter/material.dart';
import 'package:ar_furniture_app/Controller/CartController.dart';
import 'package:ar_furniture_app/Controller/ProductController.dart';
// import 'package:ar_furniture_app/Widgets/ModelView.dart';
import 'package:get/get.dart';
// import 'package:model_viewer_plus/model_viewer_plus.dart';

import 'package:ar_furniture_app/Views/LocalAndWebObjectsView.dart';

//import 'CheckOut.dart';
import 'cartPage.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({Key? key}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  ProductController product = Get.find();
  CartController cart = Get.find();
  var arguments = Get.arguments;
  var buyNow = false;

  @override
  void initState() {
    super.initState();
    product.prodName.value = arguments[0];
    product.prodDesc.value = arguments[1];
    product.prodModelUrl.value = arguments[2];
    product.prodPrice.value = arguments[3];
    product.prodImageUrl.value = arguments[4];
    cart.cartLen.value = cart.cartList.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.41,
                child: Stack(alignment: Alignment.topRight, children: [
                  Container(
                    // height: 110,
                    // width: 110,
                    child: Image.network(
                        product.prodImageUrl.value),
                    // child: ModelViewer(
                    //       src: '${product.products[index].modelUrl}', // a bundled asset file
                    //
                    //   ),
                  ),
                  // ModelViewer(
                  //   // backgroundColor: Get.isDarkMode?Colors.:Colors.white12,
                  //   src: product.prodModelUrl.value,
                  //   // a bundled asset file
                  //   ar: true,
                  //   arPlacement: ArPlacement.floor,
                  //   autoRotate: true,
                  //   cameraControls: true,
                  // ),

                  // ModelView(url: product.prodModelUrl.value),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(Icons.arrow_back_ios)),
                        ElevatedButton.icon(
                            onPressed: () {
                              Get.to(() => const Cart());
                            },
                            icon: const Icon(Icons.add_shopping_cart),
                            label: Builder(builder: (context) {
                              return Obx(() => Text('${cart.cartLen}'));
                            })
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LocalAndWebObjectsView(prodModelUrl: product.prodModelUrl.value)));
                            },
                            child: const Text("View in AR")),
                      ],
                    ),
                  )
                ]),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0)),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${product.prodName.value}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${product.prodPrice.value}',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Description:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.32,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${product.prodDesc}',
                                  textAlign: TextAlign.left, // Ensure left alignment
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                var contain = cart.cartList.where((element) =>
                                element['modelUrl'] ==
                                    "${product.prodModelUrl.value}");
                                if (contain.isNotEmpty) {
                                  Get.snackbar("Can't add item",
                                      'Item already exists in cart',
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: Colors.red,
                                      snackPosition: SnackPosition.BOTTOM);
                                } else {
                                  cart.addToCart(
                                      product.prodName.value,
                                      double.parse(product.prodPrice.value),
                                      product.prodModelUrl.value,
                                      product.prodImageUrl.value);
                                  cart.quantity.add(TextEditingController());
                                  Get.snackbar(
                                      'Successful', 'Item Added Successfully',
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: Colors.green,
                                      snackPosition: SnackPosition.BOTTOM);
                                }
                              },
                              child: Text('ADD TO CART'),
                            ),
                            // Add your commented TextButton code here
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
