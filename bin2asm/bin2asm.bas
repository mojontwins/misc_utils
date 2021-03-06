' bin2asm.bas v0.1

' Compile with freebasic (https://www.freebasic.net)
' $ fbc bin2asm.bas cmdlineparser.bas

#include "cmdlineparser.bi"

Sub usage 
	Print "$ bin2asm.exe in=input.bin out=output.asm [label=XXX] [usedb] [bin] [bytesperline=N]"
	Print
	Print "Use label=XXX for a XXX: label on top of the code."
	Print "Add the usedb parameter for .db rather than .byte. Default is .byte."
	Print "Add the bin parameter to get the data in binary format. Default is hexadecimal."
	Print "Use bytesperline=N to have max. N bytes per .db/.byte line. Default is 16."
	Print
	Print "Copyleft 2018 by The Mojon Twins"	
End Sub

Dim As Integer bytesPerLine 
Dim As String prefix
Dim As Integer asBin
Dim As Integer fIn, fOut
Dim As Integer ctr
Dim As uByte d
Dim As String mandatory (1) = { "in", "out" }
Dim As String label

bytesPerLine = 16

sclpParseAttrs
If not sclpCheck (mandatory ()) Then usage: End

If Val (sclpGetValue ("bytesperline")) Then bytesPerLine = Val (sclpGetValue ("bytesperline"))
If sclpGetValue ("usedb") <> "" Then prefix = ".db" Else prefix = ".byte"
asBin = (sclpGetValue ("bin") <> "")

fIn = FreeFile
Open sclpGetValue ("in") For Binary As #fIn
fOut = FreeFile
Open sclpGetValue ("out") For Output As #fOut

Print #fOut, "; Generated by bin2asm.exe " & Command
Print #fOut, ""

label = sclpGetValue ("label")
If label <> "" Then Print #fOut, label & ":"

ctr = 0

While Not Eof (fIn)
	Get #fIn, , d
	If ctr Mod bytesPerLine = 0 Then
		Print #fOut, "    " & prefix & " ";
	End If
	If asBin Then
		Print #fOut, "%" & Bin (d, 8);
	Else
		Print #fOut, "$" & Hex (d, 2);
	End If	
	ctr = (ctr + 1) Mod bytesPerLine
	If ctr Mod bytesPerLine = 0 Or Eof (fIn) Then Print #fOut, "" Else Print #fOut, ", ";
Wend

Print #fOut, ""

Close fIn, fOut
