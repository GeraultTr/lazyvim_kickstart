# Navigating

- From the eye s + type + letters
- otherwise use space + sG to search throughout all project
- Jump to files space + fF (capitals always to work in whole working directory of the project)
- m + LETTER / access through ' + LETTER / del with :delmarks LETTER
- Jump to definition : gd
- Go to references, first file first gr
- Current file outline space + ss
- Filter outline 
- K on a name to see the hoover
- Ctrl-o   older cursor position
- Ctrl-i   newer cursor position

**Between panes**
- Ctrl + h j k l      for     left, down, up, right, respectively

**Between files**
- Shift-h   previous buffer
- Shift-l   next buffer
- leader b b   switch to other buffer
- leader ,     list open buffers
- leader f r   recent files

# LSP errors

- space cd to get a popup of the error
- close bracket + e next error  
- open bracket + e previous error

# Edit
- i \ escape for edition
- u - undo
- ctrl + r - redo

**Visual mode**
- v         start character-wise selection
- V         start line-wise selection
- Ctrl-v    start block selection
- y         copy selected text
- d         cut selected text
- p         paste after cursor
- P         paste before cursor
- 
**Whole line management**
- gcc to comment

# File management
- :w for saving
- :q to quit
- :!mkdir -p notes to make parent directories
- :e notes/todo.md to create files

# Project
Open project
home page p or space + fp

# Terminal
- space ft to trigger a terminal
- close it with ctrl + A and :q
 
# Git control:
- git status in terminal for summary
- In file go to line and use space + ghd
- `]c`Jump to **next** diff hunk`[c`Jump to **previous** diff hunk
- space ghr reset current hunk (or space ghR for whole file)
	and simply :q to close extra window
