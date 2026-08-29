# Z.ai Agent Usage for Omarchy

A shell plugin that connects the Z.ai GLM Coding Plan to Omarchy's built-in
AI usage panel (`omarchy.agents`). It ships no UI: the agents panel discovers
any `*.json` record in `~/.local/state/omarchy/agents/usage/`, and this plugin
writes the Z.ai record there.

## Install

```bash
omarchy plugin add https://github.com/FelipeMayerDev/omarchy-zai-usage --enable
```

Or by hand:

```bash
git clone https://github.com/FelipeMayerDev/omarchy-zai-usage ~/.config/omarchy/plugins/zai.agent-usage
omarchy-shell shell rescanPlugins
omarchy plugin enable zai.agent-usage
```

The Z.ai tab appears in the agents panel once the first record lands (within
a minute of the shell starting).

## What it collects

- **Coding Plan limits** from Z.ai's monitor endpoint: the rolling 5-hour
  session window and the 7-day weekly window, plus the plan tier.
- **Local token stats** from pi and omp sessions that ran on a `zai`/`zhipu`
  provider (the `glm-*` models): today, the last 7 days, and all-time totals.

A key without a Coding Plan reports "No GLM Coding Plan on this key" and the
tab still shows local stats, the same way the Claude panel behaves without a
signed-in CLI.

## Credentials

The collector looks for an API key in this order:

1. `apiKey` (and optional `platform`) in `~/.config/omarchy/agents/zai.json`:

   ```json
   { "apiKey": "...", "platform": "zai" }
   ```

2. `ZAI_API_KEY` in the environment (global platform), or
   `ZHIPU_API_KEY` / `ZHIPUAI_API_KEY` (China platform, `open.bigmodel.cn`)
3. The same variables in `~/.omp/agent/.env` or `~/.pi/agent/.env`

## Details

- The record refreshes every 15 minutes and once at shell startup.
- The record file is swapped in atomically, so the panel never reads a
  half-written record.
- The panel's brand mark for a tab resolves inside the built-in agents
  plugin (`assets/<id>.svg`), which a third-party plugin can't extend. Until
  that convention opens up, the tab shows the standard bar glyph; the two
  marks in `assets/` are here for when it does.
- Disable or remove with `omarchy plugin disable zai.agent-usage` /
  `omarchy plugin remove zai.agent-usage`. Removing the plugin leaves the
  last `zai.json` behind; delete `~/.local/state/omarchy/agents/usage/zai.json`
  if you want the tab gone immediately.

## Dependencies

- `python3` (stdlib only — the collector uses no pip packages)
- `jq` (ships with Omarchy's default package set; used by `refresh.sh` to
  sanity-check the record before it lands)
- A Z.ai or Zhipu API key for Coding Plan limits; local token stats work
  without one

## License

MIT — see [LICENSE](LICENSE). The Z.ai mark in `assets/` is Z.AI's brand,
used to identify the service this plugin connects to.
