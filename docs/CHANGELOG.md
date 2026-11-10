# Changelog: what testing found and what changed

Version 1 was my original case-study submission. A review of my own workflow and a 6-ticket test found the problems below; version 2 and 2.1 fix them.

| # | Problem in v1 | Fix in v2 |
|---|---|---|
| 1 | Low-confidence tickets still went through urgency routing and sent emails | Status is set once (`opened` / `needs_manual_review` / `validation_error`); emails only for `opened` |
| 2 | `If1` ran `JSON.parse` on the raw model output before fences were stripped -> crash | One node cleans, parses and validates (fields, allowed values, confidence 0-1) before any decision |
| 3 | Qdrant top-3 produced 3 items -> up to 3 drafts, duplicate emails; draft used only chunk 1 | Chunks combined into one item; the draft prompt gets all 3 chunks; everything after runs once |
| 4 | Invalid tickets were silently dropped; no email-format check | Validation node checks required fields + email format; invalid tickets return `status: rejected` + reason |
| 5 | Urgent email read the draft from a node that does not run on the fallback path | Single join point `Final ticket`; emails and the sheet read the same fields |
| - | Fallback called the LLM to print a fixed sentence | Fallback is a Set node (no LLM cost) |
| - | Retrieval used only the message | Retrieval uses subject + message |
| - | Validation errors went through RAG | Validation errors skip RAG and are logged as `validation_error` |
| - | Logging happened in different places | One sheet row per ticket, always last |

## v2.1 (10.11.2026, after the first test run)

| Finding in testing | Fix |
|---|---|
| Low-urgency tickets ended without logging, so the webhook returned 500 (wiring error in v2) | 'Medium and confident?' false branch now goes to the log; true branch only to the summary email |
| A vague ticket ("it doesn't work") got confidence 0.85 and urgency high | Prompt: unclear messages must get confidence 0.4 or lower; code rule: messages under 5 words go to manual review |
| Classification could vary between runs | Classifier temperature 0 |
| Drafts ended with "[Your Name]" | Drafts are signed "NOAVIA Support Team" |
