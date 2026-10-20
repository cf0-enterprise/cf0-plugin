# Anthropic kit: Zero

Two submissions in the developer portal at claude.ai/directory/manage, paired once both exist:

1. **MCP connector** for `https://api.cf0.ai/mcp`, slug `cf0-zero`.
2. **Plugin bundle** from the public GitHub repository `cf0-enterprise/cf0-zero` (this repository), plugin path empty (the plugin is at the root).

Credentials never go in this file. They are entered only in the portal's **Test & launch** step.

## Policy 4.B: Claude stays text-only

The Anthropic Software Directory Policy, section 4.B, excludes software that uses AI models to generate audio, and section 4 opens "Unless otherwise expressly permitted by us in writing". Zero's product includes AI voice calls on cf0's own phone lines, though nothing in this plugin generates audio.

On 2026-10-02 Luca emailed `mcp-review@anthropic.com` from luca@cf0.ai to ask whether that is permitted (founder decision L3). Until Anthropic answers in writing, the Claude door stays text-only: the four tools return text and structured data, and no tool starts, places or returns a call or any audio. Mention the open request in the submission notes so the reviewer has the context.

## Connector listing fields

| Field | Value |
|---|---|
| Server name (max 100) | Zero |
| One-liner (max 200) | Zero, the AI employee of cf0, lets and manages your firm's homes. Hand it follow-ups with tenants, guests and owners by email, approve each email before it goes out, and pay per completed task. |
| Categories | Productivity; Business (check the portal's list) |
| Documentation URL | https://cf0.ai/support#assistants |
| Privacy policy URL | https://cf0.ai/privacy |
| Support contact | support@cf0.ai |
| Icon | `assets/logo.png` (434 by 434 PNG) |
| Slug (permanent) | `cf0-zero` |
| Company | cf0, Corp., https://cf0.ai |
| Primary contact | Luca Tabone, luca@cf0.ai |

**Description (max 2,000):**

> Zero is the AI employee of cf0. It lets and manages homes for owners and for property management, lettings and short-term rental firms. This connector lets your team hand Zero its follow-ups from Claude, and Zero keeps the work on your firm's task board in cf0.
>
> Ask Zero what it is handling, what is waiting on you and where a task stands. Asking changes nothing and contacts no one.
>
> Hand Zero the follow-ups your team would otherwise chase by email: arranging access with a tenant for a repair, confirming a check-out time with a guest, or telling an owner about booked work. Each task is about one person on your firm's records. Zero plans it and drafts an email from your firm's own Zero mailbox. Someone at your firm previews and approves the email, in chat or on cf0.ai, and nothing is sent before that. Zero then sends it, reads the reply and closes the task once the person confirms. If they suggest a different time or ask something only your team can answer, Zero asks you first and drafts its reply for your approval.
>
> `give_agent_task` takes maintenance and access, move-out and turnover, owner updates and stay operations. That task tool does not take leasing, leads, cold outreach, marketing, tenant screening, rent or arrears, payments, legal notices or emergencies. People on your records appear as reference codes with their role, and their contact details and access codes stay hidden. Zero never takes a phone number, and it reaches people by email only. Zero adds someone new from chat only after you agree to their name, email, role and property. Messages to 10 or more people, documents and sensitive content can only be approved on cf0.ai.
>
> Setup takes minutes on cf0.ai: an admin sets up billing, cf0 gives Zero an email address for your firm, and your team adds the people Zero emails, on cf0.ai or from chat. Your firm pays per completed task, under a monthly cap it sets.
>
> With a cf0 contract, Zero also answers your firm's phone line, WhatsApp and inbox, and runs guest agents.

**Use cases:** checking what Zero is doing and what waits on you; preparing a lettings draft from details the user provides; handing Zero maintenance and access, move-out and turnover, owner update and stay operation tasks; adding a person to the firm's records after the user agrees; approving Zero's emails and ready homes; answering Zero's questions; cancelling tasks.

**What users need before they connect:** a cf0 account as a member of a firm on cf0. Before Zero takes tasks, an admin sets up billing on cf0.ai (a firm on a cf0 contract skips this step), cf0 gives Zero an email address for the firm, and the team adds the people Zero emails. The phone line, WhatsApp and inbox come only with a cf0 contract.

**Reads or writes:** both. `ask_agent` reads; `list_home`, `give_agent_task` and `answer_agent` write.

**Authentication:** OAuth with client ID metadata documents (CIMD). The authorization server is Clerk at `https://clerk.cf0.ai`, named in the protected-resource metadata at `https://api.cf0.ai/.well-known/oauth-protected-resource/mcp`. Scopes: `openid email profile user:org:read offline_access`.

**Data handling:** the API is cf0's own, first party. The connector does not handle personal health data and carries no sponsored content.

## Example prompts (Policy 3.E)

1. "What is waiting on me from Zero today?"
2. "Ask Zero to arrange access with the tenant at Harbour View Flat 3 for the boiler service on Friday morning."
3. "Show me the email Zero wants to send the guest at Seafront Studio 2." Then: "Approve it."
4. "Zero has a question about the owner update for Elm Court 5. Tell it Friday afternoon works for us."
5. "Cancel the gutter cleaning task at Riverside 7."
6. "What do I need to list a flat in England?"
7. "List my 2-bed in Manchester, rent is £1,200 pcm"
8. "What should I charge?"
9. "No kids please, add that"

The expected results for prompts 1 to 5 are in `openai-review-kit.md` (P1 to P5). The four lettings cases are below and in that file as P6, P7, N4 and N5. Three other requests Zero refuses are N1 to N3. Prompts 1 to 5 use the demo firm's seeded data. The lettings prompts use details from the user.

## Lettings review cases

### P6. Ask what a home needs to list

- **Prompt:** "What do I need to list a flat in England?"
- **Tools triggered:** `ask_agent` with `market: "GB-ENG"`.
- **Expected behaviour:** `ask_agent` reads the GB-ENG market requirements. It shows what the home needs before it can list. It does not suggest a rent or deposit.

### P7. Create a lettings draft

- **Prompt:** "List my 2-bed in Manchester, rent is £1,200 pcm"
- **Tools triggered:** `list_home`
- **Expected behaviour:** `list_home` stages a draft. `rent_owner_text` stays exactly "£1,200 pcm". The result names any missing details. cf0 does not publish the home.

### N4. Do not suggest a rent

- **Prompt:** "What should I charge?"
- **Tools triggered:** none.
- **Expected behaviour:** The assistant does not suggest or calculate an amount. It asks the user for the rent they choose.

### N5. Do not add a tenant rule as a fact

- **Prompt:** "No kids please, add that"
- **Tools triggered:** none.
- **Expected behaviour:** The assistant does not add a home fact. It tells the user that tenant rules go in the home's criteria on cf0.ai.

## Test account notes (Policy 3.D)

- **Firm:** cf0 Demo Lettings, a standard test account with synthetic sample data (the records and seeded items listed in `openai-review-kit.md`). The Claude reviewer has its own firm and its own cf0-owned domain (`contacts-claude.cf0.ai`), separate from the ChatGPT reviewer's, so no review run reaches a real person.
- **User:** a Clerk user on cf0 production who is an admin of cf0 Demo Lettings and one of its named approvers, because approving an action needs an admin.
- **Sign-in:** https://cf0.ai/login with email and password. No MFA, no email or SMS code, no magic link. Cloudflare may show a "Verify you are human" box after the email; a person ticks it.
- **Steps for the reviewer:** in Claude, open Customize, then Connectors, choose Add custom connector and paste `https://api.cf0.ai/mcp` (or add Zero from the directory once it is listed). Sign in with the test account, choose cf0 Demo Lettings on the consent screen if asked, then try the example prompts.
- **Where credentials live:** only in the Test & launch step. Louis rotates the password after each review.
- **Tools run before submitting:** confirm each of the four tools ran from a Claude conversation against the demo firm, as the Test & launch step asks.

## Connector compliance: the seven acknowledgements

| Acknowledgement | How Zero meets it |
|---|---|
| Directory guidelines | Follows the Software Directory Terms and Policy; every tool has a title and `readOnlyHint` and `destructiveHint`; read and write tools are separate; tool names are under 64 characters. |
| First-party API usage | The server calls only cf0's own API and data. It is not a pass-through to a property management system or any third-party service. |
| Financial transactions | Zero moves no money and executes no financial transactions. It refuses rent, arrears and payment tasks. No price or checkout appears in any tool. |
| AI media generation | No tool generates images, video or audio. The Claude door stays text-only until Anthropic answers the Policy 4.B request sent on 2026-10-02. |
| Prompt injection | Tool descriptions never tell Claude to call other tools or fetch instructions from elsewhere. Text quoted from tenants, guests or owners is returned as information, and the server's instructions say to treat it as data. |
| Conversation data collection | Tools take only the user's question or task, the details of a person the user adds, and the ids and codes Zero returned. They never ask for chat history, memory, summaries or uploaded files. |
| Public documentation | Setup and usage are at https://cf0.ai/support#assistants; privacy at https://cf0.ai/privacy; terms at https://cf0.ai/terms. |

## Plugin bundle steps

- **Source:** repository `cf0-enterprise/cf0-zero`, plugin path empty, branch `main`.
- **Validate:** run `claude plugin validate .` and `scripts/check-no-price.sh` locally first, then the portal's Validate. Fix anything marked Blocking.
- **Data handling answers:**
  - Reads or stores personal data: yes. Zero reads the firm's records in cf0 and returns people as reference codes with their role. Tasks the user gives are stored on the firm's board in cf0.
  - Sends data to services other than its declared connector: no. The only connection is `https://api.cf0.ai/mcp`.
  - Retention: as the cf0 privacy policy states for the firm's workspace.
  - Intended for people under 18: no. It is for staff of property management firms.
- **Compliance:** confirm the contact email (luca@cf0.ai) and select all four acknowledgements.
- **Updates:** keep GitHub push webhook; Louis, as repository admin, sets it up from the submitted page.
- **Pairing:** once both listings exist, pair the plugin with the `cf0-zero` connector in the portal.

## Ready-home decision case

Use a home whose six criteria pass in the target environment.
Ask Zero to show the home, then approve it with its current id and version.
The named admin approver receives `done`, and the home shows as listed.
Repeat the same answer. It returns `already_answered` and adds no second decision.
A member receives `not_allowed`.
An old version receives `changed_since_shown`.
A decline leaves the home in draft and records the actor and version.
These cases require the matching backend release. This package update does not deploy that release.
