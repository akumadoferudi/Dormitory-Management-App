import 'package:flutter/material.dart';
import "package:carousel_slider/carousel_slider.dart";

class CarouselWidget extends StatefulWidget {
  final List<String> imageLinks;

  CarouselWidget({required this.imageLinks});

  @override
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: widget.imageLinks.map((imageLink) {
        return Container(
          child: Image.network(imageLink),
        );
      }).toList(),
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        aspectRatio: 2.0,
        initialPage: 0,
        onPageChanged: (index, reason) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }
}