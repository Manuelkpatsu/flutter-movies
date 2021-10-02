import 'package:fluttermovieapp/utils/constants.dart';
import 'package:fluttermovieapp/utils/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MovieDetails {
  final String title;
  final String year;
  final bool isFavorite;
  final double rating;
  final List<String> genres;
  final String overview;
  final String backgroundURL;

  MovieDetails({
    required this.title,
    required this.year,
    required this.isFavorite,
    required this.rating,
    required this.genres,
    required this.overview,
    required this.backgroundURL,
  });

  List<CustomButton> getGenresList() {
    List<CustomButton> temp = [];
    for (var item in genres) {
      temp.add(
        CustomButton(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          color: kLightGrey,
          text: item,
        ),
      );
    }
    return temp;
  }
}
