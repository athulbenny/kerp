import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kerp/main.dart';
import 'package:kerp/user/calender.dart';
import 'package:kerp/user/failedvisit.dart';
import 'package:kerp/user/visitinglist.dart';
import 'package:location/location.dart';
import '../login.dart';
import 'notvisitinglist.dart';

class Individual extends StatefulWidget {
  const Individual({required this.pid});
  static final String id="individual";
  final String pid;

  @override
  State<Individual> createState() => _IndividualState(pid);
}

class _IndividualState extends State<Individual> {
  _IndividualState(this.pid);

 // List<String> locarray=['kannur','kozhikkode'],datearray=['2023-05-18','2023-05-19'];

  @override
  void initState() {
    super.initState();
  }

  String pid;
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      NotVisitingList(pid: pid,isVisited:0),
      VisitingList(pid: pid,isVisited:1),
      Locat(pid: pid),
      FailedVisit(pid: pid),
      //Calendpass(pid: pid),
    ];
    return Scaffold(
      //resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("$pid", style: const TextStyle(
          // color: Theme
          //     .of(context)
          //     .secondaryHeaderColor,
          fontSize: 25,
          fontWeight:
          FontWeight.w600,
        ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ), toolbarHeight: MediaQuery.of(context).size.height/15,
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
                    child: Text("calendar"),
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
                      body: Calendpass(pid: pid,),
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
      body: SingleChildScrollView(physics: const NeverScrollableScrollPhysics(),
          child: Container(padding: EdgeInsets.only(left: MediaQuery.of(context).size.height/100,right: MediaQuery.of(context).size.height/100),
              height: MediaQuery.of(context).size.height,child: pages[pageIndex])),
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
        children: [
        IconButton(
        enableFeedback: false,
        onPressed: () {
        setState(() {
        pageIndex = 0;
        });
        },
        icon: pageIndex == 0
        ? const Icon(
        Icons.visibility_off,
        color: Colors.white,
        size: 35,
        )
            : const Icon(
        Icons.visibility_off_outlined,
        color: Colors.white,
        size: 35,
        ),
        ),
        const Text("To Be Visited")]),
        Column(children: [
        IconButton(
        enableFeedback: false,
        onPressed: () {
        setState(() {
        pageIndex = 1;
        });
        },
        icon: pageIndex == 1
        ? const Icon(
        Icons.visibility,
        color: Colors.white,
        size: 35,
        )
            :  const Icon(Icons.visibility_outlined,
        color: Colors.white,
        size: 35,
        ),
        ), const Text('Visited')]),
        Column(children: [
        IconButton(
        enableFeedback: false,
        onPressed: () {
        setState(() {
        pageIndex = 2;
        });
        },
        icon: pageIndex == 2
        ? const Icon(
        Icons.location_on_sharp,
        color: Colors.red,
        size: 25,
        )
            : FloatingActionButton( child: const Icon(Icons.location_on_outlined,size: 25,weight: 50,color: Colors.red,),
        onPressed: () {
        startloc();
        },
        ),
        ), const Text('start location')]),
        Column(children: [
        IconButton(
        enableFeedback: false,
        onPressed: () {
        setState(() {
        pageIndex = 3;
        });
        },
        icon: pageIndex == 3
        ? const Icon(
        Icons.visibility_off,
        color: Colors.red,
        size: 35,
        )
            :  const Icon(Icons.visibility_off_outlined,
        color: Colors.red,
        size: 35,
        ),
        ), const Text('fail to Visited')]),
        Column(children: [
        IconButton(
        enableFeedback: false,
        onPressed: () {
        setState(() {
        pageIndex = 4;
        });
        },
        icon: pageIndex == 4
        ? const Icon(
        Icons.calendar_month,
        color: Colors.white,
        size: 35,
        )
            :  const Icon(Icons.calendar_month_outlined,
        color: Colors.white,
        size: 35,
        ),
        ), const Text('Calender')]),
        ],
        ),
        );
  }
}
  void startloc() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    double? latx = _locationData.latitude;
    double? longx = _locationData.longitude;
    print(latx!);
    print(longx!);
    location.enableBackgroundMode(enable: true);
  }

  class Employee {
  int id;
  double latitude;
  double longitude;
  String loc;
  int isVisited;
  String Tdate;

  Employee({ required this.Tdate,required this.id, required this.latitude, required this.longitude, required this.loc,required this.isVisited});

  factory Employee.fromJson(Map<String, dynamic> json) {
  return Employee(
  id: int.parse(json['id']),
  latitude: double.parse(json['latitude']),
  longitude: double.parse(json['longitude']),
  loc: json['loc'] as String,
  Tdate: json['Tdate'] as String,
  isVisited: int.parse(json['isVisited']));

  }
  }

class Locat extends StatefulWidget {
  const Locat({required this.pid});
  final String pid;

  @override
  State<Locat> createState() => _LocatState(pid);
}

class _LocatState extends State<Locat> {
  String pid;
  _LocatState(this.pid);

  @override
  void initState() {
    super.initState();}
  void trackloc(List<double> lat,List<double>lng, List<int> id) {
    Location location = new Location();
    double lat1,lon1;
    location.onLocationChanged.listen((LocationData currentLocation) {
      double? lat2 = currentLocation.latitude,
          lon2 = currentLocation.longitude;//1 - searching         2 - current
      for(int i=0;i<lat.length;i++){
        lat1=lat[i];lon1=lng[i];
        double p = 0.017453292519943295;
        double a = 0.5 - cos((lat2! - lat1) * p) / 2 +
            cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2! - lon1) * p)) / 2;
        double x = 12742 * asin(sqrt(a));
        if (x <= 0.5000) {
          updateLoc(id[i]);print("yes........"+x.toString());print(id[i]);}
        else {print("no");}}
    });
  }

  Future<dynamic> updateLoc(int i) async {
 // print(pid); //function to get data
  var url = Uri.http(ip, '/kerp/updateloc.php');
  var response = await http.post(url, body: {
  "tablename": pid,
    "id":i.toString(),
  });}

  Future<dynamic> generateUserList() async {
    print(pid); //function to get data
    String tdate=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).toString();
    var url = Uri.http(ip, '/kerp/userloc.php');
    var response = await http.post(url, body: {
      "tablename": pid,
      "isVisited":3.toString(),
      "Tdate":tdate,
    });
    var list = json.decode(response.body);
    List<Employee> _employees =
    await list.map<Employee>((json) => Employee.fromJson(json)).toList();
    return _employees;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: generateUserList(),
        builder: (context, snapshot) {
          List<int> id=[];
          List<double> latarray=[],longarray=[];
          List<String> locarray=[],datearray=[];
          if (snapshot.connectionState == ConnectionState.done) {
            // If we got an error
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'network error',
                  style: TextStyle(fontSize: 18),
                ),
              );

              // if we got our data
            } else if (snapshot.hasData) {

              for(int i=0;i<snapshot.data.length;i++){
                  id.add(snapshot.data[i].id);
                  latarray.add(snapshot.data[i].latitude);
                  longarray.add(snapshot.data[i].longitude);
                  locarray.add(snapshot.data[i].loc);
                  datearray.add(snapshot.data[i].Tdate);
              }
              trackloc(latarray, longarray,id);

              return VisitingList(pid: pid,isVisited: 1,);
            }
          }
          return const CircularProgressIndicator();
        }
    );
  }
}

class Calendpass extends StatefulWidget {
  const Calendpass({required this.pid});
  final String pid;

  @override
  State<Calendpass> createState() => _CalendpassState(pid);
}

class _CalendpassState extends State<Calendpass> {
  String pid;_CalendpassState(this.pid);

  Future<dynamic> generateUserList() async {
    print(pid); //function to get data
    var url = Uri.http(ip, '/kerp/userlocad.php');
    var response = await http.post(url, body: {
      "tablename": pid,
      // "isVisited":0.toString()
    });
    var list = json.decode(response.body);
    List<Employee> _employees =
    await list.map<Employee>((json) => Employee.fromJson(json)).toList();
    return _employees;
  }

  Future<dynamic> generateDateList() async {
    print(pid); //function to get data
    var url = Uri.http(ip, '/kerp/usercalend.php');
    var response = await http.post(url, body: {
      "tablename": pid,
    });
    var list = json.decode(response.body);
    List<Dates> _dates =
    await list.map<Dates>((json) => Dates.fromJson(json)).toList();
    return _dates;
  }
  List<int> countarray=[];List<String> taskdatearray=[]; List<String> locarray=[],datearray=[];
  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
        FutureBuilder<dynamic>(
        future: generateUserList(),
        builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
        return const Center(
        child: Text(
        'network error',
        style: TextStyle(fontSize: 18),
        ),
        );

        // if we got our data
        } else if (snapshot.hasData) {
        for (int i = 0; i < snapshot.data.length; i++) {
        locarray.add(snapshot.data[i].loc);
        datearray.add(snapshot.data[i].Tdate);
        } //Calender(pid: pid,);
        print(locarray);
        return Container();
        }
    }
    return const CircularProgressIndicator();
    }
    ),
    FutureBuilder<dynamic>(
        future: generateDateList(),
        builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
        // If we got an error

        if (snapshot.hasError) {
        return const Center(
        child: Text(
        'network error',
        style: TextStyle(fontSize: 18),
        ),
        );

        // if we got our data
        } else if (snapshot.hasData) {

        for(int i=0;i<snapshot.data.length;i++){
        countarray.add(snapshot.data[i].count);
        taskdatearray.add(snapshot.data[i].taskdate);
        //print(taskdatearray);
        }//Calender(pid: pid,);
        return Text('');
        }
        }
    return const CircularProgressIndicator();
    }
    ),
          Expanded(child: Calender(pid: pid,locarray: locarray,datearray: datearray,countarray: countarray,taskdatearray: taskdatearray,))
        ]
    );
  }
}




class Dates{
  String taskdate;
  int count;

  Dates({required this.taskdate, required this.count});

  factory Dates.fromJson(Map<String, dynamic> json) {
    return Dates(
      count: int.parse(json['countdate']),
      taskdate: json['Tdate'] as String,);}
}

/*
 */