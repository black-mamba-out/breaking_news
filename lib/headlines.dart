import 'package:breaking_news/countries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class HeadlineList extends StatefulWidget {
  @override
  _HeadlineListState createState() => _HeadlineListState();
}

class _HeadlineListState extends State<HeadlineList> {
  String newsApiKey;
  Country _country;
  List<Country> _countries;
  String _noImageUrl;

  Future<List<dynamic>> fetchHeadlines(String url) async {
    var result = await http.get(url);

    return json.decode(result.body)['articles'];
  }

  String getNewsTopHeadlinesUrl() {
    return 'https://newsapi.org/v2/top-headlines?country=${_country.code}&apiKey=$newsApiKey';
  }

  String getSourceName(Map<dynamic, dynamic> source) {
    return "Source: " + source['source']['name'].toString();
  }

  @override
  void initState() {
    _countries = getCountries();
    _country = _countries.first;
    newsApiKey = "daf31c9b20414856a99ef65f74b8a3b3";
    _noImageUrl =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/600px-No_image_available.svg.png";

    super.initState();
  }

  changeCountry(Country country) {
    setState(() {
      _country = country;
    });
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Headlines'),
      ),
      body: Column(
        children: <Widget>[
          CountriesDropdownList(
              changeCountry: changeCountry,
              currentCountry: _country,
              countries: _countries),
          Expanded(
            child: FutureBuilder<dynamic>(
              future: fetchHeadlines(getNewsTopHeadlinesUrl()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print(getSourceName(snapshot.data[0]));
                  return ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImageWithRetry(
                                    snapshot.data[index]['urlToImage'] == null
                                        ? _noImageUrl
                                        : snapshot.data[index]['urlToImage']),
                              ),
                              title: Text(snapshot.data[index]['title'] == null
                                  ? ""
                                  : snapshot.data[index]['title']),
                              subtitle: Text(
                                  snapshot.data[index]['description'] == null
                                      ? ""
                                      : snapshot.data[index]['description']),
                              onTap: () => launchURL(
                                  snapshot.data[index]['url'] == null
                                      ? ""
                                      : snapshot.data[index]['url']),
                            )
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
