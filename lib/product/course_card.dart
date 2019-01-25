import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:moodle3/queries.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'course_infor.dart';
import 'dart:convert';

class CourseCard extends StatefulWidget{
  _CourseCard createState()=> _CourseCard();
}

class _CourseCard extends State<CourseCard>{
  List courses=new List();
  String _token='';
  String id;
  var c;

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

  check(){
    if (_token!=''){
      parseJwt(_token);
    }
  }

  _getToken() async{
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    _token=prefs.getString("TOKEN");
  }

  static Client client_child = new Client(
      endPoint: 'https://frozen-badlands-80400.herokuapp.com/graphql',
      cache: InMemoryCache(),
      apiToken: '',
    );
  ValueNotifier<Client> client = ValueNotifier(client_child);

  @override
  void initState() {
    _getToken().then(check());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCourseItem();
  }

  restrictEnroll(int index, List<dynamic> par){
    int check=0;
    if (_token!='' && par!=null)
    {
      for (var k in par)
      {
        if (k["UserID"]==jsonDecode(c)['userid'])
          {
            check=1;
            break;
          }
      }
      if (check==1){
        Navigator.push(context, MaterialPageRoute(
                      builder: (context) => CourseInfoPage(id: courses[index]["id"])));
      }
    }
  }

  checkEnroll(String courseid, List<dynamic> par){
    int check=0;
    if (_token!='' && par!=null){
      for (var k in par){
        if (k["UserID"]==jsonDecode(c)['userid'])
          {
            check=1;
            break;
          }
      }
      if (check==1)
        return SizedBox(height: 0,);
      else
        return Mutation(
          ENROLL_COURSE,
          builder: (
            enrollCourse,{
            bool loading,
            var data,
            Exception error,
            }) 
          {
            if (error != null) {
              return Text(error.toString());
            }
            if (loading) {
              return Text('Loading');
            }
            return InkWell(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                height: 35,
                width: 70,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue
              ),
              child: Text("Enroll", style:TextStyle(color: Colors.white)),
              ),
              onTap: ()=>enrollCourse({'courseid': courseid}),
            );
          }
        );
    }
    else
      return SizedBox(height: 0,);
  }

  Widget _buildCourseItem(){
    if (_token!='') client_child.apiToken=_token;    
    return GraphqlProvider(
      client: client,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
        child: Query(
          COURSE_LIST,
          pollInterval: 1,
          builder: ({
            bool loading,
            Map data,
            Exception error
          })
          {
            if (error != null) {
              return Text(error.toString());
            }
            if (loading) {
              return Text('Loading');
            }
            if (_token!='') check();
            courses=data["courses"];
            return ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context,index){
                return InkWell(
                  onTap: ()=>restrictEnroll(index, courses[index]['Participants']),
                  child: Card(
                    elevation: 8.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 25.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        courses[index]['CourseName'],
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        courses[index]['CourseCode'],
                                        style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    courses[index]['Semester'] + ', ',
                                    style: TextStyle(color: Colors.black38),
                                  ),  
                                  Text(
                                    courses[index]['Year'].toString(),
                                    style: TextStyle(color: Colors.black38),
                                  ),
                                ],
                              ),
                            checkEnroll(courses[index]['id'], courses[index]['Participants']),
                          ],
                        ),
                      )
                    ),
                  );
                }
              );
            }
          )
        )
    );
  }
}