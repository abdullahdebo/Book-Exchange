import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class SendNotification {
  final String title;
  final String body;
  final String userID;

  SendNotification({required this.body, required this.title, required this.userID});

  Future <bool> getTokens(BuildContext context) async {
    bool isNotificationSent;
    await FirebaseFirestore.instance.collection('UsersAccounts').doc(userID).get().then((value) async{
      await addNotification(userID);
      await sendNotification(context,value.data()!['FBNotificationToken']);
      print('Notification sent');
      isNotificationSent=true;
    });
    return isNotificationSent = true;
  }

  addNotification(String uid)async{
    await FirebaseFirestore.instance.collection('Notifications').add({
      'Title':title,
      'Body':body,
      'Seen':false,
      'SeenAt':null,
      'SendAt':DateTime.now(),
      'UserID':uid
    });
  }

  Future<bool> sendNotification(BuildContext context, String tokenNo) async {
    bool isNotificationSent;
    final data = {
      'notification': {
        'body': body,
        'title': title,
        'sound': 'default',
        'badge': '1',
      },
      'priority': 'high',
      'to': tokenNo,
    };
    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=AAAAjpLsutc:APA91bF8L35v7nfbL3cnZT2PF5sUtO3zAJI4d3T7U2ZTaL-4xNgN05NPDiExSZlM4Qs3Fw84f-_ZIsf4RVwy42TFpWpGF2hFin0I51ZLVi51xRv_fPJE4Ez0sKrSkTD8Fodj_erSDag9'
    };
    BaseOptions options = BaseOptions(
      connectTimeout: Duration(seconds: 5000),
      receiveTimeout: Duration(seconds: 3000),
      headers: headers,
    );
    try {
      final response = await Dio(options).post('https://fcm.googleapis.com/fcm/send', data: data);
      if (response.statusCode == 200) {
        isNotificationSent = true;
      } else {
        isNotificationSent = false;
      }
    }
    catch (e) {
      isNotificationSent = false;
      print('exception $e');
    }
    return isNotificationSent;
  }
}