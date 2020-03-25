import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:glug_app/models/blog_post_model.dart';
import 'package:glug_app/screens/webpage.dart';
import 'package:html/parser.dart';

class Blog extends StatelessWidget {
  static final id = 'blog';

  final BlogPost post;

  Blog({this.post});

  String _parseHtmlString(String htmlString) {
    var document = parse(htmlString);

    String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  String _getDate(String s) {
    DateTime dateTime = DateTime.parse(s).toLocal();
    var date = formatDate(dateTime, [dd, '/', mm, '/', yyyy]);
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          post.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                constraints: BoxConstraints.expand(
                  height: 300.0,
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(post.thumbnail_image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.calendar_today),
                SizedBox(
                  width: 5.0,
                ),
                Text(_getDate(post.date_to_show)),
                SizedBox(
                  width: 10.0,
                ),
                Icon(Icons.edit),
                SizedBox(
                  width: 5.0,
                ),
                Text(post.author_name),
              ],
            ),
//            SizedBox(
//              height: 30.0,
//            ),
//            Padding(
//              padding: EdgeInsets.symmetric(
//                vertical: 10.0,
//                horizontal: 10.0,
//              ),
//              child: Text(
//                _parseHtmlString(post.content_body),
//                style: TextStyle(
//                  color: Colors.grey,
//                ),
//                overflow: TextOverflow.visible,
//              ),
//            ),
            SizedBox(
              height: 20.0,
            ),
            Html(
              data: post.content_body,
              //Optional parameters:
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),

              defaultTextStyle: TextStyle(fontFamily: 'serif'),
              linkStyle: const TextStyle(
                color: Colors.blueAccent,
              ),
              useRichText: false,
              onLinkTap: (url) {
                print("Opening $url");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebPage(
                              URL: url,
                            )));
              },
              onImageTap: (src) {
                // Display the image in large form.
              },
            ),
          ],
        ),
      ),
    );
  }
}