import 'package:conca/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Background extends StatefulWidget {
  final Widget child;
  const Background({
    @required this.child,
  });

  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  /*
  initializing the values of animation in its settled state.
   */
  double _bottomTop = estimatedHeight * 1.2;
  double _rightLeft = estimatedWidth;
  double _leftRight = estimatedWidth;
  Color _bottomColor = kGearYellow.withOpacity(0.3);
  Color _rightColor = kGearGrey.withOpacity(0.4);
  Color _leftColor = kGearOrange.withOpacity(0.2);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // Positioned animation
        _bottomTop = estimatedHeight * 0.75;
        _rightLeft = estimatedWidth * 0.2;
        _leftRight = estimatedWidth * 0.3;
        //Color animations
        _bottomColor = kGearYellow.withOpacity(0.9);
        _rightColor = kGearGrey.withOpacity(1);
        _leftColor = kGearOrange.withOpacity(0.6);
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
  void updateLayout() {
    setState(() {
      _bottomTop = estimatedHeight * 0.75;
      _rightLeft = estimatedWidth * 0.2;
      _leftRight = estimatedWidth * 0.3;
      //
      _bottomColor = kGearYellow.withOpacity(0.9);
      _rightColor = kGearGrey.withOpacity(1);
      _leftColor = kGearOrange.withOpacity(0.6);
    });
  }

  void reset() {
    setState(() {
      _bottomTop = estimatedHeight * 1.5;
      _rightLeft = estimatedWidth;
      _leftRight = estimatedWidth;
      //
      _bottomColor = kGearYellow.withOpacity(0.3);
      _rightColor = kGearGrey.withOpacity(0.4);
      _leftColor = kGearOrange.withOpacity(0.2);

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
            // the Bottom blob
            AnimatedPositioned(
              duration: Duration(milliseconds: 1100),
              top: _bottomTop,
              left: -size.width * 0.2,
              child: SvgPicture.asset(
                "assets/images/blob_1.svg",
                color: _bottomColor,
                width: size.width * 1.4,
              ),
            ),
            // right circle
            AnimatedPositioned(
              duration: Duration(milliseconds: 800),
              bottom: 0,
              left: _rightLeft,
              child: SvgPicture.asset(
                "assets/images/blob.svg",
                color: _rightColor,
                width: size.width * 3,
              ),
            ),
            //Top left circle
            AnimatedPositioned(
              duration: Duration(milliseconds: 1500),
              bottom: size.height * 0.4,
              right: _leftRight,
              child: SvgPicture.asset(
                "assets/images/blob.svg",
                color: _leftColor,
                width: size.width * 1.5,
              ),
            ),
            // fill space blob for bigger screen resolution
            Positioned(
              bottom: size.height * 0.4,
              right: size.width * 0.3,
              child: SvgPicture.asset(
                "assets/images/blob_1.svg",
                color: kGearYellow.withOpacity(1),
                width: size.width * 3,
              ),
            ),
            /*
            Positioned(
              top: 30,
              left: 0,
              child: ElevatedButton(
                child: Text('click me'),
                onPressed: () => updateLayout(),
              ),
            ),
            Positioned(
              top: 60,
              left: 0,
              child: ElevatedButton(
                child: Text('click me'),
                onPressed: () => reset(),
              ),
            ),
             */
            widget.child,
          ],
        ),
      ),
    );
  }
}
