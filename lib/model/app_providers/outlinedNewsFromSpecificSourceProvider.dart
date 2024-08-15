import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../specific_source.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

enum FilterList { axios, bloomberg, buzzfeed, cnn, engadget, loading }
enum FetchingDataStatus{loading,loaded,alreadyLoaded,fail}
extension FetchingDataStatusExtension on FetchingDataStatus{
  String getValue(){
    switch(this){
      case FetchingDataStatus.loading:
        return "loading";
      case FetchingDataStatus.loaded:
        return "loaded";
      case FetchingDataStatus.alreadyLoaded:
        return "alreadyLoaded";
      case FetchingDataStatus.fail:
        return "fail";
    }
  }
}

class OutlinedNewsFromSpecificSourceProvider extends ChangeNotifier{
  List<String> filtersList = ['Axios','Bloomberg','Buzzfeed','CNN'];
  List<Articles> articles = [];
  String sourceId = "axios";
  bool sourceIdChanged=false;
  String errorMessage = "";
  String responseStatus = "";
  int currentIndex = 0;

  final InternetConnectionChecker _internetConnectionChecker = InternetConnectionChecker();
  onSourceIdChanged(String value){

    sourceId = value;
    sourceIdChanged = true;
    notifyListeners();
  }
  Future<List<Articles>> fetchTopHeadlines() async {
    if (await _internetConnectionChecker.hasConnection){
      if(articles.isEmpty || sourceIdChanged){
        sourceIdChanged = false;
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
          print("//////////////////////// done successfully ///////////////////");
          return articles;
        }
        else {
          errorMessage = "Something went wrong in server side, try again later";
          throw Exception('Failed to load headlines');
        }
      }
      else{
        print("//////////////////////// saved already ///////////////////");
        return articles;
      }
    }
    else{
      print("////////////////////////some thing went wrong, try again later///////////////////");
      errorMessage = "You are offline, Connect to the network and try again";
      notifyListeners();
      throw Exception('Failed to load headlines');
    }

  }
}
// fetchTopHeadlines() async {
//   if (await _internetConnectionChecker.hasConnection){
//     if(!sourceIdNotChanged && articles.isNotEmpty){
//       responseStatus = FetchingDataStatus.alreadyLoaded.getValue();
//       notifyListeners();
//       print("////////////////////////alreadyLoaded///////////////////");
//     }else{
//       sourceIdNotChanged = true;
//       responseStatus = FetchingDataStatus.loading.getValue();
//       notifyListeners();
//       var url = Uri.https(
//         'newsapi.org',
//         '/v2/top-headlines',
//         {'sources': sourceId, 'apiKey': '5f7de885c3f045cfb63d460f0bb426ed'},
//       );
//       final response = await http.get(url);
//       final body = json.decode(response.body);
//       if (response.statusCode == 200) {
//         articles = [];
//         Articles temp;
//         final data = body['articles'];
//         for (Map i in data) {
//           temp = Articles.fromJson(i as Map<String, dynamic>);
//           if (temp.source!.name.toString() != "[Removed]") {
//             articles.add(temp);
//           }
//         }
//         FetchingDataStatus.loaded.getValue();
//         print("////////////////////////loaded///////////////////");
//         notifyListeners();
//       }
//       else {
//         FetchingDataStatus.fail.getValue();
//         print("////////////////////////some thing went wrong, try again later///////////////////");
//
//         errorMessage = "Some thing went wrong, try again later";
//         notifyListeners();
//       }
//     }
//   }else{
//     print("////////////////////////some thing went wrong, try again later///////////////////");
//     errorMessage = "You are offline, Connect to the network and try again";
//     notifyListeners();
//   }
// }
// fillEmptyArticlsList()async{
//   if (await _internetConnectionChecker.hasConnection){
//     sourceId = FetchingDataStatus.loading.getValue();
//     notifyListeners();
//     var url = Uri.https(
//       'newsapi.org',
//       '/v2/top-headlines',
//       {'sources': sourceId, 'apiKey': '5f7de885c3f045cfb63d460f0bb426ed'},
//     );
//     final response = await http.get(url);
//     final body = json.decode(response.body);
//     if (response.statusCode == 200) {
//       articles = [];
//       Articles temp;
//       final data = body['articles'];
//       for (Map i in data) {
//         temp = Articles.fromJson(i as Map<String, dynamic>);
//         if (temp.source!.name.toString() != "[Removed]") {
//           articles.add(temp);
//         }
//       }
//       FetchingDataStatus.loaded.getValue();
//       notifyListeners();
//     }
//     else {
//       FetchingDataStatus.fail.getValue();
//       errorMessage = "Some thing went wrong, try again later";
//       notifyListeners();
//     }
//   }
//   else{errorMessage = "You are offline, Connect to the network and try again";
//   notifyListeners();}
// }