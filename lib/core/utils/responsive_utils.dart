import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResponsiveUtils {
  static const double _tabletBreakpoint = 768;
  static const double _desktopBreakpoint = 1024;

  /// Returns true if the screen width is for mobile layout (< 768)
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < _tabletBreakpoint;
  }

  /// Returns true if the screen width is for tablet layout (>= 768 and < 1024)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= _tabletBreakpoint && width < _desktopBreakpoint;
  }

  /// Returns true if the screen width is for desktop layout (>= 1024)
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= _desktopBreakpoint;
  }

  /// Get number of grid columns based on screen size
  static int getGridColumns(BuildContext context) {
    if (isDesktop(context)) return 3;
    if (isTablet(context)) return 2;
    return 1;
  }

  /// Get appropriate horizontal padding based on screen size
  static double getHorizontalPadding(BuildContext context) {
    if (isDesktop(context)) return 48.w;
    if (isTablet(context)) return 32.w;
    return 16.w;
  }

  /// Get appropriate item spacing based on screen size
  static double getItemSpacing(BuildContext context) {
    if (isDesktop(context)) return 24.w;
    if (isTablet(context)) return 16.w;
    return 12.w;
  }

  /// Get appropriate content width constraint based on screen size
  static double getContentMaxWidth(BuildContext context) {
    if (isDesktop(context)) return 1200.w;
    if (isTablet(context)) return 768.w;
    return double.infinity;
  }

  /// Get appropriate dialog width based on screen size
  static double getDialogWidth(BuildContext context) {
    if (isDesktop(context)) return 600.w;
    if (isTablet(context)) return 480.w;
    return MediaQuery.of(context).size.width * 0.9;
  }

  /// Get appropriate border radius based on screen size
  static double getBorderRadius(BuildContext context) {
    if (isDesktop(context)) return 16.r;
    if (isTablet(context)) return 12.r;
    return 8.r;
  }

  /// Initialize ScreenUtil with design size
  static void init(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(375, 812), // Base design size (iPhone X)
      minTextAdapt: true,
    );
  }
}
