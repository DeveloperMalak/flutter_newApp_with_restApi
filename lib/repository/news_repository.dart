import 'dart:convert';

import 'package:http/http.dart'as http;
import 'package:news_app/models/NewsCategoriesModel.dart';

import '../models/news_channel_headlines_model.dart';
class NewsRepository{
  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi(String sources)async{
    String url='https://newsapi.org/v2/top-headlines?sources=$sources';
    String apiKey='your_apikey_here';
    final response=await http.get(Uri.parse(url),
    headers:{
      'authorization':apiKey
    },);

    if(response.statusCode==200){
      final body=jsonDecode(response.body);
     return NewsChannelsHeadlinesModel.fromJson(body);
    }
    throw Exception('error');
  }
  Future<CategoriesNewsModel> fetchNewsCategoriesApi(String category)async{
    String url='https://newsapi.org/v2/everything?q=$category';
    String apiKey='your_apikey_here';
    final response=await http.get(Uri.parse(url),
      headers:{
        'authorization':apiKey
      },);

    if(response.statusCode==200){
      final body=jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception('error');
  }
}