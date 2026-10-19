# Nola — Voice AI Butler

A voice-controlled AI assistant built on the **LiveKit Agents** framework. Speak to Nola, and she responds with a warm, adaptive British female persona while completing tasks with her available tools.

## Features

- **Voice Conversations** — Real-time voice I/O powered by LiveKit with adaptive interruptions and preemptive generation
- **Gemini 2.0 Flash** — Uses Google's realtime model with a British female voice (`Kore`)
- **Adaptive Personality** — Nola reads the room and shifts between Warm, Sophisticated, Playful, and Efficient modes based on your conversation
- **Randomized Greetings** — Fresh, natural openings that match her current vibe — never the same greeting twice
- **Camera Support** — Video input enabled so Nola can see you
- **Wake Phrase** — Responds to "Hey Nola", "Nola", or natural requests without explicit activation
- **Browser Control** — Full Playwright-powered Chromium automation with 11 tools: `open_url`, `search_the_web`, `read_page`, `inspect_page`, `go_back`, `take_screenshot`, `click`, `type_text`, `scroll`, `press_key`, and a confirmation gate for consequential actions

## Project Structure

```
my-agent/
├── src/
│   ├── agent.py            # Entrypoint — AgentServer, Nola class
│   ├── prompts.py          # System instructions and Nola's personality
│   ├── browser.py          # BrowserManager (Playwright Chromium)
│   ├── tools.py            # NolaBrowserTools — 11 browser function tools
│   ├── nola.py             # Public exports
│   └── __init__.py
├── frontend/               # React web UI (TODO)
├── flutter/                # Flutter mobile client (TODO)
├── pyproject.toml          # Python deps (managed with uv)
├── .env.example            # Environment variable template
├── .env.local              # Local credentials (gitignored)
└── Dockerfile
```

## Prerequisites

- **Python** >= 3.10
- **uv** package manager
- **pnpm** (for the React frontend)
- **Flutter SDK** >= 3.5.1 (for the mobile app)
- **Node.js** >= 20

## Installation

### 1. Python Agent

```bash
cd my-agent
uv sync
uv run playwright install chromium
```

### 2. React Web Frontend (TODO)

```bash
cd frontend
pnpm install
```

### 3. Flutter Mobile App (TODO)

```bash
cd flutter
flutter pub get
```

## Configuration

Copy the example environment file and fill in your credentials:

```bash
cd my-agent
cp .env.example .env.local
```

Required environment variables:

| Variable | Description |
|---|---|
| `LIVEKIT_URL` | Your LiveKit Cloud WebSocket URL (e.g. `wss://your-project.livekit.cloud`) |
| `LIVEKIT_API_KEY` | LiveKit API key |
| `LIVEKIT_API_SECRET` | LiveKit API secret |
| `GOOGLE_API_KEY` | Google AI API key (for Gemini) |

## Running

### Agent (Python)

```bash
cd my-agent

# Development mode (connects to LiveKit dev server)
uv run src/agent.py dev

# Console mode (terminal-based voice chat)
uv run src/agent.py console

# IMPORTANT: run your agent before running the frontend!
```

### Web Frontend (TODO)

```bash
cd frontend
pnpm dev
```

Open http://localhost:3000 in your browser.

### Flutter App (TODO)

```bash
cd flutter
flutter run
```

## Architecture

Nola uses **LiveKit's realtime agent framework** with function tools:

1. **Voice Pipeline**: User speaks → LiveKit streams audio → AI Coustics denoises → Gemini Realtime processes
2. **Adaptive Personality**: Nola detects conversation tone and shifts between Warm, Sophisticated, Playful, and Efficient modes naturally
3. **Tool Calling**: Gemini invokes tools via LiveKit's function tool system
4. **Browser**: Playwright Chromium instance managed per-room with serialized async operations (TODO)

## Tech Stack

| Component | Technology |
|---|---|
| Agent Framework | LiveKit Agents |
| LLM | Google Gemini 3.1 Flash Live |
| Voice | LiveKit Google RealtimeModel ("Ash") |
| Browser Automation | Playwright (Chromium) — TODO |
| Noise Cancellation | AI Coustics |
| Web Frontend | Next.js / React (TODO) |
| Mobile Client | Flutter / Dart (TODO) |
| Package Manager | uv (Python), pnpm (JS) |
