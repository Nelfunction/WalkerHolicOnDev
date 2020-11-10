import 'package:flutter/material.dart';
import 'dart:ui';

class Bottom extends StatelessWidget {
  final double _iconsize = 30;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
        child: Container(
          height: 60,
          color: const Color(0x4e898989),
          child: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.transparent,
            tabs: <Widget>[
              Tab(
                  icon: new Image.asset(
                "assets/images/game.png",
                width: _iconsize,
                height: _iconsize,
              )),
              Tab(
                  icon: new Image.asset(
                "assets/images/home.png",
                width: _iconsize,
                height: _iconsize,
              )),
              Tab(
                  icon: new Image.asset(
                "assets/images/graph.png",
                width: _iconsize,
                height: _iconsize,
              )),
              Tab(
                  icon: new Image.asset(
                "assets/images/setting.png",
                width: _iconsize,
                height: _iconsize,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
