# Nola — Flutter Client

A Flutter cross-platform voice AI client that connects to the Nola voice agent via LiveKit's Session API.

## Setup

### 1. Enable the Development Token Server

In [LiveKit Cloud](https://cloud.livekit.io), enable **Development Token Server** in your project settings and copy the **Token server ID**.

### 2. Configure environment

```bash
cp assets/.env.example assets/.env
```

Edit `assets/.env` and set:

```
LIVEKIT_TOKEN_SERVER_ID=<your-token-server-id>
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Build and run

**iOS (macOS):**
```bash
flutter build ios --simulator --no-codesign
flutter run -d <simulator-id>
```

**Android:**
```bash
flutter build apk --debug
adb install build/app/outputs/flutter-apk/app-debug.apk
```

**Web:**
```bash
flutter run -d chrome
```

## Permissions

### iOS — `ios/Runner/Info.plist`

Add these entries inside `<dict>`:

```xml
<key>NSCameraUsageDescription</key>
<string>Nola uses the camera so she can see you.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Nola uses the microphone to hear you.</string>
```

### Android — `android/app/src/main/AndroidManifest.xml`

Add inside `<manifest>`:

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

## Architecture

- `lib/main.dart` — entry point, loads `.env`
- `lib/app.dart` — `MaterialApp` with `ChangeNotifierProvider<AppCtrl>`
- `lib/controllers/app_ctrl.dart` — session management, media controls, screen state
- `lib/exts.dart` — `Participant`, `ReceivedMessage` extensions
- `lib/ui/color_palette.dart` — light/dark color themes
- `lib/screens/welcome_screen.dart` — connect screen with branding
- `lib/screens/agent_screen.dart` — agent visualizer, transcription panel, control bar
- `lib/widgets/` — reusable components

## How it works

1. `AppCtrl.connect()` calls `Session.withAgent("nola", tokenSource: DevelopmentTokenSource(...))`
2. The agent name `"nola"` matches `@server.rtc_session(agent_name="nola")` in the Python agent
3. The token server dispatches the session to the running Nola agent
4. Audio flows to/from Nola via LiveKit's realtime pipeline
5. `Session.sendText()` sends typed chat messages; `Session.messagesStream` renders transcripts
6. `mediaDevice.enableCamera()` / `disableCamera()` publishes video to the agent
