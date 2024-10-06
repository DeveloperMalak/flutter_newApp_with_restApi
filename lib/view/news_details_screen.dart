import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hash_cached_image/hash_cached_image.dart';
import 'package:intl/intl.dart';
class NewsDetailsScreen extends StatefulWidget {
  String newsImage;
  String newsTitle;
  String newsDate;
  String newsAuthor;
  String newsDesc;
 // String newsContent;
  String newsSource;
   NewsDetailsScreen(this.newsImage,this.newsTitle,this.newsDate,this.newsAuthor,this.newsDesc,//this.newsContent,
       this.newsSource) ;

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  final format= DateFormat('MM dd,yyyy ');
  @override
  void initState(){
    super.initState();
    print(widget.newsDesc);
  }
  Widget build(BuildContext context) {
    double Kwidth = MediaQuery.of(context).size.width;
    double Kheight = MediaQuery.of(context).size.height;
    DateTime datetime=DateTime.parse(widget.newsDate);
    return Scaffold(
         appBar:AppBar(
           elevation:0,
           leading:IconButton(
             onPressed:(){
               Navigator.pop(context);
             },
             icon: Icon(Icons.arrow_back),
             color:Colors.grey[600]

         )
         ),
      body:Stack(
        children:[
          Container(
            child:Container(
              height:Kheight*0.45,
              width:Kwidth,
              child:ClipRRect(
                borderRadius:BorderRadius.only(
                    topLeft:Radius.circular(30),
                    topRight:Radius.circular(30)),
                child:HashCachedImage(
                  imageUrl:widget.newsImage,
                  fit:BoxFit.cover,
                  placeholder:(BuildContext url)=>CircularProgressIndicator(),
                  errorWidget:(Context, error ,url)=>new Icon(Icons.error)
                )
              )
            )
          ),
          Container(
            margin:EdgeInsets.only(top:Kheight*0.4),
            padding:EdgeInsets.only(top:20,right:20,left:20),
            height:Kheight*0.6,
            decoration:BoxDecoration(
              color:Colors.white,
              borderRadius:BorderRadius.only(
                topLeft:Radius.circular(30),
                topRight:Radius.circular(30),
              )
            ),
            child:ListView(
              children:[
                Text(widget.newsTitle,
                style:GoogleFonts.poppins(fontSize:20,color:Colors.black87,fontWeight:FontWeight.w700)),
                SizedBox(height:Kheight*0.02),
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children:[
                    Expanded(
                      child:Container(
                        child:Text(widget.newsSource,softWrap:true,
                        overflow:TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w600),),

                      )
                    ),
                    Text(format.format(datetime),
                    softWrap:true,
                    overflow:TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500),)
                  ]
                ),
                SizedBox(height:Kheight*0.03),
                Text(widget.newsDesc,
                style:GoogleFonts.poppins(fontSize:15,color:Colors.black87,
                fontWeight:FontWeight.w500))
              ]
            )
          )
        ]
      )
    );
  }
}
