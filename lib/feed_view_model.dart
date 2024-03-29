import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedViewModel with ChangeNotifier {
  Stream<QuerySnapshot<Map<String, dynamic>>>? _requests;
  Stream<QuerySnapshot<Map<String, dynamic>>>? _events;
  User? user = FirebaseAuth.instance.currentUser;
  Stream<QuerySnapshot<Map<String, dynamic>>>? members;

  // late bool? isVSubscribed;
  late List<String> isVSubscribed = [];
  Stream<QuerySnapshot<Map<String, dynamic>>>? _requests2;
  late List<String> searchResults = [];
  late int length;

  fetchRequests() async {
    var firebase = FirebaseFirestore.instance.collection('clubSupport');
    var firebase2 = FirebaseFirestore.instance.collection('events');
    _events = firebase2.orderBy('upload_time', descending: true).snapshots();
    _requests = firebase.orderBy('upload_time', descending: true).snapshots();
    notifyListeners();
  }

  fetchMembers() async {
    var firebase = FirebaseFirestore.instance.collection('users');
    members = firebase.doc(user!.uid).collection("members").snapshots();
    notifyListeners();
  }

  fetchEvents() async {
    var firebase = FirebaseFirestore.instance.collection('events');
    _events = firebase.orderBy('upload_time', descending: true).snapshots();
    notifyListeners();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? get requests {
    return _requests;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? get events {
    return _events;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? get requests2 {
    return _requests2;
  }

  List<String> get getSearchResults {
    return searchResults;
  }

  int getLength() {
    return length;
  }

  Future<void> lunchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not lunch the url";
    }
  }

  Future QueryRequests(String query) async {
    searchResults.clear();

    FirebaseFirestore.instance
        .collection('requests')
        .where('title', isGreaterThanOrEqualTo: query)
        .snapshots()
        .forEach((snapshot) {
      var i = snapshot.docs.iterator;
      while (i.moveNext()) {
        if (i.current["title"].toString().contains(query)) {
          if ((i.current['type'].toString() == "مبلغ" &&
                  i.current['donated'] < i.current['amount']) ||
              (i.current['type'].toString() == "موارد" &&
                  i.current['donated'] < i.current['amount_requested']) ||
              (i.current['type'].toString() == "تنظيم" &&
                  i.current['participants'] < i.current['parts_number'])) {
            String id = i.current.id;
            if (!searchResults.contains(id)) {
              searchResults.add(id);
            }
            ;
          }
        }
      }
    }).onError((error, stackTrace) => print("error"));

    FirebaseFirestore.instance
        .collection('requests')
        .where('mosque_name', isGreaterThanOrEqualTo: query)
        .snapshots()
        .forEach((snapshot) {
      var i = snapshot.docs.iterator;
      while (i.moveNext()) {
        if (i.current["mosque_name"].toString().contains(query)) {
          if ((i.current['type'].toString() == "مبلغ" &&
                  i.current['donated'] < i.current['amount']) ||
              (i.current['type'].toString() == "موارد" &&
                  i.current['donated'] < i.current['amount_requested']) ||
              (i.current['type'].toString() == "تنظيم" &&
                  i.current['participants'] < i.current['parts_number'])) {
            String id = i.current.id;
            // print(id);
            if (!searchResults.contains(id)) {
              searchResults.add(id);
            }
            ;
          }
        }
      }
    }).onError((error, stackTrace) => print("error"));

    FirebaseFirestore.instance
        .collection('requests')
        .where('description', isGreaterThanOrEqualTo: query)
        .snapshots()
        .forEach((snapshot) {
      var i = snapshot.docs.iterator;
      while (i.moveNext()) {
        if (i.current["description"].toString().contains(query)) {
          if ((i.current['type'].toString() == "مبلغ" &&
                  i.current['donated'] < i.current['amount']) ||
              (i.current['type'].toString() == "موارد" &&
                  i.current['donated'] < i.current['amount_requested']) ||
              (i.current['type'].toString() == "تنظيم" &&
                  i.current['participants'] < i.current['parts_number'])) {
            String id = i.current.id;
            // print(id);
            if (!searchResults.contains(id)) {
              searchResults.add(id);
            }
          }
        }
      }
    }).onError((error, stackTrace) => print("error"));

    notifyListeners();
  }
}
