import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'queries.dart';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() {
    return new ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  VoidCallback _showPersBottomSheetCallBack;
  String _token='';
  var c;

  final TextEditingController t1=new TextEditingController();
  final TextEditingController t2=new TextEditingController();
  final TextEditingController t3=new TextEditingController();
  final TextEditingController t4=new TextEditingController();

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
    _showPersBottomSheetCallBack = _showBottomSheet;
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

  check(){
    if (_token!=''){
      parseJwt(_token);
    }
  }

  void _showBottomSheet() {
    setState(() {
      _showPersBottomSheetCallBack = null;
    });
    _scaffoldKey.currentState
        .showBottomSheet((context) {
          return new Container(
            height: 350.0,
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)
              )
            ),
            child: Padding(
              padding:
                const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              child: new Column(
                children: <Widget>[
                  TextField(
                    controller: t1,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.card_membership,
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                      hintText: 'ID'
                    ),
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  TextField(
                    controller: t2,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.contacts,
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                      hintText: 'FullName'
                    ),
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  TextField(
                    controller: t3,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.email,
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                      hintText: 'Email'
                    ),
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  TextField(
                    controller: t4,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.perm_identity,
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                      hintText: 'Description'
                    ),
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Mutation(
                    UPDATE_USER,
                    builder: (
                      updateUser,{
                        bool loading,
                        var data,
                        Exception error
                    })
                    {
                      if (error!=null){
                        return Text(error.toString());
                      }
                      if (loading){
                        return Text('loading');                        
                      }
                      return RaisedButton(
                        child: Text('Save'),
                        elevation: 8.0,
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7.0))),
                        onPressed: () =>updateUser({'userid':t1.text,'fullname':t2.text,'email':t3.text,'description':t4.text}),
                      );
                    }
                  ),
                ],
              ),
            ),
          );
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showPersBottomSheetCallBack = _showBottomSheet;
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    if (_token.length==0){
      return Text('loading');
    }
    else
    {
      client_child.apiToken=_token;
      if (_token!='') check();
      return GraphqlProvider(
        client: client,
        child: CacheProvider(
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text('Profile'),
              backgroundColor: Colors.black,
            ),
            body: Container(
              width: 500.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Query(
                      USER_DETAIL,
                      variables: {"id": jsonDecode(c)['_id']},
                      pollInterval: 1,
                      builder: ({
                        bool loading,
                        var data,
                        Exception error
                      })
                      {
                        if (error != null) {
                          return Text(error.toString());
                        }
                        if (loading) {
                          return Text('Loading');
                        }
                        var user=data["user"];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Text("User ID", style:TextStyle(fontSize: 18)),
                                  width: 100,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(10.0),
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: new BoxDecoration(
                                      border: new Border.all(color: Colors.black)
                                    ),
                                    child: Text(user["UserID"].toString(), style:TextStyle(fontSize: 18)),
                                  )
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Text("FullName", style:TextStyle(fontSize: 18)),
                                  width: 100,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(10.0),
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: new BoxDecoration(
                                      border: new Border.all(color: Colors.black)
                                    ),
                                    child: Text(user["FullName"].toString(), style:TextStyle(fontSize: 18)),
                                  )
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Text("Email", style:TextStyle(fontSize: 18)),
                                  width: 100,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(10.0),
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: new BoxDecoration(
                                      border: new Border.all(color: Colors.black)
                                    ),
                                    child: Text(user["Email"].toString(), style:TextStyle(fontSize: 18)),
                                  )
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Text("Description", style:TextStyle(fontSize: 18)),
                                  width: 100,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(10.0),
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: new BoxDecoration(
                                      border: new Border.all(color: Colors.black)
                                    ),
                                    child: Text(user["Description"].toString(), style:TextStyle(fontSize: 18)),
                                  )
                                )
                              ],
                            ),
                          ],
                        );
                      }
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child:RaisedButton(
                        child: Text("Edit Profile"),
                        onPressed: _showPersBottomSheetCallBack,
                      ), 
                    )
                  ],
                ),
              ),
            ),
          )
        )
      );
    }
  }
}
