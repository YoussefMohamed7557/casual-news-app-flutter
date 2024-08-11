import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:profissional_news_app/model/articel_details_repository.dart';
import 'package:profissional_news_app/model/specific_source.dart';
import 'package:hive/hive.dart';
import '../screens/news_details.dart';
import 'articel_details_repository.dart';
part 'shared.g.dart';
enum FilterList { axios, bloomberg, buzzfeed, cnn, engadget }
List<String> filtersList = ['Axios','Bloomberg','Buzzfeed','CNN'];
class CustomPopupMenuButton extends StatelessWidget {
  FilterList? selectedMenu ;
  Function() onSelectedAction;
  CustomPopupMenuButton({required this.onSelectedAction});
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<FilterList>(
      initialValue: selectedMenu,
      icon: Icon(Icons.more_vert,size: 50,color: Colors.teal,),
      color: Colors.white,
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      elevation: 20,
      onSelected: (value) {
        sourceId = value.name;
        onSelectedAction();
      },
      itemBuilder: (context) => <PopupMenuEntry<FilterList>> [
    PopupMenuItem(value:FilterList.axios ,child: Text(filtersList[0],style: TextStyle(fontSize: 20),)),
    PopupMenuItem(value:FilterList.bloomberg ,child: Text(filtersList[1],style: TextStyle(fontSize: 20),)),
    PopupMenuItem(value:FilterList.buzzfeed,child: Text(filtersList[2],style: TextStyle(fontSize: 20),)),
    PopupMenuItem(value:FilterList.cnn,child: Text(filtersList[3],style: TextStyle(fontSize: 20),)),

    ],);
  }
}
////////////// stared news items \\\\\\\\\
List<String> staredUrls = [];
List<ArticleDetailsItem> staredArticles = [];
ArticleDetailsRepository articleDetailsRepository = ArticleDetailsRepository();

addItemToStaredItems(ArticleDetailsItem item){
  staredUrls.add(item.url);
  staredArticles.add(item);
  articleDetailsRepository.addOrDeleteIfExisted(item);
  staredArticles.forEach((v){print(v.url+"\n");});
}
removeItemFromStaredItems(String url){
  staredUrls.remove(url);
  staredArticles.removeWhere((item) => item.url == url);
  articleDetailsRepository.deleteItemByUrl(url);
  staredArticles.forEach((v){print(v.url+"\n");});
}
////////////// API Action \\\\\\\\\\\\\\\\\
List<Articles> articles = [];
String sourceId = "axios";
Future<List<Articles>> fetchTopHeadlines() async {
    var url = Uri.https(
    'newsapi.org',
    '/v2/top-headlines',
    {'sources': sourceId, 'apiKey': '5f7de885c3f045cfb63d460f0bb426ed'},
  );
  final response = await http.get(url);
  final body = json.decode(response.body);
  if (response.statusCode == 200) {
    articles = [];
    Articles temp;
    final data = body['articles'];
    for (Map i in data) {
      temp = Articles.fromJson(i as Map<String, dynamic>);
      if (temp.source!.name.toString() != "[Removed]") {
        articles.add(temp);
      }
    }
    return articles;
  }
  else {
    throw Exception('Failed to load headlines');
  }
}
List<Articles> filtered_articles = [];
String topic = "General";
Future<List<Articles>> fetchEveryThingApi() async {

    var url = Uri.https(
      'newsapi.org',
      '/v2/everything',
      {'q': topic, 'apiKey': '5f7de885c3f045cfb63d460f0bb426ed'},
    );
    final response = await http.get(url);
    final body = json.decode(response.body);
    if (response.statusCode == 200) {
      filtered_articles = [];
      Articles temp;
      final data = body['articles'];
      for (Map i in data) {
        temp = Articles.fromJson(i as Map<String, dynamic>);
        if(temp.source!.name.toString() != "[Removed]"){
          filtered_articles.add(temp);
        }
      }
    return filtered_articles;
  } else {
    throw Exception('Failed to load headlines');
  }
}
////////////////// SHARED UI COMPONENTS \\\\\\\\\\\\\\\\\\\\
const spinKit = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
const spinKit2 = SpinKitCircle(
  color: Colors.blue,
  size: 50,
);
///////////////// utilities \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
String formatDateTime(String date) {
  // DateTime parseDate =
  //     new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
  DateTime parseDate =
  new DateFormat("yyyy-MM-dd").parse(date);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('MMMM dd, yyyy');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}
ArticleDetailsItem extractArticlesDetailsInfo(Articles snapshot) {
  return ArticleDetailsItem(
      snapshot!.title.toString(),
      snapshot!.description.toString(),
      snapshot!.source!.name.toString(),
      formatDateTime(snapshot!.publishedAt.toString()),
      snapshot!.url.toString(),
      snapshot!.urlToImage.toString());
}
@HiveType(typeId: 0)
class ArticleDetailsItem {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  String sourceName;

  @HiveField(3)
  String publishedAt;

  @HiveField(4)
  String url;

  @HiveField(5)
  String imageUrl;

  ArticleDetailsItem(this.title, this.description, this.sourceName,
      this.publishedAt, this.url, this.imageUrl);
  // Convert a ArticleDetailsItem object into a Map (JSON format)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'sourceName': sourceName,
      'publishedAt': publishedAt,
      'url': url,
      'imageUrl': imageUrl,
    };
  }

  // Create a ArticleDetailsItem object from a Map (JSON format)
  factory ArticleDetailsItem.fromJson(Map<String, dynamic> json) {
    return ArticleDetailsItem(
      json['title'],
      json['description'],
      json['sourceName'],
      json['publishedAt'],
      json['url'],
      json['imageUrl'],
    );
  }
}
class StarWidget extends StatelessWidget {
  StarWidget({required this.item,required this.rebuildAction,required this.margin,super.key});
  ArticleDetailsItem item;
  Function rebuildAction;
  EdgeInsetsGeometry margin;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(staredUrls.contains(item.url)){
          removeItemFromStaredItems(item.url);
        }else{
          addItemToStaredItems(item);
        }
        rebuildAction();
      },
      child: Container(
        margin: margin,
        height: 35,
        width: 35,
        child: Icon(staredUrls.contains(item.url)?Icons.star:Icons.star_border_sharp,size: 28,color: Colors.amberAccent,),
        decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}
class CategorizedNewsWidget extends StatelessWidget {
  ArticleDetailsItem articleDetailsItem;
  double screenHeight;
  double screenWidth;
  Function() rebuildAction;/*() {setState(() {});}*/
  CategorizedNewsWidget(
      { required this.articleDetailsItem,
        required this.screenHeight,
        required this.screenWidth,
        required this.rebuildAction});
  @override
  Widget build(BuildContext context) {
    // ArticleDetailsItem articleDetailsItem =extractArticlesDetailsInfo(snapshot);
    return  GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetails(
                  articleDetailsItem:
                  articleDetailsItem),
            ));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
                alignment: Alignment.topLeft,
                children:[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(55),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CachedNetworkImage(
                          imageUrl:  articleDetailsItem.imageUrl,
                          height: screenHeight * 0.15,
                          fit: BoxFit.fill,
                          placeholder: (context, url) => Container(
                            child: spinKit,
                          ),
                          errorWidget: (context, _, error) => Icon(
                            Icons.error_outline,
                            color: Colors.red,
                          ),
                        ),
                      )),
                  StarWidget(margin:EdgeInsets.symmetric(horizontal: 14,vertical: 14),item: articleDetailsItem , rebuildAction: rebuildAction )
                ]
            ),
          ),
          Expanded(
              flex: 5,
              child: Column(
                children: [
                  Text(articleDetailsItem.title,
                    textAlign: TextAlign.justify,
                    maxLines: 7,
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                      height: screenHeight * 0.1 *0.25
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          articleDetailsItem.sourceName,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueAccent),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          articleDetailsItem.publishedAt,
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
class OutlinedNewsListView extends StatelessWidget {
  double screenHeight;
  double screenWidth;
  Function rebuildAction;
  OutlinedNewsListView(
      {required this.screenHeight,required this.screenWidth,required this.rebuildAction});

  @override
  Widget build(BuildContext context) {
    ArticleDetailsItem articleDetailsItem;
    return SizedBox(
      height: screenHeight * 0.55,
      width: screenWidth,
      child: FutureBuilder<List<Articles>>(
        future: fetchTopHeadlines(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return Center(
                child: Container(
                  child: spinKit2,
                ));
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Something went wrong, check the network and try again'),
                  SizedBox(
                    height: 20,
                  ),
                  IconButton(
                      onPressed: () {
                        rebuildAction();
                      },
                      icon: Icon(
                        Icons.refresh,
                        size: 32,
                        color: Colors.blue,
                      ))
                ],
              ),
            );
          } else {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) =>
                  GestureDetector(
                    onTap: () {
                      articleDetailsItem =
                      extractArticlesDetailsInfo(
                          snapshot.data![index]);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewsDetails(
                                articleDetailsItem:
                                articleDetailsItem),
                          ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // border: Border.all(color: Colors.grey, width: 2.0),
                        borderRadius:
                        BorderRadiusDirectional.circular(
                            20), // Border color and width
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: Offset(0, 2),
                          ),
                        ], // Shadow for elevation effect
                      ),
                      height: screenHeight * .6,
                      width: screenWidth * .8,
                      margin: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ClipRRect(
                        borderRadius:
                        BorderRadiusDirectional.circular(20),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                           CachedNetworkImage(
                              imageUrl: (snapshot
                                  .data![index].urlToImage
                                  .toString()),
                              height: double.infinity,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Container(
                                    child: spinKit,
                                  ),
                              errorWidget: (context, _, error) =>
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              height: screenHeight * .6 * .4,
                              decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius:
                                  BorderRadiusDirectional
                                      .circular(
                                      20), // Border color and width
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10.0,
                                      offset: Offset(0, 2),
                                    )
                                  ]),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.all(8.0),
                                    child: Text(
                                      snapshot.data![index].title
                                          .toString(),
                                      textAlign:
                                      TextAlign.justify,
                                      maxLines: 7,
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight:
                                          FontWeight.w700),
                                      overflow:
                                      TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets
                                              .all(8.0),
                                          child: Text(
                                            snapshot.data![index]
                                                .source!.name
                                                .toString()
                                                .toString(),
                                            style: GoogleFonts
                                                .poppins(
                                                fontSize: 18,
                                                fontWeight:
                                                FontWeight
                                                    .w600,
                                                color: Colors
                                                    .blueAccent),
                                            maxLines: 5,
                                            overflow: TextOverflow
                                                .ellipsis,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets
                                              .all(8.0),
                                          child: Text(
                                            formatDateTime(
                                                snapshot
                                                    .data![index]
                                                    .publishedAt
                                                    .toString()),
                                            style: GoogleFonts
                                                .poppins(
                                                fontSize: 16,
                                                fontWeight:
                                                FontWeight
                                                    .w500,
                                                color: Colors
                                                    .black54),
                                            maxLines: 5,
                                            overflow: TextOverflow
                                                .ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                                top: 8,
                                left: 6,
                                child:StarWidget(margin:EdgeInsets.symmetric(horizontal: 14,vertical: 14),item:extractArticlesDetailsInfo(
                                    snapshot.data![index]), rebuildAction: (){rebuildAction();})
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
            );
          }
        },
      ),
    );
  }
}
class StaredItemsListView extends StatefulWidget {
  const StaredItemsListView({super.key});

  @override
  State<StaredItemsListView> createState() => _StaredItemsListViewState();
}
class _StaredItemsListViewState extends State<StaredItemsListView> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: staredArticles.length,
        itemBuilder: (context, index) => CategorizedNewsWidget(articleDetailsItem:staredArticles[index] , screenHeight: height, screenWidth: width, rebuildAction:(){setState(() {});}),);
  }
}
