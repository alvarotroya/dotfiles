# Agent stack

Five tools layered on top of Claude Code / Codex / Pi, installed and pinned by
[`agents.sh`](./agents.sh). Run that script on a new machine and you get this
exact stack; the update commands below move individual pieces forward.

## Layout

| Path | What lives there |
|---|---|
| `$NVM_DIR/current` | Symlink to the active node. **This is the load-bearing bit** — `.zshenv` puts `$NVM_DIR/current/bin` on PATH so `node`/`npm`/`npx` are real binaries, not shell functions. MCP servers and agent CLIs spawn without a login shell and need this. |
| `~/.agents/skills/` | The 37 mattpocock skills. Source of truth. Codex reads this path natively. |
| `~/.claude/skills/`, `~/.pi/agent/skills/` | Symlinks into the above. |
| `~/.agents/.skill-lock.json` | Skill pins. A copy lives at `bootstrap/agents-skill-lock.json`. |
| `~/.pi/agent/` | Pi settings, auth, extensions. |
| `~/.lavish-axi/` | Lavish session state + `server.log`. |
| `~/repos/mine/firstmate/` | The firstmate distro (a repo, not a package). |

Changing node version: repoint the symlink, don't edit PATH.

```sh
nvm install v26.x.x && ln -sfn "$NVM_DIR/versions/node/v26.x.x" "$NVM_DIR/current"
```

---

## Pi — a second harness

A deliberately minimal coding agent: read, write, edit, bash, and a system
prompt of a few hundred tokens. Useful as a control against Claude Code — when
something works in Pi but not Claude Code, the harness is the variable.

```sh
pi                      # start in the current project
pi -p "one-shot prompt" # non-interactive
pi -c                   # continue last session
pi --list-models
```

**First run — authenticate.** Two logins, since it can drive both subscriptions:

```
/login   ->  Claude Pro/Max
/login   ->  ChatGPT Plus/Pro (Codex)
```

Then `/model`, pick one, **Ctrl+S** to save it as the startup default (this writes
`defaultModel` into `~/.pi/agent/settings.json`). Same trick with `/thinking`.

> **Cost note:** Anthropic bills third-party harness usage from your
> [extra usage](https://claude.ai/settings/usage) balance, per token — it does
> *not* draw on Claude plan limits. Pi on your Claude subscription costs real
> money in a way Claude Code does not.

Global instructions go in `~/.pi/agent/AGENTS.md`. Update with `pi update`.

## Herdr — terminal multiplexer for agents

tmux-shaped, but it recognizes coding agents in panes and exposes state over a
socket API, so agents can drive their own panes.

```sh
herdr                            # launch/attach the persistent session
herdr status
herdr integration status         # claude/codex/pi hooks, all installed
herdr update
```

The integrations are state-reporting hooks: each agent tells Herdr whether it's
idle, working, or blocked, which is what makes the mission-control view useful.

To let an agent *control* Herdr, run `herdr --skill` and give it that skill. It's
gated on `HERDR_ENV=1` and deliberately narrow — it won't fire just because a
task looks parallelizable.

## Lavish — visual review surface for HTML artifacts

Turns an HTML file into a local review page where you annotate elements, edit
Mermaid diagrams as Excalidraw whiteboards, and queue feedback that flows back
to the agent.

```sh
lavish-axi <file.html>          # open/resume a session
lavish-axi poll <file.html>     # long-poll for your feedback (agent runs this)
lavish-axi export <file.html>   # single portable HTML, assets inlined
lavish-axi end <file.html>
lavish-axi stop                 # shut down the background server
lavish-axi update
```

A `SessionStart` hook is installed for Claude Code and Codex, so agents learn
about it automatically. Artifacts default to `.lavish/` in the working directory.

`lavish-axi share` publishes to **ht-ml.app**, a third-party host, and is
**public by default** — use `--private` for a password-gated page.

## mattpocock/skills — 37 engineering skills

Installed globally for Claude Code, Codex, and Pi. Two kinds:

- **15 auto-invocable** — the agent triggers them on its own: `tdd`,
  `diagnosing-bugs`, `code-review`, `codebase-design`, `domain-modeling`,
  `research`, `prototype`, `resolving-merge-conflicts`, `grilling`,
  `writing-for-agents`, `setup-pre-commit`, `git-guardrails-claude-code`,
  `wizard`, `scaffold-exercises`, `migrate-to-shoehorn`.
- **22 explicit-only** (`disable-model-invocation: true`) — you name them:
  `ask-matt`, `wayfinder`, `to-spec`, `to-tickets`, `implement`, `triage`,
  `handoff`, `retro`, `teach`, `grill-me`, `improve-codebase-architecture`, …

Start with **`ask-matt`** — it's a router that tells you which skill fits.

Per-repo setup: run **`setup-matt-pocock-skills`** once in a project to configure
its issue tracker, triage labels, and domain doc layout. The planning skills
(`to-spec`, `to-tickets`, `wayfinder`, `triage`) depend on it.

```sh
npx skills update      # pull upstream
npx skills list
```

## Firstmate — an agent distro

Not a package. The cloned repo *is* the distro: `AGENTS.md`, skills, and helper
scripts that turn whatever harness you launch inside it into a "first mate" that
spawns and supervises a crew of agents in isolated git worktrees.

```sh
cd ~/repos/mine/firstmate
claude                 # or: pi   /   codex
```

Then talk to it in plain language: *"look at my project X, fix the flaky login
test and add dark mode."* It clones, spawns crewmates in tmux windows (or Herdr
tabs), supervises, and hands back PRs.

Requires `gh auth login` (already done). Project modes: `no-mistakes`,
`direct-PR`, `local-only`. Update from inside with **`/updatefirstmate`**.

> It is read-only over your projects except for narrow approved operations —
> crewmates make changes behind the configured merge authority. Still, point it
> at a scratch repo until you trust it.

---

## Updating everything

```sh
pi update                                  # pi
herdr update                               # herdr
lavish-axi update                          # lavish
npx skills update                          # mattpocock skills
cd ~/repos/mine/firstmate && git pull      # firstmate (or /updatefirstmate)
```

After updating, bump the matching pin in `agents.sh` so a rebuild reproduces what
you're actually running. For herdr also update `HERDR_SHA256` — the current value
is published at <https://herdr.dev/latest.json>.
