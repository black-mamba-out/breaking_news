import 'package:breaking_news/categories.dart';
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
  String _noImageUrl;

  Country _currentCountry;
  List<Country> _countries;

  Category _currentCategory;
  List<Category> _categories;

  Future<List<dynamic>> fetchHeadlines(String url) async {
    var result = await http.get(url);

    return json.decode(result.body)['articles'];
  }

  String getNewsTopHeadlinesUrl() {
    var url = _currentCategory.id == 0
        ? 'https://newsapi.org/v2/top-headlines?country=${_currentCountry.code}&apiKey=$newsApiKey'
        : 'https://newsapi.org/v2/top-headlines?country=${_currentCountry.code}&category=${_currentCategory.name}&apiKey=$newsApiKey';

    return url;
  }

  String getSourceName(Map<dynamic, dynamic> source) {
    return "Source: " + source['source']['name'].toString();
  }

  @override
  void initState() {
    _countries = getCountries();
    _currentCountry = _countries.first;

    _categories = getCategories();
    _currentCategory = _categories.first;

    newsApiKey = "daf31c9b20414856a99ef65f74b8a3b3";
    _noImageUrl =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/600px-No_image_available.svg.png";

    super.initState();
  }

  changeCountry(Country country) {
    setState(() {
      _currentCountry = country;
    });
  }

  changeCategory(Category category) {
    setState(() {
      _currentCategory = category;
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
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: CountriesDropdownList(
                  changeCountry: changeCountry,
                  currentCountry: _currentCountry,
                  countries: _countries,
                ),
              ),
              Expanded(
                child: CategoriesDropdownList(
                  changeCategory: changeCategory,
                  currentCategory: _currentCategory,
                  categories: _categories,
                ),
              ),
            ],
          ),
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
