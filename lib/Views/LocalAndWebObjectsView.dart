import 'dart:convert';
import 'dart:io';

import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vector_math/vector_math_64.dart';
import 'ViewRecommendations.dart';
import 'package:http/http.dart' as http;

class LocalAndWebObjectsView extends StatefulWidget {
  const LocalAndWebObjectsView({Key? key}) : super(key: key);
  @override
  State<LocalAndWebObjectsView> createState() => _LocalAndWebObjectsViewState();
}

class _LocalAndWebObjectsViewState extends State<LocalAndWebObjectsView> {
  XFile? image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickerImage = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickerImage != null) {
        image = XFile(pickerImage.path);
      }
      else {
        print("no image selected");
      }
    });
  }

  Future<void> sendImageToApi(XFile imageFile, int length, int breadth, int height, String category) async {
    print('Sending HTTP request...');
    // API endpoint URL
    final apiUrl = 'https://color-recommendation-api.onrender.com/recommend';

    // Create multipart request
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    request.fields['length'] = length.toString();
    request.fields['breath'] = breadth.toString();
    request.fields['height'] = height.toString();
    request.fields['category'] = category;

    print(request.fields);
    print(request.files);

    // Send request
    http.StreamedResponse response = await request.send();

    // Handle response
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      List<dynamic> responseData = jsonDecode(responseBody);
      // double accuracy = responseData['accuracy'] ?? 0.0; // Assuming default value is 0.0
      // String wasteMaterial = responseData['waste_material'] ?? ''; // Assuming default value is an empty string

      // setState(() {
      //   resultAccuracy = accuracy.toString(); // Convert double to string
      //   resultWasteMaterial = wasteMaterial;
      // });
      // print('Accuracy: $resultAccuracy');
      // print('Waste Material: $resultWasteMaterial');
      print(responseData);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewRecommendations(responseData),
        ),
      );
    }
    else {
      print('Error: ${response.reasonPhrase}');
      // setState(() {
      //   resultAccuracy = null;
      //   resultWasteMaterial = null;
      // });
    }
  }

  Future<void> _uploadFiles() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = pickedFile;
      });
    }
  }

  // Future<void> _takePicture() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.camera);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = pickedFile;
  //     });
  //
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);
  //     double latitude = position.latitude;
  //     double longitude = position.longitude;
  //
  //     List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
  //     Placemark place = placemarks.first;
  //     String address = "${place.name}, ${place.locality}, ${place.country}";
  //
  //     setState(() {
  //       location = address;
  //     });
  //     _sendImageToApi(pickedFile);
  //   }
  // }

  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;

  //String localObjectReference;
  ARNode? localObjectNode;

  //String webObjectReference;
  ARNode? webObjectNode;

  @override
  void dispose() {
    arSessionManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Local / Web Objects"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _showBottomSheet(context),
              child: const Text("Go to recommendations"),
            ),
            const SizedBox(height: 10), // Add spacing between buttons and ARView
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6, // Adjust the height as needed
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: ARView(
                    onARViewCreated: onARViewCreated,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10), // Add spacing between ARView and button
            ElevatedButton(
              onPressed: onWebObjectAtButtonPressed,
              child: const Text("Add / Remove Web Object"),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void onARViewCreated(ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;

    this.arSessionManager.onInitialize(
      showFeaturePoints: false,
      showPlanes: true,
      customPlaneTexturePath: "assets/triangle.png",
      showWorldOrigin: true,
      handleTaps: false,
    );
    this.arObjectManager.onInitialize();
  }

  // Future<void> onLocalObjectButtonPressed() async {
  //   if (localObjectNode != null) {
  //     arObjectManager.removeNode(localObjectNode!);
  //     localObjectNode = null;
  //   } else {
  //     var newNode = ARNode(
  //         type: NodeType.localGLTF2,
  //         uri: "assets/Chicken_01/Chicken_01.gltf",
  //         scale: Vector3(0.2, 0.2, 0.2),
  //         position: Vector3(0.0, 0.0, 0.0),
  //         rotation: Vector4(1.0, 0.0, 0.0, 0.0));
  //     bool? didAddLocalNode = await arObjectManager.addNode(newNode);
  //     localObjectNode = (didAddLocalNode!) ? newNode : null;
  //   }
  // }

  Future<void> onWebObjectAtButtonPressed() async {
    if (webObjectNode != null) {
      arObjectManager.removeNode(webObjectNode!);
      webObjectNode = null;
    } else {
      var newNode = ARNode(
          type: NodeType.webGLB,
          uri:
          "https://firebasestorage.googleapis.com/v0/b/craft-comfort-b11a0.appspot.com/o/ch09.glb?alt=media&token=648fdb2f-9810-4129-9145-332a3ad3836d",
          scale: Vector3(0.2, 0.2, 0.2));
      bool? didAddWebNode = await arObjectManager.addNode(newNode);
      webObjectNode = (didAddWebNode!) ? newNode : null;
    }
  }

  final TextEditingController lengthController = TextEditingController();
  final TextEditingController breadthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: lengthController,
                decoration: InputDecoration(labelText: 'Length'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: breadthController,
                decoration: InputDecoration(labelText: 'Breadth'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: heightController,
                decoration: InputDecoration(labelText: 'Height'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: categoryController,
                decoration: InputDecoration(labelText: 'Category'),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _uploadFiles(),
                      // Add logic to upload image,
                    icon: Icon(Icons.upload),
                    label: Text('Upload Image'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => getImage(),
                    icon: Icon(Icons.camera_alt),
                    label: Text('Click Image'),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  // Retrieve values from controllers and convert to integers
                  int length = int.tryParse(lengthController.text) ?? 0;
                  int breadth = int.tryParse(breadthController.text) ?? 0;
                  int height = int.tryParse(heightController.text) ?? 0;
                  String category = categoryController.text;

                  print(
                      'Length: $length, Breadth: $breadth, Height: $height, Category: $category');
                  // Call the function and pass the variables
                  // Check if image is not null
                  if (image != null) {
                    // Call the function and pass the variables
                    await sendImageToApi(image!, length, breadth, height, category);
                  } else {
                    // Handle case where image is null
                    print('Image not selected');
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }
}

