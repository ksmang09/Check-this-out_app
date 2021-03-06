import 'package:check_app/user/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../Token/register_code.dart';
import '../validate.dart';
import '../view/custom_elevated_button.dart';
import '../view/custom_text_form_field.dart';
import 'Login.dart';


// 로그인이랑 똑같이 만들기 ( 상태관리 필요없음 )
class JoinPage extends StatelessWidget {

  final _formkey = GlobalKey<FormState>();
  final UserController u = Get.put(UserController()); // 상태관리라서 get.put사용

  final _username = TextEditingController();
  final _password = TextEditingController();
  final _student_id = TextEditingController();

  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body:Container(
        child: Padding(

          padding: const EdgeInsets.all(30.0),
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0,50,0,20),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/image/심벌마크입체배경제거.png'),
                      fit: BoxFit.contain,
                  ),
                ),
              ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.fromLTRB(0, 5, 0,0),
                  height: 40,
                  child: Text(
                    "회원가입",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize:30,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              _JoinForm()
            ],
          ),
        ),
      ),
    );
  }

  Widget _JoinForm() { // 항상 return 타입은 최상위보호타입으로 잡아주는게좋음(widget)
    return Form(    // 나중에 DB 서버에 한번에 날려야 하기 때문에 form안에 한꺼번에 감싸버려버려
      key: _formkey,
      child: Column(
        children: [
          CustomTextFormField(
            controller: _student_id,
            hint: "학번",
            funValidator: validateStudent_id(),
          ),
          CustomTextFormField(
            controller: _password,
            hint: "비밀번호",
            funValidator: validatePassword(),
          ),
          CustomTextFormField(
            controller: _username,
            hint: "이름",
            funValidator: validateUsername(),
          ),
          CustomElevatedButton(
            text: "회원가입",
            funpageRoute: ()async{
              if(_formkey.currentState!.validate()) {
                await u.register(_username.text.trim(), _password.text.trim(),
                    _student_id.text.trim());
                int? result = await register_code;
                if (result == 1){
                  showToast('회원가입이 완료 되었습니다');
                  Get.offAll(()=> LoginPage());
                } else {
                  showToast('회원가입에 실패하였습니다');
                }
              }
            },
          ),
          TextButton(onPressed: (){
            Get.offAll(LoginPage());
          },
              child: Text(
                  "로그인페이지로"
              ),
            style: TextButton.styleFrom(
                  primary: Colors.indigo
            ),
          ),
        ],
      ),
    );
  }
  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM
    );
  }
}


