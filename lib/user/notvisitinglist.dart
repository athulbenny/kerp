//this is the visited and non visited list of individual in individual's page

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kerp/main.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'dart:async';

class NotVisitingList extends StatefulWidget {
  const NotVisitingList({required this.pid,required this.isVisited});
  static final String id="visitinglist";
  final String pid;final int isVisited;
  @override
  State<NotVisitingList> createState() => _NotVisitingListState(pid,isVisited);
}

class _NotVisitingListState extends State<NotVisitingList> {
  String pid;int isVisited;_NotVisitingListState(this.pid,this.isVisited);

  @override
  void initState() {super.initState();  Timer.periodic(Duration(seconds: 10), (timer) =>setState(() {}));}
  //late EmployeeDataSource employeeDataSource;
  late List<GridColumn> _columns;

  Future<dynamic> generateUserList() async {
    String tdate=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).toString();
    print(pid);//function to get data
    var url =Uri.http(ip,'/kerp/userloc.php');
    var response = await http.post(url, body:{
      "tablename": pid,
      "isVisited":isVisited.toString(),
      "Tdate":tdate,
    });print("response is "+response.body);
    var list = json.decode(response.body);
    List<Employee> _employees =
    await list.map<Employee>((json) => Employee.fromJson(json)).toList();
    return _employees;
  }
  @override
  Widget build(BuildContext context) {
    int isv=isVisited;
    return SafeArea(
      child: Scaffold(
        body:  Column(
            children:[
              FutureBuilder<dynamic>(
                  future: generateUserList(),
                  builder: (context, snapshot) {
                    List<String> locatevisit=[],tdate=[];List<double> latvisit=[],longvisit=[];
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If we got an error
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'Location not visited',
                            style: TextStyle(fontSize: 25),
                          ),
                        );

                        // if we got our data
                      } else if (snapshot.hasData) {

                        for(int i=0;i<snapshot.data.length;i++){
                          tdate.add(snapshot.data[i].tdate);
                          locatevisit.add(snapshot.data[i].loc);
                          latvisit.add(snapshot.data[i].latitude);
                          longvisit.add(snapshot.data[i].longitude);
                        }
                        print(tdate);
                        //print(notvisit);
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height/80,child: Container(),),
                                Container(
                                  decoration: BoxDecoration(
                                      color:Colors.black
                                  ),
                                  child: Row( children: [
                                    Expanded(flex:3,child: Column(children:[Text('location', style: TextStyle(color:Colors.white,fontSize: 20.0))])),
                                    Expanded(flex:1,child: SizedBox(width:1)),
                                    Expanded(flex:2,child: Column(children:[Text('latitude', style: TextStyle(color:Colors.green,fontSize: 20.0))])),
                                    Expanded(flex:1,child: SizedBox(width: 5,)),
                                    Expanded(flex:2,child: Column(children:[Text('longitud', style: TextStyle(color:Colors.green,fontSize: 20.0))])),
                                    Expanded(flex:1,child: SizedBox(width: 5,)),
                                    Expanded(flex:2,child: Column(children:[Text('date', style: TextStyle(color: Colors.white,fontSize: 20.0))])),
                                  ]),
                                ),SizedBox(height: 4,child: Container(color: Colors.black,),),
                              ],
                            ),Container(child:Column(children:[
                              Text("TO BE VISITED",style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold),),
                              Container(decoration: BoxDecoration(
                                 // border: Border.all(color: Colors.black)
                              ),height:MediaQuery.of(context).size.height/1.40,
                                  child: Visited(loc: locatevisit, lat: latvisit, long: longvisit,isv:isv,tdate: tdate,)),])),
                          ],
                        );
                      }
                    }
                    return CircularProgressIndicator();
                  }
              ),
            ]),
      ),
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
  const Visited({required this.loc,required this.lat,required this.long,required this.isv,required this.tdate});
  final List<double> lat,long;final List<String> loc,tdate;final int isv;

  @override
  State<Visited> createState() => _VisitedState(loc,lat,long,isv,tdate);
}

class _VisitedState extends State<Visited> {
  List<double> lat,long;List<String> loc,tdate;int isv;
  _VisitedState(this.loc,this.lat,this.long,this.isv,this.tdate);

  @override
  void initState() {super.initState();
}
  //late EmployeeDataSource employeeDataSource;
  //late List<GridColumn> _columns;

  // Future<dynamic> generateUserList() async {
  //   print(pid); //function to get data
  //   var url = Uri.http(ip, '/kerp/userloc.php');
  //   var response = await http.post(url, body: {
  //     "tablename": pid,
  //     "isVisited":isv.toString()
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
          return Card(elevation: 10,shadowColor: Colors.black87,
            child: Column(
              children: [
                //SizedBox(height: 3,child: Container(color: Colors.black,),),
                Container(
                  height: MediaQuery.of(context).size.height/6,//color:Colors.yellow,
                  child: Row( children: [
                    Expanded(flex:3,child: Container(padding: EdgeInsets.only(left: MediaQuery.of(context).size.height/100),
                        child:Text(loc[data], style: TextStyle(fontSize: 20.0)))),
                    //Expanded(flex:0,child: SizedBox(width:5,child: Container(color: Colors.black,),)),
                    Expanded(flex:2,child: Container(child:Text(lat[data].toString(), style: TextStyle(color:Colors.green,fontSize: 20.0)))),
                    //Expanded(flex:0,child: SizedBox(width: 5,child: Container(color: Colors.black,),)),
                    Expanded(flex:2,child: Container(child:Text(long[data].toString(), style: TextStyle(color:Colors.green,fontSize: 20.0)))),
                    //Expanded(flex:0,child: SizedBox(width: 5,child: Container(color: Colors.black,),)),
                    Expanded(flex:2,child: Container(child:Text(tdate[data].toString(), style: TextStyle(fontSize: 20.0)))),
                  ]),
                ),//SizedBox(height: 2,child: Container(color: Colors.black,),),
              ],
            ),
          );
        },separatorBuilder: (context,index){
          return Container(height: MediaQuery.of(context).size.height/65,);
      },
      ),
    );
  }
}