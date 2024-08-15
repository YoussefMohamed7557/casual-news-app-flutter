import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:profissional_news_app/model/app_providers/outlinedNewsFromSpecificSourceProvider.dart';
import 'package:profissional_news_app/model/app_providers/stared_news_provider.dart';
import 'package:profissional_news_app/model/app_providers/topics_categorized_news_provider.dart';
import 'package:profissional_news_app/screens_and_widgets/home_screen/home_screen.dart';
import 'package:profissional_news_app/screens_and_widgets/news_details.dart';
import 'package:profissional_news_app/screens_and_widgets/news_with_filters_screen.dart';
import 'package:profissional_news_app/screens_and_widgets/splash_screen.dart';
import 'model/article_details_item_model.dart';
import 'package:provider/provider.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ArticleDetailsItemAdapter());
  runApp( MultiProvider(child: MyApp(),
  providers: [
    ChangeNotifierProvider(create: (context) {
      return StaredNewsProvider();
    },),
    ChangeNotifierProvider(create: (context) {
      return OutlinedNewsFromSpecificSourceProvider();
    },),
    ChangeNotifierProvider(create: (context) {
      return TopicsCategorizedNewsProvider();
    },),
  ]),
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
