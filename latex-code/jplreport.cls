\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{jplreport}

% Base class
\LoadClass[12pt,a4paper,oneside]{report}

%variables
\interfootnotelinepenalty=10000

% Required packages
\RequirePackage[english]{babel}

\RequirePackage{tikz}
\RequirePackage{tikz-3dplot}
\usetikzlibrary{arrows.meta}

\RequirePackage{xparse}
\RequirePackage{amsmath,amssymb,amsfonts}
\RequirePackage[margin=1in]{geometry}
\RequirePackage{setspace}
\RequirePackage{siunitx}
\RequirePackage{booktabs}

\RequirePackage{fontspec}

\RequirePackage{titlesec}
\RequirePackage{fancyhdr}

\RequirePackage{hyperref}
\hypersetup{
  colorlinks=true,
  linkcolor=blue,
  citecolor=blue,
  urlcolor=blue,
  pdfauthor={Federico Ajmone Marsan},
  pdftitle={Final Internship Report}
}
\RequirePackage{graphicx}

\RequirePackage{float}
\RequirePackage{cleveref}

\RequirePackage{pgfplots}
\RequirePackage{cite}
\RequirePackage{tikz}
\RequirePackage{tikz-3dplot} 
\usetikzlibrary{positioning}
\usetikzlibrary{fit}
\usetikzlibrary{calc}
\usetikzlibrary{shapes}

\RequirePackage{bm}
\RequirePackage{array}
\RequirePackage[table]{xcolor}

\RequirePackage[bottom]{footmisc}
\RequirePackage{hyperref} 

\RequirePackage[most]{tcolorbox}
\RequirePackage{empheq}

\RequirePackage{mismath}
\RequirePackage[dvipsnames]{xcolor}

\RequirePackage{caption}
\RequirePackage{subcaption}
\captionsetup{skip=0pt}
\setlength{\abovecaptionskip}{7pt}
\setlength{\belowcaptionskip}{0pt}


% Page geometry
\geometry{a4paper, margin=1in}

% Custom commands
\NewDocumentCommand{\tran}{m}{{\mathbf{#1}}^{\mathsf{T}}}
\NewDocumentCommand{\conj}{m}{\overline{#1}}
\NewDocumentCommand{\herm}{m}{{\mathbf{#1}}^{\mathsf{H}}}

\newcommand{\prob}[1]{\mathbb{P}\left[{#1}\right]}
\newcommand{\mean}[1]{\mathbb{E}\left[{#1}\right]}
\newcommand{\vari}[1]{\mathrm{Var}\left[{#1}\right]}
\newcommand{\covi}[1]{\mathrm{Cov}\left[{#1}\right]}

\DeclareMathOperator*{\argmax}{argmax\;}
\DeclareMathOperator*{\argmin}{argmin\;}

\newcommand{\HRule}{\rule{\linewidth}{1.2pt}}

% Font setup (XeLaTeX)
\defaultfontfeatures{Ligatures=TeX}
\setmainfont{EB Garamond}
\setsansfont{Latin Modern Sans}
\setmonofont{Latin Modern Mono}

% Section formatting
\titleformat{\section}{\normalfont\Large\bfseries}{\thesection}{1em}{}  
\titleformat{\subsection}{\normalfont\large\bfseries}{\thesubsection}{1em}{}
\titleformat{\subsubsection}{\normalfont\normalsize\bfseries}{\thesubsubsection}{1em}{}

% Hyperref settings
\hypersetup{
  colorlinks=true,
  linkcolor=black,
  urlcolor=black,
  pdftitle={JPL Report},
  pdfauthor={Federico Ajmone Marsan},
}

\renewcommand{\maketitle}{
  \begin{center}
    {\Huge \@title \par}
    \vspace{1em}
    {\Large \@author \par}
    \vspace{1em}
    {\large \@date \par}
    \vspace{1em}
  \end{center}
}