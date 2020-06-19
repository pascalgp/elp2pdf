%
% PostScript prolog.
% Copyright (c) 1995-1998 Markku Rossi.
%
% Author: Markku Rossi <mtr@iki.fi>
%
%
% This file is part of GNU enscript.
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2, or (at your option)
% any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; see the file COPYING.  If not, write to
% the Free Software Foundation, 59 Temple Place - Suite 330,
% Boston, MA 02111-1307, USA.
%

% -- code follows this line --
%
% Procedures.
%

/_S {	% save current state
  /_s save def
} def
/_R {	% restore from saved state
  _s restore
} def

/S {	% showpage protecting gstate
  gsave
  showpage
  grestore
} bind def

/MF {	% fontname newfontname -> -	make a new encoded font
  /newfontname exch def
  /fontname exch def

  /fontdict fontname findfont def
  /newfont fontdict maxlength dict def

  fontdict {
    exch
    dup /FID eq {
      % skip FID pair
      pop pop
    } {
      % copy to the new font dictionary
      exch newfont 3 1 roll put
    } ifelse
  } forall

  newfont /FontName newfontname put

  % insert only valid encoding vectors
  encoding_vector length 256 eq {
    newfont /Encoding encoding_vector put
  } if

  newfontname newfont definefont pop
} def

/MF_PS { % fontname newfontname -> -	make a new font preserving its enc
  /newfontname exch def
  /fontname exch def

  /fontdict fontname findfont def
  /newfont fontdict maxlength dict def

  fontdict {
    exch
    dup /FID eq {
      % skip FID pair
      pop pop
    } {
      % copy to the new font dictionary
      exch newfont 3 1 roll put
    } ifelse
  } forall

  newfont /FontName newfontname put

  newfontname newfont definefont pop
} def

/SF { % fontname width height -> -	set a new font
  /height exch def
  /width exch def

  findfont
  [width 0 0 height 0 0] makefont setfont
} def

/SUF { % fontname width height -> -	set a new user font
  /height exch def
  /width exch def

  /F-gs-user-font MF
  /F-gs-user-font width height SF
} def

/SUF_PS { % fontname width height -> -	set a new user font preserving its enc
  /height exch def
  /width exch def

  /F-gs-user-font MF_PS
  /F-gs-user-font width height SF
} def

/M {moveto} bind def
/s {show} bind def

/Box {	% x y w h -> -			define box path
  /d_h exch def /d_w exch def /d_y exch def /d_x exch def
  d_x d_y  moveto
  d_w 0 rlineto
  0 d_h rlineto
  d_w neg 0 rlineto
  closepath
} def

/bgs {	% x y height blskip gray str -> -	show string with bg color
  /str exch def
  /gray exch def
  /blskip exch def
  /height exch def
  /y exch def
  /x exch def

  gsave
    x y blskip sub str stringwidth pop height Box
    gray setgray
    fill
  grestore
  x y M str s
} def

/bgcs { % x y height blskip red green blue str -> -  show string with bg color
  /str exch def
  /blue exch def
  /green exch def
  /red exch def
  /blskip exch def
  /height exch def
  /y exch def
  /x exch def

  gsave
    x y blskip sub str stringwidth pop height Box
    red green blue setrgbcolor
    fill
  grestore
  x y M str s
} def

% Highlight bars.
% Modifications for Green Bar printout: Pascal Parent <pascalp@ix.netcom.com>
/highlight_bars {	% nlines lineheight output_y_margin gray -> -
  gsave
    /gray exch def
    /ymarg exch def
    /lineheight exch def
    /nlines exch def
    /x_header_y 724 def
    /x_output_w 963 def
    /x_output_h 724 def
    /y_shift nlines 1000 idiv def
    /y_margin 36 y_shift 500 sub 0.0625 mul add def
    /frame_style nlines y_shift 1000 mul sub 10 idiv def
    /nlines nlines 10 mod def

    % This 2 is just a magic number to sync highlight lines to text.
    0 x_header_y ymarg sub 2 sub translate

    /cw x_output_w cols div def
    /nrows x_output_h ymarg 2 mul sub lineheight div cvi def

    1 setlinewidth
    % for each column
    0 1 cols 1 sub {
      cw mul /xp exch def
        % for each rows
        1.00 1.00 1.00 setrgbcolor % frame only background
        gray 1 eq { 0.85 0.97 0.86 setrgbcolor } if  % green bars
        gray 2 eq { 0.86 0.96 1.00 setrgbcolor } if  % blue bars
        gray 3 eq { 1.00 0.96 0.81 setrgbcolor } if  % orange bars
        gray 4 eq { 0.90 0.90 0.90 setrgbcolor } if  % gray bars
        0 1 nrows 1 sub {
          /rn exch def
          rn lineheight mul neg /yp exch def
          rn nlines idiv 2 mod 1 eq { 
 	    % Draw highlight bar.  4 is just a magic indentation.
	    xp 4 add yp y_margin add cw 8 sub lineheight 0.5 add neg Box fill
	  } if
        } for
        % for each rows
        0.00 0.00 0.00 setrgbcolor % frame only outline
        gray 1 eq { 0.52 0.93 0.52 setrgbcolor } if  % green outline
        gray 2 eq { 0.59 0.94 0.92 setrgbcolor } if  % blue outline
        gray 3 eq { 0.97 0.87 0.66 setrgbcolor } if  % orange outline
        gray 4 eq { 0.75 0.75 0.75 setrgbcolor } if  % gray outline
        1 1 nrows 1 sub {
          /rn exch def
          rn lineheight mul neg /yp exch def
          rn nlines 2 mul mod 0 eq {
  	    % Draw bar outline
	    xp 4 add yp y_margin add moveto
            cw 8 sub 0 rlineto
            stroke
	  } if
          rn nlines 2 mul mod nlines eq {
  	    % Draw bar outline
	    xp 4 add yp y_margin add gray 0 eq {0} {0.5} ifelse sub moveto
            cw 8 sub 0 rlineto
            stroke
	  } if
        } for
    } for

    % Reset coordinate system
    0 0 x_header_y ymarg sub 2 sub sub translate

    frame_style 0 eq {
        % Draw normal page outline
        3.625 y_margin moveto
        0 x_output_h 4 sub rlineto
        x_output_w 7.25 sub 0 rlineto
        0 x_output_h 4 sub neg rlineto
        closepath stroke
    } if
    frame_style 1 eq {
        % Draw tall page outline
        3.625 y_margin moveto
        0 x_output_h 19.9375 add rlineto
        x_output_w 7.25 sub 0 rlineto
        0 x_output_h 19.9375 add neg rlineto
        closepath stroke
    } if
    frame_style 2 eq {
        % No page outline
        3.625 y_margin moveto
        x_output_w 7.25 sub 0 rlineto
        closepath stroke
    } if

  grestore
} def

% Line highlight bar.
/line_highlight {	% x y width height gray -> -
  gsave
    /gray exch def
    Box gray setgray fill
  grestore
} def

% Column separator lines.
/column_lines {
  gsave
    .1 setlinewidth
    0 d_footer_h translate
    /cw d_output_w cols div def
    1 1 cols 1 sub {
      cw mul 0 moveto
      0 d_output_h rlineto stroke
    } for
  grestore
} def

% Column borders.
/column_borders {
  gsave
    .1 setlinewidth
    0 d_footer_h moveto
    0 d_output_h rlineto
    d_output_w 0 rlineto
    0 d_output_h neg rlineto
    closepath stroke
  grestore
} def

% Do the actual underlay drawing
/draw_underlay {
  ul_style 0 eq {
    ul_str true charpath stroke
  } {
    ul_str show
  } ifelse
} def

% Underlay
/underlay {	% - -> -
  gsave
    0 d_page_h translate
    d_page_h neg d_page_w atan rotate

    ul_gray setgray
    ul_font setfont
    /dw d_page_h dup mul d_page_w dup mul add sqrt def
    ul_str stringwidth pop dw exch sub 2 div ul_h_ptsize -2 div moveto
    draw_underlay
  grestore
} def

/user_underlay {	% - -> -
  gsave
    ul_x ul_y translate
    ul_angle rotate
    ul_gray setgray
    ul_font setfont
    0 0 ul_h_ptsize 2 div sub moveto
    draw_underlay
  grestore
} def

% Page prefeed
/page_prefeed {		% bool -> -
  statusdict /prefeed known {
    statusdict exch /prefeed exch put
  } {
    pop
  } ifelse
} def

% Wrapped line markers
/wrapped_line_mark {	% x y charwith charheight type -> -
  /type exch def
  /h exch def
  /w exch def
  /y exch def
  /x exch def

  type 2 eq {
    % Black boxes (like TeX does)
    gsave
      0 setlinewidth
      x w 4 div add y M
      0 h rlineto w 2 div 0 rlineto 0 h neg rlineto
      closepath fill
    grestore
  } {
    type 3 eq {
      % Small arrows
      gsave
        .2 setlinewidth
        x w 2 div add y h 2 div add M
        w 4 div 0 rlineto
        x w 4 div add y lineto stroke

        x w 4 div add w 8 div add y h 4 div add M
        x w 4 div add y lineto
	w 4 div h 8 div rlineto stroke
      grestore
    } {
      % do nothing
    } ifelse
  } ifelse
} def

% EPSF import.

/BeginEPSF {
  /b4_Inc_state save def    		% Save state for cleanup
  /dict_count countdictstack def	% Count objects on dict stack
  /op_count count 1 sub def		% Count objects on operand stack
  userdict begin
  /showpage { } def
  0 setgray 0 setlinecap
  1 setlinewidth 0 setlinejoin
  10 setmiterlimit [ ] 0 setdash newpath
  /languagelevel where {
    pop languagelevel
    1 ne {
      false setstrokeadjust false setoverprint
    } if
  } if
} bind def

/EndEPSF {
  count op_count sub { pos } repeat	% Clean up stacks
  countdictstack dict_count sub { end } repeat
  b4_Inc_state restore
} bind def

% Check PostScript language level.
/languagelevel where {
  pop /gs_languagelevel languagelevel def
} {
  /gs_languagelevel 1 def
} ifelse
