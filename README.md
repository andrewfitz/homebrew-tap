# andrewfitz/tap

Homebrew formulae and casks for my macOS apps.

```bash
brew tap andrewfitz/tap
brew install backstage          # or: brew install andrewfitz/tap/backstage
brew install --cask redlight    # or: brew install --cask andrewfitz/tap/redlight
```

| Name | Kind | What it is |
|---|---|---|
| [backstage](https://github.com/andrewfitz/backstage) | formula | Lets coding agents launch, screenshot, inspect and operate macOS apps on an invisible display, without touching your screen, cursor, focus, Dock or speakers. |
| [redlight](https://github.com/andrewfitz/redlight) | cask | A lightweight blue light screen filter with multi-monitor support. |

Homebrew asks you to trust third-party taps the first time. backstage has prebuilt bottles for
macOS 15 and later on Apple Silicon; other Macs build it from source, which needs Xcode.
Redlight is signed and notarized, and updates itself (Sparkle), so `brew upgrade` leaves it to
the app.

## backstage

```bash
backstage doctor      # check permissions
backstage install     # skills for Claude Code, Codex, Grok, Cursor and OpenCode (--hooks: also the hook)
```

After `brew upgrade backstage`, restart the daemon so it runs the new version (this quits the
apps agents have open backstage):

```bash
backstage stop --all && backstage start
```

If you installed from the old `andrewfitz/backstage` tap, `brew update` moves backstage here.

## Releasing

- **Formula (backstage):** open a pull request that bumps `url` and `sha256` in
  `Formula/backstage.rb` and drops its `bottle` block (or run
  `brew bump-formula-pr --no-fork andrewfitz/tap/backstage --version X.Y.Z`). CI builds the
  bottles; when it's green, run the **brew pr-pull** workflow with the PR number to publish
  them and merge.
- **Cask (redlight):** bump `version` and `sha256` in `Casks/redlight.rb` in a pull request
  (or `brew bump-cask-pr --no-fork andrewfitz/tap/redlight --version X.Y.Z`) and merge it once
  CI is green. The daily **brew bump** workflow also opens these PRs when a new release appears.
