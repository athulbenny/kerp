import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kerp/main.dart';

import '../login.dart';

class FailedVisit extends StatefulWidget {
  const FailedVisit({required this.pid});
  final String pid;

  @override
  State<FailedVisit> createState() => _FailedVisitState(pid);
}

class _FailedVisitState extends State<FailedVisit> {
  String pid;_FailedVisitState(this.pid);
  @override
  void initState() {super.initState();  Timer.periodic(Duration(seconds: 10), (timer) =>setState(() {}));}
  //late EmployeeDataSource employeeDataSource;
  // late List<GridColumn> _columns;

  Future<dynamic> generateUserList() async {
    String tdate=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).toString();
    print(pid);//function to get data
    var url =Uri.http(ip,'/kerp/userloc.php');
    var response = await http.post(url, body:{
      "tablename": pid,
      "isVisited":2.toString(),
      "Tdate":tdate,
    });print("response is "+response.body);
    var list = json.decode(response.body);
    List<Employee> _employees =
    await list.map<Employee>((json) => Employee.fromJson(json)).toList();
    return _employees;
  }
  @override
  Widget build(BuildContext context) {
    int isv=0;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),title: Text("${pid}'s Page"),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),toolbarHeight: MediaQuery.of(context).size.height/20,
        backgroundColor: Colors.green,
      ),
      body:  Column(
          children:[
            FutureBuilder<dynamic>(
                future: generateUserList(),
                builder: (context, snapshot) {
                  List<String> locatevisit=[],tdate=[];List<double> latvisit=[],longvisit=[];
                  List<String> plocatevisit=[],ptdate=[];List<double> platvisit=[],plongvisit=[];
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
                      // DateTime currentdate= DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);
                      // for(int j=0;j<tdate.length;j++){
                      //   if(DateTime.parse(tdate[j])==currentdate){
                      //
                      //   }
                      // }

                      //print(notvisit);
                      return Container( padding: EdgeInsets.only(left: MediaQuery.of(context).size.height/100,
                          right: MediaQuery.of(context).size.height/100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height/80,),
                                Container(decoration: BoxDecoration(
                                  color: Colors.black
                                ),
                                  child: Row( children: [
                                    Expanded(flex:3,child: Column(children:[Text('location', style: TextStyle(fontSize: 20.0,color: Colors.white))])),
                                    Expanded(flex:1,child: SizedBox(width:1)),
                                    Expanded(flex:2,child: Column(children:[Text('latitude', style: TextStyle(color:Colors.green,fontSize: 20.0))])),
                                    Expanded(flex:1,child: SizedBox(width: 5,)),
                                    Expanded(flex:2,child: Column(children:[Text('longitud', style: TextStyle(color:Colors.green,fontSize: 20.0))])),
                                    Expanded(flex:1,child: SizedBox(width: 5,)),
                                    Expanded(flex:2,child: Column(children:[Text('date', style: TextStyle(fontSize: 20.0,color: Colors.white))])),
                                  ]),
                                ),//SizedBox(height: 4,child: Container(color: Colors.black,),),
                              ],
                            ),
                              //SizedBox(height: MediaQuery.of(context).size.height/40,),
                              Container(decoration: BoxDecoration(
                                  //border: Border.all(color: Colors.black)
                              ),
                                  height:MediaQuery.of(context).size.height/1.234,
                                  child: FVisited(loc: locatevisit, lat: latvisit, long: longvisit,isv:isv,tdate: tdate,)),
                            ]
                        ),
                      );
                    }
                  }
                  return CircularProgressIndicator();
                }
            ),
          ]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,selectedItemColor: Colors.indigo,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.find_in_page),label: 'Failed Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.logout,),label: 'logout'),
        ],onTap: (index){
        if(index==1)
          Navigator.of(context).pushNamed(Login.id);
      },
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


class FVisited extends StatefulWidget {
  const FVisited({required this.loc,required this.lat,required this.long,required this.isv,required this.tdate});
  final List<double> lat,long;final List<String> loc,tdate;final int isv;

  @override
  State<FVisited> createState() => _FVisitedState(loc,lat,long,isv,tdate);
}

class _FVisitedState extends State<FVisited> {
  List<double> lat,long;List<String> loc,tdate;int isv;
  _FVisitedState(this.loc,this.lat,this.long,this.isv,this.tdate);

  @override
  void initState() {super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: loc.length,
        itemBuilder: (context, data) {
          return Card(shadowColor: Colors.black87,elevation: 10,
            child: Column(
              children: [
                //SizedBox(height: 3,child: Container(color: Colors.black,),),
                Container(
                  height: MediaQuery.of(context).size.height/6,//color:Colors.yellow,
                  child: Row( children: [
                    Expanded(flex:3,child: Container(padding: EdgeInsets.only(left: MediaQuery.of(context).size.height/100),
                      child:Text(loc[data], style: TextStyle(fontSize: 20.0)))),
                    //Expanded(flex:0,child: SizedBox(width:2,child: Container(color: Colors.black,),)),
                    Expanded(flex:2,child: Container(child:Text(lat[data].toString(), style: TextStyle(color:Colors.green,fontSize: 20.0)))),
                    //Expanded(flex:0,child: SizedBox(width: 2,child: Container(color: Colors.black,),)),
                    Expanded(flex:2,child: Container(child:Text(long[data].toString(), style: TextStyle(color:Colors.green,fontSize: 20.0)))),
                    //Expanded(flex:0,child: SizedBox(width: 2,child: Container(color: Colors.black,),)),
                    Expanded(flex:2,child: Container(child:Text(tdate[data].toString(), style: TextStyle(fontSize: 20.0)))),
                  ]),
                ),//SizedBox(height: 2,child: Container(color: Colors.black,),),
                // Container(height: 25,width: MediaQuery.of(context).size.width,
                //     color: Colors.orange,child: Text('Reason: '))
              ],
            ),
          );
        },
        separatorBuilder: (context,index){
          return Container(height: MediaQuery.of(context).size.height/65,);
        },
      ),
    );
  }
}

