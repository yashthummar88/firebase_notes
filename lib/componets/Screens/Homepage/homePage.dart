import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_firebase/componets/Screens/addDataScreen.dart';
import 'package:notes_firebase/componets/Screens/updateDataScreen.dart';
import 'package:notes_firebase/main.dart';
import 'package:notes_firebase/services/database.dart';
import 'package:notes_firebase/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime date;
  late Future<int> createdTask;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFireBaseApp();
    date = new DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return AddData();
              },
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Column(
            children: [
              // ElevatedButton(
              //   onPressed: () async {
              //     UserCredential userCredential =
              //         await FirebaseAuth.instance.signInAnonymously();
              //     print(userCredential.user!.uid);
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(
              //         content: Text("Sign In Anonymous"),
              //         duration: Duration(seconds: 02),
              //       ),
              //     );
              //   },
              //   child: Text("Sign In Anonymous"),
              // ),

              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getWeekendDay(date.weekday) + " ,",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      date.day.toString() +
                          " " +
                          getMonth(date.month).toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.height * 0.04,
                      ),
                    )
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  child: dbListItem(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  dbListItem() {
    return StreamBuilder<QuerySnapshot>(
      stream: Database.readItems(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        int j = 0;
        for (int i = 0; i < snapshot.data!.docs.length; i++) {
          var noteInfo = snapshot.data!.docs[i].data() as Map<String, dynamic>;
          bool complete = noteInfo['complete']!;
          if (complete) {
            j++;
          }
        }
        return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              height: MediaQuery.of(context).size.height * 0.07,
              width: MediaQuery.of(context).size.width,
              //color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        snapshot.data!.docs.length.toString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Created Task",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  Column(
                    children: [
                      Text(
                        j.toString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Completed Task",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 16.0),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var noteInfo =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  String docID = snapshot.data!.docs[index].id;

                  String description = noteInfo['description']!;
                  bool complete = noteInfo['complete']!;
                  return ListTile(
                    title: Text(
                      description,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height * 0.022,
                          color:
                              (complete == false) ? Colors.black : Colors.grey),
                    ),
                    leading: InkWell(
                      onTap: () {
                        Database.updateStatus(
                          docId: docID,
                          status: complete,
                        );
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.03,
                        width: MediaQuery.of(context).size.height * 0.03,
                        alignment: Alignment.center,
                        child: (complete)
                            ? Icon(
                                Icons.done,
                                size:
                                    MediaQuery.of(context).size.height * 0.025,
                                color: Colors.green,
                              )
                            : SizedBox(),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: (complete == false)
                                  ? Colors.black
                                  : Colors.green),
                        ),
                      ),
                    ),
                    trailing: Wrap(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return UpdateDataScreen(
                                    data: description,
                                    userId: docID,
                                  );
                                },
                              ),
                            );
                          },
                          child: Icon(Icons.edit),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        InkWell(
                            onTap: () async {
                              AwesomeDialog(
                                  context: context,
                                  title: "Warning",
                                  body: Text(
                                      "Are you sure you want to delete the item?"),
                                  dialogType: DialogType.WARNING,
                                  animType: AnimType.BOTTOMSLIDE,
                                  btnCancelOnPress: () {
                                    //Navigator.of(context).pop();
                                  },
                                  btnOkOnPress: () async {
                                    await Database.deleteItem(docId: docID);
                                    //Navigator.of(context).pop();
                                  })
                                ..show();
                            },
                            child: Icon(Icons.delete)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
