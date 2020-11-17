import 'dart:ui';

import 'logic/global.dart';
import 'package:flutter/material.dart';

class Friend_request_list extends StatefulWidget {
  @override
  _Friend_request_listState createState() => _Friend_request_listState();
}


class _Friend_request_listState extends State<Friend_request_list> {

  final myController = TextEditingController();

  @override Widget build(BuildContext context) {
    debugPrint("뭐야 뭐냐구 ${friend_requests.length}");
    if (friend_requests.length != 0) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Friends List"),
          ),
          body: ListView.builder(
              itemCount: friend_requests.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(friend_requests[index],
                      style: TextStyle(
                        fontSize: 20.0,
                      )),
                  trailing: Wrap(
                    spacing: 1, // space between two icons
                    children: <Widget>[
                      FlatButton(
                          onPressed: () async{
                            acceptfriendrequest(friend_requests[index]);
                            gamecards=[];

                            await loadmydata();
                            await loadfrienddata();
                            friend_requests.removeAt(index);
                            if(friend_requests.length == 0) {
                              Navigator.pop(context);
                            }
                            setState(() {});
                          },
                          child: Text('Accept',
                              style: TextStyle(
                                fontSize: 14.0,
                              )
                          )
                      ), // icon-1
                      FlatButton(
                          onPressed: () {
                            denyfriendrequest(friend_requests[index]);
                            friend_requests.removeAt(index);
                            if(friend_requests.length == 0) {
                              Navigator.pop(context);
                            }
                            setState(() {
                            });
                          },
                          child: Text('Deny',
                              style: TextStyle(
                                fontSize: 14.0,
                              )
                          )
                      ), // icon-2
                    ],
                  ),


                );
              }
          )
      );
    }

    else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Friends List"),
        ),
        body: AlertDialog(
          content: Text('친구 요청이 없습니다.'),
          actions: [
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

}