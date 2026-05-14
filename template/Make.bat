@echo off
pushd ..
if not exist build\pdf mkdir build\pdf
if not exist build\aux mkdir build\aux

for %%B in (template\*.tex) do latexindent -w -m -l "%%B"

latexmk -xelatex -interaction=nonstopmode -synctex=1 template\demo.tex

popd

REM pause
