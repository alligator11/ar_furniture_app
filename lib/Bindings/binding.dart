import 'package:get/get.dart';
import 'package:ar_furniture_app/Controller/ProductController.dart';
import 'package:ar_furniture_app/Controller/AuthController.dart';
import 'package:ar_furniture_app/Controller/CartController.dart';
import 'package:get/get_core/src/get_main.dart';

class defaultBinding extends Bindings{
  @override
  void dependencies(){
    Get.put<ProductController>(ProductController());
    Get.put<AuthController>(AuthController());
    Get.put<CartController>(CartController());
  }
}