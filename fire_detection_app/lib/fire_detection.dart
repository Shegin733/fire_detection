import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
class FireDetectionScreen extends StatefulWidget {
  const FireDetectionScreen({Key? key}) : super(key: key);

  @override
  State<FireDetectionScreen> createState() => _FireDetectionScreenState();
}

class _FireDetectionScreenState extends State<FireDetectionScreen> {

  bool hasData = false;
  bool startDetection = false;
  String temperature = '';
  String smoke = '';
  Timer? timer;
  late AudioPlayer audioPlayer;
  WebSocketChannel? channel;

  bool isPlayingAlarmSound = false;
  bool isPlayingPlayAlarm = false;
  bool isPlayingCombinedAlarm = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    startDataUpdateTimer();
  }

  void startDataUpdateTimer() {
    const updateInterval = Duration(milliseconds: 500);
    timer = Timer.periodic(updateInterval, (_) {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse(
          'https://api.thingspeak.com/channels/2145528/feeds.json?api_key=SSDJ3RBYOYCSFSFK&results=1'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['feeds'] != null && json['feeds'].isNotEmpty) {
        setState(() {
          temperature = json['feeds'][0]['field1'].toString();
          smoke = json['feeds'][0]['field2'].toString();
        });
        final smokeValue = double.tryParse(smoke);
        if (smokeValue != null && smokeValue > 100.0) {
          showAlertMessage('Smoke Detected');
          playAlarmSound();
        }
      } else {
        setState(() {
          temperature = 'No data available';
          smoke = 'No data available';
        });
      }
    } else {
      setState(() {
        temperature = 'Error';
        smoke = 'Error';
      });
    }
  }

  void showAlertMessage(String message) async {
    setState(() {
      smoke = ' Smoke Detected with smoke value $smoke';
    });

    // Send a message to the ESP32
  }

  void playAlarmSound() async {
    if (isPlayingCombinedAlarm) return;

    isPlayingAlarmSound = true;
    final player = AudioPlayer();
    await player.play(AssetSource('alarm.wav'));
    isPlayingAlarmSound = false;

    if (isPlayingPlayAlarm && !isPlayingCombinedAlarm) {
      createCombinedAlarm();
    }
  }

  void PlayAlarm() async {
    if (isPlayingCombinedAlarm) return;

    isPlayingPlayAlarm = true;
    final player = AudioPlayer();
    await player.play(AssetSource('Alarm_Sound.mp3'));
    isPlayingPlayAlarm = false;

    if (isPlayingAlarmSound && !isPlayingCombinedAlarm) {
      createCombinedAlarm();
    }
  }

  void createCombinedAlarm() async {
    if (isPlayingCombinedAlarm) return;

    isPlayingCombinedAlarm = true;

    final player = AudioPlayer();
    await player.play(AssetSource('warning.mp3'));
    setState(() {
      isPlayingAlarmSound = false;
      isPlayingPlayAlarm = false;
    });

    showDialog(
      context: context, // Use the Scaffold context
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Fire Detected in Smoke and IP Livestream"),
          content: Text("Please take necessary actions."),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  isPlayingCombinedAlarm = false;
                });
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> startFireDetection() async {
    final response =
    await http.post(Uri.parse('http://localhost:8000/start_detection'));

    if (response.statusCode == 200) {
      setState(() {
        startDetection = true;
      });
      print('Fire detection started');
      channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8000/'));
    } else {
      print('Failed to start fire detection');
    }
  }

  Future<void> stopFireDetection() async {
    final response =
    await http.post(Uri.parse('http://localhost:8000/stop_detection'));
    if (response.statusCode == 200) {
      setState(() {
        startDetection = false;
      });
      channel?.sink.close();
      print('Fire detection stopped');
    } else {
      print('Failed to stop fire detection');
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics '),
      ),
      body: Row(
        children: [

          Container(
            width: MediaQuery.of(context).size.width * .25,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/stats.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: 310,
                    padding: const EdgeInsets.all(16),
                    color: Colors.black.withOpacity(0.7),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Sensor Detector Statistics',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Current Temperature Value in Celsius: $temperature°C',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Current Smoke Value in ppm: $smoke',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: 310,
                    padding: const EdgeInsets.all(16),
                    color: Colors.blueGrey.shade900.withOpacity(.8),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'IP Livestream Controller',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal),
                            onPressed: startFireDetection,
                            child: const Text('View IP Livestream',
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: stopFireDetection,
                            child: const Text('Pause Livestream'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),


    Expanded(
    child: Stack(
    children: [
    Visibility(
    visible: !hasData, // Show the background image when there's no data
    child: Container(
    decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage('assets/images/download.jpg'),
    fit: BoxFit.cover,
    ),
    ),
    ),
    ),
    SingleChildScrollView(
    child: StreamBuilder(
    stream: channel?.stream,
    builder: (context, snapshot) {
    if (snapshot.hasData) {
    final jsonRes = jsonDecode(snapshot.data.toString());
    final response = jsonRes["response"];
    final frame = base64Decode(jsonRes['frame']);
    bool detStatus = response["detection"] as bool;
    String statusText = detStatus
    ? "Fire Detected"
        : "No Fire Detected";
    String detDesc = response["desc"];
    DateTime detTimestamp = DateTime.parse(
    response["timestamp"]);

    if (detStatus) {
    PlayAlarm();
    }

    hasData = true; // Data is available
    return Column(
    children: [
    Text("Status : $statusText",
    style: TextStyle(
    fontSize: 16,
    color: Colors.red,
    fontWeight: FontWeight.bold,
    )),
    Text("Desc : $detDesc",
    style: TextStyle(
    fontSize: 16,
    color: Colors.red,
    fontWeight: FontWeight.bold)),
    Text("TimeStamp : $detTimestamp",
    style: TextStyle(
    fontSize: 16,
    color: Colors.red,
    fontWeight: FontWeight.bold)),
    Image.memory(frame),
    ],
    );
    } else {
    hasData = false; // No data available
    return Center(
      child: Text(
        "\n No detection response received from server",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 23,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    }
    },
    ),
    ),
    ],
    ),
    ),
    ],
      ),
    );
  }
}

