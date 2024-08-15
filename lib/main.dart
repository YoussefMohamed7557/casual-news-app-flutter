import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:profissional_news_app/model/stared_news_provider.dart';
import 'package:profissional_news_app/screens/home_screen.dart';
import 'package:profissional_news_app/screens/news_details.dart';
import 'package:profissional_news_app/screens/news_with_filters_screen.dart';
import 'package:profissional_news_app/screens/splash_screen.dart';
import 'model/shared.dart';
import 'package:provider/provider.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ArticleDetailsItemAdapter());
  runApp( ChangeNotifierProvider(child: MyApp(),
  create: (context) {
    return StaredNewsProvider();
  },),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  reloadStarMarkedNews(StaredNewsProvider provider)async{
    provider.staredArticles = await provider.articleDetailsRepository.getArticles();
    provider.staredArticles.forEach((v){provider.staredUrls.add(v.url);});
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StaredNewsProvider>(context,listen: false);
    reloadStarMarkedNews(provider);
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
