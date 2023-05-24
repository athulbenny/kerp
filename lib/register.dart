import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kerp/main.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  static final String id="register";

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool validate=false,vali=false;
  Future<List> senddata() async {// function to send data
    int k;
    if(newval=="user"){
      k=1;
    }else{k=0;}
    final response = await http.post(Uri.http(ip,"/kerp/insertaccounts.php"), body: {
      "username": username1.text,
      "password": passsord1.text,
      "pid":pid1.text,
      "adminid":adminid.text,
      "isUser":k.toString(),
    });print(response.body);
    if(response.body!="user added successfully"){
      ScaffoldMessenger.of(context).showSnackBar( // is this context <<<
          const SnackBar(content: Text('Username or police id is not valied',
            style: TextStyle(color: Colors.red),)));
    }else{Navigator.of(context).pushNamed(Login.id);}
    return Future.error("e");
  }
  TextEditingController username1=new TextEditingController();
  TextEditingController passsord1=new TextEditingController();
  TextEditingController passsord2=new TextEditingController();
  TextEditingController pid1=new TextEditingController();
  TextEditingController adminid=new TextEditingController();
  //TextEditingController isUser=new TextEditingController();
  String dropdownvalue = 'user';
  var policeNames = ['user','admin'];
String newval="user";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),backgroundColor: Colors.green,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ), toolbarHeight: MediaQuery.of(context).size.height/12,
      ),
      body:  Container(padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.height/60,
          right: MediaQuery.of(context).size.height/80),
        child: Center(
          child: SafeArea(
            child: SingleChildScrollView(scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  Row(children:[
                  Expanded(flex: 1,child: Text("Username",style: TextStyle(fontSize: 18.0),)),
                  Expanded(flex:3,
                    child: TextField(
                      controller: username1,
                      decoration: InputDecoration(
                          hintText: 'username'
                      ),
                    ),
                  ),]),
                  SizedBox(height: 20,),
                  Row(children:[
                    Expanded(flex: 1,child: Text("Password",style: TextStyle(fontSize: 18.0),)),
                    Expanded(flex:3,
                      child: TextField(
                        controller: passsord1,
                        decoration: InputDecoration(
                            hintText: 'Password',
                          errorText: validate?"password must be atleast eight character":""
                        ),obscureText: true,
                      ),
                    ),]),SizedBox(height: 20,),
                  Row(children:[
                    Expanded(flex: 1,child: Text("Confirm Password",style: TextStyle(fontSize: 18.0),)),
                    Expanded(flex:3,
                      child: TextField(
                        controller: passsord2,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            errorText: vali?"Not matching":""
                        ),obscureText: true,
                        onChanged: (val){
                          if(passsord2.text.length>=1 && passsord1.text!=passsord2.text){
                            setState(() {print(val);
                              vali=true;print(vali);
                            });
                          }else{setState(() {
                            vali=false;
                          });}
                        },
                      ),
                    ),]),SizedBox(height: 20,),
                  Row(children:[
                    Expanded(flex: 1,child: Text("Police id",style: TextStyle(fontSize: 18.0),)),
                    Expanded(flex:3,
                      child: TextField(
                        controller: pid1,
                        decoration: InputDecoration(
                            hintText: 'pid'
                        ),
                      ),
                    ),]),SizedBox(height: 20,),
                  Row(children:[
                  Expanded(flex:1,child: Text("isUser",style: TextStyle(fontSize: 18.0),)),
              Expanded(flex: 2,
                child: DropdownButton(
                  // Initial Value
                  value: dropdownvalue,
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: policeNames.map((String policeName) {
                    return DropdownMenuItem(
                      value: policeName,
                      child: Text(policeName),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                      print(newValue);
                      newval=newValue;
                    });
                  },
                ),
              ),]),SizedBox(height: 20,),
                  Row(children:[
                    Expanded(flex: 1,child: Text("Admin id",style: TextStyle(fontSize: 18.0),)),
                    Expanded(flex:3,
                      child: TextField(
                        controller: adminid,
                        decoration: InputDecoration(

                            hintText: "Admin's police id"
                        ),
                      ),
                    ),]),SizedBox(height: 50,),
                  ElevatedButton(
                    child: Text("Register"),
                    onPressed: (){
                      if(passsord1.text.length<8){
                      setState(() {
                        validate=true;
                      });
                      }else{
                      senddata();

                    }},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

