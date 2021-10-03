import 'package:flutter/material.dart';
import 'package:fluttermovieapp/services/movie.dart';
import 'package:fluttermovieapp/utils/constants.dart';
import 'package:fluttermovieapp/widgets/custom_loader.dart';
import 'package:fluttermovieapp/widgets/custom_search_app_bar.dart';
import 'package:fluttermovieapp/widgets/movie_card.dart';
import 'package:fluttermovieapp/widgets/movie_card_container.dart';
import 'package:fluttermovieapp/widgets/shadowless_floating_button.dart';
import 'package:sizer/sizer.dart';
import 'package:fluttermovieapp/utils/scroll_to_top.dart' as scrollTop;

class SearchScreen extends StatefulWidget {
  final Color themeColor;

  SearchScreen({required this.themeColor});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String textFieldValue = "";
  late ScrollController _scrollController;
  bool showBackToTopButton = false;
  List<MovieCard>? _movieCards;
  bool showLoadingScreen = false;

  Future<void> loadData(String movieName) async {
    MovieModel movieModel = MovieModel();
    _movieCards = await movieModel.searchMovies(
        movieName: movieName, themeColor: widget.themeColor);

    setState(() {
      scrollTop.scrollToTop(_scrollController);
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          showBackToTopButton = (_scrollController.offset >= 200);
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 18.h,
        title: Text(kFinderScreenTitleText, style: kSmallAppBarTitleTextStyle),
        backgroundColor: kSearchAppBarColor,
        shadowColor: Colors.transparent,
        bottom: PreferredSize(
          child: CustomSearchAppbar(
              onChanged: (value) => textFieldValue = value,
              onEditingComplete: () {
                if (textFieldValue.length > 0) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  showLoadingScreen = true;

                  setState(() {
                    _movieCards = null;
                    loadData(textFieldValue);
                  });
                }
              }),
          preferredSize: Size.zero,
        ),
      ),
      body: (_movieCards == null)
          ? ((showLoadingScreen) ? CustomLoader(loadingColor: widget.themeColor) : null)
          : (_movieCards!.length == 0)
              ? Center(
                  child: Text(
                  kNotFoundErrorText,
                  style: kSplashScreenTextStyle,
                ))
              : MovieCardContainer(
                  scrollController: _scrollController,
                  themeColor: widget.themeColor,
                  movieCards: _movieCards!,
                ),
      floatingActionButton: showBackToTopButton
          ? ShadowlessFloatingButton(
              backgroundColor: widget.themeColor,
              iconData: Icons.keyboard_arrow_up_outlined,
              onPressed: () => setState(() => scrollTop.scrollToTop(_scrollController)),
            )
          : null,
    );
  }
}
