import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// AWS Amplify
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

// other plugins
import 'package:awsapp/drawer/app_drawer.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = 'user';
  String _imageURL = 'https://i.imgur.com/t2915gE.png';
  final bucketObjects = <StorageItem>[];
  int lastObj = 0;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _getItem();
  }

  // get the name of the user
  Future<void> _getUser() async {
    try {
      var att = await Amplify.Auth.fetchUserAttributes(); // get user attribute
      name = att[2].value; // get user name
      print("username is : " + name);
    } on AuthException catch (e) {
      print(e.message);
    }
  }

  // get the latest log
  Future<void> _getItem() async {
    try {
      print("getting item ......");
      final ListResult res = await Amplify.Storage.list();
      final List<StorageItem> object = res.items;
      object.forEach((element) {
        print(element);
        setState(() {
          bucketObjects.add(element);
        });
      });
      bucketObjects.sort((a, b) => a.lastModified!.compareTo(b.lastModified!));
      lastObj = object.length - 1;
      print("image name is " + bucketObjects[lastObj].key[0]);

      S3GetUrlOptions options =
          S3GetUrlOptions(accessLevel: StorageAccessLevel.guest);
      final GetUrlResult iRes = await Amplify.Storage.getUrl(
          key: bucketObjects[lastObj].key, options: options);
      setState(() {
        _imageURL = iRes.url;
      });
    } on StorageException catch (e) {
      print('GetUrl Err: $e');
    }
  }

  Future<bool> _fetchData() => Future.delayed(Duration(seconds: 1), () async {
        _getUser();
        return true;
      });

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
          return Scaffold(
            appBar: AppBar(
              title: Text("Welcome back, " + name),
              backgroundColor: Colors.teal[800],
            ),
            drawer: AppDrawer(),
            body: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              onLoading: _onLoading,
              onRefresh: _onRefresh,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Image.asset(
                        'assets/images/logo-512.png',
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 40.0),
                      child: Text(
                        'My Guard',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'latest image:',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/log');
                      },
                      child: Column(
                        children: <Widget>[
                          (bucketObjects.length > 0)
                              ? Card(
                                  child: ListTile(
                                    title: Text(
                                      DateFormat('yyyy-MM-dd - HH:mm').format(
                                          bucketObjects[lastObj]
                                              .lastModified!
                                              .add(Duration(hours: 12))),
                                    ),
                                    subtitle: Text(bucketObjects[lastObj].key),
                                  ),
                                )
                              : Text("Please Refresh The Page"),
                          Padding(
                            padding: EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Image.network(_imageURL),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      });
}
