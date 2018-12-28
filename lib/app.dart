import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';
import 'profile.dart';
import './product/course_infor.dart';
import './product/assignment.dart';
import './product/final.dart';
import './product/midterm.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StudentApp extends StatefulWidget{
  @override
  _StudentApp createState()=> _StudentApp();
}


class _StudentApp extends State<StudentApp>{
  static Client client_child = new Client(
      endPoint: 'https://polar-chamber-46934.herokuapp.com/graphql',
      cache: InMemoryCache(),
      apiToken: '',
    );
  ValueNotifier<Client> client = ValueNotifier(client_child);

  _setBase() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  void initState() {
    super.initState();
    _setBase();
  }

  @override
  Widget build(BuildContext context) {
    return GraphqlProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          title: 'Student App',
          home: LoginPage(),
          initialRoute: '/login',
          routes: {
            '/login': (BuildContext context) => LoginPage(),
            '/profile': (BuildContext context) => ProfilePage(),
            '/assignment': (BuildContext context) => AssignmentGradePage(),
            '/midterm': (BuildContext context) => MidtermGradePage(),
            '/final': (BuildContext context) => FinalGradePage(),
            '/detail': (BuildContext context) => CourseInfoPage(),
            '/home': (BuildContext context)=> HomePage()
          },
        ),    
      )
    );
  } 
}