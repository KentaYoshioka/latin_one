import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// font

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? screenWidthRatio;
  static double? screenHeightRatio;
  double baseWidth = 411.42857142857144; // Pixel 8を基準
  double baseHeight = 866.2857142857143;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    print(screenWidth);
    screenHeight = _mediaQueryData!.size.height;
    print(screenHeight);
    screenWidthRatio = screenWidth! / baseWidth;
    print(screenWidthRatio);
    screenHeightRatio = screenHeight! / baseHeight;
    print(screenHeightRatio);
  }
}

TextStyle product_title(BuildContext context) {
  SizeConfig().init(context);
  double fontSizeRatio = SizeConfig.screenWidthRatio ?? 1.0;

  return TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16 * fontSizeRatio,
    color: Colors.black,
  );
}

TextStyle Default_title_Style(BuildContext context) {
  SizeConfig().init(context);
  double fontSizeRatio = SizeConfig.screenHeightRatio ?? 1.0;

  return TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24 * fontSizeRatio,
    color: Colors.white,
  );
}

TextStyle Order_Style(BuildContext context) {
  SizeConfig().init(context);
  double fontSizeRatio = SizeConfig.screenHeightRatio ?? 1.0;

  return TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24 * fontSizeRatio,
    color: Colors.black,
  );
}

TextStyle Shopinfo_title(BuildContext context) {
  SizeConfig().init(context);
  double fontSizeRatio = SizeConfig.screenHeightRatio ?? 1.0;

  return TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 30 * fontSizeRatio,
    color: Colors.black,
  );
}

TextStyle Shopinfo(BuildContext context) {
  SizeConfig().init(context);
  double fontSizeRatio = SizeConfig.screenHeightRatio ?? 1.0;

  return TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20 * fontSizeRatio,
    color: Colors.black,
  );
}

TextStyle normal(BuildContext context) {
  SizeConfig().init(context);
  double fontSizeRatio = SizeConfig.screenWidthRatio ?? 1.0;

  return TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14 * fontSizeRatio,
    color: Colors.black,
  );
}

//decoration_image

BoxDecoration background_image(String imagePath) {
  return BoxDecoration(
    image: DecorationImage(
      image: AssetImage(imagePath),
      fit: BoxFit.cover,
    ),
  );
}
