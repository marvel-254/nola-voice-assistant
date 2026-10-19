"""Nola — British female voice AI assistant built on LiveKit Agents."""
from __future__ import annotations

import logging

from livekit.agents import (
    Agent,
    AgentServer,
    AgentSession,
    JobContext,
    TurnHandlingOptions,
    cli,
    inference,
    room_io,
)
from livekit.plugins import ai_coustics, google

from prompts import AGENT_INSTRUCTIONS
from tools import NolaBrowserTools

logger = logging.getLogger("agent")


class Nola(Agent):
    """British female voice AI butler powered by Gemini and a Playwright browser."""

    def __init__(self, browser) -> None:  # type: ignore[assignment]
        self._browser = browser
        super().__init__(
            # A Large Language Model (LLM) is your agent's brain, processing user
            # input and generating a response. See all available models at:
            # https://docs.livekit.io/agents/models/llm/
            llm=google.beta.realtime.RealtimeModel(
                model="gemini-2.0-flash-live",
                voice="Kore",
            ),
            instructions=AGENT_INSTRUCTIONS,
        )

    @property
    def tools(self):  # type: ignore[no-untyped-def]
        return NolaBrowserTools(self._browser).tools


server = AgentServer()


@server.rtc_session(agent_name="my-agent")
async def nola_session(ctx: JobContext):
    from browser import BrowserManager

    ctx.log_context_fields = {"room": ctx.room.name}
    browser = BrowserManager(headless=False)
    await browser.start()
    try:
        session = AgentSession(
            turn_handling=TurnHandlingOptions(
                turn_detection=inference.TurnDetector(),
                interruption={"mode": "adaptive"},
                preemptive_generation={"enabled": True},
            ),
        )
        await session.start(
            agent=Nola(browser),
            room=ctx.room,
            room_options=room_io.RoomOptions(
                video_input=True,
                audio_input=room_io.AudioInputOptions(
                    noise_cancellation=ai_coustics.audio_enhancement(
                        model=ai_coustics.EnhancerModel.QUAIL_VF_S,
                    ),
                ),
            ),
        )
        await ctx.connect()
    finally:
        await browser.close()


if __name__ == "__main__":
    cli.run_app(server)
