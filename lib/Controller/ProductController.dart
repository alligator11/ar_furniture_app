import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../Models/ProductModel.dart';
import '../Views/ProductPageCategoryWise.dart';

class ProductController extends GetxController{
  FirebaseFirestore fireStore=FirebaseFirestore.instance;
  late CollectionReference collectionReference;
  TextEditingController name=new TextEditingController();
  TextEditingController category=new TextEditingController();
  TextEditingController modelUrl=new TextEditingController();
  TextEditingController description=new TextEditingController();
  TextEditingController price=new TextEditingController();
  RxList<ProductModel> products=RxList<ProductModel>([]);
  RxBool addCat = false.obs;
  var prodName=''.obs;
  var prodDesc=''.obs;
  var prodImageUrl=''.obs;
  var prodModelUrl=''.obs;
  var prodPrice=''.obs;
  RxList categories=[].obs;
  RxBool catFetch=false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    print("ProductController Initialized");

    collectionReference=fireStore.collection('products');
    products.bindStream(getAllProducts());
    // Future.delayed(Duration(seconds: 2), () async{
    //   await catGet();
    //   catFetch.value=true;
    //   print("Category Fetch Status: ${catFetch.value}");
    // });
    // var result=await catGet();
    // print(result);
  }

  Stream<List<ProductModel>> getAllProducts() {
    return collectionReference.snapshots().map((query) {
      print('Received Firestore query snapshot: $query'); // Debug print
      return query.docs.map((item) {
        print('Processing document data: ${item.data()}'); // Debug print
        return ProductModel.fromMap(item);
      }).toList();
    });
  }


  // Future<List> catGet(){
  //   print("Fetching Categories...");
  //   for(int i=0;i<products.value.length;i++){
  //     var contain = categories.value.where((element) => element['Category'] == products.value[i].category.toString());
  //     if(contain.isEmpty){
  //       Map catMap={
  //         'Category':products.value[i].category,
  //         'imageUrl':products.value[i].imageUrl
  //       };
  //       categories.value.add(catMap);
  //     }
  //   }
  //   print("Categories Fetched: ${categories.length}");
  //   return Future.value(categories);
  // }

  // Future<void> addProduct(String imageUrl) {
  //   print("Adding Product...");
  //   var productId=const Uuid().v1();
  //   final data = {
  //     'name': name.text,
  //     'description': description.text,
  //     'modelUrl': modelUrl.text,
  //     'category':category.text,
  //     'price':price.text,
  //     'productId': productId,
  //     'imageUrl':imageUrl,
  //   };
  //   return collectionReference.doc(productId)
  //   //adding to firebase collection
  //       .set(data)
  //       .then((value) => Get.snackbar('Success', 'Product Added Successfully',backgroundColor: Colors.green))
  //       .catchError((error) =>Get.snackbar('Error', '$error',backgroundColor: Colors.red));
  // }
}
