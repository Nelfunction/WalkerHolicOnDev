import 'package:flutter/material.dart';

class Bottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(50, 0, 0, 0),
      child: Container(
        height: 70,
        child: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.transparent,
          tabs: <Widget>[
            Tab(
              icon: new Image.asset("assets/images/home.png",
              width: 40,
              height: 40,
              )
            ),
            Tab(
                icon: new Image.asset("assets/images/graph.png",
                  width: 40,
                  height: 40,
                )
            ),
            Tab(
                icon: new Image.asset("assets/images/setting.png",
                  width: 50,
                  height: 50,
                )
            ),

          ],
        ),
      ),
    );
  }

}