import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// other plugins
import 'dart:core';
import 'package:intl/intl.dart';

// AWS Amplify
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:awsapp/drawer/app_drawer.dart';
import 'package:awsapp/models/ModelProvider.dart';
import 'package:awsapp/models/Sensor.dart';

String _imageURL = 'https://i.imgur.com/t2915gE.png';
String _imageTime = '1999-05-17';

class LogPage extends StatefulWidget {
  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  String loadingIcon = '⚇';
  bool showFirstObject = false;

  final bucketObjects = <StorageItem>[];
  List<String> bucketImages = <String>[];
  List<Sensor> sensors = <Sensor>[];

  TextEditingController _sensor1Controller =
      TextEditingController(text: 'Sensor 1');
  TextEditingController _sensor2Controller =
      TextEditingController(text: 'Sensor 2');

  @override
  void initState() {
    super.initState();
    readSensor(0);
    getItem(0);
  }

  // to get the log image
  Future<void> getItem(int i) async {
    // Post newPost = Post(title: "New Post", rating: 15);
    // await Amplify.DataStore.save(newPost);

    bucketObjects.clear();
    bucketImages.clear();
    _imageURL = 'https://i.imgur.com/t2915gE.png';
    try {
      // List<Post> posts = await Amplify.DataStore.query(Post.classType);
      // posts.forEach((element) {
      //   print(element.id);
      // });

      print("getting item ......");
      final ListResult res = await Amplify.Storage.list();
      final List<StorageItem> object = res.items;
      object.forEach((element) {
        print(element);
        setState(() {
          if ((element.key != '1st/') &&
              (element.key[0] == '1') &&
              ((i == 0) || (i == 1))) {
            element.eTag = '1st sensor';
            bucketObjects.add(element);
            bucketImages.add('https://i.imgur.com/t2915gE.png');
          } else if ((element.key != '2nd/') &&
              (element.key[0] == '2') &&
              ((i == 0) || (i == 2))) {
            element.eTag = '2nd sensor';
            bucketObjects.add(element);
            bucketImages.add('https://i.imgur.com/t2915gE.png');
          }
        });
      });
      // sort the object according to time
      bucketObjects.sort((a, b) => b.lastModified!.compareTo(a.lastModified!));
    } on StorageException catch (e) {
      print('GetUrl Err: $e');
    }
  }

  // rename image name with their relvant sensors
  String getImageName(String eTag, String key) {
    if (key[0] == '1') {
      key = key.replaceAll('1st/', '');
    } else if (key[0] == '2') {
      key = key.replaceAll('2nd/', '');
    }
    return eTag + ' - ' + key;
  }

  // get the url to show the image
  Future<void> getURL(int i, String key) async {
    try {
      S3GetUrlOptions options =
          S3GetUrlOptions(accessLevel: StorageAccessLevel.guest);
      final GetUrlResult res =
          await Amplify.Storage.getUrl(key: key, options: options);
      setState(() {
        _imageURL = res.url;
        bucketImages[i] = res.url;
      });
    } on StorageException catch (e) {
      print(e.message);
    }
  }

  // pop-up notification when removing the images
  Future<void> alertRemove(String key) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure?"),
          content: Text(
              "Do you really want to delete this log history? This process cannot be undone."),
          actions: [
            TextButton(
              onPressed: () {
                removeFile(key);
                Navigator.pop(context);
              },
              child: Text(
                'Confirm',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  // remove a image from the log
  Future<void> removeFile(String key) async {
    try {
      final RemoveResult res = await Amplify.Storage.remove(key: key);
      getItem(0);
      print("${res.key} is deleted");
      const botBar = SnackBar(
          content: Text("removing image ..."), duration: Duration(seconds: 3));
      ScaffoldMessenger.of(context).showSnackBar(botBar);
    } on StorageException catch (e) {
      print(e.message);
    }
  }

  // read the current sensors name
  Future<void> readSensor(int i) async {
    try {
      sensors = await Amplify.DataStore.query(Sensor.classType);

      _sensor1Controller.text = sensors[0].title;
      _sensor2Controller.text = sensors[1].title;

      print("Sensors:");
      print(sensors[0].title);
      print(sensors[1].title);
    } catch (e) {
      print(e);
    }
    print('finished reading sensor');
  }

  // change sensor name
  Future<void> _renameSensor(BuildContext context,
      TextEditingController controller, String sensor) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New $sensor Name'),
          content: TextField(
            onChanged: (value) {},
            controller: controller,
            decoration: InputDecoration(hintText: "Room 1"),
          ),
        );
      },
    ).then((value) async {
      try {
        int sensorID = 0;
        if (controller == _sensor1Controller) {
          sensorID = 0;
        } else if (controller == _sensor2Controller) {
          sensorID = 1;
        }

        print("Controller Text : \n $controller.text");
        // update sensor
        Sensor oldS =
            (await Amplify.DataStore.query(Sensor.classType))[sensorID];
        Sensor newS = oldS.copyWith(id: oldS.id, title: controller.text);
        await Amplify.DataStore.save(newS);
      } catch (e) {
        print(e);
      }
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
        appBar: AppBar(
          title: Text("Logs"),
          backgroundColor: Colors.teal[800],
        ),
        drawer: AppDrawer(),
        body: Column(
          children: <Widget>[
            // Image
            Padding(
              padding: EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ImageScreen();
                  }));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Image.network(_imageURL),
                ),
              ),
            ),
            // Refresh
            Padding(
              padding: EdgeInsets.all(5.0),
              child: ElevatedButton(
                onPressed: () {
                  getItem(0);
                  loadingIcon = '⚆';
                },
                child: Text('Refresh $loadingIcon'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal[800],
                  textStyle: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            // Sensor
            Padding(
              padding: EdgeInsets.all(5.0),
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: new Text(
                                'Select Sensor (long pressed to rename)',
                                style: TextStyle(
                                  color: Colors.teal[800],
                                ),
                              ),
                              onTap: () {},
                            ),
                            ListTile(
                              leading: new Icon(Icons.view_comfy),
                              title: new Text('All Sensors'),
                              onTap: () {
                                getItem(0);
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: new Icon(Icons.sensors),
                              title: new Text(_sensor1Controller.text),
                              onTap: () {
                                getItem(1);
                                Navigator.pop(context);
                              },
                              onLongPress: () {
                                _renameSensor(
                                    context, _sensor1Controller, 'Sensor 1');
                              },
                            ),
                            ListTile(
                              leading: new Icon(Icons.sensors),
                              title: new Text(_sensor2Controller.text),
                              onTap: () {
                                getItem(2);
                                Navigator.pop(context);
                              },
                              onLongPress: () {
                                _renameSensor(
                                    context, _sensor2Controller, 'Sensor 2');
                              },
                            ),
                          ],
                        );
                      });
                },
                child: Text('Sensors'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal[800],
                  textStyle: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text("Click image on top to zoom-in"),
            ),
            Expanded(
              child: new ListView.builder(
                padding: EdgeInsets.all(10.0),
                shrinkWrap: true,
                itemCount: bucketObjects.length,
                itemBuilder: (context, i) {
                  String? time = DateFormat('yyyy-MM-dd - HH:mm').format(
                      bucketObjects[i].lastModified!.add(Duration(hours: 12)));
                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        bucketImages[i],
                        width: 70,
                        height: 70,
                      ),
                      title: Text(time),
                      subtitle: Text(getImageName(
                          bucketObjects[i].eTag!, bucketObjects[i].key)),
                      onTap: () {
                        _imageTime = time;
                        getURL(i, bucketObjects[i].key);
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // const botBar = SnackBar(
                          //     content: Text('removing...'),
                          //     duration: Duration(seconds: 3));
                          // ScaffoldMessenger.of(context).showSnackBar(botBar);
                          alertRemove(bucketObjects[i].key);
                          // removeFile(bucketObjects[i].key);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}

// enlarge the selected image
class ImageScreen extends StatelessWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[800],
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    child: Hero(
                      tag: 'heroImage',
                      child: Image.network(_imageURL),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      _imageTime,
                      style: TextStyle(color: Colors.white, fontSize: 25.0),
                    ),
                  )
                ],
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
