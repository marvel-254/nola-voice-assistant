# Nola Voice AI Assistant — Project Summary

## Overview
Nola is a British female voice-controlled AI assistant built with **LiveKit Agents** using Google's **Gemini 2.0 Flash Live** model. She responds with an adaptive personality that shifts between Warm, Sophisticated, Playful, and Efficient modes.

## What Was Fixed

### 1. Syntax Errors in `src/agent.py`
- **Line 15**: Added missing `google` import so `google.beta.realtime.RealtimeModel` resolves
- **Lines 21-24**: Removed broken multi-line string literal that was treated as code instead of a docstring comment
- **Line 135**: Fixed `room_options` indentation (added missing comma after `video_input=True`)
- Replaced hardcoded instructions with imported `AGENT_INSTRUCTIONS` from `prompts.py`

### 2. Code Cleanup
- Fixed import ordering in `src/tools.py` (removed trailing blank line)
- Removed unused `textwrap` import from `src/agent.py`
- All files pass `ruff check` and `python -m py_compile` with no errors

### 3. Dependencies Verified
- livekit-agents 1.8.8
- livekit-plugins-google 1.8.8
- livekit-plugins-ai-coustics 0.3.4
- playwright 1.64.0
- Python 3.10-3.14 compatibility maintained

## Architecture

### Main Components
1. **Agent Entry Point** (`src/agent.py`):
   - `Nola` class extending `LiveKit Agent`
   - Uses `google.beta.realtime.RealtimeModel` (Gemini 2.0 Flash Live)
   - Voice: "Kore" (British female)

2. **Adaptive Personality** (`src/prompts.py`):
   - Warm (default), Sophisticated, Playful, Efficient modes
   - Natural persona-based greeting selection (randomized)
   - Behavior guided by conversation tone

3. **Browser Tools** (`src/tools.py` + `src/browser.py`):
   - 11 Playwright-based browser automation functions
   - Tools: `open_url`, `search_the_web`, `read_page`, `inspect_page`, `go_back`, `take_screenshot`, `click`, `type_text`, `scroll`, `press_key`, `confirm_browser_action`
   - Consequential action confirmation gate for risky operations

4. **Simulation Tests** (`scenarios.yaml`):
   - 3 tests covering greeting behavior, grounding (no invented facts), and safety/guardrails

## Key Files

| File | Purpose |
|------|---------|
| `src/agent.py` | Agent entry point, runs agent server |
| `src/prompts.py` | Nola's adaptive personality and system instructions |
| `src/tools.py` | 11 browser automation function tools |
| `src/browser.py` | Playwright Chromium browser manager (per-room isolation) |
| `src/nola.py` | Public exports interface |
| `scenarios.yaml` | LiveKit simulation test scenarios |
| `pyproject.toml` | Python dependencies (uv package manager) |
| `.env.example` | Environment template (LIVEKIT_URL, API keys, GOOGLE_API_KEY) |
| `Dockerfile` | Container runtime for the agent |

## Running the Agent

```bash
cd my-agent
uv sync
uv run playwright install chromium

# Development mode (requires credentials in .env.local)
uv run src/agent.py dev

# In a LiveKit Cloud room, Nola will greet and be ready for voice commands
```

## Dependencies
- Python >= 3.10
- livekit-agents ~= 1.8
- livekit-plugins-google ~= 1.8
- livekit-plugins-ai-coustics ~= 0.3
- playwright >= 1.40
- uv package manager
- pnpm (for frontend, TODO)
- Flutter SDK >= 3.5.1 (for mobile client, TODO)

## Known Limitations

### CPU Compatibility Issue (Pentium B950)
The project has a CPU instruction compatibility issue:
- **Root Cause**: `livekit-local-inference` extension requires AVX/AVX-512 instructions
- **Current CPU**: Intel Pentium B950 (SSE4.2 only)
- **Error**: `Illegal instruction` (46) → SIGILL when importing `livekit.agents`

**Workaround**: AI Coustics noise cancellation requires native inference; without local inference support, the agent runs without audio enhancement on incompatible hardware.

**Solutions for production**:
1. Run on a CPU with AVX/AVX-512 support (Intel Core generation 4+, AMD Ryzen, Apple Silicon)
2. Use a cloud runtime (LiveKit Cloud provides managed inference)
3. Build custom local-inference wheels with CPU flags detection

## Next Steps

### Immediate
- Test agent in a LiveKit Cloud room with compatible CPU or cloud deployment
- Verify all 11 browser tools work correctly in voice context
- Add scenarios for browser actions (search_the_web, click, type)

### Short Term (TODO from README)
1. **Frontend** (React/Next.js):
   - Add web UI for agent control and visualization
   - Show live audio/video streams from the room
   - Display Nola's current mode/vibe

2. **Mobile App** (Flutter):
   - Implement mobile client with Directions API integration
   - Add device audio/camera permissions handling
   - Push notifications for dropped calls

3. **Agent Enhancements**:
   - Wire up NolaBrowserTools to AgentSession
   - Add weather lookup tool
   - Implement task workflow/handoff patterns

## Environment Variables Required

| Variable | Purpose |
|----------|---------|
| `LIVEKIT_URL` | LiveKit Cloud WebSocket URL (e.g. `wss://project.livekit.cloud`) |
| `LIVEKIT_API_KEY` | LiveKit API key |
| `LIVEKIT_API_SECRET` | LiveKit API secret |
| `GOOGLE_API_KEY` | Google AI API key (for Gemini Realtime) |

Copy `.env.example` to `.env.local` and fill in your credentials.

## Citation

Built with [LiveKit Agents](https://docs.livekit.io/agents/) and [Google Gemini 2.0 Flash Live](https://ai.google.dev/gemini-api/docs/realtime-model).

---
**Project Status**: Codebase clean, ready for testing once CPU compatibility is resolved or agent runs in cloud environment.