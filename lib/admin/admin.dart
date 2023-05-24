import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kerp/admin/adminhome.dart';
import 'package:kerp/admin/calenderad.dart';
import 'package:kerp/admin/visitinglistad.dart';
import 'package:kerp/login.dart';
import 'package:kerp/main.dart';
import 'package:kerp/admin/failedvisit.dart';
import 'package:kerp/admin/notvisiting.dart';
import 'package:kerp/admin/visiting.dart';
import 'dart:async';
import 'package:badges/badges.dart' as badges;

class Admin extends StatefulWidget {
  const Admin({required this.adminid});
  static final String id="admin";
  final String adminid;

  @override
  State<Admin> createState() => _AdminState(adminid);
}

class _AdminState extends State<Admin> {
  _AdminState(this.adminid);
  String adminid;
  @override
  void initState() {super.initState();}

  Future<dynamic> generateUserList() async { //function to get data
    var url =Uri.http(ip,'/kerp/admindata.php');
    var response = await http.post(url, body:{
      "tablename": adminid,
      "sep":"1",
    });print(response.body);
    var list = json.decode(response.body);
    List<Employee> _employees =
    await list.map<Employee>((json) => Employee.fromJson(json)).toList();
    return _employees;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body:  Column(
          children:[
            FutureBuilder<dynamic>(
                future: generateUserList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If we got an error
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'NO USERS...KINDLY WAIT',
                          style: TextStyle(fontSize: 25,color: Colors.red),
                        ),
                      );

                      // if we got our data
                    } else if (snapshot.hasData) {
                      List<String> pid=[];
                      for(int i=0;i<snapshot.data.length;i++){
                        print(pid);
                        pid.add(snapshot.data[i].pid );
                      }print(pid);
                      return Cardiovtasks(pid: pid,adminid:adminid);
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
  String pid;
  Employee({  required this.pid});
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
        pid: json['pid'] as String);
  }
}

class UserCard {
  String pid,username,adminid;
  UserCard({required this.pid,required this.username,required this.adminid});
  factory UserCard.fromJson(Map<String, dynamic> json) {
    return UserCard(
        pid: json['pid'] as String,
        username: json['username'] as String,
        adminid: json['adminid'] as String);
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }}

class Cardiovtasks extends StatefulWidget {
  const Cardiovtasks({required this.pid,required this.adminid});
  final List<String> pid;final String adminid;

  @override
  State<Cardiovtasks> createState() => _CardiovtasksState(pid,adminid);
}

class _CardiovtasksState extends State<Cardiovtasks> {
  List<String> pid;String adminid;
  _CardiovtasksState(this.pid,this.adminid);
  @override
  void initState() {super.initState();}

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
        //backgroundColor: Colors.grey,
          body: Container(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/20),
            child: ListView.separated(
        itemCount: pid.length,
        itemBuilder: (context, index) {
      return Card(elevation: 10,shadowColor: Colors.black87,
        child: Column(
            children: [
              //SizedBox(height: 3,child: Container(color: Colors.black,),),
              GestureDetector(onTap: (){
                Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
                  return Scaffold(
                      body: AdminUserView(pid: pid[index],adminid: adminid,)
                  );
                })
                );
              },
                child: Container(
                  height: MediaQuery.of(context).size.height/15,//color:Colors.yellow,
                  child: ListTile(
                    leading: Text(pid[index]),
                    trailing: IconButton(
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
                        return Scaffold(
                        body: Calenderad(pid: pid[index],isChanged:0,tid:0)
                        );
                        }));
                        },
                      icon: Icon(Icons.add_task),
                    ),
                  )
                ),
              ),//SizedBox(height: 2,child: Container(color: Colors.black,),),
            ],
        ),
      );
    },
    separatorBuilder: (context,index){
    return Container(height: MediaQuery.of(context).size.height/65,);
    },
    ),
          ),
      ),
    );
  }
}

class AdminUserView extends StatefulWidget {
  const AdminUserView({required this.pid,required this.adminid});
  static final String id="adminUserView";
  final String pid,adminid;


  @override
  State<AdminUserView> createState() => _AdminUserViewState(pid,adminid);
}

class _AdminUserViewState extends State<AdminUserView> {
_AdminUserViewState(this.pid,this.adminid);String pid,adminid;
  @override
  void initState() {super.initState();}

  @override
  Widget build(BuildContext context) {

    //String adminid="police999";
    Future<dynamic> displayUser(String pid1) async{
      var url =Uri.http(ip,'/kerp/displayaccounts.php');
      var response = await http.post(url,body: {
        "pid":pid1,
      });
      var list = json.decode(response.body);
      List<UserCard> userCard =
      await list.map<UserCard>((json) => UserCard.fromJson(json)).toList();
      return userCard;
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: (){Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
            return Scaffold(
              body: Adminhome(pid: adminid)
            );
          }));}),title: Text("${pid}'s Page"),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),toolbarHeight: MediaQuery.of(context).size.height/20,
        backgroundColor: Colors.green,
        centerTitle: true,
        actions: [
          IconButton(
          onPressed: (){Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
    return Scaffold(
    body: AdminUserView(pid: pid,adminid: adminid,),
    );
    })
    );},
      icon: Icon(Icons.back_hand),),
          PopupMenuButton(
              itemBuilder: (context){
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("Visited Lists"),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text("Upcoming  List"),
                  ),
                  const PopupMenuItem<int>(
                    value: 2,
                    child: Text("Failed Visits"),
                  ),
                  const PopupMenuItem<int>(
                    value: 3,
                    child: Text("Logout"),
                  ),
                ];
              },
              onSelected:(value){
                if(value == 0){
                  Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
                    return Scaffold(
                      body: VisitingList(pid: pid,isVisited: 1,)
                    );
                  })
                  );
                }else if(value == 1){
                Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
                return Scaffold(
                body: NotVisitingList(pid: pid,isVisited: 0,),
                );
                })
                );}else if(value == 2){
                  Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
                    return Scaffold(
                      body: FailedVisit(pid: pid),
                    );
                  })
                  );
                }else if(value == 3){
                  Navigator.of(context).pushNamed(Login.id);
                }
              }
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(flex: 1,
            child: FutureBuilder<dynamic>(
                future: displayUser(pid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If we got an error
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'NO TASKS ASSIGNED',
                          style: TextStyle(fontSize: 25,color: Colors.red),
                        ),
                      );

                      // if we got our data
                    } else if (snapshot.hasData) {
                      adminid=snapshot.data[0].adminid;
                      return Container(
                        height: MediaQuery.of(context).size.height/1,
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.person,size: MediaQuery.of(context).size.height/10,),
                              Text(snapshot.data[0].username,style: TextStyle(color: Colors.blue,fontSize: 25),),
                              Text(snapshot.data[0].pid),
                              Text(snapshot.data[0].adminid),
                              ElevatedButton(onPressed: (){
                                Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
                                  return Scaffold(
                                      body: Calenderad(pid: snapshot.data[0].pid,isChanged: 0,tid: 0,)
                                  );
                                }));
                              }, child:const Text("Add tasks"),),
                            ],
                          ),
                        ),
                      );
                    }
                  }
                  return CircularProgressIndicator();
                }
            ),
          ),
          //
          Expanded(flex:3,child: Container(padding: EdgeInsets.only(left: MediaQuery.of(context).size.height/100,right: MediaQuery.of(context).size.height/100),
          height:MediaQuery.of(context).size.height/2,child: VisitingListad(pid: pid))),
          //Expanded(flex:0,child: ElevatedButton(onPressed: (){}, child: Text(''))),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,selectedItemColor: Colors.indigo,
        items:const [
          BottomNavigationBarItem(icon: Icon(Icons.find_in_page),label: "Today's task"),
          BottomNavigationBarItem(icon: Icon(Icons.logout,),label: 'Logout'),
        ],onTap: (index){
        if(index==1)
          Navigator.of(context).pushNamed(Login.id);
      },
      ),
    );
  }
}

/*

            crossAxisCount: 3,
            crossAxisSpacing: MediaQuery.of(context).size.width/500,
            mainAxisSpacing: MediaQuery.of(context).size.height/300,
            shrinkWrap: true,
            children: List.generate(pid.length, (index) {
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  child: Container(
                    color: Colors.orange,
                    child: Column(
                      children: [
                        SizedBox.fromSize(size: Size.fromHeight(MediaQuery.of(context).size.height/100)),
                        Text("${pid[index]}",style:  TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,),),
                        SizedBox.fromSize(size: Size.fromHeight(MediaQuery.of(context).size.height/27)),
                        ElevatedButton(onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
                            return Scaffold(
                                body: Calenderad(pid: pid[index],isChanged:0,tid:0)
                            );
                          }));
                        }, child: Text("Add tasks"),)
                      ],
                    ),
                  ),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
                      return Scaffold(
                          body: AdminUserView(pid: pid[index],adminid: adminid,)
                      );
                    })
                    );
                  },
                ),
              );
            },),
          )
 */