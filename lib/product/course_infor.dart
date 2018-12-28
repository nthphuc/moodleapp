import 'package:flutter/material.dart';
import 'assignment.dart';
import 'midterm.dart';
import 'final.dart';
import 'package:moodle3/queries.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'studentslist.dart';

class CourseInfoPage extends StatefulWidget{
  final String id;
  final String userrole;
  List<Map<String,dynamic>> students;

  CourseInfoPage({
    this.id, this.userrole
  });

  @override
  _CourseInfoPageState createState() {
      return new _CourseInfoPageState();  
    }
}

class _CourseInfoPageState extends State<CourseInfoPage>{
  var courses;
  String _token='';
  int count=2;

  _doSth(){
    return Query(
      COURSE_DETAIL,
      variables: {'courseid': widget.id},
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
        courses=data["course"];
        return Padding(
          padding: const EdgeInsets.only(
          left: 10.0, right: 10.0, top: 20.0, bottom: 40.0),
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            elevation: 8.0,
            child: ListView(
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    _buildCourseBasicInfor(),
                    _buildCourseStudentInfo(),
                    _buildCourseGradeInfo()
                  ],
                ),
              ]
            ),
          ),
        );
      }
    );    
  }

  _getToken() async{
    SharedPreferences prefs =  await SharedPreferences.getInstance();
      setState(() {
        _token=prefs.getString("TOKEN");
      });
  }

  static Client client_child = new Client(
      endPoint: 'https://polar-chamber-46934.herokuapp.com/graphql',
      cache: InMemoryCache(),
      apiToken: '',
    );
  ValueNotifier<Client> client = ValueNotifier(client_child);
  
  @override
  void initState() {
    super.initState();
    _getToken();
  }

  _buildCourseBasicInfor(){
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 220,
          width: 380,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:<Widget>[
                    new Icon(Icons.import_contacts,color: Colors.blue, size: 40),
                    new Container(
                      padding: EdgeInsets.only(left: 15),
                      child: new Text(courses["CourseCode"].toString(),style: new TextStyle(fontSize: 30.0, color: Colors.blue),textAlign: TextAlign.left,),
                    )  
                  ],
                ),          
                new Container(
                  padding: EdgeInsets.only(top:10,bottom:10),
                  child: new Text(courses["CourseName"].toString(),style: new TextStyle(fontSize: 25.0, color: Colors.blue)),
                ),
                /*new Text("Teacher: " + widget.teacherName,style: new TextStyle(fontSize: 20.0, color: Colors.black),)*/
              ],
            ),
          ),
        )
      ],
    );
  }

  _buildCourseStudentInfo(){
    return new Column(
      children: <Widget>[
        new Container(
          height: 5,
          width: 360,
          decoration: new BoxDecoration(
            color: Colors.grey[200]
          ),
        ),
        new Container(
          width: 400.0,
          height: 90.0,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StudentsPage(
                              students: courses["Participants"],
                            )));
              },
              child: new Row(
                children: <Widget>[
                  Icon(
                    Icons.people,
                    color: Colors.blue,
                    size: 35.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Participants',
                      style: TextStyle(fontSize: 25.0, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
         new Container(
          height: 5,
          width: 360,
          decoration: new BoxDecoration(
            color: Colors.grey[200]
          ),
        ),
      ],
    );
  }

  _buildCourseGradeInfo(){
      return Container(
      width: 360.0,
      height: 215.0,
      decoration: BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: new Row(
          children: <Widget>[
            Text(
              'Grade',
              style: TextStyle(fontSize: 25.0),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: new Container(
                width: 5.0,
                height: 190.0,
                color: Colors.grey[200],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Card(
                    elevation: 3.0,
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 150,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => AssignmentGradePage(students: courses["Grades"],courseid: widget.id, userrole: widget.userrole)
                          ));
                        },
                        child: Text(
                          'Assignment',
                          style: TextStyle(fontSize: 20.0, color: Colors.blue),
                        ),
                      ),
                    )
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Card(
                    elevation: 3.0,
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 150,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => MidtermGradePage(students: courses["Grades"],courseid: widget.id, userrole: widget.userrole)
                          ));
                        },
                        child: Text(
                          'Midterm',
                          style: TextStyle(fontSize: 20.0, color: Colors.blue),
                        ),
                      ),
                    )
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Card(
                    elevation: 3.0,
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 150,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => FinalGradePage(students: courses["Grades"],courseid: widget.id, userrole: widget.userrole)
                          ));
                        },
                        child: Text(
                          'Final',
                          style: TextStyle(fontSize: 20.0, color: Colors.blue),
                        ),
                      ),
                    )
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
    
  @override
  Widget build(BuildContext context) {
    if (_token.length==0)
    {
      return new Text("loading token");
    }
    else
    {
      client_child.apiToken=_token;
      return GraphqlProvider(
      client: client,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Course'),
            backgroundColor: Colors.blue,
          ),
          body: _doSth()
        )
      );
    } 
  }
}