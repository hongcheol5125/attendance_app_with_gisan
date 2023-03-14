import 'package:attendance_app/main.dart';
import 'package:attendance_app/page/calendarpage.dart';
import 'package:attendance_app/page/registerpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _idController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // 캘린더페이지로 가기
    goToCalendarPage() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CalendarPage(),
    ));
  }

  // 회원가입페이지로 가기
  goToRegisterPage() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => RegisterPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/imgs/ehakdrk.jpg',
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Row(
                children: [
                  Text('id : '),
                  Expanded(
                    child: TextField(
                      controller: _idController,
                      decoration: InputDecoration(
                          hintText: 'Write down your id',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _idController.clear();
                            },
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Row(
                children: [
                  Text('Password : '),
                  Expanded(
                    child: TextField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                          hintText: 'Write down your Password',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _idController.clear();
                            },
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  onPressed: () {
                    goToCalendarPage();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'sign in',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              goToRegisterPage();
            },
            child: Text(
              '회원가입',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    ));
    ;
  }
}
