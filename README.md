# studio-theme

Converts a Visual Studio Code theme into a command you can paste into Roblox Studio's command bar to set your Script Editor colors.

A Luau/Lute port of [vocksel/rbxtheme](https://github.com/vocksel/rbxtheme).

## Setup

Requires [Rokit](https://github.com/rojo-rbx/rokit).

```sh
git clone https://github.com/morgann1/studio-theme.git
cd studio-theme
rokit install
lute setup
```

## Usage

List available themes — auto-discovered from your VSCode install (bundled themes like Dark Modern, Monokai, Solarized) and anything in `~/.vscode/extensions/`:

```sh
lute run list
```

Convert one to a Studio command:

```sh
lute run convert "Dark Modern"
```

```luau
local json = [[{"Background Color":[31, 31, 31],"Selection Color":[204, 204, 204], …}]]local theme = game.HttpService:JSONDecode(json) …
```

Paste the printed command into Studio's command bar.

### Flags

- `-c`, `--copy` — copy the command to your clipboard instead of printing it
- `-e`, `--expanded` — print the non-minified script (easier to read / inspect)

```sh
lute run convert "Dark Modern" --copy
lute run convert "Dark Modern" --expanded
```
