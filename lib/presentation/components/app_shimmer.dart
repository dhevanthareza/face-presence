import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BoxShimmer extends StatefulWidget {
  const BoxShimmer({Key? key}) : super(key: key);

  @override
  State<BoxShimmer> createState() => _BoxShimmerState();
}

class _BoxShimmerState extends State<BoxShimmer> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Container(
        decoration: ShapeDecoration(
          color: Colors.grey[400]!,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        height: 80,
        width: double.infinity,
      ),
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.white,
    );
  }
}

class ListShimmer extends StatelessWidget {
  const ListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        BoxShimmer(),
        SizedBox(
          height: 12,
        ),
        BoxShimmer(),
        SizedBox(height: 12),
        BoxShimmer()
      ],
    );
  }
}
