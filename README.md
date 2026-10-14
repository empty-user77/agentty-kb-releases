# agentty-kb releases

Builds of **agentty-kb**, the local server behind the **Knowledge Base** plugin for
[Agentty](https://github.com/empty-user77/Agentty). The plugin is the panel; agentty-kb reads your
repositories, keeps their knowledge graph in `.kb/` and answers Claude Code and Codex through the
plugin, on `127.0.0.1` only.

You usually do not need to install it yourself: pressing **Turn on** in the plugin installs it when
this machine has none.

## Install

```sh
curl -fsSL https://github.com/empty-user77/agentty-kb-releases/releases/latest/download/install.sh | sh
```

The script picks the build for your machine, checks it against the release's `SHA256SUMS` and puts
it in `~/.agentty/bin/agentty-kb`. Nothing else is changed. Set `AGENTTY_KB_VERSION=v0.1.0` for a
given version, or `AGENTTY_KB_DIR` for another folder.

| Platform | File |
|---|---|
| macOS, Apple silicon | `agentty-kb-aarch64-apple-darwin.tar.gz` |
| macOS, Intel | `agentty-kb-x86_64-apple-darwin.tar.gz` |
| Linux x86_64 (glibc 2.17+) | `agentty-kb-x86_64-unknown-linux-gnu.tar.gz` |
| Linux arm64 (glibc 2.17+) | `agentty-kb-aarch64-unknown-linux-gnu.tar.gz` |

## Uninstall

Uninstalling the Knowledge Base plugin in Agentty removes `agentty-kb` too (an Agentty that sends
`plugin/uninstall`, with the server on). By hand (0.1.5 and later): turn the server off in the plugin, then

```sh
~/.agentty/bin/agentty-kb uninstall
```

It removes the program, its login item and its files in `~/.agentty/kb`. Knowledge bases stay in
each repository's `.kb/` folder and in `~/.agentty/kb/hubs`; delete those to remove them too.

## Licence

Proprietary. Free to use with Agentty; the source is not public.
