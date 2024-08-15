import 'package:flutter/material.dart';
import 'package:profissional_news_app/model/article_details_item_model.dart';
import '../local_data_source_repository.dart';
class StaredNewsProvider extends ChangeNotifier{
  List<String> staredUrls = [];
  List<ArticleDetailsItem> staredArticles = [];
  LocalDataSourceRepository articleDetailsRepository = LocalDataSourceRepository();
  bool lacalDataIsNotRestored = true;
  addItemToStaredItems(ArticleDetailsItem item){
    staredUrls.add(item.url);
    staredArticles.add(item);
    articleDetailsRepository.addOrDeleteIfExisted(item);
    staredArticles.forEach((v){print(v.url+"\n");});
    notifyListeners();
  }
  removeItemFromStaredItems(String url){
    staredUrls.remove(url);
    staredArticles.removeWhere((item) => item.url == url);
    articleDetailsRepository.deleteItemByUrl(url);
    staredArticles.forEach((v){print(v.url+"\n");});
    notifyListeners();
  }
}