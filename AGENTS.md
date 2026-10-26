# AGENTS.md: cf0 Zero plugin

This repository is the cf0 Zero plugin for Claude, ChatGPT and Codex. It has no runtime code. It connects an assistant to the remote cf0 MCP server at `https://api.cf0.ai/mcp`. cf0 operates that server. Its source is not in this repository.

## What is here

| Path | What it is |
| --- | --- |
| `plugin.json`, `mcp.json` | Agent Plugins manifest (https://agent-plugins.org) and the MCP server for ChatGPT and Codex |
| `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `.mcp.json` | Claude Code plugin, marketplace and MCP server |
| `skills/list-my-home/SKILL.md` | Skill: an owner lists a home to let on cf0 |
| `skills/zero-property-manager/SKILL.md` | Skill: a firm gives Zero follow-up tasks |
| `listing/` | Directory submission material. The plugin does not load it |
| `scripts/check-no-price.sh` | The listing text check |

## Rules for coding agents

1. Do not add local code, hooks or commands to the plugin. The MCP server is the only connection.
2. Keep the version the same in `plugin.json`, `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`. Increase it in all three files for each change to a manifest or a skill.
3. Run `scripts/check-no-price.sh` before each commit. The listing text names no price, trial or discount.
4. A skill never tells the assistant to suggest a rent or a deposit. The owner types these values.
5. A tool name or a tool behavior comes from the cf0 MCP server. Do not describe a tool that the server does not have. The current tools are `ask_agent`, `save_home_draft`, `import_listings`, `answer_agent` and `give_agent_task`.
6. Write in plain English: short sentences, one name for one thing, no marketing adjectives.

## Test a change

- Claude Code: run `/plugin marketplace add ./` in this folder, then `/plugin install cf0-zero@cf0`.
- MCP: connect to `https://api.cf0.ai/mcp` and sign in with a cf0 account. The steps are in https://cf0.ai/auth.md.

## More

- Developer resources: https://cf0.ai/developers
- When an agent uses cf0: https://cf0.ai/agents.md
- Contact: luca@cf0.ai
