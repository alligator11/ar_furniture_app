import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ar_furniture_app/Controller/AuthController.dart';
import 'package:ar_furniture_app/Views/Admin_Panel/AdminPanel.dart';
import 'package:ar_furniture_app/Views/MyOrders.dart';
//import 'package:ar_furniture_app/Views/Admin_Panel/UploadData.dart';
import 'package:ar_furniture_app/Views/profile_screen.dart';
import 'package:get/get.dart';

import '../Helper/ThemeToggle.dart';

class NavDrawer extends StatelessWidget {
  AuthController auth = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // key:MainPage().drawerscaffoldkey,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text(
              'Settings',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
              // image: DecorationImage(
              //     fit: BoxFit.fill,
              //image: AssetImage('images/erp-gold.png')
              // )
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () async {
              Get.to(()=> const ProfileScreen());
            },
          ),

          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('My Orders'),
            onTap: () async {
              Get.to(() => const MyOrders());
            },
          ),
          Builder(builder: (context) {
            return ListTile(
              leading: Get.isDarkMode
                  ? Icon(Icons.light_mode)
                  : Icon(Icons.dark_mode),
              title: Get.isDarkMode ? Text('Light Mode') : Text('Dark Mode'),
              trailing: Container(height: 30, width: 40, child: themeToggle()),
            );
          }),





          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async {
              auth.logoutUser();
            },
          ),
          Builder(
              builder: (context) {
                if(FirebaseAuth.instance.currentUser!.email.toString()=='shayaniqbal515@gmail.com'){
                  return ListTile(
                    leading: Icon(Icons.person_outlined),
                    title: Text('Admin Panel'),
                    onTap: () async {
                      Get.to(() => const AdminPanel());
                    },
                  );
                }
                else{
                  return Text('');
                }
              }
          ),
        ],
      ),
    );
  }
}
