import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:convert';
import '../specific_source.dart';

class TopicsCategorizedNewsProvider extends ChangeNotifier{
  List<String> topicFilteringItems = [
    "General",
    "Entertainment",
    "Health",
    "Sports",
    "Business",
    'Technology',
  ];
  final InternetConnectionChecker _internetConnectionChecker = InternetConnectionChecker();
  List<Articles> filtered_articles = [];
  String topic = "General";
  String errorMessage = "";
  bool topicChanged = false;
  onTopicChanged(int index){
    topic = topicFilteringItems[index];
    topicChanged = true;
    notifyListeners();
  }
  Future<List<Articles>> fetchEveryThingApi() async {
    if (await _internetConnectionChecker.hasConnection){
      if(filtered_articles.isEmpty || topicChanged){
        topicChanged = false;
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
          print("//////////////////////// done successfully ///////////////////");
          return filtered_articles;
        }
        else {
          errorMessage = "Something went wrong in server side, try again later";
          throw Exception('Failed to load headlines');
        }
      }
      else{
        print("//////////////////////// saved already ///////////////////");
        return filtered_articles;
      }
    }
    else{
      errorMessage = "You are offline, Connect to the network and try again";
      notifyListeners();
      throw Exception('Failed to load headlines');
    }
  }

}
