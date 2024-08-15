import 'package:hive/hive.dart';
part 'article_details_item_model.g.dart';

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


