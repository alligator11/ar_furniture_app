import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ar_furniture_app/Views/MainPage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/user_model.dart';
import '../Widgets/TextField.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController name=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController phone=TextEditingController();
  String selectedAge = '10-30';
  String selectedGender = 'Male';
  late SharedPreferences _prefs;
  Future<void> _savePreferences() async {
    await _prefs.setString('selectedAge', selectedAge);
    await _prefs.setString('selectedGender', selectedGender);
  }

  final key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: Form(
        key: key,
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid.toString()).snapshots(),
          builder: (context,snapshot){

            if(snapshot.data==null){
              return Container();
            }
            name.text=snapshot.data!['name'].toString();
            email.text=snapshot.data!['email'].toString();
            phone.text=snapshot.data!['userPhone'].toString();
            // selectedAge = snapshot.data!['selectedAge'].toString();
            // selectedGender = snapshot.data!['selectedGender'].toString();
            print(snapshot.data!['name']);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(

                child: Column(
                  children: [

                    CustomTextField(
                      controllers: name,
                      labelText: 'Full Name',
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Field Required";
                        }
                      },
                    ),CustomTextField(
                      controllers: email,
                      labelText: 'Email Address',
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Field Required";
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextFormField(
                        controller: phone,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration( border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                        ),
                            filled: true,
                            labelText: 'Phone Number'
                        ),
                        autovalidateMode: AutovalidateMode.always,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Field Required";
                          }
                        },
                      ),
                    ),
                    Container(
                      width: 200,
                      child: DropdownButton<String>(
                        value: selectedAge,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedAge = newValue!;
                          });
                        },
                        items: <String>['10-30', '31-50', '50+']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 200,
                      child: DropdownButton<String>(
                        value: selectedGender,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue!;
                          });
                        },
                        items: <String>['Male', 'Female', 'Others']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(onPressed: () async{
    if (key.currentState!.validate()) {
      UserModel userModel = UserModel();
      userModel.userPhone=phone.text;
      userModel.email = email.text;
      userModel.selectedAge = selectedAge;
      userModel.selectedGender = selectedGender;
      userModel.userId = FirebaseAuth.instance.currentUser!.uid.toString();
      //userModel.address='';
      userModel.name = name.text;
      await FirebaseFirestore.instance.collection('users').doc(
          FirebaseAuth.instance.currentUser!.uid.toString()).update(
          userModel.asMap());
      _savePreferences();
      Get.snackbar('Successful', 'User Data Updated Successfully',duration: const Duration(seconds: 2),backgroundColor: Colors.green,snackPosition: SnackPosition.BOTTOM);

    }
    Get.off(MainPage());
    }, child: Text('Save Data'))
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
