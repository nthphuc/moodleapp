import 'package:flutter/material.dart';

class StudentsPage extends StatelessWidget {
  var students;
  StudentsPage({this.students});

  Widget _buildStudentItem(BuildContext context, int index) {
    return new Card(
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              students[index]['UserID'],
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              students[index]['FullName'],
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  _buildStudentList() {
    Widget studentCard = Center(
      child: Text('No student'),
    );
    if (students.length > 0) {
      studentCard = ListView.builder(
        itemBuilder: _buildStudentItem,
        itemCount: students.length,
      );
    }
    return studentCard;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students'),
        backgroundColor: Colors.black,
      ),
      body: _buildStudentList(),
    );
  }
}
