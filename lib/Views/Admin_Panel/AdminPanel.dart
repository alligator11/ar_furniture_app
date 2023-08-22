
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ar_furniture_app/Views/Admin_Panel/OrderAdmin.dart';
import 'package:ar_furniture_app/Views/Admin_Panel/ProductsAdmin.dart';
import 'package:get/get.dart';

import 'UserAdmin.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
   var orderCount='0'.obs;
   var userCount='0'.obs;
   var productCount='0'.obs;
  @override
  fetchCount() async{

    QuerySnapshot productCollection = await
    FirebaseFirestore.instance.collection('products').get();
    productCount.value = productCollection.size.toString();
    QuerySnapshot userCollections = await
    FirebaseFirestore.instance.collection('users').get();
    userCount.value = userCollections.size.toString();
    QuerySnapshot orderCollections = await
    FirebaseFirestore.instance.collection('Orders').get();
    orderCount.value = orderCollections.size.toString();
  }
  void initState() {
    super.initState();

   fetchCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Container( height: MediaQuery.of(context).size.height*0.15,
                  width: MediaQuery.of(context).size.width*0.31,
                  child: InkWell(onTap: (){Get.to(()=>UserAdmin());},
                    child: Card(elevation: 8,shadowColor: Get.isDarkMode?Colors.black45:Colors.black45,margin: EdgeInsets.all(6),
                      shape:  OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black26)
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Users',style: TextStyle(
                                fontSize: 16
                            ),),
                          ),
                          Obx(()=> Text('$userCount',style: TextStyle(
                              fontSize: 22,
                            color: Colors.green
                          ),))
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height*0.15,
                  width: MediaQuery.of(context).size.width*0.31,
                  child: InkWell(onTap: (){Get.to(()=>ProductsAdmin());},
                    child: Card(elevation: 8,shadowColor: Get.isDarkMode?Colors.black45:Colors.black45,margin: EdgeInsets.all(6),
                      shape:  OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black26)
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Products',style: TextStyle(
                              fontSize: 16
                            ),),
                          ),
                          Obx(()=> Text('$productCount',style: TextStyle(
                              fontSize: 22,
                            color: Colors.green
                          ),))
                        ],
                      ),
                    ),
                  ),
                ),
                Container( height: MediaQuery.of(context).size.height*0.15,
                  width: MediaQuery.of(context).size.width*0.31,
                  child: InkWell(
                    onTap: (){Get.to(()=>OrderAdmin());},
                    child: Card(elevation: 8,shadowColor: Get.isDarkMode?Colors.black45:Colors.black45,margin: EdgeInsets.all(6),
                      shape:  OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black26)
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Orders',style: TextStyle(
                                fontSize: 16
                            ),),
                          ),
                          Obx(()=> Text('$orderCount',style: TextStyle(
                              fontSize: 22,
                          color: Colors.green),))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
