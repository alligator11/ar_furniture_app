import 'package:ar_furniture_app/Views/result_analysis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewRecommendations extends StatefulWidget {
  final List<dynamic> responseData;

  ViewRecommendations(this.responseData);

  @override
  State<ViewRecommendations> createState() => _ViewRecommendationsState();
}

class _ViewRecommendationsState extends State<ViewRecommendations> {
  double _rating = 0.0;
  double average = 0.0;
  String avg = "fetching...";

  @override
  void initState() {
    super.initState();
    getAverageRating();
    _loadPreferences();
  }
  String selectedAge = '10-30';
  String selectedGender = 'Male';
  late SharedPreferences _prefs;
  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedAge = _prefs.getString('selectedAge') ?? '10-30';
      selectedGender = _prefs.getString('selectedGender') ?? 'Male';
    });
  }

  Future<double> getAverageRating() async {
    List<double> ratings = [];

    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('ratings').get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        dynamic ratingData = doc.get('rating');
        if (ratingData is double) {
          ratings.add(ratingData);
        } else if (ratingData is int) {
          ratings.add(ratingData.toDouble()); // Convert integer to double
        }
      }

      if (ratings.isNotEmpty) {
        double sum = ratings.reduce((a, b) => a + b);
        setState(() {
          average = sum / ratings.length;
          avg = average.toString();
        });
        print(average);
        return average;
      } else {
        return 0.0; // Or handle empty ratings list accordingly
      }
    } catch (e) {
      print('Error getting average rating: $e');
      return 0.0;
    }
  }


  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rate our recommendation'),
          content: RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _submitRating();
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _submitRating() async {
    try {
      await FirebaseFirestore.instance.collection('ratings').add({
        'rating': _rating,
        'timestamp': FieldValue.serverTimestamp(),
        'selectedAge': selectedAge,
        'selectedGender': selectedGender
      });
      print('Rating submitted successfully!');
    } catch (e) {
      print('Error submitting rating:$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: Scaffold(
        appBar: AppBar(
          title: Text("Recommended furnitures"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Navigate back when back button is pressed
            },
          ),
        ),
        // body: Column(
        //   children: [
        //     ListView.builder(
        //       itemCount: widget.responseData.length,
        //       itemBuilder: (BuildContext context, int index) {
        //         var item = widget.responseData[index];
        //         return Card(
        //           child: Row(
        //             children: [
        //               Expanded(
        //                 flex: 1,
        //                 child: Image.network(
        //                   item['image link'],
        //                   width: 100,
        //                   height: 100,
        //                   fit: BoxFit.cover,
        //                 ),
        //               ),
        //               Expanded(
        //                 flex: 3,
        //                 child: Padding(
        //                   padding: const EdgeInsets.all(8.0),
        //                   child: Column(
        //                     crossAxisAlignment: CrossAxisAlignment.start,
        //                     children: [
        //                       Text(
        //                         item['product name'],
        //                         style: TextStyle(
        //                           fontSize: 18,
        //                           fontWeight: FontWeight.bold,
        //                         ),
        //                       ),
        //                       SizedBox(height: 8),
        //                       Text(
        //                         'Price: ${item['price']}',
        //                         style: TextStyle(fontSize: 16),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         );
        //       },
        //     ),
        //     Text("Average rating: $avg")
        //   ],
        // ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.responseData.length,
                itemBuilder: (BuildContext context, int index) {
                  var item = widget.responseData[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Image.network(
                              item['image link'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 8), // Add spacing between image and text
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['product name'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Price: ${item['price']}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0), // Adjust vertical margin as needed
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _showRatingDialog();
                        },
                        child: Text("Rate"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BarChartScreen()),
                          );
                        },
                        child: Text("View Chart"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0), // Adjust vertical margin as needed
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Align center within the row
                    children: [
                      Text("Average rating: $avg"),
                    ],
                  ),
                ),
              ],
            )

            // Assuming avg is a variable holding the average rating
          ],
        )
      ),
    );
  }
}




// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class ViewRecommendations extends StatefulWidget {
//   final List<dynamic> responseData;
//   ViewRecommendations(this.responseData);
//
//   @override
//   _ViewRecommendationsState createState() => _ViewRecommendationsState();
// }
//
// class _ViewRecommendationsState extends State<ViewRecommendations> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("Recommended furnitures"),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//
//             ]
//           ),
//         ),
//       ),
//     );
//   }
// }



