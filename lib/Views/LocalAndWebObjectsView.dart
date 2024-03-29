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

class LocalAndWebObjectsView extends StatefulWidget {
  const LocalAndWebObjectsView({Key? key}) : super(key: key);
  @override
  State<LocalAndWebObjectsView> createState() => _LocalAndWebObjectsViewState();
}

class _LocalAndWebObjectsViewState extends State<LocalAndWebObjectsView> {
  File? image;
  final picker = ImagePicker();

  Future getImage() async{
    final pickerImage = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if(pickerImage != null){
        image = File(pickerImage.path);
      }
      else{
        print("no image selected");
      }
    });
  }

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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              children:[
            SizedBox(
              height: MediaQuery.of(context).size.height * .8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: ARView(
                  onARViewCreated: onARViewCreated,
                ),
              ),
            ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: getImage,
                          child: const Text("Upload room pictures")),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewRecommendations(image)));
                          },
                          child: const Text("View ")),
                    ),
                  ],
                ),
              ]
              ),
            Row(
              children: [
                // Expanded(
                //   child: ElevatedButton(
                //       onPressed: onLocalObjectButtonPressed,
                //       child: const Text("Add / Remove Local Object")),
                // ),
                // const SizedBox(
                //   width: 10,
                // ),
                Expanded(
                  child: ElevatedButton(
                      onPressed: onWebObjectAtButtonPressed,
                      child: const Text("Add / Remove Web Object")),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
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
}

