import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:kerp/admin/adminhome.dart';
import 'package:kerp/user/individual.dart';
import 'package:kerp/main.dart';
import 'package:kerp/register.dart';



class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static final String id="login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {


  Future<void> verifydata() async {// function to send data
    final response = await http.post(Uri.http(ip,"/kerp/verifylogin.php"), body: {
      "username": username1.text,
      "password": passsord1.text,});
    //String tdate=DateTime.now().toString();
    //(DateTime.parse("2023-5-18")==DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day))? print("tdate"):print("hai");
    if(response.body==""){
      ScaffoldMessenger.of(context).showSnackBar( // is this context <<<
          const SnackBar(content: Text('Invalied usename or password...login failed',
            style: TextStyle(color: Colors.red),)));
    }else{
    var list = json.decode(response.body);
    List<Policeid> policeid =
    await list.map<Policeid>((json) => Policeid.fromJson(json)).toList();
    print(policeid[0].isUser);
    if(policeid[0].isUser==1) {
      print(policeid[0].isUser);
      await Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
        return Scaffold(
          body: Individual(pid: policeid[0].pid),
        );
      })
      );
    }else{
      await Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
        return Scaffold(
          body: Adminhome(pid: policeid[0].pid),
        );
      })
      );
    }}
  }int i=0;
  TextEditingController username1=new TextEditingController();
  TextEditingController passsord1=new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: (){exit(0);},),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),toolbarHeight: 70,
        backgroundColor: Colors.green,
        title: const Center(child:
        Text('Login',style: TextStyle(
          fontSize: 25,fontWeight:FontWeight.w900),)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.comment),
            tooltip: 'Comment Icon',
            onPressed: () {},
          ), //IconButton
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Setting Icon',
            onPressed: () {},
          ), //IconButton
        ],
      ),
      body:  Container(padding: EdgeInsets.only(left: MediaQuery.of(context).size.height/20,
          right: MediaQuery.of(context).size.height/20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(children:[
            //const Expanded(flex:1,child: Text("Username",style: TextStyle(fontSize: 18.0),)),
            Expanded(flex: 3,
              child: TextField(
                controller: username1,
                decoration: const InputDecoration(labelText: 'Username',labelStyle: TextStyle(color: Colors.blue),
                    hintText: 'Username',border: OutlineInputBorder()
                ),
              ),
            ),]),SizedBox(height: 20,),
            Row(children:[
              //Expanded(flex:1,child: Text("Password",style: TextStyle(fontSize: 18.0),)),
              Expanded(flex: 3,
                child: TextField(
                  controller: passsord1,obscureText: true,
                  decoration: InputDecoration(labelText: 'Password',labelStyle: TextStyle(color: Colors.red),
                      hintText: 'Password',border: OutlineInputBorder()
                  ),
                ),
              ),]),SizedBox(height: 50,),
    Theme(
    data: Theme.of(context).copyWith(
        hoverColor: Colors.green,
    colorScheme:
    Theme.of(context).colorScheme.copyWith(secondary: Colors.red),
    ),
          child:  FloatingActionButton(
            elevation: 25,
              child: Text("Login",
                style: TextStyle(fontSize: MediaQuery.of(context).devicePixelRatio*12),),
              onPressed: (){
                verifydata();
                //Navigator.of(context).pushNamed(Register.id);
              },
            ),),SizedBox(height: MediaQuery.of(context).size.height/50,),
            TextButton(
              child: Text("Sign up"),
              onPressed: (){
                Navigator.of(context).pushNamed(Register.id);
              },
            ),
            // TextButton(
            //   child: Text("Forgot password?"),
            //   onPressed: (){
            //     Navigator.of(context).pushNamed(Register.id);
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

class Policeid {
  String pid;int isUser;
  Policeid({ required this.pid,required this.isUser});
  factory Policeid.fromJson(Map<String, dynamic> json) {
    return Policeid(
        pid: json['pid'] as String,
        isUser: int.parse(json['isUser']),
    );
  }
}
