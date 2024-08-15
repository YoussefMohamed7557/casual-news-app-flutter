import 'package:hive/hive.dart';
import 'package:profissional_news_app/model/article_details_item_model.dart';

class LocalDataSourceRepository {
  static const String _boxName = 'articleDetailsBox';

  // Method to store the list of articles
  Future<void> storeArticles(List<ArticleDetailsItem> articles) async {
    var box = await Hive.openBox<ArticleDetailsItem>(_boxName);
    await box.addAll(articles);
  }

  // Method to update an article if it exists, or add it if it doesn't
  // Method to update or add a list of articles
  Future<void> updateOrAddListOfArticles(List<ArticleDetailsItem> articles) async {
    var box = await Hive.openBox<ArticleDetailsItem>(_boxName);

    for (var article in articles) {
      int? existingKey;

      // Search for the article by its URL
      for (var key in box.keys) {
        var item = box.get(key);
        if (item != null && item.url == article.url) {
          existingKey = key as int?;
          break;
        }
      }

      if (existingKey != null) {
        // Update the existing article
        await box.put(existingKey, article);
      } else {
        // Add a new article
        await box.add(article);
      }
    }
  }
  Future<void> addOrDeleteIfExisted(ArticleDetailsItem article) async {
    var box = await Hive.openBox<ArticleDetailsItem>(_boxName);

    int? existingKey;

    // Search for the article by its URL
    for (var key in box.keys) {
      var item = box.get(key);
      if (item != null && item.url == article.url) {
        existingKey = key as int?;
        break;
      }
    }

    if (existingKey != null) {
      // Delete the existing article
      await box.delete(existingKey);
    } else {
      // Add the new article
      await box.add(article);
    }
  }
  Future<void> deleteItemByUrl(String url) async {
    var box = await Hive.openBox<ArticleDetailsItem>(_boxName);

    int? keyToDelete;

    // Search for the article by its URL
    for (var key in box.keys) {
      var item = box.get(key);
      if (item != null && item.url == url) {
        keyToDelete = key as int?;
        break;
      }
    }

    if (keyToDelete != null) {
      // Delete the article if found
      await box.delete(keyToDelete);
    }
  }
  // Optionally, method to get all stored articles
  Future<List<ArticleDetailsItem>> getArticles() async {
    var box = await Hive.openBox<ArticleDetailsItem>(_boxName);
    return box.values.toList();
  }
}
