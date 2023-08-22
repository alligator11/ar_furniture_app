//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ar_furniture_app/Controller/ProductController.dart';
import 'package:ar_furniture_app/Views/ProductDetailsPage.dart';
import 'package:ar_furniture_app/Views/cartPage.dart';
//import 'package:ar_furniture_app/Widgets/DividerHeading.dart';
//import 'package:ar_furniture_app/Widgets/ProductCard.dart';
import 'package:get/get.dart';
//import 'package:model_viewer_plus/model_viewer_plus.dart';

//import '../Widgets/NavDrawer.dart';
//import '../Widgets/SmallerDivider.dart';
//import 'ProductPageCategoryWise.dart';

class AllProducts extends StatefulWidget {
  const AllProducts({Key? key}) : super(key: key);

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  ProductController product=Get.find();


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'All Products',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600
          ),
        ),
        actions: [
          //
          IconButton(onPressed: (){
            Get.to(()=>Cart());
          }, icon: Icon(Icons.add_shopping_cart)),

        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(()=>
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: product.products.length,
                    //itemCount: product.products.length,

                    itemBuilder: (context,index)=>
                        InkWell(
                          onTap: (){
                            Get.to(()=>ProductDetails(),
                                arguments: ['${product.products[index].name}','${product.products[index].description}','${product.products[index].modelUrl}','${product.products[index].price}','${product.products[index].imageUrl}']);
                          },
                          child: Card(elevation: 8,shadowColor: Get.isDarkMode?Colors.black45:Colors.black45,margin: EdgeInsets.all(6),
                            shape:  OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.black26)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 110,
                                    width: 110,
                                    child: Image.network(product.products[index].imageUrl!),
                                    // child: ModelViewer(
                                    //   src: '${product.products[index].modelUrl}', // a bundled asset file
                                    //
                                    // ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${product.products[index].name!} \n',
                                        style: TextStyle(fontSize: 16),),
                                      Text('\Rs ${product.products[index].price.toString() } \t',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),),

                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                  )),
            ),

          ],
        ),
      ),

    );
  }
}
