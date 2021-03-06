import 'dart:io';

import 'package:check_app/Token/token.dart';
import 'package:check_app/homepage.dart';
import 'package:check_app/main.dart';
import 'package:check_app/user/user_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:http/http.dart'hide MultipartFile;
import 'package:image_picker/image_picker.dart';


class CheckPage extends StatefulWidget{
  @override
  _CheckpageState createState() => _CheckpageState();
}



class _CheckpageState extends State<CheckPage>{
  final ImagePicker _picker = ImagePicker();
  dynamic _selectedData = null;
  File? _f = null;
  UserController u = Get.find();
  XFile? selectedImage = null;



  Future<dynamic> patchImage(dynamic input) async {
    print("사진을 서버에 업로드 합니다.");
    var dio = new Dio();
    print(u.principal.value.password);
    try {
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;
      dio.options.headers = {'authorization': jwtToken, 'student_id': '${u.principal.value.student_id}'};
      var response = await dio.post(
        'http://43.200.123.69:5000' + '/image',
        data: input,
      );
      print('성공적으로 업로드했습니다');
      // if (response.data.code == 1){
      //   Get.offAll()
      // }aaa
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('자가진단 Check this'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                XFile? selectImage = await _picker.pickImage(
                  source: ImageSource.gallery,
                  // maxHeight: 75,
                  // maxWidth: 75,
                  // imageQuality: 30,
                );


                if (selectImage != null) {
                  dynamic sendData = selectImage.path;
                  _selectedData = FormData.fromMap({'image': await MultipartFile.fromFile(sendData)});
                  setState(() {
                    _f = File(selectImage.path);
                  });
                }
              },
              child: Text("이미지 선택하기"),
              style: ElevatedButton.styleFrom(
                primary: Colors.black
              ),
            ),
            _f != null ? Container(
              width: 300,
              height: 500,
              decoration: BoxDecoration(
                border: Border.all(width: 0.1,color: Colors.black
                ),
                  image: DecorationImage(
                      image: FileImage(_f!),//File Image를 삽입
                      fit: BoxFit.cover)
              ),
            ) : Container(
              width: 300,
              height: 500,
              decoration: BoxDecoration(
                border: Border.all(width: 1,color: Colors.black),

              ),
              child: Text(
                  '사진을 선택해주십시오',
                  style: TextStyle(
                    height: 18,
                  fontSize: 18.0,
                  ),
                  textAlign: TextAlign.center,

              ),

            ),

            ElevatedButton(
              onPressed: () async {
                if(_f != null){
                  dynamic res = await patchImage(_selectedData);
                  if(res['code'] == 1) {
                    showToast('사진 업로드 성공');
                    Get.to(HomePage());
                  } else {
                    showToast('사진 업로드 실패\n 다시 선택해 주세요');
                  }
                }else {
                  return showToast('사진을 선택해 주세요');
                }
            },
              child: Text("서버에 업로드하기"),
              style: ElevatedButton.styleFrom(
                  primary: Colors.black
              ),
            ),
          ],
        ),
      ),

    );

  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: Colors.indigoAccent,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM
    );
  }

}
