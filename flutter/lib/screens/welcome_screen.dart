import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart' as sdk;
import 'package:provider/provider.dart';

import '../controllers/app_ctrl.dart' as ctrl;
import '../widgets/agent_status_indicator.dart';
import '../widgets/button.dart' as buttons;

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext ctx) => Material(
        color: Colors.transparent,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 30,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(ctx).colorScheme.surface.withValues(alpha: 0.6),
                  ),
                  child: Icon(
                    Icons.mic_rounded,
                    size: 40,
                    color: Theme.of(ctx).colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Nola',
                  textAlign: TextAlign.center,
                  style: Theme.of(ctx).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1,
                      ),
                ),
                const Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Your British voice assistant. Start a call to chat with Nola. Need help getting set up? Check out the ',
                      ),
                      TextSpan(
                        text: 'Voice AI quickstart',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,
                          decorationThickness: 1,
                        ),
                      ),
                      TextSpan(text: '.'),
                    ],
                  ),
                ),
                // Agent status indicator
                const AgentStatusIndicator(),
                Consumer2<ctrl.AppCtrl, sdk.Session>(
                  builder: (ctx, appCtrl, session, child) {
                    final isProgressing =
                        appCtrl.isSessionStarting || session.connectionState != sdk.ConnectionState.disconnected;
                    return buttons.Button(
                      text: isProgressing ? 'Connecting' : 'Start call',
                      isProgressing: isProgressing,
                      onPressed: () => appCtrl.connect(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
}