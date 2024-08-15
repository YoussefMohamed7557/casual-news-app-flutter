import 'package:flutter/material.dart';
import 'package:profissional_news_app/screens_and_widgets/shared_ui_components.dart';
import 'package:profissional_news_app/screens_and_widgets/topic_categorized_news_item.dart';
import 'package:provider/provider.dart';

import '../../model/app_providers/topics_categorized_news_provider.dart';
import '../../model/app_utitlities.dart';
import '../../model/specific_source.dart';
import 'horizontal_list_view_in_home_screen.dart';
class VerticalListView extends StatefulWidget {
  @override
  State<VerticalListView> createState() => _VerticalListViewState();
}

class _VerticalListViewState extends State<VerticalListView> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    final provider = Provider.of<TopicsCategorizedNewsProvider>(context);
    return SizedBox(
      height: height,
      child: FutureBuilder<List<Articles>>(
        future: provider.fetchEveryThingApi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                child: spinKit2,
              ),
            );
          } else if (snapshot.hasError) {
            return Column(
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
                itemCount: provider.filtered_articles.length,
                itemBuilder: (context, index) {
                  if (index == 0)
                  {
                    return HorizontalListView(screenHeight: height, screenWidth: width);
                  }
                  else  {
                    return CategorizedNewsWidget(screenHeight: height,screenWidth: width,
                      articleDetailsItem:AppUtitlities.extractArticlesDetailsInfo(snapshot.data![index]) ,
                    );
                  }
                });
          }
        },
      ),
    );
  }
}
