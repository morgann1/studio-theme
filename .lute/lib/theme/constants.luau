--!strict

local constants = {}

export type ColorMapping = { studio: string, vscode: { string } }

constants.ROBLOX_VSCODE_THEME_MAP = {
	{ studio = "Background Color", vscode = { "editor.background" } },
	{ studio = "Selection Color", vscode = { "foreground", "editor.foreground" } },
	{ studio = "Selected Text Color", vscode = { "editor.selectionForeground", "foreground", "editor.foreground" } },
	{
		studio = "Selection Background Color",
		vscode = {
			"editor.selectionBackground",
			"selection.background",
			"editor.inactiveSelectionBackground",
			"editor.selectionHighlightBackground",
			"editor.wordHighlightBackground",
			"editor.findMatchHighlightBackground",
		},
	},
	{
		studio = "Matching Word Background Color",
		vscode = {
			"editor.selectionHighlightBackground",
			"editor.wordHighlightBackground",
			"editor.selectionBackground",
		},
	},
	{
		studio = "Find Selection Background Color",
		vscode = { "editor.findMatchBackground", "editor.findMatchHighlightBackground" },
	},
	{ studio = "Error Color", vscode = { "errorForeground", "editorError.foreground" } },
	{
		studio = "Warning Color",
		vscode = {
			"editorWarning.foreground",
			"editorWarning.border",
			"list.warningForeground",
			"editorOverviewRuler.warningForeground",
			"problemsWarningIcon.foreground",
			"statusBarItem.warningForeground",
			"inputValidation.warningForeground",
			"warningForeground",
			"markup.warning",
			"invalid.deprecated",
			"editorError.foreground",
			"errorForeground",
		},
	},
	{
		studio = "InformationColor",
		vscode = {
			"editorInfo.foreground",
			"editorInfo.border",
			"list.infoForeground",
			"editorOverviewRuler.infoForeground",
			"problemsInfoIcon.foreground",
			"notificationsInfoIcon.foreground",
			"foreground",
			"editor.foreground",
		},
	},
	{
		studio = "HintColor",
		vscode = {
			"editorHint.foreground",
			"editorHint.border",
			"editorOverviewRuler.infoForeground",
			"editorInfo.foreground",
			"foreground",
			"editor.foreground",
		},
	},
	{ studio = "Whitespace Color", vscode = { "editorWhitespace.foreground", "editorLineNumber.activeForeground" } },
	{ studio = "Current Line Highlight Color", vscode = { "editor.lineHighlightBackground", "editor.background" } },
	{
		studio = "Ruler Color",
		vscode = {
			"editorRuler.foreground",
			"editorOverviewRuler.border",
			"editorOverviewRuler.foreground",
			"editor.lineHighlightBorder",
			"editorIndentGuide.background1",
			"editorIndentGuide.background",
			"editorLineNumber.activeForeground",
			"editorLineNumber.foreground",
			"panel.border",
			"editorGroup.border",
		},
	},
	{
		studio = "Bracket Color",
		vscode = {
			"editorBracketMatch.background",
			"editorBracketMatch.border",
			"meta.brace",
			"foreground",
			"editor.foreground",
		},
	},
	{
		studio = "Text Color",
		vscode = { "string", "string.quoted", "foreground", "editor.foreground" },
	},
	{ studio = "Operator Color", vscode = { "keyword.operator", "keyword" } },
	{ studio = "Number Color", vscode = { "constant.numeric", "constant" } },
	{
		studio = "String Color",
		vscode = {
			"variable",
			"variable.other",
			"variable.object",
			"variable.parameter",
			"variable.other.readwrite",
			"meta.object-literal.key",
			"support",
			"foreground",
			"editor.foreground",
		},
	},
	{ studio = "Comment Color", vscode = { "comment" } },
	{ studio = "Bool Color", vscode = { "constant.language.boolean", "constant.language", "constant" } },
	{ studio = '"nil" Color', vscode = { "constant.language.null", "constant.language", "constant" } },
	{
		studio = "Function Name Color",
		vscode = { "entity.name.function", "variable.function", "meta.function", "support.function" },
	},
	{
		studio = '"function" Color',
		vscode = {
			"storage.type.function",
			"keyword.declaration.function",
			"keyword",
			"keyword.control",
			"variable",
			"variable.language",
			"meta.function",
		},
	},
	{ studio = '"local" Color', vscode = { "storage.type.local", "storage.modifier", "keyword" } },
	{
		studio = '"self" Color',
		vscode = {
			"variable.language.self",
			"variable.instance",
			"variable.language",
			"support",
			"keyword",
			"variable",
		},
	},
	{ studio = "Luau Keyword Color", vscode = { "variable.language", "variable" } },
	{ studio = "Keyword Color", vscode = { "keyword.control", "keyword" } },
	{ studio = "Built-in Function Color", vscode = { "support.function", "entity.name", "entity.other" } },
	{ studio = '"TODO" Color', vscode = { "comment.todo", "keyword.codetag.notation", "variable", "keyword" } },
	{
		studio = "Method Color",
		vscode = { "entity.name.function.method", "entity.name.function", "variable.function" },
	},
	{
		studio = "Property Color",
		vscode = { "variable.other.property", "variable.other.member", "support.variable.property", "variable" },
	},
	{
		studio = "Debugger Current Line Color",
		vscode = {
			"editor.stackFrameHighlightBackground",
			"editor.focusedStackFrameHighlightBackground",
			"editor.lineHighlightBackground",
			"editor.findMatchBackground",
			"editor.findMatchHighlightBackground",
			"debugToolBar.background",
			"statusBar.debuggingBackground",
			"editorInfo.foreground",
		},
	},
	{
		studio = "Debugger Error Line Color",
		vscode = {
			"editor.stackFrameErrorHighlightBackground",
			"editorError.background",
			"editorError.foreground",
			"editor.findMatchBackground",
		},
	},
	{
		studio = "IndentationRulerColor",
		vscode = {
			"editorIndentGuide.background1",
			"editorIndentGuide.background",
			"editorIndentGuide.activeBackground",
		},
	},
	{
		studio = "Script Editor Scrollbar Background Color",
		vscode = { "scrollbar.shadow", "editorOverviewRuler.background", "editor.background" },
	},
	{
		studio = "Script Editor Scrollbar Handle Color",
		vscode = {
			"scrollbarSlider.background",
			"scrollbarSlider.activeBackground",
			"scrollbarSlider.hoverBackground",
			"editorOverviewRuler.background",
			"editorOverviewRuler.border",
			"panel.border",
			"editorGroup.border",
			"widget.border",
			"tab.border",
			"editorWidget.border",
		},
	},
	{
		studio = "Primary Text Color",
		vscode = { "foreground", "editor.foreground", "editorSuggestWidget.foreground", "menu.foreground" },
	},
	{
		studio = "Secondary Text Color",
		vscode = {
			"descriptionForeground",
			"editorSuggestWidget.descriptionForeground",
			"foreground",
			"editor.foreground",
		},
	},
	{
		studio = "Active Color",
		vscode = { "focusBorder", "button.background", "list.activeSelectionBackground", "tab.activeBorderTop" },
	},
	{
		studio = "Active Hover Over Color",
		vscode = { "list.activeSelectionForeground", "list.hoverForeground", "foreground" },
	},
	{
		studio = "Hover Over Color",
		vscode = { "list.hoverBackground", "editorHoverWidget.background", "editorWidget.background" },
	},
	{
		studio = "Select Color",
		vscode = { "list.activeSelectionBackground", "editor.selectionBackground", "menu.selectionBackground" },
	},
	{
		studio = "Select/Hover Color",
		vscode = {
			"list.hoverBackground",
			"list.inactiveSelectionBackground",
			"editor.selectionBackground",
			"editor.inactiveSelectionBackground",
			"menu.selectionBackground",
			"editor.selectionHighlightBackground",
			"editorSuggestWidget.selectedBackground",
		},
	},
	{
		studio = "Menu Item Background Color",
		vscode = {
			"menu.background",
			"editorSuggestWidget.background",
			"dropdown.background",
			"editorWidget.background",
		},
	},
	{
		studio = "Selected Menu Item Background Color",
		vscode = {
			"menu.selectionBackground",
			"editorSuggestWidget.selectedBackground",
			"list.activeSelectionBackground",
			"editor.selectionBackground",
		},
	},
} :: { ColorMapping }

return constants
