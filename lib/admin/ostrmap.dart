import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kerp/admin/osm.dart';

class Ostrmap extends StatefulWidget {
  const Ostrmap({required this.pid,required this.Tdate,required this.isChanged,required this.tid});
  static final String id="ostrmap";
  final String pid,Tdate;final int isChanged,tid;

  // @override
  // void dispose() {
  //   Timer? _timer;
  //   if (_timer != null) {
  //     _timer.cancel();
  //     _timer = null;
  //   }
  // }

  @override
  State<Ostrmap> createState() => _OstrmapState(pid,Tdate,isChanged,tid);
}

class _OstrmapState extends State<Ostrmap> {
  String pid;String Tdate;int isChanged,tid;
  _OstrmapState(this.pid,this.Tdate,this.isChanged,this.tid);

  @override
  void initState() {super.initState();}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,
        title: Text('MAP'),backgroundColor: Colors.green,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ), toolbarHeight: MediaQuery.of(context).size.height/15,
      ),
      body: OpenStreetMapSearchAndPick(
        Tdate: Tdate,
          pid: pid,
          isChanged:isChanged,
          tid:tid,
          center: LatLong(11.873595198897403,75.37102790426799),
          buttonColor: Colors.deepOrange,
          buttonTextColor: Colors.black,
          buttonText: 'Save the Selected Location',
          onPicked: (pickedData) {
            print(pickedData.latLong.latitude);
            print(pickedData.latLong.longitude);
            //print(pickedData.address);
          }),
    );
  }
}