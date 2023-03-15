import 'package:attendance_app/page/calendarpage.dart';
import 'package:attendance_app/page/registerpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserName extends StatelessWidget {
  final String documentId;

  GetUserName(this.documentId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text("Full Name: ${data['full_name']} ${data['last_name']}");
        }

        return Text("loading");
      },
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _idController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Stream collectionStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  Stream documentStream = FirebaseFirestore.instance
      .collection('users')
      .doc('hongcheol')
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

  // Firebase에서 id, password 가져오기(Read)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // GestureDetector, FocusScope : 키보드 이외의 부분 누르면 키보드 사라지게 함(l.84, 85)
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
                          if (value.exists) {
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
