% =========================================================================
%  Project:   PENG Engine
%  Version:   0.01
%  Module:    dcg_extension.pl  
%  Date:      2016-01-06 
%  Modified:  2016-01-06
%  Status:    DEMO VERSION !
%  Author:    Rolf Schwitter
%  Copyright: Rolf Schwitter, Macquarie University, 2016
% =========================================================================

% This extension is required so that the PENG grammar works in DCG mode.

% ------------------------------------------------------------------------
% Adjective
% ------------------------------------------------------------------------

adjective([arg:[num:_, ind:I],
	   ref:'+',
           drs:[drs(U1, C1)|D2]-[drs(U1, [C2|C1])|D2],
           ana:N1-[WF|N1],
	   para:P1-[WF|P1],
           tree:[adj_3, WF]])
  -->
  { lexicon([cat:adjective, wfm:WF, evtl:I, con:C2]) }, 
  WF.


% ------------------------------------------------------------------------
% Determiner
% ------------------------------------------------------------------------

determiner([arg:[num:sg, ind:I],
	    fcn:O,
	    qnt:def,
	    ref:'+',
	    drs:D1-D3,
            res:D1-D2,
            sco:D2-D3,
            ana:N-{WF|N},
	    para:P1-[WF|P1],
            tree:[det_4, WF]])
  -->
  { lexicon([cat:determiner, wfm:WF, arg:[num:sg, ind:I], qnt:def]) },
  WF.


% ------------------------------------------------------------------------
% Ordinal number
% ------------------------------------------------------------------------

ordinal([arg:A,
         ref:'+',
         drs:[drs(U1, C1)|Top]-[drs(U1, [C2|C1])|Top],
         ana:N1-[WF|N1],
	 para:P1-[WF|P1],
         tree:[ord, WF]])
  -->
  { lexicon([cat:ordinal, wfm:WF, arg:A, con:C2]) },
  WF.


% ------------------------------------------------------------------------
% Count noun
% ------------------------------------------------------------------------

count_noun([wfm:WF,
            arg:[num:N, ind:I],
            ref:'+',
            drs:[drs(U1, C1)|Top]-[drs([I|U1], [C2|C1])|Top],
            ana:N1-[WF|N1],
            para:P1-[WF|P1],
            tree:[noun_1, WF]])
  -->
 { lexicon([cat:count_noun, wfm:WF, arg:[num:N, ind:I], con:C2]) }, 
 WF.


% ------------------------------------------------------------------------
% String Variable
% ------------------------------------------------------------------------

string_variable([arg:[num:N, ind:I],
                 app:'+',
		 ref:'+',
                 drs:[drs(U1, C1)|Top]-[drs(U1, [C2|C1])|Top],
                 ana:N1-[WF|N1],
	         para:P1-[WF|P1],
                 tree:[svar_2, WF]])
  -->
  { lexicon([cat:string_variable, wfm:WF, arg:[num:N, ind:I], con:[C2]]) }, 
  WF.


% ------------------------------------------------------------------------
% Numeric Variable
% ------------------------------------------------------------------------

numeric_variable([arg:[num:Num1, ind:I1],
                  arg:[num:Num2, ind:I2],
                  app:'+',
		  ref:'+',
                  drs:[drs(U1, C1)|Top]-[drs([I2|U1], [C3, C2|C1])|Top],
                  ana:N1-[WF|N1],
	          para:P1-[WF|P1],
                  tree:[nvar_1, WF]])
  -->
  { lexicon([cat:numeric_variable, wfm:WF, arg:[num:Num1, ind:I1], arg:[num:Num2, ind:I2], con:[C3, C2]]) }, 
  WF.


% ------------------------------------------------------------------------
% Preposition
% ------------------------------------------------------------------------

preposition([wfm:WF,
	     arg:A1,
	     arg:A2,
	     ref:'+', 
             drs:[drs(U1, C1)|Top]-[drs(U1, [C2|C1])|Top],
             ana:N1-[WF|N1],
	     para:P1-[WF|P1],
             tree:[prep_3, WF]])
  -->
  { lexicon([cat:preposition, wfm:WF, arg:A1, arg:A2, con:C2]) }, 
  WF.





