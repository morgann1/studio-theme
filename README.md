# studio-theme

This collection of lute scripts attempt to convert vscode theme token colors to Roblox Studio's Script Editor colors.

## Usage

```shell
# Clone the repository
git clone https://github.com/morgann1/studio-theme.git

# Navigate to the project directory
cd studio-theme

# Install the toolchain
rokit install

# Set up lute
lute setup
```

Then you can view the list of all the available themes.

```shell
lute run list
```

After picking a theme, use the `convert` command, which will give you a code snippet for you to run in the command bar.

```shell
lute run convert "Dark 2026"
```

```lua
local json = [[{"Background Color":[18, 19, 20],"Selection Color":[191, 191, 191],"Selected Text Color":[191, 191, 191],"Selection Background Color":[36, 92, 115],"Matching Word Background Color":[26, 51, 61],"Find Selection Background Color":[30, 66, 82],"Error Color":[244, 135, 113],"Warning Color":[229, 186, 125],"InformationColor":[58, 148, 188],"HintColor":[191, 191, 191],"Whitespace Color":[55, 56, 56],"Current Line Highlight Color":[36, 37, 38],"Ruler Color":[132, 132, 132],"Bracket Color":[31, 62, 76],"Text Color":[165, 214, 255],"Operator Color":[212, 212, 212],"Number Color":[181, 206, 168],"String Color":[201, 209, 217],"Comment Color":[139, 148, 158],"Bool Color":[86, 156, 214],"\"nil\" Color":[86, 156, 214],"Function Name Color":[210, 168, 255],"\"function\" Color":[255, 123, 114],"\"local\" Color":[86, 156, 214],"\"self\" Color":[121, 192, 255],"Luau Keyword Color":[78, 201, 176],"Keyword Color":[197, 134, 192],"Built-in Function Color":[220, 220, 170],"\"TODO\" Color":[139, 148, 158],"Method Color":[121, 192, 255],"Property Color":[201, 209, 217],"Debugger Current Line Color":[36, 37, 38],"Debugger Error Line Color":[30, 66, 82],"IndentationRulerColor":[64, 64, 64],"Script Editor Scrollbar Background Color":[20, 21, 23],"Script Editor Scrollbar Handle Color":[41, 42, 43],"Primary Text Color":[191, 191, 191],"Secondary Text Color":[140, 140, 140],"Active Color":[45, 110, 138],"Active Hover Over Color":[237, 237, 237],"Hover Over Color":[30, 31, 32],"Select Color":[24, 38, 45],"Select/Hover Color":[30, 31, 32],"Menu Item Background Color":[32, 33, 34],"Selected Menu Item Background Color":[24, 38, 45]}]]local theme = game.HttpService:JSONDecode(json) local studio = settings().Studio for name, color in theme do local success = pcall(function() studio[name] = Color3.fromRGB(color[1], color[2], color[3]) end) if not success then warn(`{name} is not a valid theme color`) end end print("Successfully changed your Script Editor theme!")
```