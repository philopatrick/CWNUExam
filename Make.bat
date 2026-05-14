@echo off
if not exist build\pdf mkdir build\pdf
if not exist build\aux mkdir build\aux

for %%B in (examples\*.tex template\*.tex) do latexindent -w -m -l "%%B"

latexmk -xelatex -interaction=nonstopmode -synctex=1 examples\demo.tex

REM pause
