import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:profissional_news_app/model/articel_details_repository.dart';
import 'package:profissional_news_app/model/specific_source.dart';
import 'package:hive/hive.dart';
part 'shared.g.dart';
enum FilterList { axios, bloomberg, buzzfeed, cnn, engadget }
List<String> filtersList = ['Axios','Bloomberg','Buzzfeed','CNN'];

////////////// stared news items \\\\\\\\\



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


