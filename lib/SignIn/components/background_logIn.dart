import 'package:conca/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

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
            Positioned(
              top: size.height * 0.75,
              left: -size.width * 0.2,
              child: SvgPicture.asset(
                "assets/images/blob.svg",
                color: kSemiDarkAccentColor.withOpacity(0.8),
                width: size.width * 1.4,
              ),
            ),
            // Left circle
            Positioned(
              bottom: 0,
              right: size.width * 0.2,
              child: SvgPicture.asset(
                "assets/images/blob.svg",
                color: kDarkAccentColor.withOpacity(0.8),
                width: size.width * 3,
              ),
            ),
            //Top right Edged blob
            Positioned(
              bottom: size.height * 0.4,
              left: size.width * 0.3,
              child: SvgPicture.asset(
                "assets/images/blob_1.svg",
                color: kAccentColor.withOpacity(1),
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
            child,
          ],
        ),
      ),
    );
  }
}
