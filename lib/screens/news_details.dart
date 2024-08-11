import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/shared.dart';

class NewsDetails extends StatelessWidget {
  static const String route = "NewsDetails";
  late Uri _url;
  ArticleDetailsItem articleDetailsItem;
  NewsDetails(
      {required this.articleDetailsItem});
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
                    imageUrl: articleDetailsItem.imageUrl,
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
                        articleDetailsItem.title,
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: GestureDetector(
                          onTap: () {
                            _url = Uri.parse(articleDetailsItem.url);
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
                              articleDetailsItem.sourceName,
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              articleDetailsItem.publishedAt,
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
                          articleDetailsItem.description,
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
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
