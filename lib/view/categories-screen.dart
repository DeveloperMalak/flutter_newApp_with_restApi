import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hash_cached_image/hash_cached_image.dart';
import 'package:intl/intl.dart';

import '../models/NewsCategoriesModel.dart';
import '../view_model/news_view_model.dart';
import 'home_screen.dart';
import 'news_details_screen.dart';
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsViewModel=NewsViewModel();
  final format=DateFormat('MM dd,yyyy');
  String categoryName='All';
  List<String> categoryList=[
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar:AppBar(

      )
          ,body:Padding(
            padding:  EdgeInsets.symmetric(horizontal:20),
            child: Column(
                  children:[
                    SizedBox(height:50,
                    child:ListView.builder(
            scrollDirection:Axis.horizontal,
            itemCount:categoryList.length,
            itemBuilder:(context ,index){
              return InkWell(
                onTap:(){
                  setState((){
                    categoryName=categoryList[index];
                    print(categoryName);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right:12),
                  child: Container(
                    decoration:BoxDecoration(
                      color:categoryName==categoryList[index]?Colors.blue:Colors.grey,
                      borderRadius:BorderRadius.circular(20)
                    ),
                    child:Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text(categoryList[index].toString(),style:GoogleFonts.poppins(color:Colors.white,fontSize:13))),
                    ),
                  ),
                ),
              );
            }
                    )),
                    SizedBox(height:20),
                    Expanded(
                      child: FutureBuilder<CategoriesNewsModel>(
                        future: newsViewModel.fetchNewsCategoriesApi(categoryName),
                        builder: (BuildContext context, AsyncSnapshot<CategoriesNewsModel> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            // Show loading spinner while fetching data
                            return Center(
                              child: SpinKitCircle(
                                color: Colors.blue,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            // Show an error message if fetching data fails
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (!snapshot.hasData || snapshot.data?.articles?.isEmpty == true) {
                            // Show a message if no data is available
                            return Center(
                              child: Text('No articles available'),
                            );
                          } else {
                            // Return the ListView.builder when data is available
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data!.articles!.length,
                              itemBuilder: (context, index) {
                                DateTime datetime=DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                                return InkWell(
                                  onTap:(){
                                    Navigator.push(context,MaterialPageRoute(builder:(context)=>NewsDetailsScreen(
                                        snapshot.data!.articles![index].urlToImage.toString(),
                                        snapshot.data!.articles![index].title.toString(),
                                        snapshot.data!.articles![index].publishedAt.toString(),
                                        snapshot.data!.articles![index].author.toString(),
                                        snapshot.data!.articles![index].description.toString(),
                                        snapshot.data!.articles![index].source.toString()
                                    )));
                                  },
                                  child: Row(
                                    children:[
                                      ClipRRect(
                                        borderRadius:BorderRadius.circular(15),
                                        child:HashCachedImage(imageUrl:snapshot.data!.articles![index].urlToImage.toString(),
                                          fit:BoxFit.cover,
                                          height:height*.18,
                                          width:width*.3,
                                          placeholder:(BuildContext url)=>Container(child:spinKit2),
                                          errorWidget:(BuildContext, url,error)=>Icon(Icons.error_outline,color:Colors.red)
                                        )
                                      ),
                                      Expanded(
                                        child:Container(
                                      height:height*.18,
                                          padding:EdgeInsets.only(left:15),
                                          child:Column(
                                            children:[
                                              Text(snapshot.data!.articles![index].title.toString(),
                                              maxLines:3,
                                              style:GoogleFonts.poppins(fontSize:15,color:Colors.black54,fontWeight:FontWeight.w700)),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children:[
                                                  Text(snapshot.data!.articles![index].source!.id.toString(),
                                                      maxLines:3,
                                                      style:GoogleFonts.poppins(fontSize:15,color:Colors.blue,)),

                                                  Text(format.format(datetime),//this is jsut for formatig our code
                                                      style:GoogleFonts.poppins(fontSize:15,color:Colors.black54,)),
                                                ]
                                              )
                                            ]
                                          )
                                        )
                                      ),

                                    ]
                                  ),
                                );}
                            );
                          }
                        },
                      ),
                    ),
                  ]
                ),
          )
    );
  }
}
const spinKit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);