"
" $Id: til.vim 696 2006-10-06 20:17:52Z suriya $
"
" Some useful tools to read TIL (TRIPS Intermediate Language) files.
" Requires Vim 7.0

if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

if has("python") && has("signs")

sign define src text=<- linehl=DiffChange
sign define dest text=-> linehl=DiffDelete

python << END
import vim
import re

mu = None

class MarkUses:
    nextsignnum = 1
    # These regular expressions need to be commented better
    splitter = re.compile(r'[ ,\t]+')
    splitter2 = re.compile(r'[()<>, \t]+')

    def __init__(self, curlineno, inst, bufnum):
        """Initialize the MarkUses datastructure.
        inst is the instruction whose uses we want to mark."""
        self.curlineno = curlineno
        self.bufnum = bufnum
        self.target = self.findTarget(inst)

    def findTarget(self, inst):
        """Parse instruction and find the target register"""
        inst = inst.strip()
        if inst.startswith(';'):
            return None
        l = self.splitter.split(inst)
        # l[0] is the opcode
        # l[1] is the destination
        try:
            opcode = l[0]
            destination = l[1]
            if destination.startswith('$') and (opcode not in [ 'ret', 'write' ]):
                return destination
            else:
                return None
        except IndexError:
            return None

    def placeSign(self, sign, line):
        """Place `sign' in line number 'line' of the current buffer."""
        cmd = 'exe ":sign place %d line=%d name=%s buffer=%d"' \
            % (self.nextsignnum, line, sign, self.bufnum)
        vim.command(cmd)
        self.nextsignnum += 1

    def defines(self, inst):
        """Return true, if inst produces self.target"""
        t = self.findTarget(inst)
        return (t is not None) and (t == self.target)

    def uses(self, inst):
        """Return true, if inst uses self.target"""
        # This is check is not perfect now, but works for most cases
        l1 = self.splitter.split(inst.strip())
        l2 = self.splitter2.split(inst.strip())
        try:
            return (self.target in l2) and ((self.target != l1[1]) or (l1[0] == 'ret'))
        except IndexError:
            return False

    def placeSignIfNeeded(self, line, lineno):
        if line.strip().startswith(';'):
            return
        if self.uses(line):
            self.placeSign('dest', lineno)
        elif self.defines(line):
            self.placeSign('src', lineno)

    def isBlockEnd(self, line):
        return line.strip().startswith('.bend')

    def isBlockBegin(self, line):
        return line.strip().startswith('.bbegin')

    def doAll(self):
        """Mark all the uses and defs within the block"""
        # We go backward from the current line till the beginning of the block,
        # searching for defs of this instruction
        vim.command('sign unplace *')
        for i,line in enumerate(reversed(buf[:self.curlineno])):
            lineno = self.curlineno - i
            if self.isBlockBegin(line):
                break
            self.placeSignIfNeeded(line, lineno)
        # We go forward from the current line till the end of the block, searching
        # for uses of this instruction
        for i,line in enumerate(buf[self.curlineno:]):
            lineno = self.curlineno + 1 + i
            if self.isBlockEnd(line):
                break
            self.placeSignIfNeeded(line, lineno)
END

function HighlightDefUses()
python << END
if mu is not None:
    mu.doAll()
END
endfunction

function InitializeHighligtDefUses()
python << END
buf = vim.current.buffer
bufnum = int(vim.eval('bufnr("%")'))
curlineno = int(vim.eval('line(".")'))
# The buffer_index and line number are related by: buffer_index == lineno - 1
curline = buf[curlineno-1]
mu = MarkUses(curlineno, curline, bufnum)
END
call HighlightDefUses()
endfunction

map << :call InitializeHighligtDefUses()<cr>

if has("autocmd")
    autocmd CursorMoved,CursorMovedI *.til call HighlightDefUses()
endif

endif
