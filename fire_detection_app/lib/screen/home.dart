import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{
    const HomeScreen({Key?key}) : super(key:key);

@override
State<HomeScreen>createState() =>_HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen>{
    @override
    Widget build(BuildContext context){
        return SafeArea(child: Scaffold(
            body : Container(
                child: const WebViewPlus(
                    initialUrl:'assets/webpage/test.html'
                )
            )
        ))
    }

}
}