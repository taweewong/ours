import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ours/app_navigation.dart';
import 'package:ours/presentation/resource/theme_provider.dart';
import 'package:ours/presentation/resource/themes.dart';

class OursApp extends ConsumerWidget {
  final String flavor;

  const OursApp({super.key, required this.flavor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String themeState = ref.watch(themeStateNotifierProvider);
    ThemeData theme = themeState == ThemeStateNotifier.light ? lightTheme : darkTheme;

    return MaterialApp.router(
      title: "Ours application",
      theme: theme,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: AppRouter.router,
    );
  }
}
