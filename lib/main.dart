import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:profissional_news_app/screens/home_screen.dart';
import 'package:profissional_news_app/screens/news_details.dart';
import 'package:profissional_news_app/screens/news_with_filters_screen.dart';
import 'package:profissional_news_app/screens/splash_screen.dart';
import 'model/shared.dart';

Future<void> main() async {
  initHive();
  runApp(const MyApp());
}
initHive() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ArticleDetailsItemAdapter());
  staredArticles = await articleDetailsRepository.getArticles();
  staredArticles.forEach((v){staredUrls.add(v.url);});
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.route,
      routes: {
        SplashScreen.route : (context)=> SplashScreen(),
        HomePage.route : (context)=>HomePage(),
        NewsWithFiltersScreen.route : (context)=> NewsWithFiltersScreen(),
        NewsDetails.route : (context) => NewsDetails(articleDetailsItem: ArticleDetailsItem("", "", "", "", "", ""),)
      },
    );
  }
}
