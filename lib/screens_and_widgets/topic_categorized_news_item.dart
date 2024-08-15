import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profissional_news_app/screens_and_widgets/shared_ui_components.dart';

import '../model/article_details_item_model.dart';
import 'news_details.dart';
class CategorizedNewsWidget extends StatelessWidget {
  ArticleDetailsItem articleDetailsItem;
  double screenHeight;
  double screenWidth;
  CategorizedNewsWidget(
      { required this.articleDetailsItem,
        required this.screenHeight,
        required this.screenWidth,});
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
                  StarWidget(margin:EdgeInsets.symmetric(horizontal: 14,vertical: 14),item: articleDetailsItem  )
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