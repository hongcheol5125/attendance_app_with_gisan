import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  // 값을 저장할 위치
  String id =
      ''; // id가 non-nullable이므로 비워두면 안되니까 <=''> 해준 것! ( late로 해서 나중에 쓸 때 지정 해 줘도 된다)
  String password = '';
  String nickname = '';

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // textformfield를 쓰려면 Form이 무조건 필요!
            Form(
              key: this.formKey,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      renderTextFormField(
                        controller: _idController,
                        label: '아이디',
                        onSaved: (val) {
                          setState(() {
                            this.id = val;
                          });
                        },
                        validator: (val) {
                          if (val.length < 1) {
                            return '필수 필드입니다.';
                          }
                          return null;
                        },
                      ),
                      renderTextFormField(
                        controller: _passwordController,
                        label: '비밀번호',
                        onSaved: (val) {
                          setState(() {
                            this.password = val;
                          });
                        },
                        validator: (val) {
                          if (val.length < 1) {
                            return '필수 필드입니다.';
                          }
                          return null;
                        },
                      ),
                      renderTextFormField(
                        controller: _nicknameController,
                        label: '닉네임',
                        onSaved: (val) {
                          setState(() {
                            this.nickname = val;
                          });
                        },
                        validator: (val) {
                          if (val.length < 1) {
                            return '필수 필드입니다.';
                          }
                          return null;
                        },
                      ),
                      renderSubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> isIDExist({required String id}) async {
    bool isExist = false;
    await FirebaseFirestore.instance.collection('users').get().then((value) {
      List<DocumentSnapshot> docs = value.docs.toList();
      // for (var i = 0; i < docs.length; i++) {
      //   var element = docs[i];
      //   Map<String, dynamic> docMap = element.data() as Map<String, dynamic>;
      //   if (docMap["id"] == id) {
      //     isExist = true;
      //   }
      // }
      docs.forEach((element) {
        Map<String, dynamic> docMap = element.data() as Map<String, dynamic>;
        if (docMap["id"] == id) {  // 파란 id는 회원이 쓴 id
          isExist = true;
        }
      });
    });
    return isExist;
  }

  registerUserAtFireStore({
    required String id,
    required String password,
    required String nickname,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set({
          'id': id,     // 파란 id는 회원이 쓴 id
          'password': password, 
          'nickname': nickname 
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  showSnackBar(String text) {
    SnackBar snackBar = SnackBar(
      content: Text(text),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  renderTextFormField({
    required String label,
    required FormFieldSetter onSaved,
    required FormFieldValidator validator,
    required TextEditingController controller,
  }) {
    assert(label != null);
    assert(onSaved != null);
    assert(validator != null);

    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
        TextFormField(
          onSaved: onSaved,
          validator: validator,
          controller: controller,
        ),
        SizedBox(
          height: 16.0,
        )
      ],
    );
  }

  renderSubmitButton() {
    return ElevatedButton(
      child: Text('저장하기'),
      onPressed: () async {
        //만약 validation이 다 통과되면 true 리턴
        if (this.formKey.currentState!.validate()) {
          this.formKey.currentState!.save();

          bool _isExist = await isIDExist(id: _idController.text);  // isIDExist는 해석하려면 시간이 좀 걸리므로 async/await 필요!
          if (_isExist == false) // need to add DB check
          {
            registerUserAtFireStore(
              id: _idController.text,
              password: _passwordController.text,
              nickname: _nicknameController.text,
            );
            showSnackBar("등록 성공");
            Navigator.pop(context);
          } else {
            showSnackBar("이미 존재하는 아이디입니다");
          }
        }
      },
    );
  }
}
