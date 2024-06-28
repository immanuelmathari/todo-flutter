import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddToDo extends StatefulWidget {
  const AddToDo({super.key});

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  addTaskToFirebase () async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    // the ! means that the user should not be null
    final uid = user!.uid;
    var time = DateTime.now();

    await FirebaseFirestore.instance.collection('tasks').doc(uid).collection('userTasks').doc(time.toString()).set({
      'title' : titleController.text,
      'description' : descriptionController.text,
      'time' : time.toString(),
    });
    Fluttertoast.showToast(msg: 'Task added successfully');



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[700],
        title: Text('Add ToDo'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 40.0),
            Text(
              'Add the Task you want to do',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 100.0),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.grey.shade700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.grey.shade700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: () {
                addTaskToFirebase();
                Navigator.pop(context); // to redirect
              },
              child: Text('Add ToDo'),
              style: ElevatedButton.styleFrom(
                backgroundColor : Colors.green.shade300,
                padding: EdgeInsets.symmetric(horizontal: 100.0, vertical:15.0),
                textStyle: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ]
        ),
      )
    );
  }
}