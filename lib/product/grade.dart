import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moodle3/queries.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GradePage extends StatefulWidget{
  List grades;
  String courseid;
  GradePage({this.grades, this.courseid});

  @override
  _GradePage createState() => _GradePage();
}

class _GradePage extends State<GradePage> {
  double sum=0;
  int i;
  String _token;

  _getToken() async{
      SharedPreferences prefs =  await SharedPreferences.getInstance();
        setState(() {
          _token=prefs.getString("TOKEN");
        });
    }

  static Client client_child = new Client(
      endPoint: 'https://frozen-badlands-80400.herokuapp.com/graphql',
      cache: InMemoryCache(),
      apiToken: '',
    );
  ValueNotifier<Client> client = ValueNotifier(client_child);

  @override
    void initState() {
      super.initState();
      _getToken();
    }

  @override
  Widget build(BuildContext context) {

    var data=[ListGradeItem(0, 0)];
    sum=0;

    for (i=0;i<widget.grades.length;i++){
      data.add(new ListGradeItem(i, widget.grades[i]["Weight"]));
      sum+=widget.grades[i]["Weight"];
    }

    if (1-sum!=0) data.add(new ListGradeItem(i, 1-sum));

    var series=[
      charts.Series(
        domainFn: (ListGradeItem list,_)=>list.id,
        measureFn: (ListGradeItem list,_)=>list.weight,
        id: 'Sales',
        data: data,
        labelAccessorFn: (ListGradeItem list,_)=>'${list.id.toString()} (${(list.weight*100).toString()}%)',
      )
    ];

    var chart = charts.PieChart(
      series,
      animate: true,
      defaultRenderer: charts.ArcRendererConfig(arcRendererDecorators: [new charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.outside)]),
    );

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
            title: Text(' Grade'),
            backgroundColor: Colors.black,
          ),
          body: Column(
            children: <Widget>[
              Container(
                height: 220,
                child: chart,
                padding: EdgeInsets.only(top: 20, bottom: 20),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.grades.length,
                  itemBuilder:(context, index){
                    return Query(
                      GRADE_LIST ,
                      variables: {'gradeid':widget.grades[index]["id"],'courseid':widget.courseid},
                        builder:
                        ({
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
                          return Card(
                            margin: EdgeInsets.all(5),
                            child: ExpansionTile(
                              title: Container(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: <Widget>[
                                    Text(index.toString()+"."),
                                    SizedBox(width: 10,),
                                    Expanded(
                                      child: Text(widget.grades[index]["GradeItemName"]),
                                    )
                                  ],
                                )
                              ),
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    child: Text("Grade: ", style: TextStyle(fontWeight: FontWeight.bold),),
                                    alignment: Alignment.centerLeft, 
                                  ),
                                  Text(data["gradeList"][0]["Grade"].toString()!='null'?data["gradeList"][0]["Grade"].toString()+"/"+widget.grades[index]["Max"].toString():"_", style: TextStyle(fontSize: 15),),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.all(5),
                                child: Text("Feedback: ", style: TextStyle(fontWeight: FontWeight.bold),),
                                alignment: Alignment.centerLeft, 
                              ),
                              Container(
                                margin: EdgeInsets.all(5),
                                alignment: Alignment.centerLeft,
                                child: Text(data["gradeList"][0]["Feedback"].toString()!=''?data["gradeList"][0]["Feedback"].toString():"_", style: TextStyle(fontSize: 15),),
                              )
                            ],
                          ),
                        );
                      }
                    );
                  },
                )
              )
            ],
          ) 
        )
      );
    }
  }
}

class ListGradeItem{
  final int id;
  final double weight;
  ListGradeItem(this.id, this.weight);
}
