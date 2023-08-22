import 'package:flutter/material.dart';
import 'package:ar_furniture_app/Widgets/ModelView.dart';
import 'package:get/get.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';


class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({Key? key}) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  var args= Get.arguments;
  @override
  Widget build(BuildContext context) {
    print(args.length);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details Page'),
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: args.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 8,shadowColor: Get.isDarkMode?Colors.black45:Colors.black45,margin: EdgeInsets.all(6),
              shape:  OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.black26)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                        child:Image.network(args[index]['imageUrl'].toString()),
                      // child: ModelViewer(
                      //   src: args[index]['modelUrl'],
                      // ),
                    ),
                    Text(args[index]['name'].toString(),style: TextStyle(fontSize: 18)),
                    Text(args[index]['price'].toString(),style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),

            );
          }),
    );
  }
}
