import 'package:flutter/material.dart';
import 'package:profissional_news_app/model/shared.dart';
import 'articel_details_repository.dart';
class StaredNewsProvider extends ChangeNotifier{
  List<String> staredUrls = [];
  List<ArticleDetailsItem> staredArticles = [];
  ArticleDetailsRepository articleDetailsRepository = ArticleDetailsRepository();
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