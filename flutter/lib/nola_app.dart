import 'package:flutter/material.dart';
import 'package:livekit_components/livekit_components.dart' as components;
import 'package:provider/provider.dart';

import 'controllers/app_ctrl.dart';
import 'screens/agent_screen.dart';
import 'screens/welcome_screen.dart';
import 'ui/color_palette.dart' show LKColorPaletteLight, LKColorPaletteDark;
import 'widgets/app_layout_switcher.dart';
import 'widgets/session_error_banner.dart';

/// Module-level [AppCtrl] instance shared across the app and widgets that
/// need to call methods on it (e.g. [AppCtrl].disconnect, toggleCamera, etc.)
/// without creating a circular dependency on [app.dart].
final appCtrl = AppCtrl();

class VoiceAssistantApp extends StatelessWidget {
  const VoiceAssistantApp({super.key});

  ThemeData buildTheme({required bool isLight}) {
    final colorPalette = isLight ? LKColorPaletteLight() : LKColorPaletteDark();

    return ThemeData(
      useMaterial3: true,
      cardColor: colorPalette.bg2,
      scaffoldBackgroundColor: colorPalette.bg1,
      canvasColor: colorPalette.bg1,
      inputDecorationTheme: InputDecorationTheme(
        fillColor: colorPalette.bg2,
        hintStyle: TextStyle(
          color: colorPalette.fg4,
          fontSize: 14,
        ),
      ),
      buttonTheme: ButtonThemeData(
        disabledColor: Colors.red,
        colorScheme: ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.white,
          surface: colorPalette.fgAccent,
        ),
      ),
      colorScheme: isLight
          ? const ColorScheme.light(
              primary: Colors.black,
              secondary: Colors.black,
              surface: Colors.white,
            )
          : const ColorScheme.dark(
              primary: Colors.white,
              secondary: Colors.white,
              surface: Colors.black,
            ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext ctx) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: appCtrl),
          ChangeNotifierProvider.value(value: appCtrl.session),
          ChangeNotifierProvider.value(value: appCtrl.roomContext),
        ],
        child: components.SessionContext(
          session: appCtrl.session,
          child: MaterialApp(
            title: 'Nola',
            debugShowCheckedModeBanner: false,
            theme: buildTheme(isLight: true),
            darkTheme: buildTheme(isLight: false),
            // themeMode: ThemeMode.dark,
            home: Builder(
              builder: (ctx) => Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Stack(
                    children: [
                      Selector<AppCtrl, AppScreenState>(
                        selector: (ctx, appCtx) => appCtx.appScreenState,
                        builder: (ctx, screen, _) => AppLayoutSwitcher(
                          frontBuilder: (ctx) => const WelcomeScreen(),
                          backBuilder: (ctx) => const AgentScreen(),
                          isFront: screen == AppScreenState.welcome,
                        ),
                      ),
                      const SessionErrorBanner(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}