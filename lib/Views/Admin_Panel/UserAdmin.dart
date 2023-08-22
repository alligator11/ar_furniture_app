import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ar_furniture_app/Views/Admin_Panel/AdminUserDetailsPage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UserAdmin extends StatefulWidget {
  const UserAdmin({Key? key}) : super(key: key);

  @override
  State<UserAdmin> createState() => _UserAdminState();
}

class _UserAdminState extends State<UserAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        centerTitle: true,
      ),
      body:  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context,snapshot){
          if(snapshot.data==null){
            return Container();
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data!.docs[index];
                return InkWell(
                  onTap: (){
                    Get.to(()=> const AdminUserDetailsPage(),arguments: [doc['name'],doc['email'],doc['address'],doc['userId'],doc['userPhone']]);
                  },
                  child: Card(elevation: 8,shadowColor: Get.isDarkMode?Colors.black45:Colors.black45,margin: EdgeInsets.all(6),
                      shape:  OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black26)
                      ),
                    child:Column(
                      children:[
                        Container(
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(doc['name']),
                                Text(doc['email']),
                              ],
                            ),
                          ),
                        ),

                    ])),
                );
              });
        },
      ),
    );
  }
}
