import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/helper.dart';
import 'package:palette_generator/palette_generator.dart';

class ThemeController extends GetxController {
  final primaryColor = Colors.deepPurple[400].obs;
  final textColor = Colors.white24.obs;
  final themedata = Rxn<ThemeData>();

  ThemeController() {
    themedata.value = _createThemeData(
        _createMaterialColor(primaryColor.value!), ThemeType.dynamic);
  }
  void setTheme(ImageProvider imageProvider) async {
    PaletteGenerator generator =
        await PaletteGenerator.fromImageProvider(imageProvider);
    //final colorList = generator.colors;
    final paletteColor = generator.dominantColor ??
        generator.darkMutedColor ??
        generator.darkVibrantColor ??
        generator.lightMutedColor ??
        generator.lightVibrantColor;
    primaryColor.value = paletteColor!.color;
    textColor.value = paletteColor.bodyTextColor;
   // printINFO(paletteColor.color.computeLuminance().toString());
    if (paletteColor.color.computeLuminance() > 0.11) {
      primaryColor.value = paletteColor.color.withLightness(0.11);
      textColor.value = Colors.white54;
    }
    final primarySwatch = _createMaterialColor(primaryColor.value!);
    themedata.value = _createThemeData(primarySwatch, ThemeType.dynamic,
        textColor: textColor.value,
        titleColorSwatch: _createMaterialColor(textColor.value));
  }

  ThemeData _createThemeData(MaterialColor primarySwatch, ThemeType themeType,
      {MaterialColor? titleColorSwatch, Color? textColor}) {
    if (themeType == ThemeType.dynamic) {
      return ThemeData(
          primaryColor: primarySwatch[500],
          accentColor: primarySwatch[200],
          primaryColorLight: primarySwatch[100],
          primaryColorDark: primarySwatch[700],
          secondaryHeaderColor: primarySwatch[50],
          canvasColor: primarySwatch[700],
          scaffoldBackgroundColor: primarySwatch[700],
          bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: primarySwatch[600],
              modalBarrierColor: primarySwatch[400]),
          textTheme: TextTheme(
            titleLarge: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: textColor ?? primarySwatch[50]),
            titleMedium: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor ?? primarySwatch[50]),
            titleSmall: TextStyle(color: primarySwatch[300]),
            labelMedium: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: textColor ?? primarySwatch[50]),
            labelSmall: TextStyle(
                fontSize: 15,
                color: titleColorSwatch != null
                    ? titleColorSwatch[900]
                    : primarySwatch[100],
                letterSpacing: 1,
                fontWeight: FontWeight.bold),
          ),
          progressIndicatorTheme: ProgressIndicatorThemeData(
              linearTrackColor: (primarySwatch[300])!.computeLuminance() > 0.3
                  ? Colors.black54
                  : Colors.white60),
          navigationRailTheme: NavigationRailThemeData(
              backgroundColor: primarySwatch[600],
              selectedLabelTextStyle: TextStyle(
                  color: primarySwatch[0], fontWeight: FontWeight.bold),
              unselectedLabelTextStyle: TextStyle(
                  color: primarySwatch[100], fontWeight: FontWeight.bold)),
          sliderTheme: SliderThemeData(
            inactiveTrackColor: primarySwatch[300],
            activeTrackColor: primarySwatch[400],
            valueIndicatorColor: textColor,
            thumbColor: Colors.white,
          )
          //scaffoldBackgroundColor: primarySwatch[700]
          );
    } else if (themeType == ThemeType.dark) {
      return ThemeData(
        primaryColor: primarySwatch[500],
        accentColor: primarySwatch[200],
        primaryColorLight: primarySwatch[100],
        primaryColorDark: primarySwatch[700],
        toggleableActiveColor: primarySwatch[600],
        secondaryHeaderColor: primarySwatch[50],
        backgroundColor: primarySwatch[200],
      );
    } else {
      return ThemeData(
        primaryColor: primarySwatch[500],
        accentColor: primarySwatch[200],
        primaryColorLight: primarySwatch[100],
        primaryColorDark: primarySwatch[700],
        toggleableActiveColor: primarySwatch[600],
        secondaryHeaderColor: primarySwatch[50],
        backgroundColor: primarySwatch[200],
      );
    }
  }

  MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}

extension ColorWithHSL on Color {
  HSLColor get hsl => HSLColor.fromColor(this);

  Color withSaturation(double saturation) {
    return hsl.withSaturation(clampDouble(saturation, 0.0, 1.0)).toColor();
  }

  Color withLightness(double lightness) {
    return hsl.withLightness(clampDouble(lightness, 0.0, 1.0)).toColor();
  }

  Color withHue(double hue) {
    return hsl.withHue(clampDouble(hue, 0.0, 360.0)).toColor();
  }
}

enum ThemeType {
  dynamic,
  dark,
  light,
}
