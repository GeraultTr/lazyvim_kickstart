# Navigating

| Keybinding | Description |
|---|---|
| s + type + letters | Navigate to visible position (from the eye) |
| space + sG | Search throughout all project |
| space + sb | Search in file |
| space + sw | Search current word or visual selection |
| space + fF | Jump to files (capitals = whole project directory) |
| m + LETTER | Set mark |
| ' + LETTER | Jump to mark |
| :delmarks LETTER | Delete mark |
| gd | Jump to definition |
| gr | Go to references (first file first) |
| space + ss | Current file outline |
| K | Show hover documentation |
| Ctrl-o | Older cursor position |
| Ctrl-i | Newer cursor position |

**Between panes**

| Keybinding | Description |
|---|---|
| Ctrl + h/j/k/l | Move left/down/up/right between panes |

**Between files**

| Keybinding | Description |
|---|---|
| Shift-h | Previous buffer |
| Shift-l | Next buffer |
| leader b b | Switch to other buffer |
| leader , | List open buffers |
| leader f r | Recent files |

# LSP errors

| Keybinding | Description |
|---|---|
| space cd | Popup of the error |
| ] + e | Next error |
| [ + e | Previous error |

# Edit

| Keybinding | Description |
|---|---|
| i / Escape | Enter/exit insert mode |
| u | Undo |
| Ctrl-r | Redo |

**Visual mode**

| Keybinding | Description |
|---|---|
| v | Start character-wise selection |
| V | Start line-wise selection |
| Ctrl-v | Start block selection |
| y | Copy selected text |
| d | Cut selected text |
| p | Paste after cursor |
| P | Paste before cursor |

**Whole line management**

| Keybinding | Description |
|---|---|
| gcc | Comment line |

# File management

| Keybinding | Description |
|---|---|
| :q | Quit |
| Ctrl + e , then a / m / d  on file | Add / Move / Delete file by editing its path. To add a directory / at the end of the path |


**Redundant but resource**

| Keybinding | Description |
|---|---|
| :w | Save file (But autosave is turned on in this template |
| :!mkdir -p notes | Make parent directories |
| :e notes/todo.md | Create file |


# Project

| Keybinding | Description |
|---|---|
| p (home page) / space + fp | Open project |

# Terminal

| Keybinding | Description |
|---|---|
| space ft | Trigger terminal |
| Ctrl-A then :q | Close terminal |

# Git control

| Keybinding | Description |
|---|---|
| space + gd | Diffed files |
| space + gs | Whole git summary |
| space + ghd | Diff current line |
| ]c | Jump to next diff hunk |
| [c | Jump to previous diff hunk |
| space ghr | Reset current hunk |
| space ghR | Reset whole file |

# Claude code extension

| Keybinding | Description |
|---|---|
| space + ac | Toggle Claude code pane |
| shift + Tab twice | Enable plan mode in claude code |
| / | Explore claude code commands (e.g. /resume /config) |
