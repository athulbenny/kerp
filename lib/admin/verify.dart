import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kerp/admin/admin.dart';
import 'package:kerp/main.dart';
import 'dart:async';
import '../login.dart';

class Verify extends StatefulWidget {
  const Verify({required this.adminid});
  static final String id="Verify";
  final String adminid;

  @override
  State<Verify> createState() => _VerifyState(adminid);
}

class _VerifyState extends State<Verify> {
  _VerifyState(this.adminid);
  String adminid;

  @override
  void initState() {super.initState();Timer.periodic(Duration(seconds: 2), (timer) =>setState(() {}));}

  Future<dynamic> generateUserList() async { //function to get data
    var url =Uri.http(ip,'/kerp/admindata.php');
    var response = await http.post(url, body:{
      "tablename": adminid,
      "sep":"0",
    });
    var list = json.decode(response.body);
    List<Employee> _employees =
    await list.map<Employee>((json) => Employee.fromJson(json)).toList();
    return _employees;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Column(
          children:[
            FutureBuilder<dynamic>(
                future: generateUserList(),
                builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
            return const Center(
              child : Text('NO MORE USER TO BE VERIFIED',style: TextStyle(fontSize: 18,color: Colors.red),)
            );
            } else if (snapshot.hasData) {
              List<String> pid=[];
              for(int i=0;i<snapshot.data.length;i++){
                pid.add(snapshot.data[i].pid );
              print(pid);
            }
            return Cardioverfiy(pid: pid,adminid:adminid);
            }
            }
            return LinearProgressIndicator();
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

class Cardioverfiy extends StatefulWidget {
  const Cardioverfiy({required this.pid,required this.adminid});
final List<String> pid;final String adminid;

  @override
  State<Cardioverfiy> createState() => _CardioverfiyState(pid,adminid);
}

class _CardioverfiyState extends State<Cardioverfiy> {
  List<String> pid;
  String adminid;
  _CardioverfiyState(this.pid,this.adminid);

  @override
  void initState() {super.initState();}
IconData iconvar=Icons.verified_outlined;
  @override
  Widget build(BuildContext context) {

    Future<dynamic> updateUserList(String pid1) async{
      var url =Uri.http(ip,'/kerp/verifyuser.php');
      var response = await http.post(url,body: {
        "pid":pid1,
        "adminid":adminid,
      });//print(response);
    }

    return Expanded(
      child: Scaffold(
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
                                  updateUserList(pid[index]);
                                },
                                icon: Icon(iconvar),
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
  final String pid,adminid;

  @override
  State<AdminUserView> createState() => _AdminUserViewState(pid,adminid);
}

class _AdminUserViewState extends State<AdminUserView> {
  _AdminUserViewState(this.pid,this.adminid);
  String pid,adminid;
  @override
  Widget build(BuildContext context) {

    Future<dynamic> displayUser(String pid1) async{
      var url =Uri.http(ip,'/kerp/displayaccounts.php');
      var response = await http.post(url,body: {
        "pid":pid1,
      });
      var list = json.decode(response.body);
      List<UserCard> userCard =
      await list.map<UserCard>((json) => UserCard.fromJson(json)).toList();
      //employeeDataSource = EmployeeDataSource(_employees);
      return userCard;
    }

    Future<dynamic> updateUserList(String pid1) async{
      var url =Uri.http(ip,'/kerp/verifyuser.php');
      var response = await http.post(url,body: {
        "pid":pid1,
        "adminid":adminid,
      });//print(response);
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: Colors.green,title: Text('Verify user'),centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),toolbarHeight: MediaQuery.of(context).size.height/20,
      ),
      body: FutureBuilder<dynamic>(
          future: displayUser(pid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If we got an error
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'NO USER',
                    style: TextStyle(fontSize: 18),
                  ),
                );

                // if we got our data
              } else if (snapshot.hasData) {
                return Container(
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.person,size: MediaQuery.of(context).size.height/10,),
                          Text(snapshot.data[0].username),
                          Text(snapshot.data[0].pid),
                          Text(snapshot.data[0].adminid),
                          ElevatedButton(onPressed: (){
                            updateUserList(pid);setState(() {
                            });
                          }, child: Text("verify"),)
                        ],
                      ),
                    ),
                );
              }
            }
            return CircularProgressIndicator();
          }
      ),
    );
  }
}

/*
GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: MediaQuery.of(context).size.width/500,
            mainAxisSpacing: MediaQuery.of(context).size.height/100,
            shrinkWrap: true,
            children: List.generate(pid.length, (index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  child: Container(
                    color: Colors.brown[400],
                    child: Column(
                      children: [
                        SizedBox.fromSize(size: Size.fromHeight(MediaQuery.of(context).size.height/100)),
                        Text("${pid[index]}",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w900,color: Colors.yellow),),
                        SizedBox.fromSize(size: Size.fromHeight(MediaQuery.of(context).size.height/30)),
                        ElevatedButton(onPressed: (){
                          updateUserList(pid[index]);

                        }, child: Text("verify"),)
                      ],
                    ),
                  ),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
                      return Scaffold(
                        body: AdminUserView(pid: pid[index],adminid: adminid)
                      );
                    })
                    );
                  },
                ),
              );
            },),
          )
 */