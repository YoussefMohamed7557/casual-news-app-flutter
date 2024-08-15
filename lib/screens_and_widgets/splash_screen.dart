import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profissional_news_app/screens_and_widgets/home_screen/home_screen.dart';
class SplashScreen extends StatefulWidget {
  static const String route = "SplashScreen";
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  _startDelay(){
    _timer = Timer(const Duration(seconds: 4),_goNext);
  }
  _goNext(){
    Navigator.pushReplacementNamed(context,HomePage.route);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startDelay();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }  @override

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
              "assets/images/splash_pic.jpg",
              fit: BoxFit.cover,
              height: height* 0.5,
            width:width ,
            ),
          SizedBox(height: height * 0.04,),
          Text("TOP HEADLINES" , style: GoogleFonts.anton(letterSpacing: 6,color: Colors.grey.shade700),),
          SizedBox(height: height * 0.04,),
          SpinKitChasingDots(
            color: Colors.blue,
            size: 40,
          )
        ],
      ),
    );
  }
}
// the product key
// API_KEY=5f7de885c3f045cfb63d460f0bb426ed
// https://newsapi.org/v2/everything?q=(topic to search about) &from=(date of wanted article )&sortBy=popularity&apiKey=API_KEY (every thing)
// https://newsapi.org/v2/top-headlines?country=eg&apiKey=API_KEY (top headline)
// https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=API_KEY