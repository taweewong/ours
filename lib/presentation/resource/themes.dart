import 'package:flutter/material.dart';
import 'package:ours/presentation/resource/colors.dart';
import 'package:ours/presentation/resource/dimens.dart';

final lightTheme = ourTheme.copyWith(
  primaryColor: OurColors.lightPrimary,
  extensions: <ThemeExtension<dynamic>>[
    const CustomColors(
      secondaryColor: OurColors.lightSecondary,
      accentColor: OurColors.lightAccent,
    ),
  ],
);

final darkTheme = ourTheme.copyWith(
  primaryColor: OurColors.darkPrimary,
  extensions: <ThemeExtension<dynamic>>[
    const CustomColors(
      secondaryColor: OurColors.darkSecondary,
      accentColor: OurColors.darkAccent,
    ),
  ],
);

final ourTheme = ThemeData(
  primaryColor: OurColors.lightPrimary,
  colorScheme: ColorScheme.fromSeed(seedColor: OurColors.lightPrimary),
  textTheme: TextTheme(
    titleSmall: TextStyleBuilder.withNotoSans(
      fontSize: OurDimension.fontSize.small,
      fontWeight: FontWeight.w800,
    ),
    titleMedium: TextStyleBuilder.withNotoSans(
      fontSize: OurDimension.fontSize.medium,
      fontWeight: FontWeight.w800,
    ),
    titleLarge: TextStyleBuilder.withNotoSans(
      fontSize: OurDimension.fontSize.large,
      fontWeight: FontWeight.w800,
    ),
    bodySmall: TextStyleBuilder.withNotoSans(
      fontSize: OurDimension.fontSize.small,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyleBuilder.withNotoSans(
      fontSize: OurDimension.fontSize.medium,
      fontWeight: FontWeight.w400,
    ),
    bodyLarge: TextStyleBuilder.withNotoSans(
      fontSize: OurDimension.fontSize.large,
      fontWeight: FontWeight.w400,
    ),
  ),
);

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color secondaryColor;
  final Color accentColor;

  const CustomColors({required this.secondaryColor, required this.accentColor});

  @override
  CustomColors copyWith({Color? secondaryColor, Color? accentColor}) {
    return CustomColors(
      secondaryColor: secondaryColor ?? this.secondaryColor,
      accentColor: accentColor ?? this.accentColor,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t) ?? secondaryColor,
      accentColor: Color.lerp(accentColor, other.accentColor, t) ?? accentColor,
    );
  }
}

extension TextStyleBuilder on TextStyle {
  static TextStyle withNotoSans({
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return TextStyle(
      fontFamily: "NotoSans",
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }
}

extension ThemeGetter on BuildContext {
  ThemeData get theme => Theme.of(this);
}

extension AppColorExtensionGetter on ThemeData {
  CustomColors get customColors => extension<CustomColors>()!;
}
