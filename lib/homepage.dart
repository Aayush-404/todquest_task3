import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'model/UserModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 22, right: 16, left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'List of users',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10,),
              Expanded(
                child: FutureBuilder<List<UserModel>>(
                  future: readTests().first,
                  builder: (context, snapshot){
                    if(snapshot.hasError){
                      return Center(child: Text('Something went wrong!'));
                    }else if(snapshot.hasData){
                      final tests = snapshot.data!;
                      print(tests);
                      if(tests.isEmpty){
                        return Center(child: SizedBox(
                            child: CircularProgressIndicator()
                        ));
                      }else{
                        return ListView(
                          children: tests.map(buildTest).toList(),
                        );
                      }
                    }else{
                      return Center(child: SizedBox(
                          height: 100,
                          child: CircularProgressIndicator()
                      ));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTest(UserModel t) => Padding(
    padding: EdgeInsets.only(top: 14),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(15)
          ),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      'Source: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15
                      ),
                    ),
                    Text(
                      t.source,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: 15
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text(
                      'Name: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15
                      ),
                    ),
                    Text(
                      t.userName,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: 15
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text(
                      'Mail: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15
                      ),
                    ),
                    Text(
                      t.mail,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: 15
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );

  Stream<List<UserModel>> readTests() => FirebaseFirestore.instance.collection('users')
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());
}
