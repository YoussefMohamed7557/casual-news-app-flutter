import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profissional_news_app/model/shared.dart';
import '../model/specific_source.dart';
class NewsWithFiltersScreen extends StatefulWidget {
  const NewsWithFiltersScreen({super.key});
  static const String route = "NewsWithFiltersScreen";

  @override
  State<NewsWithFiltersScreen> createState() => _NewsWithFiltersScreenState();
}

class _NewsWithFiltersScreenState extends State<NewsWithFiltersScreen> {
  List<String> topicFilteringItems = [
    "General",
    "Entertainment",
    "Health",
    "Sports",
    "Business",
    'Technology',
  ];
  String selectedFilter = "General";
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gareeda',
          style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w700,color: Colors.teal),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset("assets/images/category_icon.png",color: Colors.teal,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          Container(
            height: height,
            child: FutureBuilder<List<Articles>>(
              future: fetchEveryThingApi(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(
                      child: spinKit2,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          'Something went wrong, check the connection and try again'),
                      SizedBox(
                        height: 40,
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.refresh,
                            size: 32,
                            color: Colors.blueAccent,
                          ))
                    ],
                  );
                } else {
                  return ListView.builder(
                      itemCount: filtered_articles.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return SizedBox(
                            height: height * 1 / 14,
                            width: width,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: topicFilteringItems.length,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                      onTap: () {
                                        selectedFilter =
                                            topicFilteringItems[index];
                                        topic = selectedFilter;
                                        setState(() {});
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 8),
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          topicFilteringItems[index],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color:
                                                (topicFilteringItems[index] ==
                                                        selectedFilter)
                                                    ? Colors.teal
                                                    : Colors.grey),
                                      ),
                                    )),
                          );
                        } else {
                          return Container(
                            margin: EdgeInsets.all(8),
                            child: CategorizedNewsWidget( screenHeight: height,screenWidth: width,
                              articleDetailsItem:extractArticlesDetailsInfo(snapshot.data![index] ),
                              rebuildAction: (){setState(() {});},),
                          );
                        }
                      });
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
/*
 Image.asset('assets/images/splash_pic.jpg',height: height * 0.23,fit: BoxFit.fill,),
 */
