import 'package:flutter/material.dart';
import 'package:rammus/rammus.dart'  as rammus;


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void initState() {
    super.initState();
    initPlatformState();
    rammus.initCloudChannelResult.listen((data) {
      print(
          "----------->init successful ${data.isSuccessful} ${data
              .errorCode} ${data.errorMessage}");
    });

    var channels = List<rammus.NotificationChannel>();
    channels.add(rammus.NotificationChannel(
      "centralized_activity",
      "集中活动",
      "集中活动",
      importance: rammus.AndroidNotificationImportance.MAX,
    ));
    channels.add(rammus.NotificationChannel(
      "psychological_tests",
      "心理测评",
      "心理测评",
      importance: rammus.AndroidNotificationImportance.MAX,
    ));
    channels.add(rammus.NotificationChannel(
      "system_notice",
      "公告信息",
      "公告信息",
      importance: rammus.AndroidNotificationImportance.MAX,
    ));
    rammus.setupNotificationManager(channels);

    rammus.onNotification.listen((data) {
      print("----------->notification here ${data.summary}");
      setState(() {
        _platformVersion = data.summary;
      });
    });
    rammus.onNotificationOpened.listen((data) {
      print("-----------> ${data.summary} 被点了");
      setState(() {
        _platformVersion = "${data.summary} 被点了";
      });
    });

    rammus.onNotificationRemoved.listen((data) {
      print("-----------> $data 被删除了");
    });

    rammus.onNotificationReceivedInApp.listen((data) {
      print("-----------> ${data.summary} In app");
    });

    rammus.onNotificationClickedWithNoAction.listen((data) {
      print("${data.summary} no action");
    });

    rammus.onMessageArrived.listen((data) {
      print("received data -> ${data.content}");
      setState(() {
        _platformVersion = data.content;
      });
    });
    getDeviceId();
  }
  String _platformVersion = 'Unknown';

  getDeviceId() async {
    var deviceId = await rammus.deviceId;
    print(
        "----------->deviceId $deviceId");
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      platformVersion = await Rammus.platformVersion;
//    } on PlatformException {
//      platformVersion = 'Failed to get platform version.';
//    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('push'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }

}
