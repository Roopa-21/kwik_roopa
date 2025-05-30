import 'package:flutter/material.dart';
import 'package:kwik/widgets/shimmer/product_model_1_shimmer.dart';
import 'package:kwik/widgets/shimmer/shimmer1.dart';

class ProductModel1ListShimmer extends StatelessWidget {
  const ProductModel1ListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 10,
      children: [
        Expanded(child: ProductModel1Shimmer()),
        Expanded(child: ProductModel1Shimmer()),
        Expanded(child: ProductModel1Shimmer()),
      ],
    );
  }
}
