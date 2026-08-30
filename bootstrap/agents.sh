#!/usr/bin/env bash
#
# Reproducible install of the CLI agent stack: pi, herdr, lavish, firstmate,
# and the mattpocock skill set, wired into Claude Code / Codex / Pi.
#
# Idempotent: safe to re-run. It pins every version, so a fresh machine gets
# exactly this stack. To pull upstream updates instead, see bootstrap/AGENTS-STACK.md.
#
#   ./bootstrap/agents.sh          install everything
#   ./bootstrap/agents.sh node     just one phase (node|npm|skills|lavish|herdr|firstmate)
#
set -euo pipefail

# --- pins -------------------------------------------------------------------
NODE_VERSION="v24.14.1"          # lts/krypton; also what ~/.nvmrc resolves to
PI_VERSION="0.84.4"
LAVISH_VERSION="0.1.63"
SKILLS_VERSION="1.5.23"
HERDR_VERSION="0.8.2"
HERDR_SHA256="976150a14d490c94b243ea2e1a7eb2dfb67f12e36b182db90936f6728e6aecf4"
FIRSTMATE_SHA="d71f4b9cf1e6a8c647867d9a92c67ab0a6bb460f"
FIRSTMATE_DIR="${FIRSTMATE_DIR:-$HOME/repos/mine/firstmate}"

AGENTS=(claude-code codex pi)    # skills CLI names
HERDR_AGENTS=(claude codex pi)   # herdr integration names

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m warn\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31merror\033[0m %s\n' "$*" >&2; exit 1; }

# --- node -------------------------------------------------------------------
# The whole stack is npm-installed, so node must be a real binary on PATH --
# not a shell function. .zshenv puts $NVM_DIR/current/bin first; this creates
# that symlink. Repoint it to change the version every agent CLI and MCP
# server sees, without touching PATH.
phase_node() {
  [ -s "$NVM_DIR/nvm.sh" ] || die "nvm not found at $NVM_DIR. Install it first: https://github.com/nvm-sh/nvm"

  if [ ! -d "$NVM_DIR/versions/node/$NODE_VERSION" ]; then
    log "installing node $NODE_VERSION"
    # shellcheck disable=SC1091
    . "$NVM_DIR/nvm.sh" --no-use
    nvm install "$NODE_VERSION"
    nvm alias default "$NODE_VERSION"
  else
    log "node $NODE_VERSION already installed"
  fi

  ln -sfn "$NVM_DIR/versions/node/$NODE_VERSION" "$NVM_DIR/current"
  export PATH="$NVM_DIR/current/bin:$PATH"
  log "node $(node --version), npm $(npm --version)"
}

need_node() {
  [ -x "$NVM_DIR/current/bin/node" ] || die "run the 'node' phase first"
  export PATH="$NVM_DIR/current/bin:$PATH"
}

# --- npm globals: pi + lavish ----------------------------------------------
phase_npm() {
  need_node
  # --ignore-scripts is upstream's documented flag for pi.
  log "installing pi $PI_VERSION"
  npm install -g --ignore-scripts "@earendil-works/pi-coding-agent@$PI_VERSION"
  log "installing lavish $LAVISH_VERSION"
  npm install -g "lavish-axi@$LAVISH_VERSION"
  log "pi $(pi --version), lavish-axi $(lavish-axi --version)"
}

# --- mattpocock skills ------------------------------------------------------
# Installs to ~/.agents/skills (the universal location Codex reads directly)
# and symlinks into ~/.claude/skills and ~/.pi/agent/skills.
phase_skills() {
  need_node
  local args=(add mattpocock/skills -g -s '*' -y)
  for a in "${AGENTS[@]}"; do args+=(-a "$a"); done
  log "installing mattpocock/skills -> ${AGENTS[*]}"
  npx --yes "skills@$SKILLS_VERSION" "${args[@]}"
}

# --- lavish hooks -----------------------------------------------------------
phase_lavish() {
  need_node
  log "installing lavish SessionStart hooks (Claude Code, Codex, OpenCode, Copilot)"
  lavish-axi setup hooks
}

# --- herdr ------------------------------------------------------------------
# Installed from the official GitHub release and checksum-verified, rather
# than via `curl | sh`, so the bytes are auditable and pinned.
phase_herdr() {
  local os arch target url tmp actual
  os="$(uname -s)"; arch="$(uname -m)"
  case "$os/$arch" in
    Linux/x86_64)   target="linux-x86_64"  ;;
    Linux/aarch64)  target="linux-aarch64" ;;
    Darwin/x86_64)  target="macos-x86_64"  ;;
    Darwin/arm64)   target="macos-aarch64" ;;
    *) die "unsupported platform $os/$arch" ;;
  esac

  if command -v herdr >/dev/null 2>&1 && [ "$(herdr --version 2>/dev/null | awk '{print $2}')" = "$HERDR_VERSION" ]; then
    log "herdr $HERDR_VERSION already installed"
  else
    url="https://github.com/herdrdev/herdr/releases/download/v${HERDR_VERSION}/herdr-${target}"
    tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' RETURN
    log "downloading herdr $HERDR_VERSION ($target)"
    curl -fL --retry 3 --max-time 300 "$url" -o "$tmp/herdr"

    actual="$(sha256sum "$tmp/herdr" | cut -d' ' -f1)"
    if [ "$target" = "linux-x86_64" ] && [ "$actual" != "$HERDR_SHA256" ]; then
      die "herdr checksum mismatch: expected $HERDR_SHA256, got $actual"
    fi
    [ "$target" = "linux-x86_64" ] || warn "no pinned checksum for $target; verify against https://herdr.dev/latest.json"

    mkdir -p "$HOME/.local/bin"
    install -m 755 "$tmp/herdr" "$HOME/.local/bin/herdr"
    log "installed $(herdr --version 2>/dev/null || echo herdr)"
  fi

  for a in "${HERDR_AGENTS[@]}"; do
    log "herdr integration: $a"
    "$HOME/.local/bin/herdr" integration install "$a"
  done
}

# --- firstmate --------------------------------------------------------------
# A repo you launch an agent inside of, not a package. Pinned to a SHA so a
# rebuild matches; `git pull` in that dir (or /updatefirstmate) moves it forward.
phase_firstmate() {
  if [ -d "$FIRSTMATE_DIR/.git" ]; then
    log "firstmate already cloned at $FIRSTMATE_DIR"
  else
    log "cloning firstmate -> $FIRSTMATE_DIR"
    mkdir -p "$(dirname "$FIRSTMATE_DIR")"
    git clone https://github.com/kunchenguid/firstmate "$FIRSTMATE_DIR"
  fi
  git -C "$FIRSTMATE_DIR" fetch --depth 1 origin "$FIRSTMATE_SHA" 2>/dev/null \
    && git -C "$FIRSTMATE_DIR" checkout --quiet "$FIRSTMATE_SHA" \
    || warn "could not pin firstmate to $FIRSTMATE_SHA; leaving as-is"
  log "firstmate at $(git -C "$FIRSTMATE_DIR" rev-parse --short HEAD)"
}

# --- driver -----------------------------------------------------------------
main() {
  local phases=("$@")
  [ ${#phases[@]} -eq 0 ] && phases=(node npm skills lavish herdr firstmate)
  for p in "${phases[@]}"; do
    case "$p" in
      node|npm|skills|lavish|herdr|firstmate) "phase_$p" ;;
      *) die "unknown phase: $p (node|npm|skills|lavish|herdr|firstmate)" ;;
    esac
  done
  log "done. Restart your shell, then authenticate pi with: pi  ->  /login"
}

main "$@"
