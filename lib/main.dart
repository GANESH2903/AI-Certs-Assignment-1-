import 'dart:async';
import 'package:alaram/Model/Model.dart';
import 'package:alaram/Provider/Provier.dart';
import 'package:alaram/Screen/Add_Alarm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import 'package:another_flushbar/flushbar.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .requestNotificationsPermission();

  runApp(ChangeNotifierProvider(
    create: (contex) => alarmprovider(),
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool value = false;

  @override
  void initState() {
    context.read<alarmprovider>().Inituilize(context);
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });

    super.initState();
    context.read<alarmprovider>().GetData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        actions: [],
        title: const Text(
          'My Reminder ',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,),
            height: MediaQuery.of(context).size.height * 0.08,
            child: Container(
              margin: EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white),
              height: MediaQuery.of(context).size.height*0.08,
              child: Center(
                  child: Text(
                    DateFormat.yMEd().add_jms().format(
                      DateTime.now(),
                    ),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black),
                  )),
            ),
          ),
          Consumer<alarmprovider>(builder: (context, alarm, child) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: ListView.builder(
                  itemCount: alarm.modelist.length,
                  itemBuilder: (BuildContext, index) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          alarm.modelist[index].dateTime!,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text("|" +
                                              alarm.modelist[index].label
                                                  .toString()),
                                        ),
                                      ],
                                    ),
                                    CupertinoSwitch(
                                        value:(alarm.modelist[index].milliseconds! < DateTime.now().microsecondsSinceEpoch)? false:alarm.modelist[index].check,
                                        onChanged: (v) {
                                          alarm.EditSwitch(index, v);
                                          alarm.CancelNotification(alarm.modelist[index].id!);

                                        }),
                                  ],
                                ),
                                Text(alarm.modelist[index].when!)
                              ],
                            ),
                          ),
                        ));
                  }),
            );
          }),
          CircleAvatar(
            backgroundColor: Colors.indigo,
            radius: MediaQuery.sizeOf(context).width*0.075,
            child: Center(
                child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddAlarm()));
              },
              child: CircleAvatar(
                radius: MediaQuery.sizeOf(context).width*0.063,
                child: Center(
                  child: Icon(Icons.add,size: MediaQuery.sizeOf(context).width*0.1),
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }
}


