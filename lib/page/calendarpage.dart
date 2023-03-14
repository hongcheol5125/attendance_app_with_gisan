import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  CalendarPage({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Attendance App'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            
          },
           icon: Icon(
            Icons.home,
           ))
        ]
      ),
      body: Center(
        child: Text('signed in')
      )
    );
  }
}

