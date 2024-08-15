import 'package:intl/intl.dart';
import 'package:profissional_news_app/model/shared.dart';
import 'package:profissional_news_app/model/specific_source.dart';

class AppUtitlities{
  static ArticleDetailsItem extractArticlesDetailsInfo(Articles snapshot) {
    return ArticleDetailsItem(
        snapshot!.title.toString(),
        snapshot!.description.toString(),
        snapshot!.source!.name.toString(),
        formatDateTime(snapshot!.publishedAt.toString()),
        snapshot!.url.toString(),
        snapshot!.urlToImage.toString());
  }
  static String formatDateTime(String date) {
    // DateTime parseDate =
    //     new DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
    DateTime parseDate =
    new DateFormat("yyyy-MM-dd").parse(date);
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('MMMM dd, yyyy');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }
}