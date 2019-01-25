import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';
import 'profile.dart';
import './product/course_infor.dart';
<<<<<<< HEAD
=======
<<<<<<< HEAD
=======
import './product/assignment.dart';
import './product/final.dart';
import './product/midterm.dart';
>>>>>>> ee802170704be7834bef40cb3fc226990f1252c5
>>>>>>> 8e28c893b7044dc8be8006043af644f24315f0d4
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StudentApp extends StatefulWidget{
  @override
  _StudentApp createState()=> _StudentApp();
}


class _StudentApp extends State<StudentApp>{
  static Client client_child = new Client(
<<<<<<< HEAD
      endPoint: 'https://frozen-badlands-80400.herokuapp.com/graphql',
=======
<<<<<<< HEAD
      endPoint: 'https://frozen-badlands-80400.herokuapp.com/graphql',
=======
      endPoint: 'https://polar-chamber-46934.herokuapp.com/graphql',
>>>>>>> ee802170704be7834bef40cb3fc226990f1252c5
>>>>>>> 8e28c893b7044dc8be8006043af644f24315f0d4
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
      child: MaterialApp(
        title: 'Student App',
        home: LoginPage(),
        initialRoute: '/login',
        routes: {
          '/login': (BuildContext context) => LoginPage(),
          '/profile': (BuildContext context) => ProfilePage(),
<<<<<<< HEAD
=======
<<<<<<< HEAD
=======
          '/assignment': (BuildContext context) => AssignmentGradePage(),
          '/midterm': (BuildContext context) => MidtermGradePage(),
          '/final': (BuildContext context) => FinalGradePage(),
>>>>>>> ee802170704be7834bef40cb3fc226990f1252c5
>>>>>>> 8e28c893b7044dc8be8006043af644f24315f0d4
          '/detail': (BuildContext context) => CourseInfoPage(),
          '/home': (BuildContext context)=> HomePage()
        },
      ),    
    );
  } 
}