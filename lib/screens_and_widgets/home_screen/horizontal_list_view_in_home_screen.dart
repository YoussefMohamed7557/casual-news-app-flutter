import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profissional_news_app/screens_and_widgets/shared_ui_components.dart';
import 'package:provider/provider.dart';

import '../../model/app_providers/outlinedNewsFromSpecificSourceProvider.dart';
import '../../model/app_utitlities.dart';
import '../../model/article_details_item_model.dart';
import '../../model/specific_source.dart';
import '../news_details.dart';
class HorizontalListView extends StatefulWidget {
  double screenHeight;
  double screenWidth;
  HorizontalListView(
      {required this.screenHeight,required this.screenWidth});

  @override
  State<HorizontalListView> createState() => _HorizontalListViewState();
}
class _HorizontalListViewState extends State<HorizontalListView> {

  @override
  Widget build(BuildContext context) {
    OutlinedNewsFromSpecificSourceProvider sourceProvider = Provider.of<OutlinedNewsFromSpecificSourceProvider>(context);
    ArticleDetailsItem articleDetailsItem;
    return SizedBox(
      height: widget.screenHeight * 0.55,
      width: widget.screenWidth,
      child:FutureBuilder<List<Articles>>(
        future: sourceProvider.fetchTopHeadlines(),
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
                  Text(sourceProvider.errorMessage),
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
          } else {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) =>
                  GestureDetector(
                    onTap: () {
                      articleDetailsItem =
                          AppUtitlities.extractArticlesDetailsInfo(
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
                                            AppUtitlities.formatDateTime(
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
                                child:StarWidget(margin:EdgeInsets.symmetric(horizontal: 14,vertical: 14),item:AppUtitlities.extractArticlesDetailsInfo(
                                    snapshot.data![index]))
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