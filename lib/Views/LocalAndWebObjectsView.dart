import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/widgets/ar_view.dart';
import 'package:flutter/material.dart';

class LocalAndWebObjectsView extends StatefulWidget {
  const LocalAndWebObjectsView({Key? key}) : super(key: key);

  @override
  State<LocalAndWebObjectsView> createState() => _LocalAndWebObjectsViewState();
}

class _LocalAndWebObjectsViewState extends State<LocalAndWebObjectsView> {
  late ARSessionManager arSessionManager;
  late ARObjectManager arObjectManager;

  //String localObjectReference;
  ARNode? localObjectNode;

  //String webObjectReference;
  ARNode? webObjectNode;

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
            SizedBox(
              height: MediaQuery.of(context).size.height * .8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: ARView(
                  onARViewCreated: onARViewCreated,
                ),
              ),
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: ElevatedButton(
            //           onPressed: () {
            //             //TODO
            //           },
            //           child: const Text("Add / Remove Local Object")),
            //     ),
            //     const SizedBox(
            //       width: 10,
            //     ),
            //     Expanded(
            //       child: ElevatedButton(
            //           onPressed: () {
            //             //TODO
            //           },
            //           child: const Text("Add / Remove Web Object")),
            //     )
            //   ],
            // ),
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
      customPlaneTexturePath: "triangle.png",
      showWorldOrigin: true,
      handleTaps: false,
    );
    this.arObjectManager.onInitialize();
  }
}
