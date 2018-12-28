import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:moodle3/queries.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/role.dart';
import 'dart:async';

class FinalGradePage extends StatefulWidget{
  var students;
  String courseid;
  String userrole;
  FinalGradePage({this.students, this.courseid, this.userrole});

  @override
  _FinalGradePage createState() => _FinalGradePage();
}

class _FinalGradePage extends State<FinalGradePage> {
  int state=0;
  String _token;
  int _index=0;
  Timer timer;
  final TextEditingController inputGrade=new TextEditingController();

  static Client client_child = new Client(
    endPoint: 'https://polar-chamber-46934.herokuapp.com/graphql',
    cache: InMemoryCache(),
    apiToken: '',
  );
  ValueNotifier<Client> client = ValueNotifier(client_child);

  _getToken() async{
    SharedPreferences prefs =  await SharedPreferences.getInstance();
    _token=prefs.getString("TOKEN");
  }

  @override
  void initState() {
    _getToken();
    super.initState();
  }

  inputGradeChange(){
    if (state==0 || widget.userrole!=TEACHER_ROLE){
      return SizedBox(height: 0,);
    }
    else{
      return Container(
        height: 50,
        width: double.infinity,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        alignment: Alignment.bottomCenter,
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: inputGrade,
                keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                autofocus: false,
              ),
            ),
            Mutation(
              MODIFY_GRADE,
              builder: (
                modifyGrade,{
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
                return RaisedButton(
                  child: Text("Confirm"),
                  onPressed: (){
                    modifyGrade({'courseid':widget.courseid,'userid':widget.students[_index]['UserID'],'final':double.parse(inputGrade.text)});
                    timer=new Timer(const Duration(milliseconds: 1000),(){
                      setState(() {
                        widget.students[_index]['Final']=double.parse(inputGrade.text);                                        
                      });
                    });
                  }
                );
              }
            )
          ]
         )
      );
    }
  }

  Widget _buildFinalGradeItem(BuildContext context, int index) {
    return new Card(
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onDoubleTap: (){
                setState(() {
                  state=1;
                  _index=index;    
                });
              },
              child:Row(
                children: <Widget>[
                  Expanded(
                    child: new Text(
                      widget.students[index]['StudentID'],
                      style:
                          TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: new Text(
                      widget.students[index]['Final'].toString(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
          ],
        ),
      ),
    );
  }

  _buildFinalGradeList() {
    Widget studentCard = Center(
      child: Text('No student'),
    );
    if (widget.students.length > 0) {
      studentCard = ListView.builder(
        itemBuilder: _buildFinalGradeItem,
        itemCount: widget.students.length,
      );
    }
    return studentCard;
  }

  @override
  Widget build(BuildContext context) {
    if (_token!='') client_child.apiToken=_token;
    return  GraphqlProvider(
    client: client,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Final Grade'),
          backgroundColor: Colors.black,
        ),
        body: GestureDetector(
          onTap: (){
            timer=new Timer(const Duration(milliseconds: 1500),(){
              setState(() {
                state=0;         
              });
            });
          },
          child: Column(
            children: <Widget>[
              Flexible(
                child:_buildFinalGradeList(),
               ),
              inputGradeChange()
            ],
          ) 
        )
      )
    );
  }
}
