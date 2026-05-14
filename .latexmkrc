# 清理所有生成文件
$clean_ext = 'aux bbl blg idx ind lof lot out toc acn acr alg glg glo gls ist fls listing hd dvi xdv fdb_latexmk bak*';

# ======================================================================================
# PDF Generation/Building/Compilation
# ======================================================================================

# Chinese exam papers require XeLaTeX for CJK font handling.
$pdf_mode = 5;
$xelatex = 'xelatex -interaction=nonstopmode -synctex=1 -halt-on-error %O %S';

# Keep generated files out of the repository root.
$out_dir = 'build/pdf';
$aux_dir = 'build/aux';

# Show used CPU time. Looks like: https://tex.stackexchange.com/a/312224/120853
$show_time = 1;

@default_files = ('examples/demo.tex');

for my $file (glob 'body/*.tex') {
    push @default_files, $file;
}
