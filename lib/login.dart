import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todquest_task3/homepage.dart';
import 'package:todquest_task3/signup.dart';

import 'model/UserModel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController mail = TextEditingController();
  final TextEditingController password = TextEditingController();
  String dropdownValue = "Google";
  List<String> ll = ["Google", "FaceBook", "Instagram", "Friend", "Organic"];
  // var items = [
  //   'Item 1',
  //   'Item 2',
  //   'Item 3',
  //   'Item 4',
  //   'Item 5',
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40,),
              Container(
                padding: EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                autofocus: true,
                maxLines: 1,
                keyboardType: TextInputType.name,
                style: TextStyle(
                    color: Colors.black
                ),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFECECEC),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(18))
                  ),
                  hintText: 'Enter Username',
                  hintStyle: TextStyle(
                      color: Colors.black45
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
                controller: name,
              ),
              SizedBox(height: 15,),
              TextField(
                controller: mail,
                autofocus: true,
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                    color: Colors.black
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFECECEC),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(18))
                  ),
                  hintText: 'Enter E-Mail',
                  hintStyle: TextStyle(
                      color: Colors.black45
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
              SizedBox(height: 15,),
              TextField(
                autofocus: true,
                maxLines: 1,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                style: TextStyle(
                    color: Colors.black
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFECECEC),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(18))
                  ),
                  hintText: 'Enter Password',
                  hintStyle: TextStyle(
                      color: Colors.black45
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
                controller: password,
              ),
              SizedBox(height: 12),
              DropdownButton(
                // Initial Value
                value: dropdownValue,
                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),

                // Array list of items
                items: ll.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
              ),
              SizedBox(height: 12),
              ElevatedButton(
                  onPressed :() async{
                    await signUp();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 60),
                    primary: Color(0xFFF50404),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(18))
                    ),
                  ),
                  child: Text(
                    'Login',
                  )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Text("Don't have an account?",
                    style: TextStyle(fontSize: 13),
                  ),
                  TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text("Sign Up", style: TextStyle(color: Color(0xFFF50404),fontSize: 13),)
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  void dropdown(String? selectedValue){
    if(selectedValue is String){
      setState((){
        dropdownValue = selectedValue;
      });
    }
  }

  Future signUp() async{

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: SizedBox(
          height: 100,
          child: CircularProgressIndicator()
      )),
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: mail.text.trim(),
          password: password.text.trim()
      );
      createUser();
    } on FirebaseException catch (e) {
      print(e);
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  Future createUser() async{
    final uuid = FirebaseAuth.instance.currentUser!.uid;
    final docUser = FirebaseFirestore.instance.collection('users/').doc(uuid);
    final user = UserModel(
        userName: name.text.trim().toString(),
        mail: mail.text.toString(),
        source: dropdownValue.toString(),
        password: password.text.trim().toString()
    );
    final json = user.toJson();
    await docUser.set(json);
  }

}

