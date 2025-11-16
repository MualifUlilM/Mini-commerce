import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoriesSkeletonWidget extends StatelessWidget {
  const CategoriesSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          height: 60.sp,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            // itemCount: state.categories.length,
            itemBuilder: (context, index) {
              // final categoriesProduct = state.categories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(20.sp),
                  onTap: () {},
                  child: Chip(label: Text("loading...")),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
