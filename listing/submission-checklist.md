# Submission checklist: Zero

For Luca and Louis. Work top to bottom; each line names its owner. Founder decision L1: submit as soon as the build passes the review checks, and run the paid test while listed.

## 1. Before either submission

- [x] **Louis:** PR cf0-enterprise/cf0#326 merged and deployed, with the `v2-staff-agent` Durable Object migration and the rate-limit namespaces.
- [x] **Luca:** Clerk production: run `./c auth-config diff`, then `./c auth-config apply prod -y` to apply the OAuth application settings in `apps/api/auth-config.json` (client metadata documents on, `aud` claim on, dynamic registration off). Check the consent screen and the scopes `openid email profile user:org:read offline_access`. No JWT template change is needed (door decision, clause 5).
- [x] **Louis:** create the public repository `cf0-enterprise/cf0-zero`, then push this local repository's `main` to it. Check that no `.DS_Store` file is committed.
- [x] **Louis and Luca:** the demo firm cf0 Demo Lettings (build map T9.2): approved, account set up by ops so no checkout shows, Zero's mailbox ready, the records and seeded items in `openai-review-kit.md`, and the demo contacts domains (`contacts-chatgpt.cf0.ai`, `contacts-claude.cf0.ai`) verified in AgentMail with live inboxes for the guest and the owner.
- [x] **Louis:** two reviewer users (one for OpenAI, one for Anthropic), each an admin and named approver of the demo firm, password only. Prove each signs in from a fresh browser with no code.
- [ ] **Louis:** set the OpenAI domain challenge variable so `curl https://api.cf0.ai/.well-known/openai-apps-challenge` returns the dashboard's token exactly (T9.4).
- [ ] **Agent or Louis:** with `CF0_BILLING=stub` and the reach variables, run `./c demo-firm`, then `./c assistant-probe --suite review` and `--suite gates` (`--url http://localhost:<port>/mcp --stub-port <port>`). Both exit 0. Both write local D1, so they never run against production. Then do the manual production smoke in listing decision clause 7.
- [ ] **Luca:** counsel's written sign-off on the listing questions, the terms section 10 rewrite and the privacy update (T8.3). T9.6 depends on it in the build map; decide whether L1 waives it.
- [x] **Anyone:** in this repository, run `claude plugin validate .` (expect "Validation passed") and `scripts/check-no-price.sh` (expect 8 fixtures caught and 0 hits).
- [ ] **Luca:** pages live and identical in wording to the listing: https://cf0.ai/support#assistants, https://cf0.ai/privacy, https://cf0.ai/terms. No price on any of them during the price test (Q5). Check again for version 1.0.6: the comparison of the plugin and a cf0 contract, and adding a person from chat.
- [ ] **Louis:** push version 1.0.6 only after the api with the quick start and `new_person` is deployed. The skill teaches `new_person`, and the live tool refuses that field until then.

## 2. Video

- [ ] **Luca, agent records:** record the walkthrough from the script in `openai-review-kit.md` with the OpenAI reviewer account. No billing page or checkout on screen.
- [ ] **Luca:** upload it where a reviewer can open it without signing in, and keep the URL.

## 3. OpenAI (ChatGPT and Codex plugin directory)

- [ ] **Luca:** business verification for "cf0, Corp." complete in the OpenAI organization settings.
- [ ] **Luca:** the listing-only project `cf0-plugins` with global data residency (founder decision L2): no keys, no inference, no data.
- [x] The OpenAI listing names no pricing, contract or upsell, and the display name is "cf0 Zero", not the single word "Zero". OpenAI rejected 1.4.2 on 2026-10-23 because the name or description "did not meet our quality standards". `scripts/check-no-price.sh` checks every listing description.
- [ ] **Luca:** build the ZIP of version 1.4.7 from the repository root with only the package files:
  `zip -r cf0-zero.zip plugin.json mcp.json skills assets README.md LICENSE -x '*.DS_Store'`
- [ ] **Luca:** Plugins, Upload plugin, choose the ZIP. Resolve every required finding under Metadata & Skills and MCPs.
- [ ] **Luca:** check the imported listing: display name "cf0 Zero", subtitle, description, category (fall back to Productivity if the dashboard has nothing closer), three starter prompts, both icons, and that commerce is off.
- [ ] **Luca:** verify the domain with the challenge token (T9.4).
- [ ] **Luca:** set up OAuth with CIMD against `https://clerk.cf0.ai`.
- [ ] **Luca:** Review details: enter the 5 positive and 3 negative cases from `openai-review-kit.md`, the video URL, the annotation justifications, and the OpenAI reviewer's credentials and sign-in steps.
- [ ] **Luca:** country availability: paste the list from `openai-review-kit.md` (all five markets).
- [ ] **Luca:** Submit for review and complete the attestations.
- [ ] **Luca:** ask OpenAI support whether per-task charges for tasks started from ChatGPT count as "indirect selling", quoting the plugin id.

## 4. Anthropic (Claude connector and plugin directories)

- [ ] **Luca:** Claude Team organization with Luca as Owner and GitHub connected on claude.ai.
- [ ] **Luca:** confirm the Policy 4.B email to `mcp-review@anthropic.com` (sent 2026-10-02) is still unanswered or answered. Until it is answered, the Claude door stays text-only.
- [ ] **Luca:** submit the **MCP connector** with the fields, description, example prompts, test account notes and seven acknowledgements in `anthropic-kit.md`. Slug `cf0-zero`, which is permanent.
- [ ] **Luca:** submit the **Plugin bundle** from `cf0-enterprise/cf0-zero`: Validate, fix any Blocking finding, answer the data handling questions, select the four acknowledgements.
- [ ] **Louis:** set up the GitHub push webhook from the submitted page (needs repository admin).
- [ ] **Luca:** pair the plugin with the `cf0-zero` connector.

## 5. After submission

- [ ] **Luca:** record the submission dates, the plugin id and the connector slug in a diary note.
- [ ] **Louis:** rotate both reviewer passwords after each review and update the two dashboards.
- [ ] **Luca:** answer reviewer email; an OpenAI appeal is a reply to the rejection email.
- [ ] **Luca:** on publish day (T9.7), the public task figure takes effect the same day on cf0.ai, `/support#billing` and the terms, and stays out of the plugin and both listings.
