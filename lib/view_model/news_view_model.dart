

import 'package:news_app/models/NewsCategoriesModel.dart';
import 'package:news_app/repository/news_repository.dart';

import '../models/news_channel_headlines_model.dart';

class NewsViewModel{
 final _repo=NewsRepository();
 Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi(String sources)async{
   final response=await _repo.fetchNewsChannelHeadlinesApi(sources);
   return response;
 }
 Future<CategoriesNewsModel> fetchNewsCategoriesApi(String category)async{
   final response=await _repo.fetchNewsCategoriesApi(category);
   return response;
 }
}