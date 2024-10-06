

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hash_cached_image/hash_cached_image.dart';
import 'package:intl/intl.dart';
import 'package:news_app/view/categories-screen.dart';

import '../models/NewsCategoriesModel.dart';
import '../models/news_channel_headlines_model.dart';
import '../view_model/news_view_model.dart';
import 'news_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList{bbcNews,aljazeeraNews,aryNews,independent,cnn,reuters}
FilterList? selectedMenu;
String name='bbc-news';
class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
 final format=DateFormat('MM dd,yyyy');
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width; // Corrected the use of width instead of height for width

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('images/category_icon.png', height: 30, width: 30),
          onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder:(Context)=>CategoriesScreen()));
          },
        ),
        actions:[
          PopupMenuButton<FilterList>(
            onSelected:(FilterList item){
              if(FilterList.bbcNews.name==item.name){
                name='bbc-news';
              }
              if(FilterList.aryNews.name==item.name){
                name='ary-news';
              }
              if(FilterList.aljazeeraNews.name==item.name){
                name='aljazeeraNews';
              }if(FilterList.cnn.name==item.name){
                name='cnn';
              }if(FilterList.reuters.name==item.name){
                name='reuters';
              }if(FilterList.independent.name==item.name){
                name='independent';
              }
              setState((){
                selectedMenu=item;
              });
            },
            icon:Icon(Icons.more_vert,color:Colors.black,),
            initialValue:selectedMenu,
            itemBuilder: (context)=><PopupMenuEntry<FilterList>>[
            PopupMenuItem(
              child: Text('bbcNews',style:TextStyle()),
            value:FilterList.bbcNews,
            ),
              PopupMenuItem(
                child: Text('aryNews',style:TextStyle()),
                value:FilterList.aryNews,
              ),
              PopupMenuItem(
                child: Text('aljazeeraNews',style:TextStyle()),
                value:FilterList.aljazeeraNews,
              ),
              PopupMenuItem(
                child: Text('cnn',style:TextStyle()),
                value:FilterList.cnn,
              ),
              PopupMenuItem(
                child: Text('reuters',style:TextStyle()),
                value:FilterList.reuters,
              ),
              PopupMenuItem(
                child: Text('independent',style:TextStyle()),
                value:FilterList.independent,
              )
    ]

          )
        ],
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('News', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700)),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            width: width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
              future: newsViewModel.fetchNewsChannelHeadlinesApi(name),
              builder: (BuildContext context, AsyncSnapshot<NewsChannelsHeadlinesModel> snapshot) {
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
                    scrollDirection: Axis.horizontal,
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
                        child: SizedBox(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height:height *0.6,
                                width:width*0.9,
                                padding:EdgeInsets.symmetric(horizontal:height*0.02),

                                child: ClipRRect(
                                  borderRadius:BorderRadius.circular(15),
                                  child: HashCachedImage(
                                    imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                    fit: BoxFit.cover,
                                    placeholder: (BuildContext url) => Container(child: spinKit2),
                                    errorWidget: (context, error, url) => Icon(Icons.error_outline, color: Colors.red),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom:20,
                                child: Card(
                                  elevation:5,
                                  shape:RoundedRectangleBorder(
                                    borderRadius:BorderRadius.circular(12)
                                  ),
                                  child:Container(
                                    height:height*.22,
                                    alignment:Alignment.bottomCenter,
                                    padding:EdgeInsets.all(15),
                                    child:Column(
                                      mainAxisAlignment:MainAxisAlignment.center,
                                      crossAxisAlignment:CrossAxisAlignment.center,
                                      children:[
                                        Container(
                                          width:width*0.7,
                                          child:Text(snapshot.data!.articles![index].title.toString(),maxLines:3,
                                          overflow:TextOverflow.ellipsis,
                                          style:GoogleFonts.poppins(fontSize:17,fontWeight:FontWeight.w700))
                                        ),
                                        Spacer(),
                                        Container(
                                          child:Row(
                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                            children:[
                                              Text(snapshot.data!.articles![index].source!.id.toString(),maxLines:3,
                                            overflow:TextOverflow.ellipsis,
                                            style:GoogleFonts.poppins(color:Colors.blue,fontSize:12,fontWeight:FontWeight.w700)),
                                               SizedBox(width:90),
                                              Text(format.format(datetime),maxLines:3,
                                                  overflow:TextOverflow.ellipsis,
                                                  style:GoogleFonts.poppins(fontSize:12,fontWeight:FontWeight.w700))
                                            ]
                                          )
                                        )
                                      ]
                                    )
                                  )
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchNewsCategoriesApi('All'),
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
                    shrinkWrap:true,
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
        ],
      ),
    );
  }
}

const spinKit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
