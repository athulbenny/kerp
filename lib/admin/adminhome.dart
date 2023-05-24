import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kerp/admin/admin.dart';
import 'package:kerp/admin/verify.dart';
import 'package:kerp/main.dart';
import 'package:http/http.dart' as http;
import '../login.dart';


class Adminhome extends StatefulWidget {
  const Adminhome({required this.pid});
  static final String id="adminhome";
  final String pid;

  @override
  State<Adminhome> createState() => _AdminhomeState(pid);
}

class _AdminhomeState extends State<Adminhome> {
  String pid;
  _AdminhomeState(this.pid);
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();}

  @override
  Widget build(BuildContext context) {
    final pages = [
      Admin(adminid: pid,),
      Verify(adminid: pid),
    ];
    return Scaffold(

      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ), toolbarHeight: MediaQuery.of(context).size.height/15,
        title: Center(child:
        Text('${pid}',style: TextStyle(
            fontSize: 25,fontWeight:FontWeight.w900),)),
        backgroundColor: Colors.green,
        centerTitle: true,
        leading: BackButton(onPressed: (){
          Navigator.of(context).pushNamed(Login.id);
        },),
        actions: [
          PopupMenuButton(
              itemBuilder: (context){
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("My Account"),
                  ),

                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text("Reasons"),
                  ),

                  const PopupMenuItem<int>(
                    value: 2,
                    child: Text("Logout"),
                  ),
                ];
              },
              onSelected:(value){
                if(value == 0){
                  print("My account menu is selected.");
                }else if(value == 1){
                  Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
                    return Scaffold(
                      body: ReasonMessages(pid:pid)
                    );
                  })
                  );
                }else if(value == 2){
                  Navigator.of(context).pushNamed(Login.id);
                }
              }
          ),
        ],
      ),
      body: Container(padding: EdgeInsets.only(left: MediaQuery.of(context).size.height/50,right: MediaQuery.of(context).size.height/50),
          height: MediaQuery.of(context).size.height,child: pages[pageIndex]),
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
        children:[
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
              });
            },
            icon: pageIndex == 0
                ? const Icon(
              Icons.home_filled,
              color: Colors.white,
              size: 35,
            )
                : const Icon(
              Icons.home_outlined,
              color: Colors.white,
              size: 35,
            ),
          ),
        const Text("add tasks")
        ]),
          Column(children:[
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 1;
              });
            },
            icon: pageIndex == 1
                ? const Icon(
              Icons.person_2,
              color: Colors.white,
              size: 35,
            )
                : const Icon(
              Icons.person_2_outlined,
              color: Colors.white,
              size: 35,
            ),
          ),const Text('Verify user')]),
        ],
      ),
    );
  }
}

class ReasonMessages extends StatefulWidget {
  const ReasonMessages({required this.pid});
  final String pid;

  @override
  State<ReasonMessages> createState() => _ReasonMessagesState(pid);
}



class _ReasonMessagesState extends State<ReasonMessages> {
  String pid;_ReasonMessagesState(this.pid);

  Future<dynamic> reasonMessageList() async {//function to get data
    var url =Uri.http(ip,'/kerp/givereason.php');
    var response = await http.post(url, body:{
      "pid":'',
      "loc":'',
      "tdate":"",
      "reason":"",
      "sep":1.toString()
    });print("response is "+response.body);
    var list = json.decode(response.body);
    List<Reasons> reasons =
    await list.map<Reasons>((json) => Reasons.fromJson(json)).toList();
    return reasons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Failure reason", style: TextStyle(
          // color: Theme
          //     .of(context)
          //     .secondaryHeaderColor,
          fontSize: 25,
          fontWeight:
          FontWeight.w600,
        ),
        ),
        centerTitle: true,
        leading: BackButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
            return Scaffold(
              body: Adminhome(pid: pid,)
            );
          })
          );
        },),
        actions: [
          PopupMenuButton(
              itemBuilder: (context){
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("My Account"),
                  ),


                  const PopupMenuItem<int>(
                    value: 2,
                    child: Text("Logout"),
                  ),
                ];
              },
              onSelected:(value){
                if(value == 0){
                  print("My account menu is selected.");
                }else if(value == 2){
                  Navigator.of(context).pushNamed(Login.id);
                }
              }
          ),
        ],
      ),
      body: FutureBuilder<dynamic>(
          future: reasonMessageList(),
          builder: (context, snapshot) {
            List<String> rloc=[],rmsg=[],rdate=[],rpid=[];
            if (snapshot.connectionState == ConnectionState.done) {
              // If we got an error
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'No messages',
                    style: TextStyle(fontSize: 25),
                  ),
                );

                // if we got our data
              } else if (snapshot.hasData) {

                for(int i=0;i<snapshot.data.length;i++){
                  rdate.add(snapshot.data[i].tdate);
                  rloc.add(snapshot.data[i].loc);
                  rmsg.add(snapshot.data[i].reason);
                  rpid.add(snapshot.data[i].pid);
                }

                return Container( padding: EdgeInsets.only(left: MediaQuery.of(context).size.height/100,
                    right: MediaQuery.of(context).size.height/100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height/80,),
                          Container(decoration: BoxDecoration(color: Colors.black),
                            child: Row( children: [
                              Expanded(flex:2,child: Column(children:[Text('pid', style: TextStyle(color: Colors.white,fontSize: 20.0))])),
                              Expanded(flex:1,child: SizedBox(width:1)),
                              Expanded(flex:2,child: Column(children:[Text('date', style: TextStyle(color: Colors.white,fontSize: 20.0))])),
                              Expanded(flex:1,child: SizedBox(width: 1,)),
                              Expanded(flex:3,child: Column(children:[Text('location', style: TextStyle(color: Colors.white,fontSize: 20.0))])),
                              Expanded(flex:1,child: SizedBox(width: 1,)),
                              Expanded(flex:4,child: Column(children:[Text('message', style: TextStyle(color: Colors.white,fontSize: 20.0))])),
                            ]),
                          ),//SizedBox(height: 4,child: Container(color: Colors.black,),),
                        ],
                      ),Container(child:Column(children:[
                        Text("Reasons",style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold),),
                        Container(height:MediaQuery.of(context).size.height/1.25,
                            child: Reason(loc: rloc, pids: rpid, msgs: rmsg,dates: rdate,)),])),
                    ],
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

class Reasons{
  String pid,loc,reason,tdate;

Reasons({ required this.tdate,required this.pid, required this.reason, required this.loc});

factory Reasons.fromJson(Map<String, dynamic> json) {
return Reasons(
pid: json['pid'] as String,
reason: json['reason'] as String,
loc: json['loc'] as String,
tdate: json['tdate'] as String,
//      isVisited: int.parse(json['isVisited']));
);
}
}

class Reason extends StatefulWidget {
  const Reason({required this.loc,required this.pids,required this.msgs,required this.dates});
  final List<String> loc,pids,msgs,dates;
  @override
  State<Reason> createState() => _ReasonState(loc,pids,msgs,dates);
}

class _ReasonState extends State<Reason> {
  List<String> loc,pids,msgs,dates;
  _ReasonState(this.loc,this.pids,this.msgs,this.dates);
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
                    Expanded(flex:2,child: Container(padding: EdgeInsets.only(left: MediaQuery.of(context).size.height/100),
                      child:Text(pids[data], style: TextStyle(fontSize: 20.0)))),
                    //Expanded(flex:0,child: SizedBox(width:5,child: Container(color: Colors.black,),)),
                    Expanded(flex:2,child: Container(child:Text(dates[data].toString(), style: TextStyle(fontSize: 20.0)))),
                    //Expanded(flex:0,child: SizedBox(width: 5,child: Container(color: Colors.black,),)),
                    Expanded(flex:3,child: Container(child:Text(loc[data].toString(), style: TextStyle(fontSize: 20.0)))),
                    //Expanded(flex:0,child: SizedBox(width: 5,child: Container(color: Colors.black,),)),
                    Expanded(flex:3,child: Container(child:Text(msgs[data].toString(), style: TextStyle(fontSize: 20.0)))),
                  ]),
                ),//SizedBox(height: 2,child: Container(color: Colors.black,),),
                // Container(height: 25,width: MediaQuery.of(context).size.width,
                //     color: Colors.orange,child: Text('Reason: '))
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
