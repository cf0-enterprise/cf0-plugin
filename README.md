# cf0 Zero

cf0 Zero connects Claude, ChatGPT or Codex to your account on [cf0](https://cf0.ai), an AI real estate agency that lists homes to let and manages them. Owners save home drafts from chat. Firms hand Zero, cf0's AI agent, their follow-ups with tenants, guests and owners.

## Install

- **Claude Code:** Run `/plugin marketplace add cf0-enterprise/cf0-zero`. Then run `/plugin install cf0-zero@cf0`.
- **Claude app:** Select Customize > Connectors, then + > Add custom connector. Name it `cf0`, enter `https://api.cf0.ai/mcp`, press Continue, then Add. To add the skill, turn on Settings > Capabilities > Code execution. Then select Customize > Skills, then + > Upload a skill, and choose the [list-my-home skill](https://cf0.ai/skills/list-my-home.zip).
- **ChatGPT:** cf0 Zero is not in the ChatGPT plugin directory yet. Open Plugins, press Add, then Add custom MCP server. Name it `cf0`, enter `https://api.cf0.ai/mcp`, keep OAuth, tick the box and press Create as a plugin. Then press Connect cf0 and sign in to cf0. ChatGPT skills work only in Business and Enterprise workspaces. To list a home in any other workspace, paste the prompt from [cf0.ai/list/assistant](https://cf0.ai/list/assistant).

## How it works

You hand Zero the follow-ups your team would otherwise chase by email, such as arranging access with a tenant for a repair, confirming a check-out time with a guest, or telling an owner about booked work. Each task is about one person on your firm's records. To add someone new, Zero first shows you their name, email, role and property, and adds them only after you agree. Zero plans the task and drafts an email from your firm's own Zero mailbox. Someone at your firm previews and approves the email, in chat or on cf0.ai, and nothing is sent before that. Zero then sends it, reads the reply and closes the task once the person confirms. If they suggest a different time or ask something only your team can answer, Zero asks you first and drafts its reply for your approval.

Every task stays on your firm's board in cf0, with a record of what Zero sent and when.

## What it does

- **Ask Zero** (`ask_agent`, read-only): what Zero is handling, what is waiting on you, and where a task stands. It also reads your homes and their listing requirements. It changes nothing and contacts no one.
- **Save a home draft** (`save_home_draft`): write a draft home from the details the user gives. It never publishes the home.
- **Give Zero a task** (`give_agent_task`): hand Zero one task about one person on your firm's records, or about someone new that you agree to add, such as arranging access with a tenant for a repair visit, confirming a check-out time with a guest or telling an owner about booked work. Zero drafts one email from your firm's own Zero mailbox and sends it only after someone at your firm approves it.
- **Answer Zero** (`answer_agent`): approve or decline an ordinary email after a preview, answer a question Zero asked about your task, cancel a task, or approve or decline a home as the named admin approver after the listing checks pass.

People on your firm's records appear as reference codes such as `p_k7mq2xrb4a` with their role, and contact details and access codes are hidden. A name that is not on your firm's records, such as one typed into the chat, is passed back as written. `give_agent_task` never takes leasing, leads, cold outreach, marketing, tenant screening, rent or arrears, payments, legal notices or emergencies. Messages to 10 or more people, documents and sensitive content can only be approved on cf0.ai.

## What is in this package

| Path | Purpose |
|---|---|
| `plugin.json`, `mcp.json` | Agent Plugins manifest and MCP server for ChatGPT and Codex |
| `.claude-plugin/plugin.json`, `.mcp.json` | Plugin manifest and MCP server for Claude |
| `skills/zero-property-manager/SKILL.md` | How your assistant works with Zero, using the four tools |
| `skills/list-my-home/SKILL.md` | Walks the owner through a cf0 account, the home facts with the rent and the deposit, the photos and an optional Polycam 3D scan. Then it names the steps on cf0.ai before the home goes live: the ownership proof, the lettings terms and the approval. |
| `assets/` | Zero logos and composer icons, light and dark |
| `listing/` | Directory submission material; not loaded by the plugin |
| `scripts/` | Repository checks; not loaded by the plugin |
| `AGENTS.md` | Instructions for AI coding agents that change this repository |

Listing checks exclude review cases. These cases can contain rent that the owner provides.

The plugin runs no local code, hooks or commands. Its one connection is the remote MCP server at `https://api.cf0.ai/mcp`, operated by cf0. When you connect, your assistant asks you to sign in with your cf0 account through OAuth. Each request then carries your question or task, and Zero answers from your firm's workspace in cf0. Nothing is sent anywhere else.

## The plugin and a cf0 contract

| | Plugin | cf0 contract |
|---|---|---|
| What Zero does | Works the follow-ups your staff hand it: access for repairs, check-out times, owner updates, move-out and turnover | Answers your tenants, guests and owners, runs guest agents and works its follow-ups |
| Who starts the work | Your staff, from chat or cf0.ai. They approve each email | Anyone who calls, messages or emails your firm, and your staff |
| Channels | Email only, from your firm's own Zero address | Your phone line, WhatsApp and inbox |
| Setup | On cf0.ai, in minutes | cf0 onboards your firm with you |
| How your firm pays | Only for tasks the person confirms, under a monthly cap it sets. Card on file, billed monthly | Under your cf0 contract |

To talk to cf0 about a contract, book a demo at [cf0.ai](https://cf0.ai).

## Before you connect

You need a cf0 account as a member of a firm on cf0. Before Zero takes tasks, an admin sets up billing on cf0.ai (a firm on a cf0 contract skips this step), cf0 gives Zero an email address for your firm, and your team adds the people Zero emails, on cf0.ai or from chat. Until then, task requests list the missing setup steps. Reading homes and preparing a home draft do not need task setup.

Setup steps for each assistant are at [cf0.ai/support](https://cf0.ai/support#assistants).

## Optional 3D floor plan

`give_agent_task` accepts optional `floor_plan` for the home in `property`. Send `filename`, `mime`, and one of `file_url` (public HTTPS) or `file_base64`. The file must not exceed 20 MB. DXF, PDF and images (JPEG, PNG or WebP) are accepted. DWG is not supported yet.

Only a firm admin can start the run. The owner must have the right to use the drawing. The result has an `open_in_cf0` link. The owner reviews and publishes the plan in cf0. The assistant does not publish it. This optional step does not stop the home from listing. See `skills/zero-property-manager/SKILL.md` for the field details.

## Privacy and terms

- Privacy policy: [cf0.ai/privacy](https://cf0.ai/privacy)
- Terms: [cf0.ai/terms](https://cf0.ai/terms)
- Support: [support@cf0.ai](mailto:support@cf0.ai)

## License

MIT. See [LICENSE](LICENSE).
