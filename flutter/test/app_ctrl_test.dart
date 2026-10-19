import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nola/controllers/app_ctrl.dart';

void main() {
  setUpAll(() async {
    await dotenv.load(fileName: 'assets/.env', isOptional: true);
  });

  group('AppScreenState', () {
    test('has exactly welcome and agent states', () {
      expect(AppScreenState.values, hasLength(2));
      expect(AppScreenState.values, contains(AppScreenState.welcome));
      expect(AppScreenState.values, contains(AppScreenState.agent));
    });
  });

  group('AgentScreenState', () {
    test('has exactly visualizer and transcription states', () {
      expect(AgentScreenState.values, hasLength(2));
      expect(AgentScreenState.values, contains(AgentScreenState.visualizer));
      expect(AgentScreenState.values, contains(AgentScreenState.transcription));
    });
  });

  group('kNolaAgentName', () {
    test('matches the Python agent dispatch name', () {
      expect(kNolaAgentName, 'nola');
    });
  });

  group('send button state', () {
    test('tracks whether the message field has text', () async {
      final ctrl = AppCtrl();
      addTearDown(ctrl.dispose);

      expect(ctrl.isSendButtonEnabled, isFalse);

      ctrl.messageCtrl.text = 'hello';
      await Future<void>.delayed(Duration.zero);
      expect(ctrl.isSendButtonEnabled, isTrue);

      ctrl.messageCtrl.clear();
      await Future<void>.delayed(Duration.zero);
      expect(ctrl.isSendButtonEnabled, isFalse);
    });
  });

  group('screen mode toggle', () {
    test('flips between visualizer and transcription', () {
      final ctrl = AppCtrl();
      addTearDown(ctrl.dispose);

      expect(ctrl.agentScreenState, AgentScreenState.visualizer);

      ctrl.toggleAgentScreenMode();
      expect(ctrl.agentScreenState, AgentScreenState.transcription);

      ctrl.toggleAgentScreenMode();
      expect(ctrl.agentScreenState, AgentScreenState.visualizer);
    });
  });

  group('camera toggle flag', () {
    test('flips isUserCameEnabled without a device context', () {
      final ctrl = AppCtrl();
      addTearDown(ctrl.dispose);

      expect(ctrl.isUserCameEnabled, isFalse);

      ctrl.toggleUserCamera(null);
      expect(ctrl.isUserCameEnabled, isTrue);

      ctrl.toggleUserCamera(null);
      expect(ctrl.isUserCameEnabled, isFalse);
    });
  });
}