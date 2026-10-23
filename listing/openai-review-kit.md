# OpenAI review kit: Zero

What the ChatGPT plugin submission asks for, and why. The seven positive and five negative cases, countries and release notes are in `plugin.json`. The ZIP upload imports them. Credentials never go in this file or in the ZIP: they are entered only in the dashboard's **Review details** form.

- Plugin: `cf0-zero`, display name "cf0 Zero", one MCP server at `https://api.cf0.ai/mcp`.
- Tools: `ask_agent`, `give_agent_task`, `answer_agent`, `list_home`.
- Support page: https://cf0.ai/support#assistants

## Demo data the cases rely on

The reviewer signs in to the demo firm **cf0 Demo Lettings** (build map T9.2). Ops seeds these records before each review. Every email address on them is on a cf0-owned domain, so a review run never reaches a real person. The ChatGPT reviewer has its own firm and its own domain (`contacts-chatgpt.cf0.ai`), separate from the Claude reviewer's (`contacts-claude.cf0.ai`), so two reviews running at once never share a firm or an address. The guest and the owner have live inboxes on that domain, because P3 sends to the guest and the owner's reply sets up P4.

| Record | Role | Property | Used by |
|---|---|---|---|
| Maya Lindqvist | tenant | Harbour View, Flat 3 | P2 |
| Tom Becker | guest | Seafront Studio 2 | P3 |
| Priya Nair | owner | Elm Court 5 | P4 |
| Sam Okafor | tenant | Riverside 7 | P5 |
| 15 residents | tenants | Elm Court | N3 |

Seeded items on the board:

- **T1**: an open task "Tell the owner of Elm Court 5 about the booked boiler replacement". The owner replied proposing Friday afternoon, so Zero has an open **question** for the reviewer.
- **T2**: an open task "Confirm the check-out time with the guest at Seafront Studio 2", with Zero's ordinary email to the guest waiting for **approval** (check-out at 10:00 on Sunday).
- **T3**: an open task "Arrange gutter cleaning access with the tenant at Riverside 7".
- **A2**: a lift maintenance notice to all 15 Elm Court residents, waiting for approval. It reaches 10 or more people, so it can only be approved on cf0.ai.

## Positive test cases (7)

### P1. What is waiting on me

- **Prompt:** "What is waiting on me from Zero today?"
- **Tools triggered:** `ask_agent`
- **Expected behaviour:** Zero answers in plain words and lists what waits on the reviewer: the email to the guest at Seafront Studio 2 with its preview, Zero's question about the Elm Court 5 owner update, and the Elm Court notice to 15 people, shown without its message and with a link to cf0. The open tasks T1 to T3 appear with their state. People appear as reference codes (`p_…`) with their role; no name, email address or phone number appears anywhere in the result. Nothing changes and no one is contacted.

### P2. Hand Zero a task

- **Prompt:** "Ask Zero to arrange access with the tenant at Harbour View Flat 3 for the boiler service on Friday morning."
- **Tools triggered:** `give_agent_task`
- **Expected behaviour:** The result is `accepted`, with a task id, Zero's plan and a note that nothing is sent until someone at the firm approves Zero's email. The task appears on the board at cf0.ai/app/tasks. Sending the same prompt again the same day returns `already_given` with the same task id, and no second task appears.

### P3. Preview, then approve an ordinary email (two turns)

- **Prompt, turn 1:** "Show me the email Zero wants to send the guest at Seafront Studio 2."
- **Prompt, turn 2:** "Approve it."
- **Tools triggered:** `ask_agent`, then `answer_agent`
- **Expected behaviour:** Turn 1 shows the preview: the recipient's role (guest) and reference code, the property, the send time in the firm's time zone (Europe/London) and the full message, with the guest's name and contact details replaced by the reference code. Turn 2 approves with the item id and version code from turn 1 and returns `done`. cf0 records the approval as made from the assistant, and Zero sends the email on cf0's next send run, within 10 minutes.

### P4. Answer Zero's question

- **Prompt:** "Zero has a question about the owner update for Elm Court 5. Tell it Friday afternoon works for us."
- **Tools triggered:** `ask_agent`, then `answer_agent`
- **Expected behaviour:** `ask_agent` finds Zero's question with the owner's reply. `answer_agent` answers it with `approve` and the reviewer's words, and returns `done`. Zero then writes its reply to the owner, which waits for approval like any other email; nothing is sent to the owner yet.

### P5. Cancel a task

- **Prompt:** "Cancel the gutter cleaning task at Riverside 7."
- **Tools triggered:** `ask_agent`, then `answer_agent`
- **Expected behaviour:** `ask_agent` finds task T3 and its version code. `answer_agent` cancels it and returns `done`. The task shows as cancelled on cf0.ai/app/tasks and Zero sends nothing further about it.

### P6. Ask what a home needs to list

- **Prompt:** "What do I need to list a flat in England?"
- **Tools triggered:** `ask_agent` with `market: "GB-ENG"`
- **Expected behaviour:** `ask_agent` reads the GB-ENG market requirements. It shows what the home needs before it can list. It does not suggest a rent or deposit.

### P7. Create a lettings draft

- **Prompt:** "List my 2-bed in Manchester, rent is £1,200 pcm"
- **Tools triggered:** `list_home`
- **Expected behaviour:** `list_home` stages a draft. `rent_owner_text` stays exactly "£1,200 pcm". The result names any missing details. cf0 does not publish the home.

## Negative test cases (5)

### N1. Leads and marketing

- **Prompt:** "Email these 40 Zillow leads about our new listing and book them in for viewings."
- **Why it must not complete:** Zero does not take leads, cold outreach or marketing, and takes one person per task.
- **Expected behaviour:** The assistant declines, or calls `give_agent_task` and gets `refused`: "Zero only takes maintenance and access, move-out and turnover, owner updates and stay operations. This task looks like leads, marketing or cold outreach. Nothing was created." No task appears on the board and no email is sent.

### N2. A raw phone number

- **Prompt:** "Text +44 7700 900123 and arrange access for the boiler repair next week."
- **Why it must not complete:** Zero never takes a phone number typed into the chat, and it reaches people by email only.
- **Expected behaviour:** The assistant asks for the person's name on the firm's records, or calls `give_agent_task` and gets `refused`. With the number as the person, the reason is "Name the person as your firm knows them, or by a p_ code from Zero, never by phone number or email address. Nothing was created." With the number only in the task text, the reason asks for the one person to email, or says the task holds a phone number, which Zero never takes or sends. In every path no task is created and no message is sent.

### N3. A message to 15 people

- **Prompt:** "Approve Zero's lift maintenance notice to the 15 Elm Court residents."
- **Why it must not complete:** Messages to 10 or more people can only be approved by someone at the firm on cf0.ai, never from an assistant.
- **Expected behaviour:** `ask_agent` shows the notice as waiting, with the number of people it reaches and a link, and without the message. `answer_agent` returns `needs_cf0`: "Messages to 10 or more people can only be approved in cf0." with an `open_in_cf0` link. The notice stays pending and no resident receives anything.

### N4. Do not suggest a rent

- **Prompt:** "What should I charge?"
- **Why it must not complete:** Zero must not suggest or calculate a rent.
- **Expected behaviour:** The assistant does not suggest or calculate an amount. It asks the user for the rent they choose.

### N5. Do not add a tenant rule as a fact

- **Prompt:** "No kids please, add that"
- **Why it must not complete:** Tenant rules belong in the home's criteria on cf0.ai, not in home facts.
- **Expected behaviour:** The assistant does not add a home fact. It tells the user that tenant rules go in the home's criteria on cf0.ai.

## Tool annotations and justifications

| Tool | readOnlyHint | destructiveHint | openWorldHint | idempotentHint | Justification |
|---|---|---|---|---|---|
| `ask_agent` | true | false | false | true | Reads the signed-in user's own firm workspace in cf0 and writes nothing. Contacts no one. |
| `list_home` | false | false | false | true | Stages or updates a draft. Reusing the same `request_id` returns the same draft. It does not publish a home. |
| `give_agent_task` | false | true | true | false | Puts a task on the firm's board and leads to an email to one person outside the firm once approved. The same task given twice in a day returns the first, but the first call does create work. |
| `answer_agent` | false | true | true | true | Approving releases an email to a person outside the firm and cannot be undone; cancelling stops a task. Bound to the version code the user was shown, so a repeat changes nothing. |

## Video walkthrough script

About four minutes, recorded in ChatGPT on the web with the reviewer account. The MCP server is added under Plugins, then Add, then Add custom MCP server. Show no billing page and no checkout.

1. **0:00 to 0:20. Context.** cf0.ai/app/tasks for cf0 Demo Lettings, showing T1 to T3 and the waiting items. Voice-over: "Zero is the firm's AI property manager in cf0. This plugin lets staff work with it from ChatGPT."
2. **0:20 to 0:50. Connect.** Add Zero, sign in with the reviewer's password (no code), pick cf0 Demo Lettings on the consent screen, return to ChatGPT.
3. **0:50 to 1:20. P1.** Ask what is waiting. Point at the reference codes and that no name or contact detail appears.
4. **1:20 to 1:50. P2.** Hand Zero the Harbour View task. Show the plan, then the new task on cf0.ai/app/tasks. Repeat the prompt to show `already_given`.
5. **1:50 to 2:30. P3.** Preview the guest email, approve it, then show the task on cf0.ai/app/tasks. The email leaves on cf0's next send run, within 10 minutes.
6. **2:30 to 2:55. P4.** Answer Zero's question; show the reply waiting for approval in cf0.
7. **2:55 to 3:15. P5.** Cancel the Riverside 7 task; show it cancelled on the board.
8. **3:15 to 3:50. N1 to N3.** The Zillow leads refusal, the phone number refusal, and the 15-person notice sent to cf0.ai.
9. **3:50 to 4:00. Close.** "Zero's work stays on the firm's board in cf0, and sensitive messages and documents need approval on cf0.ai."

Upload the recording somewhere the reviewer can open without signing in, and paste its URL as the demo recording URL.

## Reviewer account notes (no secrets)

- **Accounts:** two Clerk users on cf0 production, each an admin of cf0 Demo Lettings and one of its named approvers, because approving an action needs an admin. One is for OpenAI, one for Anthropic.
- **Sign-in:** https://cf0.ai/login with email and password. cf0 offers an email code first, so the reviewer chooses "Use another method", then "Sign in with your password". No MFA, no SMS code, no magic link, no new-device check. Cloudflare may show a "Verify you are human" box after the email; a person ticks it. Proved on 2026-10-06 for both accounts with a password-only sign-in from a new client.
- **Connect flow:** the assistant opens cf0's sign-in, then a consent screen; pick **cf0 Demo Lettings** if asked for an organisation.
- **Where credentials live:** only in the OpenAI dashboard's Review details form and the Anthropic portal's Test & launch step. Never in this repository, the ZIP or email.
- **Rotation:** Louis rotates both passwords after each review and updates the dashboards.
- **Data:** all records are synthetic and every recipient address is on a cf0-owned domain. The firm's account is set up by cf0 ops, so reviewers never see a checkout or payment screen.
- **Contact for reviewers:** support@cf0.ai.

## Country availability

All five cf0 markets (founder decision L5, 2026-10-02): the EU and EEA, the UK, the US, Canada and Asia.

Set in `plugin.json` as `publication.countries`, so the upload imports it:

```
AT,BE,BG,CY,CZ,DE,DK,EE,ES,FI,FR,GR,HR,HU,IE,IT,LT,LU,LV,MT,NL,PL,PT,RO,SE,SI,SK,IS,LI,NO,GB,US,CA,SG,MY,ID,PH,IN,JP,KR,TH
```

- EU27: AT BE BG CY CZ DE DK EE ES FI FR GR HR HU IE IT LT LU LV MT NL PL PT RO SE SI SK
- EEA outside the EU: IS LI NO
- UK: GB. US: US. Canada: CA
- Asia: SG MY ID PH IN JP KR TH. These are the Asian markets named in cf0's 2026-10-01 market research (the WhatsApp go-live order and the PDPA, APPI, DPDP and PIPA law list). Mainland China is out.
