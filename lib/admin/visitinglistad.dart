//this is the visited and non visited list of individual in admin

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kerp/admin/calenderad.dart';
import 'package:kerp/main.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:async';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:location/location.dart';

import 'ostrmap.dart';

class VisitingListad extends StatefulWidget {
  const VisitingListad({required this.pid});
  static final String id="visitinglist";
  final String pid;
  @override
  State<VisitingListad> createState() => _VisitingListadState(pid);
}

class _VisitingListadState extends State<VisitingListad> {
  String pid;_VisitingListadState(this.pid);

  @override
  void initState() {super.initState();}

  Future<dynamic> generateTodayList() async {
    print(pid);//function to get data
    String tdate=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).toString();
    var url =Uri.http(ip,'/kerp/userloc.php');
    var response = await http.post(url, body:{
      "tablename": pid,
      "isVisited":3.toString(),
      "Tdate":tdate,
    });print("response is "+response.body);
    var list = json.decode(response.body);
    List<Employee> _employees =
    await list.map<Employee>((json) => Employee.fromJson(json)).toList();
    //employeeDataSource = EmployeeDataSource(_employees);
    return _employees;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
            children:[
              FutureBuilder<dynamic>(
                  future: generateTodayList(),
                  builder: (context, snapshot) {
                    List<int> tid=[];
                    List<String> tlocatevisit=[];List<double> tlatvisit=[],tlongvisit=[];
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If we got an error
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'DATA TO BE ASSIGNED',
                            style: TextStyle(fontSize: 18),
                          ),
                        );

                        // if we got our data
                      } else if (snapshot.hasData) {

                        for(int i=0;i<snapshot.data.length;i++){
                            tid.add(snapshot.data[i].id);
                            tlocatevisit.add(snapshot.data[i].loc);
                            tlatvisit.add(snapshot.data[i].latitude);
                            tlongvisit.add(snapshot.data[i].longitude);

                        }
                        //print(notvisit);
                        return Column(
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 3,child: Container(color: Colors.black,),),
                                Text("TODAY'S TASK",style: TextStyle(color: Colors.pink,fontSize: 50,fontWeight: FontWeight.bold),),

                                Container(decoration: BoxDecoration(
                                    color: Colors.black
                                ),
                                  child: Row( children: [
                                    Expanded(flex:2,child: Column(children:[Text('latitude', style: TextStyle(color:Colors.green,fontSize: 20.0))])),
                                    Expanded(flex:1,child: SizedBox(width: 1,)),
                                    Expanded(flex:2,child: Column(children:[Text('longitude', style: TextStyle(color:Colors.green,fontSize: 20.0))])),
                                    Expanded(flex:1,child: SizedBox(width: 1,)),
                                    Expanded(flex:3,child: Column(children:[Text('location', style: TextStyle(color:Colors.white,fontSize: 20.0))])),
                                  ]),
                                ),SizedBox(height: 4,child: Container(color: Colors.black,),),
                              ],
                            ),
                            Container(decoration: BoxDecoration(
                               // border: Border.all(color: Colors.black)
                            ),height:MediaQuery.of(context).size.height/1.82,
                                child: Visited(loc: tlocatevisit, lat: tlatvisit, long: tlongvisit,tid:tid,pid:pid)),
                            ],
                        );
                      }
                    }
                    return CircularProgressIndicator();
                  }
              ),

            ]),
    );
  }

}

class Employee {
  int id;
  double latitude;
  double longitude;
  String loc,tdate;
//  int isVisited;

  Employee({ required this.tdate,required this.id, required this.latitude, required this.longitude, required this.loc});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: int.parse(json['id']),
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      loc: json['loc'] as String,
      tdate: json['Tdate'] as String,
      //      isVisited: int.parse(json['isVisited']));
    );
  }
}


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }}

class Visited extends StatefulWidget {
  const Visited({required this.loc,required this.lat,required this.long,required this.tid,required this.pid});
  final List<double> lat,long;final List<String> loc;final List<int> tid;final String pid;

  @override
  State<Visited> createState() => _VisitedState(loc,lat,long,tid,pid);
}

class _VisitedState extends State<Visited> {
  List<double> lat,long;List<String> loc;List<int> tid;String pid;
  _VisitedState(this.loc,this.lat,this.long,this.tid,this.pid );

  @override
  void initState() {super.initState();}

  // Future<dynamic> generateUserList() async {
  //   print(pid); //function to get data
  //   var url = Uri.http(ip, '/kerp/userlocad.php');
  //   var response = await http.post(url, body: {
  //     "tablename": pid
  //   });
  //   print("response is " + response.body);
  //   var list = json.decode(response.body);
  //   List<Employee> _employees =
  //   await list.map<Employee>((json) => Employee.fromJson(json)).toList();
  //   // employeeDataSource = EmployeeDataSource(_employees);
  //   return _employees;
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: loc.length,
        itemBuilder: (context, data) {
          return Card(elevation: 10, shadowColor: Colors.black87,
              child: Column(
                children: [
                  //SizedBox(height: 3,child: Container(color: Colors.black,),),
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: GestureDetector(
                      onTap: () {
                        changedata(tid[data], pid);
                      },
                      child: Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height / 8, //color:Colors.yellow,
                        child: Row(children: [
                          Expanded(flex: 2,
                              child: Container(
                                  padding: EdgeInsets.only(left: MediaQuery
                                      .of(context)
                                      .size
                                      .height / 100),
                                  child: Text(lat[data].toString(),
                                      style: TextStyle(color: Colors.green,
                                          fontSize: 20.0)))),
                          //Expanded(flex:0,child: SizedBox(width: 5,child: Container(color: Colors.black,),)),
                          Expanded(flex: 2,
                              child: Container(child: Text(
                                  long[data].toString(), style: TextStyle(
                                  color: Colors.green, fontSize: 20.0)))),
                          //Expanded(flex:0,child: SizedBox(width: 5,child: Container(color: Colors.black,),)),
                          Expanded(flex: 3,
                              child: Container(child: Text(loc[data],
                                  style: TextStyle(fontSize: 20.0)))),
                        ]),
                      ),
                    ),
                  ),
                  //SizedBox(height: 2,child: Container(color: Colors.black,),),
                ],
              ),
          );
        }, separatorBuilder: (context, index) {
        return Container(height: MediaQuery
            .of(context)
            .size
            .height / 65,);
      },
      ),
    );
  }



  Future<void> changedata(id,pid) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            actions: <Widget>[
              Text('OPTIONS'),
              TextButton(
                child: const Text('Change Data'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
                    return Scaffold(
                        body: Calenderad(pid: pid,isChanged: 1,tid:id)
                    );
                  }));
                  //Navigator.of(context).pop();
                },
              ), TextButton(
                child: const Text('Delete Data'),
                onPressed: () async {
                  String tdate=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).toString();
                    String e="efgh";int isChanged=2;
                    final response = await http.post(Uri.http(ip,"/kerp/insertlocation.php"), body: {
                      "tablename":pid,
                      "latitude": lat[0].toString(),
                      "longitude": long[0].toString(),
                      "loc":loc[0],
                      "Tdate":tdate,
                      "isChanged":isChanged.toString(),
                      "id":id.toString(),
                    });
                  //   print(response.body);
                  //   return Future.error("error"+e);
                  // }
                },
              ),
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}