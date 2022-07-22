import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBackgroundService.initialize(onStart);
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

String changer = 'game_changer';

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  late Timer _timer;
  int count = 0;
  //run task here
  print(changer);
  service.onDataReceived.listen((event) {
    print(event!);

    if (event.containsKey('action')) {
      changer = 'game_changerd';
      return;
    }

    service.setNotificationInfo(
        title: "meu app service", content: "Updated at ${DateTime.now()}");
  });

  _timer = Timer.periodic(Duration(seconds: 2), (timer) {
    Map<String, dynamic> dataToSend = {
      'count': count++,
    };
    service.sendData(dataToSend);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isRunning = true;
  int playCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    FlutterBackgroundService.initialize(onStart);

    //listen for incoming data from the service
    FlutterBackgroundService().onDataReceived.listen((event) {
      print('initState >>> $event');

      if (event!.isNotEmpty && event['count'] != null) {
        setState(() {
          playCount = event['count'] as int;
        });
        print('from service >>> $playCount');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('kjh'),
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
            child: Text('Change val'),
            onPressed: () {
              FlutterBackgroundService().sendData({
                "action": "pode cre",
              });
            },
          ),
          Text(playCount.toString()),
        ],
      )),
    );
  }
}
