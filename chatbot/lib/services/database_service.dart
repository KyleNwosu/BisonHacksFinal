import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

// Database service: controls manipulation of the database
class DatabaseService extends ChangeNotifier {
  // string user id
  final String? uid;

  // constructor for database service
  DatabaseService({
    required this.uid,
  });

  // get the collection of all students in the database
  final CollectionReference studentsCollection =
      FirebaseFirestore.instance.collection('all_users');

  final CollectionReference botMessageCollection =
      FirebaseFirestore.instance.collection('all_bot_messages');


  // get the collection of all posts in the database
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('all_posts');


  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chat_rooms');


  final CollectionReference documentCollection =
      FirebaseFirestore.instance.collection('resource_documents');


  final CollectionReference linkCollection =
      FirebaseFirestore.instance.collection('links');

  // update all student collections and student collections in respective schools
  Future UpdateStudentCollection(MyUser? user) async {
    // get dictionary representation of user
    Map<String, dynamic> dic = user?.toMap() ?? {};
    // update all student collections and student collections in respective schools
    await studentsCollection.doc(user?.uid).set(dic);
    notifyListeners();
  }



  // get user data snapshots
  Stream<DocumentSnapshot> get userData {
    return studentsCollection.doc(uid).snapshots();
  }

  // get user information and converts it into a [MyUser]
  Future<MyUser> get userInfo async {
    // get the information as a Map
    DocumentSnapshot<Object?> val = await studentsCollection.doc(uid).get();
    Map data = val.data() as Map<String, dynamic>;

    // convert map to [MyUser]
    MyUser user = MyUser.fromMap(data as Map<String, dynamic>);
    return user;
  }

  // get posts
  Stream<DocumentSnapshot> get posts {
    return postsCollection.doc('posts').snapshots();
  }


  // get chatroom information stream
  Stream<DocumentSnapshot> chatRoom(String roomID) {
    return postsCollection.doc(roomID).snapshots();
  }

  // get stream of course resource documents
  Stream<QuerySnapshot> getDocuments(String school, String courseCode) {
    return documentCollection.doc(school).collection(courseCode).snapshots();
  }

  // get stream of course resource links
  Stream<QuerySnapshot> getLinks(String school, String courseCode) {
    return linkCollection.doc(school).collection(courseCode).snapshots();
  }

  // get stream of user matches
  Stream<QuerySnapshot> userMatches() {
    return studentsCollection.snapshots();
  }


  // update tasks in My Schedule
  Future<void> setTasks(Map<String, dynamic> map) async {
    await studentsCollection
        .doc(uid)
        .collection('schedule_tasks')
        .doc('document')
        .set(map);
  }

  // get tasks
  Future<List<dynamic>> getTasks() async {
    DocumentSnapshot<Map<String, dynamic>> document = await studentsCollection
        .doc(uid)
        .collection('schedule_tasks')
        .doc('document')
        .get();
    Map<String, dynamic> documentData = document.data() ?? {};
    try {
      List<dynamic> tasks = documentData['tasks'];
      return tasks;
    } catch (e) {
      print(e);
      return [];
    }
  }



  //add a my calendar event
  Future<void> addEvent(Map<String, dynamic> map) async {
    await studentsCollection
        .doc(uid)
        .collection('calendar_events')
        .doc('document')
        .set(map);

    notifyListeners();
  }
  // retrieve
}
