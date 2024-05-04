import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


class BarChartScreen extends StatefulWidget {
  @override
  _BarChartScreenState createState() => _BarChartScreenState();
}

class _BarChartScreenState extends State<BarChartScreen> {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> data1 = []; // New list for age categories

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('ratings')
        .get();

    // Initialize genderAverages and ageCategoryAverages with default values
    Map<String, double> genderAverages = {
      'Male': 0,
      'Female': 0,
      'Others': 0,
    };
    Map<String, double> ageCategoryAverages = {
      '10-30': 0,
      '31-50': 0,
      '50+': 0,
    };

    for (var doc in querySnapshot.docs) {
      var rating = doc['rating'];
      var selectedGender = doc['selectedGender'];
      var selectedAge = doc['selectedAge'];

      // Use null-aware operator and provide a default value
      genderAverages[selectedGender] = (genderAverages[selectedGender]?? 0) + rating;
      ageCategoryAverages[selectedAge] = (ageCategoryAverages[selectedAge]?? 0) + rating;
    }

    for (var gender in genderAverages.keys) {
      // Ensure the value is non-null before performing division
      genderAverages[gender] = (genderAverages[gender]?? 0) / querySnapshot.docs.length;
    }
    for (var ageCategory in ageCategoryAverages.keys) {
      // Ensure the value is non-null before performing division
      ageCategoryAverages[ageCategory] = (ageCategoryAverages[ageCategory]?? 0) / querySnapshot.docs.length;
    }

    // Print the average values for debugging
    print('Gender Averages: $genderAverages');
    print('Age Category Averages: $ageCategoryAverages');

    setState(() {
      data = [
        {'x': 0, 'y': genderAverages['Male']?? 0},
        {'x': 1, 'y': genderAverages['Female']?? 0},
        {'x': 2, 'y': genderAverages['Others']?? 0},
      ];
      data1 = [
        {'x': 0, 'y': ageCategoryAverages['10-30']?? 0},
        {'x': 1, 'y': ageCategoryAverages['31-50']?? 0},
        {'x': 2, 'y': ageCategoryAverages['50+']?? 0},
      ];
    });
  }

  Widget bottomTitles1(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = '10-30';
        break;
      case 1:
        text = '31-50';
        break;
      case 2:
        text = '50+';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Male';
        break;
      case 1:
        text = 'Female';
        break;
      case 2:
        text = 'Others';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ratings'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text("Gender-wise average rating", style:TextStyle(
                    fontSize: 20
                  )),
                ),
                SizedBox(height: 50,),
                AspectRatio(
                  aspectRatio: 1.3,
                  child: BarChart(
                    BarChartData(
                      barTouchData: BarTouchData(
                        enabled: true,
                      ),
                      borderData: FlBorderData(
                          show: true,
                          border: Border(
                              top: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                              )
                          )
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: false
                            )
                        ),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: false
                            )
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: bottomTitles,
                          ),
                        ),
                      ),

                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.grey.withOpacity(0.5),
                          strokeWidth: 1,
                        ),
                      ),
                      groupsSpace: 20,
                      barGroups: data.map((dataPoint) {
                        return BarChartGroupData(
                          x: dataPoint['x'],
                          barRods: [
                            BarChartRodData(
                                toY: dataPoint['y'].toDouble(),
                                color: Colors.blue,
                                width: 20
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text("Age-wise average rating", style: TextStyle(
                    fontSize: 20
                  ),),
                ),
                SizedBox(height: 50,),
                AspectRatio(
                  aspectRatio: 1.3,
                  child: BarChart(
                    BarChartData(
                      barTouchData: BarTouchData(
                        enabled: true,
                      ),
                      borderData: FlBorderData(
                          show: true,
                          border: Border(
                              top: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                              )
                          )
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: false
                            )
                        ),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(
                                showTitles: false
                            )
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: bottomTitles1,
                          ),
                        ),
                      ),

                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.grey.withOpacity(0.5),
                          strokeWidth: 1,
                        ),
                      ),
                      groupsSpace: 20,
                      barGroups: data.map((dataPoint) {
                        return BarChartGroupData(
                          x: dataPoint['x'],
                          barRods: [
                            BarChartRodData(
                                toY: dataPoint['y'].toDouble(),
                                color: Colors.blue,
                                width: 20
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}