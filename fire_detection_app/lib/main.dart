import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'fire_detection.dart';

import 'package:fire_detection_app/location.dart';

import 'package:fire_detection_app/log.dart';


import 'dart:math';
import 'dart:math' show pi, cos, sin;
import 'package:flutter_glow/flutter_glow.dart';
void main() {
  runApp(const FireDetectionApp());
}

class FireDetectionApp extends StatelessWidget {
  const FireDetectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fire Detection App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/':(context) =>  Start(),
        '/login': (context) =>  LoginPage(),
        '/home': (context) =>  HomePage(),

        '/log': (context) =>  LogFilePage(),
        '/location': (context) => LocationPage(),
        '/statistics': (context) => FireDetectionScreen(),
      },
    );
  }
}




class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/chil.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: FractionallySizedBox(
                widthFactor: 0.3,
                heightFactor: 0.5,
                child: ClipOval(
                  child: Transform.scale(
                    scale: 1.0,
                    child: Image.asset(
                      'assets/images/blue-fire-pyrotechnics.gif',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // White glow over the oval frame
          Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5, // Match the width of the scaled image
              height: MediaQuery.of(context).size.height * 0.5, // Match the height of the scaled image
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.1), // White color with opacity
                    blurRadius: 20.0, // Adjust the blur radius as needed
                    spreadRadius: 10.0, // Adjust the spread radius as needed
                  ),
                ],
              ),
            ),
          ),
          // Buttons and text in front of both images
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white, // Set the button background color to white
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.deepPurpleAccent, // Glowing violet text color
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.white,
                        blurRadius: 10.0,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.8),
                      Colors.white70.withOpacity(0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.6], // Adjust the stops as needed
                  ).createShader(bounds);
                },
                child: Text(
                  'FOREST FIRE DETECTION APP',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.white,
                        blurRadius: 10.0,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}





class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if ((username == 'JustinFO-idukki' && password == 'FOKLIDK') ||
        (username == 'ZainFO-Nilambur' && password == 'FOKLMLP') ||
        (username == 'RajFO-Wayanad' && password == 'FOKLWYD')) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      await prefs.setString('password', password);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Invalid username or password.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/1690546665342.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login Page',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.white,
                    ),
                    Shadow(
                      blurRadius: 20,
                      color: Colors.purpleAccent,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 382,
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(80),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'User Name',
                        labelStyle: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 17,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Colors.deepPurple),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3),
                          borderSide: const BorderSide(color: Colors.purple),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(15),
                            right: Radius.circular(3),
                          ),
                          borderSide: const BorderSide(color: Colors.purple, width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 17,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Colors.deepPurple),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Colors.purple),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(15),
                            right: Radius.circular(3),
                          ),
                          borderSide: const BorderSide(color: Colors.purple, width: 2.0),
                        ),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17),
                        ),
                        minimumSize: const Size(300, 30),
                      ),
                      child: const Text(
                        'Log In',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}


class HomePage extends StatelessWidget {
  static const IconData query_stats_sharp = IconData(0xebef, fontFamily: 'MaterialIcons');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Home Page',
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            showExitConfirmationDialog(context);
          },
        ),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/newbg.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0, top: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'The Call of The Forest',
                  style: TextStyle(
                    fontSize: 43,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.greenAccent,
                        blurRadius: 8,
                        offset: Offset(0, 0),
                      ),
                      Shadow(
                        color: Colors.greenAccent,
                        blurRadius: 15,
                        offset: Offset(0, 0),
                      ),
                    ],
                    fontFamily: 'Your-Modern-Font',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'The Forest Calls each and everyone of us!'
                      ' \n only a certain few hear the call!',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 260,
              height: 260,
              child: CircularWrap(
                alignment: Alignment.center,

                children: [
                  buildToolItem(
                    icon: Icons.location_on,
                    title: 'Location',
                    size: 90.0,
                    onTap: () {
                      Navigator.pushNamed(context, '/location');
                    },
                  ),
                  buildToolItem(
                    icon: Icons.insert_chart_outlined,
                    title: 'Statistics',
                    size: 90.0,
                    onTap: () {
                      Navigator.pushNamed(context, '/statistics');
                    },
                  ),
                  buildToolItem(
                    icon: Icons.receipt_outlined,
                    title: 'Log',
                    size: 90.0,
                    onTap: () {
                      Navigator.pushNamed(context, '/log');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildToolItem({
    required VoidCallback onTap,
    required IconData icon,
    required String title,
    required double size,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.transparent,
              Colors.blue,
              Colors.green,
            ],
            stops: [0.0, 0.4, 0.6, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return RadialGradient(
              radius: 1.5,
              colors: [
                Colors.white,
                Colors.transparent,
              ],
              stops: [0.9, 1.0],
              center: Alignment.center,
              tileMode: TileMode.clamp,
            ).createShader(bounds);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: size * 0.6,
                color: Colors.white,
              ),
              SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit App'),
          content: Text('Are you sure you want to exit?'),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Pop twice to go back to the initial '/' page
              },
            ),
          ],
        );
      },
    );
  }
}



class CircularWrap extends StatelessWidget {
  final Alignment alignment;
  final List<Widget> children;

  CircularWrap({required this.alignment, required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final circleCenter = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
        final radius = min(constraints.maxWidth, constraints.maxHeight) / 2 - 20; // Reduce the radius to avoid cut-off

        double angleDelta = 2 * pi / children.length;
        double angle = -pi / 2; // Start angle at the top

        List<Widget> positionedChildren = [];
        double iconSize = 40; // Adjust this size based on your icon size
        for (int i = 0; i < children.length; i++) {
          double x = circleCenter.dx + (radius - iconSize / 2) * cos(angle);
          double y = circleCenter.dy + (radius - iconSize / 2) * sin(angle);

          positionedChildren.add(
            Positioned(
              left: x - iconSize / 2,
              top: y - iconSize / 2,
              child: children[i],
            ),
          );

          angle += angleDelta;
        }

        return Container(
          width: radius * 2,
          height: radius * 2,
          child: Stack(
            alignment: alignment,
            children: [
              Container(
                width: radius * 2,
                height: radius * 2,

              ),
              ...positionedChildren,
            ],
          ),
        );
      },
    );
  }
}

class CircularFramePainter extends CustomPainter {
  final Offset circleCenter;
  final double radius;

  CircularFramePainter({required this.circleCenter, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
       // Change the color of the circular frame here
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(circleCenter, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}





  class PlaceholderPage extends StatelessWidget {
  final String title;

  PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('Placeholder Content'),
      ),
    );
  }
}
