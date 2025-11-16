import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tugas/core/theme/app_colors.dart';

class CardSkeletonWidget extends StatelessWidget {
  const CardSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Skeletonizer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,

            onTap: () {},
            child: Column(
              children: [
                Container(
                  height: (size.height / 2) * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(height: 10.sp),
                Text(
                  "product.title",
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.sp),
                ),
                Text(
                  "product.category",
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark
                        ? AppColors.secondaryDark
                        : AppColors.secondaryLight,
                  ),
                ),
              ],
            ),
          ),

          Text(
            '\$ 200',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              color: isDark ? Colors.white : AppColors.accentLight,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20.sp),
                  SizedBox(width: 4.sp),
                  Text(
                    '02',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.primaryDark
                          : AppColors.primaryLight,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: Icon(Icons.favorite, color: Colors.red),
                    ),
                  ),

                  SizedBox(width: 10),
                  Icon(
                    Icons.add_shopping_cart,
                    // color: AppColors.secondaryLight,
                    size: 18.sp,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
