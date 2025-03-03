import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../bloc/banner_bloc/banner_bloc.dart';
import '../../../bloc/banner_bloc/banner_event.dart';
import '../../../bloc/banner_bloc/banner_state.dart';
import '../../../repositories/banner_repository.dart';

class BannerModel1 extends StatelessWidget {
  final String bgColor;
  final String titlecolor;
  final double height;
  final int bannerId;
  final double padding;
  final double borderradious;

  const BannerModel1({
    super.key,
    required this.bgColor,
    required this.titlecolor,
    required this.height,
    required this.bannerId,
    this.padding = 8,
    this.borderradious = 15,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BannerBloc(bannerepository: BannerRepository())..add(FetchBanners()),
      child: Builder(
        builder: (context) {
          return BlocBuilder<BannerBloc, BannerState>(
            builder: (context, state) {
              if (state is BannerLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BannerLoaded) {
                final filteredBanners = state.banners
                    .where((banner) => banner.bannerId == bannerId)
                    .toList();

                if (filteredBanners.isEmpty) {
                  return const SizedBox();
                }

                return Container(
                  color: parseColor(bgColor),
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Stack(
                      children: [
                        CarouselSlider.builder(
                          itemCount: filteredBanners.length,
                          options: CarouselOptions(
                            height: height,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            enlargeCenterPage: true,
                            viewportFraction: 1.0,
                            onPageChanged: (index, reason) {},
                          ),
                          itemBuilder: (context, index, realIndex) {
                            final banner = filteredBanners[index];
                            return ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(borderradious),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(banner.bannerImage),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: SmoothPageIndicator(
                              controller: PageController(),
                              count: filteredBanners.length,
                              effect: const ExpandingDotsEffect(
                                activeDotColor: Colors.white,
                                dotHeight: 6,
                                dotWidth: 6,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is BannerError) {
                return Center(child: Text("Error: ${state.message}"));
              }
              return const Center(child: Text("No data available"));
            },
          );
        },
      ),
    );
  }
}

Color parseColor(String? hexColor) {
  if (hexColor == null || hexColor.isEmpty) {
    return const Color(0xFFADD8E6);
  }
  hexColor = hexColor.replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  } else if (hexColor.length != 8) {
    return const Color(0xFFADD8E6);
  }
  try {
    return Color(int.parse("0x$hexColor"));
  } catch (e) {
    return const Color(0xFFADD8E6);
  }
}
