\NeedsTeXFormat{LaTeX2e}
\RequirePackage{expl3}
\ProvidesExplClass {USTBExam} {2025-11-02} {v2.3.8} {An exam template for USTB}

\AddToHook{package/exam-zh-symbols/before}{%
    \AtBeginDocument{\let\savedsim=\sim}
  }
\AddToHook{package/exam-zh-symbols/after}{%
    \AtBeginDocument{\let\sim=\savedsim}
  }

% 加载文档类和宏包
\LoadClass {exam-zh}

% 处理文档类选项
\PassOptionsToClass { UTF8,  scheme = chinese, openany } { exam-zh }
\DeclareOption* { \PassOptionsToClass { \CurrentOption } { exam-zh } }
\ProcessOptions*

% 使用 l3keys 定义 \ustbexamsetup 配置命令
\NewDocumentCommand \ustbexamsetup { m }
  { \keys_set:nn { ustb-exam } {#1} }

% 全局配置
\keys_define:nn { ustb-exam / global }
  {
    watermark .tl_set:N = \l__ustbexam_global_watermark,
  }
\keys_set:nn { ustb-exam / global }
  {
    watermark = {},
  }
\keys_define:nn { ustb-exam }
  { global .meta:nn = { ustb-exam / global } {#1} }

\AtEndPreamble
  {
    % 增加左边距，避免内容从左侧溢出
    \geometry{left=25mm} % 增加左边距到25mm（密封线区域宽度）
    
    \tl_if_empty:NF { \l__ustbexam_global_watermark }
      {
        \RequirePackage{background}
        \backgroundsetup{
            scale=1, % 调整大小
            angle=0, % 调整角度
            opacity=0.15, % 调整透明度
            pages=all, % 应用到所有页面
            position=current~page.center, % 确保在页面正中心
            contents={
                \includegraphics[width=0.6\paperwidth, keepaspectratio]{\l__ustbexam_global_watermark}
              }
          }
      }
  }


% 试卷内标题处的参数
\keys_define:nn { ustb-exam / title }
  {
    year       .int_set:N = \l__ustbexam_title_year_int,
    semester   .tl_set:N  = \l__ustbexam_title_semester,
    course     .tl_set:N  = \l__ustbexam_title_course_str,
    suffix     .tl_set:N  = \l__ustbexam_title_suffix_str,
    type       .str_set:N = \l__ustbexam_title_type_str,
    total-part .int_set:N = \l__ustbexam_title_total_part_int,
    college    .tl_set:N  = \l__ustbexam_title_college_str,
    major      .tl_set:N  = \l__ustbexam_title_major_str,
    grade      .tl_set:N  = \l__ustbexam_title_grade_str,
    exam-room  .tl_set:N  = \l__ustbexam_title_exam_room_str,
    exam-type  .tl_set:N  = \l__ustbexam_title_exam_type_str,
    exam-time  .int_set:N = \l__ustbexam_title_exam_time_int,
    exam-category .tl_set:N = \l__ustbexam_title_exam_category_str,
    test-type  .tl_set:N  = \l__ustbexam_title_test_type_str,
  }
\keys_set:nn { ustb-exam / title }
  {
    year       = {\the\year},
    semester   = {一},
    course     = {JAVA Programming Language},
    suffix     = {},
    type       = {A},
    total-part = {4},
    college    = {计算机学院},
    major      = {软件工程专业},
    grade      = {2024级},
    exam-room  = {},
    exam-type  = {闭卷},
    exam-time  = {120},
    exam-category = {考试},
    test-type  = {normal},  % normal 或 international
  }
\keys_define:nn { ustb-exam }
  { title .meta:nn = { ustb-exam / title } {#1} }

% PDF 配置
\keys_define:nn { ustb-exam / pdf }
  {
    title    .tl_set:N = \l__ustbexam_pdf_title,
    subject  .tl_set:N = \l__ustbexam_pdf_subject,
    author   .tl_set:N = \l__ustbexam_pdf_author,
    keywords .tl_set:N = \l__ustbexam_pdf_keywords,
  }
\keys_set:nn { ustb-exam / pdf }
  {
    title    = \l_ustbexam_title_tl,
    subject  = {},
    author   = \@author,
    keywords = {},
  }
\keys_define:nn { ustb-exam }
  { pdf .meta:nn = { ustb-exam / pdf } {#1} }

\AtBeginDocument
  {
    \hypersetup{
        pdfinfo={
            Title    = {\l__ustbexam_pdf_title},
            Author   = {\l__ustbexam_pdf_author},
            Subject  = {\l__ustbexam_pdf_subject},
            Keywords = {\l__ustbexam_pdf_keywords},
          },
        colorlinks = true,
        linkcolor  = black,
      }
  }

% title 里的课程名
\tl_new:N \l__ustbexam_title_course_real
\AtBeginDocument{
    \str_if_empty:NF {\l__ustbexam_title_course_str}
      {
        \hbox_set:Nn \l_tmpa_box {\l__ustbexam_title_course_str}
        \dim_set:Nn \l_tmpa_dim { \box_wd:N \l_tmpa_box * 2 }
        \tl_set:Nn \l__ustbexam_title_course_real
          {
            \__examzh_spread_box:nn { \l_tmpa_dim } { \l__ustbexam_title_course_str }
          }
      }
  }

% 是否期中
\tl_new:N \l__ustbexam_title_suffix_real
\tl_set:Nn \l__ustbexam_title_suffix_real { 试卷 }

% 在文档开始前处理 suffix
\AtBeginDocument{
    \tl_if_empty:NF \l__ustbexam_title_suffix_str
      {
        \tl_set:Nx \l__ustbexam_title_suffix_real { \l__ustbexam_title_suffix_str 试卷 }
      }
  }

% 试卷类型
\tl_new:N \l__ustbexam_title_type_real
\tl_set:Nn \l__ustbexam_title_type_real
  {
    \bool_if:NTF \l__examzh_question_show_paren_answer_bool
      { （\str_use:N \l__ustbexam_title_type_str 卷解析）}
      { （\str_use:N \l__ustbexam_title_type_str 卷） }
  }

% 标题
\tl_new:N \l_ustbexam_title_tl
\AtBeginDocument{
    \tl_set:Nn \l_ustbexam_title_tl
      {
        \int_eval:n { \l__ustbexam_title_year_int } -- \int_eval:n {\l__ustbexam_title_year_int + 1} ~学年\,%
        第 \l__ustbexam_title_semester{} 学期 \l__ustbexam_title_course_str \l__ustbexam_title_suffix_real \l__ustbexam_title_type_real
      }
  }

% 定义计数器, 自动获取大题数目
\newcounter{sectioncounter}

% 使用钩子在每次调用 \section 和 \section* 时递增计数器
\AddToHook{ cmd / section / before }{ \stepcounter{sectioncounter} }

% 覆盖 section 定义（在 exam-zh 重定义之后）
% exam-zh 会在 \AtEndPreamble 时根据 scoringbox/type 重定义 section
% 我们需要在 \AtBeginDocument 时再次覆盖，以便自定义格式
\AtBeginDocument{
  % 保存 exam-zh 的原始 section 定义
  \@ifundefined{examzholdsection}{
    % 如果 exam-zh 没有保存原始 section，我们自己保存
    \NewCommandCopy { \examzholdsection } { \section }
  }{}
  % 重新定义 section，创建自定义的评分框格式
  % 格式：评分框在 section 标题上方，第一行是"得分"和"阅卷人"两列，第二行是两列空格
  \RenewDocumentCommand { \section } { s o m }
    {
      \IfBooleanTF {#1}
        {
          % \section* 的情况，不显示评分框
          \examzholdsection*{#3}
        }
        {
          % \section 的情况，显示自定义评分框在标题上方
          \par\addvspace{1.5em}\noindent
          % 评分框（在标题上方，左对齐）
          \begin{tabular}{|c|c|}
            \hline 
            得分 & 阅卷人\rule[-0.7em]{0pt}{2em} \\\hline
            \rule{1.5em}{0pt}\rule[-0.7em]{0pt}{2em} & \rule{1.5em}{0pt}\rule[-0.7em]{0pt}{2em} \\\hline
          \end{tabular}
          \vspace{0.5em}
          % section 标题
          \IfNoValueTF {#2}
            {
              \examzholdsection{#3}
            }
            {
              \examzholdsection[#2]{#3}
            }
          \par
          \addvspace{1em}
        }
    }
}

% 脚注编号每页清零
\AddToHook{ shipout / before }
  {
    \global\c@footnote=0
  }

% 添加页面边框框
% A3 纸张宽度为 297mm，A4 纸张宽度为 210mm
\AddToHook{shipout/background}{
  \begin{tikzpicture}[remember~picture, overlay]
    \pgfmathsetlengthmacro{\framemargin}{5mm}
    \pgfmathsetlengthmacro{\seallinewidth}{16mm} % 密封线区域宽度，避免边框与密封线重叠
    \pgfmathsetlengthmacro{\gapwidth}{ 5mm} % A3 模式下左右框之间的间距
    
    % 计算页眉页脚区域高度，避免边框与页眉页脚重叠
    \pgfmathsetlengthmacro{\topmargin}{\headheight  + \framemargin}
    \pgfmathsetlengthmacro{\bottommargin}{ \footskip + \framemargin +7mm}
    
    % 检测是否是 A3 纸张（A3 宽度约 297mm，A4 宽度约 210mm）
    \pgfmathparse{\paperwidth > 280mm ? 1 : 0}
    \ifnum\pgfmathresult=1
      % A3 纸张：绘制左右两个框
      % 左边框（避开密封线区域和页眉页脚）
      \draw[line~width=0.8pt, black]
        ([xshift=\seallinewidth, yshift=-\topmargin]current~page.north~west)
        rectangle
        ([xshift={\paperwidth/2 - \gapwidth/2}, yshift=\bottommargin]current~page.south~west);
      % 右边框（从页面中间开始，避开页眉页脚）
      \draw[line~width=0.8pt, black]
        ([xshift={\paperwidth/2 + \gapwidth/2}, yshift=-\topmargin]current~page.north~west)
        rectangle
        ([xshift=-\framemargin, yshift=\bottommargin]current~page.south~east);
    \else
      % A4 纸张：绘制单个框（避开密封线区域和页眉页脚）
      % 检测当前页是奇数页还是偶数页
      \pgfmathparse{mod(\thepage,2) == 1 ? 1 : 0}
      \ifnum\pgfmathresult=1
        % 奇数页：密封线在左侧，边框从密封线右侧开始
        \draw[line~width=0.8pt, black]
          ([xshift=\seallinewidth, yshift=-\topmargin]current~page.north~west)
          rectangle
          ([xshift=-\framemargin, yshift=\bottommargin]current~page.south~east);
      \else
        % 偶数页：密封线在右侧，边框到密封线左侧结束
        \draw[line~width=0.8pt, black]
          ([xshift=\framemargin, yshift=-\topmargin]current~page.north~west)
          rectangle
          ([xshift=-\seallinewidth, yshift=\bottommargin]current~page.south~east);
      \fi
    \fi
  \end{tikzpicture}
}

% 暂时不做自动获取, 有困难需解决

% 输出标题
\RenewDocumentCommand \maketitle { }
  {
    \cleardoublepage
    \chapter{西华师范大学学生试卷}
    \begingroup
    \begin { center }
    \let \footnote \thanks
      {
        % 主标题：西华师范大学学生试卷（一号黑体）
        {\fontsize{26pt}{31.2pt}\selectfont\heiti 西华师范大学学生试卷} \par
        \vspace{0.5em}
        % 考试信息行：年   月   日        2017-2018学年第 1  学期           考室
        {
          \kaishu
          年 \quad 月 \quad 日 \quad\quad\quad
          \int_eval:n { \l__ustbexam_title_year_int } -- \int_eval:n {\l__ustbexam_title_year_int + 1} 学年第~ \l__ustbexam_title_semester{} ~ 学期 \quad\quad\quad
          考室 \underline{\quad\quad\quad\quad} \l__ustbexam_title_exam_room_str
        } \par
        \vspace{0.5em}
        % 得分表格
        {\kaishu \bfseries \ScoreTable { \l__ustbexam_title_total_part_int } } \par
        \vspace{0.5em}
        % 课程信息：××学院××专业××级《 》试题 A(或B)卷（四号黑体）
        {
          \fontsize{14pt}{16.8pt}\selectfont\heiti
          \l__ustbexam_title_college_str\l__ustbexam_title_major_str\l__ustbexam_title_grade_str《\l__ustbexam_title_course_str》试题 \l__ustbexam_title_type_str 卷
        } \par
        \vspace{0.3em}
        % 考试类型和时间（五号宋体）
        {
          \fontsize{10.5pt}{12.6pt}\selectfont\songti
          \str_if_eq:VnTF \l__ustbexam_title_exam_type_str {开卷}
            {
              % 开卷时只显示：开卷考试 时间120分钟 或 开卷考查 时间90分钟
              \l__ustbexam_title_exam_type_str\l__ustbexam_title_exam_category_str 时间 \int_use:N \l__ustbexam_title_exam_time_int 分钟
            }
            {
              % 闭卷时显示：闭卷(或开卷)考试(或考查) 时间120(或90)分钟
              \l__ustbexam_title_exam_type_str \l__ustbexam_title_exam_category_str  时间 \int_use:N \l__ustbexam_title_exam_time_int 分钟
            }
        }
      }
    \end { center }
    \endgroup
    \begingroup
      \str_if_eq:VnTF \l__ustbexam_title_test_type_str {international}
        {
          % English version
          {\par \bfseries Notes:}
          \begin{minipage}[t]{.9\textwidth}
            \begingroup
            \raggedright
            \setlength{\parindent}{0pt}
            \setlength{\parskip}{0.5em}
            \makeatletter
            \let\save@xobeysp\@xobeysp
            \def\@xobeysp{\ }
            \makeatother
            1. Full score: 100 points. Keep paper neat, otherwise 2 points deducted.\par
            2. Submit both question and answer sheets together, otherwise points deducted.\par
            3. Fill in name, class, and student ID in sealed section, otherwise paper void.\par
            4. Students must sign in, otherwise omissions are student's responsibility.
            \makeatletter
            \let\@xobeysp\save@xobeysp
            \makeatother
            \endgroup
          \end{minipage}
        }
        {
          % Chinese version
          {\par \bfseries 注意事项：}
          \begin{minipage}[t]{.9\textwidth}
            \kaishu
            1、满分:100分。保持卷面整洁,否则扣卷面2分。\par
            2、交卷时请将试题卷与答题卷一起交,否则扣分。\par
            3、学生必须将姓名、班级、学号完整填写在规定的密封栏目内,否则视为废卷。\par
            4、学生必须签到,否则出现遗漏由学生本人负责。
          \end{minipage}
        }
    \endgroup
  }

% 输出计分表
\RequirePackage{makecell,tabularx}

% https://tex.stackexchange.com/questions/625226/alternative-to-repeatcell-from-the-interfaces-package-since-texlive-2021/625249#625249
% we need LaTeX counters and not expl3 ones because of tabularx two-step process
\newcounter{repeatstart}
\newcounter{repeatcurrent}
\newcounter{repeatlast}

\NewDocumentCommand{\repeatcell}{ m m }
  { % #1 = number of repeats
    % #2 = key-value pairs
    \oaheix_repeatcell:nn { #1 } { #2 }
  }

\tl_new:N \l__oaheix_repeatcells_body_tl

\keys_define:nn { oaheix/repeatcells }
  {
    text  .code:n  = \cs_gset_protected:Nn \__oaheix_repeatcell_text:n { #1 },
    start .code:n = \setcounter{repeatstart}{#1},
  }

\cs_new_protected:Nn \oaheix_repeatcell:nn
  {
    \keys_set:nn { oaheix/repeatcells } { #2 }
    \tl_clear:N \l__oaheix_repeatcells_body_tl
    \int_step_inline:nnn
      { \value{repeatstart} + 1 }
      { \value{repeatstart} + #1 }
      {
        \tl_put_right:Nx \l__oaheix_repeatcells_body_tl
          {
            \int_compare:nF { ##1 = \value{repeatstart} + 1 } { & }
            \__oaheix_repeatcell_text:n { ##1 }
          }
      }
    \tl_use:N \l__oaheix_repeatcells_body_tl
    \setcounter{repeatlast} { \int_eval:n { \value{repeatstart} + #1 } }
  }

\NewExpandableDocumentCommand{\lastvalue}{}{\int_eval:n { \value{repeatlast} } }

\AtBeginEnvironment{tabularx}{\setcounter{repeatstart}{0}}

% 计分表制作
\NewDocumentCommand \ScoreTable { m } {
    \begin{ center }
    \int_compare:nTF { #1 > 0 }
      {
        % 计算需要显示的列数（最多10题，加上题号、总分、阅卷教师）
        \int_set:Nn \l_tmpa_int { \int_min:nn { #1 } { 10 } }
        % 设置表格宽度为 A4 宽度的 80%（A4 宽度 210mm，80% = 168mm）
        \begin{tabularx}
          {168mm}{ |p{3em}<{\centering} *{\l_tmpa_int}{|X<{\centering}} |X<{\centering}|X<{\centering}|}
          \hline
          题号 & \repeatcell{\l_tmpa_int}{text = \zhnumber{##1}} & 总分 & 阅卷教师 \\
          \hline
          得分 & \repeatcell{\l_tmpa_int}{text = \ } & & \\
          \hline
        \end{tabularx}
      }{
        % 设置表格宽度为 A4 宽度的 80%（A4 宽度 210mm，80% = 168mm）
        \begin{tabularx}
          {168mm}{ |p{3em}<{\centering} | X<{\centering} | X<{\centering} | }
          \hline
          题号 & 总分 & 阅卷教师 \\
          \hline
          得分 & & \\
          \hline
        \end{tabularx}
      }
    \end{ center }
  }

% 默认图片路径
\graphicspath{
    {./figs}{../figs}{body/figs}
      {./Figs}{../Figs}{body/Figs}
  }

% 默认的 enumerate 环境
\setlist[enumerate]{label=(\arabic*), left=\parindent, itemsep=0pt, align=left, parsep=0pt, topsep=0pt}
\setlist[enumerate,2]{label=(\roman*), left=0em, labelsep=-0.5em, itemsep=0pt, parsep=0pt, topsep=0pt}
% 默认的 itemize 环境
\setlist[itemize]{left=\parindent, itemsep=0pt, parsep=0pt, topsep=0pt}
\setlist[itemize,2]{left=0em, labelsep=-0.5em, itemsep=0pt, parsep=0pt, topsep=0pt}
% 默认的 description 环境
\setlist[description]{leftmargin=\parindent, itemsep=0pt, parsep=0pt, topsep=0pt}
\setlist[description,2]{left=0em, labelsep=-0.5em, itemsep=0pt, parsep=0pt, topsep=0pt}

\newlist{inenum}{enumerate*}{2}
\setlist[inenum]{(1), itemjoin={\quad}}

% 更新日志
\RequirePackage{changelog,translations}
\DeclareTranslation{English}{changelog-Added}{新增}
\DeclareTranslation{English}{changelog-Changed}{修改}
\DeclareTranslation{English}{changelog-Deprecated}{即将舍弃}
\DeclareTranslation{English}{changelog-Removed}{移除}
\DeclareTranslation{English}{changelog-Fixed}{纠错}
\DeclareTranslation{English}{changelog-Security}{安全}
\DeclareTranslation{English}{changelog-Miscellaneous}{其他}
\DeclareTranslation{English}{changelog-Unreleased}{即将发布}
\DeclareTranslation{English}{changelog-Yanked}{警醒}

% 页眉页脚
\fancypagestyle{myEmptyPage}{
    \fancyhf{}
    \cfoot{\thepage}
  }

% 已废弃
\NewDocumentCommand \backcover { }
  {
    \int_if_odd:nTF \c@page
      {
        { \clearpage \hbox:n { } \thispagestyle{empty} }
          { \setcounter{page}{\thepage - 1} }
      }
      {
        { \cleardoublepage \hbox:n { } \thispagestyle{empty} }
          { \setcounter{page}{\thepage - 2} }
      }
  }

\RenewDocumentCommand \cleardoublepage { }
  {
    \clearpage
    \int_if_odd:nF \c@page
      { \hbox:n { } \thispagestyle { empty } \newpage }
  }

\RequirePackage{tocloft}
\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}}
\renewcommand{\contentsname}{\centerline{\LARGE 目\quad 录}}
\tocloftpagestyle{myEmptyPage}

\setlength{\parindent}{0em}

\RequirePackage{zref-user, refcount}

% 定义一个命令：取 RealLastPage 页码 - 1，且不小于 1
\NewDocumentCommand \realLastPageMinusOne {} {
    \int_eval:n {
        \int_max:nn { 1 } { \zref@extractdefault{RealLastPage}{page}{0} - 1 }
      }
  }

\examsetup{
    page = {
        foot-content = {
            \kaishu  第~\thepage~页 \quad 共~\realLastPageMinusOne~页
          },
        foot-type = common,
        show-chapter = false,
      },
    sealline = {
        show        = true,
        scope       = oddpage,
        circle-show = false,
        line-type   = dotted,
        odd-info-content = {
          {\kaishu 姓名}：{\underline{\hspace*{8em}}},
          {\kaishu 学号}：{\underline{\hspace*{8em}}},
          {\kaishu 学院}：{\underline{\hspace*{8em}}},
          {\kaishu 级}：{\underline{\hspace*{8em}}},
          {\kaishu 专业}：{\underline{\hspace*{8em}}},
          {\kaishu 班}：{\underline{\hspace*{8em}}}
        },
        odd-info-xshift = 12mm,
        line-xshift = 20.5mm,
        text = {装订线内不要答题},
        text-direction-vertical = true,
        text-width = 0.6\textheight,
        text-format  = \normalfont,
        text-xshift = 18mm,
      
      },
    choices/label=(\Alph*),
    scoringbox/type = twocolumn,
    symbols/change-frac-style = true,
    symbols/change-dfrac-style = true,
    solution/blank-type = manual,
    solution/label-content = {\color{blue}{\heiti 解}},
    solution/qedsymbol = {\color{blue}{$\square$}},
    question/show-answer = true,
    problem/show-answer = true,
    paren/show-answer = true,
    fillin/show-answer = true,
    paren/text-color=blue,
    fillin/text-color=blue,
    solution/text-color=blue,
  }

% 根据 exam-zh 版本号进行设置
\@ifclasslater { exam-zh } { 2024/02/12 }
  {
    % 版本大于等于 0.2.1
    \keys_set:nn { exam-zh } {
        solution/show-solution = show-stay,
        textfigure/fig-pos=right,
      }
    \ExamPrintAnswerSet{
        sealline/show=true,
        paren/show-answer=false,
        paren/show-paren=true,
        fillin/show-answer=false,
        solution/show-solution=hide,
        fillin/no-answer-type=none,
      }
  }
  {
    % 版本小于 0.2.1
    \keys_set:nn { exam-zh } { solution/show-answer = true }
    \ExamPrintAnswerSet{
        sealline/show=true,
        paren/show-answer=false,
        paren/show-paren=true,
        fillin/show-answer=false,
        solution/show-solution=false,
        fillin/no-answer-type=none,
      }
  }

% 封面配置
\keys_define:nn { ustb-exam / cover }
  {
    top      .tl_set:N = \l__ustbexam_cover_top,
    title    .tl_set:N = \l__ustbexam_cover_title,
    subtitle .tl_set:N = \l__ustbexam_cover_subtitle,
    author   .tl_set:N = \l__ustbexam_cover_author,
    date     .tl_set:N = \l__ustbexam_cover_date,
    bottom   .tl_set:N = \l__ustbexam_cover_bottom,
    bgimg    .tl_set:N = \l__ustbexam_cover_bgimg,
  }
\keys_set:nn { ustb-exam / cover }
  {
    top      = 北京科技大学,
    title    = 高等数学AI,
    subtitle = 历年期中试卷合集,
    author   = 黄腾,
    date     = \today,
    bottom   = 假装有出版社,
    bgimg    = {},
  }
\keys_define:nn { ustb-exam }
  { cover .meta:nn = { ustb-exam / cover } {#1} }

% 定义 makeCover 命令
\NewDocumentCommand \makeCover { }
  {
    \newgeometry{right=3.5cm, vmargin=2.5cm, headsep=0.5cm}
    \pagestyle{myEmptyPage}
    \begin{titlepage}
      \setcounter{page}{0}
      \tl_if_empty:NF { \l__ustbexam_cover_bgimg }
        {
          \begin{tikzpicture}[remember~picture, overlay]
            \node[opacity=0.2,rotate=30] at ([shift={(-2.0cm, 0)}]current~page.center)
              {
                \includegraphics[width=23cm]{\l__ustbexam_cover_bgimg}
              };
          \end{tikzpicture}
        }

      \centering

      \makebox[0.5\textwidth][s]{\huge \bfseries \l__ustbexam_cover_top}
      \par\addvspace{2.5cm}

      \begin{tcolorbox}
        [
        width=0.8\textwidth, height=4cm,
        halign=center, valign=center,
        blanker,
        frame~hidden, boxsep=0pt,
        borderline~horizontal={2pt}{0pt}{black},
        hyphenationfix,
        ]
        \Huge \bfseries
        \makebox[0.6\textwidth][s]{\l__ustbexam_cover_title}
        \par
        \makebox[0.75\textwidth][s]{\l__ustbexam_cover_subtitle}
      \end{tcolorbox}
      \par\addvspace{1.5cm}

      \parbox{0.4\textwidth}{\Large \centering \l__ustbexam_cover_author}
      \par\addvspace{1cm}

        {\l__ustbexam_cover_date}
      \par\vfill

      \makebox[0.3\textwidth][s]{\large \l__ustbexam_cover_bottom}
    \end{titlepage}
    \restoregeometry
  }

% 添加 RealLastPage 标记
\AddToHook{cmd/makeBackCover/before}{
    % 在正文最后一页打标记
    \zlabel{RealLastPage}
  }
\AddToHook{cmd/backcover/before}{
    % 在正文最后一页打标记
    \zlabel{RealLastPage}
  }

% 定义 makeBackCover 命令
\NewDocumentCommand \makeBackCover { }
  {
    % 移除密封线
    \RemoveFromHook { shipout / background } [ sealline ]

    \clearpage
    \int_if_odd:nTF { \value{page} }
      {
        % 当前页是奇数页，插入一页空白页
        \group_begin:
        \pagestyle{empty}
        \null \newpage
        \group_end:
      }
      {
        % 当前页是偶数页，插入两页空白页
        \group_begin:
        \pagestyle{empty}
        \null \newpage
        \null \newpage
        \group_end:
      }
  }

\NewDocumentEnvironment{analysis}{ O{} }
  {
    \begin{solution}[label-content={\color{blue}{\heiti 解析}},blank-type=none,#1]}{
    \end{solution}
  }
\NewDocumentEnvironment{note}{ O{} }
  {
    \begin{solution}[label-content=【尾注】,text-color=black,show-qed=false,parbreak=true,#1]
      \setlength{\parindent}{2em}}{
    \end{solution}
  }
\RenewDocumentEnvironment{proof}{ O{} }
  {
    \begin{solution}[label-content={\color{blue}{\heiti 证明}},blank-type=manual,#1]}{
    \end{solution}
  }

\DeclareTColorBox{pabox}{ O{ } m O{ blue } }
  {
    colback=#3!5!white,
    colframe=#3!45!gray,
    colbacktitle=#3!5!white,
    coltitle=#3!45!gray,
    titlerule=0mm,
    toprule=0mm,
    bottomrule=0mm,
    rightrule=0mm,
    leftrule=.5mm,
    boxsep=0mm,
    breakable,
    % frame hidden,
    % interior hidden,
    % detach title,
    % sharpish corners,
    fonttitle=\bfseries,
    label=#2,
    % title={\faMortarBoard~ #2},
    #1
  }

\RequirePackage{tikz}
% 不使用 fontawesome，定义替代命令
\NewDocumentCommand{\faMortarBoard}{}{\text{【注】}}

\NewDocumentEnvironment{ notes }{ O{ } o o +b }
  {
    \bool_if:NTF \g__examzh_solution_show_bool
      {
        \begin{pabox}[]{\IfNoValueTF{#2}{#1}{#2}}[#3]
          \group_begin:
          {\color{blue!45!gray} \faMortarBoard~ {\bfseries #1}}
          \smallskip
          \par
          \group_end:
          \begingroup
          #4
          \endgroup
        \end{pabox}
      }
      {}
  }
  {}

\NewDocumentCommand \myref { m o }
  { 详见 第 ~\pageref{#1}~ 页 \IfNoValueTF{#2}{#1}{#2} }

\RequirePackage{mathtools,extarrows}

\RequirePackage{fixdif}
\newdif{\dif}{\mathrm{d}}

\DeclareMathOperator{\re}{e}
\DeclareMathOperator{\ri}{i}
\DeclareMathOperator{\cov}{cov}
\DeclareMathOperator{\sgn}{sgn}
\DeclareMathOperator{\rot}{\mathbf{rot}}
\DeclareMathOperator{\grad}{\mathbf{grad}}
\DeclareMathOperator{\divd}{\mathbf{div}}
\DeclareMathOperator{\ch}{ch}
\DeclareMathOperator{\sh}{sh}
\DeclareMathOperator{\arccot}{arccot}

\NewDocumentCommand \abs { m }
  {\left| #1 \right|}

\renewcommand{\Re}{\operatorname{Re}}
\renewcommand{\Im}{\operatorname{Im}}
\renewcommand{\le}{\leqslant}
\renewcommand{\leq}{\leqslant}
\renewcommand{\ge}{\geqslant}
\renewcommand{\geq}{\geqslant}
\renewcommand{\parallel}{\mathrel{/\mskip-2.5mu/}}

\everymath{\displaystyle}
\allowdisplaybreaks

% 以下为兼容性代码
% ===== 弃用 begin =====

% 试卷头里的年份
\NewDocumentCommand \Year { m }
  { \int_set:Nn \l__ustbexam_title_year_int {#1} }

% 试卷头里的学期
\NewDocumentCommand \Semester { m }
  { \tl_set:Nn \l__ustbexam_title_semester {#1} }

% 试卷头里的课程
\NewDocumentCommand \Course { m }
  { \str_set:Nn \l__ustbexam_title_course_str { #1 } }

% 是否期中
\NewDocumentCommand \Suffix { m }
  { \tl_set:Nn \l__ustbexam_title_suffix_str {#1} }

% 试卷头里的类型，如A/B/模拟等
\NewDocumentCommand \Type { m }
  { \tl_set:Nn \l__ustbexam_title_type_str { #1 } }

% 试卷头计分表中大题的数目
\NewDocumentCommand \TotalPart { m }
  { \int_set:Nn \l__ustbexam_title_total_part_int {#1} }

% 学院
\NewDocumentCommand \College { m }
  { \tl_set:Nn \l__ustbexam_title_college_str {#1} }

% 专业
\NewDocumentCommand \Major { m }
  { \tl_set:Nn \l__ustbexam_title_major_str {#1} }

% 级
\NewDocumentCommand \Grade { m }
  { \tl_set:Nn \l__ustbexam_title_grade_str {#1} }

% 考室
\NewDocumentCommand \ExamRoom { m }
  { \tl_set:Nn \l__ustbexam_title_exam_room_str {#1} }

% 考试类型
\NewDocumentCommand \ExamType { m }
  { \tl_set:Nn \l__ustbexam_title_exam_type_str {#1} }

% 考试时间
\NewDocumentCommand \ExamTime { m }
  { \int_set:Nn \l__ustbexam_title_exam_time_int {#1} }

% 考试类别（考试或考查）
\NewDocumentCommand \ExamCategory { m }
  { \tl_set:Nn \l__ustbexam_title_exam_category_str {#1} }

% 测试类型（normal 或 international）
\NewDocumentCommand \TestType { m }
  { \tl_set:Nn \l__ustbexam_title_test_type_str {#1} }

% PDF 主题信息
\NewDocumentCommand \Subject { m }
  { \str_set:Nn \l__ustbexam_pdf_subject {#1} }

% PDF 关键词信息
\NewDocumentCommand \Keywords { m }
  { \str_set:Nn \l__ustbexam_pdf_keywords {#1} }

\NewDocumentCommand \makehead {}
  {\maketitle}

% 也可以用正则表达式替换
% \\options\{(.+?)\}[%\n ]+\{(.+?)\}[%\n ]+?\{(.+?)\}[%\n ]+?\{(.+?)\}[%\n ]+?\n
% =>
% \\begin{choices}\n\t\t\\item $1\n\t\t\\item $2\n\t\t\\item $3\n\t\t\\item $4\n\t\\end{choices}\n
\NewDocumentCommand \options { m m m m }
  {
    \begin{choices}
      \item #1
      \item #2
      \item #3
      \item #4
    \end{choices}
  }

% 也可以用正则表达式替换
% \\pickout\{([A-D])\} => \\pickout[$1]
\NewDocumentCommand \pickout { m }
  {\paren[#1]}

% 也可以用正则表达式替换
% \\fillin\{(.+)\} => \\fillin[$1]
% % 此处的兼容性代码实在是不会
% \let\savefillin=\fillin
% \AtBeginDocument{
%   \RenewDocumentCommand \fillin { m }
%     {\savefillin[#1]}
%   }

% 也可以用正则表达式替换
% \\makepart\{(.+?)\}\{(.+?)\} => \\section{$1（$2）}
\NewDocumentCommand \makepart { m m }
  {\section{#1（#2）}}

% ===== 弃用 end =====

\NewDocumentCommand \vempty { m }{
    \bool_if:NF \l__examzh_question_show_paren_answer_bool
      {
        \vspace*{#1}
      }
  }
\NewDocumentCommand \mynewpage { }{
    \bool_if:NF \l__examzh_question_show_paren_answer_bool
      {
        \newpage
      }
  }

