import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/constants/app_constants.dart';
import 'core/themes/app_theme.dart';
import 'core/themes/theme_cubit.dart';
import 'core/utils/responsive_utils.dart';
import 'data/datasources/local/hive_storage.dart';
import 'data/datasources/remote/supabase_client.dart';
import 'features/todos/cubit/todo_cubit.dart';
import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await HiveStorage.init();

  // Initialize Supabase
  await SupabaseClientHelper.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => TodoCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp.router(
                title: AppConstants.appName,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState == ThemeState.dark
                    ? ThemeMode.dark
                    : ThemeMode.light,
                routerConfig: AppRouter.router,
                builder: (context, child) {
                  ResponsiveUtils.init(context);
                  return child ?? const SizedBox.shrink();
                },
              );
            },
          );
        },
      ),
    );
  }
}
