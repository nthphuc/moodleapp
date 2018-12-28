import 'package:flutter/material.dart';
import './product/course_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage extends StatefulWidget{
  @override
  _HomePage createState()=> _HomePage();
}

class _HomePage extends State<HomePage>{
  String _token='';
  var c;

  _getToken() async{
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    setState(() {
    _token=prefs.getString("TOKEN");
    });
    }

  check(){
    if (_token!=''){
      parseJwt(_token);
    }
  }

  initState(){
    _getToken();
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }
    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }
    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }
    c=utf8.decode(base64Url.decode(output));
    return utf8.decode(base64Url.decode(output));
  }

  checkEmail(){
    if (c!=null)
      return                         
        new Container(
        padding: EdgeInsets.only(top: 10),
        child: new Text(jsonDecode(c)['email'].toString(), style: new TextStyle(fontSize: 25),),
      );
    else
      return SizedBox(height: 0,);
  }

  @override
  Widget build(BuildContext context) {
    if (_token!='') check();
    return new Scaffold(
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new Container(
              height: 260,
              child: new DrawerHeader(
                decoration: new BoxDecoration(
                  color: Colors.blue),
                  child: new Container(
                    child: new Column(
                      children: <Widget>[
                        new Container(
                          height: 150,
                          width: 150,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage("https://tedconfblog.files.wordpress.com/2012/08/back-to-school.jpg")
                            )
                          ),
                        ),
                        checkEmail()
                      ],
                    ),
                  )
              ),
            ),
            new ListTile(
              leading: new Icon(Icons.perm_identity),
              title: new Text("Profile", style: new TextStyle(fontSize: 20),),
              onTap: (){
                Navigator.pushNamed(context, '/profile');
              },
            ),
            new ListTile(
              leading: new Icon(Icons.arrow_back),
              title: new Text("Logout", style: new TextStyle(fontSize: 20),),
              onTap: (){
                Navigator.pushReplacementNamed(context, '/login');
              },
            )
          ],
        )
      ),
      appBar: AppBar(
        title: Text('All Courses'),
        backgroundColor: Colors.blue,
      ),
      body: CourseCard(),
    );      
  }
}
