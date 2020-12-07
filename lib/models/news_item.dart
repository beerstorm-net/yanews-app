/// {
//       "source": {
//         "id": null,
//         "name": "CoinDesk"
//       },
//       "author": "Tanzeel Akhtar",
//       "title": "Crypto Exchange Bittrex Lists Tokenized Apple, Amazon, Tesla Stocks for Trading",
//       "description": "Bittrex will list tokenized stocks such as Apple, Tesla and Amazon on its digital asset exchange.",
//       "url": "https://www.coindesk.com/index.php?p=551484",
//       "urlToImage": "https://static.coindesk.com/wp-content/uploads/2018/08/shutterstock_1015316194-1200x628.jpg",
//       "publishedAt": "2020-12-07T15:00:04Z",
//       "content": "Bittrex Global has launched trading in tokenized stocks such as Apple, Tesla and Amazon on its digital asset exchange.\r\n&lt;ul&gt;&lt;li&gt;The platform said traders and investors will have direct access to list… [+1663 chars]"
//     }

class NewsItem {
  NewsSource _source;
  String _author;
  String _title;
  String _description;
  String _url;
  String _urlToImage;
  String _publishedAt;
  String _content;

  NewsSource get source => _source;
  String get author => _author;
  String get title => _title;
  String get description => _description;
  String get url => _url;
  String get urlToImage => _urlToImage;
  String get publishedAt => _publishedAt;
  String get content => _content;

  NewsItem(
      {NewsSource source,
      String author,
      String title,
      String description,
      String url,
      String urlToImage,
      String publishedAt,
      String content}) {
    _source = source;
    _author = author;
    _title = title;
    _description = description;
    _url = url;
    _urlToImage = urlToImage;
    _publishedAt = publishedAt;
    _content = content;
  }

  NewsItem.fromJson(dynamic json) {
    _source =
        json["source"] != null ? NewsSource.fromJson(json["source"]) : null;
    _author = json["author"];
    _title = json["title"];
    _description = json["description"];
    _url = json["url"];
    _urlToImage = json["urlToImage"];
    _publishedAt = json["publishedAt"];
    _content = json["content"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_source != null) {
      map["source"] = _source.toJson();
    }
    map["author"] = _author;
    map["title"] = _title;
    map["description"] = _description;
    map["url"] = _url;
    map["urlToImage"] = _urlToImage;
    map["publishedAt"] = _publishedAt;
    map["content"] = _content;
    return map;
  }
}

class NewsSource {
  dynamic _id;
  String _name;

  dynamic get id => _id;
  String get name => _name;

  NewsSource({dynamic id, String name}) {
    _id = id;
    _name = name;
  }

  NewsSource.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    return map;
  }
}
