import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String latitude = '';
  String longitude = '';

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse(
          'https://api.thingspeak.com/channels/2145528/feeds.json?api_key=SSDJ3RBYOYCSFSFK&results=1'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      setState(() {
        latitude = jsonData['channel']['latitude'].toString();
        longitude = jsonData['channel']['longitude'].toString();
      });
    } else {
      // Handle error response
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Page'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/nature-hop.jpg'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.8),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
              borderRadius: BorderRadius.circular(16),
              color: Colors.transparent, // Make the background transparent
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 60,
                ),
                SizedBox(height: 16),
                Text(
                  'Location Details of Detector',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  // Container for latitude and longitude with its own decoration
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/imager.jfif'), // Background image for the box
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Latitude: $latitude\nLongitude: $longitude',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _openGoogleMaps,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Show on Map',
                    style: TextStyle(
                      fontSize: 20,
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

  Future<void> _openGoogleMaps() async {
    String url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Handle error: unable to launch the URL
    }
  }
}


