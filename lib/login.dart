import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'queries.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget{
  _LoginPageState createState()=> _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  _setBase() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  _doSth(String s) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("TOKEN", s).then(navigate());
  }

  navigate(){
    Navigator.pushReplacementNamed(context, '/home');
  }

@override
  void initState() {
    super.initState();
    _setBase();
  }

  @override
  Widget build(BuildContext context) {
    final logo= new Icon((Icons.school), size: 100, color: Colors.blue,);
    final TextEditingController t1=new TextEditingController();
    final TextEditingController t2=new TextEditingController();

    final username=TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: t1,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        )
      ),
    );

    final password=TextFormField(
      obscureText: true,
      keyboardType: TextInputType.text,
      controller: t2,
      autofocus: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText: "password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        )
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            Container(
              alignment: Alignment.center,
              child: Text("STUDENT", style:new TextStyle(fontSize: 25, color: Colors.blue), ),),
            SizedBox(height: 40.0,),
            username,
            SizedBox(height: 8.0,),
            password,
            Mutation(
              LOGIN,
              builder:(
               login, {
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
                if (data["login"].toString()!='null'){
                  _doSth(data["login"].toString());
                }
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0), 
                  child: Material(
                    borderRadius: BorderRadius.circular(30.0),
                    shadowColor: Colors.lightBlueAccent.shade100,
                    elevation: 5.0,
                    child: MaterialButton(
                    minWidth: 200,
                      height: 42.0,
                      onPressed: ()=>login({'email': t1.text,'password': t2.text}),
                      color: Colors.lightBlueAccent,
                      child: Text("Log In", style: TextStyle(color: Colors.white),),
                    )
                  ),
                );
              }       
            ),
          ],
        )
      ),
    );
  }    
} 