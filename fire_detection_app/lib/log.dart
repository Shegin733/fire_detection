

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Log File Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LogFilePage(),
    );
  }
}

class LogFilePage extends StatelessWidget {
  final List<String> logEntries = [
    'Temperature Vs Time',
    'Smoke Vs Time',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log File'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height, // Set the height to cover the entire screen
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Log (2).png'),
              fit: BoxFit.cover,
            ),
          ),

          child: SingleChildScrollView(

            child: Row( // Wrap the charts in a Row
              children: List.generate(logEntries.length, (index) {

                const SizedBox(height: 20);
                return Container(
                  width: MediaQuery.of(context).size.width * 0.45, // Set container width to 45% of the screen size
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          _getImagePath(index),
                          width: 430, // Adjust the width of the image
                          height: 400, // Adjust the height of the image
                        ),
                        SizedBox(height: 16),
                        Text(
                          logEntries[index],
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                          color : Colors.lightBlue.shade900,
                              shadows: [
                                Shadow(
                                  blurRadius: 10,
                                  color: Colors.white,
                                ),

                              ]),

                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  String _getImagePath(int index) {
    // Add logic to return the correct image path based on the index
    if (index == 0) {
      return 'assets/images/temp.png';
    } else if (index == 1) {
      return 'assets/images/lie.png';
    }
    return ''; // Return a default image path or handle other cases
  }
}
