import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

Future<String> uploadGlbFileToFirebaseStorage(String videoID, String videoFilePath) async {
  UploadTask videoUploadTask = FirebaseStorage.instance
      .ref()
      .child('3DModels')
      .child(videoID)
      .putFile(File(videoFilePath)); // Assuming videoFilePath is the path to the video file
  TaskSnapshot snapshot = await videoUploadTask;
  String downloadUrlOfUploadedVideo = await snapshot.ref.getDownloadURL();
  return downloadUrlOfUploadedVideo;
  }

// void main() async {
//   String videoID = 'model1'; // Replace with your own video ID
//   String videoFilePath = 'glbFiles/out_13.glb'; // Replace with the actual file path
//
//   try {
//     String downloadUrl = await uploadGlbFileToFirebaseStorage(videoID, videoFilePath);
//     print('Uploaded video URL: $downloadUrl');
//   } catch (e) {
//     print('Error uploading video:$e');
//   }
// }
