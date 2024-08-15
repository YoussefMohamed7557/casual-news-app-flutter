import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:profissional_news_app/screens_and_widgets/shared_ui_components.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/article_details_item_model.dart';

class NewsDetails extends StatefulWidget {
  static const String route = "NewsDetails";
  ArticleDetailsItem articleDetailsItem;
  NewsDetails(
      {required this.articleDetailsItem});

  @override
  State<NewsDetails> createState() => _NewsDetailsState();
}

class _NewsDetailsState extends State<NewsDetails> {
  InternetConnectionChecker _internetConnectionChecker = InternetConnectionChecker();

  late Uri _url;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(size: 40),
      ),
      body: Container(
        width: width,
        height: height,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: SizedBox(
                height: height * 0.55,
                width: width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    imageUrl: widget.articleDetailsItem.imageUrl,
                    height: height * 0.5,
                    width: width,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Container(
                      child: spinKit,
                    ),
                    errorWidget: (context, _, error) => Icon(
                      Icons.error_outline,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: height * 0.47,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ListView(
                    children: [
                      Text(
                        widget.articleDetailsItem.title,
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: GestureDetector(
                          onTap: () {
                            _url = Uri.parse(widget.articleDetailsItem.url);
                            _launchUrl();
                          },
                          child: Row(
                            children: [
                              Text(
                                'Jump to the site ',
                                style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blueAccent,
                                    fontStyle: FontStyle.italic),
                              ),
                              Icon(
                                Icons.assistant_direction_outlined,
                                color: Colors.blueAccent,
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.articleDetailsItem.sourceName,
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.articleDetailsItem.publishedAt,
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          widget.articleDetailsItem.description,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87),
                          textAlign: TextAlign.justify,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                height: height * 0.5,
                width: width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                    color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (await _internetConnectionChecker.hasConnection){
      if (!await launchUrl(_url)) {
        throw Exception('Could not launch $_url');
      }
    }else{
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Center(
                    child: Text('ok'),
                  ))
            ],
            title: Center(child: Text('No Internet Connection')),
            contentPadding: EdgeInsets.all(20),
            content: Text('Your offline check your connection and try again'),
          ));
    }
  }
}
