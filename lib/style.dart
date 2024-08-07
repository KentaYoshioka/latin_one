import 'package:flutter/material.dart';

// font

const TextStyle Default_title_Style = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 24,
  color: Colors.white,
);

const TextStyle Shopinfo_title = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 30,
    color: Colors.black
);

const TextStyle Shopinfo = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: Colors.black
);

//decoration_image

BoxDecoration background_image(String imagePath) {
  return BoxDecoration(
    image: DecorationImage(
      image: AssetImage(imagePath),
      fit: BoxFit.cover,
    ),
  );
}
