import 'package:flutter/material.dart';
import 'game_screen.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

double catsize = 200;

class _MyHomeState extends State<MyHome> {
  TextStyle thumbnailStyle =
      new TextStyle(fontSize: 20, fontWeight: FontWeight.w600, shadows: [
    Shadow(
        // bottomLeft
        offset: Offset(-1.5, -1.5),
        color: Colors.black),
    Shadow(
        // bottomRight
        offset: Offset(1.5, -1.5),
        color: Colors.black),
    Shadow(
        // topRight
        offset: Offset(1.5, 1.5),
        color: Colors.black),
    Shadow(
        // topLeft
        offset: Offset(-1.5, 1.5),
        color: Colors.black),
  ]);

  //MyGame game = MyGame();
  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          accentColor: Colors.white,
          buttonColor: Colors.black),
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            margin: EdgeInsets.fromLTRB(30, 60, 30, 40),
            child: InkWell(
                onTap: () {
                  print("tapped!");
                  Navigator.of(context).push(createRoute(FullGame()));
                },
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: new AssetImage(
                                'assets/images/pixel_background2.jpg'),
                            fit: BoxFit.none),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.transparent, width: 8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(0.0, 2.0), //(x,y)
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Station_Soen",
                            style: thumbnailStyle,
                          ),
                          Text(
                            (catsize.toInt() * 10).toString() + " Steps",
                            style: thumbnailStyle,
                          )
                        ],
                      ),
                      right: 20,
                      bottom: 20,
                    )
                  ],
                ))),
        floatingActionButton: FloatingActionButton(
          heroTag: "btnHome",
          onPressed: () {
            if (catsize == 400) {
              catsize = 200;
            } else {
              catsize = 400;
            }
            setState(() {});
          },
          tooltip: "Increment",
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
