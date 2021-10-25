import 'package:conca/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Background extends StatefulWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  /*
  initializing the values of animation in its settled state.
   */
  double _bottomTop = estimatedHeight * 1.2;
  double _leftRight = estimatedWidth;
  double _rightLeft = estimatedWidth;
  Color _bottomColor = kSemiDarkAccentColor.withOpacity(0.3);
  Color _leftColor = kDarkAccentColor.withOpacity(0.3);
  Color _rightColor = kAccentColor.withOpacity(0.4);

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      setState(() {
        // Positioned animation
        _bottomTop = estimatedHeight *0.75;
        _leftRight = estimatedWidth *0.2;
        _rightLeft = estimatedWidth *0.3;
        //Color animations
        _bottomColor = kSemiDarkAccentColor.withOpacity(0.8);
        _leftColor = kDarkAccentColor.withOpacity(0.8);
        _rightColor = kAccentColor.withOpacity(1);
      });
    });
    super.initState();
  }
  /*
  Test cases for animation
  Two Buttons run two methods
  1. to apply animation (updateLayout)
  2. resetting animation (reset)
   */
  void updateLayout(){
    setState(() {
      _bottomTop = estimatedHeight *0.75;
      _leftRight = estimatedWidth *0.2;
      _rightLeft = estimatedWidth *0.3;
      //
      _bottomColor = kSemiDarkAccentColor.withOpacity(0.8);
      _leftColor = kDarkAccentColor.withOpacity(0.8);
      _rightColor = kAccentColor.withOpacity(1);
    });
  }
  void reset(){
    setState(() {
      _bottomTop = estimatedHeight * 1.5;
      _leftRight = estimatedWidth;
      _rightLeft = estimatedWidth;
      //
      _bottomColor = kSemiDarkAccentColor.withOpacity(0.3);
      _leftColor = kDarkAccentColor.withOpacity(0.3);
      _rightColor = kAccentColor.withOpacity(0.4);

    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: size.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[

            // the Bottom circle
            AnimatedPositioned(
              duration: Duration(milliseconds: 1000),
              top: _bottomTop,
              left: -size.width * 0.2,
              child: SvgPicture.asset(
                "assets/images/blob.svg",
                color: _bottomColor,
                width: size.width * 1.4,
              ),
            ),
            // Left circle
            AnimatedPositioned(
              duration: Duration(milliseconds: 1800),
              bottom: 0,
              right: _leftRight,
              child: SvgPicture.asset(
                "assets/images/blob.svg",
                color: _leftColor,
                width: size.width * 3,
              ),
            ),
            //Top right Edged blob
            AnimatedPositioned(
              duration: Duration(milliseconds: 1500),
              bottom: size.height * 0.4,
              left: _rightLeft,
              child: SvgPicture.asset(
                "assets/images/blob_1.svg",
                color: _rightColor,
                width: size.width * 1.5,
              ),
            ),
            // fill space blob for bigger screen resolution
            Positioned(
              bottom: size.height * 0.4,
              right: size.width * 0.3,
              child: SvgPicture.asset(
                "assets/images/blob_1.svg",
                color: kAccentColor.withOpacity(1),
                width: size.width * 3,
              ),
            ),
            // top Positioned buttons for animation test cases
            /*
            Positioned(
              top: 30,
              left: 0,
              child: ElevatedButton(
                child: Text('click me'),
                onPressed: () => updateLayout(),
              ),),
            Positioned(
              top: 60,
              left: 0,
              child: ElevatedButton(
                child: Text('click me'),
                onPressed: () => reset(),
               ),),
           */
            widget.child,
          ],
        ),
      ),
    );
  }
}
