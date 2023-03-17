import 'package:attendance_app/page/calendarpage.dart';
import 'package:attendance_app/page/registerpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _idController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

// 실시간으로 DB에서 알려줌
  Stream collectionStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  Stream documentStream = FirebaseFirestore.instance
      .collection('users')
      .snapshots();

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

  // snackbar
  showSnackBar(String text) {
    SnackBar snackBar = SnackBar(
      content: Text(text),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // GestureDetector, FocusScope : 키보드 이외의 부분 누르면 키보드 사라지게 함(l.52, 53)
        body: GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
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
                    Text(
                      'id : ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _idController,
                        decoration: InputDecoration(
                            hintText: 'Write down your id',
                            border: OutlineInputBorder(), // TextField 테두리 모두 감쌈
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
                    Text('Password : ',
                     style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),),
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
                                _passwordController.clear();
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
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          '로그인',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      String? idFromFireStore;
                      String? pwFromFireStore;
                      if (_idController.text == "") {
                        showSnackBar("아이디를 입력해주세요");
                      } else {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(_idController.text)
                            .get()
                            .then((value) {
                          if (value.exists) {        // 만약, value가 존재하면 firestore에서 map 형태로 data를 가져온 후 data의 id부분을 idFromFireStore로 한다
                            Map<String, dynamic> data =
                                value.data() as Map<String, dynamic>;
                            idFromFireStore = data['id'];
                            pwFromFireStore = data['password'];
                          }
                        });

                        if (idFromFireStore != _idController.text) {
                          showSnackBar("아이디가 존재하지 않습니다");
                        } else {
                          if (pwFromFireStore != _passwordController.text) {
                            showSnackBar("비밀번호가 일치하지 않습니다");
                          } else {
                            goToCalendarPage();
                          }
                        }
                      }
                    },
                    
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
      ),
    ));
    ;
  }
}
