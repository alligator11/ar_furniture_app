import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ViewRecommendations extends StatelessWidget{
  final File? image;

  ViewRecommendations(this.image);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Picked Image"),
        ),
        body: Center(
          child: image == null ? Text('No image selected'): Image.file(image!),
        )
      )
    );
}
}