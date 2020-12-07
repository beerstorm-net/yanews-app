import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../blocs/app_navigator/app_navigator_bloc.dart';
import '../models/main_repository.dart';
import '../models/news_item.dart';
import '../shared/common_utils.dart';
import '../shared/screen_size_config.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScreenSizeConfig screenSizeConfig = ScreenSizeConfig();
  MainRepository _mainRepository;
  List<NewsItem> _items = List();
  String pageSizeDefault = "20";
  String countryDefault = "no";
  // set default params, and update per request!
  Map<String, String> _reqParams = Map()
    ..putIfAbsent("isHeadlines", () => "true")
    ..putIfAbsent("page", () => "0")
    ..putIfAbsent("pageSize", () => "20")
    ..putIfAbsent("country", () => "no")
    ..putIfAbsent("q", () => null);

  @override
  void initState() {
    super.initState();
  }

  RefreshController _refreshController = RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext buildContext) {
    screenSizeConfig.init(buildContext);

    if (_mainRepository == null) {
      _mainRepository = RepositoryProvider.of<MainRepository>(context);
      CommonUtils.logger.d("repository isReady: ${_mainRepository != null}");
    }

    return BlocListener<AppNavigatorBloc, AppNavigatorState>(
        listener: (context, state) {
          BlocProvider.of<AppNavigatorBloc>(context)
              .add(WarnUserEvent(List<String>()..add("progress_stop")));
          if (state is ItemsLoaded) {
            setState(() {
              //_coins = state.coins;
              _items.addAll(state.items);
              _refreshController.refreshCompleted();
            });
          }
        },
        child: Container(
          child: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: true,
            header: WaterDropMaterialHeader(),
            onRefresh: () {
              BlocProvider.of<AppNavigatorBloc>(context).add(
                  WarnUserEvent(List<String>()..add("progress_start"), message: "in progress.."));
              BlocProvider.of<AppNavigatorBloc>(context).add(LoadItemsEvent(reqParams: _reqParams));
            },
            onLoading: () {
              // infinite loading
              String page = _reqParams['page'];
              if (CommonUtils.nullSafe(page).isEmpty) {
                page = "0";
              }
              String pageSize = _reqParams['pageSize'];
              if (CommonUtils.nullSafe(pageSize).isEmpty) {
                pageSize = pageSizeDefault;
              }
              if (_items.isNotEmpty && (_items.length == int.parse(pageSize))) {
                page = (int.parse(page) + int.parse(pageSize)).toString();
                _reqParams['page'] = page;

                BlocProvider.of<AppNavigatorBloc>(context)
                    .add(LoadItemsEvent(reqParams: _reqParams));
              }
            },
            child: ListView.builder(
              itemCount: _items.length,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                final NewsItem _item = _items[index];
                return _itemCard(_item);
              },
            ),
          ),
        ));
  }

  _itemCard(NewsItem item) {
    return Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
        margin: EdgeInsets.all(4.0),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(16.0),
              onTap: () => CommonUtils.launchURL(item.url),
              isThreeLine: true,
              leading: _networkImage(item.urlToImage),
              title: Container(
                alignment: Alignment.center,
                child: Expanded(
                  child: Text(
                    "${item.title}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              subtitle: Text(
                "${item.description}",
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 8),
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("${CommonUtils.humanizeDateText(item.publishedAt)}",
                      style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                  Text(
                    "${item.author}",
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    "${item.source?.name}",
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.clip,
                  ),
                ],
              ),
            )
          ],
        ));
  }

  _networkImage(String imageUrl) => CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        width: screenSizeConfig.safeBlockHorizontal * 22,
        height: screenSizeConfig.safeBlockVertical * 22,
        fit: BoxFit.fill,
      );
}
