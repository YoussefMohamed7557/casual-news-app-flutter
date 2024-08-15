import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:profissional_news_app/model/app_providers/outlinedNewsFromSpecificSourceProvider.dart';
import 'package:profissional_news_app/screens_and_widgets/topic_categorized_news_item.dart';
import 'package:provider/provider.dart';
import '../model/article_details_item_model.dart';
import '../model/app_providers/stared_news_provider.dart';
const spinKit = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
const spinKit2 = SpinKitCircle(
  color: Colors.blue,
  size: 50,
);
class CustomPopupMenuButton extends StatelessWidget {
  FilterList? selectedMenu ;
  Function() onSelectedAction;

  CustomPopupMenuButton({required this.onSelectedAction});
  @override
  Widget build(BuildContext context) {
    return Consumer<OutlinedNewsFromSpecificSourceProvider>(
      builder: (context, provider, _) {
        return PopupMenuButton<FilterList>(
          initialValue: selectedMenu,
          icon: Icon(Icons.more_vert,size: 50,color: Colors.teal,),
          color: Colors.white,
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          elevation: 20,
          onSelected: (value) {
            provider.onSourceIdChanged(value.name);
          },
          itemBuilder: (context) => <PopupMenuEntry<FilterList>> [
            PopupMenuItem(value:FilterList.axios ,child: Text(provider.filtersList[0],style: TextStyle(fontSize: 20),)),
            PopupMenuItem(value:FilterList.bloomberg ,child: Text(provider.filtersList[1],style: TextStyle(fontSize: 20),)),
            PopupMenuItem(value:FilterList.buzzfeed,child: Text(provider.filtersList[2],style: TextStyle(fontSize: 20),)),
            PopupMenuItem(value:FilterList.cnn,child: Text(provider.filtersList[3],style: TextStyle(fontSize: 20),)),

          ],);
      },
    );
  }
}
class StarWidget extends StatelessWidget {
  StarWidget({required this.item,required this.margin,super.key});
  ArticleDetailsItem item;
  EdgeInsetsGeometry margin;
  @override
  Widget build(BuildContext context) {
    return Consumer<StaredNewsProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: (){
            if(provider.staredUrls.contains(item.url)){
              provider.removeItemFromStaredItems(item.url);
            }else{
              provider.addItemToStaredItems(item);
            }
          },
          child: Container(
            margin: margin,
            height: 35,
            width: 35,
            child: Icon(provider.staredUrls.contains(item.url)?Icons.star:Icons.star_border_sharp,size: 28,color: Colors.amberAccent,),
            decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(18)),
          ),
        );
      },
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
    return Consumer<StaredNewsProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          itemCount: provider.staredArticles.length,
          itemBuilder: (context, index) => CategorizedNewsWidget(articleDetailsItem:provider.staredArticles[index] , screenHeight: height, screenWidth: width),);
      },
    );
  }
}
/*
  Widget getHomeWidget(OutlinedNewsFromSpecificSourceProvider sourceProvider){
    ArticleDetailsItem articleDetailsItem;
    if(sourceProvider.responseStatus == "loading"){
      return Center(
          child: Container(
            child: spinKit2,
          ));
    }
    else if(sourceProvider.responseStatus == "fail"){
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
                  setState(() { });
                },
                icon: Icon(
                  Icons.refresh,
                  size: 32,
                  color: Colors.blue,
                ))
          ],
        ),
      );
    }
    else{
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sourceProvider.articles.length,
        itemBuilder: (context, index) =>
            GestureDetector(
              onTap: () {
                articleDetailsItem =
                    AppUtitlities.extractArticlesDetailsInfo(
                        sourceProvider.articles[index]);
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
                height: widget.screenHeight * .6,
                width: widget.screenWidth * .8,
                margin: EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: ClipRRect(
                  borderRadius:
                  BorderRadiusDirectional.circular(20),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CachedNetworkImage(
                        imageUrl: (sourceProvider.articles[index].urlToImage
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
                        height: widget.screenHeight * .6 * .4,
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
                                sourceProvider.articles[index].title
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
                                      sourceProvider.articles[index].source!.name
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
                                      AppUtitlities.formatDateTime(
                                          sourceProvider.articles[index].publishedAt
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
                          child:StarWidget(margin:EdgeInsets.symmetric(horizontal: 14,vertical: 14),item:AppUtitlities.extractArticlesDetailsInfo(
                              sourceProvider.articles[index]))
                      )
                    ],
                  ),
                ),
              ),
            ),
      );
    }
  }
 */

