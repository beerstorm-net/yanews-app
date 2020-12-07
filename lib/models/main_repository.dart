import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:yanews_app/models/news_item.dart';

import '../shared/common_utils.dart';
import '../shared/hive_store.dart';

class MainRepository {
  final HiveStore _hiveStore;
  final RemoteConfig _remoteConfig;
  RemoteConfig get remoteConfig => _remoteConfig;
  HiveStore get hiveStore => _hiveStore;

  static initHiveStore(hiveBox) => HiveStore(hiveBox: hiveBox);
  MainRepository({Box hiveBox, RemoteConfig remoteConfig})
      : _hiveStore = initHiveStore(hiveBox),
        _remoteConfig = remoteConfig;

  /// https://newsapi.org/docs/endpoints/everything
  /// https://newsapi.org/docs/endpoints/top-headlines
  Future<List<NewsItem>> apiGetNews(Map<String, String> reqParams) async {
    List<NewsItem> newsItems = List();

    Map<String, String> reqHeaders = Map()
      ..putIfAbsent("X-Api-Key", () => _remoteConfig.getString("newsapi_key"));

    String reqUrl = _remoteConfig.getString("newsapi_url");
    reqUrl += (reqParams.containsKey("isHeadlines")
        ? _remoteConfig.getString("newsapi_headlines")
        : _remoteConfig.getString("newsapi_all"));

    reqUrl = CommonUtils.appendParamToUrl(reqUrl, "page", reqParams['page']);
    reqUrl = CommonUtils.appendParamToUrl(reqUrl, "pageSize", reqParams['pageSize']);
    reqUrl = CommonUtils.appendParamToUrl(reqUrl, "country", reqParams['country']);
    reqUrl = CommonUtils.appendParamToUrl(reqUrl, "q", reqParams['q']);

    try {
      final response = await http.get(reqUrl, headers: reqHeaders);
      if (response.statusCode <= 201) {
        Map<String, dynamic> responseMap = json.decode(response.body);
        if (responseMap.containsKey("articles")) {
          List<dynamic> dataItems = responseMap["articles"] as List;
          dataItems.forEach((dataItem) {
            newsItems.add(NewsItem.fromJson(dataItem));
          });
        }
      }
    } catch (ex) {
      CommonUtils.logger.e(ex);
    }

    return newsItems;
  }
}
