% =========================================================================
%  Project:   PENG Engine
%  Version:   0.01
%  Module:    grammar.pl
%  Date:      2012-04-22   
%  Modified:  2016-09-25
%  Status:    DEMO VERSION !
%  Author:    Rolf Schwitter
%  Copyright: Rolf Schwitter, Macquarie University, 2016
% =========================================================================


% -------------------------------------------------------------------------
% Style check
% -------------------------------------------------------------------------

:- no_style_check(singleton).
:- no_style_check(discontiguous).
 

% -------------------------------------------------------------------------
% Tracer
% -------------------------------------------------------------------------

tracer(List) :-
   write('Tracer: '),
   write(List),
   nl, nl.


% -------------------------------------------------------------------------
% Discourse
%
% -------------------------------------------------------------------------

discourse_element([drs:D, ana:N1-N3, para:P1-P3, tree:T1]) -->
  sentence_3([crd:_, drs:D, ana:N1-N2, para:P1-P2, tree:T1]),   
  full_stop([wfm:['.'], ana:N2-N3, para:P2-P3, tree:T2]).


discourse_element([drs:D, ana:N1-N3, para:P1-P3, tree:T1]) -->
  question([crd:_, drs:D, ana:N1-N2, para:P1-P2, tree:T1]),   
  question_mark([wfm:['?'], ana:N2-N3, para:P2-P3, tree:T2]).
 

% ------------------------------------------------------------------------
% Questions
%
% ------------------------------------------------------------------------

question([crd:_,
	  drs:[drs(U1, C1)|Top]-
	       [drs(U1, [drs(U3, C3) ==> drs([], [ans(I2)])|C1])|Top],
          ana:N1-N5,
	  para:P1-P5,
          tree:[q_1, WhA, Cop, Name, Prep]])
  -->
  wh_adverb([wfm:WF1, ana:N1-N2, para:P1-P2, tree:WhA]),
  copula([wfm:WF2, arg:[num:N1, ind:I1], vform:V, evtl:S, drs:D2-D3, ana:N2-N3, para:P2-P3, tree:Cop]),
  name([arg:[num:N1, ind:I1], drs:[drs(U2, C2)]-D2, ana:N3-N4, para:P3-P4, tree:Name]),
  preposition([wfm:WF4, evtl:S, arg:[num:N2, ind:I2], drs:D3-[drs(U3, C3)], ana:N4-N5, para:P4-P5, tree:Prep]).


% -------------------------------------------------------------------------

% fix negative case
question([crd:_, drs:[drs(U1, C1)|Top]-
	             [drs(U1, [drs(U3, [CAdj, CCop|C3]) ==> drs([], [ans(yes_no, yes, pos)])|C1])|Top],
          ana:N1-N4,
	  para:P1-P4,
          tree:[q_2, [Cop, Name, Adj]]])
  -->
  copula([wfm:['Is'], arg:[num:sg, ind:I1], vform:V, evtl:S, drs:D2-D3, ana:N1-N2, para:P1-P2, tree:Cop]),
  name([arg:[num:sg, ind:I1], drs:[drs(U2, C2)]-D2, ana:N2-N3, para:P2-P3, tree:Name]),
  adjective([evtl:S, con:C, drs:D3-[drs(U3, [CAdj, CCop|C3])], ana:N3-N4, para:P3-P4, tree:Adj]).


% fix negative case
question([crd:_, drs:[drs(U1, C1)|Top]-
	             [drs(U1, [drs([I2, S|U3], [CName, CRel, CCop|C3]) ==> drs([], [ans(yes_no, yes, pos)])|C1])|Top],
          ana:N1-N5,
	  para:P1-P5,
          tree:[q_3, [Cop, Name1, RAdj, Name2]]])
  -->
  copula([wfm:['Is'], arg:[num:sg, ind:I1], vform:V, evtl:S, drs:D2-D3, ana:N1-N2, para:P1-P2, tree:Cop]),
  name([arg:[num:sg, ind:I1], drs:[drs(U2, C2)]-D2, ana:N2-N3, para:P2-P3, tree:Name1]),
  relational_adjective([evtl:S, arg:[num:sg, ind:I2], con:C, drs:D3-D4, ana:N3-N4, para:P3-P4, tree:RAdj]),
  name([arg:[num:sg, ind:I2], drs:D4-[drs([I2, S|U3], [CName, CRel, CCop|C3])], ana:N4-N5, para:P4-P5, tree:Name2]).

  
% -------------------------------------------------------------------------

% Who works?
% Who is afraid of math?
%
question([crd:_, 
          drs:D1-[drs(U2, [D3 ==> drs([], [ans(who, inst(I1, I2), pos)])|C2])|D4],
          ana:N1-N3,
	  para:P1-P3,
          tree:[q_4, [np, WhP], VP]])
  -->
  wh_pronoun([wfm:['Who'],
              arg:[num:sg, ind:I1], 
              drs:[drs([], [])|D1]-[D3, drs(U2, C2)|D4],
              res:[drs([], [])|D1]-[drs(U1, [query(I1, who, I2)|C1])|D1], 
              sco:[drs(U1, [query(I1, who, I2)|C1])|D1]-D2,
              ana:N1-N2, 
              para:P1-P2, 
              tree:WhP]),  
  verb_phrase([crd:_, 
               arg:[num:sg, ind:I1], 
               loc:query,
               inv:no,
               gap:[]-[],
               pol:pos,
               evtl:E,
               drs:[drs(U1, [query(I1, who, I2)|C1])|D1]-[D3, drs(U2, C2)|D4],
               ana:N2-N3, 
               para:P2-P3, 
               tree:VP]). 


% Who does not work?
% Who is not afraid of math?
%
question([crd:_, 
          drs:D1-[drs(U2, [drs(U3, [neg D4|C3]) ==> drs([], [ans(who, inst(I1, I2), neg)])|C2])|D6],
          ana:N1-N3,
	  para:P1-P3,
          tree:[q_5, [np, WhP], VP]])
  -->
  wh_pronoun([wfm:['Who'],
              arg:[num:sg, ind:I1], 
              drs:[drs([], [])|D1]-[drs(U3, [neg D4|C3]), drs(U2, C2)|D6],
              res:[drs([], [])|D1]-[drs(U1, [query(I1, who, I2)|C1])|D1], 
              sco:[drs(U1, [query(I1, who, I2)|C1])|D1]-D2,
              ana:N1-N2, 
              para:P1-P2, 
              tree:WhP]),  
  verb_phrase([crd:_, 
               arg:[num:sg, ind:I1], 
               loc:query,
               inv:no,
               gap:[]-[],
               pol:neg,
               evtl:E,
               drs:[drs(U1, [query(I1, who, I2)|C1])|D1]-[drs(U3, [neg D4|C3]), drs(U2, C2)|D6],
               ana:N2-N3, 
               para:P2-P3, 
               tree:VP]). 


% -------------------------------------------------------------------------

% Who holds which jobs?
%
question([crd:_, 
          drs:D1-[drs(U2, [D4 ==> drs([], [ans(who_rel, C, pos)])|C2])|D6],
          ana:N1-N3,
	  para:P1-P3,
          tree:[q_6, [np, WhP], VP]])
  -->
  wh_pronoun([wfm:['Who'],
              arg:[num:sg, ind:I1], 
              drs:[drs([], [])|D1]-[D4, drs(U2, C2)|D6],
              res:[drs([], [])|D1]-[drs(U1, [query(I1, who, I2)|C1])|D1], 
              sco:[drs(U1, [query(I1, who, I2)|C1])|D1]-D2,
              ana:N1-N2, 
              para:P1-P2, 
              tree:WhP]),  
  verb_phrase([crd:_, 
               arg:[num:sg, ind:I1], 
               loc:query,
               inv:no,
               gap:[]-[],
               pol:pos,
               evtl:E,
               con:C,
               drs:[drs(U1, [query(I1, who, I2)|C1])|D1]-[D4, drs(U2, C2)|D6],
               ana:N2-N3, 
               para:P2-P3, 
               tree:VP]). 


% Who does not hold which jobs?
%
question([crd:_, 
          drs:D1-[drs(U2, [drs(U3, [neg D4|C3]) ==> drs([], [ans(who_rel, C, neg)])|C2])|D6],
          ana:N1-N3,
	  para:P1-P3,
          tree:[q_7, [np, WhP], VP]])
  -->
  wh_pronoun([wfm:['Who'],
              arg:[num:sg, ind:I1], 
              drs:[drs([], [])|D1]-[drs(U3, [neg D4|C3]), drs(U2, C2)|D6],
              res:[drs([], [])|D1]-[drs(U1, [query(I1, who, I2)|C1])|D1], 
              sco:[drs(U1, [query(I1, who, I2)|C1])|D1]-D2,
              ana:N1-N2, 
              para:P1-P2, 
              tree:WhP]),  
  verb_phrase([crd:_, 
               arg:[num:sg, ind:I1], 
               loc:query,
               inv:no,
               gap:[]-[],
               pol:neg,
               evtl:E,
               con:C,
               drs:[drs(U1, [query(I1, who, I2)|C1])|D1]-[drs(U3, [neg D4|C3]), drs(U2, C2)|D6],
               ana:N2-N3, 
               para:P2-P3, 
               tree:VP]). 


% -------------------------------------------------------------------------

% What holds at 09:30?   --> fix
%
question([crd:_, 
          drs:D1-[drs(U2, [D4 ==> drs([], [ans(what, C, pos)])|C2])|D6],
          ana:N1-N3,
	  para:P1-P3,
          tree:[q_8, [np, WhP], VP]])
  -->
  wh_pronoun([wfm:['What'],
              arg:[num:sg, ind:I1], 
              drs:[drs([], [])|D1]-[D4, drs(U2, C2)|D6],
              res:[drs([], [])|D1]-[drs(U1, [query(I1, what, I2)|C1])|D1], 
              sco:[drs(U1, [query(I1, what, I2)|C1])|D1]-D2,
              ana:N1-N2, 
              para:P1-P2, 
              tree:WhP]),  
  verb_phrase([crd:_, 
               arg:[num:sg, ind:I1], 
               loc:query,
               inv:no,
               gap:[]-[],
               pol:pos,
               evtl:E,
               con:C,
               drs:[drs(U1, [query(I1, what, I2)|C1])|D1]-[D4, drs(U2, C2)|D6],
               ana:N2-N3, 
               para:P2-P3, 
               tree:VP]). 


% -------------------------------------------------------------------------


% Which company does Fairfax Media Limited own?
%
question([crd:_, 
          drs:D1-[drs(U1, [D5 ==> drs([], [ans(which, C, pos)])|C1])|D6],
          ana:N1-N4,
	  para:P1-P4,
          tree:[q_9, [np, WhD, Noun], VP]])
  -->

  wh_determiner([wfm:['Which'],
                 arg:A,
                 drs:[drs([], [])|D1]-[D4, drs(U1, C1)|D6],
                 res:[drs([], [])|D1]-D2,
                 sco:D3-S,
                 ana:N1-N2,
	         para:P1-P2,
                 tree:WhD]),
  count_noun([wfm:WF,
              arg:A, 
              drs:D2-D3, 
              ana:_-_, 
              para:P2-P3, 
              tree:Noun]),
  verb_phrase([crd:_, 
               arg:A, 
               loc:query,
               inv:yes,
               gap:[np]-[],
               pol:pos,
               evtl:E,
               con:C,
               drs:D3-[D5, drs(U1, C1)|D6],
               ana:N2-N4, 
               para:P3-P4, 
               tree:VP]).


% Which company does Fairfax Media Limited not own?  TO BE FIXED
%
question([crd:_, 
          drs:D1-[drs(U1, [drs(U3, [neg D4|C3]) ==> drs([], [ans(which, C, neg)])|C1])|D6],
          ana:N1-N4,
	  para:P1-P4,
          tree:[q_10, [np, WhD, Noun], VP]])
  -->

  wh_determiner([wfm:['Which'],
                 arg:A1,
                 drs:[drs([], [])|D1]-[drs(U3, [neg D4|C3]), drs(U1, C1)|D6],
                 res:[drs([], [])|D1]-D2,
                 sco:D3-S,
                 ana:N1-N2,
	         para:P1-P2,
                 tree:WhD]),
  count_noun([wfm:WF,
              arg:A1,
              drs:D2-D3, 
              ana:_-_, 
              para:P2-P3, 
              tree:Noun]),
  verb_phrase([crd:_, 
               arg:A1,
               loc:query,
               inv:no,
               gap:[]-[],
               pol:neg,
               evtl:E, 
               con:C,
               drs:D3-[drs(U3, [neg D4|C3]), drs(U1, C1)|D6],
               ana:N2-N4, 
               para:P3-P4, 
               tree:VP]).


% -------------------------------------------------------------------------

% Which runner is allocated to what position?
%
question([crd:_, 
          drs:D1-[drs(U1, [D5 ==> drs([], [ans(which, C, pos)])|C1])|D6],
          ana:N1-N4,
	  para:P1-P4,
          tree:[q_9, [np, WhD, Noun], VP]])
  -->

  wh_determiner([wfm:['Which'],
                 arg:A,
                 drs:[drs([], [])|D1]-[D4, drs(U1, C1)|D6],
                 res:[drs([], [])|D1]-D2,
                 sco:D3-S,
                 ana:N1-N2,
	         para:P1-P2,
                 tree:WhD]),
  count_noun([wfm:WF,
              arg:A, 
              drs:D2-D3, 
              ana:_-_, 
              para:P2-P3, 
              tree:Noun]),
  verb_phrase([crd:_, 
               arg:A, 
               loc:query,
               inv:no,
               gap:[]-[],
               pol:pos,
               evtl:E,
               con:C,
               drs:D3-[D5, drs(U1, C1)|D6],
               ana:N2-N4, 
               para:P3-P4, 
               tree:VP]).


% Which student does not work?
%
question([crd:_, 
          drs:D1-[drs(U1, [drs(U3, [neg D4|C3]) ==> drs([], [ans(which, C, neg)])|C1])|D6],
          ana:N1-N4,
	  para:P1-P4,
          tree:[q_10, [np, WhD, Noun], VP]])
  -->

  wh_determiner([wfm:['Which'],
                 arg:A1,
                 drs:[drs([], [])|D1]-[drs(U3, [neg D4|C3]), drs(U1, C1)|D6],
                 res:[drs([], [])|D1]-D2,
                 sco:D3-S,
                 ana:N1-N2,
	         para:P1-P2,
                 tree:WhD]),
  count_noun([wfm:WF,
              arg:A1,
              drs:D2-D3, 
              ana:_-_, 
              para:P2-P3, 
              tree:Noun]),
  verb_phrase([crd:_, 
               arg:A1,
               loc:query,
               inv:no,
               gap:[]-[],
               pol:neg,
               evtl:E, 
               con:C,
               drs:D3-[drs(U3, [neg D4|C3]), drs(U1, C1)|D6],
               ana:N3-N4, 
               para:P3-P4, 
               tree:VP]).


% -------------------------------------------------------------------------

% Where does Alice work?
% Where does Alice teach Bob?
%
question([crd:_, 
          drs:D1-[drs(U1, [D2 ==> drs([], [ans(where, (I2, Class), pos)])|C1])|D3],
          ana:N1-N5,
	  para:P1-P5,
          tree:[q_99, WhD, Aux, NP, VP]])
  -->
   wh_adverb([ wfm:['Where'],
	       arg:[num:_, ind:I2],	   
	       evtl:E,   
               drs:[drs([], [])|D0]-[drs(U0, [prop(E, I2, Sym)])|D0],
               ana:N1-N2,
	       para:P1-P2,
               tree:WhD]),
  auxiliary([  wfm:[does],
               arg:A,
               ana:N2-N3,
               para:P2-P3,
               tree:Aux]),
  noun_phrase([arg:A,
	       loc:L,
	       fcn:wsubj,
	       qnt:Q,
	       drs:[drs([I2, Class], [query(I2, where, Class)])|D1]-[D2, drs(U1, C1)|D3],
	       sco:S,
	       ana:N3-N4,
	       para:P3-P4,
	       tree:NP]),
  verb_phrase([crd:_, 
               arg:A, 
               loc:query,
               inv:yes,
               gap:[prop(E, I2, Sym)]-[],
               pol:pos,
               evtl:E,
               drs:S,
               ana:N4-N5, 
               para:P4-P5, 
               tree:VP]).


% Where does Alice not work?
% Where does Alice not teach Bob?
%
question([crd:_,
	  drs:D1-[drs(U1, [drs(U3, [neg D2|C3]) ==> drs([], [ans(where, (I2, Class), neg)])|C1])|D4],
          ana:N1-N5,
	  para:P1-P5,
          tree:[q_99, WhD, Aux, NP, VP]])
  -->
  wh_adverb([  wfm:['Where'],
	       arg:[num:_, ind:I2],	   
	       evtl:E,   
               drs:[drs([], [])|D0]-[drs(U0, [prop(E, I2, Sym)])|D0],
               ana:N1-N2,
	       para:P1-P2,
               tree:WhD]),
  auxiliary([  wfm:[does],
               arg:A,
               ana:N2-N3,
               para:P2-P3,
               tree:Aux]),
  noun_phrase([arg:A,
	       loc:L,
	       fcn:wsubj,
	       qnt:Q,
               drs:[drs([I2, Class], [query(I2, where, Class)])|D1]-[drs(U3, [neg D2|C3]), drs(U1, C1)|D4],
	       sco:S,
	       ana:N3-N4,
	       para:P3-P4,
	       tree:NP]),
  verb_phrase([crd:_, 
               arg:A, 
               loc:query,
               inv:yes,  
               gap:[does, prop(E, I2, Sym)]-[],
               pol:neg,
               evtl:E,
               drs:S,
               ana:N4-N5, 
               para:P4-P5, 
               tree:VP]).


% -------------------------------------------------------------------------

% Where is Alice?
%
question([crd:_, 
          drs:D1-[drs(U1, [D4 ==> drs([], [ans(where, (I2, Class), pos)])|C1])|D5],
          ana:N1-N4,
	  para:P1-P4,
          tree:[q_99, WhD, Cop, NP]])
  -->
   wh_adverb([ wfm:['Where'],
	       arg:[num:_, ind:I2],	   
	       evtl:E,   
               drs:[drs([], [])|D0]-[drs(U0, [prop(E, I2, Sym)])|D0],
               ana:N1-N2,
	       para:P1-P2,
               tree:WhD]),
   copula([wfm:WF,
   	   arg:A,
           vform:fin,
           evtl:E,
           drs:[drs(U3, [prop(E, I2, Sym)|C3])|D3]-S2,
           ana:N2-N3,
    	   para:P2-P3,
           tree:Cop]),
   noun_phrase([arg:A,
	       loc:L,
	       fcn:wsubj,
	       qnt:Q,
	       drs:[drs([I2, Class], [query(I2, where, Class)])|D1]-[D4, drs(U1, C1)|D5],
	       sco:[drs(U3, C3)|D3]-S2,
	       ana:N3-N4,
	       para:P3-P4,
	       tree:NP]).


% -------------------------------------------------------------------------

% Where is Alice not?
%
question([crd:_,
	  drs:D1-[drs(U1, [drs(U3, [neg D3|C3]) ==> drs([], [ans(where, (I2, Class), neg)])|C1])|D4],
          ana:N1-N5,
	  para:P1-P5,
          tree:[q_99, WhD, Cop, NP, Neg]])
  -->
  wh_adverb([wfm:['Where'],
	     arg:[num:_, ind:I2],	   
	     evtl:E,   
             drs:[drs([], [])|D0]-[drs(U0, [prop(E, I2, Sym)])|D0],
             ana:N1-N2,
	     para:P1-P2,
             tree:WhD]),
  copula([wfm:WF,
   	   arg:A,
           vform:fin,
           evtl:E,
           drs:[drs([], [prop(E, I2, Sym)]), drs(U2, C2)|D2]-[D3, drs(U3, C3), drs(U1, C1)|D4],
           ana:N2-N3,
    	   para:P2-P3,
           tree:Cop]),   
  noun_phrase([arg:A,
	       loc:L,
	       fcn:wsubj,
	       qnt:Q,
               %% drs:[drs([I2, Class], [query(I2, where, Class)])|D1]-[D2, drs(U1, C1)|D3],
	       drs:[drs([I2, Class], [query(I2, where, Class)])|D1]-_,
	       sco:[drs(U2, C2)|D2]-S2,
	       ana:N3-N4,
	       para:P3-P4,
	       tree:NP]),  
  negation([wfm:[not],
	    ana:N4-N5,
	    para:P4-P5,
	    tree:Neg]).
  

% -------------------------------------------------------------------------

% How many students work?
%
question([crd:_, 
          drs:D1-[drs(U1, [D4 ==> drs([], [eval(how_many, I, pos)])|C1])|D6],
          ana:N1-N4,
	  para:P1-P4,
          tree:[q_11, [np, WhD, Noun], VP]])
  -->

  wh_determiner([wfm:['How', many],
                 arg:[num:pl, ind:I],
                 drs:[drs([], [])|D1]-[D4, drs(U1, C1)|D6],
                 res:[drs([], [])|D1]-D2,
                 sco:D3-S,
                 ana:N1-N2,
	         para:P1-P2,
                 tree:WhD]),
  count_noun([wfm:WF,
              arg:[num:pl, ind:I],
              drs:D2-D3, 
              ana:_-_, 
              para:P2-P3, 
              tree:Noun]),
  verb_phrase([crd:_, 
               arg:[num:pl, ind:I],
               loc:query,
               inv:no,
               gap:[]-[],
               pol:pos,
               evtl:E, 
               drs:D3-[D4, drs(U1, C1)|D6],
               ana:N2-N4, 
               para:P3-P4, 
               tree:VP]).


% How many students do not work?
%
question([crd:_, 
          drs:D1-[drs(U1, [drs(U3, [neg D4|C3]) ==> drs([], [eval(how_many, I, neg)])|C1])|D6],
          ana:N1-N4,
	  para:P1-P4,
          tree:[q_12, [np, WhD, Noun], VP]])
  -->
  wh_determiner([wfm:['How', many],
                 arg:[num:pl, ind:I],
                 drs:[drs([], [])|D1]-[drs(U3, [neg D4|C3]), drs(U1, C1)|D6],
                 res:[drs([], [])|D1]-D2,
                 sco:D3-S,
                 ana:N1-N2,
	         para:P1-P2,
                 tree:WhD]),
  count_noun([wfm:WF,
              arg:[num:pl, ind:I],
              drs:D2-D3, 
              ana:_-_, 
              para:P2-P3, 
              tree:Noun]),
  verb_phrase([crd:_, 
               arg:[num:pl, ind:I],
               loc:query,
               inv:no,
               gap:[]-[],
               pol:neg,
               evtl:E, 
               drs:D3-[drs(U3, [neg D4|C3]), drs(U1, C1)|D6],
               ana:N2-N4, 
               para:P3-P4, 
               tree:VP]).


% -------------------------------------------------------------------------

% Does a student work?


question([crd:_, 
          drs:D1-[drs(U1, [D4 ==> drs([], [ans(yes_no, yes, pos)])|C1])|D6],
          ana:N1-N5,
	  para:P1-P5,
          tree:[q_13_b, [Aux, [np, Det, Noun], VP]]])
  -->
  auxiliary([wfm:['Does'],
             arg:[num:sg, ind:I],
             ana:N1-N2,
             para:P1-P2,
             tree:Aux]),  
  determiner([arg:[num:sg, ind:I],
	      fcn:subj,
	      qnt:exist,
	      drs:[drs([], [])|D1]-[D4, drs(U1, C1)|D6],
              res:[drs([], [])|D1]-D2,
              sco:D2-D3,
              ana:_N2-_N3,
	      para:P2-P3,
              tree:Det]), 
  count_noun([wfm:WF,
              arg:[num:sg, ind:I],
              drs:[drs([], [])|D1]-D2,
              ana:_-_, 
              para:P3-P4, 
              tree:Noun]), 
  verb_phrase([crd:_, 
               arg:[num:_, ind:I],
	       vform:inf,
               loc:query, 
               inv:yes,
               gap:[do]-[],
               pol:pos,
               evtl:E,
               drs:D2-[D4, drs(U1, C1)|D6],
               ana:N2-N5, 
               para:P4-P5, 
               tree:VP]).


% -------------------------------------------------------------------------

% Does a student not work?
%

question([crd:_, 
	  drs:D1-[drs(U1, [drs(U3, [neg D4|C3]) ==> drs([], [ans(yes_no, yes, neg)])|C1])|D6],
          ana:N1-N5,
	  para:P1-P5,
          tree:[q_13_b, [Aux, [np, Det, Noun], VP]]])
  -->
  auxiliary([wfm:['Does'],
             arg:[num:sg, ind:I],
             ana:N1-N2,
             para:P1-P2,
             tree:Aux]),  
  determiner([arg:[num:sg, ind:I],
	      fcn:subj,
	      qnt:exist,
	      drs:[drs([], [])|D1]-[drs(U3, [neg D4|C3]), drs(U1, C1)|D6],
              res:[drs([], [])|D1]-D2,
              sco:D2-D3,
              ana:_-_,
	      para:P2-P3,
              tree:Det]), 
  count_noun([wfm:WF,
              arg:[num:sg, ind:I],
              drs:[drs([], [])|D1]-D2,
              ana:_-_, 
              para:P3-P4, 
              tree:Noun]), 
  verb_phrase([crd:_, 
               arg:[num:_, ind:I],
	       vform:inf,
               loc:query, 
               inv:yes,
               gap:[do]-[],
               pol:neg,
               evtl:E,
               drs:D2-[drs(U3, [neg D4|C3]), drs(U1, C1)|D6],
               ana:N2-N5, 
               para:P4-P5, 
               tree:VP]).


% -------------------------------------------------------------------------

% Does John work?


question([crd:_, 
          drs:D1-[drs(U1, [D4 ==> drs([], [ans(yes_no, yes, pos)])|C1])|D6],
          ana:N1-N5,
	  para:P1-P4,
          tree:[q_13_b, [Aux, [np, Name], VP]]])
  -->
  auxiliary([wfm:['Does'],
             arg:[num:sg, ind:I],
             ana:N1-N2,
             para:P1-P2,
             tree:Aux]),
  name([     arg:[num:sg, ind:I],
    	     drs:[drs([], [])|D1]-D2,
	     ana:_-_,
	     para:P2-P3,
	     tree:Name]),
  verb_phrase([crd:_, 
               arg:[num:_, ind:I],
	       vform:inf,
               loc:query, 
               inv:yes,
               gap:[do]-[],
               pol:pos,
               evtl:E,
               drs:D2-[D4, drs(U1, C1)|D6],
               ana:N2-N5, 
               para:P3-P4, 
               tree:VP]).


% -------------------------------------------------------------------------

% Does John not work?
%

question([crd:_, 
	  drs:D1-[drs(U1, [drs(U3, [neg D4|C3]) ==> drs([], [ans(yes_no, yes, neg)])|C1])|D6],
          ana:N1-N5,
	  para:P1-P4,
          tree:[q_13_b, [Aux, [np, Name], VP]]])
  -->
  auxiliary([wfm:['Does'],
             arg:[num:sg, ind:I],
             ana:N1-N2,
             para:P1-P2,
             tree:Aux]),  
  name([     arg:[num:sg, ind:I],
	     drs:D1-D2,
	     ana:_-_,
	     para:P2-P3,
	     tree:Name]),
  verb_phrase([crd:_, 
               arg:[num:_, ind:I],
	       vform:inf,
               loc:query, 
               inv:yes,
               gap:[do]-[],
               pol:neg,
               evtl:E,
               drs:[drs([],[])|D2]-[drs(U3, [neg D4|C3]), drs(U1, C1)|D6],
               ana:N2-N5, 
               para:P3-P4, 
               tree:VP]).


% -------------------------------------------------------------------------

% Do most students work?
%

question([crd:_, 
          drs:D1-[drs(U1, [D4 ==> drs([], [eval(most, I, pos)])|C1])|D6],
          ana:N1-N5,
	  para:P1-P5,
          tree:[q_13, [Aux, [np, Det, Noun], VP]]])
  -->
  auxiliary([wfm:['Do'],
             arg:[num:pl, ind:I],
             ana:N1-N2,
             para:P1-P2,
             tree:Aux]),
  determiner([arg:[num:pl, ind:I],
	      fcn:subj,
	      qnt:most,
	      drs:[drs([], [])|D1]-[D4, drs(U1, C1)|D6],
              res:[drs([], [])|D1]-D2,
              sco:D3-S,
              ana:N2-N3,
	      para:P2-P3,
              tree:Det]),
  count_noun([wfm:WF,
              arg:[num:pl, ind:I],
              drs:D2-D3, 
              ana:_-_, 
              para:P3-P4, 
              tree:Noun]),
  verb_phrase([crd:_, 
               arg:[num:_, ind:I],
	       vform:inf,
               loc:query, 
               inv:yes,
               gap:[do]-[],
               pol:pos,
               evtl:E,
               drs:D3-[D4, drs(U1, C1)|D6],
               ana:N3-N5, 
               para:P4-P5, 
               tree:VP]).


% -------------------------------------------------------------------------

% Do most students not work?
%
question([crd:_, 
          drs:D1-[drs(U1, [drs(U3, [neg D4|C3]) ==> drs([], [eval(most, I, neg)])|C1])|D6],
          ana:N1-N5,
	  para:P1-P5,
          tree:[q_13, [Aux, [np, Det, Noun], VP]]])
  -->
  auxiliary([wfm:['Do'],
             arg:[num:pl, ind:I],
             ana:N1-N2,
             para:P1-P2,
             tree:Aux]),
  determiner([arg:[num:pl, ind:I],
	      fcn:subj,
	      qnt:most,
	      drs:[drs([], [])|D1]-[drs(U3, [neg D4|C3]), drs(U1, C1)|D6],
              res:[drs([], [])|D1]-D2,
              sco:D3-S,
              ana:N2-N3,
	      para:P2-P3,
              tree:Det]),
  count_noun([wfm:WF,
              arg:[num:pl, ind:I],
              drs:D2-D3, 
              ana:_-_, 
              para:P3-P4, 
              tree:Noun]),
  verb_phrase([crd:_, 
               arg:[num:_, ind:I],
	       vform:inf,
               loc:query, 
               inv:yes,
               gap:[do]-[],
               pol:neg,
               evtl:E,
               drs:D3-[drs(U3, [neg D4|C3]), drs(U1, C1)|D6],
               ana:N3-N5, 
               para:P4-P5, 
               tree:VP]).


% -------------------------------------------------------------------------

% Are most students employed?
%
question([crd:_, 
          drs:D1-[drs(U1, [D4 ==> drs([], [eval(most, I, pos)])|C1])|D6],
          ana:N1-N5,
	  para:P1-P5,
          tree:[q_15, [Cop, [np, Det, Noun], VP]]])
  -->
  copula([wfm:['Are'],
          arg:[num:pl, ind:I],
          ana:N1-N2,
          para:P1-P2,
          tree:Cop]),
  determiner([arg:[num:pl, ind:I],
	      fcn:subj,
	      qnt:most,
	      drs:[drs([], [])|D1]-[D4, drs(U1, C1)|D6],
              res:[drs([], [])|D1]-D2,
              sco:D3-S,
              ana:N2-N3,
	      para:P2-P3,
              tree:Det]),
  count_noun([wfm:WF,
              arg:[num:pl, ind:I],
              drs:D2-D3, 
              ana:_-_, 
              para:P3-P4, 
              tree:Noun]),
  verb_phrase([crd:_, 
               arg:[num:pl, ind:I],
               loc:query, 
               inv:yes,
               gap:[copula(pred(E, I, be))]-[],
               pol:pos,
               evtl:E,
               drs:D3-[D4, drs(U1, C1)|D6],
               ana:N3-N5, 
               para:P4-P5, 
               tree:VP]).


% -------------------------------------------------------------------------

% Are most students not employed?
%
question([crd:_, 
          drs:D1-[drs(U1, [drs(U3, [neg D4|C3]) ==> drs([], [eval(most, I, neg)])|C1])|D6],
          ana:N1-N5,
	  para:P1-P5,
          tree:[q_16, [np, Det, Noun], VP]])
  -->

  copula([wfm:['Are'],
          arg:[num:pl, ind:I],
          ana:N1-N2,
          para:P1-P2,
          tree:Cop]),
  determiner([arg:[num:pl, ind:I],
	      fcn:subj,
	      qnt:most,
	      drs:[drs([], [])|D1]-[drs(U3, [neg D4|C3]), drs(U1, C1)|D6],
              res:[drs([], [])|D1]-D2,
              sco:D3-S,
              ana:N2-N3,
	      para:P2-P3,
              tree:Det]),
  count_noun([wfm:WF,
              arg:[num:pl, ind:I],
              drs:D2-D3, 
              ana:_-_, 
              para:P3-P4, 
              tree:Noun]),
  verb_phrase([crd:_, 
               arg:[num:pl, ind:I],
               loc:query, 
               inv:yes,
               gap:[copula(pred(E, I, be))]-[],
               pol:neg,
               evtl:E,
               drs:D3-[drs(U3, [neg D4|C3]), drs(U1, C1)|D6],
               ana:N3-N5, 
               para:P4-P5, 
               tree:VP]).

         
% ------------

verb_phrase([crd:'-', arg:[num:_, ind:I], loc:query, inv:yes, gap:[prop(E, I2, Sym)]-[], pol:pos, evtl:E,
             drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2], ana:N1-N2, para:P1-P2, tree:[vp_1, IV]])
  -->
  intransitive_verb([wfm:WF, arg:[num:_, ind:I], vform:inf, evtl:E, con:C,
	             drs:[drs(U1, [prop(E, I2, Sym)|C1])|D1]-[drs(U2, C2)|D2], 
                     ana:N1-N2, para:P1-P2, tree:IV]).


verb_phrase([crd:'-', arg:[num:_, ind:I], loc:query, inv:yes, gap:[does, prop(E, I2, Sym)]-[], pol:neg, evtl:E,
             drs:[drs(U1, C1)|D1]-[drs(U3, [neg drs(U2, C2)|C3])|D2], ana:N1-N3, para:P1-P3, tree:[vp_2, Neg, IV]])
  -->
  negation([wfm:[not], ana:N1-N2, para:P1-P2, tree:Neg]),
  intransitive_verb([wfm:WF, arg:[num:_, ind:I], vform:inf, evtl:E, con:C, 
		     drs:[drs([], [prop(E, I2, Sym)]), drs(U1, C1)|D1]-[drs(U2, C2), drs(U3, C3)|D2],
                     ana:N2-N3, para:P2-P3, tree:IV]).


verb_phrase([crd:'-', arg:A1, loc:query, inv:yes, gap:[prop(E, I2, Sym)]-[], pol:pos, evtl:E,  
             drs:[drs(U1, C1)|D1]-[drs(U3, C3)|D3],
             ana:N1-N3, para:P1-P3, tree:[vp_3, TV, NP]])
  -->
  transitive_verb([wfm:WF, arg:A1, arg:[num:Num, ind:I], vform:inf, evtl:E, con:C,
		   drs:[drs(U2, [prop(E, I2, Sym)|C2])|D2]-S2,
		   ana:N1-N2, para:P1-P2, tree:TV]),
  noun_phrase([arg:[num:Num, ind:I], loc:L, fcn:dobj, qnt:Q,  
               drs:[drs(U1, C1)|D1]-[drs(U3, C3)|D3], 
               sco:[drs(U2, C2)|D2]-S2, ana:N2-N3, para:P2-P3, tree:NP]).


verb_phrase([crd:'-', arg:A1, loc:query, inv:yes, gap:[does, prop(E, I2, Sym)]-[], pol:neg, evtl:E,  
             drs:[drs(U1, C1)|D1]-[drs(U1, [neg drs(U3, C3)|C1])|D3], 
             ana:N1-N4, para:P1-P4, tree:[vp_4, Neg, TV, NP]])
  -->
  negation([wfm:[not], ana:N1-N2, para:P1-P2, tree:Neg]),
  transitive_verb([wfm:WF, arg:A1, arg:[num:Num, ind:I], vform:inf, evtl:E, con:C,
		   drs:[drs(U2, [prop(E, I2, Sym)|C2])|D2]-S2,
		   ana:N2-N3, para:P2-P3, tree:TV]),
  noun_phrase([arg:[num:Num, ind:I], loc:L, fcn:dobj, qnt:Q, 
               drs:[drs([], [])|D1]-[drs(U3, C3)|D3], 
               sco:[drs(U2, C2)|D2]-S2, ana:N3-N4, para:P3-P4, tree:NP]).


% ------------


verb_phrase([crd:'-', arg:[num:sg, ind:I], loc:query, inv:no, gap:[]-[], pol:neg, evtl:E, 
             drs:[drs(U1, C1)|D1]-[drs(U1, [neg drs(U2, C2)|C1])|D2],
             ana:N1-N3, para:P1-P3, tree:[vp_5, Neg, IV]])
  -->
  negation([wfm:[does, not], ana:N1-N2, para:P1-P2, tree:Neg]),
  intransitive_verb([wfm:WF, arg:[num:_, ind:I], vform:inf, evtl:E, con:C, 
                    drs:[drs([], [])|D1]-[drs(U2, C2)|D2], 
                    ana:N2-N3, para:P2-P3, tree:IV]).


verb_phrase([crd:'-', arg:[num:pl, ind:I], loc:query, inv:no, gap:[]-[], pol:neg, evtl:E, 
             drs:[drs(U1, C1)|D1]-[drs(U1, [neg drs(U2, C2)|C1])|D2],
             ana:N1-N3, para:P1-P3, tree:[vp_6, Neg, IV]])
  -->
  negation([wfm:[do, not], ana:N1-N2, para:P1-P2, tree:Neg]),
  intransitive_verb([wfm:WF, arg:[num:_, ind:I], vform:inf, evtl:E, con:C, 
                     drs:[drs([], [])|D1]-[drs(U2, C2)|D2],
                     ana:N2-N3, para:P2-P3, tree:IV]).


verb_phrase([crd:'-', arg:[num:sg, ind:I], loc:query, inv:no, gap:[]-[], pol:neg, evtl:E, con:C,
             drs:[drs(U1, C1)|D1]-[drs(U1, [neg drs(U2, C2)|C1])|D2],
             ana:N1-N3, para:P1-P3, tree:[vp_7, Neg, IV]])
  -->
  negation([wfm:[does, not], ana:N1-N2, para:P1-P2, tree:Neg]),
  intransitive_verb([wfm:WF, arg:[num:_, ind:I], vform:inf, evtl:E, con:C, 
                     drs:[drs([], [])|D1]-[drs(U2, C2)|D2], 
                     ana:N2-N3, para:P2-P3, tree:IV]).


verb_phrase([crd:'-', arg:[num:_, ind:I], vform:inf, loc:query, inv:yes, gap:[do]-[], pol:neg, evtl:E,
             drs:[drs(U1, C1)|D1]-[drs(U1, [neg drs(U2, C2)|C1])|D2],
             ana:N1-N3, para:P1-P3, tree:[vp_8, Neg, IV]])
  -->
  negation([wfm:[not], ana:N1-N2, para:P1-P2, tree:Neg]),
  intransitive_verb([wfm:WF, arg:[num:_, ind:I], vform:inf, evtl:E, con:C, 
                     drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2], 
                     ana:N2-N3, para:P2-P3, tree:IV]).


verb_phrase([crd:'-', arg:A1, vform:inf, loc:query, inv:yes, gap:[do]-[], pol:pos, evtl:E, 
             drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2],
             ana:N1-N2, para:P1-P2, tree:[vp_9, IV]])
  -->
  intransitive_verb([wfm:WF, arg:A1, vform:inf, evtl:E, con:C, 
                     drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2], 
                     ana:N1-N2, para:P1-P2, tree:IV]).



verb_phrase([crd:'-', arg:A1, vform:inf, loc:query, inv:yes, gap:[do]-[], pol:neg, evtl:E,  
             drs:[drs(U1, C1)|D1]-[drs(U1, [neg drs(U3, C3)|C1])|D3], 
             ana:N1-N4, para:P1-P4, tree:[vp_9_2, Neg, TV, NP]])
  -->
  negation([wfm:[not], ana:N1-N2, para:P1-P2, tree:Neg]),
  transitive_verb([wfm:WF, arg:A1, arg:[num:Num, ind:I], vform:inf, evtl:E, con:C,
		   drs:[drs(U2, C2)|D2]-S2,
		   ana:N2-N3, para:P2-P3, tree:TV]),
  noun_phrase([arg:[num:Num, ind:I], loc:L, fcn:dobj, qnt:Q, 
               drs:[drs([], [])|D1]-[drs(U3, C3)|D3], 
               sco:[drs(U2, C2)|D2]-S2, ana:N3-N4, para:P3-P4, tree:NP]).


verb_phrase([crd:'-', arg:A1, vform:inf, loc:query, inv:yes, gap:[do]-[], pol:pos, evtl:E,  
             drs:[drs(U1, C1)|D1]-[drs(U3, C3)|D3],
             ana:N1-N3, para:P1-P3, tree:[vp_9_3, TV, NP]])
  -->
  transitive_verb([wfm:WF, arg:A1, arg:[num:Num, ind:I], vform:inf, evtl:E, con:C,
		   drs:[drs(U2, C2)|D2]-S2,
		   ana:N1-N2, para:P1-P2, tree:TV]),
  noun_phrase([arg:[num:Num, ind:I], loc:L, fcn:dobj, qnt:Q,  
               drs:[drs(U1, C1)|D1]-[drs(U3, C3)|D3], 
               sco:[drs(U2, C2)|D2]-S2, ana:N2-N3, para:P2-P3, tree:NP]).





verb_phrase([crd:'-', arg:A1, loc:query, inv:no, gap:[]-[], pol:pos, evtl:E, 
             drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2],
             ana:N1-N2, para:P1-P2, tree:[vp_10, IV]])
  -->
  intransitive_verb([wfm:WF, arg:A1, vform:fin, evtl:E, con:C, 
                     drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2], 
                     ana:N1-N2, para:P1-P2, tree:IV]).


verb_phrase([crd:'-', arg:A1, loc:query, inv:no, gap:[]-[], pol:pos, evtl:E, con:C,
             drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2],
             ana:N1-N2, para:P1-P2, tree:[vp_11, IV]])
  -->
  intransitive_verb([wfm:WF, arg:A1, vform:fin, evtl:E, con:C,
                     drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2], 
                     ana:N1-N2, para:P1-P2, tree:IV]).


verb_phrase([crd:'-', arg:[num:pl, ind:I], loc:query, inv:no, gap:[]-[], pol:neg, evtl:E, con:C,
             drs:[drs(U1, C1)|D1]-[drs(U1, [neg drs(U2, C2)|C1])|D2],
             ana:N1-N3, para:P1-P3, tree:[vp_12, Neg, IV]])
  -->
  negation([wfm:[do, not], ana:N1-N2, para:P1-P2, tree:Neg]),
  intransitive_verb([wfm:WF, arg:[num:_, ind:I], vform:inf, evtl:E, con:C, 
                     drs:[drs([], [])|D1]-[drs(U2, C2)|D2],
                     ana:N2-N3, para:P2-P3, tree:IV]).


verb_phrase([crd:'-', arg:A1, loc:query, inv:no, gap:[]-[], pol:pos, evtl:E, con:C,
             drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2],
             ana:N1-N2, para:P1-P2, tree:[vp_13, IV]])
  -->
  intransitive_verb([wfm:WF, arg:A1, vform:fin, evtl:E, con:C, 
                     drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2], 
                     ana:N1-N2, para:P1-P2, tree:IV]).


% ---------------------------------------

verb_phrase([crd:'-', arg:A1, loc:query, inv:no, gap:[]-[], pol:pos, evtl:E, con:C, 
             drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2],
             ana:N1-N3, para:P1-P3, tree:[vp_14, VP, PP]])
  -->
  verb_phrase([arg:A1, vform:fin, evtl:E, loc:query, con:C, drs:S2-[drs(U2, C2)|D2], ana:N1-N2, para:P1-P2, tree:VP]),
  prepositional_phrase([wfm:WF, loc:query, fcn:pmod, evtl:E, drs:[drs(U1, C1)|D1]-S0, sco:S1-S2, ana:N2-N3, para:P2-P3, tree:PP]).


prepositional_phrase([wfm:WF, loc:query, fcn:pmod, evtl:E, drs:D, sco:S, ana:N1-N3, para:P1-P3, tree:[pp_1, Prep, NP]])
  -->
  preposition([wfm:WF, evtl:E, arg:A, drs:S, ana:N1-N2, para:P1-P2, tree:Prep]),
  noun_phrase([arg:A, loc:query, fcn:tex, qnt:def, drs:D, sco:S, ana:N2-N3, para:P2-P3, tree:NP]).


noun_phrase([arg:A, loc:query, fcn:tex, qnt:_, drs:D1-D2, sco:D4-D5, ana:N1-N3, para:P1-P3, tree:[np_1, TX]])
  -->
  temporal_expression([arg:A, drs:[drs([], [])|D1]-D2, res:[drs([], [])|D1]-[D3|D1], sco:S, ana:[]-N2, para:P1-P2, tree:TX]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:[D3], sco:D4-[], ana:N1-N2-N3, para:P1-P2-P3]) }.


% ---------------------------------------

verb_phrase([arg:A, vform:V, evtl:E, loc:query, con:C, drs:D1-D2, ana:N1-N2, para:P1-P2, tree:[vp_15, IV]])
  -->
  intransitive_verb([wfm:WF, arg:A, vform:V, evtl:E, con:C, drs:D1-D2, ana:N1-N2, para:P1-P2, tree:IV]).


% ------------


verb_phrase([crd:'-', arg:[num:sg, ind:I], loc:query, inv:no, gap:[]-[], pol:neg, evtl:E,  
             drs:[drs(U1, C1)|D1]-[drs(U1, [neg drs(U2, C2)|C1])|D2], 
             ana:N1-N5, para:P1-P5, tree:[vp_16, Cop, Neg, RAdj, NP]])
  -->
  copula([wfm:WF, arg:[num:sg, ind:I], vform:V, evtl:E, drs:S1-S2, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:S2-S3, ana:N3-N4, para:P3-P4, tree:RAdj]),
  noun_phrase([arg:A2, loc:decl, fcn:dobj, qnt:Q, 
               drs:[drs([], [])|D1]-[drs(U2, C2)|D2],
               sco:S1-S3, ana:N4-N5, para:P4-P5, tree:NP]).


verb_phrase([crd:'-', arg:[num:sg, ind:I], loc:query, inv:no, gap:[]-[], pol:pos, evtl:E, 
            drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2],
            ana:N1-N4, para:P1-P4, tree:[vp_17, Cop, RAdj, NP]])
  -->
  copula([wfm:WF, arg:[num:sg, ind:I], vform:V, evtl:E, drs:S1-S2, ana:N1-N2, para:P1-P2, tree:Cop]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:S2-S3, ana:N2-N3, para:P2-P3, tree:RAdj]),
  noun_phrase([arg:A2, loc:decl, fcn:dobj, qnt:Q,  
               % drs:D, 
               drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2],
               sco:S1-S3, ana:N3-N4, para:P3-P4, tree:NP]).


verb_phrase([crd:'-', arg:[num:sg, ind:I], loc:query, inv:no, gap:[]-[], pol:neg, evtl:E, con:C,
             drs:[drs(U1, C1)|D1]-[drs(U1, [neg drs(U2, C2)|C1])|D2], 
             ana:N1-N5, para:P1-P5, tree:[vp_18, Cop, Neg, RAdj, NP]])
  -->
  copula([wfm:WF, arg:[num:sg, ind:I], vform:V, evtl:E, drs:S1-S2, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:S2-S3, ana:N3-N4, para:P3-P4, tree:RAdj]),
  noun_phrase([arg:A2, loc:decl, fcn:wobj, qnt:Q, 
               drs:[drs([], [])|D1]-[drs(U2, C2)|D2],
               sco:S1-S3, ana:N4-N5, para:P4-P5, tree:NP]).


verb_phrase([crd:'-', arg:[num:sg, ind:I], loc:query, inv:no, gap:[]-[], pol:pos, evtl:E, con:C, 
            drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2],
            ana:N1-N4, para:P1-P4, tree:[vp_19, Cop, RAdj, NP]])
  -->
  copula([wfm:WF, arg:[num:sg, ind:I], vform:V, evtl:E, drs:S1-S2, ana:N1-N2, para:P1-P2, tree:Cop]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:S2-S3, ana:N2-N3, para:P2-P3, tree:RAdj]),
  noun_phrase([arg:A2, loc:decl, fcn:wobj, qnt:Q, 
               drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2],
               sco:S1-S3, 
               ana:N3-N4, para:P3-P4, tree:NP]).


verb_phrase([crd:'-', arg:[num:sg, ind:I], loc:query, inv:no, gap:[]-[], pol:pos, evtl:E, con:prop(X, A3, PName), 
            drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2],
            ana:N1-N4, para:P1-P4, tree:[vp_20, Cop, RAdj, NP]])
  -->
  copula([wfm:WF, arg:[num:sg, ind:I], vform:V, evtl:E, drs:S1-S2, ana:N1-N2, para:P1-P2, tree:Cop]),
  relational_adjective([evtl:E, arg:A2, con:prop(X, Y, PName), drs:S2-S3, ana:N2-N3, para:P2-P3, tree:RAdj]),
  noun_phrase([arg:A2, arg:[num:_, ind:A3], loc:decl, fcn:wobj, qnt:Q, 
               drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2],
               sco:S1-S3, 
               ana:N3-N4, para:P3-P4, tree:NP]).


% ------------

verb_phrase([crd:_, arg:A1, loc:query, inv:no, gap:[]-[], pol:pos, evtl:E,  
             drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2],
             ana:N1-N3, para:P1-P3, tree:[vp_21, TV, NP]])
  -->
  transitive_verb([wfm:WF, arg:A1, arg:[num:Num, ind:I], vform:fin, evtl:E, con:C, drs:S, ana:N1-N2, para:P1-P2, tree:TV]),
  noun_phrase([arg:[num:Num, ind:I], loc:L, fcn:dobj, qnt:Q,  
               drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2], 
               sco:S, ana:N2-N3, para:P2-P3, tree:NP]).


verb_phrase([crd:_, arg:A1, loc:query, inv:no, gap:[]-[], pol:neg, evtl:E,  
             drs:[drs(U1, C1)|D1]-[drs(U1, [neg drs(U2, C2)|C1])|D2], 
             ana:N1-N4, para:P1-P4, tree:[vp_22, Neg, TV, NP]])
  -->
  negation([wfm:[does, not], ana:N1-N2, para:P1-P2, tree:Neg]),
  transitive_verb([wfm:WF, arg:A1, arg:[num:Num, ind:I], vform:inf, evtl:E, con:C, drs:S, ana:N2-N3, para:P2-P3, tree:TV]),
  noun_phrase([arg:[num:Num, ind:I], loc:L, fcn:dobj, qnt:Q, 
               drs:[drs([], [])|D1]-[drs(U2, C2)|D2], 
               sco:S, ana:N3-N4, para:P3-P4, tree:NP]).


verb_phrase([crd:_, arg:A1, loc:query, inv:no, gap:[]-[], pol:pos, evtl:E, con:C, 
             drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2],
             ana:N1-N3, para:P1-P3, tree:[vp_23, TV, NP]])
  -->
  transitive_verb([wfm:WF, arg:A1, arg:[num:Num, ind:I], vform:fin, evtl:E, con:C, drs:S, ana:N1-N2, para:P1-P2, tree:TV]),
  noun_phrase([arg:[num:Num, ind:I], loc:L, fcn:wobj, qnt:Q, 
               drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2],
               sco:S, ana:N2-N3, para:P2-P3, tree:NP]).

%%% NEW 
verb_phrase([crd:_, arg:A1, loc:query, inv:yes, gap:[np]-[], pol:pos, evtl:E, con:C, 
             drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2],
             ana:N1-N4, para:P1-P4, tree:[vp_24, Aux, NP, TV]])
  -->
  auxiliary([wfm:[does], arg:[num:sg, ind:I], ana:N1-N2, para:P1-P2, tree:Aux]),   
  noun_phrase([arg:[num:sg, ind:I], loc:L, fcn:dobj, qnt:Q, 
               drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2],
               sco:S, ana:N2-N3, para:P2-P3, tree:NP]),
  transitive_verb([wfm:WF, arg:[num:_, ind:I], arg:A1, vform:inf, evtl:E, con:C, drs:S, ana:N3-N4, para:P3-P4, tree:TV]).


verb_phrase([crd:_, arg:A1, loc:query, inv:no, gap:[]-[], pol:neg, evtl:E, con:C, 
             drs:[drs(U1, C1)|D1]-[drs(U1, [neg drs(U2, C2)|C1])|D2],
             ana:N1-N4, para:P1-P4, tree:[vp_25, Neg, TV, NP]])
  -->
  negation([wfm:[does, not], ana:N1-N2, para:P1-P2, tree:Neg]),
  transitive_verb([wfm:WF, arg:A1, arg:[num:Num, ind:I], vform:inf, evtl:E, con:C, drs:S, ana:N2-N3, para:P2-P3, tree:TV]),
  noun_phrase([arg:[num:Num, ind:I], loc:L, fcn:wobj, qnt:Q, 
               drs:[drs([], [])|D1]-[drs(U2, C2)|D2],
               sco:S, ana:N3-N4, para:P3-P4, tree:NP]).


%-------------------


verb_phrase([crd:'-', arg:[num:N, ind:I], loc:query, inv:yes, gap:[copula(Pred)]-[], pol:neg, evtl:E, 
             drs:[drs(U1, C1)|D1]-[drs(U1, [neg drs(U2, C2)|C1])|D2], 
             ana:N1-N3, para:P1-P3, tree:[vp_26, Neg, Adj]])
  -->
  negation([wfm:[not], ana:N1-N2, para:P1-P2, tree:Neg]),
  adjective([evtl:E, con:C, drs:[drs([E], [Pred])|D1]-[drs(U2, C2)|D2], ana:N2-N3, para:P2-P3, tree:Adj]).


verb_phrase([crd:'-', arg:[num:N, ind:I], loc:query, inv:yes, gap:[copula(Pred)]-[], pol:pos, evtl:E, 
             drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D2],
             ana:N1-N2, para:P1-P2, tree:[vp_27, Adj]])
  -->
  adjective([evtl:E, con:C, drs:[drs([E|U1], [Pred|C1])|D1]-[drs(U2, C2)|D2], ana:N1-N2, para:P1-P2, tree:Adj]).


%-------------------

verb_phrase([crd:'-', arg:A1, loc:query, inv:no, gap:[]-[], pol:neg, evtl:E, 
             drs:[drs(U1, C1)|D1]-[drs(U1, [neg drs(U2, C2)|C1])|D3], 
             ana:N1-N4, para:P1-P4, tree:[vp_28, Cop, Neg, Adj]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:D2-[drs(U2, C2)|D3], ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  adjective([evtl:E, con:C, drs:[drs([], [])|D1]-D2, ana:N3-N4, para:P3-P4, tree:Adj]).


verb_phrase([crd:'-', arg:A1, loc:query, inv:no, gap:[]-[], pol:pos, evtl:E, 
             drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D3],
             ana:N1-N3, para:P1-P3, tree:[vp_29, Cop, Adj]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:D2-[drs(U2, C2)|D3], ana:N1-N2, para:P1-P2, tree:Cop]),
  adjective([evtl:E, con:C, drs:[drs(U1, C1)|D1]-D2, ana:N2-N3, para:P2-P3, tree:Adj]).

/***
verb_phrase([crd:'-', arg:[num:Num, ind:I], loc:query, inv:no, gap:[]-[], pol:neg, evtl:E, con:C,
             drs:[drs(U1, C1)|D1]-[drs(U1, [neg drs(U2, C2)|C1])|D3], 
             ana:N1-N4, para:P1-P4, tree:[vp_30, Cop, Neg, Adj]])
  -->
  copula([wfm:WF, arg:[num:Num, ind:I], vform:V, evtl:E, drs:D2-[drs(U2, C2)|D3], ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  adjective([evtl:E, con:C, drs:[drs([], [])|D1]-D2, ana:N3-N4, para:P3-P4, tree:Adj]).


verb_phrase([crd:'-', arg:[num:Num, ind:I], loc:query, inv:no, gap:[]-[], pol:pos, evtl:E, con:C,
             drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D3],
             ana:N1-N3, para:P1-P3, tree:[vp_31, Cop, Adj]])
  -->
  copula([wfm:WF, arg:[num:Num, ind:I], vform:V, evtl:E, drs:D2-[drs(U2, C2)|D3], ana:N1-N2, para:P1-P2, tree:Cop]),
  adjective([evtl:E, con:C, drs:[drs(U1, C1)|D1]-D2, ana:N2-N3, para:P2-P3, tree:Adj]).
***/


verb_phrase([crd:'-', arg:[num:Num, ind:I], loc:query, inv:no, gap:[]-[], pol:neg, evtl:E, con:prop(I, PName),
             drs:[drs(U1, C1)|D1]-[drs(U1, [neg drs(U2, C2)|C1])|D3], 
             ana:N1-N4, para:P1-P4, tree:[vp_30, Cop, Neg, Adj]])
  -->
  copula([wfm:WF, arg:[num:Num, ind:I], vform:V, evtl:E, drs:D2-[drs(U2, C2)|D3], ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  adjective([evtl:E, con:prop(E, PName), drs:[drs([], [])|D1]-D2, ana:N3-N4, para:P3-P4, tree:Adj]).


verb_phrase([crd:'-', arg:[num:Num, ind:I], loc:query, inv:no, gap:[]-[], pol:pos, evtl:E, con:prop(I, PName),
             drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D3],
             ana:N1-N3, para:P1-P3, tree:[vp_31, Cop, Adj]])
  -->
  copula([wfm:WF, arg:[num:Num, ind:I], vform:V, evtl:E, drs:D2-[drs(U2, C2)|D3], ana:N1-N2, para:P1-P2, tree:Cop]),
  adjective([evtl:E, con:prop(E, PName), drs:[drs(U1, C1)|D1]-D2, ana:N2-N3, para:P2-P3, tree:Adj]).

% ------------

verb_phrase([crd:'-', arg:A1, loc:query, inv:no, gap:[]-[], pol:pos, evtl:E,
             drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D3],
             ana:N1-N3, para:P1-P3, tree:[vp_32, Cop, NP]])
  -->
  copula([wfm:WF, arg:A1, arg:[num:sg, ind:I], vform:V, evtl:E, drs:S, ana:N1-N2, para:P1-P2, tree:Cop]),  
  noun_phrase([arg:[num:sg, ind:I], loc:decl, fcn:dobj, qnt:Q,
               drs:[drs(U1, C1)|D1]-[drs(U2, C2)|D3],
               sco:S, ana:N2-N3, para:P2-P3, tree:NP]).


% ------------

noun_phrase([arg:A, loc:L, fcn:wsubj, qnt:def, drs:D, sco:S, ana:N, para:P, tree:[np_2, T]])
  -->
  noun_phrase([arg:A, loc:L, fcn:subj, qnt:def, drs:D, sco:S, ana:N, para:P, tree:T]).


noun_phrase([arg:A, loc:L, fcn:wsubj, qnt:exist, drs:D, sco:S, ana:N, para:P, tree:[np_3, T]])
  -->
  noun_phrase([arg:A, loc:L, fcn:wsubj, qnt:exist, drs:D, sco:S, ana:N, para:P, tree:T]).


% ------------

noun_phrase([arg:A, loc:L, fcn:wobj, qnt:Q, drs:D, sco:R3-S, ana:N1-N1, para:P1-P3, tree:[np_4, WhD, Noun]])
  -->
  wh_determiner([wfm:WF1, arg:A, drs:D, res:R1-R2, sco:R3-S, ana:N1-N2, para:P1-P2, tree:WhD]), 
  count_noun([wfm:WF2, arg:A, drs:R2-R3, ana:N2-N3, para:P2-P3, tree:Noun]).

noun_phrase([arg:A1, arg:A2, loc:L, fcn:wobj, qnt:Q, drs:D, sco:R4-S, ana:N1-N1, para:P1-P4, tree:[np_5, WhD, Noun, Var]])
  -->
  wh_determiner([wfm:WF1, arg:A1, drs:D, res:R1-R2, sco:R3-S, ana:N1-N2, para:P1-P2, tree:WhD]), 
  count_noun([wfm:WF2, arg:A1, drs:R2-R3, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:R3-R4, ana:N3-N4, para:P3-P4, tree:Var]).

% ------------
% ------------ to be merged

% the successful student who ...
%
noun_phrase([arg:A, loc:L, fcn:dobj, qnt:def, drs:D1-D2, sco:R5-D2, ana:N1-N6, para:P1-P6, tree:[np_135, Det, Adj, Noun, RC0]])
  -->
  determiner([arg:A, fcn:O, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:R3, sco:R4-[], ana:N1-N4-N5, para:P1-P4-P5]) },
  relative_clause_0([crd:'+', arg:A, loc:L, drs:R4-R5, ana:N5-N6, para:P5-P6, tree:RC0]).


% ... a successful student who ...
%
noun_phrase([arg:A, loc:L, fcn:dobj, qnt:exist, drs:D, sco:S, ana:N1-N5, para:P1-P5, tree:[np_138, Det, Adj, Noun, RC0]])
  -->
  determiner([arg:A, fcn:O, qnt:exist, drs:D, res:R1-R4, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  relative_clause_0([crd:'+', arg:A, loc:L, drs:R3-R4, ana:[N4|N1]-N5, para:P4-P5, tree:RC0]).


% ... the student who ...
%
noun_phrase([arg:A, loc:L, fcn:dobj, qnt:def, drs:D1-D2, sco:R4-D2, ana:N1-N5, para:P1-P5, tree:[np_141, Det, Noun, RC0]])
  -->
  determiner([arg:A, fcn:O, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:R2, sco:R3-[], ana:N1-N3-N4, para:P1-P3-P4]) },
  relative_clause_0([crd:'+', arg:A, loc:L, drs:R3-R4, ana:N4-N5, para:P4-P5, tree:RC0]).


% ... the parent of the child ...
%
noun_phrase([arg:A1, loc:L, fcn:dobj, qnt:def, drs:D1-D6, sco:D5-D6, ana:N1-N6, para:P1-P6, tree:[np_148, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:O, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:L, fcn:pobj, qnt:def, drs:D3-D4, sco:S2-S2, ana:N1-N4-N5, para:P4-P5, tree:NP]),  
  { anaphora_resolution([arg:A1, ref:F, drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P5-P6]) }.


% ... the parent of a child ...
%
noun_phrase([arg:A1, loc:L, fcn:dobj, qnt:def, drs:D, sco:S1, ana:N1-[N5|N1], para:P1-P5, tree:[np_152, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:O, qnt:def, drs:D, res:R1-R4, sco:S1, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:L, fcn:pobj, qnt:exist, drs:R3-R4, sco:S2-S2, ana:N1-N4-N5, para:P4-P5, tree:NP]).


% ... a parent of a child ...
% ... a parent of the child ...
%
noun_phrase([arg:A1, loc:L, fcn:dobj, qnt:exist, drs:D, sco:S1, ana:N1-[N5|N1], para:P1-P5, tree:[np_158, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:O, qnt:exist, drs:D, res:R1-R4, sco:S1, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:L, fcn:pobj, qnt:Q2, drs:R3-R4, sco:S2-S2, ana:N1-N4-N5, para:P4-P5, tree:NP]).


% ... the successful student
%
noun_phrase([arg:A, loc:L, fcn:dobj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_162, Det, Adj, Noun]])
  -->
  determiner([arg:A, fcn:O, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),                                      
  count_noun([wfm:WF, arg:A, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% ... a successful student
%
noun_phrase([arg:A, loc:L, fcn:dobj, qnt:exist, drs:D, sco:S, ana:N1-[N4|N1], para:P1-P4, tree:[np_165, Det, Adj, Noun]])
  -->
  determiner([arg:A, fcn:O, qnt:exist, drs:D, res:R1-R3, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]).


% ... the successful student X1 who ...
%
noun_phrase([arg:A, loc:L, fcn:dobj, qnt:def, drs:D1-D7, sco:D6-D7, ana:N1-N7, para:P1-P7, tree:[np_168, Det, Adj, Noun, Var, RC0]])
  -->
  determiner([arg:A, fcn:O, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D3-D4, ana:N4-N5, para:P4-P5, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P4-P5]) }.
  relative_clause_0([crd:'+', arg:A, loc:L, drs:D5-D6, ana:N6-N7, para:P6-P7, tree:RC0]).


% merge
% ... a successful student X1 who ...
%
noun_phrase([arg:A, loc:L, fcn:dobj, qnt:exist, drs:D, sco:S, ana:N1-N6, para:P1-P6, tree:[np_171, Det, Adj, Noun, Var, RC0]])
  -->
  determiner([arg:A, fcn:O, qnt:exist, drs:D, res:R1-R5, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', drs:R3-R4, ana:N4-N5, para:P4-P5, tree:Var]),
  relative_clause_0([crd:'+', arg:A, loc:L, drs:R4-R5, ana:[N5|N1]-N6, para:P5-P6, tree:RC0]).


% ... the successful student X1 ...
%
noun_phrase([arg:A, loc:L, fcn:dobj, qnt:def, drs:D1-D6, sco:D5-D6, ana:N1-N6, para:P1-P6, tree:[np_175, Det, Adj, Noun, Var]])
  -->
  determiner([arg:A, fcn:O, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D3-D4, ana:N4-N5, para:P4-P5, tree:Var]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P5-P6]) }.


% ... a successful student X1 ...
%
noun_phrase([arg:A, loc:L, fcn:dobj, qnt:exist, drs:D, sco:S, ana:N1-[N5|N1], para:P1-P5, tree:[np_178, Det, Adj, Noun, Var]])
  -->
  determiner([arg:A, fcn:O, qnt:exist, drs:D, res:R1-R4, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', drs:R3-R4, ana:N4-N5, para:P4-P5, tree:Var]).


% ... the student X1 who ...
%
noun_phrase([arg:A, loc:L, fcn:dobj, qnt:def, drs:D1-D6, sco:D5-D6, ana:N1-N6, para:P1-P6, tree:[np_181, Det, Noun, Var, RC0]])
  -->
  determiner([arg:A, fcn:O, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) },
  relative_clause_0([crd:'+', arg:A, loc:L, drs:D4-D5, ana:N5-N6, para:P5-P6, tree:RC0]).


% ... a student X1 who ...
%
noun_phrase([arg:A, loc:L, fcn:dobj, qnt:exist, drs:D, sco:S, ana:N1-N5, para:P1-P5, tree:[np_184, Det, Noun, Var, RC0]])
  -->
  determiner([arg:A, fcn:O, qnt:exist, drs:D, res:R1-R4, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Var]),
  relative_clause_0([crd:'+', arg:A, loc:L, drs:R3-R4, ana:[N4|N1]-N5, para:P4-P5, tree:RC0]).


% ... the student X1
%
noun_phrase([arg:A, loc:L, fcn:dobj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_188, Det, Noun, Var]])
  -->
  determiner([arg:A, fcn:O, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% ... a student X1
%
noun_phrase([arg:A, loc:L, fcn:dobj, qnt:exist, drs:D, sco:S, ana:N1-[N4|N1], para:P1-P4, tree:[np_191, Det, Noun, Var]])
  -->
  determiner([arg:A, fcn:O, qnt:exist, drs:D, res:R1-R3, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Var]).


% ... the successful student N1 who ...
%
noun_phrase([arg:A1, loc:L, fcn:dobj, qnt:def, drs:D1-D7, sco:D6-D7, ana:N1-N7, para:P1-P7, tree:[np_194, Det, Adj, Noun, Var, RC0]])
  -->
  determiner([arg:A1, fcn:O, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A1, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:D3-D4, ana:N4-N5, para:P4-P5, tree:Var]),
  { anaphora_resolution([arg:A1, ref:'?', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P4-P5]) },
  relative_clause_0([crd:'+', arg:A2, loc:L, drs:D5-D6, ana:N6-N7, para:P6-P7, tree:RC0]).


% ... a successful student N1 who ...
%
noun_phrase([arg:A1, loc:L, fcn:dobj, qnt:exist, drs:D, sco:S, ana:N1-N6, para:P1-P6, tree:[np_196, Det, Adj, Noun, Var, RC0]])
  -->
  determiner([arg:A1, fcn:O, qnt:exist, drs:D, res:R1-R5, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A1, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:R3-R4, ana:N4-N5, para:P4-P5, tree:Var]),
  relative_clause_0([crd:'+', arg:A2, loc:L, drs:R4-R5, ana:[N5|N1]-N6, para:P5-P6, tree:RC0]).


% ... the student N1 who ...
%
noun_phrase([arg:A1, loc:L, fcn:dobj, qnt:def, drs:D1-D6, sco:D5-D6, ana:N1-N6, para:P1-P6, tree:[np_199, Det, Noun, Var, RC0]])
  -->
  determiner([arg:A1, fcn:O, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A1, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) },
  relative_clause_0([crd:'+', arg:A2, loc:L, drs:D4-D5, ana:N5-N6, para:P5-P6, tree:RC0]).


% ... a student N1 who ...
%
noun_phrase([arg:A1, loc:L, fcn:dobj, qnt:exist, drs:D, sco:S, ana:N1-N5, para:P1-P5, tree:[np_202, Det, Noun, Var, RC0]])
  -->
  determiner([arg:A1, fcn:O, qnt:exist, drs:D, res:R1-R4, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Var]),
  relative_clause_0([crd:'+', arg:A2, loc:L, drs:R3-R4, ana:[N4|N1]-N5, para:P4-P5, tree:RC0]).


% ... the student N1 ...
%
noun_phrase([arg:A1, loc:L, fcn:dobj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_206, Det, Noun, Var]])
  -->
  determiner([arg:A1, fcn:O, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A1, ref:F, drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% ... a student N1 ...
%
noun_phrase([arg:A1, loc:L, fcn:dobj, qnt:exist, drs:D, sco:S, ana:N1-[N4|N1], para:P1-P4, tree:[np_209, Det, Noun, Var]])
  -->
  determiner([arg:A1, fcn:O, qnt:exist, drs:D, res:R1-R3, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Var]).


% ... the student ...
%
noun_phrase([arg:A, loc:L, fcn:dobj, qnt:def, drs:D1-D4, sco:D3-D4, ana:N1-N4, para:P1-P4, tree:[np_213, Det, Noun]])
  -->
  determiner([arg:A, fcn:O, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D2, sco:D3-[], ana:N1-N3-N4, para:P1-P3-P4]) }.


% ... a student ...
%
noun_phrase([arg:A, loc:L, fcn:dobj, qnt:exist, drs:D, sco:S, ana:N1-[N3|N1], para:P1-P3, tree:[np_216, Det, Noun]])
  -->
  determiner([arg:A, fcn:O, qnt:exist, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R, ana:N2-N3, para:P2-P3, tree:Noun]).


% ... John who ...
%
noun_phrase([arg:A, loc:L, fcn:dobj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N4, para:P1-P4, tree:[np_223, Name, RC0]])
  -->
  name([arg:A, drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  relative_clause_0([crd:'+', arg:A, loc:L, drs:D3-D4, ana:N3-N4, para:P3-P4, tree:RC0]).


% ... John
%
noun_phrase([arg:A, loc:L, fcn:dobj, qnt:def, drs:D1-D4, sco:D3-D4, ana:N1-N3, para:P1-P3, tree:[np_227, Name]])
  -->
  name([arg:A, drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) }.


% ... water
%
noun_phrase([arg:A, loc:L, fcn:dobj, qnt:def, drs:D1-D4, sco:D3-D4, ana:N1-N3, para:P1-P3, tree:[np_229, MN]])
  -->
  mass_noun([arg:A, drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:MN]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) }.


% ... X1 that ...
%
noun_phrase([arg:A, loc:L, fcn:dobj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N4, para:P1-P4, tree:[np_232, Var, RC0]])
  -->
  string_variable([arg:A, app:'-', drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Var]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  relative_clause_0([crd:'+', arg:A, loc:L, drs:D3-D4, ana:N3-N4, para:P3-P4, tree:RC0]).


% ... X1
%
noun_phrase([arg:A, loc:L, fcn:dobj, qnt:def, drs:D1-D4, sco:D3-D4, ana:N1-N3, para:P1-P3, tree:[np_235, Var]])
  -->
  string_variable([arg:A, app:'-', drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) }.


% ------------------------------------------------------------------------
% Sentence coordination
% ------------------------------------------------------------------------

sentence_3([crd:'+', drs:D1-D2, ana:N1-N2, para:P1-P2, tree:[s3_1, S]])
  -->
  sentence_2([crd:'-', drs:D1-D2, ana:N1-N2, para:P1-P2, tree:S]). 


sentence_3([crd:'-', drs:D1-D2, ana:N1-N2, para:P1-P2, tree:[s3_2, S]])
  -->
  sentence_2([crd:'-', drs:D1-D2, ana:N1-N2, para:P1-P2, tree:S]).


sentence_3([crd:'and', drs:D1-D2, ana:N1-N2, para:P1-P2, tree:[s3_3, S]])
  -->
  sentence_2([crd:'-', drs:D1-D2, ana:N1-N2, para:P1-P2, tree:S]). 


sentence_3([crd:'-', drs:D1-D2, ana:N1-N2, para:P1-P2, tree:[s3_4, S]])
  -->
  sentence_0([crd:'-', loc:decl, drs:D1-D2, ana:N1-N2, para:P1-P2, tree:S]). 


sentence_3([crd:'+', drs:D1-D2, ana:N1-N2, para:P1-P2, tree:[s3_5, S]])
  -->
  sentence_0([crd:'-', loc:decl,  drs:D1-D2, ana:N1-N2, para:P1-P2, tree:S]).


sentence_3([crd:'and', drs:D1-D2, ana:N1-N2, para:P1-P2, tree:[s3_6, S]])
  -->
  sentence_0([crd:'-', loc:decl,  drs:D1-D2, ana:N1-N2, para:P1-P2, tree:S]).


sentence_3([crd:'+', drs:D1-D3, ana:N1-N4, para:P1-P4, tree:[s3_7, S2A, CRD, S2B]])
  -->
  sentence_3([crd:'-', drs:D1-D2, ana:N1-N2, para:P1-P2, tree:S2A]),	  
  coordination([wfm:[and], ana:N2-N3, para:P2-P3, tree:CRD]),	  
  sentence_3([crd:'and', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:S2B]).


% ------------------------------------------------------------------------
% Conditional sentences
% 
%   - If [...] then [...]
%
% ------------------------------------------------------------------------

sentence_2([crd:'-', drs:D1-[drs(U, [Ant==>Con|Cons])|D3], ana:N1-[['</sub>']|N5], para:P1-P5, tree:[s2_1, Prep, S1, Adv, S0]])
  -->
  preposition([wfm:['If'], ana:[['<sub>']|N1]-N2, para:P1-P2, tree:Prep]),
  sentence_1([crd:'+', loc:ante, drs:[drs([], [])|D1]-D2, ana:N2-N3, para:P2-P3, tree:S1]),
  adverb([wfm:[then], ana:N3-N4, para:P3-P4, tree:Adv]),
  sentence_0([crd:'-', loc:cons, drs:[drs([], [])|D2]-[Con, Ant, drs(U, Cons)|D3], ana:N4-N5, para:P4-P5, tree:S0]).


sentence_2([crd:'-', drs:D1-[drs(U, [Ant==>Con|Cons])|D3], ana:N1-[['</sub>']|N5], para:P1-P5, tree:[s2_2, Prep, S1, Adv, S0]])
  -->
  preposition([wfm:[if], ana:[['<sub>']|N1]-N2, para:P1-P2, tree:Prep]),
  sentence_1([crd:'+', loc:ante, drs:[drs([], [])|D1]-D2, ana:N2-N3, para:P2-P3, tree:S1]),
  adverb([wfm:[then], ana:N3-N4, para:P3-P4, tree:Adv]),
  sentence_0([crd:'-', loc:cons, drs:[drs([], [])|D2]-[Con, Ant, drs(U, Cons)|D3], ana:N4-N5, para:P4-P5, tree:S0]).


% ------------------------------------------------------------------------
% For every sentences
%
%   - For every [...] there is [...]
%   - For every [...] there are [...]
%
% ------------------------------------------------------------------------

sentence_2([crd:'-', drs:D1-D3, ana:N1-[['</sub>']|N4], para:P1-P4, tree:[s2_4, NP1, EXT, NP2]])
  -->
  noun_phrase([arg:A1, loc:ante, fcn:extra, qnt:all, drs:D1-D3, sco:S1-S2, ana:[['<sub>']|N1]-N2, para:P1-P2, tree:NP1]),	  
  existential_there([wfm:[there, is], arg:[num:sg, ind:I2], qnt:exist, ana:N2-N3, para:P2-P3, tree:EXT]),
  noun_phrase([arg:[num:sg, ind:I2], loc:cons, fcn:nsubj, qnt:card, drs:S1-S2, sco:S2-S2, ana:N3-N4, para:P3-P4, tree:NP2]).


sentence_2([crd:'-', drs:D1-D3, ana:N1-[['</sub>']|N4], para:P1-P4, tree:[s2_5, NP1, EXT, NP2]])
  -->
  noun_phrase([arg:A1, loc:ante, fcn:extra, qnt:all, drs:D1-D3, sco:S1-S2, ana:[['<sub>']|N1]-N2, para:P1-P2, tree:NP1]),
  existential_there([wfm:[there, are], arg:[num:pl, ind:I2], qnt:exist, ana:N2-N3, para:P2-P3, tree:EXT]),
  noun_phrase([arg:[num:pl, ind:I2], loc:cons, fcn:nsubj, qnt:card, drs:S1-S2, sco:S2-S2, ana:N3-N4, para:P3-P4, tree:NP2]).


% -----

noun_phrase([arg:A, loc:ante, fcn:extra, qnt:all, drs:D, sco:S, ana:N1-N3, para:P1-P3, tree:[np_6, Det, Noun]])
  -->
  determiner([arg:A, fcn:extra, qnt:all, drs:D, res:R, sco:S, ana:N1-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R, ana:N2-N3, para:P2-P3, tree:Noun]).


noun_phrase([arg:A, loc:ante, fcn:extra, qnt:all, drs:D, sco:S, ana:N1-N5, para:P1-P4, tree:[np_7, Det, Noun, RC0]])
  -->
  determiner([arg:A, fcn:extra, qnt:all, drs:D, res:R1-R3, sco:S, ana:N0-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  relative_clause_0([crd:'+', arg:A, loc:ante, drs:R2-R3, ana:N1-N5, para:P3-P4, tree:RC0]).


noun_phrase([arg:A, loc:ante, fcn:extra, qnt:all, drs:D, sco:S, ana:N1-N5, para:P1-P5, tree:[np_8, Det, Adj, Noun, RC0]])
  -->
  determiner([arg:A, fcn:extra, qnt:all, drs:D, res:R1-R4, sco:S, ana:N0-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  relative_clause_0([crd:'+', arg:A, loc:ante, drs:R3-R4, ana:N1-N5, para:P4-P5, tree:RC0]).


% ----- MERGE???

% For every job there is exactly one person.
%
noun_phrase([arg:A, loc:cons, fcn:nsubj, qnt:card, drs:D, sco:R3-S, ana:N1-N1, para:P1-P3, tree:[np_9, Card, Noun]])
  -->
  cardinal([arg:A, drs:D, res:R1-R2, sco:R4-S, ana:_-_, para:P1-P2, tree:Card]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:_-_, para:P2-P3, tree:Noun]).


% For every job there is exactly one person who holds the job.
%
noun_phrase([arg:A, loc:cons, fcn:nsubj, qnt:card, drs:D, sco:R4-S, ana:N1-N4, para:P1-P4, tree:[np_10, Card, Noun, RC0]])
  -->
  cardinal([arg:A, drs:D, res:R1-R2, sco:R4-S, ana:_-_, para:P1-P2, tree:Card]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:_-_, para:P2-P3, tree:Noun]),
  relative_clause_0([crd:'+', arg:A, loc:L, drs:R3-R4, ana:N1-N4, para:P3-P4, tree:RC0]).


% ------------------------------------------------------------------------
% Constraints
%
%  - Exclude that [...]
%  - exclude that [...]
%
% ------------------------------------------------------------------------

sentence_2([crd:'-', drs:[drs(U1, C1)|D1]-[drs(U3, [cstr drs(U2, C2)|C3])|D3], ana:N1-[['</sub>']|N4], para:P1-P4, tree:[s2_6, Cstr, RP, S1]])
  -->
  constraint([wfm:['Exclude'], ana:[['<sub>']|N1]-N2, para:P1-P2, tree:Cstr]),
  relative_pronoun([wfm:[that], ana:N2-N3, para:P2-P3, tree:RP]),
  sentence_1([crd:'+', loc:ante, drs:[drs([], []), drs(U1, C1)|D1]-[drs(U2, C2), drs(U3, C3)|D3], ana:N3-N4, para:P3-P4, tree:S1]).


sentence_2([crd:'-', drs:[drs(U1, C1)|D1]-[drs(U3, [cstr drs(U2, C2)|C3])|D3], ana:N1-[['</sub>']|N4], para:P1-P4, tree:[s2_7, Cstr, RP, S1]])
  -->
  constraint([wfm:[exclude], ana:[['<sub>']|N1]-N2, para:P1-P2, tree:Cstr]),
  relative_pronoun([wfm:[that], ana:N2-N3, para:P2-P3, tree:RP]),
  sentence_1([crd:'+', loc:ante, drs:[drs([], []), drs(U1, C1)|D1]-[drs(U2, C2), drs(U3, C3)|D3], ana:N3-N4, para:P3-P4, tree:S1]).


sentence_2([crd:'-', drs:[drs(U1, C1)|D1]-[drs(U3, [cstr drs(U2, C2)|C3])|D3], ana:N1-[['</sub>']|N4], para:P1-P4, tree:[s2_8, Cstr, RP, S1]])
  -->
  constraint([wfm:['It', is, not, the, case], ana:[['<sub>']|N1]-N2, para:P1-P2, tree:Cstr]),
  relative_pronoun([wfm:[that], ana:N2-N3, para:P2-P3, tree:RP]),
  sentence_1([crd:'+', loc:ante, drs:[drs([], []), drs(U1, C1)|D1]-[drs(U2, C2), drs(U3, C3)|D3], ana:N3-N4, para:P3-P4, tree:S1]).


sentence_2([crd:'-', drs:[drs(U1, C1)|D1]-[drs(U3, [cstr drs(U2, C2)|C3])|D3], ana:N1-[['</sub>']|N4], para:P1-P4, tree:[s2_9, Cstr, RP, S1]])
  -->
  constraint([wfm:[it, is, not, the, case], ana:[['<sub>']|N1]-N2, para:P1-P2, tree:Cstr]),
  relative_pronoun([wfm:[that], ana:N2-N3, para:P2-P3, tree:RP]),
  sentence_1([crd:'+', loc:ante, drs:[drs([], []), drs(U1, C1)|D1]-[drs(U2, C2), drs(U3, C3)|D3], ana:N3-N4, para:P3-P4, tree:S1]).


sentence_2([crd:'-', drs:[drs(U1, C1)|D1]-[drs(U3, [cstr drs(U2, C2)|C3])|D3], ana:N1-[['</sub>']|N3], para:P1-P3, tree:[s2_10, Cstr, RC1]])
  -->
  constraint([wfm:['Exclude'], ana:[['<sub>']|N1]-N2, para:P1-P2, tree:Cstr]),
  relative_clause_1([crd:'+', drs:[drs([], []), drs(U1, C1)|D1]-[drs(U2, C2), drs(U3, C3)|D3], ana:N2-N3, para:P2-P3, tree:RC1]).


sentence_2([crd:'-', drs:[drs(U1, C1)|D1]-[drs(U3, [cstr drs(U2, C2)|C3])|D3], ana:N1-[['</sub>']|N3], para:P1-P3, tree:[s2_11, Cstr, RC1]])
  -->
  constraint([wfm:['It', is, not, the, case], ana:[['<sub>']|N1]-N2, para:P1-P2, tree:Cstr]),
  relative_clause_1([crd:'+', drs:[drs([], []), drs(U1, C1)|D1]-[drs(U2, C2), drs(U3, C3)|D3], ana:N2-N3, para:P2-P3, tree:RC1]).


% -----

relative_clause_1([crd:'-', drs:D1-D2, ana:N1-N3, para:P1-P3, tree:[rc_1, RP, S0]])
  -->
  relative_pronoun([wfm:[that], ana:N1-N2, para:P1-P2, tree:RP]),
  sentence_0([crd:'-', loc:ante, drs:D1-D2, ana:N2-N3, para:P2-P3, tree:S0]).


relative_clause_1([crd:'and', drs:D1-D2, ana:N1-N3, para:P1-P3, tree:[rc_2, RP, S0]])
  -->
  relative_pronoun([wfm:[that], ana:N1-N2, para:P1-P2, tree:RP]),
  sentence_0([crd:'-', loc:ante, drs:D1-D2, ana:N2-N3, para:P2-P3, tree:S0]).


relative_clause_1([crd:'+', drs:D1-D3, ana:N1-N5, para:P1-P5, tree:[rc_3, RP, S0, Crd, RC]])
  -->
  relative_pronoun([wfm:[that], ana:N1-N2, para:P1-P2, tree:RP]),	  
  sentence_0([crd:'-', loc:ante, drs:D1-D2, ana:N2-N3, para:P2-P3, tree:S0]),	  
  coordination([wfm:[and], ana:N3-N4, para:P3-P4, tree:Crd]),	  
  relative_clause_1([crd:'and', drs:D2-D3, ana:N4-N5, para:P4-P5, tree:RC]).


relative_clause_1([crd:'and', drs:D1-D3, ana:N1-N5, para:P1-P5, tree:[rc_4, RP, S0, Crd, RC]])
  -->
  relative_pronoun([wfm:[that], ana:N1-N2, para:P1-P2, tree:RP]),	  
  sentence_0([crd:'-', loc:ante, drs:D1-D2, ana:N2-N3, para:P2-P3, tree:S0]),	  
  coordination([wfm:[and], ana:N3-N4, para:P3-P4, tree:Crd]),	  
  relative_clause_1([crd:'and', drs:D2-D3, ana:N4-N5, para:P4-P5, tree:RC]).


% ------------------------------------------------------------------------
% Defaults
%
%  - Students normally [...]
%  - Students of [...] normally [...]
% ------------------------------------------------------------------------


% to do think about "gen" versus "all"

sentence_2([crd:'-', drs:D, ana:N1-[['</sub>']|N3], para:P1-P3, tree:[s2_12, NP, VP]])
  -->
  noun_phrase([arg:[num:pl, ind:I], loc:gen, fcn:subj, qnt:all, drs:D, sco:S, ana:[['<sub>']|N1]-N2, para:P1-P2, tree:NP]),
  verb_phrase([crd:'-', arg:[num:pl, ind:I], loc:gen, drs:S, ana:N2-N3, para:P2-P3, tree:VP]).


noun_phrase([arg:[num:pl, ind:I], 
             loc:gen, 
             fcn:subj, 
             qnt:Q,
             drs:D1-[drs(U1, [drs(U2, C2) ~~> drs(U3, C3)|C1])|Top],  
             sco:[drs([], [])|R2]-[drs(U3, C3), drs(U2, C2), drs(U1, C1)|Top],
             ana:N1-N2,
             para:P1-P2,
             tree:[np_11, Noun]])
  -->
  count_noun([wfm:WF, arg:[num:pl, ind:I], drs:[drs([], [])|D1]-R2, ana:N1-N2, para:P1-P2, tree:Noun]).
  
 
noun_phrase([arg:[num:pl, ind:I1], 
             loc:gen, 
             fcn:subj, 
             qnt:Q,
             drs:D1-[drs(U1, [drs(U2, C2) ~~> drs(U3, C3)|C1])|Top],  
             sco:[drs([], [])|R4]-[drs(U3, C3), drs(U2, C2), drs(U1, C1)|Top],
             ana:N1-N4, 
             para:P1-P4,
             tree:[np_12, Noun, Prep, NP]])
  -->
  count_noun([wfm:WF, arg:[num:pl, ind:I1], drs:[drs([], [])|D1]-R2, ana:N1-N2, para:P1-P2, tree:Noun]),
  preposition([wfm:[of], arg:[num:pl, ind:I1], arg:[num:sg, ind:I2], drs:R2-R3, ana:N2-N3, para:P2-P3, tree:Prep]),
  noun_phrase([arg:[num:sg, ind:I2], loc:L, fcn:pobj, qnt:Q2, drs:R3-R4, sco:S2-S2, ana:N1-N3-N4, para:P3-P4, tree:NP]).


verb_phrase([crd:'-', arg:[num:pl, ind:I], loc:gen, drs:D1-S4, ana:N1-N6, para:P1-P6, tree:[vp_33, Cop, Adv, RAdj, Name]])
  -->
  copula([wfm:WF, arg:[num:pl, ind:I], vform:V, evtl:E, drs:S1-S2, ana:N1-N2, para:P1-P2, tree:Cop]),
  adverb([wfm:[normally], evtl:E, drs:S2-S3, ana:N2-N3, para:P2-P3, tree:Adv]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:S3-S4, ana:N3-N4, para:P3-P4, tree:RAdj]),
  name([arg:A2, drs:[drs([], [])]-D2, ana:[]-N5, para:P4-P5, tree:Name]),
  { anaphora_resolution([arg:A2, ref:'?', drs:D1-[], ant:D2, sco:S1-[], ana:N1-N5-N6, para:P4-P5-P6]) }.


verb_phrase([crd:'-', arg:[num:pl, ind:I], loc:gen, drs:D1-S3, ana:N1-N6, para:P1-P6, tree:[vp_34, Adv, TV, Det, Noun]])
  -->
  adverb([wfm:[normally], evtl:E, drs:S1-S2, ana:N1-N2, para:P1-P2, tree:Adv]),
  transitive_verb([wfm:WF1, arg:[num:pl, ind:I], arg:A2, vform:fin, evtl:E, con:C, drs:S2-S3, ana:N2-N3, para:P2-P3, tree:TV]),   
  determiner([arg:A2, fcn:dobj, qnt:def, drs:D, res:R, sco:S1-S3, ana:[]-N4, para:P3-P4, tree:Det]),
  count_noun([wfm:WF2, arg:A2, drs:[drs([], [])]-D2, ana:N4-N5, para:P4-P5, tree:Noun]),
  { anaphora_resolution([arg:A2, ref:'+', drs:D1-[], ant:D2, sco:S1-[], ana:N1-N5-N6, para:P3-P5-P6]) }.


% ------------------------------------------------------------------------
% Universally quantified sentences
% ------------------------------------------------------------------------

sentence_2([crd:'-', drs:D, ana:N1-[['</sub>']|N3], para:P1-P3, tree:[s2_13a, NP, VP]])
  -->
  noun_phrase([arg:A, loc:ante, fcn:subj, qnt:all, drs:D, sco:S, ana:[['<sub>']|N1]-N2, para:P1-P2, tree:NP]),
  verb_phrase([crd:'+', arg:A, loc:cons, drs:S, ana:N2-N3, para:P2-P3, tree:VP]).


sentence_2([crd:'-', drs:D1-D2, ana:N1-[['</sub>']|N3], para:P1-P3, tree:[s2_13b, NP, VP]])
  -->
  noun_phrase([arg:A, loc:ante, fcn:subj, qnt:neg, drs:D1-D2, sco:S, ana:[['<sub>']|N1]-N2, para:P1-P2, tree:NP]),
  verb_phrase([crd:'+', arg:A, loc:cons, drs:S, ana:N2-N3, para:P2-P3, tree:VP]).


sentence_2([crd:'-',
            drs:D,
            ana:N1-[['</sub>']|N3], para:P1-P3, tree:[s2_14, NP, VP]])
  -->
  noun_phrase([crd:'+',
               arg:A, 
               loc:L, 
               fcn:subj, 
               qnt:all, 
               drs:D, 
               sco:S, 
               ana:[['<sub>']|N1]-N2, 
               para:P1-P2, 
               tree:NP]),
  verb_phrase([crd:'-', 
               arg:A, 
               loc:L, 
               drs:S, 
               ana:N2-N3, 
               para:P2-P3, 
               tree:VP]).


noun_phrase([crd:'+',
             arg:[num:sg, ind:I1], 
             loc:L,
             fcn:subj, 
             qnt:all,
             drs:[drs(U1, C1)|Top]-[drs(U1, [drs(U2, C2) ==> drs(U3, C3), drs(U4, C4) ==> drs(U3, C3)|C1])|Top],
             sco:[drs([], [])]-[drs(U3, C3)],
             ana:N1-N6, 
             para:P1-P6, 
             tree:[np_13, Det1, Noun1, Crd, Det2, Noun2]])
  -->
  determiner([arg:[num:sg, ind:I1], 
              fcn:subj,
              qnt:all, 
              drs:D2, 
              res:R2, 
              sco:S2,
              ana:N1-N2, 
              para:P1-P2, 
              tree:Det1]),
  count_noun([wfm:WF1,
              arg:[num:sg, ind:I1], 
              drs:[drs([], [])]-[drs(U2, C2)],
              ana:N2-N3,
              para:P2-P3, 
              tree:Noun1]),
  coordination([wfm:[and], ana:N3-N4, para:P3-P4, tree:Crd]),
  determiner([arg:[num:sg, ind:I1],
              fcn:subj, 
              qnt:all, 
              drs:D3, 
              res:R3, 
              sco:S3,
              ana:N4-N5, 
              para:P4-P5, 
              tree:Det2]),
  count_noun([wfm:WF2,
              arg:[num:sg, ind:I1], 
              drs:[drs([], [])]-[drs(U4, C4)],
              ana:N5-N6, 
              para:P5-P6, 
              tree:Noun2]).


noun_phrase([crd:'+',
             arg:[num:sg, ind:I], 
             loc:L, 
             fcn:subj, 
             qnt:all, 
             drs:[drs(U1, C1)|Top]-D,
             sco:[drs([], [])]-[drs(U3, C3)],
             ana:N1-N5, 
             para:P1-P5, 
             tree:[np_14, Det, Noun, Comma, NP]])
  -->
  determiner([arg:[num:sg, ind:I], 
              fcn:subj, 
              qnt:all, 
              drs:D2, 
              res:R2,
              sco:S2,
              ana:N1-N2, 
              para:P1-P2, 
              tree:Det]),
  count_noun([wfm:WF,
              arg:[num:sg, ind:I], 
              drs:[drs([], [])]-[drs(U2, C2)],
              ana:N2-N3, 
              para:P2-P3, 
              tree:Noun]), 
  comma([wfm:[','], ana:N3-N4, para:P3-P4, tree:Comma]),
  noun_phrase([crd:'+',
               arg:[num:sg, ind:I], 
               loc:L,
               fcn:subj, 
               qnt:all, 
               drs:[drs(U1, [drs(U2, C2) ==> drs(U3, C3)|C1])|Top]-D,
               sco:[drs([], [])]-[drs(U3, C3)], 
               ana:N4-N5, 
               para:P4-P5, 
               tree:NP]).


% Experimental: Every students has exactly two distinct jobs.
%
sentence_2([crd:'-', 
            drs:D1-D3,
            ana:N1-[['</sub>']|N3], 
            para:P1-P3, 
            tree:[s2_15, NP, VP]])
  -->
  noun_phrase_s([arg:A, 
                 loc:cons, 
                 fcn:subj, 
                 qnt:all, 
                 drs:D1-D2,
                 sco:S, 
                 ana:[['<sub>']|N1]-N2, 
                 para:P1-P2, 
                 tree:NP]),
  verb_phrase_x([crd:'+', arg:A, loc:cons, drs:S, ana:N2-N3, para:P2-P3, tree:VP]),
  { distinct([drs:D1, drs:D2, drs:D3]) }.


distinct([drs:D1, drs:D2, drs:D3]) :- 
   D1 = [drs(U1, C1)|Top],
   D2 = [drs(U1, [drs(U2, [object(V1, ON1, count)]) ==> drs(U3, [pred(E, Var1, Var2, PN), object(V2, ON2, count), Card1])|C1])|Top],
   D3 = [drs(U1, [drs(U2, [object(V1, ON1, count)]) ==> drs(U3, [pred(E, Var1, Var2, PN), object(V2, ON2, count), Card1]), 
                  drs(U2, [object(V1, ON2, count)]) ==> drs(U3, [pred(E, Var2, Var1, PN), object(V2, ON1, count), Card1])|C1])|Top].

/*
sentence_2([crd:'-', 
            drs:[drs(U1, C1)|Top]-[drs(U1, [drs(U2, [object(V1, ON1)]) ==> drs(U3, [predicate(E, PN, Var1, Var2), object(V2, ON2), Card1]), 
                                            drs(U2, [object(V1, ON2)]) ==> drs(U3, [predicate(E, PN, Var2, Var1), object(V2, ON1), Card1])|C1])|Top],
            ana:N1-[['</sub>']|N3], 
            para:P1-P3, 
            tree:[s2_11, NP, VP]])
  -->
  noun_phrase_s([arg:A, 
                 fcn:subj, 
                 qnt:all, 
                 drs:[drs(U1, C1)|Top]-[drs(U1, [drs(U2, [object(V1, ON1)]) ==> drs(U3, [predicate(E, PN, Var1, Var2), object(V2, ON2), Card1])|C1])|Top],
                 sco:S, 
                 ana:[['<sub>']|N1]-N2, 
                 para:P1-P2, 
                 tree:NP]),
  verb_phrase_x([crd:'+', arg:A, qnt:all, drs:S, ana:N2-N3, para:P2-P3, tree:VP]).
*/


noun_phrase_s([arg:A, loc:L, fcn:subj, qnt:all, drs:D, sco:S, ana:N1-N1, para:P1-P3, tree:[np_15, Det, Noun]])
  -->
  determiner([arg:A, fcn:subj, qnt:all, drs:D, res:R, sco:S, ana:N1-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R, ana:N2-N3, para:P2-P3, tree:Noun]).


verb_phrase_x([crd:'+', arg:A1, loc:L, drs:D, ana:N1-N3, para:P1-P3, tree:[vp_35, TV, NP]])
  -->
  transitive_verb([wfm:WF, arg:A1, arg:A2, vform:fin, evtl:E, con:C, drs:R-S, ana:N1-N2, para:P1-P2, tree:TV]),
  noun_phrase_x([arg:A2, loc:L, fcn:dobj, qnt:all>card, drs:D, sco:R-S, ana:N2-N3, para:P2-P3, tree:NP]).


noun_phrase_x([arg:A, loc:L, fcn:dobj, qnt:all>card, drs:D, sco:R3-S, ana:N1-N1, para:P1-P4, tree:[np_16, Card, Adj, Noun]])
  -->
  cardinal([arg:A, drs:D, res:R1-R2, sco:R3-S, ana:_-_, para:P1-P2, tree:Card]),
  adjective([wfm:[distinct], ana:_-_, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:_-_, para:P3-P4, tree:Noun]).

% end experimental


% ------------------------------------------------------------------------
% sentence_1/1
% ------------------------------------------------------------------------

sentence_1([crd:'+', loc:ante, drs:D1-D2, ana:N1-N2, para:P1-P2, tree:[s1_1, S]])
  -->
  sentence_0([crd:'-', loc:ante, drs:D1-D2, ana:N1-N2, para:P1-P2, tree:S]).


% sentence_1([crd:'-', loc:F, drs:D1-D2, ana:N1-N2, para:P1-P2, tree:[s1_2, S]])
%  -->
%  sentence_0([crd:'-', loc:F, drs:D1-D2, ana:N1-N2, para:P1-P2, tree:S]).


% sentence_1([crd:'and', loc:F, drs:D1-D2, ana:N1-N2, para:P1-P2, tree:[s1_3, S]])
%  -->
%  sentence_0([crd:'-', loc:F, drs:D1-D2, ana:N1-N2, para:P1-P2, tree:S]).


% sentence_1([crd:'and', loc:F, drs:D1-D3, ana:N1-N4, para:P1-P4, tree:[s1_4, S1A, CRD, S1B]])
%  -->
%  sentence_0([crd:'-', loc:F, drs:D1-D2, ana:N1-N2, para:P1-P2, tree:S1A]),	  
%  coordination([wfm:[and], ana:N2-N3, para:P2-P3, tree:CRD]),	  
%  sentence_1([crd:'and', loc:F, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:S1B]).


sentence_1([crd:'+', loc:ante, drs:D1-D3, ana:N1-N4, para:P1-P4, tree:[s1_5, S1A, CRD, S1B]])
  -->
  sentence_0([crd:'-', loc:ante, drs:D1-D2, ana:N1-N2, para:P1-P2, tree:S1A]),	  
  coordination([wfm:[and], ana:N2-N3, para:P2-P3, tree:CRD]),	  
  sentence_1([crd:'+', loc:ante, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:S1B]).


% ------------------------------------------------------------------------
% sentence_0/1
% ------------------------------------------------------------------------


% decl: A student works ...
%
sentence_0([crd:'-', loc:decl, drs:D, ana:N1-N3, para:P1-P3, tree:[s0_1, NP, VP]])
  -->
  noun_phrase([crd:'-', arg:A, loc:decl, fcn:subj, qnt:exist, drs:D, sco:S, ana:N1-N2, para:P1-P2, tree:NP]),
  verb_phrase([crd:'+', arg:A, loc:decl, drs:S, ana:N2-N3, para:P2-P3, tree:VP]).


% decl: The student works. 
%
sentence_0([crd:'-', loc:decl, drs:D, ana:N1-N3, para:P1-P3, tree:[s0_2, NP, VP]])
  -->
  noun_phrase([crd:'-', arg:A, loc:decl, fcn:subj, qnt:def, drs:D, sco:S, ana:N1-N2, para:P1-P2, tree:NP]),
  verb_phrase([crd:'+', arg:A, loc:decl, drs:S, ana:N2-N3, para:P2-P3, tree:VP]).


% decl: Robert, Thelma, and Sue work.
%
sentence_0([crd:'-', loc:decl, drs:D, ana:N1-N3, para:P1-P3, tree:[s0_3, NP, VP]])
  -->
  noun_phrase([crd:'+', arg:A, loc:decl, fcn:subj, qnt:def, drs:D, sco:S, ana:N1-N2, para:P1-P2, tree:NP]),
  verb_phrase([crd:'+', arg:A, loc:decl, drs:S, ana:N2-N3, para:P2-P3, tree:VP]).


% ante: [If] a student works [then] ...
%
sentence_0([crd:'-', loc:ante, drs:D, ana:N1-N3, para:P1-P3, tree:[s0_4, NP, VP]])
  -->
  noun_phrase([crd:'-', arg:A, loc:ante, fcn:subj, qnt:exist, drs:D, sco:S, ana:N1-N2, para:P1-P2, tree:NP]),
  verb_phrase([crd:'+', arg:A, loc:ante, drs:S, ana:N2-N3, para:P2-P3, tree:VP]).


% ante: [If] the student works [then] ...
%
sentence_0([crd:'-', loc:ante, drs:D, ana:N1-N3, para:P1-P3, tree:[s0_5, NP, VP]])
  -->
  noun_phrase([crd:'-', arg:A, loc:ante, fcn:subj, qnt:def, drs:D, sco:S, ana:N1-N2, para:P1-P2, tree:NP]),
  verb_phrase([crd:'+', arg:A, loc:ante, drs:S, ana:N2-N3, para:P2-P3, tree:VP]).


% ante: [If] Robert, Thelma, and Sue work [then] ...
%
sentence_0([crd:'-', loc:ante, drs:D, ana:N1-N3, para:P1-P3, tree:[s0_6, NP, VP]])
  -->
  noun_phrase([crd:'+', arg:A, loc:ante, fcn:subj, qnt:def, drs:D, sco:S, ana:N1-N2, para:P1-P2, tree:NP]),
  verb_phrase([crd:'+', arg:A, loc:ante, drs:S, ana:N2-N3, para:P2-P3, tree:VP]).


% decl: Coffee is a drink.
%
sentence_0([crd:'-', loc:decl, drs:D, ana:N1-N3, para:P1-P3, tree:[s0_7, NP, VP]])
  -->
  noun_phrase([crd:'-', arg:A, loc:decl, fcn:subj, qnt:mass, drs:D, sco:S, ana:N1-N2, para:P1-P2, tree:NP]),
  verb_phrase([crd:'+', arg:A, loc:decl, drs:S, ana:N2-N3, para:P2-P3, tree:VP]).


% ante: [If] coffee is a drink [then] ...
%
sentence_0([crd:'-', loc:ante, drs:D, ana:N1-N3, para:P1-P3, tree:[s0_8, NP, VP]])
  -->
  noun_phrase([crd:'-', arg:A, loc:ante, fcn:subj, qnt:mass, drs:D, sco:S, ana:N1-N2, para:P1-P2, tree:NP]),
  verb_phrase([crd:'+', arg:A, loc:ante, drs:S, ana:N2-N3, para:P2-P3, tree:VP]).


% decl: Coffee, milk, and tea are drink.
%
sentence_0([crd:'-', loc:decl, drs:D, ana:N1-N3, para:P1-P3, tree:[s0_9, NP, VP]])
  -->
  noun_phrase([crd:'+', arg:A, loc:decl, fcn:subj, qnt:mass, drs:D, sco:S, ana:N1-N2, para:P1-P2, tree:NP]),
  verb_phrase([crd:'+', arg:A, loc:decl, drs:S, ana:N2-N3, para:P2-P3, tree:VP]).


% ante: [If] coffee, milk, and tea are drinks [then] ...
%
sentence_0([crd:'-', loc:ante, drs:D, ana:N1-N3, para:P1-P3, tree:[s0_10, NP, VP]])
  -->
  noun_phrase([crd:'+', arg:A, loc:ante, fcn:subj, qnt:mass, drs:D, sco:S, ana:N1-N2, para:P1-P2, tree:NP]),
  verb_phrase([crd:'+', arg:A, loc:ante, drs:S, ana:N2-N3, para:P2-P3, tree:VP]).


% ---------------------------------------


% decl: There exists a student ...
%
sentence_0([crd:'-', loc:decl, drs:D1-D3, ana:N1-N3, para:P1-P3, tree:[s0_11, EX, NP]])
  -->
  existential_there([wfm:WF, arg:A, qnt:exist, ana:N1-N2, para:P1-P2, tree:EX]),
  noun_phrase([arg:A, loc:decl, fcn:dobj, qnt:exist, drs:D1-D2, sco:D2-D3, ana:N2-N3, para:P2-P3, tree:NP]).


% ante: [If] there exists a student ...
%
sentence_0([crd:'-', loc:ante, drs:D1-D3, ana:N1-N3, para:P1-P3, tree:[s0_12, EX, NP]])
  -->
  existential_there([wfm:WF, arg:A, qnt:exist, ana:N1-N2, para:P1-P2, tree:EX]),
  noun_phrase([arg:A, loc:ante, fcn:dobj, qnt:exist, drs:D1-D2, sco:D2-D3, ana:N2-N3, para:P2-P3, tree:NP]).


% decl: There exists exactly one student ...
%
sentence_0([crd:'-', loc:decl, drs:D1-D3, ana:N1-N3, para:P1-P3, tree:[s0_13, EX, NP]])
  -->
  existential_there([wfm:WF, arg:[num:sg, ind:I], qnt:exist, ana:N1-N2, para:P1-P2, tree:EX]),
  noun_phrase([crd:'-', arg:[num:sg, ind:I], loc:decl, fcn:nsubj, qnt:card, drs:D1-D2, sco:D2-D3, ana:N2-N3, para:P2-P3, tree:NP]).


% ante: [If] there exits exactly one student ...
%
sentence_0([crd:'-', loc:ante, drs:D1-D3, ana:N1-N3, para:P1-P3, tree:[s0_14, EX, NP]])
  -->
  existential_there([wfm:WF, arg:[num:sg, ind:I], qnt:exist, ana:N1-N2, para:P1-P2, tree:EX]),
  noun_phrase([crd:'-', arg:[num:sg, ind:I], loc:ante, fcn:nsubj, qnt:card, drs:D1-D2, sco:D2-D3, ana:N2-N3, para:P2-P3, tree:NP]).


% decl: There exist exactly two students ...
%
sentence_0([crd:'-', loc:decl, drs:D1-D3, ana:N1-N3, para:P1-P3, tree:[s0_15, EX, NP]])
  -->
  existential_there([wfm:WF, arg:[num:pl, ind:I1], qnt:exist, ana:N1-N2, para:P1-P2, tree:EX]),
  noun_phrase([crd:'+', arg:[num:pl, ind:I1], loc:decl, fcn:nsubj, qnt:card, drs:D1-D2, sco:D2-D3, ana:N2-N3, para:P2-P3, tree:NP]).


% ante: [If] there exist exactly two students ...
%
sentence_0([crd:'-', loc:ante, drs:D1-D3, ana:N1-N3, para:P1-P3, tree:[s0_16, EX, NP]])
  -->
  existential_there([wfm:WF, arg:[num:pl, ind:I1], qnt:exist, ana:N1-N2, para:P1-P2, tree:EX]),
  noun_phrase([crd:'+', arg:[num:pl, ind:I1], loc:ante, fcn:nsubj, qnt:card, drs:D1-D2, sco:D2-D3, ana:N2-N3, para:P2-P3, tree:NP]).


% decl: There are a student, a job and a lecturer ...
%
sentence_0([crd:'-', loc:decl, drs:D1-D3, ana:N1-N3, para:P1-P3, tree:[s0_17, EX, NP]])
  -->
  existential_there([wfm:WF, arg:[num:pl, ind:I1], qnt:exist, ana:N1-N2, para:P1-P2, tree:EX]),
  noun_phrase([crd:'+', arg:[num:pl, ind:I1], loc:decl, fcn:nsubj, qnt:exist, drs:D1-D2, sco:D2-D3, ana:N2-N3, para:P2-P3, tree:NP]).


% ante: [If] there are a student, a job and a lecturer ...
%
sentence_0([crd:'-', loc:ante, drs:D1-D3, ana:N1-N3, para:P1-P3, tree:[s0_18, EX, NP]])
  -->
  existential_there([wfm:WF, arg:[num:pl, ind:I1], qnt:exist, ana:N1-N2, para:P1-P2, tree:EX]),
  noun_phrase([crd:'+', arg:[num:pl, ind:I1], loc:ante, fcn:nsubj, qnt:exist, drs:D1-D2, sco:D2-D3, ana:N2-N3, para:P2-P3, tree:NP]).


% cons: [then] sentence (everything needs to be introduced apart from constants).
%
sentence_0([crd:'-', loc:cons, drs:D, ana:N1-N3, para:P1-P3, tree:[s0_19, NP, VP]])
  -->
  noun_phrase([arg:[num:Num, ind:I], loc:cons, fcn:subj, qnt:def, drs:D, sco:S, ana:N1-N2, para:P1-P2, tree:NP]),
  verb_phrase([crd:_, arg:[num:Num, ind:I], loc:cons, drs:S, ana:N2-N3, para:P2-P3, tree:VP]).


% ------------------------------------------------------------------------
% noun_phrase/1  (not coordinated
% ------------------------------------------------------------------------

noun_phrase([crd:'-', arg:A, loc:L, fcn:subj, qnt:exist, drs:D, sco:S, ana:N1-N2, para:P1-P2, tree:[np_001, NP]])
   -->
   noun_phrase([arg:A, loc:L, fcn:subj, qnt:exist, drs:D, sco:S, ana:N1-N2, para:P1-P2, tree:NP]).

   
noun_phrase([crd:'-', arg:A, loc:L, fcn:subj, qnt:def, drs:D, sco:S, ana:N1-N2, para:P1-P2, tree:[np_002, NP]])
   -->
   noun_phrase([arg:A, loc:L, fcn:subj, qnt:def, drs:D, sco:S, ana:N1-N2, para:P1-P2, tree:NP]).

   
noun_phrase([crd:'-', arg:A, loc:L, fcn:subj, qnt:mass, drs:D, sco:S, ana:N1-N2, para:P1-P2, tree:[np_003, NP]])
   -->
     noun_phrase([arg:A, loc:L, fcn:subj, qnt:mass, drs:D, sco:S, ana:N1-N2, para:P1-P2, tree:NP]).


noun_phrase([crd:'-', arg:A, loc:L, fcn:subj, qnt:all, drs:D, sco:S, ana:N1-N2, para:P1-P2, tree:[np_003, NP]])
   -->
   noun_phrase([arg:A, loc:L, fcn:subj, qnt:all, drs:D, sco:S, ana:N1-N2, para:P1-P2, tree:NP]).



% ---------------------------------------

% Enumeration: cardinality
%

% Enumeration: [There are] exactly six students ...
%
noun_phrase([crd:_, arg:A, loc:decl, fcn:nsubj, qnt:card, drs:D, sco:R4-S, ana:N1-N1, para:P1-P3, tree:[np_17, Card, Noun]])
  -->
  cardinal([wfm:[exactly|WF1], arg:A, drs:D, res:R1-R2, sco:R4-S, ana:_-_, para:P1-P2, tree:Card]),
  count_noun([wfm:WF2, arg:A, drs:R2-R3, ana:_-_, para:P2-P3, tree:Noun]),
  { cardinal_to_ordinal_np([drs:R3-R4]) }.


% Conversion of cardinal number to ordinal number
%
cardinal_to_ordinal_np([drs:[drs([X|U1], [object(X, ON, P), cardinal(X, eq, Num)|Con1])|R1]-[drs(U2, Con2)|R1]]) :-
  convert_cardinal_to_ordinal(Num, ON, U1, Con1, U2, Con2), !.

convert_cardinal_to_ordinal(1, ON, U1, Con1, [X|U1], [object(X, ON, P), ordinal(X, 1)|Con1]).

convert_cardinal_to_ordinal(Num1, ON, U1, Con1, [X|U2], [object(X, ON, P), ordinal(X, Num1)|Con2]) :-
  Num2 is Num1 - 1,
  convert_cardinal_to_ordinal(Num2, ON, U1, Con1, U2, Con2).


% Enumeration: [There are exactly] six students and two jobs ...
%
% noun_phrase([crd:'+', arg:[num:pl, ind:[I1, I2]], loc:L, fcn:nsubj, qnt:card, drs:D1-D3, sco:R5-S2, ana:N1-N6, para:P1-P6, tree:[np_18, Card1, Noun1, Crd, Card2, Noun2]])
%  -->
%  cardinal([wfm:[exactly|W1], arg:[num:Num1, ind:I1], drs:D1-D2, res:R1-R2, sco:R3-S1, ana:N1-N2, para:P1-P2, tree:Card1]),
%  count_noun(wfm:WF2, [arg:[num:Num1, ind:I1], drs:R2-R3, ana:N2-N3, para:P2-P3, tree:Noun1]),
%  coordination([wfm:[and], ana:N3-N4, para:P3-P4, tree:Crd]),
%  cardinal([wfm:[exactly|W3], arg:[num:Num2, ind:I2], drs:D2-D3, res:R3-R4, sco:R5-S2, ana:N4-N5, para:P4-P5, tree:Card2]),
%  count_noun([wfm:WF4, arg:[num:Num2, ind:I2], drs:R4-R5, ana:N5-N6, para:P5-P6, tree:Noun2]).


% Enumeration: [There are exactly] six students, two jobs and three lecturers ...
%
% noun_phrase([crd:'+', arg:[num:pl, ind:[I1|I2]], loc:L, fcn:nsubj, qnt:card, drs:D1-D3, sco:R4-S2, ana:N1-N5, para:P1-P5, tree:[np_19, Card, Noun, Comma, NP]])
%  -->
%  cardinal([wfm:[exactly|W1], arg:[num:Num, ind:I1], drs:D1-D2, res:R1-R2, sco:R3-S1, ana:N1-N2, para:P1-P2, tree:Card]),
%  count_noun([wfm:WF2, arg:[num:Num, ind:I1], drs:R2-R3, ana:N2-N3, para:P2-P3, tree:Noun]),
%  comma([wfm:[','], ana:N3-N4, para:P3-P4, tree:Comma]),
%  noun_phrase([crd:'+', arg:[num:pl, ind:I2], loc:L,  fcn:nsubj, qnt:card, drs:D2-D3, sco:R4-S2, ana:N4-N5, para:P4-P5, tree:NP]).


% ---------------------------------------

% Enumeration: existential
%

% Enumeration: There are a student and a job.
%
noun_phrase([crd:'+', arg:[num:pl, ind:[I1, I2]], loc:L, fcn:nsubj, qnt:exist, drs:D1-D4, sco:D3-D4, ana:N1-[N5, N3|N1], para:P1-P6, tree:[np_20, Det1, Noun1, Crd, Det2, Noun2]])
  -->
  determiner([arg:[num:sg, ind:I1], fcn:O, qnt:exist, drs:D1-D3, res:D1-D2, sco:D2-D3, ana:[]-N2, para:P1-P2, tree:Det1]),
  count_noun([wfm:WF1, arg:[num:sg, ind:I1], drs:D1-D2, ana:N2-N3, para:P2-P3, tree:Noun1]),
  coordination([wfm:[and], ana:N3-N3, para:P3-P4, tree:Crd]),
  determiner([arg:[num:sg, ind:I2], fcn:O, qnt:exist, drs:D2-D4, res:D2-D3, sco:D3-D4, ana:[]-N4, para:P4-P5, tree:Det2]),
  count_noun([wfm:WF2, arg:[num:sg, ind:I2], drs:D2-D3, ana:N4-N5, para:P5-P6, tree:Noun2]).


% Enumeration: There are a student, a job and a lecturer ...
%
noun_phrase([crd:'+', arg:[num:pl, ind:[I1|I2]], loc:L, fcn:nsubj, qnt:exist, drs:D1-D4, sco:D3-D4, ana:N1-N4, para:P1-P5, tree:[np_21, Det, Noun, Comma, NP]])
  -->
  determiner([arg:[num:sg, ind:I1], fcn:O, qnt:exist, drs:D1-D3, res:D1-D2, sco:D2-D3, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF1, arg:[num:sg, ind:I1], drs:D1-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  comma([wfm:[','], ana:N3-N3, para:P3-P4, tree:Comma]),
  noun_phrase([crd:'+', arg:[num:pl, ind:I2], loc:L, fcn:nsubj, qnt:exist, drs:D2-D4, sco:D3-D4, ana:[N3|N1]-N4, para:P4-P5, tree:NP]).


% ------------------------------------------------------------------------
% Universally quantified noun phrase (subject position)
% ------------------------------------------------------------------------

% ante: Every lecturer ...
%
noun_phrase([arg:A, loc:ante, fcn:subj, qnt:all, drs:D, sco:S, ana:N1-N1, para:P1-P3, tree:[np_22a, Det, Noun]])
  -->
  determiner([arg:A, fcn:subj, qnt:all, drs:D, res:R, sco:S, ana:N1-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R, ana:N2-N3, para:P2-P3, tree:Noun]).


% ante: No lecturer ...
%
noun_phrase([arg:A, loc:ante, fcn:subj, qnt:neg, drs:D, sco:S, ana:N1-N1, para:P1-P3, tree:[np_22b, Det, Noun]])
  -->
  determiner([arg:A, fcn:subj, qnt:neg, drs:D, res:R, sco:S, ana:N1-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R, ana:N2-N3, para:P2-P3, tree:Noun]).


% ante: Every female lecturer who ...
%
noun_phrase([arg:A, loc:ante, fcn:subj, qnt:all, drs:D, sco:S, ana:N1-N5, para:P1-P5, tree:[np_23a, Det, Adj, Noun, RC0]])
  -->
  determiner([arg:A, fcn:subj, qnt:all, drs:D, res:R1-R4, sco:S, ana:N0-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  relative_clause_0([crd:'+', arg:A, loc:ante, drs:R3-R4, ana:N1-N5, para:P4-P5, tree:RC0]).


% ante: No female lecturer who ...
%
noun_phrase([arg:A, loc:ante, fcn:subj, qnt:neg, drs:D, sco:S, ana:N1-N5, para:P1-P5, tree:[np_23b, Det, Adj, Noun, RC0]])
  -->
  determiner([arg:A, fcn:subj, qnt:neg, drs:D, res:R1-R4, sco:S, ana:N0-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  relative_clause_0([crd:'+', arg:A, loc:ante, drs:R3-R4, ana:N1-N5, para:P4-P5, tree:RC0]).


% ante: Every lecturer who ...
%
noun_phrase([arg:A, loc:ante, fcn:subj, qnt:all, drs:D, sco:S, ana:N1-N5, para:P1-P4, tree:[np_24a, Det, Noun, RC0]])
  -->
  determiner([arg:A, fcn:subj, qnt:all, drs:D, res:R1-R3, sco:S, ana:N0-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  relative_clause_0([crd:'+', arg:A, loc:ante, drs:R2-R3, ana:N1-N5, para:P3-P4, tree:RC0]).


% ante: No lecturer who ...
%
noun_phrase([arg:A, loc:ante, fcn:subj, qnt:neg, drs:D, sco:S, ana:N1-N5, para:P1-P4, tree:[np_24b, Det, Noun, RC0]])
  -->
  determiner([arg:A, fcn:subj, qnt:neg, drs:D, res:R1-R3, sco:S, ana:N0-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  relative_clause_0([crd:'+', arg:A, loc:ante, drs:R2-R3, ana:N1-N5, para:P3-P4, tree:RC0]).


% ante: Every female lecturer of Macquarie University ...
%
noun_phrase([arg:A1, loc:ante, fcn:subj, qnt:all, drs:D, sco:S1, ana:N1-N6, para:P1-P6, tree:[np_25a, Det, Adj, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:subj, qnt:all, drs:D, res:R1-R5, sco:S1, ana:N0-N2, para:P1-P2, tree:Det]),
  adjective([arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A1, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, drs:R3-R4, ana:N4-N5, para:P4-P5, tree:Prep]),
  noun_phrase([arg:A2, loc:ante, fcn:pobj, qnt:Q2, drs:R4-R5, sco:S2-S2, ana:N1-N1-N6, para:P5-P6, tree:NP]).


% ante: No female lecturer of Macquarie University ...
%
noun_phrase([arg:A1, loc:ante, fcn:subj, qnt:neg, drs:D, sco:S1, ana:N1-N6, para:P1-P6, tree:[np_25b, Det, Adj, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:subj, qnt:neg, drs:D, res:R1-R5, sco:S1, ana:N0-N2, para:P1-P2, tree:Det]),
  adjective([arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A1, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, drs:R3-R4, ana:N4-N5, para:P4-P5, tree:Prep]),
  noun_phrase([arg:A2, loc:ante, fcn:pobj, qnt:Q2, drs:R4-R5, sco:S2-S2, ana:N1-N1-N6, para:P5-P6, tree:NP]).


% ante: Every lecturer of Macquarie University ...
%
noun_phrase([arg:A1, loc:ante, fcn:subj, qnt:all, drs:D, sco:S1, ana:N1-N5, para:P1-P5, tree:[np_26a, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:subj, qnt:all, drs:D, res:R1-R4, sco:S1, ana:N0-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:ante, fcn:pobj, qnt:Q2, drs:R3-R4, sco:S2-S2, ana:N1-N1-N5, para:P4-P5, tree:NP]).


% ante: No lecturer of Macquarie University ...
%
noun_phrase([arg:A1, loc:ante, fcn:subj, qnt:neg, drs:D, sco:S1, ana:N1-N5, para:P1-P5, tree:[np_26b, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:subj, qnt:neg, drs:D, res:R1-R4, sco:S1, ana:N0-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:ante, fcn:pobj, qnt:Q2, drs:R3-R4, sco:S2-S2, ana:N1-N1-N5, para:P4-P5, tree:NP]).


% ante: Every female lecturer ...
%
noun_phrase([arg:A, loc:ante, fcn:subj, qnt:all, drs:D, sco:S, ana:N1-N1, para:P1-P4, tree:[np_27a, Det, Adj, Noun]])
  -->
  determiner([arg:A, fcn:subj, qnt:all, drs:D, res:R1-R3, sco:S, ana:N1-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]).


% ante: No female lecturer ...
%
noun_phrase([arg:A, loc:ante, fcn:subj, qnt:neg, drs:D, sco:S, ana:N1-N1, para:P1-P4, tree:[np_27b, Det, Adj, Noun]])
  -->
  determiner([arg:A, fcn:subj, qnt:neg, drs:D, res:R1-R3, sco:S, ana:N1-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]).


% ------------------------------------------------------------------------
% Definite and existential noun phrases (subject position)
% ------------------------------------------------------------------------

% decl: The successful student who ...
%
noun_phrase([arg:A, loc:decl, fcn:subj, qnt:def, drs:D1-D2, sco:R5-D2, ana:N1-N6, para:P1-P6, tree:[np_28, Det, Adj, Noun, RC0]])
  -->
  determiner([arg:A, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:R3, sco:R4-[], ana:N1-N4-N5, para:P1-P4-P5]) },
  relative_clause_0([crd:'+', arg:A, loc:L, drs:R4-R5, ana:N5-N6, para:P5-P6, tree:RC0]).


% ante: ... the successful student who ...
%
noun_phrase([arg:A, loc:ante, fcn:subj, qnt:def, drs:D1-D2, sco:R5-D2, ana:N1-N6, para:P1-P6, tree:[np_29, Det, Adj, Noun, RC0]])
  -->
  determiner([arg:A, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:R3, sco:R4-[], ana:N1-N4-N5, para:P1-P4-P5]) },
  relative_clause_0([crd:'+', arg:A, loc:L, drs:R4-R5, ana:N5-N6, para:P5-P6, tree:RC0]).
  

% L: A successful student who ...
%
noun_phrase([arg:A, loc:L, fcn:subj, qnt:exist, drs:D, sco:S, ana:N1-N5, para:P1-P5, tree:[np_30, Det, Adj, Noun, RC0]])
  -->
  determiner([arg:A, fcn:subj, qnt:exist, drs:D, res:R1-R4, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  relative_clause_0([crd:'+', arg:A, loc:L, drs:R3-R4, ana:[N4|N1]-N5, para:P4-P5, tree:RC0]).


% -----

% decl: The student who ...
%
noun_phrase([arg:A, loc:decl, fcn:subj, qnt:def, drs:D1-D2, sco:R4-D2, ana:N1-N5, para:P1-P5, tree:[np_31, Det, Noun, RC0]])
  -->
  determiner([arg:A, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:R2, sco:R3-[], ana:N1-N3-N4, para:P1-P3-P4]) },
  relative_clause_0([crd:'+', arg:A, loc:L, drs:R3-R4, ana:N4-N5, para:P4-P5, tree:RC0]).


% ante: ... the student who ...
%
noun_phrase([arg:A, loc:ante, fcn:subj, qnt:def, drs:D1-D2, sco:R4-D2, ana:N1-N5, para:P1-P5, tree:[np_32, Det, Noun, RC0]])
  -->
  determiner([arg:A, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:R2, sco:R3-[], ana:N1-N3-N4, para:P1-P3-P4]) },
  relative_clause_0([crd:'+', arg:A, loc:L, drs:R3-R4, ana:N4-N5, para:P4-P5, tree:RC0]).


% L: A student who ...
%
noun_phrase([arg:A, loc:L, fcn:subj, qnt:exist, drs:D, sco:S, ana:N1-N4, para:P1-P4, tree:[np_33, Det, Noun, RC0]])
  -->
  determiner([arg:A, fcn:subj, qnt:exist, drs:D, res:R1-R3, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  relative_clause_0([crd:'+', arg:A, loc:L, drs:R2-R3, ana:[N3|N1]-N4, para:P3-P4, tree:RC0]).


% -----

% decl: The parent of the child ...
%
noun_phrase([arg:A1, loc:decl, fcn:subj, qnt:def, drs:D1-D6, sco:D5-D6, ana:N1-N6, para:P1-P6, tree:[np_34, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:L, fcn:pobj, qnt:Q2, drs:D3-D4, sco:S2-S2, ana:N1-N4-N5, para:P4-P5, tree:NP]), 
  { anaphora_resolution([arg:A1, ref:'?', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P5-P6]) }.


% ante: ... the parent of the child ...
%
noun_phrase([arg:A1, loc:ante, fcn:subj, qnt:def, drs:D1-D6, sco:D5-D6, ana:N1-N6, para:P1-P6, tree:[np_35, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:L, fcn:pobj, qnt:Q2, drs:D3-D4, sco:S2-S2, ana:N1-N4-N5, para:P4-P5, tree:NP]), 
  { anaphora_resolution([arg:A1, ref:'?', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P5-P6]) }. 


% cons: .... the parent of the child ...
%
noun_phrase([arg:A1, loc:cons, fcn:subj, qnt:def, drs:D1-D6, sco:D5-D6, ana:N1-N6, para:P1-P6, tree:[np_36, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, ref:'+', drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, ref:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:cons, fcn:pobj, qnt:Q2, drs:D3-D4, sco:S2-S2, ana:N1-N4-N5, para:P4-P5, tree:NP]), 
  { anaphora_resolution([arg:A1, ref:'+', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P5-P6]) }. 


% -----

% decl: The parent of a child ...
%
noun_phrase([arg:A1, loc:decl, fcn:subj, qnt:def, drs:D, sco:S1, ana:N1-[N5|N1], para:P1-P5, tree:[np_37, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:subj, qnt:def, drs:D, res:R1-R4, sco:S1, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:L, fcn:pobj, qnt:exist, drs:R3-R4, sco:S2-S2, ana:N1-N4-N5, para:P4-P5, tree:NP]).


% ante: ... the parent of a child ...
%
noun_phrase([arg:A1, loc:ante, fcn:subj, qnt:def, drs:D, sco:S1, ana:N1-[N5|N1], para:P1-P5, tree:[np_38, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:subj, qnt:def, drs:D, res:R1-R4, sco:S1, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:L, fcn:pobj, qnt:exist, drs:R3-R4, sco:S2-S2, ana:N1-N4-N5, para:P4-P5, tree:NP]).


% L: A parent of a child ...
% L: A parent of the child ...
%
noun_phrase([arg:A1, loc:L, fcn:subj, qnt:exist, drs:D, sco:S1, ana:N1-[N5|N1], para:P1-P5, tree:[np_39, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:subj, qnt:exist, drs:D, res:R1-R4, sco:S1, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:L, fcn:pobj, qnt:Q2, drs:R3-R4, sco:S2-S2, ana:N1-N4-N5, para:P4-P5, tree:NP]).


% -----

% decl: The successful student ...
%
noun_phrase([arg:A, loc:decl, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_40, Det, Adj, Noun]])
  -->
  determiner([arg:A, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),                                      
  count_noun([wfm:WF, arg:A, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% ante: ... the successful student ...
%
noun_phrase([arg:A, loc:ante, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_41, Det, Adj, Noun]])
  -->
  determiner([arg:A, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),                                      
  count_noun([wfm:WF, arg:A, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% cons: ... the successful student ...
%
noun_phrase([arg:A, loc:cons, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_42, Det, Adj, Noun]])
  -->
  determiner([arg:A, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, ref:'+', drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),                                      
  count_noun([wfm:WF, arg:A, ref:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'+', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% L: A successful student ...
%
noun_phrase([arg:A, loc:L, fcn:subj, qnt:exist, drs:D, sco:S, ana:N1-[N4|N1], para:P1-P4, tree:[np_43, Det, Adj, Noun]])
  -->
  determiner([arg:A, fcn:subj, qnt:exist, drs:D, res:R1-R3, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]).


% -----

% decl: The successful student X1 who ...
%
noun_phrase([arg:A, loc:decl, fcn:subj, qnt:def, drs:D1-D7, sco:D6-D7, ana:N1-N7, para:P1-P7, tree:[np_44, Det, Adj, Noun, Var, RC0]])
  -->
  determiner([arg:A, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D3-D4, ana:N4-N5, para:P4-P5, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P4-P5]) }.
  relative_clause_0([crd:'+', arg:A, loc:decl, drs:D5-D6, ana:N6-N7, para:P6-P7, tree:RC0]).


% ante: ... the successful student X1 who ...
%
noun_phrase([arg:A, loc:ante, fcn:subj, qnt:def, drs:D1-D7, sco:D6-D7, ana:N1-N7, para:P1-P7, tree:[np_45, Det, Adj, Noun, Var, RC0]])
  -->
  determiner([arg:A, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D3-D4, ana:N4-N5, para:P4-P5, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P4-P5]) }.
  relative_clause_0([crd:'+', arg:A, loc:ante, drs:D5-D6, ana:N6-N7, para:P6-P7, tree:RC0]).


% L: A successful student X1 who ...
%
noun_phrase([arg:A, loc:L, fcn:subj, qnt:exist, drs:D, sco:S, ana:N1-N6, para:P1-P6, tree:[np_46, Det, Adj, Noun, Var, RC0]])
  -->
  determiner([arg:A, fcn:subj, qnt:exist, drs:D, res:R1-R5, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', drs:R3-R4, ana:N4-N5, para:P4-P5, tree:Var]),
  relative_clause_0([crd:'+', arg:A, loc:L, drs:R4-R5, ana:[N5|N1]-N6, para:P5-P6, tree:RC0]).


% -----

% decl: The successful student X1 ...
%
noun_phrase([arg:A, loc:decl, fcn:subj, qnt:def, drs:D1-D6, sco:D5-D6, ana:N1-N6, para:P1-P6, tree:[np_47, Det, Adj, Noun, Var]])
  -->
  determiner([arg:A, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D3-D4, ana:N4-N5, para:P4-P5, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P5-P6]) }.


% ante: ... the successful student X1 ...
%
noun_phrase([arg:A, loc:ante, fcn:subj, qnt:def, drs:D1-D6, sco:D5-D6, ana:N1-N6, para:P1-P6, tree:[np_48, Det, Adj, Noun, Var]])
  -->
  determiner([arg:A, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D3-D4, ana:N4-N5, para:P4-P5, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P5-P6]) }.


% cons: ... the successful student X1 ...
%
noun_phrase([arg:A, loc:cons, fcn:subj, qnt:def, drs:D1-D6, sco:D5-D6, ana:N1-N6, para:P1-P6, tree:[np_49, Det, Adj, Noun, Var]])
  -->
  determiner([arg:A, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, ref:'+', drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, ref:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', ref:'+', drs:D3-D4, ana:N4-N5, para:P4-P5, tree:Var]),
  { anaphora_resolution([arg:A, ref:'+', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P5-P6]) }.


% L: A successful student X1 ...
%
noun_phrase([arg:A, loc:L, fcn:subj, qnt:exist, drs:D, sco:S, ana:N1-[N5|N1], para:P1-P5, tree:[np_50, Det, Adj, Noun, Var]])
  -->
  determiner([arg:A, fcn:subj, qnt:exist, drs:D, res:R1-R4, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', drs:R3-R4, ana:N4-N5, para:P4-P5, tree:Var]).


% -----

% decl: The student X1 who ...
%
noun_phrase([arg:A, loc:decl, fcn:subj, qnt:def, drs:D1-D6, sco:D5-D6, ana:N1-N6, para:P1-P6, tree:[np_51, Det, Noun, Var, RC0]])
  -->
  determiner([arg:A, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) },
  relative_clause_0([crd:'+', arg:A, loc:decl, drs:D4-D5, ana:N5-N6, para:P5-P6, tree:RC0]).


% ante: ... the student X1 who ...
%
noun_phrase([arg:A, loc:ante, fcn:subj, qnt:def, drs:D1-D6, sco:D5-D6, ana:N1-N6, para:P1-P6, tree:[np_52, Det, Noun, Var, RC0]])
  -->
  determiner([arg:A, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) },
  relative_clause_0([crd:'+', arg:A, loc:ante, drs:D4-D5, ana:N5-N6, para:P5-P6, tree:RC0]).


% L: A student X1 who ...
%
noun_phrase([arg:A, loc:L, fcn:subj, qnt:exist, drs:D, sco:S, ana:N1-N5, para:P1-P5, tree:[np_52, Det, Noun, Var, RC0]])
  -->
  determiner([arg:A, fcn:subj, qnt:exist, drs:D, res:R1-R4, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Var]),
  relative_clause_0([crd:'+', arg:A, loc:L, drs:R3-R4, ana:[N4|N1]-N5, para:P4-P5, tree:RC0]).


% -----

% decl: The student X1 ...
%
noun_phrase([arg:A, loc:decl, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_53, Det, Noun, Var]])
  -->
  determiner([arg:A, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% ante: ... the student X1 ...
%
noun_phrase([arg:A, loc:ante, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_54, Det, Noun, Var]])
  -->
  determiner([arg:A, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% cons: The student X1 ...
%
noun_phrase([arg:A, loc:cons, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_55, Det, Noun, Var]])
  -->
  determiner([arg:A, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, ref:'+', drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', ref:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A, ref:'+', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% L: A student X1 ...
%
noun_phrase([arg:A, loc:L, fcn:subj, qnt:exist, drs:D, sco:S, ana:N1-[N4|N1], para:P1-P4, tree:[np_56, Det, Noun, Var]])
  -->
  determiner([arg:A, fcn:subj, qnt:exist, drs:D, res:R1-R3, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Var]).


% -----

% decl: The successful student N1 who ...
%
noun_phrase([arg:A1, loc:decl, fcn:subj, qnt:def, drs:D1-D7, sco:D6-D7, ana:N1-N7, para:P1-P7, tree:[np_57, Det, Adj, Noun, Var, RC0]])
  -->
  determiner([arg:A1, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A1, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:D3-D4, ana:N4-N5, para:P4-P5, tree:Var]),
  { anaphora_resolution([arg:A1, ref:'?', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P4-P5]) }.
  relative_clause_0([crd:'+', arg:A2, loc:decl, drs:D5-D6, ana:N6-N7, para:P6-P7, tree:RC0]).


% ante: ... the successful student N1 who ...
%
noun_phrase([arg:A1, loc:ante, fcn:subj, qnt:def, drs:D1-D7, sco:D6-D7, ana:N1-N7, para:P1-P7, tree:[np_58, Det, Adj, Noun, Var, RC0]])
  -->
  determiner([arg:A1, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A1, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:D3-D4, ana:N4-N5, para:P4-P5, tree:Var]),
  { anaphora_resolution([arg:A1, ref:'?', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P4-P5]) }.
  relative_clause_0([crd:'+', arg:A2, loc:ante, drs:D5-D6, ana:N6-N7, para:P6-P7, tree:RC0]).


% L: A successful student N1 who ...
%
noun_phrase([arg:A1, loc:L, fcn:subj, qnt:exist, drs:D, sco:S, ana:N1-N6, para:P1-P6, tree:[np_59, Det, Adj, Noun, Var, RC0]])
  -->
  determiner([arg:A1, fcn:subj, qnt:exist, drs:D, res:R1-R5, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A1, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:R3-R4, ana:N4-N5, para:P4-P5, tree:Var]),
  relative_clause_0([crd:'+', arg:A2, loc:L, drs:R4-R5, ana:[N5|N1]-N6, para:P5-P6, tree:RC0]).


% ----

% decl: The student N1 who ...
%
noun_phrase([arg:A1, loc:decl, fcn:subj, qnt:def, drs:D1-D6, sco:D5-D6, ana:N1-N6, para:P1-P6, tree:[np_60, Det, Noun, Var, RC0]])
  -->
  determiner([arg:A1, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A1, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) },
  relative_clause_0([crd:'+', arg:A2, loc:decl, drs:D4-D5, ana:N5-N6, para:P5-P6, tree:RC0]).


% ante: ... the student N1 who ...
%
noun_phrase([arg:A1, loc:ante, fcn:subj, qnt:def, drs:D1-D6, sco:D5-D6, ana:N1-N6, para:P1-P6, tree:[np_61, Det, Noun, Var, RC0]])
  -->
  determiner([arg:A1, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A1, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) },
  relative_clause_0([crd:'+', arg:A2, loc:ante, drs:D4-D5, ana:N5-N6, para:P5-P6, tree:RC0]).


% L: A student N1 who ...
%
noun_phrase([arg:A1, loc:L, fcn:subj, qnt:exist, drs:D, sco:S, ana:N1-N5, para:P1-P5, tree:[np_62, Det, Noun, Var, RC0]])
  -->
  determiner([arg:A1, fcn:subj, qnt:exist, drs:D, res:R1-R4, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Var]),
  relative_clause_0([crd:'+', arg:A2, loc:L, drs:R3-R4, ana:[N4|N1]-N5, para:P4-P5, tree:RC0]).


% ----

% decl: The successful student N1 ...
%
noun_phrase([arg:A1, loc:decl, fcn:subj, qnt:def, drs:D1-D6, sco:D5-D6, ana:N1-N6, para:P1-P6, tree:[np_63, Det, Adj, Noun, Var]])
  -->
  determiner([arg:A1, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A1, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:D3-D4, ana:N4-N5, para:P4-P5, tree:Var]),
  { anaphora_resolution([arg:A1, ref:'?', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P5-P6]) }.


% ante: ... the successful student N1 ...
%
noun_phrase([arg:A1, loc:ante, fcn:subj, qnt:def, drs:D1-D6, sco:D5-D6, ana:N1-N6, para:P1-P6, tree:[np_64, Det, Adj, Noun, Var]])
  -->
  determiner([arg:A1, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A1, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:D3-D4, ana:N4-N5, para:P4-P5, tree:Var]),
  { anaphora_resolution([arg:A1, ref:'?', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P5-P6]) }.


% cons: ... the successful student N1 ...
%
noun_phrase([arg:A1, loc:cons, fcn:subj, qnt:def, drs:D1-D6, sco:D5-D6, ana:N1-N6, para:P1-P6, tree:[np_65, Det, Adj, Noun, Var]])
  -->
  determiner([arg:A1, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A1, ref:'+', drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A1, ref:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', ref:'+', drs:D3-D4, ana:N4-N5, para:P4-P5, tree:Var]),
  { anaphora_resolution([arg:A1, ref:'+', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P5-P6]) }.


% L: A successful student N1 ...
%
noun_phrase([arg:A1, loc:L, fcn:subj, qnt:exist, drs:D, sco:S, ana:N1-[N5|N1], para:P1-P5, tree:[np_66, Det, Adj, Noun, Var]])
  -->
  determiner([arg:A1, fcn:subj, qnt:exist, drs:D, res:R1-R4, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A1, arg:A2, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  numeric_variable([arg:A1, app:'+', drs:R3-R4, ana:N4-N5, para:P4-P5, tree:Var]).


% ---

% decl: The student N1 ...
%
noun_phrase([arg:A1, loc:decl, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_67, Det, Noun, Var]])
  -->
  determiner([arg:A1, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A1, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% ante: ... the student N1 ...
%
noun_phrase([arg:A1, loc:ante, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_68, Det, Noun, Var]])
  -->
  determiner([arg:A1, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A1, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% cons: ... the student N1 ...
%
noun_phrase([arg:A1, loc:cons, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_69, Det, Noun, Var]])
  -->
  determiner([arg:A1, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, ref:'+', drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', ref:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A1, ref:'+', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% L: A student N1 ...
%
noun_phrase([arg:A1, loc:L, fcn:subj, qnt:exist, drs:D, sco:S, ana:N1-[N4|N1], para:P1-P4, tree:[np_70, Det, Noun, Var]])
  -->
  determiner([arg:A1, fcn:subj, qnt:exist, drs:D, res:R1-R3, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Var]).


% -----

% decl: The student ...
%
noun_phrase([arg:A, loc:decl, fcn:subj, qnt:def, drs:D1-D4, sco:D3-D4, ana:N1-N4, para:P1-P4, tree:[np_71, Det, Noun]])
  -->
  determiner([arg:A, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N3-N4, para:P1-P3-P4]) }.


% ante: ... the student ...
%
noun_phrase([arg:A, loc:ante, fcn:subj, qnt:def, drs:D1-D4, sco:D3-D4, ana:N1-N4, para:P1-P4, tree:[np_72, Det, Noun]])
  -->
  determiner([arg:A, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N3-N4, para:P1-P3-P4]) }.


% cons: ... the student ...
%
noun_phrase([arg:A, loc:cons, fcn:subj, qnt:def, drs:D1-D4, sco:D3-D4, ana:N1-N4, para:P1-P4, tree:[np_73, Det, Noun]])
  -->
  determiner([arg:A, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, ref:'+', drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'+', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N3-N4, para:P1-P3-P4]) }.


% decl: A student ...
%
noun_phrase([arg:A, loc:L, fcn:subj, qnt:exist, drs:D, sco:S, ana:N1-[N3|N1], para:P1-P3, tree:[np_74, Det, Noun]])
  -->
  determiner([arg:A, fcn:subj, qnt:exist, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R, ana:N2-N3, para:P2-P3, tree:Noun]).


% ----

% Ordinal
%

% decl: The first student ...
%
noun_phrase([arg:A, loc:decl, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_75, Det, Ord, Noun]])
  -->
  determiner([arg:A, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  ordinal([arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Ord]),                                      
  count_noun([wfm:WF, arg:A, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% ante: ... the first student ...
%
noun_phrase([arg:A, loc:ante, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_76, Det, Ord, Noun]])
  -->
  determiner([arg:A, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  ordinal([arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Ord]),                                      
  count_noun([wfm:WF, arg:A, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% cons: ... the first student ...
%
noun_phrase([arg:A, loc:cons, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_77, Det, Ord, Noun]])
  -->
  determiner([arg:A, fcn:subj, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  ordinal([arg:A, ref:'+', drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Ord]),                                      
  count_noun([wfm:WF, arg:A, ref:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'+', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% -----

% decl: John who ...
%
noun_phrase([arg:A, loc:decl, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N4, para:P1-P4, tree:[np_78, Name, RC0]])
  -->
  name([arg:A, drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  relative_clause_0([crd:'+', arg:A, loc:decl, drs:D3-D4, ana:N3-N4, para:P3-P4, tree:RC0]).


% ante: ... John who ...
%
noun_phrase([arg:A, loc:ante, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N4, para:P1-P4, tree:[np_79, Name, RC0]])
  -->
  name([arg:A, drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  relative_clause_0([crd:'+', arg:A, loc:ante, drs:D3-D4, ana:N3-N4, para:P3-P4, tree:RC0]).


% -----

% L: John ...
%
noun_phrase([arg:A, loc:L, fcn:subj, qnt:def, drs:D1-D4, sco:D3-D4, ana:N1-N3, para:P1-P3, tree:[np_80, Name]])
  -->
  name([arg:A, drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) }.


% -----

% L; Water ...
%
noun_phrase([arg:A, loc:L, fcn:subj, qnt:def, drs:D1-D4, sco:D3-D4, ana:N1-N3, para:P1-P3, tree:[np_81, MN]])
  -->
  mass_noun([arg:A, drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:MN]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) }.


% -----

% decl: X1 that ...
%
noun_phrase([arg:A, loc:decl, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N4, para:P1-P4, tree:[np_82, Var, RC0]])
  -->
  string_variable([arg:A, app:'-', drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Var]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  relative_clause_0([crd:'+', arg:A, loc:decl, drs:D3-D4, ana:N3-N4, para:P3-P4, tree:RC0]).


% ante: ... X1 that ...
%
noun_phrase([arg:A, loc:ante, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N4, para:P1-P4, tree:[np_83, Var, RC0]])
  -->
  string_variable([arg:A, app:'-', drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Var]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  relative_clause_0([crd:'+', arg:A, loc:ante, drs:D3-D4, ana:N3-N4, para:P3-P4, tree:RC0]).


% -----

% L: X1 ...
%
noun_phrase([arg:A, loc:L, fcn:subj, qnt:def, drs:D1-D4, sco:D3-D4, ana:N1-N3, para:P1-P3, tree:[np_84, Var]])
  -->
  string_variable([arg:A, app:'-', drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) }.


% ------------------------------------------------------------------------
% noun_phrase/1 -- enumeration
%
%   For example:
%   Roberta, Thelma, Steve, and Pete are persons.
%   Roberta and Thelma are female.
%   
% ------------------------------------------------------------------------

% L: Robert and Thelma [are absent].
%
noun_phrase([crd:'+', arg:[num:pl, ind:[I1, I2]], loc:L, fcn:subj, qnt:def,  drs:D1-D6, sco:D5-D6, ana:N1-N6, para:P1-P6, tree:[np_89, Name1, Crd, Name2]])
  -->
  name([arg:[num:sg, ind:I1], drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name1]),
  { anaphora_resolution([arg:[num:sg, ind:I1], ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  coordination([wfm:[and], ana:N3-N4, para:P3-P4, tree:Crd]),
  name([arg:[num:sg, ind:I2], drs:[drs([], [])]-D4, ana:[]-N5, para:P4-P5, tree:Name2]),
  { anaphora_resolution([arg:[num:sg, ind:I2], ref:'?', drs:D3-[], ant:D4, sco:D5-[], ana:N4-N5-N6, para:P4-P5-P6]) }.


% L: ... Thelma, and Sue [are absent].
noun_phrase([crd:'land', arg:[num:pl, ind:[I1, I2]], loc:L, fcn:subj, qnt:def, drs:D1-D6, sco:D5-D6, ana:N1-N7, para:P1-P7, tree:[np_88, Name1, Comma, Crd, Name2]])
  -->
  name([arg:[num:sg, ind:I1], drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name1]),
  { anaphora_resolution([arg:[num:sg, ind:I1], ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  comma([wfm:[','], ana:N3-N4, para:P3-P4, tree:Comma]),
  coordination([wfm:[and], ana:N4-N5, para:P4-P5, tree:Crd]),
  name([arg:[num:sg, ind:I2], drs:[drs([], [])]-D4, ana:[]-N6, para:P5-P6, tree:Name2]),
  { anaphora_resolution([arg:[num:sg, ind:I2], ref:'?', drs:D3-[], ant:D4, sco:D5-[], ana:N5-N6-N7, para:P5-P6-P7]) }.


% L: ... Thelma and Sue [are absent].
noun_phrase([crd:'land', arg:[num:pl, ind:[I1, I2]], loc:L, fcn:subj, qnt:def,  drs:D1-D6, sco:D5-D6, ana:N1-N6, para:P1-P6, tree:[np_89, Name1, Crd, Name2]])
  -->
  name([arg:[num:sg, ind:I1], drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name1]),
  { anaphora_resolution([arg:[num:sg, ind:I1], ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  coordination([wfm:[and], ana:N3-N4, para:P3-P4, tree:Crd]),
  name([arg:[num:sg, ind:I2], drs:[drs([], [])]-D4, ana:[]-N5, para:P4-P5, tree:Name2]),
  { anaphora_resolution([arg:[num:sg, ind:I2], ref:'?', drs:D3-[], ant:D4, sco:D5-[], ana:N4-N5-N6, para:P4-P5-P6]) }.


% -----

% L: Robert and <NP> ...
%
noun_phrase([crd:'+', arg:[num:pl, ind:[I1|I2]], loc:L, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_90a, Name, Crd, NP]])
  -->
  name([arg:[num:sg, ind:I1], drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:[num:sg, ind:I1], ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  coordination([wfm:[and], ana:N3-N4, para:P3-P4, tree:Crd]),
  noun_phrase([crd:'and', arg:[num:pl, ind:I2], loc:L, fcn:subj, qnt:def, drs:D3-D5, sco:D4-D5, ana:N4-N5, para:P4-P5, tree:NP]).


% L: Robert and [Thelma and Sue are absent].
%
noun_phrase([crd:'+', arg:[num:pl, ind:[I1|I2]], loc:L, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_90b, Name, Crd, NP]])
  --> 
  name([arg:[num:sg, ind:I1], drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:[num:sg, ind:I1], ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  coordination([wfm:[and], ana:N3-N4, para:P3-P4, tree:Crd]),
  noun_phrase([crd:'land', arg:[num:pl, ind:I2], loc:L, fcn:subj, qnt:def, drs:D3-D5, sco:D4-D5, ana:N4-N5, para:P4-P5, tree:NP]).


% L: ... Thelma and [Sue and Mary are absent].
%
noun_phrase([crd:'and', arg:[num:pl, ind:[I1|I2]], loc:L, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_90d, Name, Crd, NP]])
  -->
  name([arg:[num:sg, ind:I1], drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:[num:sg, ind:I1], ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  coordination([wfm:[and], ana:N3-N4, para:P3-P4, tree:Crd]),
  noun_phrase([crd:'land', arg:[num:pl, ind:I2], loc:L, fcn:subj, qnt:def, drs:D3-D5, sco:D4-D5, ana:N4-N5, para:P4-P5, tree:NP]).



% L: ... Thelma and [Sue and Mary] ...
%
noun_phrase([crd:'and', arg:[num:pl, ind:[I1|I2]], loc:L, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_90c, Name, Crd, NP]])
  -->
  name([arg:[num:sg, ind:I1], drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:[num:sg, ind:I1], ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  coordination([wfm:[and], ana:N3-N4, para:P3-P4, tree:Crd]),
  noun_phrase([crd:'and', arg:[num:pl, ind:I2], loc:L, fcn:subj, qnt:def, drs:D3-D5, sco:D4-D5, ana:N4-N5, para:P4-P5, tree:NP]).



% -----

% L: Robert, <NP>
%
noun_phrase([crd:'+', arg:[num:pl, ind:[I1|I2]], loc:L, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_91a, Name, Comma, NP]])
  -->
  name([arg:[num:sg, ind:I1], drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:[num:sg, ind:I1], ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  comma([wfm:[','], ana:N3-N4, para:P3-P4, tree:Comma]),
  noun_phrase([crd:'cand', arg:[num:pl, ind:I2], loc:L, fcn:subj, qnt:def, drs:D3-D5, sco:D4-D5, ana:N4-N5, para:P4-P5, tree:NP]).


% L: Robert, [Thelma and Sue are absent].
%
noun_phrase([crd:'+', arg:[num:pl, ind:[I1|I2]], loc:L, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_91b, Name, Comma, NP]])
  -->
  name([arg:[num:sg, ind:I1], drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:[num:sg, ind:I1], ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  comma([wfm:[','], ana:N3-N4, para:P3-P4, tree:Comma]),
  noun_phrase([crd:'land', arg:[num:pl, ind:I2], loc:L, fcn:subj, qnt:def, drs:D3-D5, sco:D4-D5, ana:N4-N5, para:P4-P5, tree:NP]).


% L: Robert, [Telema, Sue, Mary ...]
%
noun_phrase([crd:'cand', arg:[num:pl, ind:[I1|I2]], loc:L, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_91c, Name, Comma, NP]])
  -->
  name([arg:[num:sg, ind:I1], drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:[num:sg, ind:I1], ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  comma([wfm:[','], ana:N3-N4, para:P3-P4, tree:Comma]),
  noun_phrase([crd:'cand', arg:[num:pl, ind:I2], loc:L, fcn:subj, qnt:def, drs:D3-D5, sco:D4-D5, ana:N4-N5, para:P4-P5, tree:NP]).


% L: Robert, [Thelma and Sue are absent].
%
noun_phrase([crd:'cand', arg:[num:pl, ind:[I1|I2]], loc:L, fcn:subj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_91d, Name, Comma, NP]])
  -->
  name([arg:[num:sg, ind:I1], drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:[num:sg, ind:I1], ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  comma([wfm:[','], ana:N3-N4, para:P3-P4, tree:Comma]),
  noun_phrase([crd:'land', arg:[num:pl, ind:I2], loc:L, fcn:subj, qnt:def, drs:D3-D5, sco:D4-D5, ana:N4-N5, para:P4-P5, tree:NP]).


% ------------------------------------------------------------------------
% noun_phrase/1 -- enumeration
%
%   For example:
%   Coffee, milk and tea are drinks.
%   
% ------------------------------------------------------------------------

noun_phrase([crd:'+', arg:[num:pl, ind:[I1, I2]], loc:L, fcn:subj, qnt:mass,  drs:D1-D6, sco:D5-D6, ana:N1-N6, para:P1-P6, tree:[np_96a, Name1, Crd, Name2]])
  -->
  mass_noun([arg:[num:sg, ind:I1], drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name1]),
  { anaphora_resolution([arg:[num:sg, ind:I1], ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  coordination([wfm:[and], ana:N3-N4, para:P3-P4, tree:Crd]),
  mass_noun([arg:[num:sg, ind:I2], drs:[drs([], [])]-D4, ana:[]-N5, para:P4-P5, tree:Name2]),
  { anaphora_resolution([arg:[num:sg, ind:I2], ref:'?', drs:D3-[], ant:D4, sco:D5-[], ana:N4-N5-N6, para:P4-P5-P6]) }.


noun_phrase([crd:'land', arg:[num:pl, ind:[I1, I2]], loc:L, fcn:subj, qnt:mass, drs:D1-D6, sco:D5-D6, ana:N1-N7, para:P1-P7, tree:[np_96b, Name1, Comma, Crd, Name2]])
  -->
  mass_noun([arg:[num:sg, ind:I1], drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name1]),
  { anaphora_resolution([arg:[num:sg, ind:I1], ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  comma([wfm:[','], ana:N3-N4, para:P3-P4, tree:Comma]),
  coordination([wfm:[and], ana:N4-N5, para:P4-P5, tree:Crd]),
  mass_noun([arg:[num:sg, ind:I2], drs:[drs([], [])]-D4, ana:[]-N6, para:P5-P6, tree:Name2]),
  { anaphora_resolution([arg:[num:sg, ind:I2], ref:'?', drs:D3-[], ant:D4, sco:D5-[], ana:N5-N6-N7, para:P5-P6-P7]) }.


noun_phrase([crd:'land', arg:[num:pl, ind:[I1, I2]], loc:L, fcn:subj, qnt:mass,  drs:D1-D6, sco:D5-D6, ana:N1-N6, para:P1-P6, tree:[np_96c, Name1, Crd, Name2]])
  -->
  mass_noun([arg:[num:sg, ind:I1], drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name1]),
  { anaphora_resolution([arg:[num:sg, ind:I1], ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  coordination([wfm:[and], ana:N3-N4, para:P3-P4, tree:Crd]),
  mass_noun([arg:[num:sg, ind:I2], drs:[drs([], [])]-D4, ana:[]-N5, para:P4-P5, tree:Name2]),
  { anaphora_resolution([arg:[num:sg, ind:I2], ref:'?', drs:D3-[], ant:D4, sco:D5-[], ana:N4-N5-N6, para:P4-P5-P6]) }.


% ---

noun_phrase([crd:'+', arg:[num:pl, ind:[I1|I2]], loc:L, fcn:subj, qnt:mass, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_97a, Name, Crd, NP]])
  -->
  mass_noun([arg:[num:sg, ind:I1], drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:[num:sg, ind:I1], ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  coordination([wfm:[and], ana:N3-N4, para:P3-P4, tree:Crd]),
  noun_phrase([crd:'land', arg:[num:pl, ind:I2], loc:L, fcn:subj, qnt:mass, drs:D3-D5, sco:D4-D5, ana:N4-N5, para:P4-P5, tree:NP]).


noun_phrase([crd:'+', arg:[num:pl, ind:[I1|I2]], loc:L, fcn:subj, qnt:mass, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_97b, Name, Crd, NP]])
  -->
  mass_noun([arg:[num:sg, ind:I1], drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:[num:sg, ind:I1], ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  coordination([wfm:[and], ana:N3-N4, para:P3-P4, tree:Crd]),
  noun_phrase([crd:'cand', arg:[num:pl, ind:I2], loc:L, fcn:subj, qnt:mass, drs:D3-D5, sco:D4-D5, ana:N4-N5, para:P4-P5, tree:NP]).


noun_phrase([crd:'and', arg:[num:pl, ind:[I1|I2]], loc:L, fcn:subj, qnt:mass, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_97c, Name, Crd, NP]])
  -->
  mass_noun([arg:[num:sg, ind:I1], drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:[num:sg, ind:I1], ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  coordination([wfm:[and], ana:N3-N4, para:P3-P4, tree:Crd]),
  noun_phrase([crd:'and', arg:[num:pl, ind:I2], loc:L, fcn:subj, qnt:mass, drs:D3-D5, sco:D4-D5, ana:N4-N5, para:P4-P5, tree:NP]).


noun_phrase([crd:'and', arg:[num:pl, ind:[I1|I2]], loc:L, fcn:subj, qnt:mass, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_97d, Name, Crd, NP]])
  -->
  mass_noun([arg:[num:sg, ind:I1], drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:[num:sg, ind:I1], ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  coordination([wfm:[and], ana:N3-N4, para:P3-P4, tree:Crd]),
  noun_phrase([crd:'land', arg:[num:pl, ind:I2], loc:L, fcn:subj, qnt:mass, drs:D3-D5, sco:D4-D5, ana:N4-N5, para:P4-P5, tree:NP]).


% -----

noun_phrase([crd:'+', arg:[num:pl, ind:[I1|I2]], loc:L, fcn:subj, qnt:mass, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_98a, Name, Comma, NP]])
  -->
  mass_noun([arg:[num:sg, ind:I1], drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:[num:sg, ind:I1], ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  comma([wfm:[','], ana:N3-N4, para:P3-P4, tree:Comma]),
  noun_phrase([crd:'land', arg:[num:pl, ind:I2], loc:L, fcn:subj, qnt:mass, drs:D3-D5, sco:D4-D5, ana:N4-N5, para:P4-P5, tree:NP]).


noun_phrase([crd:'+', arg:[num:pl, ind:[I1|I2]], loc:L, fcn:subj, qnt:mass, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_98b, Name, Comma, NP]])
  -->
  mass_noun([arg:[num:sg, ind:I1], drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:[num:sg, ind:I1], ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  comma([wfm:[','], ana:N3-N4, para:P3-P4, tree:Comma]),
  noun_phrase([crd:'cand', arg:[num:pl, ind:I2], loc:L, fcn:subj, qnt:mass, drs:D3-D5, sco:D4-D5, ana:N4-N5, para:P4-P5, tree:NP]).


noun_phrase([crd:'cand', arg:[num:pl, ind:[I1|I2]], loc:L, fcn:subj, qnt:mass, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_98c, Name, Comma, NP]])
  -->
  mass_noun([arg:[num:sg, ind:I1], drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:[num:sg, ind:I1], ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  comma([wfm:[','], ana:N3-N4, para:P3-P4, tree:Comma]),
  noun_phrase([crd:'cand', arg:[num:pl, ind:I2], loc:L, fcn:subj, qnt:mass, drs:D3-D5, sco:D4-D5, ana:N4-N5, para:P4-P5, tree:NP]).


noun_phrase([crd:'cand', arg:[num:pl, ind:[I1|I2]], loc:L, fcn:subj, qnt:mass, drs:D1-D5, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_98d, Name, Comma, NP]])
  -->
  mass_noun([arg:[num:sg, ind:I1], drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:[num:sg, ind:I1], ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  comma([wfm:[','], ana:N3-N4, para:P3-P4, tree:Comma]),
  noun_phrase([crd:'land', arg:[num:pl, ind:I2], loc:L, fcn:subj, qnt:mass, drs:D3-D5, sco:D4-D5, ana:N4-N5, para:P4-P5, tree:NP]).


% ------------------------------------------------------------------------
% Prepositional object (pobj)       
%
% ------------------------------------------------------------------------

% decl: [... of] the female child X1
noun_phrase([arg:A, loc:decl, fcn:pobj, qnt:def, drs:D1-D6, sco:D5-D6, ana:N0-N1-N6, para:P1-P6, tree:[np_99, Det, Adj, Noun, Var]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),                                      
  count_noun([wfm:WF, arg:A, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D3-D4, ana:N4-N5, para:P4-P5, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P5-P6]) }.


% ante: [... of] the female child X1
noun_phrase([arg:A, loc:ante, fcn:pobj, qnt:def, drs:D1-D6, sco:D5-D6, ana:N0-N1-N6, para:P1-P6, tree:[np_100, Det, Adj, Noun, Var]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),                                      
  count_noun([wfm:WF, arg:A, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D3-D4, ana:N4-N5, para:P4-P5, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P5-P6]) }.


% cons: [... of] the female child X1
noun_phrase([arg:A, loc:cons, fcn:pobj, qnt:def, drs:D1-D6, sco:D5-D6, ana:N0-N1-N6, para:P1-P6, tree:[np_101, Det, Adj, Noun, Var]])
  -->
  determiner([arg:A, fcn:_, qnt:def, ref:'+', drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, ref:'+', drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),                                      
  count_noun([wfm:WF, arg:A, ref:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', ref:'+', drs:D3-D4, ana:N4-N5, para:P4-P5, tree:Var]),
  { anaphora_resolution([arg:A, ref:'+', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P5-P6]) }.


% L: [... of] a female child X1
noun_phrase([arg:A, loc:L, fcn:pobj, qnt:exist, drs:D, sco:S, ana:N0-N1-N5, para:P1-P5, tree:[np_102, Det, Adj, Noun, Var]])
  -->
  determiner([arg:A, fcn:_, qnt:exist, drs:D, res:R1-R4, sco:S, ana:N1-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', drs:R3-R4, ana:N4-N5, para:P4-P5, tree:Var]).


% decl: [... of] the child X1
noun_phrase([arg:A, loc:decl, fcn:pobj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N0-N1-N5, para:P1-P5, tree:[np_103, Det, Noun, Var]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% ante: [... of] the child X1
noun_phrase([arg:A, loc:ante, fcn:pobj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N0-N1-N5, para:P1-P5, tree:[np_104, Det, Noun, Var]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% cons: [... of] the child X1
noun_phrase([arg:A, loc:cons, fcn:pobj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N0-N1-N5, para:P1-P5, tree:[np_105, Det, Noun, Var]])
  -->
  determiner([arg:A, fcn:_, qnt:def, ref:'+', drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, ref:'+', drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', ref:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A, ref:'+', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% L: [... of] a child X1
noun_phrase([arg:A, loc:L, fcn:pobj, qnt:exist, drs:D, sco:S, ana:N0-N1-N4, para:P1-P4, tree:[np_106, Det, Noun, Var]])
  -->
  determiner([arg:A, fcn:_, qnt:exist, drs:D, res:R1-R3, sco:S, ana:N1-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Var]).


% decl: [... of] the female child
noun_phrase([arg:A, loc:decl, fcn:pobj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N0-N1-N5, para:P1-P5, tree:[np_107, Det, Adj, Noun]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),                                      
  count_noun([wfm:WF, arg:A, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% ante: [... of] the female child
noun_phrase([arg:A, loc:ante, fcn:pobj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N0-N1-N5, para:P1-P5, tree:[np_108, Det, Adj, Noun]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),                                      
  count_noun([wfm:WF, arg:A, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'+', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% cons: [... of] the female child
noun_phrase([arg:A, loc:cons, fcn:pobj, qnt:def, drs:D1-D5, sco:D4-D5, ana:N0-N1-N5, para:P1-P5, tree:[np_109, Det, Adj, Noun]])
  -->
  determiner([arg:A, fcn:O, qnt:def, ref:'+', drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, ref:'+', drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),                                      
  count_noun([wfm:WF, arg:A, ref:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'+', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% L: [... of] a female child
noun_phrase([arg:A, loc:L, fcn:pobj, qnt:exist, drs:D, sco:S, ana:N0-N1-N4, para:P1-P4, tree:[np_110, Det, Adj, Noun]])
  -->
  determiner([arg:A, fcn:_, qnt:exist, drs:D, res:R1-R3, sco:S, ana:N1-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]).


% decl: [... of] the child
noun_phrase([arg:A, loc:decl, fcn:pobj, qnt:def, drs:D1-D4, sco:D3-D4, ana:N0-N1-N4, para:P1-P4, tree:[np_111, Det, Noun]])
  -->
  determiner([arg:A, fcn:O, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N3-N4, para:P1-P3-P4]) }.


% ante: [... of] the child
noun_phrase([arg:A, loc:ante, fcn:pobj, qnt:def, drs:D1-D4, sco:D3-D4, ana:N0-N1-N4, para:P1-P4, tree:[np_112, Det, Noun]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N3-N4, para:P1-P3-P4]) }.


% cons: [... of] the child
noun_phrase([arg:A, loc:cons, fcn:pobj, qnt:def, drs:D1-D4, sco:D3-D4, ana:N0-N1-N4, para:P1-P4, tree:[np_113, Det, Noun]])
  -->
  determiner([arg:A, fcn:_, qnt:def, ref:'+', drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, ref:'+', drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'+', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N3-N4, para:P1-P3-P4]) }.


% L: [... of] a child
noun_phrase([arg:A, loc:L, fcn:pobj, qnt:exist, drs:D, sco:S, ana:N0-N1-N3, para:P1-P3, tree:[np_114, Det, Noun]])
  -->
  determiner([arg:A, fcn:_, qnt:exist, drs:D, res:R, sco:S, ana:N1-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R, ana:N2-N3, para:P2-P3, tree:Noun]).


% L: [... of] of John
noun_phrase([arg:A, loc:L, fcn:pobj, qnt:def, drs:D1-D4, sco:D3-D4, ana:N0-N1-N3, para:P1-P3, tree:[np_115, Name]])
  -->
  name([arg:A, drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) }.


% L: [... of] of X1
noun_phrase([arg:A, loc:L, fcn:pobj, qnt:def, drs:D1-D4, sco:D3-D4, ana:N0-N1-N3, para:P1-P3, tree:[np_116, Var]])
  -->
  string_variable([arg:A, app:'-', drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Var]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) }.


% ------------------------------------------------------------------------
% relative_clause_0/1
% ------------------------------------------------------------------------

relative_clause_0([crd:'+', arg:A, loc:L, drs:R, ana:N1-N3, para:P1-P3, tree:[rc0_1, RP, VP]])
  -->
  relative_pronoun([wfm:WF, ana:N1-N2, para:P1-P2, tree:RP]),
  verb_phrase([crd:'-', arg:A, loc:L, drs:R, ana:N2-N3, para:P2-P3, tree:VP]).


relative_clause_0([crd:'-', arg:A, loc:L, drs:R, ana:N1-N3, para:P1-P3, tree:[rc0_2, RP, VP]])
  -->
  relative_pronoun([wfm:WF, ana:N1-N2, para:P1-P2, tree:RP]),
  verb_phrase([crd:'-', arg:A, loc:L, drs:R, ana:N2-N3, para:P2-P3, tree:VP]).


relative_clause_0([crd:'and', arg:A, loc:L, drs:R, ana:N1-N3, para:P1-P3, tree:[rc0_3, RP, VP]])
  -->
  relative_pronoun([wfm:WF, ana:N1-N2, para:P1-P2, tree:RP]),
  verb_phrase([crd:'-', arg:A, loc:L, drs:R, ana:N2-N3, para:P2-P3, tree:VP]).


relative_clause_0([crd:'or', arg:A, loc:L, drs:R, ana:N1-N3, para:P1-P3, tree:[rc0_4, RP, VP]])
  -->
  relative_pronoun([wfm:WF, ana:N1-N2, para:P1-P2, tree:RP]),
  verb_phrase([crd:'-', arg:A, loc:L, drs:R, ana:N2-N3, para:P2-P3, tree:VP]).


relative_clause_0([crd:'+', arg:A, loc:L, drs:D1-D3, ana:N1-N4, para:P1-P4, tree:[rc0_5, RC01, Crd, RC02]])
  -->
  relative_clause_0([crd:'-', arg:A, loc:L, drs:D1-D2, ana:N1-N2, para:P1-P2, tree:RC01]),
  coordination([wfm:[and], ana:N2-N3, para:P2-P3, tree:Crd]),
  relative_clause_0([crd:'and', arg:A, loc:L, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:RC02]).


relative_clause_0([crd:'and', arg:A, loc:L, drs:D1-D3, ana:N1-N4, para:P1-P4, tree:[rc0_6, RC01, Crd, RC02]])
  -->
  relative_clause_0([crd:'-', arg:A, loc:L, drs:D1-D2, ana:N1-N2, para:P1-P2, tree:RC01]),
  coordination([wfm:[and], ana:N2-N3, para:P2-P3, tree:Crd]),
  relative_clause_0([crd:'and', arg:A, loc:L, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:RC02]).


relative_clause_0([crd:'+', arg:A, loc:L, drs:D1-[drs(U1, [D3 or D4|C1])|D5], ana:N1-N4, para:P1-P4, tree:[rc0_7, RC01, Crd, RC02]])
  -->
  relative_clause_0([crd:'-', arg:A, loc:L, drs:[drs([], [])|D1]-[D3|D2], ana:N1-N2, para:P1-P2, tree:RC01]),
  coordination([wfm:[or], ana:N2-N3, para:P2-P3, tree:Crd]),
  relative_clause_0([crd:'or', arg:A, loc:L, drs:[drs([], [])|D2]-[D4, drs(U1, C1)|D5], ana:N3-N4, para:P3-P4, tree:RC02]).


relative_clause_0([crd:'or', arg:A, loc:L, drs:D1-[drs(U1, [D3 or D4|C1])|D5], ana:N1-N4, para:P1-P4, tree:[rc0_8, RC01, Crd, RC02]])
  -->
  relative_clause_0([crd:'-', arg:A, loc:L, drs:[drs([], [])|D1]-[D3|D2], ana:N1-N2, para:P1-P2, tree:RC01]),
  coordination([wfm:[or], ana:N2-N3, para:P2-P3, tree:Crd]),
  relative_clause_0([crd:'or', arg:A, loc:L, drs:[drs([], [])|D2]-[D4, drs(U1, C1)|D5], ana:N3-N4, para:P3-P4, tree:RC02]).


% ========================================================================
% Verb phrase coordination
%
% ========================================================================

verb_phrase([crd:'+', arg:A, loc:L, drs:D, ana:N, para:P, tree:[vp_42, VP]])
  -->
  verb_phrase([crd:'-', arg:A, loc:L, drs:D, ana:N, para:P, tree:VP]).


% -----

verb_phrase([crd:'and', arg:A, loc:L, drs:D, ana:N, para:P, tree:[vp_36, VP]])
  -->
  verb_phrase([crd:'-', arg:A, loc:L, drs:D, ana:N, para:P, tree:VP]).


verb_phrase([crd:'+', arg:A, loc:L, drs:D1-D3, ana:N1-N4, para:P1-P4, tree:[vp_37, VP1, CRD, VP2]])
  -->
  verb_phrase([crd:'-', arg:A, loc:L, drs:D1-D2, ana:N1-N2, para:P1-P2, tree:VP1]),
  coordination([wfm:[and], ana:N2-N3, para:P2-P3, tree:CRD]),
  verb_phrase([crd:'and', arg:A, loc:L, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:VP2]).


verb_phrase([crd:'and', arg:A, loc:L, drs:D1-D3, ana:N1-N4, para:P1-P4, tree:[vp_38, VP1, CRD, VP2]])
  -->
  verb_phrase([crd:'-', arg:A, loc:L, drs:D1-D2, ana:N1-N2, para:P1-P2, tree:VP1]),
  coordination([wfm:[and], ana:N2-N3, para:P2-P3, tree:CRD]),
  verb_phrase([crd:'and', arg:A, loc:L, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:VP2]).


% -----

verb_phrase([crd:'or', arg:A, loc:L, drs:D, ana:N, para:P, tree:[vp_39, VP]])
  -->
  verb_phrase([crd:'-', arg:A, loc:L, drs:D, ana:N, para:P, tree:VP]).


verb_phrase([crd:'+', arg:A, loc:L, drs:D1-[drs(U1, [D3 or D4|C1])|D5], ana:N1-N4, para:P1-P4, tree:[vp_40, VP1, CRD, VP2]])
  -->
  verb_phrase([crd:'-', arg:A, loc:L, drs:[drs([], [])|D1]-[D3|D2], ana:N1-N2, para:P1-P2, tree:VP1]),
  coordination([wfm:[or], ana:N2-N3, para:P2-P3, tree:CRD]),
  verb_phrase([crd:'or', arg:A, loc:L, drs:[drs([], [])|D2]-[D4, drs(U1, C1)|D5], ana:N3-N4, para:P3-P4, tree:VP2]).


verb_phrase([crd:'or', arg:A, loc:L, drs:D1-[drs(U1, [D3 or D4|C1])|D5], ana:N1-N4, para:P1-P4, tree:[vp_41, VP1, CRD, VP2]])
  -->
  verb_phrase([crd:'-', arg:A, loc:L, drs:[drs([], [])|D1]-[D3|D2], ana:N1-N2, para:P1-P2, tree:VP1]),
  coordination([wfm:[or], ana:N2-N3, para:P2-P3, tree:CRD]),
  verb_phrase([crd:'or', arg:A, loc:L, drs:[drs([], [])|D2]-[D4, drs(U1, C1)|D5], ana:N3-N4, para:P3-P4, tree:VP2]).


% ========================================================================
% Verb phrase plus prepositional phrase (modifier)
%
% ========================================================================

% ... teaches a student in a garden
%
verb_phrase([crd:'-', arg:A, loc:decl, drs:D1-D4, ana:N1-N3, para:P1-P3, tree:[vp_43, VP, PP]])
  -->
  verb_phrase([arg:A, vform:fin, evtl:E, loc:decl, drs:D1-D4, res:D1-D2, sco:D3-D4, ana:N1-N2, para:P1-P2, tree:VP]),
  prepositional_phrase_([wfm:WF, loc:decl, fcn:pmod, evtl:E, drs:D2-D3, ana:N2-N3, para:P2-P3, tree:PP]).


% [If] ... teaches a student in a garden
%
verb_phrase([crd:'-', arg:A, loc:ante, drs:D1-D4, ana:N1-N3, para:P1-P3, tree:[vp_44, VP, PP]])
  -->
  verb_phrase([arg:A, vform:fin, evtl:E, loc:ante, drs:D1-D4, res:D1-D2, sco:D3-D4, ana:N1-N2, para:P1-P2, tree:VP]),
  prepositional_phrase_([wfm:WF, loc:ante, fcn:pmod, evtl:E, drs:D2-D3, ana:N2-N3, para:P2-P3, tree:PP]).


% [then] ... teaches the student in the garden
%
verb_phrase([crd:'-', arg:A, loc:cons, drs:D1-D4, ana:N1-N3, para:P1-P3, tree:[vp_45, VP, PP]])
  -->
  verb_phrase([arg:A, vform:fin, evtl:E, loc:cons, drs:D1-D4, res:D1-D2, sco:D3-D4, ana:N1-N2, para:P1-P2, tree:VP]),
  prepositional_phrase_([wfm:WF, loc:cons, fcn:pmod, evtl:E, drs:D2-D3, ana:N2-N3, para:P2-P3, tree:PP]).


% --------------------------

% [If] ... does not provably not teach a student in the garden
%
verb_phrase([crd:'-', arg:A1, loc:ante, drs:D1-[drs(U1, [naf drs([], [neg D4])|C1])|D5], ana:N1-N7, para:P1-P7, tree:[vp_46, Aux, Neg1, Adv, Neg2, VP, PP]])
  -->
  auxiliary([wfm:[does], arg:[num:sg|_], ana:N1-N2, para:P1-P2, tree:Aux]),    
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg1]),
  adverb([wfm:[provably], evtl:E, drs:S, ana:N3-N4, para:P3-P4, tree:Adv]),
  negation([wfm:[not], ana:N4-N5, para:P4-P5, tree:Neg2]),
  verb_phrase([arg:A1, vform:inf, evtl:E, loc:ante, drs:[drs([], [])|D1]-[D4, drs(U1, C1)|D5], res:[drs([], [])|D1]-D2, sco:D3-[D4, drs(U1, C1)|D5], ana:N5-N6, para:P5-P6, tree:VP]),
  prepositional_phrase_([wfm:WF, loc:ante, fcn:pmod, evtl:E, drs:D2-D3, ana:N6-N7, para:P6-P7, tree:PP]).


% [IF] ... does not provably teach a student
%
verb_phrase([crd:'-', arg:A, loc:ante, drs:D1-[drs(U1, [naf drs([], [neg D2])|C1])|D3], ana:N1-N6, para:P1-P6, tree:[vp_47, Aux, Neg1, Adv, Neg2, VP]])
  -->
  auxiliary([wfm:[does], arg:[num:sg|_], ana:N1-N2, para:P1-P2, tree:Aux]),    
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg1]),
  adverb([wfm:[provably], evtl:E, drs:S, ana:N3-N4, para:P3-P4, tree:Adv]),
  negation([wfm:[not], ana:N4-N5, para:P4-P5, tree:Neg2]),
  verb_phrase([arg:A, vform:inf, evtl:E, loc:ante,
	       drs:[drs([], [])|D1]-[D2, drs(U1, C1)|D3], res:[drs([], [])|D1]-S1, sco:S1-[D2, drs(U1, C1)|D3], ana:N5-N6, para:P5-P6, tree:VP]).


% --------------------------


% [If] ... does not provably teach a student in the garden
%
verb_phrase([crd:'-', arg:A1, loc:ante, drs:D1-[drs(U1, [naf D4|C1])|D5], ana:N1-N6, para:P1-P6, tree:[vp_48, Aux, Neg, Adv, VP, PP]])
  -->
  auxiliary([wfm:[does], arg:[num:sg|_], ana:N1-N2, para:P1-P2, tree:Aux]),    
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  adverb([wfm:[provably], evtl:E, drs:S, ana:N3-N4, para:P3-P4, tree:Adv]),
  verb_phrase([arg:A1, vform:inf, evtl:E, loc:ante, drs:[drs([], [])|D1]-[D4, drs(U1, C1)|D5], res:[drs([], [])|D1]-D2, sco:D3-[D4, drs(U1, C1)|D5], ana:N4-N5, para:P4-P5, tree:VP]),
  prepositional_phrase_([wfm:WF, loc:ante, fcn:pmod, evtl:E, drs:D2-D3, ana:N5-N6, para:P5-P6, tree:PP]).


% [IF] ... does not provably teach a student
%
verb_phrase([crd:'-', arg:A, loc:ante, drs:D1-[drs(U1, [naf D2|C1])|D3], ana:N1-N5, para:P1-P5, tree:[vp_49, Aux, Neg, Adv, VP]])
  -->
  auxiliary([wfm:[does], arg:[num:sg|_], ana:N1-N2, para:P1-P2, tree:Aux]),    
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  adverb([wfm:[provably], evtl:E, drs:S, ana:N3-N4, para:P3-P4, tree:Adv]),
  verb_phrase([arg:A, vform:inf, evtl:E, loc:ante,
	       drs:[drs([], [])|D1]-[D2, drs(U1, C1)|D3], res:[drs([], [])|D1]-S1, sco:S1-[D2, drs(U1, C1)|D3], ana:N4-N5, para:P4-P5, tree:VP]).


% --------------------------

% ... does not teach a student in a garden
%
verb_phrase([crd:'-', arg:A1, loc:decl, drs:D1-[drs(U1, [neg D4|C1])|D5], ana:N1-N5, para:P1-P5, tree:[vp_50, Aux, Neg, VP, PP]])
  -->
  auxiliary([wfm:[does], arg:[num:sg|_], ana:N1-N2, para:P1-P2, tree:Aux]),    
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  verb_phrase([arg:A1, vform:inf, evtl:E, loc:decl, drs:[drs([], [])|D1]-[D4, drs(U1, C1)|D5], res:[drs([], [])|D1]-D2, sco:D3-[D4, drs(U1, C1)|D5], ana:N3-N4, para:P3-P4, tree:VP]),
  prepositional_phrase_([wfm:WF, loc:decl, fcn:pmod, evtl:E, drs:D2-D3, ana:N4-N5, para:P4-P5, tree:PP]).


% [If] ... does not teach a student in a garden
%
verb_phrase([crd:'-', arg:A1, loc:ante, drs:D1-[drs(U1, [neg D4|C1])|D5], ana:N1-N5, para:P1-P5, tree:[vp_51, Aux, Neg, VP, PP]])
  -->
  auxiliary([wfm:[does], arg:[num:sg|_], ana:N1-N2, para:P1-P2, tree:Aux]),    
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  verb_phrase([arg:A1, vform:inf, evtl:E, loc:ante, drs:[drs([], [])|D1]-[D4, drs(U1, C1)|D5], res:[drs([], [])|D1]-D2, sco:D3-[D4, drs(U1, C1)|D5], ana:N3-N4, para:P3-P4, tree:VP]),
  prepositional_phrase_([wfm:WF, loc:ante, fcn:pmod, evtl:E, drs:D2-D3, ana:N4-N5, para:P4-P5, tree:PP]).


% [then] ... does not teach the student in the garden
%
verb_phrase([crd:'-', arg:A1, loc:cons, drs:D1-[drs(U1, [neg D4|C1])|D5], ana:N1-N5, para:P1-P5, tree:[vp_52, Aux, Neg, VP, PP]])
  -->
  auxiliary([wfm:[does], arg:[num:sg|_], ana:N1-N2, para:P1-P2, tree:Aux]),    
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  verb_phrase([arg:A1, vform:inf, evtl:E, loc:cons, drs:[drs([], [])|D1]-[D4, drs(U1, C1)|D5], res:[drs([], [])|D1]-D2, sco:D3-[D4, drs(U1, C1)|D5], ana:N3-N4, para:P3-P4, tree:VP]),
  prepositional_phrase_([wfm:WF, loc:cons, fcn:pmod, evtl:E, drs:D2-D3, ana:N4-N5, para:P4-P5, tree:PP]).


% --------------------------

% ... does not teach a student
%
verb_phrase([crd:'-', arg:A, loc:decl, drs:D1-[drs(U1, [neg D2|C1])|D3], ana:N1-N4, para:P1-P4, tree:[vp_53, Aux, Neg, VP]])
  -->
  auxiliary([wfm:[does], arg:[num:sg|_], ana:N1-N2, para:P1-P2, tree:Aux]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  verb_phrase([arg:A, vform:inf, evtl:E, loc:decl,
	       drs:[drs([], [])|D1]-[D2, drs(U1, C1)|D3], res:[drs([], [])|D1]-S, sco:S-[D2, drs(U1, C1)|D3], ana:N3-N4, para:P3-P4, tree:VP]).


% [IF] ... does not teach a student
%
verb_phrase([crd:'-', arg:A, loc:ante, drs:D1-[drs(U1, [neg D2|C1])|D3], ana:N1-N4, para:P1-P4, tree:[vp_54, Aux, Neg, VP]])
  -->
  auxiliary([wfm:[does], arg:[num:sg|_], ana:N1-N2, para:P1-P2, tree:Aux]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  verb_phrase([arg:A, vform:inf, evtl:E, loc:ante,
	       drs:[drs([], [])|D1]-[D2, drs(U1, C1)|D3], res:[drs([], [])|D1]-S, sco:S-[D2, drs(U1, C1)|D3], ana:N3-N4, para:P3-P4, tree:VP]).


% [then] ... does not teach the student
%
verb_phrase([crd:'-', arg:A, loc:cons, drs:D1-[drs(U1, [neg D2|C1])|D3], ana:N1-N4, para:P1-P4, tree:[vp_55, Aux, Neg, VP]])
  -->
  auxiliary([wfm:[does], arg:[num:sg|_], ana:N1-N2, para:P1-P2, tree:Aux]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  verb_phrase([arg:A, vform:inf, evtl:E, loc:cons,
	       drs:[drs([], [])|D1]-[D2, drs(U1, C1)|D3], res:[drs([], [])|D1]-S, sco:S-[D2, drs(U1, C1)|D3], ana:N3-N4, para:P3-P4, tree:VP]).


% --------------------------

% [then] ... abnormally cares about the child
%
verb_phrase([crd:'-', arg:A, loc:cons, drs:D1-D4, ana:N1-N3, para:P1-P3, tree:[vp_56, Adv, VP]])
  -->
  adverb([wfm:[abnormally], evtl:E, drs:D3-D4, ana:N1-N2, para:P1-P2, tree:Adv]),
  verb_phrase([arg:A, vform:fin, evtl:E, loc:cons, drs:D1-_, res:D1-D2, sco:D2-D3, ana:N2-N3, para:P2-P3, tree:VP]).


% [then] ... abnormally cares about the child in the garden
%
verb_phrase([crd:'-', arg:A, loc:cons, drs:D1-D5, ana:N1-N4, para:P1-P4, tree:[vp_57, Adv, VP, PP]])
  -->
  adverb([wfm:[abnormally], evtl:E, drs:D3-D4, ana:N1-N2, para:P1-P2, tree:Adv]),
  verb_phrase([arg:A, vform:fin, evtl:E, loc:cons, drs:D1-_, res:D1-D2, sco:D4-D5, ana:N2-N3, para:P2-P3, tree:VP]).
  prepositional_phrase_([wfm:WF, loc:cons, fcn:pmod, evtl:E, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:PP]).
 

% -------------------------     

% ... teaches a student
%
verb_phrase([crd:'-', arg:A, loc:decl, drs:D1-D3, ana:N, para:P, tree:[vp_58, VP]])
  -->
  verb_phrase([arg:A, vform:fin, evtl:E, loc:decl, drs:D1-D3, res:D1-D2, sco:D2-D3, ana:N, para:P, tree:VP]).


% [If] ... teaches a student
%
verb_phrase([crd:'-', arg:A, loc:ante, drs:D1-D3, ana:N, para:P, tree:[vp_59, VP]])
  -->
  verb_phrase([arg:A, vform:fin, evtl:E, loc:ante, drs:D1-D3, res:D1-D2, sco:D2-D3, ana:N, para:P, tree:VP]).


% [then] ... teaches a student
%
verb_phrase([crd:'-', arg:A, loc:cons, drs:D1-D3, ana:N, para:P, tree:[vp_60, VP]])
  -->
  verb_phrase([arg:A, vform:fin, evtl:E, loc:cons, drs:D1-D3, res:D1-D2, sco:D2-D3, ana:N, para:P, tree:VP]).


% --------------------------

% ... do not (to be tested and extended)
% verb_phrase([crd:'-', arg:[num:pl, ind:I], loc:L, drs:[drs(U1, C1)|D1]-[drs(U1, [neg D2|C1])|D1], ana:N1-N4, para:P1-P4, tree:[vp_61, Aux, Neg, IV]])
%  -->
%  auxiliary([wfm:[do], arg:A, ana:N1-N2, para:P1-P2, tree:Aux]),  
%  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
%  verb_phrase([arg:[num:pl, ind:I], vform:inf, evtl:E, loc:L,
%	       drs:[drs([], [])|D1]-[D2, drs(U1, C1)|D3], res:[drs([], [])|D1]-S, sco:S-[D2, drs(U1, C1)|D3], ana:N3-N4, para:P3-P4, tree:VP]).


% -------------------------
% intransitive verb


verb_phrase([arg:[num:sg, ind:I], vform:V, evtl:E, loc:decl, drs:D1-D3, res:D1-D1, sco:S, ana:N, para:P, tree:[vp_61, IV]])
  -->
  intransitive_verb([wfm:WF, arg:[num:sg, ind:I], vform:V, evtl:E, con:C, drs:S, ana:N, para:P, tree:IV]).


verb_phrase([arg:[num:sg, ind:I], vform:V, evtl:E, loc:ante, drs:D1-D3, res:D1-D1, sco:S, ana:N, para:P, tree:[vp_62, IV]])
  -->
  intransitive_verb([wfm:WF, arg:[num:sg, ind:I], vform:V, evtl:E, con:C, drs:S, ana:N, para:P, tree:IV]).


verb_phrase([arg:[num:sg, ind:I], vform:V, evtl:E, loc:cons, drs:D1-D3, res:D1-D1, sco:S, ana:N, para:P, tree:[vp_63, IV]])
  -->
  intransitive_verb([wfm:WF, arg:[num:sg, ind:I], vform:V, evtl:E, con:C, drs:S, ana:N, para:P, tree:IV]).


verb_phrase([arg:[num:pl, ind:I], vform:V, evtl:E, loc:decl, drs:D1-D3, res:D1-D1, sco:S, ana:N, para:P1-P2, tree:[vp_64, IV]])
  -->
  intransitive_verb([wfm:WF, arg:[num:pl, ind:I], vform:V, evtl:E, con:C, drs:S, ana:N, para:[['&lt;/ins&gt;'], [each], ['&lt;ins&gt;']|P1]-P2, tree:IV]).


verb_phrase([arg:[num:pl, ind:I], vform:V, evtl:E, loc:ante, drs:D1-D3, res:D1-D1, sco:S, ana:N, para:P1-P2, tree:[vp_65, IV]])
  -->
  intransitive_verb([wfm:WF, arg:[num:pl, ind:I], vform:V, evtl:E, con:C, drs:S, ana:N, para:[['&lt;/ins&gt;'], [each], ['&lt;ins&gt;']|P1]-P2, tree:IV]).


% -------------------------
% transitive verb


verb_phrase([arg:[num:sg, ind:I], vform:V, evtl:E, loc:decl, drs:D1-D3, res:D1-D2, sco:S, ana:N1-N3, para:P1-P3, tree:[vp_66, TV, NP]])
  -->
  transitive_verb([wfm:WF, arg:[num:sg, ind:I], arg:A2, vform:V, evtl:E, con:C, drs:S, ana:N1-N2, para:P1-P2, tree:TV]),
  noun_phrase([arg:A2, loc:decl, fcn:dobj, qnt:_, drs:D1-D3, res:D1-D2, sco:_-_, ana:N2-N3, para:P2-P3, tree:NP]).


verb_phrase([arg:[num:sg, ind:I], vform:V, evtl:E, loc:ante, drs:D1-D3, res:D1-D2, sco:S, ana:N1-N3, para:P1-P3, tree:[vp_67, TV, NP]])
  -->
  transitive_verb([wfm:WF, arg:[num:sg, ind:I], arg:A2, vform:V, evtl:E, con:C, drs:S, ana:N1-N2, para:P1-P2, tree:TV]),
  noun_phrase([arg:A2, loc:ante, fcn:dobj, qnt:_, drs:D1-D3, res:D1-D2, sco:_-_, ana:N2-N3, para:P2-P3, tree:NP]).


verb_phrase([arg:[num:sg, ind:I], vform:V, evtl:E, loc:cons, drs:D1-D3, res:D1-D2, sco:S, ana:N1-N3, para:P1-P3, tree:[vp_68, TV, NP]])
  -->
  transitive_verb([wfm:WF, arg:[num:sg, ind:I], arg:A2, vform:V, evtl:E, con:C, drs:S, ana:N1-N2, para:P1-P2, tree:TV]),
  noun_phrase([arg:A2, loc:cons, fcn:dobj, qnt:_, drs:D1-D3, res:D1-D2, sco:_-_, ana:N2-N3, para:P2-P3, tree:NP]).


verb_phrase([arg:[num:pl, ind:I], vform:V, evtl:E, loc:decl, drs:D1-D3, res:D1-D2, sco:S, ana:N1-N3, para:P1-P3, tree:[vp_69, TV, NP]])
  -->
  transitive_verb([wfm:WF, arg:[num:pl, ind:I], arg:A2, vform:V, evtl:E, con:C, drs:S, ana:N1-N2, para:[['&lt;/ins&gt;'], [each], ['&lt;ins&gt;']|P1]-P2, tree:TV]),
  noun_phrase([arg:A2, loc:decl, fcn:dobj, qnt:_, drs:D1-D3, res:D1-D2, sco:_-_, ana:N2-N3, para:P2-P3, tree:NP]).


verb_phrase([arg:[num:pl, ind:I], vform:V, evtl:E, loc:ante, drs:D1-D3, res:D1-D2, sco:S, ana:N1-N3, para:P1-P3, tree:[vp_70, TV, NP]])
  -->
  transitive_verb([wfm:WF, arg:[num:pl, ind:I], arg:A2, vform:V, evtl:E, con:C, drs:S, ana:N1-N2, para:[['&lt;/ins&gt;'], [each], ['&lt;ins&gt;']|P1]-P2, tree:TV]),
  noun_phrase([arg:A2, loc:ante, fcn:dobj, qnt:_, drs:D1-D3, res:D1-D2, sco:_-_, ana:N2-N3, para:P2-P3, tree:NP]).


% -------------------------
% copula


verb_phrase([crd:'-', arg:A, loc:L, drs:D1-D3, ana:N, para:P, tree:[vp_71, VP]])
  -->
  verb_phrase([cat:cp, arg:A, vform:fin, evtl:E, pol:pos, loc:L, drs:D1-D3, res:D1-D2, sco:D2-D3, ana:N, para:P, tree:VP]).


% verb_phrase([crd:'-', arg:A, loc:ante, drs:D1-D3, ana:N, para:P, tree:[vp_72, VP]])
%  -->
%  verb_phrase([cat:cp, arg:A, vform:fin, evtl:E, pol:pos, loc:ante, drs:D1-D3, res:D1-D2, sco:D2-D3, ana:N, para:P, tree:VP]).


% verb_phrase([crd:'-', arg:A, loc:cons, drs:D1-D3, ana:N, para:P, tree:[vp_73, VP]])
%  -->
%  verb_phrase([cat:cp, arg:A, vform:fin, evtl:E, pol:pos, loc:cons, drs:D1-D3, res:D1-D2, sco:D2-D3, ana:N, para:P, tree:VP]).


% ---

verb_phrase([crd:'-', arg:A, loc:L, drs:D1-[drs(U1, [neg D2|C1])|D3], ana:N1-N2, para:P1-P2, tree:[vp_74, VP]])
  -->
  verb_phrase([cat:cp, arg:A, vform:fin, evtl:E, pol:neg, loc:L,
	       drs:[drs([], [])|D1]-[D2, drs(U1, C1)|D3], res:[drs([], [])|D1]-S, sco:S-[D2, drs(U1, C1)|D3], ana:N1-N2, para:P1-P2, tree:VP]).


% verb_phrase([crd:'-', arg:A, loc:ante, drs:D1-[drs(U1, [neg D2|C1])|D3], ana:N1-N2, para:P1-P2, tree:[vp_75, VP]])
%  -->
%  verb_phrase([cat:cp, arg:A, vform:fin, evtl:E, pol:neg, loc:ante,
%	       drs:[drs([], [])|D1]-[D2, drs(U1, C1)|D3], res:[drs([], [])|D1]-S, sco:S-[D2, drs(U1, C1)|D3], ana:N1-N2, para:P1-P2, tree:VP]).


% verb_phrase([crd:'-', arg:A, loc:cons, drs:D1-[drs(U1, [neg D2|C1])|D3], ana:N1-N2, para:P1-P2, tree:[vp_76, VP]])
%  -->
%  verb_phrase([cat:cp, arg:A, vform:fin, evtl:E, pol:neg, loc:cons,
%	       drs:[drs([], [])|D1]-[D2, drs(U1, C1)|D3], res:[drs([], [])|D1]-S, sco:S-[D2, drs(U1, C1)|D3], ana:N1-N2, para:P1-P2, tree:VP]).


% ---

verb_phrase([crd:'-', arg:A, loc:decl, drs:D1-D4, ana:N1-N3, para:P1-P3, tree:[vp_77, VP, PP]])
  -->
  verb_phrase_mod([cat:cp, arg:A, vform:fin, evtl:E, pol:pos, loc:L, drs:D1-D4, res:D1-D2, sco:D3-D4, ana:N1-N2, para:P1-P2, tree:VP]),
  prepositional_phrase_([wfm:WF, loc:decl, fcn:pmod, evtl:E, drs:D2-D3, ana:N2-N3, para:P2-P3, tree:PP]).


verb_phrase([crd:'-', arg:A, loc:ante, drs:D1-D4, ana:N1-N3, para:P1-P3, tree:[vp_78, VP, PP]])
   -->
   verb_phrase_mod([cat:cp, arg:A, vform:fin, evtl:E, pol:pos, loc:ante, drs:D1-D4, res:D1-D2, sco:D3-D4, ana:N1-N2, para:P1-P2, tree:VP]),
   prepositional_phrase_([wfm:WF, loc:ante, fcn:pmod, evtl:E, drs:D2-D3, ana:N2-N3, para:P2-P3, tree:PP]).


% Comment: to investigate requires probably splitting
verb_phrase([crd:'-', arg:A, loc:cons, drs:D1-D4, ana:N1-N3, para:P1-P3, tree:[vp_79, VP, PP]])
  -->
  verb_phrase_mod([cat:cp, arg:A, vform:fin, evtl:E, pol:pos, loc:cons, drs:D1-D4, res:D1-D2, sco:D3-D4, ana:N1-N2, para:P1-P2, tree:VP]),
  prepositional_phrase_([wfm:WF, loc:cons, fcn:pmod, evtl:E, drs:D2-D3, ana:N2-N3, para:P2-P3, tree:PP]).


% ----

verb_phrase([crd:'-', arg:A1, loc:decl, drs:D1-[drs(U1, [neg D4|C1])|D5], ana:N1-N3, para:P1-P3, tree:[vp_80, VP, PP]])
  -->
  verb_phrase_mod([cat:cp, arg:A1, vform:fin, evtl:E, pol:neg, loc:decl,
	           drs:[drs([], [])|D1]-[D4, drs(U1, C1)|D5], res:[drs([], [])|D1]-D2, sco:D3-[D4, drs(U1, C1)|D5],
	           ana:N1-N2, para:P1-P2, tree:VP]),
  prepositional_phrase_([wfm:WF, loc:decl, fcn:pmod, evtl:E, drs:D2-D3, ana:N2-N3, para:P2-P3, tree:PP]).


verb_phrase([crd:'-', arg:A1, loc:ante, drs:D1-[drs(U1, [neg D4|C1])|D5], ana:N1-N3, para:P1-P3, tree:[vp_81, VP, PP]])
  -->
  verb_phrase_mod([cat:cp, arg:A1, vform:fin, evtl:E, pol:neg, loc:ante,
	           drs:[drs([], [])|D1]-[D4, drs(U1, C1)|D5], res:[drs([], [])|D1]-D2, sco:D3-[D4, drs(U1, C1)|D5],
	           ana:N1-N2, para:P1-P2, tree:VP]),
  prepositional_phrase_([wfm:WF, loc:ante, fcn:pmod, evtl:E, drs:D2-D3, ana:N2-N3, para:P2-P3, tree:PP]).


verb_phrase([crd:'-', arg:A1, loc:cons, drs:D1-[drs(U1, [neg D4|C1])|D5], ana:N1-N3, para:P1-P3, tree:[vp_82, VP, PP]])
  -->
  verb_phrase_mod([cat:cp, arg:A1, vform:fin, evtl:E, pol:neg, loc:cons,
	           drs:[drs([], [])|D1]-[D4, drs(U1, C1)|D5], res:[drs([], [])|D1]-D2, sco:D3-[D4, drs(U1, C1)|D5],
	           ana:N1-N2, para:P1-P2, tree:VP]),
  prepositional_phrase_([wfm:WF, loc:cons, fcn:pmod, evtl:E, drs:D2-D3, ana:N2-N3, para:P2-P3, tree:PP]).


% ----


verb_phrase([crd:'-', arg:A, loc:ante, drs:D1-[drs(U1, [naf D2|C1])|D3], ana:N1-N2, para:P1-P2, tree:[vp_83, VP]])
  -->
  verb_phrase([cat:cp, arg:A, vform:fin, evtl:E, pol:naf, loc:ante,
	       drs:[drs([], [])|D1]-[D2, drs(U1, C1)|D3], res:[drs([], [])|D1]-S, sco:S-[D2, drs(U1, C1)|D3], ana:N1-N2, para:P1-P2, tree:VP]).


verb_phrase([crd:'-', arg:A, loc:ante, drs:D1-[drs(U1, [naf drs([], [neg D2])|C1])|D3], ana:N1-N2, para:P1-P2, tree:[vp_84, VP]])
  -->
  verb_phrase([cat:cp, arg:A, vform:fin, evtl:E, pol:naf_neg, loc:ante,
	       drs:[drs([], [])|D1]-[D2, drs(U1, C1)|D3], res:[drs([], [])|D1]-S, sco:S-[D2, drs(U1, C1)|D3], ana:N1-N2, para:P1-P2, tree:VP]).


verb_phrase([crd:'-', arg:A1, loc:ante, drs:D1-[drs(U1, [naf D4|C1])|D5], ana:N1-N3, para:P1-P3, tree:[vp_85, VP, PP]])
  -->
  verb_phrase_mod([cat:cp, arg:A1, vform:fin, evtl:E, pol:naf, loc:ante,
	           drs:[drs([], [])|D1]-[D4, drs(U1, C1)|D5], res:[drs([], [])|D1]-D2, sco:D3-[D4, drs(U1, C1)|D5],
	           ana:N1-N2, para:P1-P2, tree:VP]),
  prepositional_phrase_([wfm:WF, loc:ante, fcn:pmod, evtl:E, drs:D2-D3, ana:N2-N3, para:P2-P3, tree:PP]).


verb_phrase([crd:'-', arg:A1, loc:ante, drs:D1-[drs(U1, [naf drs([], [neg D4])|C1])|D5], ana:N1-N3, para:P1-P3, tree:[vp_86, VP, PP]])
  -->
  verb_phrase_mod([cat:cp, arg:A1, vform:fin, evtl:E, pol:naf_neg, loc:ante,
	           drs:[drs([], [])|D1]-[D4, drs(U1, C1)|D5], res:[drs([], [])|D1]-D2, sco:D3-[D4, drs(U1, C1)|D5],
	           ana:N1-N2, para:P1-P2, tree:VP]),
  prepositional_phrase_([wfm:WF, loc:ante, fcn:pmod, evtl:E, drs:D2-D3, ana:N2-N3, para:P2-P3, tree:PP]).

    
% ----

verb_phrase([cat:cp, arg:A1, vform:V, evtl:E, pol:pos, loc:L, drs:D1-D3, res:D1-D1, sco:S1-S3, ana:N1-N3, para:P1-P3, tree:[vp_87, Cop, Adj]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:Cop]),
  adjective([evtl:E, con:C, drs:S1-S2, ana:N2-N3, para:P2-P3, tree:Adj]).


verb_phrase_mod([cat:cp, arg:A1, vform:V, evtl:E, pol:pos, loc:L, drs:D1-D3, res:D1-D1, sco:S1-S3, ana:N1-N3, para:P1-P3, tree:[vp_88, Cop, Adj]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:Cop]),
  adjective([evtl:E, con:C, drs:S1-S2, ana:N2-N3, para:P2-P3, tree:Adj]).


verb_phrase([cat:cp, arg:A1, vform:V, evtl:E, pol:neg, loc:L, drs:D1-D3, res:D1-D1, sco:S1-S3, ana:N1-N4, para:P1-P4, tree:[vp_89, Cop, Neg, Adj]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  adjective([evtl:E, con:C, drs:S1-S2, ana:N3-N4, para:P3-P4, tree:Adj]).


verb_phrase([cat:cp, arg:A1, vform:V, evtl:E, pol:neg, loc:L, drs:D1-D3, res:D1-D1, sco:S1-S3, ana:N1-N4, para:P1-P4, tree:[vp_90, Cop, Neg, Adj]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  adjective([evtl:E, con:C, drs:S1-S2, ana:N3-N4, para:P3-P4, tree:Adj]).


% -----
% copula + adjective

verb_phrase([cat:cp, arg:A1, vform:V, evtl:E, pol:naf, loc:ante, drs:D1-D3, res:D1-D1, sco:S1-S3, ana:N1-N4, para:P1-P4, tree:[vp_91, Cop, Neg, Adj]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  adjective([evtl:E, con:C, drs:S1-S2, ana:N3-N4, para:P3-P4, tree:Adj]).


verb_phrase_mod([cat:cp, arg:A1, vform:V, evtl:E, pol:naf, loc:ante, drs:D1-D3, res:D1-D1, sco:S1-S3, ana:N1-N4, para:P1-P4, tree:[vp_92, Cop, Neg, Adj]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  adjective([evtl:E, con:C, drs:S1-S2, ana:N3-N4, para:P3-P4, tree:Adj]).


verb_phrase([cat:cp, arg:A1, vform:V, evtl:E, pol:naf, loc:ante, drs:D1-D3, res:D1-D1, sco:S1-S3, ana:N1-N5, para:P1-P5, tree:[vp_93, Cop, Neg, Adv, Adj]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  adverb([wfm:[provably], evtl:_E, drs:_-_, ana:N3-N4, para:P3-P4, tree:Adv]),
  adjective([evtl:E, con:C, drs:S1-S2, ana:N4-N5, para:P4-P5, tree:Adj]).


verb_phrase_mod([cat:cp, arg:A1, vform:V, evtl:E, pol:naf, loc:ante, drs:D1-D3, res:D1-D1, sco:S1-S3, ana:N1-N5, para:P1-P5, tree:[vp_94, Cop, Neg, Adv, Adj]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  adverb([wfm:[provably], evtl:_E, drs:_-_, ana:N3-N4, para:P3-P4, tree:Adv]),
  adjective([evtl:E, con:C, drs:S1-S2, ana:N4-N5, para:P4-P5, tree:Adj]).


verb_phrase([cat:cp, arg:A1, vform:V, evtl:E, pol:naf_neg, loc:ante, drs:D1-D3, res:D1-D1, sco:S1-S3, ana:N1-N6, para:P1-P6, tree:[vp_95, Cop, Neg1, Adv, Neg2, Adj]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg1]),
  adverb([wfm:[provably], evtl:_E, drs:_-_, ana:N3-N4, para:P3-P4, tree:Adv]),
  negation([wfm:[not], ana:N4-N5, para:P4-P5, tree:Neg2]),
  adjective([evtl:E, con:C, drs:S1-S2, ana:N5-N6, para:P5-P6, tree:Adj]).


verb_phrase_mod([cat:cp, arg:A1, vform:V, evtl:E, pol:naf_neg, loc:ante, drs:D1-D3, res:D1-D1, sco:S1-S3, ana:N1-N6, para:P1-P6, tree:[vp_96, Cop, Neg1, Adv, Neg2, Adj]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg1]),
  adverb([wfm:[provably], evtl:_E, drs:_-_, ana:N3-N4, para:P3-P4, tree:Adv]),
  negation([wfm:[not], ana:N4-N5, para:P4-P5, tree:Neg2]),
  adjective([evtl:E, con:C, drs:S1-S2, ana:N5-N6, para:P5-P6, tree:Adj]).


% -----
% copula + relational adjective


% If a student is not probably not located in a Department of Computer Science then the student is abnormally afraid of math.
% Every student who is not provably not located in a Department of Computer Science is abnormally afraid of math.
%

verb_phrase([cat:cp, arg:A1, vform:V, evtl:E, pol:naf_neg, loc:ante, drs:D1-D4, res:D1-D1, sco:D1-D4, ana:N1-N7, para:P1-P7, tree:[vp_97, Cop, Neg1, Adv, Neg2, RAdj, NP]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:D3-D4, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg1]),
  adverb([wfm:[provably], evtl:E, drs:_-_, ana:N3-N4, para:P3-P4, tree:Adv]),
  negation([wfm:[not], ana:N4-N5, para:P4-P5, tree:Neg2]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:D2-D3, ana:N5-N6, para:P5-P6, tree:RAdj]),
  noun_phrase([arg:A2, loc:ante, fcn:dobj, qnt:_, drs:D1-D5, res:D1-D2, sco:_-_, ana:N6-N7, para:P6-P7, tree:NP]).


verb_phrase_mod([cat:cp, arg:A1, vform:V, evtl:E, pol:naf_neg, loc:ante, drs:D1-S3, res:D1-D2, sco:S1-S3,
		 ana:N1-N7, para:P1-P7, tree:[vp_98, Cop, Neg1, Adv, Neg2, RAdj, NP]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg1]),
  adverb([wfm:[provably], evtl:E, drs:_-_, ana:N3-N4, para:P3-P4, tree:Adv]),
  negation([wfm:[not], ana:N4-N5, para:P4-P5, tree:Neg2]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:S1-S2, ana:N5-N6, para:P5-P6, tree:RAdj]),
  noun_phrase([arg:A2, loc:ante, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N6-N7, para:P6-P7, tree:NP]).


% If a student is not provably located in a department then the student is not located in that department.
%
verb_phrase([cat:cp, arg:A1, vform:V, evtl:E, pol:naf, loc:ante, drs:D1-D4, res:D1-D1, sco:D1-D4, ana:N1-N6, para:P1-P6, tree:[vp_99, Cop, Neg, Adv, RAdj, NP]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:D3-D4, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  adverb([wfm:[provably], evtl:E, drs:_-_, ana:N3-N4, para:P3-P4, tree:Adv]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:D2-D3, ana:N4-N5, para:P4-P5, tree:RAdj]),
  noun_phrase([arg:A2, loc:ante, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N5-N6, para:P5-P6, tree:NP]).


verb_phrase_mod([cat:cp, arg:A1, vform:V, evtl:E, pol:naf, loc:ante, drs:D1-S3, res:D1-D2, sco:S1-S3,
	 	   ana:N1-N6, para:P1-P6, tree:[vp_100, Cop, Neg, Adv, RAdj, NP]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  adverb([wfm:[provably], evtl:E, drs:_-_, ana:N3-N4, para:P3-P4, tree:Adv]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:S1-S2, ana:N4-N5, para:P4-P5, tree:RAdj]),
  noun_phrase([arg:A2, loc:ante, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N5-N6, para:P5-P6, tree:NP]).


% ----

verb_phrase([cat:cp, arg:A1, vform:V, evtl:E, pol:neg, loc:ante, drs:D1-D4, res:D1-D1, sco:D1-D4, ana:N1-N5, para:P1-P5, tree:[vp_101, Cop, Neg, RAdj, NP]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:D3-D4, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:RAdj]),
  noun_phrase([arg:A2, loc:ante, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N4-N5, para:P4-P5, tree:NP]).


verb_phrase_mod([cat:cp, arg:A1, vform:V, evtl:E, pol:neg, loc:ante, drs:D1-S3, res:D1-D2, sco:S1-S3, ana:N1-N5, para:P1-P5, tree:[vp_102, Cop, Neg, RAdj, NP]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:S1-S2, ana:N3-N4, para:P3-P4, tree:RAdj]),
  noun_phrase([arg:A2, loc:ante, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N4-N5, para:P4-P5, tree:NP]).


verb_phrase([cat:cp, arg:A1, vform:V, evtl:E, pol:pos, loc:ante, drs:D1-D4, res:D1-D1, sco:D1-D4, ana:N1-N4, para:P1-P4, tree:[vp_103, Cop, RAdj, NP]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:D3-D4, ana:N1-N2, para:P1-P2, tree:Cop]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:D2-D3, ana:N2-N3, para:P2-P3, tree:RAdj]),
  noun_phrase([arg:A2, loc:ante, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N3-N4, para:P3-P4, tree:NP]).


verb_phrase_mod([cat:cp, arg:A1, vform:V, evtl:E, pol:pos, loc:ante, drs:D1-S3, res:D1-D2, sco:S1-S3, ana:N1-N4, para:P1-P4, tree:[vp_104, Cop, RAdj, NP]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:Cop]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:S1-S2, ana:N2-N3, para:P2-P3, tree:RAdj]),
  noun_phrase([arg:A2, loc:ante, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N3-N4, para:P3-P4, tree:NP]).


% ----

verb_phrase([cat:cp, arg:A1, vform:V, evtl:E, pol:neg, loc:decl, drs:D1-D4, res:D1-D1, sco:D1-D4, ana:N1-N5, para:P1-P5, tree:[vp_105, Cop, Neg, RAdj, NP]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:D3-D4, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:RAdj]),
  noun_phrase([arg:A2, loc:decl, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N4-N5, para:P4-P5, tree:NP]).


verb_phrase_mod([cat:cp, arg:A1, vform:V, evtl:E, pol:neg, loc:decl, drs:D1-S3, res:D1-D2, sco:S1-S3, ana:N1-N5, para:P1-P5, tree:[vp_106, Cop, Neg, RAdj, NP]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:S1-S2, ana:N3-N4, para:P3-P4, tree:RAdj]),
  noun_phrase([arg:A2, loc:decl, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N4-N5, para:P4-P5, tree:NP]).


verb_phrase([cat:cp, arg:A1, vform:V, evtl:E, pol:pos, loc:decl, drs:D1-D4, res:D1-D1, sco:D1-D4, ana:N1-N4, para:P1-P4, tree:[vp_107, Cop, RAdj, NP]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:D3-D4, ana:N1-N2, para:P1-P2, tree:Cop]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:D2-D3, ana:N2-N3, para:P2-P3, tree:RAdj]),
  noun_phrase([arg:A2, loc:decl, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N3-N4, para:P3-P4, tree:NP]).


verb_phrase_mod([cat:cp, arg:A1, vform:V, evtl:E, pol:pos, loc:decl, drs:D1-S3, res:D1-D2, sco:S1-S3, ana:N1-N4, para:P1-P4, tree:[vp_108, Cop, RAdj, NP]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:Cop]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:S1-S2, ana:N2-N3, para:P2-P3, tree:RAdj]),
  noun_phrase([arg:A2, loc:decl, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N3-N4, para:P3-P4, tree:NP]).


% ----

verb_phrase([cat:cp, arg:A1, vform:V, evtl:E, pol:neg, loc:cons, drs:D1-D4, res:D1-D1, sco:D1-D4, ana:N1-N5, para:P1-P5, tree:[vp_109, Cop, Neg, RAdj, NP]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:D3-D4, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:RAdj]),
  noun_phrase([arg:A2, loc:cons, fcn:dobj, qnt:def, drs:D1-_, res:D1-D2, sco:_-_, ana:N4-N5, para:P4-P5, tree:NP]).


/*** Rule splitting required in drs to asp
verb_phrase_mod([cat:cp, arg:A1, vform:V, evtl:E, pol:neg, loc:cons, drs:D1-S3, res:D1-D2, sco:S1-S3, ana:N1-N5, para:P1-P5, tree:[vp_110, Cop, Neg, RAdj, NP]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:S1-S2, ana:N3-N4, para:P3-P4, tree:RAdj]),
  noun_phrase([arg:A2, loc:cons, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N4-N5, para:P4-P5, tree:NP]).
***/


verb_phrase([cat:cp, arg:[num:sg, ind:I], vform:V, evtl:E, pol:pos, loc:cons, drs:D1-D4, res:D1-D1, sco:D1-D4, ana:N1-N4, para:P1-P4, tree:[vp_111, Cop, RAdj, NP]])
  -->
  copula([wfm:WF, arg:[num:sg, ind:I], vform:V, evtl:E, drs:D3-D4, ana:N1-N2, para:P1-P2, tree:Cop]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:D2-D3, ana:N2-N3, para:P2-P3, tree:RAdj]),
  noun_phrase([arg:A2, loc:cons, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N3-N4, para:P3-P4, tree:NP]).


verb_phrase([cat:cp, arg:[num:pl, ind:I], vform:V, evtl:E, pol:pos, loc:cons, drs:D1-D4, res:D1-D1, sco:D1-D4, ana:N1-N4, para:P1-P4, tree:[vp_112, Cop, RAdj, NP]])
  -->
  copula([wfm:WF, arg:[num:pl, ind:I], vform:V, evtl:E, drs:D3-D4, ana:N1-N2, para:P1-P2, tree:Cop]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:D2-D3, ana:N2-N3, para:[['&lt;/ins&gt;'], [each], ['&lt;ins&gt;']|P2]-P3, tree:RAdj]),
  noun_phrase([arg:A2, loc:cons, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N3-N4, para:P3-P4, tree:NP]).


/*** Rule splitting required in drs to asp
verb_phrase_mod([cat:cp, arg:A1, vform:V, evtl:E, pol:pos, loc:cons, drs:D1-S3, res:D1-D2, sco:S1-S3, ana:N1-N4, para:P1-P4, tree:[vp_113, Cop, RAdj, NP]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:Cop]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:S1-S2, ana:N2-N3, para:P2-P3, tree:RAdj]),
  noun_phrase([arg:A2, loc:cons, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N3-N4, para:P3-P4, tree:NP]).
***/


% ---

verb_phrase([cat:cp, arg:A1, vform:V, evtl:E, pol:pos, loc:cons, drs:D1-D5, res:D1-D1, sco:D1-D5, ana:N1-N5, para:P1-P5, tree:[vp_114, Cop, Adv, RAdj, NP]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:D4-D5, ana:N1-N2, para:P1-P2, tree:Cop]),
  adverb([wfm:[abnormally], evtl:E, drs:D3-D4, ana:N2-N3, para:P2-P3, tree:Adv]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:RAdj]),  
  noun_phrase([arg:A2, loc:cons, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N4-N5, para:P4-P5, tree:NP]).

% ---

% Plural to be implemented
% verb_phrase([crd:'-', arg:[num:pl, ind:I], loc:ante, drs:D, ana:N1-N4, para:P1-P4, tree:[vp_115, Cop, RAdj, NP]])
%  -->
%  copula([wfm:WF, arg:[num:pl, ind:I], vform:V, evtl:E, drs:S1-S2, ana:N1-N2, para:[['&lt;/ins&gt;'], [each], ['&lt;ins&gt;']|P1]-P2, tree:Cop]),
%  relational_adjective([evtl:E, arg:A2, con:C, drs:S2-S3, ana:N2-N3, para:P2-P3, tree:RAdj]),
% noun_phrase([arg:A2, loc:decl, fcn:dobj, qnt:_, drs:D, sco:S1-S3, ana:N3-N4, para:P3-P4, tree:NP]).


% verb_phrase([crd:'-', arg:[num:pl, ind:I], loc:decl, drs:D, ana:N1-N4, para:P1-P4, tree:[vp_116, Cop, RAdj, NP]])
%  -->
%  copula([wfm:WF, arg:[num:pl, ind:I], vform:V, evtl:E, drs:S1-S2, ana:N1-N2, para:[['&lt;/ins&gt;'], [each], ['&lt;ins&gt;']|P1]-P2, tree:Cop]),
%  relational_adjective([evtl:E, arg:A2, con:C, drs:S2-S3, ana:N2-N3, para:P2-P3, tree:RAdj]),
%  noun_phrase([arg:A2, loc:decl, fcn:dobj, qnt:_, drs:D, sco:S1-S3, ana:N3-N4, para:P3-P4, tree:NP]).


% [Exclude,that,Olivier,is,allocated,to,the,sixth,position,.]

verb_phrase([crd:'-', arg:[num:sg, ind:I], loc:ante, drs:D, ana:N1-N4, para:P1-P4, tree:[vp_117, Cop, RAdj, NP]])
  -->
  copula([wfm:WF, arg:[num:sg, ind:I], vform:V, evtl:E, drs:S1-S2, ana:N1-N2, para:P1-P2, tree:Cop]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:S2-S3, ana:N2-N3, para:P2-P3, tree:RAdj]),
  noun_phrase([arg:A2, loc:ante, fcn:dobj, qnt:_, drs:D, sco:S1-S3, ana:N3-N4, para:P3-P4, tree:NP]).


% -------------------------
% John is the teacher of Sam                    
% John is a teacher of Sam


verb_phrase([cat:cp, arg:A1, vform:V, evtl:E, pol:naf_neg, loc:ante, drs:D1-D3, res:D1-D1, sco:D1-D3, ana:N1-N6, para:P1-P6, tree:[vp_118, Cop, Neg1, Adv, Neg2, NP]])
  -->
  copula([wfm:WF, arg:A1, arg:[num:sg, ind:I], vform:V, evtl:E, drs:D2-D3, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg1]),
  adverb([wfm:[provably], evtl:E, drs:_-_, ana:N3-N4, para:P3-P4, tree:Adv]),
  negation([wfm:[not], ana:N4-N5, para:P4-P5, tree:Neg2]),    
  noun_phrase([arg:[num:sg, ind:I], loc:ante, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N5-N6, para:P5-P6, tree:NP]).


verb_phrase_mod([cat:cp, arg:A1, vform:V, evtl:E, pol:naf_neg, loc:ante, drs:D1-D3, res:D1-D1, sco:D1-D3, ana:N1-N6, para:P1-P6, tree:[vp_119, Cop, Neg1, Adv, Neg2, NP]])
  -->
  copula([wfm:WF, arg:A1, arg:[num:sg, ind:I], vform:V, evtl:E, drs:D2-D3, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg1]),
  adverb([wfm:[provably], evtl:E, drs:_-_, ana:N3-N4, para:P3-P4, tree:Adv]),
  negation([wfm:[not], ana:N4-N5, para:P4-P5, tree:Neg2]),   
  noun_phrase([arg:[num:sg, ind:I], loc:ante, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N5-N6, para:P5-P6, tree:NP]).


verb_phrase([cat:cp, arg:A1, vform:V, evtl:E, pol:naf, loc:ante, drs:D1-D3, res:D1-D1, sco:D1-D3, ana:N1-N5, para:P1-P5, tree:[vp_120, Cop, Neg, Adv, NP]])
  -->
  copula([wfm:WF, arg:A1, arg:[num:sg, ind:I], vform:V, evtl:E, drs:D2-D3, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  adverb([wfm:[provably], evtl:E, drs:_-_, ana:N3-N4, para:P3-P4, tree:Adv]),
  noun_phrase([arg:[num:sg, ind:I], loc:ante, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N4-N5, para:P4-P5, tree:NP]).


verb_phrase_mod([cat:cp, arg:A1, vform:V, evtl:E, pol:naf, loc:ante, drs:D1-D3, res:D1-D1, sco:D1-D3, ana:N1-N5, para:P1-P5, tree:[vp_121, Cop, Neg, Adv, NP]])
  -->
  copula([wfm:WF, arg:A1, arg:[num:sg, ind:I], vform:V, evtl:E, drs:D2-D3, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  adverb([wfm:[provably], evtl:E, drs:_-_, ana:N3-N4, para:P3-P4, tree:Adv]),
  noun_phrase([arg:[num:sg, ind:I], loc:ante, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N4-N5, para:P4-P5, tree:NP]).


verb_phrase([cat:cp, arg:A1, vform:V, evtl:E, pol:pos, loc:decl, drs:D1-D3, res:D1-D1, sco:D1-D3, ana:N1-N3, para:P1-P3, tree:[vp_122, Cop, NP]])
  -->
  copula([wfm:WF, arg:A1, arg:[num:sg, ind:I], vform:V, evtl:E, drs:D2-D3, ana:N1-N2, para:P1-P2, tree:Cop]),  
  noun_phrase([arg:[num:sg, ind:I], loc:decl, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N2-N3, para:P2-P3, tree:NP]).


verb_phrase_mod([cat:cp, arg:A1, vform:V, evtl:E, pol:pos, loc:decl, drs:D1-S2, res:D1-D2, sco:S1-S2, ana:N1-N3, para:P1-P3, tree:[vp_123, Cop, NP]])
  -->
  copula([wfm:WF, arg:A1, arg:[num:sg, ind:I], vform:V, evtl:E, drs:S1-S2, ana:N1-N2, para:P1-P2, tree:Cop]),  
  noun_phrase([arg:[num:sg, ind:I], loc:decl, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N2-N3, para:P2-P3, tree:NP]).


verb_phrase([cat:cp, arg:A1, vform:V, evtl:E, pol:pos, loc:ante, drs:D1-D3, res:D1-D1, sco:D1-D3, ana:N1-N3, para:P1-P3, tree:[vp_124, Cop, NP]])
  -->
  copula([wfm:WF, arg:A1, arg:[num:sg, ind:I], vform:V, evtl:E, drs:D2-D3, ana:N1-N2, para:P1-P2, tree:Cop]),  
  noun_phrase([arg:[num:sg, ind:I], loc:ante, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N2-N3, para:P2-P3, tree:NP]).  


verb_phrase_mod([cat:cp, arg:A1, vform:V, evtl:E, pol:pos, loc:ante, drs:D1-S2, res:D1-D2, sco:S1-S2, ana:N1-N3, para:P1-P3, tree:[vp_125, Cop, NP]])
  -->
  copula([wfm:WF, arg:A1, arg:[num:sg, ind:I], vform:V, evtl:E, drs:S1-S2, ana:N1-N2, para:P1-P2, tree:Cop]),  
  noun_phrase([arg:[num:sg, ind:I], loc:ante, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N2-N3, para:P2-P3, tree:NP]).


verb_phrase([cat:cp, arg:A1, vform:V, evtl:E, pol:pos, loc:cons, drs:D1-D3, res:D1-D1, sco:D1-D3, ana:N1-N3, para:P1-P3, tree:[vp_126, Cop, NP]])
  -->
  copula([wfm:WF, arg:A1, arg:[num:sg, ind:I], vform:V, evtl:E, drs:D2-D3, ana:N1-N2, para:P1-P2, tree:Cop]),  
  noun_phrase([arg:[num:sg, ind:I], loc:cons, fcn:pred_nominal, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N2-N3, para:P2-P3, tree:NP]).



% --- NOMINAL

noun_phrase([arg:A, loc:cons, fcn:pred_nominal, qnt:exist, drs:D, res:R, sco:_, ana:N1-N1, para:P1-P3, tree:[np_117, Det, Noun]])
  -->
  determiner([arg:A, fcn:cons, qnt:exist, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R, ana:N2-N3, para:P2-P3, tree:Noun]).


noun_phrase([arg:A1, loc:cons, fcn:pred_nominal, qnt:exist, drs:D, res:R1-R4, sco:_-_, ana:N1-N5, para:P1-P5, tree:[np_118, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:cons, qnt:exist, drs:D, res:R1-R4, sco:S1, ana:N1-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:cons, fcn:pobj, qnt:def, drs:R3-R4, sco:S2-S2, ana:N1-N1-N5, para:P4-P5, tree:NP]).


noun_phrase([arg:A1, loc:cons, fcn:pred_nominal, qnt:def, drs:D, res:R1-R4, sco:_-_, ana:N1-N5, para:P1-P5, tree:[np_119, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:cons, qnt:def, drs:D, res:R1-R4, sco:S1, ana:N1-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:cons, fcn:pobj, qnt:def, drs:R3-R4, sco:S2-S2, ana:N1-N1-N5, para:P4-P5, tree:NP]).

% ---

verb_phrase([cat:cp, arg:A1, vform:V, evtl:E, pol:neg, loc:decl, drs:D1-D3, res:D1-D1, sco:D1-D3, ana:N1-N4, para:P1-P4, tree:[vp_127, Cop, Neg, NP]])
  -->
  copula([wfm:WF, arg:A1, arg:[num:sg, ind:I], vform:V, evtl:E, drs:D2-D3, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),    
  noun_phrase([arg:[num:sg, ind:I], loc:decl, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N3-N4, para:P3-P4, tree:NP]).


verb_phrase_mod([cat:cp, arg:A1, vform:V, evtl:E, pol:neg, loc:decl, drs:D1-S2, res:D1-D2, sco:S1-S2, ana:N1-N4, para:P1-P4, tree:[vp_128, Cop, Neg, NP]])
  -->
  copula([wfm:WF, arg:A1, arg:[num:sg, ind:I], vform:V, evtl:E, drs:S1-S2, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),    
  noun_phrase([arg:[num:sg, ind:I], loc:decl, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N3-N4, para:P3-P4, tree:NP]).


verb_phrase([cat:cp, arg:A1, vform:V, evtl:E, pol:neg, loc:ante, drs:D1-D3, res:D1-D1, sco:D1-D3, ana:N1-N4, para:P1-P4, tree:[vp_129, Cop, Neg, NP]])
  -->
  copula([wfm:WF, arg:A1, arg:[num:sg, ind:I], vform:V, evtl:E, drs:D2-D3, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),        
  noun_phrase([arg:[num:sg, ind:I], loc:ante, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N3-N4, para:P3-P4, tree:NP]).  


verb_phrase_mod([cat:cp, arg:A1, vform:V, evtl:E, pol:neg, loc:ante, drs:D1-S2, res:D1-D2, sco:S1-S2, ana:N1-N4, para:P1-P4, tree:[vp_130, Cop, Neg, NP]])
  -->
  copula([wfm:WF, arg:A1, arg:[num:sg, ind:I], vform:V, evtl:E, drs:S1-S2, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),          
  noun_phrase([arg:[num:sg, ind:I], loc:ante, fcn:dobj, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N3-N4, para:P3-P4, tree:NP]).


verb_phrase([cat:cp, arg:A1, vform:V, evtl:E, pol:neg, loc:cons, drs:D1-D3, res:D1-D1, sco:D1-D3, ana:N1-N4, para:P1-P4, tree:[vp_131, Cop, Neg, NP]])
  -->
  copula([wfm:WF, arg:A1, arg:[num:sg, ind:I], vform:V, evtl:E, drs:D2-D3, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),        
  noun_phrase([arg:[num:sg, ind:I], loc:cons, fcn:pred_nominal, qnt:_, drs:D1-_, res:D1-D2, sco:_-_, ana:N3-N4, para:P3-P4, tree:NP]).


% -------------------------
%

verb_phrase([cat:cp, arg:[num:pl, ind:I1], vform:V, evtl:E, pol:pos, loc:decl, drs:D1-D3, res:D1-D1, sco:D1-D3, ana:N1-N1, para:P1-P3, tree:[vp_132, Cop, Noun]])
  -->
  copula([wfm:[are], arg:[num:pl, ind:I1], arg:[num:pl, ind:I2], vform:V, evtl:E, drs:D2-D3, ana:N1-N2, para:[['&lt;/ins&gt;'], [each], ['&lt;ins&gt;']|P1]-P2, tree:Cop]),
  count_noun([wfm:WF, arg:[num:pl, ind:I2], drs:D1-D2, ana:N2-N3, para:P2-P3, tree:Noun]).


% not yet implemented
% verb_phrase_mod([cat:cp, arg:[num:pl, ind:I1], vform:V, evtl:E, pol:pos, loc:decl, drs:D1-S2, res:D1-D2, sco:S1-S2, ana:N1-N1, para:P1-P3, tree:[vp_133, Cop, Noun]])
%  -->
%  copula([wfm:[are], arg:[num:pl, ind:I1], arg:[num:pl, ind:I2], vform:V, evtl:E, drs:S1-S2, ana:N1-N2, para:[['&lt;/ins&gt;'], [each], ['&lt;ins&gt;']|P1]-P2, tree:Cop]),
%  count_noun([wfm:WF, arg:[num:pl, ind:I2], drs:D1-D2, ana:N2-N3, para:P2-P3, tree:Noun]).


% verb_phrase([cat:cp, arg:[num:pl, ind:I1], vform:V, evtl:E, pol:pos, loc:cons, drs:D1-D3, res:D1-D1, sco:D1-D3, ana:N1-N1, para:P1-P3, tree:[vp_134, Cop, Noun]])
%  -->
%  copula([wfm:[are], arg:[num:pl, ind:I1], arg:[num:pl, ind:I2], vform:V, evtl:E, drs:D2-D3, ana:N1-N2, para:[['&lt;/ins&gt;'], [each], ['&lt;ins&gt;']|P1]-P2, tree:Cop]),
%  count_noun([wfm:WF, arg:[num:pl, ind:I2], drs:D1-D2, ana:N2-N3, para:P2-P3, tree:Noun]).


verb_phrase([cat:cp, arg:[num:pl, ind:I1], vform:V, evtl:E, pos:pos, loc:decl, drs:D1-D3, res:D1-D1, sco:D1-D3, ana:N1-N3, para:P1-P3, tree:[vp_135, Cop, Adj]])
  -->
  copula([wfm:[are], arg:[num:pl, ind:I1], vform:V, evtl:E, drs:D2-D3, ana:N1-N2, para:[['&lt;/ins&gt;'], [each], ['&lt;ins&gt;']|P1]-P2, tree:Cop]),
  adjective([evtl:E, con:C, drs:D1-D2, ana:N2-N3, para:P2-P3, tree:Adj]).


% verb_phrase([cat:cp, arg:[num:pl, ind:I1], vform:V, evtl:E, pos:pos, loc:cons, drs:D1-D3, res:D1-D1, sco:D1-D3, ana:N1-N3, para:P1-P3, tree:[vp_136, Cop, Adj]])
%  -->
%  copula([wfm:[are], arg:[num:pl, ind:I1], vform:V, evtl:E, drs:D2-D3, ana:N1-N2, para:[['&lt;/ins&gt;'], [each], ['&lt;ins&gt;']|P1]-P2, tree:Cop]),
%  adjective([evtl:E, con:C, drs:D1-D2, ana:N2-N3, para:P2-P3, tree:Adj]).


% -------------------------

% in the garden
prepositional_phrase_([wfm:[in], loc:L, fcn:pmod, evtl:E, drs:D1-D3, ana:N1-N3, para:P1-P3, tree:[pp_1a, Prep, NP]])
  -->
  preposition([wfm:[in], evtl:E, arg:A, drs:D2-D3, ana:N1-N2, para:P1-P2, tree:Prep]),
  noun_phrase([arg:A, loc:L, fcn:pmod, drs:D1-D, res:D1-D2, sco:_-_, ana:N2-N3, para:P2-P3, tree:NP]).


% --------------------------------------------------
%%% fix this one -- event calculus
% --------------------------------------------------

verb_phrase([crd:'-', arg:A1, loc:ante, drs:D1-S3, ana:N1-N3, para:P1-P3, tree:[vp_137, VP, PP]])
  -->
  verb_phrase_x([arg:A1, vform:fin, evtl:E, loc:L, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:VP]),
  prepositional_phrase([wfm:[at], loc:ante, fcn:pmod, evtl:E, drs:D1-S0, sco:S1-S2, ana:N2-N3, para:P2-P3, tree:PP]).


verb_phrase([crd:'-', arg:A1, loc:decl, drs:D1-S3, ana:N1-N3, para:P1-P3, tree:[vp_138, VP, PP]])
  -->
  verb_phrase_x([arg:A1, vform:fin, evtl:E, loc:L, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:VP]),
  prepositional_phrase([wfm:[at], loc:decl, fcn:pmod, evtl:E, drs:D1-S0, sco:S1-S2, ana:N2-N3, para:P2-P3, tree:PP]).


verb_phrase([crd:'-', arg:A1, loc:cons, drs:D1-S3, ana:N1-N3, para:P1-P3, tree:[vp_139, VP, PP]])
  -->
  verb_phrase_x([arg:A1, vform:fin, evtl:E, loc:L, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:VP]),
  prepositional_phrase([wfm:[at], loc:cons, fcn:pmod, evtl:E, drs:D1-S0, sco:S1-S2, ana:N2-N3, para:P2-P3, tree:PP]).


prepositional_phrase([wfm:[at], loc:L, fcn:pmod, evtl:E, drs:D1-D3, sco:D2-D3, ana:N1-N3, para:P1-P3, tree:[pp_1a, Prep, NP]])
  -->
  preposition([wfm:[at], evtl:E, arg:A, drs:D2-D3, ana:N1-N2, para:P1-P2, tree:Prep]),
  noun_phrase([arg:A, loc:L, fcn:tex, drs:D1-D3, sco:D2-D3, ana:N2-N3, para:P2-P3, tree:NP]).


noun_phrase([arg:A, loc:decl, fcn:tex, drs:D1-D2, sco:D4-D5, ana:N1-N3, para:P1-P3, tree:[np_120, TX]])
  -->
  temporal_expression([arg:A, drs:[drs([], [])|D1]-D2, res:[drs([], [])|D1]-[D3|D1], sco:S, ana:[]-N2, para:P1-P2, tree:TX]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:[D3], sco:D4-[], ana:N1-N2-N3, para:P1-P2-P3]) }.


noun_phrase([arg:A1, loc:cons, fcn:tex, drs:D1-D0, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_121, Det, Noun, Var]])
  -->
  determiner([arg:A1, fcn:O, qnt:def, drs:D1-_, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:[time, point], arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A1, ref:F, drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


noun_phrase([arg:A1, loc:cons, fcn:tex, drs:D1-D0, sco:D5-D6, ana:N1-N7, para:P1-P7, tree:[np_122, Det, Noun, Var, Op, Num]])
  -->
  determiner([arg:A1, fcn:O, qnt:def, drs:D1-_, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:[time, point], arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A1, ref:F, drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) },
  operator([wfm:[plus], arg:A2, arg:A3, drs:R2-D5, ana:N5-N6, para:P5-P6, tree:Op]),
  number([wfm:[1], arg:A3, drs:D1-R1, res:R1-R2, sco:_-_, ana:N6-N7, para:P6-P7, tree:Num]).


noun_phrase([arg:A1, loc:ante, fcn:tex, drs:D1-D0, sco:R3-S2, ana:N1-N4, para:P1-P4, tree:[np_123, Det, Noun, Var]])
  -->
  determiner([arg:A1, fcn:O, qnt:exist, drs:D1-_, res:D1-R3, sco:R3-S2, ana:N1-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:[time, point], arg:A, drs:D1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Var]).


% -------------------------

prepositional_phrase_([wfm:[at], loc:L, fcn:pmod, evtl:E, drs:D1-D3, ana:N1-N3, para:P1-P3, tree:[pp_1a, Prep, NP]])
  -->
  preposition([wfm:[at], evtl:E, arg:A, drs:D2-D3, ana:N1-N2, para:P1-P2, tree:Prep]),
  noun_phrase([arg:A, loc:L, fcn:tex, drs:D1-D3, sco:D2-D3, ana:N2-N3, para:P2-P3, tree:NP]).


noun_phrase([arg:A, loc:decl, fcn:tex, drs:D1-D2, sco:D4-D5, ana:N1-N3, para:P1-P3, tree:[np_124, TX]])
  -->
  temporal_expression([arg:A, drs:[drs([], [])|D1]-D2, res:[drs([], [])|D1]-[D3|D1], sco:S, ana:[]-N2, para:P1-P2, tree:TX]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:[D3], sco:D4-[], ana:N1-N2-N3, para:P1-P2-P3]) }.


noun_phrase([arg:A1, loc:cons, fcn:tex, drs:D1-D0, sco:D4-D5, ana:N1-N5, para:P1-P5, tree:[np_125, Det, Noun, Var]])
  -->
  determiner([arg:A1, fcn:O, qnt:def, drs:D1-_, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:[time, point], arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A1, ref:F, drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


noun_phrase([arg:A1, loc:cons, fcn:tex, drs:D1-D0, sco:D5-D6, ana:N1-N7, para:P1-P7, tree:[np_126, Det, Noun, Var, Op, Num]])
  -->
  determiner([arg:A1, fcn:O, qnt:def, drs:D1-_, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:[time, point], arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A1, ref:F, drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) },
  operator([wfm:[plus], arg:A2, arg:A3, drs:R2-D5, ana:N5-N6, para:P5-P6, tree:Op]),
  number([wfm:[1], arg:A3, drs:D1-R1, res:R1-R2, sco:_-_, ana:N6-N7, para:P6-P7, tree:Num]).


noun_phrase([arg:A1, loc:ante, fcn:tex, drs:D1-D0, sco:R3-S2, ana:N1-N4, para:P1-P4, tree:[np_127, Det, Noun, Var]])
  -->
  determiner([arg:A1, fcn:O, qnt:exist, drs:D1-_, res:D1-R3, sco:R3-S2, ana:N1-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:[time, point], arg:A, drs:D1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Var]).


% ------------------------------------------------------------------------
% Noun phrases (prepositional modifier)
%
% ------------------------------------------------------------------------

% the garden
noun_phrase([arg:A, loc:decl, fcn:pmod, drs:_-_, res:D1-D3, sco:_-_, ana:N1-N4, para:P1-P4, tree:[np_128, Det, Noun]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N3-N4, para:P1-P3-P4]) }.


% a garden
noun_phrase([arg:A, loc:decl, fcn:pmod, drs:D, res:R, sco:_-_, ana:N1-[N3|N1], para:P1-P3, tree:[np_129, Det, Noun]])
  -->
  determiner([arg:A, fcn:_, qnt:exist, drs:_, res:R, sco:_-_, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R, ana:N2-N3, para:P2-P3, tree:Noun]).


% the garden
noun_phrase([arg:A, loc:ante, fcn:pmod, drs:_-_, res:D1-D3, sco:_-_, ana:N1-N4, para:P1-P4, tree:[np_130, Det, Noun]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N3-N4, para:P1-P3-P4]) }.


% a garden
noun_phrase([arg:A, loc:ante, fcn:pmod, drs:D, res:R, sco:_-_, ana:N1-[N3|N1], para:P1-P3, tree:[np_131, Det, Noun]])
  -->
  determiner([arg:A, fcn:_, qnt:exist, drs:_, res:R, sco:_-_, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R, ana:N2-N3, para:P2-P3, tree:Noun]).


% the garden
noun_phrase([arg:A, loc:cons, fcn:pmod, drs:_-_, res:D1-D3, sco:_-_, ana:N1-N4, para:P1-P4, tree:[np_132, Det, Noun]])
  -->
  determiner([arg:A, fcn:_, qnt:def, ref:'+', drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, ref:'+', drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'+', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N3-N4, para:P1-P3-P4]) }.


% add name
noun_phrase([arg:A, loc:L, fcn:pmod, drs:_-_, res:D1-D3, sco:_-_, ana:N1-N3, para:P1-P3, tree:[np_118, MN]])
  -->
  mass_noun([arg:A, drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:MN]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) }.


% ------------------------------------------------------------------------
% Noun phrases (object position)
%
% ------------------------------------------------------------------------

% decl: ... the successful student who ...
%
noun_phrase([arg:A, loc:decl, fcn:dobj, qnt:def, drs:D1-D2, res:D1-R5, sco:R5-_, ana:N1-N6, para:P1-P6, tree:[np_133, Det, Adj, Noun, RC0]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:R3, sco:R4-[], ana:N1-N4-N5, para:P1-P4-P5]) },
  relative_clause_0([crd:'+', arg:A, loc:decl, drs:R4-R5, ana:N5-N6, para:P5-P6, tree:RC0]).


% ante: ... the successful student who ...
%
noun_phrase([arg:A, loc:ante, fcn:dobj, qnt:def, drs:D1-D2, res:D1-R5, sco:R5-_, ana:N1-N6, para:P1-P6, tree:[np_134, Det, Adj, Noun, RC0]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:R3, sco:R4-[], ana:N1-N4-N5, para:P1-P4-P5]) },
  relative_clause_0([crd:'+', arg:A, loc:ante, drs:R4-R5, ana:N5-N6, para:P5-P6, tree:RC0]).


% -----

% decl: ... a successful student who ...
%
noun_phrase([arg:A, loc:decl, fcn:dobj, qnt:exist, drs:D1-D2, res:D1-R4, sco:_, ana:N1-N5, para:P1-P5, tree:[np_136, Det, Adj, Noun, RC0]])
  -->
  determiner([arg:A, fcn:_, qnt:exist, drs:D, res:R1-R4, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  relative_clause_0([crd:'+', arg:A, loc:decl, drs:R3-R4, ana:[N4|N1]-N5, para:P4-P5, tree:RC0]).

  
% ante: ... a successful student who ...
%
noun_phrase([arg:A, loc:ante, fcn:dobj, qnt:exist, drs:D1-D2, res:D1-R4, sco:_, ana:N1-N5, para:P1-P5, tree:[np_137, Det, Adj, Noun, RC0]])
  -->
  determiner([arg:A, fcn:_, qnt:exist, drs:D, res:R1-R4, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  relative_clause_0([crd:'+', arg:A, loc:ante, drs:R3-R4, ana:[N4|N1]-N5, para:P4-P5, tree:RC0]).


% -----

% decl: ... the student who ...
%
noun_phrase([arg:A, loc:decl, fcn:dobj, qnt:def, drs:D1-D2, res:D1-R4, sco:_, ana:N1-N5, para:P1-P5, tree:[np_139, Det, Noun, RC0]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:R2, sco:R3-[], ana:N1-N3-N4, para:P1-P3-P4]) },
  relative_clause_0([crd:'+', arg:A, loc:decl, drs:R3-R4, ana:N4-N5, para:P4-P5, tree:RC0]).


% ante: ... the student who ...
%
noun_phrase([arg:A, loc:ante, fcn:dobj, qnt:def, drs:D1-D2, res:D1-R4, sco:_, ana:N1-N5, para:P1-P5, tree:[np_140, Det, Noun, RC0]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:R2, sco:R3-[], ana:N1-N3-N4, para:P1-P3-P4]) },
  relative_clause_0([crd:'+', arg:A, loc:ante, drs:R3-R4, ana:N4-N5, para:P4-P5, tree:RC0]).


% -----

% decl: ... a student who ...
%
noun_phrase([arg:A, loc:decl, fcn:dobj, qnt:exist, drs:D1-D2, res:D1-R3, sco:_, ana:N1-N4, para:P1-P4, tree:[np_142, Det, Noun, RC0]])
  -->
  determiner([arg:A, fcn:_, qnt:exist, drs:D1-D2, res:R1-R3, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  relative_clause_0([crd:'+', arg:A, loc:decl, drs:R2-R3, ana:[N3|N1]-N4, para:P3-P4, tree:RC0]).


% ante: ... a student who ...
%
noun_phrase([arg:A, loc:ante, fcn:dobj, qnt:exist, drs:D1-D2, res:D1-R3, sco:_, ana:N1-N4, para:P1-P4, tree:[np_143, Det, Noun, RC0]])
  -->
  determiner([arg:A, fcn:_, qnt:exist, drs:D1-D2, res:D1-R3, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:D1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  relative_clause_0([crd:'+', arg:A, loc:ante, drs:R2-R3, ana:[N3|N1]-N4, para:P3-P4, tree:RC0]).


% L: ... a student who ...
%
noun_phrase([arg:A, loc:L, fcn:dobj, qnt:exist, drs:D, sco:S, ana:N1-N4, para:P1-P4, tree:[np_144, Det, Noun, RC0]])
  -->
  determiner([arg:A, fcn:_, qnt:exist, drs:D, res:R1-R3, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  relative_clause_0([crd:'+', arg:A, loc:L, drs:R2-R3, ana:[N3|N1]-N4, para:P3-P4, tree:RC0]).


% -----

% decl: ... the parent of the child
%
noun_phrase([arg:A1, loc:decl, fcn:dobj, qnt:def, drs:D1-D6, res:D1-D5, sco:_, ana:N1-N6, para:P1-P6, tree:[np_145, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:decl, fcn:pobj, qnt:def, drs:D3-D4, sco:S2-S2, ana:N1-N4-N5, para:P4-P5, tree:NP]),  
  { anaphora_resolution([arg:A1, ref:'?', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P5-P6]) }.


% ante: ... the parent of the child
%
noun_phrase([arg:A1, loc:ante, fcn:dobj, qnt:def, drs:D1-D6, res:D1-D5, sco:_, ana:N1-N6, para:P1-P6, tree:[np_146, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:ante, fcn:pobj, qnt:def, drs:D3-D4, sco:S2-S2, ana:N1-N4-N5, para:P4-P5, tree:NP]),  
  { anaphora_resolution([arg:A1, ref:'?', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P5-P6]) }.


% cons: ... the parent of the child 
%
noun_phrase([arg:A1, loc:cons, fcn:dobj, qnt:def, drs:D1-D6, res:D1-D5, sco:_, ana:N1-N6, para:P1-P6, tree:[np_147, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:_, qnt:def, ref:'+', drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, ref:'+', drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, ref:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:cons, fcn:pobj, qnt:def, drs:D3-D4, sco:S2-S2, ana:N1-N4-N5, para:P4-P5, tree:NP]),  
  { anaphora_resolution([arg:A1, ref:'+', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P5-P6]) }.


% -----


% decl: ... the parent of a child
%
noun_phrase([arg:A1, loc:decl, fcn:dobj, qnt:def, drs:D, res:R1-R4, sco:_, ana:N1-[N5|N1], para:P1-P5, tree:[np_150, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:_, qnt:def, drs:D, res:R1-R4, sco:_, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:decl, fcn:pobj, qnt:exist, drs:R3-R4, sco:S2-S2, ana:N1-N4-N5, para:P4-P5, tree:NP]).


% ante: ... the parent of a child ...
%
noun_phrase([arg:A1, loc:ante, fcn:dobj, qnt:def, drs:D, res:R1-R4, sco:_, ana:N1-[N5|N1], para:P1-P5, tree:[np_151, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:_, qnt:def, drs:D, res:R1-R4, sco:_, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:ante, fcn:pobj, qnt:exist, drs:R3-R4, sco:S2-S2, ana:N1-N4-N5, para:P4-P5, tree:NP]).


% ---

% decl: ... the parent of the child ...
%
noun_phrase([arg:A1, loc:decl, fcn:dobj, qnt:def, drs:D, res:R1-R4, sco:_, ana:N1-[N5|N1], para:P1-P5, tree:[np_154, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:_, qnt:def, drs:D, res:R1-R4, sco:_, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:decl, fcn:pobj, qnt:def, drs:R3-R4, sco:S2-S2, ana:N1-N4-N5, para:P4-P5, tree:NP]).


% ante: ... the parent of the child
%
noun_phrase([arg:A1, loc:ante, fcn:dobj, qnt:def, drs:D, res:R1-R4, sco:_, ana:N1-[N5|N1], para:P1-P5, tree:[np_153, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:_, qnt:def, drs:D, res:R1-R4, sco:_, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:ante, fcn:pobj, qnt:def, drs:R3-R4, sco:S2-S2, ana:N1-N4-N5, para:P4-P5, tree:NP]).


% ---

% decl: ... a parent of a/the child ...
%
noun_phrase([arg:A1, loc:decl, fcn:dobj, qnt:exist, drs:D, res:R1-R4, sco:S1, ana:N1-[N5|N1], para:P1-P5, tree:[np_156, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:_, qnt:exist, drs:D, res:R1-R4, sco:S1, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:decl, fcn:pobj, qnt:Q2, drs:R3-R4, sco:S2-S2, ana:N1-N4-N5, para:P4-P5, tree:NP]).


% ante: ... a parent of a/the child ...
%
noun_phrase([arg:A1, loc:ante, fcn:dobj, qnt:exist, drs:D, res:R1-R4, sco:_, ana:N1-[N5|N1], para:P1-P5, tree:[np_155, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:_, qnt:exist, drs:D, res:R1-R4, sco:S1, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[of], arg:A1, arg:A2, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:ante, fcn:pobj, qnt:Q2, drs:R3-R4, sco:S2-S2, ana:N1-N4-N5, para:P4-P5, tree:NP]).


% -----

% decl: ... the successful student
%
noun_phrase([arg:A, loc:decl, fcn:dobj, qnt:def, drs:D1-D5, res:D1-D4, sco:_, ana:N1-N5, para:P1-P5, tree:[np_159, Det, Adj, Noun]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),                                      
  count_noun([wfm:WF, arg:A, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% ante: ... the successful student
%
noun_phrase([arg:A, loc:ante, fcn:dobj, qnt:def, drs:D1-D5, res:D1-D4, sco:_, ana:N1-N5, para:P1-P5, tree:[np_160, Det, Adj, Noun]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),                                      
  count_noun([wfm:WF, arg:A, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% cons: ... the successful student
%
noun_phrase([arg:A, loc:cons, fcn:dobj, qnt:def, drs:D1-D5, res:D1-D4, sco:_, ana:N1-N5, para:P1-P5, tree:[np_161, Det, Adj, Noun]])
  -->
  determiner([arg:A, fcn:_, qnt:def, ref:'+', drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, ref:'+', drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),                                      
  count_noun([wfm:WF, arg:A, ref:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'+', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% -----

% decl: ... a successful student
%
noun_phrase([arg:A, loc:decl, fcn:dobj, qnt:exist, drs:D, res:R1-R3, sco:_, ana:N1-[N4|N1], para:P1-P4, tree:[np_163, Det, Adj, Noun]])
  -->
  determiner([arg:A, fcn:_, qnt:exist, drs:D, res:R1-R3, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]).


% ante: ... a successful student
%
noun_phrase([arg:A, loc:ante, fcn:dobj, qnt:exist, drs:D, res:R1-R3, sco:_, ana:N1-[N4|N1], para:P1-P4, tree:[np_164, Det, Adj, Noun]])
  -->
  determiner([arg:A, fcn:_, qnt:exist, drs:D, res:R1-R3, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]).


% -----

% decl: ... the successful student X1 who ...
%
noun_phrase([arg:A, loc:decl, fcn:dobj, qnt:def, drs:D1-D7, res:D1-D6, sco:_, ana:N1-N7, para:P1-P7, tree:[np_166, Det, Adj, Noun, Var, RC0]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D3-D4, ana:N4-N5, para:P4-P5, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P4-P5]) }.
  relative_clause_0([crd:'+', arg:A, loc:decl, drs:D5-D6, ana:N6-N7, para:P6-P7, tree:RC0]).


% ante: ... the successful student X1 who ...
%
noun_phrase([arg:A, loc:ante, fcn:dobj, qnt:def, drs:D1-D7, res:D1-D6, sco:_, ana:N1-N7, para:P1-P7, tree:[np_167, Det, Adj, Noun, Var, RC0]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D3-D4, ana:N4-N5, para:P4-P5, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P4-P5]) }.
  relative_clause_0([crd:'+', arg:A, loc:ante, drs:D5-D6, ana:N6-N7, para:P6-P7, tree:RC0]).


% ---

% decl: ... a successful student X1 who ...
%
noun_phrase([arg:A, loc:decl, fcn:dobj, qnt:exist, drs:D, res:R1-R5, sco:_, ana:N1-N6, para:P1-P6, tree:[np_169, Det, Adj, Noun, Var, RC0]])
  -->
  determiner([arg:A, fcn:_, qnt:exist, drs:D, res:R1-R5, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', drs:R3-R4, ana:N4-N5, para:P4-P5, tree:Var]),
  relative_clause_0([crd:'+', arg:A, loc:decl, drs:R4-R5, ana:[N5|N1]-N6, para:P5-P6, tree:RC0]).


% ante: ... a successful student X1 who ...
%
noun_phrase([arg:A, loc:ante, fcn:dobj, qnt:exist, drs:D, res:R1-R5, sco:_, ana:N1-N6, para:P1-P6, tree:[np_170, Det, Adj, Noun, Var, RC0]])
  -->
  determiner([arg:A, fcn:_, qnt:exist, drs:D, res:R1-R5, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', drs:R3-R4, ana:N4-N5, para:P4-P5, tree:Var]),
  relative_clause_0([crd:'+', arg:A, loc:ante, drs:R4-R5, ana:[N5|N1]-N6, para:P5-P6, tree:RC0]).


% -----

% decl: ... the successful student X1
%
noun_phrase([arg:A, loc:decl, fcn:dobj, qnt:def, drs:D1-D6, res:D1-D5, sco:_, ana:N1-N6, para:P1-P6, tree:[np_172, Det, Adj, Noun, Var]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D3-D4, ana:N4-N5, para:P4-P5, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P5-P6]) }.


% ante: ... the successful student X1
%
noun_phrase([arg:A, loc:ante, fcn:dobj, qnt:def, drs:D1-D6, res:D1-D5, sco:_, ana:N1-N6, para:P1-P6, tree:[np_173, Det, Adj, Noun, Var]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D3-D4, ana:N4-N5, para:P4-P5, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P5-P6]) }.


% cons: ... the successful student X1
%
noun_phrase([arg:A, loc:cons, fcn:dobj, qnt:def, drs:D1-D6, res:D1-D5, sco:_, ana:N1-N6, para:P1-P6, tree:[np_174, Det, Adj, Noun, Var]])
  -->
  determiner([arg:A, fcn:_, qnt:def, ref:'+', drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, ref:'+', drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, ref:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', ref:'+', drs:D3-D4, ana:N4-N5, para:P4-P5, tree:Var]),
  { anaphora_resolution([arg:A, ref:'+', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P5-P6]) }.


% -----

% decl: ... a successful student X1
%
noun_phrase([arg:A, loc:decl, fcn:dobj, qnt:exist, drs:D, res:R1-R4, sco:_, ana:N1-[N5|N1], para:P1-P5, tree:[np_176, Det, Adj, Noun, Var]])
  -->
  determiner([arg:A, fcn:_, qnt:exist, drs:D, res:R1-R4, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', drs:R3-R4, ana:N4-N5, para:P4-P5, tree:Var]).


% ante: ... a successful student X1
%
noun_phrase([arg:A, loc:ante, fcn:dobj, qnt:exist, drs:D, res:R1-R4, sco:_, ana:N1-[N5|N1], para:P1-P5, tree:[np_177, Det, Adj, Noun, Var]])
  -->
  determiner([arg:A, fcn:_, qnt:exist, drs:D, res:R1-R4, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  string_variable([arg:A, app:'+', drs:R3-R4, ana:N4-N5, para:P4-P5, tree:Var]).


% -----

% decl: ... the student X1 who ...
%
noun_phrase([arg:A, loc:decl, fcn:dobj, qnt:def, drs:D1-D5, res:D1-D5, sco:_, ana:N1-N6, para:P1-P6, tree:[np_179, Det, Noun, Var, RC0]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) },
  relative_clause_0([crd:'+', arg:A, loc:decl, drs:D4-D5, ana:N5-N6, para:P5-P6, tree:RC0]).


% ante: ... the student X1 who ...
%
noun_phrase([arg:A, loc:ante, fcn:dobj, qnt:def, drs:D1-D6, res:D1-D5, sco:_, ana:N1-N6, para:P1-P6, tree:[np_180, Det, Noun, Var, RC0]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) },
  relative_clause_0([crd:'+', arg:A, loc:ante, drs:D4-D5, ana:N5-N6, para:P5-P6, tree:RC0]).


% ----

% decl: ... a student X1 who ...
%
noun_phrase([arg:A, loc:decl, fcn:dobj, qnt:exist, drs:D, res:R1-R4, sco:_, ana:N1-N5, para:P1-P5, tree:[np_182, Det, Noun, Var, RC0]])
  -->
  determiner([arg:A, fcn:O, qnt:exist, drs:D, res:R1-R4, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Var]),
  relative_clause_0([crd:'+', arg:A, loc:decl, drs:R3-R4, ana:[N4|N1]-N5, para:P4-P5, tree:RC0]).


% ante: ... a student X1 who ...
%
noun_phrase([arg:A, loc:ante, fcn:dobj, qnt:exist, drs:D, res:R1-R4, sco:_, ana:N1-N5, para:P1-P5, tree:[np_183, Det, Noun, Var, RC0]])
  -->
  determiner([arg:A, fcn:_, qnt:exist, drs:D, res:R1-R4, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Var]),
  relative_clause_0([crd:'+', arg:A, loc:ante, drs:R3-R4, ana:[N4|N1]-N5, para:P4-P5, tree:RC0]).


% -----

% decl: ... the student X1
%
noun_phrase([arg:A, loc:decl, fcn:dobj, qnt:def, drs:D1-D5, res:D1-D4, sco:_, ana:N1-N5, para:P1-P5, tree:[np_185, Det, Noun, Var]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% ante: ... the student X1
%
noun_phrase([arg:A, loc:ante, fcn:dobj, qnt:def, drs:D1-D5, res:D1-D4, sco:_, ana:N1-N5, para:P1-P5, tree:[np_186, Det, Noun, Var]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% cons: ... the student X1
%
noun_phrase([arg:A, loc:cons, fcn:dobj, qnt:def, drs:D1-D5, res:D1-D4, sco:_, ana:N1-N5, para:P1-P5, tree:[np_187, Det, Noun, Var]])
  -->
  determiner([arg:A, fcn:_, qnt:def, ref:'+', drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, ref:'+', drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', ref:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% -----

% decl: ... a student X1
%
noun_phrase([arg:A, loc:decl, fcn:dobj, qnt:exist, drs:D, res:R1-R3, sco:_, ana:N1-[N4|N1], para:P1-P4, tree:[np_189, Det, Noun, Var]])
  -->
  determiner([arg:A, fcn:_, qnt:exist, drs:D, res:R1-R3, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Var]).


% ante: ... a student X1
%
noun_phrase([arg:A, loc:ante, fcn:dobj, qnt:exist, drs:D, res:R1-R3, sco:_, ana:N1-[N4|N1], para:P1-P4, tree:[np_190, Det, Noun, Var]])
  -->
  determiner([arg:A, fcn:_, qnt:exist, drs:D, res:R1-R3, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  string_variable([arg:A, app:'+', drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Var]).


% -----

% decl: ... the successful student N1 who ...
%
noun_phrase([arg:A1, loc:decl, fcn:dobj, qnt:def, drs:D1-D7, res:D1-D6, sco:_, ana:N1-N7, para:P1-P7, tree:[np_192, Det, Adj, Noun, Var, RC0]])
  -->
  determiner([arg:A1, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A1, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:D3-D4, ana:N4-N5, para:P4-P5, tree:Var]),
  { anaphora_resolution([arg:A1, ref:'?', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P4-P5]) },
  relative_clause_0([crd:'+', arg:A2, loc:decl, drs:D5-D6, ana:N6-N7, para:P6-P7, tree:RC0]).


% ante: ... the successful student N1 who ...
%
noun_phrase([arg:A1, loc:ante, fcn:dobj, qnt:def, drs:D1-D7, res:D1-D6, sco:_, ana:N1-N7, para:P1-P7, tree:[np_193, Det, Adj, Noun, Var, RC0]])
  -->
  determiner([arg:A1, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A1, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:D3-D4, ana:N4-N5, para:P4-P5, tree:Var]),
  { anaphora_resolution([arg:A1, ref:'?', drs:D1-[], ant:D4, sco:D5-[], ana:N1-N5-N6, para:P1-P4-P5]) },
  relative_clause_0([crd:'+', arg:A2, loc:ante, drs:D5-D6, ana:N6-N7, para:P6-P7, tree:RC0]).


% -----

% decl: ... a successful student N1 who ...
%
noun_phrase([arg:A1, loc:decl, fcn:dobj, qnt:exist, drs:D, res:R1-R5, sco:_, ana:N1-N6, para:P1-P6, tree:[np_195, Det, Adj, Noun, Var, RC0]])
  -->
  determiner([arg:A1, fcn:_, qnt:exist, drs:D, res:R1-R5, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A1, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:R3-R4, ana:N4-N5, para:P4-P5, tree:Var]),
  relative_clause_0([crd:'+', arg:A2, loc:decl, drs:R4-R5, ana:[N5|N1]-N6, para:P5-P6, tree:RC0]).


% decl: ... a successful student N1 who ...
%
noun_phrase([arg:A1, loc:ante, fcn:dobj, qnt:exist, drs:D, res:R1-R5, sco:_, ana:N1-N6, para:P1-P6, tree:[np_195, Det, Adj, Noun, Var, RC0]])
  -->
  determiner([arg:A1, fcn:_, qnt:exist, drs:D, res:R1-R5, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  adjective([arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Adj]),
  count_noun([wfm:WF, arg:A1, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:R3-R4, ana:N4-N5, para:P4-P5, tree:Var]),
  relative_clause_0([crd:'+', arg:A2, loc:ante, drs:R4-R5, ana:[N5|N1]-N6, para:P5-P6, tree:RC0]).


% -----


% decl: ... the student N1 who ...
%
noun_phrase([arg:A1, loc:decl, fcn:dobj, qnt:def, drs:D1-D6, res:D1-D5, sco:_, ana:N1-N6, para:P1-P6, tree:[np_198, Det, Noun, Var, RC0]])
  -->
  determiner([arg:A1, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A1, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) },
  relative_clause_0([crd:'+', arg:A2, loc:decl, drs:D4-D5, ana:N5-N6, para:P5-P6, tree:RC0]).


% ante: ... the student N1 who ...
%
noun_phrase([arg:A1, loc:ante, fcn:dobj, qnt:def, drs:D1-D6, res:D1-D5, sco:_, ana:N1-N6, para:P1-P6, tree:[np_197, Det, Noun, Var, RC0]])
  -->
  determiner([arg:A1, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A1, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) },
  relative_clause_0([crd:'+', arg:A2, loc:ante, drs:D4-D5, ana:N5-N6, para:P5-P6, tree:RC0]).


% ---

% decl: ... a student N1 who ...
%
noun_phrase([arg:A1, loc:decl, fcn:dobj, qnt:exist, drs:D, res:R1-R4, sco:_, ana:N1-N5, para:P1-P5, tree:[np_201, Det, Noun, Var, RC0]])
  -->
  determiner([arg:A1, fcn:_, qnt:exist, drs:D, res:R1-R4, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Var]),
  relative_clause_0([crd:'+', arg:A2, loc:decl, drs:R3-R4, ana:[N4|N1]-N5, para:P4-P5, tree:RC0]).


% ante: ... a student N1 who ...
%
noun_phrase([arg:A1, loc:ante, fcn:dobj, qnt:exist, drs:D, res:R1-R4, sco:_, ana:N1-N5, para:P1-P5, tree:[np_200, Det, Noun, Var, RC0]])
  -->
  determiner([arg:A1, fcn:_, qnt:exist, drs:D, res:R1-R4, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Var]),
  relative_clause_0([crd:'+', arg:A2, loc:ante, drs:R3-R4, ana:[N4|N1]-N5, para:P4-P5, tree:RC0]).


% -----

% decl: ... the student N1
%
noun_phrase([arg:A1, loc:decl, fcn:dobj, qnt:def, drs:D1-D5, res:D1-D4, sco:_, ana:N1-N5, para:P1-P5, tree:[np_203, Det, Noun, Var]])
  -->
  determiner([arg:A1, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A1, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% ante: ... the student N1
%
noun_phrase([arg:A1, loc:ante, fcn:dobj, qnt:def, drs:D1-D5, res:D1-D4, sco:_, ana:N1-N5, para:P1-P5, tree:[np_204, Det, Noun, Var]])
  -->
  determiner([arg:A1, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A1, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% cons: ... the student N1 ...
%
noun_phrase([arg:A1, loc:cons, fcn:dobj, qnt:def, drs:D1-D5, res:D1-D4, sco:_, ana:N1-N5, para:P1-P5, tree:[np_205, Det, Noun, Var]])
  -->
  determiner([arg:A1, fcn:_, qnt:def, ref:'+', drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, ref:'+', drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', ref:'+',  drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Var]),
  { anaphora_resolution([arg:A1, ref:'+', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% -----

% decl: ... a student N1
%
noun_phrase([arg:A1, loc:decl, fcn:dobj, qnt:exist, drs:D, res:R1-R3, sco:_, ana:N1-[N4|N1], para:P1-P4, tree:[np_207, Det, Noun, Var]])
  -->
  determiner([arg:A1, fcn:_, qnt:exist, drs:D, res:R1-R3, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Var]).


% ante: ... a student N1 
%
noun_phrase([arg:A1, loc:ante, fcn:dobj, qnt:exist, drs:D, res:R1-R3, sco:_, ana:N1-[N4|N1], para:P1-P4, tree:[np_208, Det, Noun, Var]])
  -->
  determiner([arg:A1, fcn:_, qnt:exist, drs:D, res:R1-R3, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  numeric_variable([arg:A1, arg:A2, app:'+', drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Var]).


% -----

% decl: ... the student 
%
noun_phrase([arg:A1, loc:decl, fcn:dobj, qnt:def, drs:D1-D4, res:D1-D3, sco:_, ana:N1-N4, para:P1-P4, tree:[np_210, Det, Noun]])
  -->
  determiner([arg:A1, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  { anaphora_resolution([arg:A1, ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N3-N4, para:P1-P3-P4]) }.


% ante: ... the student 
%
noun_phrase([arg:A1, loc:ante, fcn:dobj, qnt:def, drs:D1-D4, res:D1-D3, sco:_, ana:N1-N4, para:P1-P4, tree:[np_211, Det, Noun]])
  -->
  determiner([arg:A1, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  { anaphora_resolution([arg:A1, ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N3-N4, para:P1-P3-P4]) }.


% cons: ... the student 
%
noun_phrase([arg:A1, loc:cons, fcn:dobj, qnt:def, drs:D1-D4, res:D1-D3, sco:_, ana:N1-N4, para:P1-P4, tree:[np_212, Det, Noun]])
-->
  determiner([arg:A1, fcn:_, qnt:def, ref:'+', drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1,  ref:'+', drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Noun]),
  { anaphora_resolution([arg:A1, ref:'+', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N3-N4, para:P1-P3-P4]) }.


% -----

% decl: ... a student 
%
noun_phrase([arg:A, loc:decl, fcn:dobj, qnt:exist, drs:D, res:R, sco:_, ana:N1-[N3|N1], para:P1-P3, tree:[np_214, Det, Noun]])
  -->
  determiner([arg:A, fcn:_, qnt:exist, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R, ana:N2-N3, para:P2-P3, tree:Noun]).


% ante: ... a student 
%
noun_phrase([arg:A, loc:ante, fcn:dobj, qnt:exist, drs:D, res:R, sco:_, ana:N1-[N3|N1], para:P1-P3, tree:[np_215, Det, Noun]])
  -->
  determiner([arg:A, fcn:_, qnt:exist, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A, drs:R, ana:N2-N3, para:P2-P3, tree:Noun]).


% -----  MERGE!

% Number
%

% Exclude that Dominique is allocated to a position that is greater than or equal to 3.
%
noun_phrase([arg:[num:_, ind:I], loc:L, fcn:dobj, qnt:Q, drs:D, sco:S1-S2, ana:N1-N1, para:P1-P2, tree:[np_217, Number]])
  -->
  number([arg:[num:_, ind:I], drs:D, res:R-S1, sco:S1-S2, ana:_-_, para:P1-P2, tree:Number]).


% -----
% Ordinal

% decl: ... the first student 
%
noun_phrase([arg:A, loc:decl, fcn:dobj, qnt:def, drs:D1-D5, res:D1-D4, sco:_, ana:N1-N5, para:P1-P5, tree:[np_219, Det, Ord, Noun]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  ordinal([arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Ord]),                                      
  count_noun([wfm:WF, arg:A, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% ante: ... the first student 
%
noun_phrase([arg:A, loc:ante, fcn:dobj, qnt:def, drs:D1-D5, res:D1-D4, sco:_, ana:N1-N5, para:P1-P5, tree:[np_218, Det, Ord, Noun]])
  -->
  determiner([arg:A, fcn:_, qnt:def, drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  ordinal([arg:A, drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Ord]),                                      
  count_noun([wfm:WF, arg:A, drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% cons: ... the first student 
%
noun_phrase([arg:A, loc:cons, fcn:dobj, qnt:def, drs:D1-D5, res:D1-D4, sco:_, ana:N1-N5, para:P1-P5, tree:[np_220, Det, Ord, Noun]])
  -->
  determiner([arg:A, fcn:_, qnt:def, ref:'+',  drs:D, res:R, sco:S, ana:[]-N2, para:P1-P2, tree:Det]),
  ordinal([arg:A, ref:'+', drs:[drs([], [])]-D2, ana:N2-N3, para:P2-P3, tree:Ord]),                                      
  count_noun([wfm:WF, arg:A, ref:'+', drs:D2-D3, ana:N3-N4, para:P3-P4, tree:Noun]),
  { anaphora_resolution([arg:A, ref:'+', drs:D1-[], ant:D3, sco:D4-[], ana:N1-N4-N5, para:P1-P4-P5]) }.


% -----

% decl: ... John who ...
%
noun_phrase([arg:A, loc:decl, fcn:dobj, qnt:_, drs:D1-D5, res:D1-D4, sco:_, ana:N1-N4, para:P1-P4, tree:[np_221, Name, RC0]])
  -->
  name([arg:A, drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  relative_clause_0([crd:'+', arg:A, loc:decl, drs:D3-D4, ana:N3-N4, para:P3-P4, tree:RC0]).


% ante: ... John who ...
%
noun_phrase([arg:A, loc:ante, fcn:dobj, qnt:_, drs:D1-D5, res:D1-D4, sco:_, ana:N1-N4, para:P1-P4, tree:[np_222, Name, RC0]])
  -->
  name([arg:A, drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  relative_clause_0([crd:'+', arg:A, loc:ante, drs:D3-D4, ana:N3-N4, para:P3-P4, tree:RC0]).


% -----

% decl: ... John
%
noun_phrase([arg:A, loc:decl, fcn:dobj, qnt:_, drs:D1-D4, res:D1-D3, sco:_, ana:N1-N3, para:P1-P3, tree:[np_224, Name]])
  -->
  name([arg:A, drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) }.


% ante: ... John
%
noun_phrase([arg:A, loc:ante, fcn:dobj, qnt:_, drs:D1-D4, res:D1-D3, sco:_, ana:N1-N3, para:P1-P3, tree:[np_225, Name]])
  -->
  name([arg:A, drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) }.


% cons: ... John
%
noun_phrase([arg:A, loc:cons, fcn:dobj, qnt:_, drs:D1-D4, res:D1-D3, sco:_, ana:N1-N3, para:P1-P3, tree:[np_226, Name]])
  -->
  name([arg:A, drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) }.


% -----

% L: ... water
%
noun_phrase([arg:A, loc:L, fcn:dobj, qnt:_, drs:D1-D4, res:D1-D3, sco:_, ana:N1-N3, para:P1-P3, tree:[np_228, MN]])
  -->
  mass_noun([arg:A, drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:MN]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) }.


% -----

% decl: ... X1 that ...
%
noun_phrase([arg:A, loc:decl, fcn:dobj, qnt:_, drs:D1-D5, res:D1-D4, sco:_, ana:N1-N4, para:P1-P4, tree:[np_230, Var, RC0]])
  -->
  string_variable([arg:A, app:'-', drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Var]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  relative_clause_0([crd:'+', arg:A, loc:decl, drs:D3-D4, ana:N3-N4, para:P3-P4, tree:RC0]).


% ante: ... X1 that ...
%
noun_phrase([arg:A, loc:ante, fcn:dobj, qnt:_, drs:D1-D5, res:D1-D4, sco:_, ana:N1-N4, para:P1-P4, tree:[np_231, Var, RC0]])
  -->
  string_variable([arg:A, app:'-', drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Var]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  relative_clause_0([crd:'+', arg:A, loc:ante, drs:D3-D4, ana:N3-N4, para:P3-P4, tree:RC0]).


% -----

% decl: ... X1
%
noun_phrase([arg:A, loc:decl, fcn:dobj, qnt:_, drs:D1-D4, res:D1-D3, sco:_, ana:N1-N3, para:P1-P3, tree:[np_232, Var]])
  -->
  string_variable([arg:A, app:'-', drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) }.


% ante: ... X1
%
noun_phrase([arg:A, loc:ante, fcn:dobj, qnt:_, drs:D1-D4, res:D1-D3, sco:_, ana:N1-N3, para:P1-P3, tree:[np_233, Var]])
  -->
  string_variable([arg:A, app:'-', drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) }.


% cons: ... X1
%
noun_phrase([arg:A, loc:cons, fcn:dobj, qnt:_, drs:D1-D4, res:D1-D3, sco:_, ana:N1-N3, para:P1-P3, tree:[np_234, Var]])
  -->
  string_variable([arg:A, app:'-', drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Var]),
  { anaphora_resolution([arg:A, ref:'?', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) }.


% ------------------------------------------------------------------------
% Cardinal noun phrases
%
% ------------------------------------------------------------------------

% [Every person] holds exactly two jobs.
%

noun_phrase([arg:A, loc:cons, fcn:dobj, qnt:card, drs:D, res:R1-R3, sco:_, ana:N1-N1, para:P1-P3, tree:[np_236, Card, Noun]])
  -->
  cardinal([arg:A, drs:D, res:R1-R2, sco:R3-S, ana:_-_, para:P1-P2, tree:Card]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:_-_, para:P2-P3, tree:Noun]).


% [Every person] holds exactly two jobs that ...
%
noun_phrase([arg:A, loc:cons, fcn:dobj, qnt:card, drs:D, res:R1-R4, sco:_, ana:N1-N1, para:P1-P4, tree:[np_237, Card, Noun, RC]])
  -->
  cardinal([arg:A, drs:D, res:R1-R2, sco:R4-S, ana:_-_, para:P1-P2, tree:Card]),
  count_noun([wfm:WF, arg:A, drs:R2-R3, ana:_-_, para:P2-P3, tree:Noun]),
  relative_clause_0([crd:_, arg:A, loc:cons, drs:R3-R4, ana:N1-N5, para:P3-P4, tree:RC]).


% ------------------------------------------------------------------------
%  Verb phrase (copula)
%  [Every runner] is allocated to exactly one position.
%  [Every runner] is allocate to NP.
% ------------------------------------------------------------------------

verb_phrase([crd:'-', arg:A1, loc:cons, drs:D, ana:N1-N1, para:P1-P5, tree:[vp_139, Cop, RAdj, Card, Noun]])
  -->
  copula([wfm:WF1, arg:A1, vform:V, evtl:E, drs:S1-S2, ana:N1-N2, para:P1-P2, tree:Cop]),
  relational_adjective([evtl:E, arg:A2, con:C, drs:S2-S3, ana:N2-N3, para:P2-P3, tree:RAdj]),
  cardinal([arg:A2, drs:D, res:R1-R2, sco:S1-S3, ana:N3-N4, para:P3-P4, tree:Card]),
  count_noun([wfm:WF2, arg:A2, drs:R2-S1, ana:N4-N5, para:P4-P5, tree:Noun]).


% ------------------------------------------------------------------------
%  Verb phrase (copula)
%  [...] is before [...]
% ------------------------------------------------------------------------

verb_phrase([crd:'-', arg:[num:sg, ind:I], loc:ante, drs:D, ana:N1-N3, para:P1-P3, tree:[vp_140, Cop, PP]])
  -->
  copula([wfm:WF, arg:[num:sg, ind:I], vform:V, evtl:E, drs:S, ana:N1-N2, para:P1-P2, tree:Cop]),
  prepositional_phrase([wfm:_, loc:ante, fcn:dobj, evtl:E, drs:D, sco:S, ana:N2-N3, para:P2-P3, tree:PP]).


verb_phrase([crd:'-', arg:[num:sg, ind:I], loc:cons, drs:D, ana:N1-N3, para:P1-P3, tree:[vp_141, Cop, PP]])
  -->
  copula([wfm:WF, arg:[num:sg, ind:I], vform:V, evtl:E, drs:S, ana:N1-N2, para:P1-P2, tree:Cop]),
  prepositional_phrase([wfm:_, loc:cons, fcn:dobj, evtl:E, drs:D, sco:S, ana:N2-N3, para:P2-P3, tree:PP]).


% Carefully check before deleting this one.
% verb_phrase([crd:'-', arg:[num:sg, ind:I], loc:decl, drs:D, ana:N1-N3, para:P1-P3, tree:[vp_39, Cop, PP]])
%  -->
%  copula([wfm:WF, arg:[num:sg, ind:I], vform:V, evtl:E, drs:S, ana:N1-N2, para:P1-P2, tree:Cop]),
%  prepositional_phrase([wfm:_, loc:decl, fcn:dobj, evtl:E, drs:D, sco:S, ana:N2-N3, para:P2-P3, tree:PP]).


verb_phrase([crd:'-', arg:[num:sg, ind:I], loc:decl, drs:D1-S3, ana:N1-N3, para:P1-P3, tree:[vp_142, Cop, PP]])
  -->
  copula([wfm:WF, arg:[num:sg, ind:I], vform:V, evtl:E, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:Cop]),
  prepositional_phrase([wfm:_, loc:decl, fcn:pmod, evtl:E, drs:D1-_S3, sco:S1-S2, ana:N2-N3, para:P2-P3, tree:PP]).


% ---------------------------------------

verb_phrase([crd:'-', arg:A1, loc:L, drs:[drs(U1, C1)|D1]-[drs(U2, [neg D3|C2])|D2], ana:N1-N5, para:P1-P5, tree:[vp_143, Cop, Neg, Adj, PP]])
  -->
  copula([wfm:WF1, arg:A1, vform:V, evtl:E, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:Cop]),
  negation([wfm:[not], ana:N2-N3, para:P2-P3, tree:Neg]),
  adjective([evtl:E, con:C, drs:S3-[D3, drs(U2, C2)|D2], ana:N3-N4,  para:P3-P4, tree:Adj]),
  prepositional_phrase([wfm:[at], loc:L, fcn:mod, evtl:E, drs:[drs([], []), drs(U1, C1)|D1]-S1, sco:S1-S2, ana:N4-N5, para:P4-P5, tree:PP]).


% ---------------------------------------

verb_phrase_x([arg:A1, vform:V, evtl:E, loc:L, drs:D1-D3, ana:N1-N3, para:P1-P3, tree:[vp_144, Cop, Adj]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:D1-D2, ana:N1-N2, para:P1-P2, tree:Cop]),
  adjective([evtl:E, con:C, drs:D2-D3, ana:N2-N3, para:P2-P3, tree:Adj]).


verb_phrase_x([arg:A1, vform:V, evtl:E, loc:cons, drs:D1-D3, ana:N1-N3, para:P1-P3, tree:[vp_145, Cop, Adj]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:D1-D2, ana:N1-N2, para:P1-P2, tree:Cop]),
  adjective([evtl:E, con:C, drs:D2-D3, ana:N2-N3, para:P2-P3, tree:Adj]).


% ----


% [Every,person,who,holds,a,job,as,chef,is,a,chef,.]
%  Experimental


verb_phrase([arg:[num:sg, ind:I], vform:V, evtl:E, loc:decl, drs:D1-D3, res:D1-D2, sco:S, ana:N1-N3, para:P1-P3, tree:[vp_146, TV, NP]])
  -->
  transitive_verb([wfm:WF, arg:[num:sg, ind:I], arg:A2, vform:V, evtl:E, con:C, drs:S, ana:N1-N2, para:P1-P2, tree:TV]),
  noun_phrase([arg:A2, loc:decl, fcn:obj_as, qnt:_, drs:D1-D3, res:D1-D2, sco:_-_, ana:N2-N3, para:P2-P3, tree:NP]).


verb_phrase([arg:[num:sg, ind:I], vform:V, evtl:E, loc:ante, drs:D1-D3, res:D1-D2, sco:S, ana:N1-N3, para:P1-P3, tree:[vp_147, TV, NP]])
  -->
  transitive_verb([wfm:WF, arg:[num:sg, ind:I], arg:A2, vform:V, evtl:E, con:C, drs:S, ana:N1-N2, para:P1-P2, tree:TV]),
  noun_phrase([arg:A2, loc:ante, fcn:obj_as, qnt:_, drs:D1-D3, res:D1-D2, sco:_-_, ana:N2-N3, para:P2-P3, tree:NP]).


verb_phrase([arg:[num:sg, ind:I], vform:V, evtl:E, loc:cons, drs:D1-D3, res:D1-D2, sco:S, ana:N1-N3, para:P1-P3, tree:[vp_148, TV, NP]])
  -->
  transitive_verb([wfm:WF, arg:[num:sg, ind:I], arg:A2, vform:V, evtl:E, con:C, drs:S, ana:N1-N2, para:P1-P2, tree:TV]),
  noun_phrase([arg:A2, loc:cons, fcn:obj_as, qnt:_, drs:D1-D3, res:D1-D2, sco:_-_, ana:N2-N3, para:P2-P3, tree:NP]).


verb_phrase([arg:[num:pl, ind:I], vform:V, evtl:E, loc:decl, drs:D1-D3, res:D1-D2, sco:S, ana:N1-N3, para:P1-P3, tree:[vp_149, TV, NP]])
  -->
  transitive_verb([wfm:WF, arg:[num:pl, ind:I], arg:A2, vform:V, evtl:E, con:C, drs:S, ana:N1-N2, para:[['&lt;/ins&gt;'], [each], ['&lt;ins&gt;']|P1]-P2, tree:TV]),
  noun_phrase([arg:A2, loc:decl, fcn:obj_as, qnt:_, drs:D1-D3, res:D1-D2, sco:_-_, ana:N2-N3, para:P2-P3, tree:NP]).


verb_phrase([arg:[num:pl, ind:I], vform:V, evtl:E, loc:ante, drs:D1-D3, res:D1-D2, sco:S, ana:N1-N3, para:P1-P3, tree:[vp_150, TV, NP]])
  -->
  transitive_verb([wfm:WF, arg:[num:pl, ind:I], arg:A2, vform:V, evtl:E, con:C, drs:S, ana:N1-N2, para:[['&lt;/ins&gt;'], [each], ['&lt;ins&gt;']|P1]-P2, tree:TV]),
  noun_phrase([arg:A2, loc:ante, fcn:obj_as, qnt:_, drs:D1-D3, res:D1-D2, sco:_-_, ana:N2-N3, para:P2-P3, tree:NP]).


noun_phrase([arg:A1, loc:decl, fcn:obj_as, qnt:exist, drs:D, res:R1-R4, sco:_, ana:N1-[N5|N1], para:P1-P5, tree:[np_240, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:_, qnt:exist, drs:D, res:R1-R4, sco:S1, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[as], arg:A1, arg:A2, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:decl, fcn:pobj_as, qnt:Q2, drs:R3-R4, sco:S2-S2, ana:N1-N4-N5, para:P4-P5, tree:NP]).


noun_phrase([arg:A1, loc:ante, fcn:obj_as, qnt:exist, drs:D, res:R1-R4, sco:_, ana:N1-[N5|N1], para:P1-P5, tree:[np_241, Det, Noun, Prep, NP]])
  -->
  determiner([arg:A1, fcn:_, qnt:exist, drs:D, res:R1-R4, sco:S1, ana:[]-N2, para:P1-P2, tree:Det]),
  count_noun([wfm:WF, arg:A1, drs:R1-R2, ana:N2-N3, para:P2-P3, tree:Noun]),
  preposition([wfm:[as], arg:A1, arg:A2, drs:R2-R3, ana:N3-N4, para:P3-P4, tree:Prep]),
  noun_phrase([arg:A2, loc:ante, fcn:pobj_as, qnt:Q2, drs:R3-R4, sco:S2-S2, ana:N1-N4-N5, para:P4-P5, tree:NP]).


noun_phrase([arg:A, loc:L, fcn:pobj_as, qnt:def, drs:D1-D4, sco:D3-D4, ana:N0-N1-N3, para:P1-P3, tree:[np_242, Name]])
  -->
  name([arg:A, drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Name]),
  { anaphora_resolution([arg:A, ref:F, drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) }.


% ------------------------------------------------------------------------
% Prepositional phrase
% ------------------------------------------------------------------------

prepositional_phrase([wfm:WF, loc:L, fcn:dobj, evtl:E, drs:D, sco:S1-S2, ana:N1-N3, para:P1-P3, tree:[pp_1, Prep, NP]])
  -->
  preposition([wfm:WF, evtl:E, arg:A, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:Prep]),
  noun_phrase([arg:A, loc:L, fcn:dobj, qnt:def, drs:D, sco:S1-S3, ana:N2-N3, para:P2-P3, tree:NP]).


prepositional_phrase([wfm:WF, loc:L, fcn:dobj, evtl:E, drs:D, sco:S1-S2, ana:N1-N3, para:P1-P3, tree:[pp_2, Prep, NP]])
  -->
  preposition([wfm:WF, evtl:E, arg:A, drs:S2-S3, ana:N1-N2, para:P1-P2, tree:Prep]),
  noun_phrase([arg:A, loc:L, fcn:dobj, qnt:exist, drs:D, sco:S1-S3, ana:N2-N3, para:P2-P3, tree:NP]).


% ------------------------------------------------------------------------
% Adjective
% ------------------------------------------------------------------------

adjective([wfm:WF, 
           ana:N-N, 
           para:P1-[WF|P1], 
           tree:[adj_1, WF]]) -->
  { lexicon([cat:adjective, wfm:WF]) }, 
  WF.


adjective([arg:[num:_, ind:I],
           drs:[drs(U1, C1)|D2]-[drs(U1, [C2|C1])|D2],
           ana:N1-[adjective(WF)|N1],
	   para:P1-[WF|P1],
           tree:[adj_2, WF]])
  -->
  { lexicon([cat:adjective, wfm:WF, evtl:I, con:C2]) }, 
  WF.


adjective([arg:[num:_, ind:I],
	   ref:'+',
           drs:[drs(U1, C1)|D2]-[drs(U1, [C2|C1])|D2],
           ana:N1-[WF|N1],
	   para:P1-[WF|P1],
           tree:[adj_3, WF]])
  -->
  { lexicon([cat:adjective, wfm:WF, ref:'+', snum:_, spos:_, evtl:I, con:C2]) }, 
  WF.



adjective([evtl:E,
           con:C2,
           drs:[drs(U1, C1)|D2]-[drs(U1, [C2|C1])|D2],
           ana:N-N,
	   para:P1-[WF|P1],
           tree:[adj_4, WF]])
  -->
  { lexicon([cat:adjective, wfm:WF, evtl:E, con:C2]) }, 
  WF.


% ------------------------------------------------------------------------
% Constraint
% ------------------------------------------------------------------------

constraint([wfm:WF, ana:N-N, para:P1-[WF|P1], tree:[cstr, WF]])
  -->
  { lexicon([cat:constraint, wfm:WF]) }, 
  WF.


% ------------------------------------------------------------------------
% Determiner
% ------------------------------------------------------------------------

determiner([arg:A,
	    fcn:extra,
	    qnt:all,
	    drs:D1-[drs(U1, [drs(U2, C2) ==> drs(U3, C3)|C1])|Top], 
            res:[drs([], [])|D1]-D2, 
            sco:[drs([], [])|D2]-[drs(U3, C3), drs(U2, C2), drs(U1, C1)|Top],
            ana:N-N,
	    para:P1-[WF|P1],
            tree:[det_1, WF]])
  -->
  { lexicon([cat:determiner, wfm:WF, arg:A, qnt:forall]) },
  WF.


determiner([arg:A,
	    fcn:subj,
	    qnt:neg,
	    drs:D1-[drs(U1, [drs(U2, C2) ==> drs([], [neg drs(U3, C3)])|C1])|Top],
            res:[drs([], [])|D1]-D2, 
            sco:[drs([], [])|D2]-[drs(U3, C3), drs(U2, C2), drs(U1, C1)|Top],
            ana:N-N,
	    para:P1-[WF|P1],
            tree:[det_2, WF]])
  -->
  { lexicon([cat:determiner, wfm:WF, arg:A, qnt:neg]) },
  WF.


/*
determiner([arg:A,
	    fcn:subj,
	    qnt:neg,
	    drs:D1-[drs(U, [neg DRS|Con])|Top],
            res:[drs([], [])|D1]-D2, 
            sco:D2-[DRS, drs(U, Con)|Top],
            ana:N-N,
	    para:P1-[WF|P1],
            tree:[det_2, WF]])
  -->
  { lexicon([cat:determiner, wfm:WF, arg:A, qnt:neg]) },
  WF.
*/

determiner([arg:A,
	    fcn:subj,
	    qnt:all,
	    drs:D1-[drs(U1, [drs(U2, C2) ==> drs(U3, C3)|C1])|Top], 
            res:[drs([], [])|D1]-D2, 
            sco:[drs([], [])|D2]-[drs(U3, C3), drs(U2, C2), drs(U1, C1)|Top],
            ana:N-N,
	    para:P1-[WF|P1],
            tree:[det_3, WF]])
  -->
  { lexicon([cat:determiner, wfm:WF, arg:A, qnt:all]) },
  WF.


determiner([arg:A,
	    fcn:subj,
	    qnt:most,
            drs:[drs(U1, C1)|Top]-D3,
            res:[drs(U1, C1)|Top]-[drs(U1, C1)|Top],
            sco:D2-D3,
            ana:N-N,
	    para:P1-[WF|P1],
            tree:[det_4, WF]])
  -->
  { lexicon([cat:determiner, wfm:WF, arg:A, qnt:most]) },
  WF.


determiner([arg:[num:sg, ind:I],
	    fcn:O,
	    qnt:exist,
	    drs:D1-D3,
            res:D1-D2,
            sco:D2-D3,
            ana:N-[[determiner([the])]|N],
	    para:P1-[WF|P1],
            tree:[det_5, WF]])
  -->
  { lexicon([cat:determiner, wfm:WF, arg:[num:sg, ind:I], qnt:exist]) },
  WF.


determiner([arg:[num:sg, ind:I],
	    fcn:O,
	    qnt:def,
	    drs:D1-D3,
            res:D1-D2,
            sco:D2-D3,
            ana:N-[[determiner([the])]|N],
	    para:P1-[WF|P1],
            tree:[det_6, WF]])
  -->
  { lexicon([cat:determiner, wfm:WF, arg:[num:sg, ind:I], qnt:def]) },
  WF.


determiner([arg:[num:sg, ind:I],
	    fcn:O,
	    qnt:def,
	    ref:'+',
	    drs:D1-D3,
            res:D1-D2,
            sco:D2-D3,
            ana:N-{WF|N},
	    para:P1-[WF|P1],
            tree:[det_7, WF]])
  -->
  { lexicon([cat:determiner, wfm:WF, ref:'+', snum:_, spos:_,  arg:[num:sg, ind:I], qnt:def]) },
  WF.


determiner([arg:[num:sg, ind:I],
	    fcn:O,
	    qnt:def,
	    ref:'+',
	    drs:D1-D3,
            res:D1-D2,
            sco:D2-D3,
            ana:N-{WF|N},
	    para:P1-[WF|P1],
            tree:[det_8, WF]])
  -->
  { lexicon([cat:determiner, wfm:WF, arg:[num:sg, ind:I], qnt:def]) },
  WF.

% ------------------------------------------------------------------------
% Wh determiner
% ------------------------------------------------------------------------

wh_determiner([wfm:WF,
               arg:[num:N, ind:I],
	       drs:[drs(U1, C1)|Top]-D3,
               res:[drs(U1, C1)|Top]-[drs(U1, C1)|Top],
               sco:D2-D3,
               ana:N1-N1,
	       para:P1-[WF|P1],
               tree:[whd, WF]])
  -->
  { lexicon([cat:wh_determiner, wfm:WF, arg:[num:N, ind:I]]) },
  WF.


% ------------------------------------------------------------------------
% Wh pronoun
% ------------------------------------------------------------------------

wh_pronoun([wfm:WF,
	    arg:[num:N, ind:I1],
	    drs:[drs(U1, C1)|Top]-D3,
            res:[drs(U1, C1)|Top]-[drs([I2, I1|U1], [query(I1, Sym, I2)|C1])|Top],
            sco:D2-D3,
            ana:N1-N1,
	    para:P1-[WF|P1],
            tree:[whp, WF]])
  -->
  { lexicon([cat:wh_pronoun, wfm:WF, arg:[num:N, ind:I1], con:query(I1, Sym, I2)]) },
  WF.


% ------------------------------------------------------------------------
% Wh adverb
% ------------------------------------------------------------------------

wh_adverb([wfm:WF,
	   arg:A,
	   evtl:E,
	   drs:[drs(U1, C1)|Top]-[drs(U1, [C2|C1])|Top],
	   ana:N-N,
	   para:P1-[WF|P1],
           tree:[wha, WF]])
  -->
  { lexicon([cat:wh_adverb, wfm:WF, arg:A, evtl:E, con:C2]) },
  WF.


wh_adverb([wfm:WF,
           ana:N-N,
	   para:P1-[WF|P1],
           tree:[wha, WF]])
  -->
  { lexicon([cat:wh_adverb, wfm:WF]) },
  WF.


% ------------------------------------------------------------------------
% Existential there
% ------------------------------------------------------------------------

existential_there([wfm:WF,
		   arg:A, 
		   qnt:exist,
                   ana:N-N,
		   para:P1-[WF|P1],
                   tree:[ext, WF]])
  -->
  { lexicon([cat:ex_there, wfm:WF, arg:A, qnt:exist]) },
  WF.


% ------------------------------------------------------------------------
% Number
% ------------------------------------------------------------------------

number([arg:A,
	drs:[drs(U1, C1)|Top]-D3,
        res:[drs(U1, C1)|Top]-[drs(U1, [C2|C1])|Top],
        sco:D2-D3,
        ana:N-N,
        para:P1-[WF|P1],
        tree:[num, WF]])
  -->
  { lexicon([cat:number, wfm:WF, arg:A, con:C2]) },
  WF.

number([wfm:WF,
        arg:[num:Num, ind:I],
	drs:[drs(U1, C1)|Top]-D3,
        res:[drs(U1, C1)|Top]-[drs([I|U1], [C2|C1])|Top],
        sco:D2-D3,
        ana:N-N,
        para:P1-[WF|P1],
        tree:[num, WF]])
  -->
  { lexicon([cat:number, wfm:WF, arg:[num:Num, ind:I], con:C2]) },
  WF.


% ------------------------------------------------------------------------
% Cardinal number
% ------------------------------------------------------------------------

cardinal([wfm:WF,
          arg:A,
	  drs:[drs(U1, C1)|Top]-D3,
          res:[drs(U1, C1)|Top]-[drs(U1, [C2|C1])|Top],
          sco:D2-D3,
          ana:N-N,
	  para:P1-[WF|P1],
          tree:[card_1, WF]])
  -->
  { lexicon([cat:cardinal, wfm:WF, arg:A, con:C2]) },
  WF.


cardinal([arg:A,
	  drs:[drs(U1, C1)|Top]-D3,
          res:[drs(U1, C1)|Top]-[drs(U1, [C2|C1])|Top],
          sco:D2-D3,
          ana:N-N,
	  para:P1-[WF|P1],
          tree:[card_2, WF]])
  -->
  { lexicon([cat:cardinal, wfm:WF, arg:A, con:C2]) },
  WF.


% ------------------------------------------------------------------------
% Ordinal number
% ------------------------------------------------------------------------

ordinal([arg:A,
         drs:[drs(U1, C1)|Top]-[drs(U1, [C2|C1])|Top],
         ana:N1-[ordinal(WF)|N1],
	 para:P1-[WF|P1],
         tree:[ord, WF]])
  -->
  { lexicon([cat:ordinal, wfm:WF, arg:A, con:C2]) },
  WF.


ordinal([arg:A,
         ref:'+',
         drs:[drs(U1, C1)|Top]-[drs(U1, [C2|C1])|Top],
         ana:N1-[WF|N1],
	 para:P1-[WF|P1],
         tree:[ord, WF]])
  -->
  { lexicon([cat:ordinal, wfm:WF, ref:'+', snum:_, spos:_, arg:A, con:C2]) },
  WF.



% ------------------------------------------------------------------------
% Count noun
% ------------------------------------------------------------------------

count_noun([wfm:WF,
            arg:[num:N, ind:I],
            drs:[drs(U1, C1)|Top]-[drs([I|U1], [C2|C1])|Top],
            ana:N1-[[count_noun(WF)]|N1],
            para:P1-[WF|P1],
            tree:[noun_1, WF]])
  -->
  { lexicon([cat:count_noun, wfm:WF, arg:[num:N, ind:I], con:C2]) }, 
  WF.


count_noun([wfm:WF,
            arg:[num:N, ind:I],
            ref:'+',
            drs:[drs(U1, C1)|Top]-[drs([I|U1], [C2|C1])|Top],
            ana:N1-[WF|N1],
            para:P1-[WF|P1],
            tree:[noun_2, WF]])
  -->
  { lexicon([cat:count_noun, wfm:WF, ref:'+', snum:SNum, spos:SPos, arg:[num:N, ind:I], con:C2]) }, 
  WF.


% ------------------------------------------------------------------------
% Mass noun
% ------------------------------------------------------------------------

mass_noun([arg:[num:sg, ind:I],
           drs:[drs(U1, C1)|Top]-[drs([I|U1], [C2|C1])|Top],
           ana:N1-[WF|N1],
           para:P1-[WF|P1],
           tree:[mass_noun, WF]])
  -->
  { lexicon([cat:mass_noun, wfm:WF, arg:[num:sg, ind:I], con:C2]) },
  WF.


% ------------------------------------------------------------------------
% Name
% ------------------------------------------------------------------------

name([arg:[num:sg, ind:I],
      drs:[drs(U1, C1)|Top]-[drs([I|U1], [C2|C1])|Top],
      ana:N1-[WF|N1],
      para:P1-[WF|P1],
      tree:[name, WF]])
  -->
  { lexicon([cat:name, wfm:WF, arg:[num:sg, ind:I], con:C2]) },
  WF.


% ------------------------------------------------------------------------
% Temporal Expression
% ------------------------------------------------------------------------

temporal_expression([arg:[num:_, ind:I],
                     drs:[drs(U1, C1)|D1]-D2,
                     res:[drs(U1, C1)|D1]-[drs([I|U1], [C2|C1])|D1],
                     sco:[drs([I|U1], [C2|C1])|D1]-S2,
                     ana:N1-[[WF]|N1],
                     para:P1-[WF|P1],
                     tree:[tex, [WF]]])
  -->
  [WF],
  { lexicon([spc:no, cat:temporal_expression, wfm:[WF], arg:[num:_, ind:I], con:C2]) }.

  
% ------------------------------------------------------------------------
% String Variable
% ------------------------------------------------------------------------

string_variable([arg:[num:N, ind:I],
                 app:'+',
                 drs:[drs(U1, C1)|Top]-[drs(U1, [C2|C1])|Top],
                 ana:N1-[[string_variable(WF)]|N1],
	         para:P1-[WF|P1],
                 tree:[svar_1, WF]])
  -->
  { lexicon([cat:string_variable, wfm:WF, arg:[num:N, ind:I], con:[C2]]) }, 
  WF.

string_variable([arg:[num:N, ind:I],
                 app:'+',
		 ref:'+',
                 drs:[drs(U1, C1)|Top]-[drs(U1, [C2|C1])|Top],
                 ana:N1-[WF|N1],
	         para:P1-[WF|P1],
                 tree:[svar_2, WF]])
  -->
  { lexicon([cat:string_variable, wfm:WF, ref:'+', snum:_, spos:_, arg:[num:N, ind:I], con:[C2]]) }, 
  WF.

string_variable([arg:[num:N, ind:I],
                 app:'-',
                 drs:[drs(U1, C1)|Top]-[drs([I|U1], [C2|C1])|Top],
                 ana:N1-[WF|N1],
	         para:P1-[WF|P1],
                 tree:[svar_3, WF]])
  -->
  { lexicon([cat:string_variable, wfm:WF, arg:[num:N, ind:I], con:[C2]]) }, 
  WF.


% ------------------------------------------------------------------------
% Numeric Variable
% ------------------------------------------------------------------------

numeric_variable([arg:[num:Num1, ind:I1],
                  arg:[num:Num2, ind:I2],
                  app:'+',
                  drs:[drs(U1, C1)|Top]-[drs([I2|U1], [C3, C2|C1])|Top],
                  ana:N1-[[numeric_variable(WF)]|N1],
	          para:P1-[WF|P1],
                  tree:[nvar_1, WF]])
  -->
  { lexicon([cat:numeric_variable, wfm:WF, arg:[num:Num1, ind:I1], arg:[num:Num2, ind:I2], con:[C3, C2]]) }, 
  WF.


numeric_variable([arg:[num:Num1, ind:I1],
                  arg:[num:Num2, ind:I2],
                  app:'+',
		  ref:'+',
                  drs:[drs(U1, C1)|Top]-[drs([I2|U1], [C3, C2|C1])|Top],
                  ana:N1-[WF|N1],
	          para:P1-[WF|P1],
                  tree:[nvar_1, WF]])
  -->
  { lexicon([cat:numeric_variable, wfm:WF, ref:'+', snum:_, spos:_, arg:[num:Num1, ind:I1], arg:[num:Num2, ind:I2], con:[C3, C2]]) }, 
  WF.


numeric_variable([arg:[num:Num1, ind:I1],
                  arg:[num:Num2, ind:I2],
                  app:'-',
                  drs:[drs(U1, C1)|Top]-[drs([I2, I1|U1], [C3, C2|C1])|Top],
                  ana:N1-[WF|N1],
	          para:P1-[WF|P1],
                  tree:[nvar_2, WF]])
  -->
  { lexicon([cat:numeric_variable, wfm:WF, arg:[num:Num1, ind:I1], arg:[num:Num2, ind:I2], con:[C3, C2]]) }, 
  WF.


% ------------------------------------------------------------------------
% Auxiliary
% ------------------------------------------------------------------------

auxiliary([wfm:WF,
           arg:A,
           ana:N-N,
           para:P1-[WF|P1],
           tree:[aux, WF]])
  -->
  { lexicon([cat:auxiliary, wfm:WF, arg:A]) }, 
  WF.


% ------------------------------------------------------------------------
% Copula
% ------------------------------------------------------------------------

% Are questions
copula([wfm:WF,
        arg:A,
        ana:N-N,
        para:P1-[WF|P1],
        tree:[cp, WF]])
  -->
  { lexicon([cat:copula, wfm:WF, arg:A, vform:V, evtl:E, con:C2]) }, 
  WF.


copula([wfm:WF,
	arg:A1,
	arg:A2,
        vform:V,
        evtl:E,
        drs:[drs(U1, C1)|Top]-[drs([E|U1], [C2|C1])|Top],
        ana:N-N,
	para:P1-[WF|P1],
        tree:[cop_1, WF]])
  -->
  { lexicon([cat:copula, wfm:WF, arg:A1, arg:A2, vform:V, evtl:E, con:C2]) }, 
  WF.


copula([wfm:WF,
	arg:A,
        vform:V,
        evtl:E,
        drs:[drs(U1, C1)|Top]-[drs([E|U1], [C2|C1])|Top],
        ana:N-N,
	para:P1-[WF|P1],
        tree:[cop_2, WF]])
  -->
  { lexicon([cat:copula, wfm:WF, arg:A, vform:V, evtl:E, con:C2]) }, 
  WF.


% ------------------------------------------------------------------------
% Intransitive verb
% ------------------------------------------------------------------------

intransitive_verb([wfm:WF,
	           arg:A,
                   vform:V,
                   evtl:E,
                   con:C2, 
                   drs:[drs(U1, C1)|Top]-[drs([E|U1], [C2|C1])|Top],
                   ana:N-N,
		   para:P1-[WF|P1],
                   tree:[iv, WF]])
  -->
  { lexicon([cat:intransitive_verb, wfm:WF, arg:A, vform:V, evtl:E, con:C2]) }, 
  WF.


% ------------------------------------------------------------------------
% Transitive verb
% ------------------------------------------------------------------------

transitive_verb([wfm:WF,
		 arg:A1,
	         arg:A2,
                 vform:V,
                 evtl:E, 
		 con:C2,
                 drs:[drs(U1, C1)|Top]-[drs([E|U1], [C2|C1])|Top],
                 ana:N-N,
		 para:P1-[WF|P1],
                 tree:[tv, WF]])
  -->
  { lexicon([cat:transitive_verb, wfm:WF, arg:A1, arg:A2, vform:V, evtl:E, con:C2]) }, 
  WF.


% ------------------------------------------------------------------------
% Relative pronoun
% ------------------------------------------------------------------------

relative_pronoun([wfm:WF, ana:N-N, para:P1-[WF|P1], tree:[rp, WF]])
  -->
  { lexicon([cat:relative_pronoun, wfm:WF]) },
  WF.


% ------------------------------------------------------------------------
% Coordination
% ------------------------------------------------------------------------

coordination([wfm:WF, ana:N-N, para:P1-[WF|P1], tree:[crd, WF]])
  -->
  { lexicon([cat:coordination, wfm:WF]) },
  WF.

  
% ------------------------------------------------------------------------
% Operator
% ------------------------------------------------------------------------

operator([arg:A1,
	  arg:A2,
          drs:[drs(U1, C1)|Top]-[drs(U1, [C2|C1])|Top],
          ana:N-N,
	  para:P1-[WF|P1],
          tree:[op, WF]])
  -->
  { lexicon([cat:operator, wfm:WF, arg:A1, arg:A2, con:C2]) }, 
  WF.


operator([wfm:WF,
          arg:A1,
	  arg:A2,
          drs:[drs(U1, C1)|Top]-[drs(U1, [C2|C1])|Top],
          ana:N-N,
	  para:P1-[WF|P1],
          tree:[op, WF]])
  -->
  { lexicon([cat:operator, wfm:WF, arg:A1, arg:A2, con:C2]) }, 
  WF.


% ------------------------------------------------------------------------
% Relational adjective
% ------------------------------------------------------------------------

relational_adjective([evtl:E,
	              arg:A,
                      con:C2,
                      drs:[drs(U1, C1)|Top]-[drs(U1, [C2|C1])|Top],
                      ana:N-N,
		      para:P1-[WF|P1],
                      tree:[radj_1, WF]])
  -->
  { lexicon([cat:relational_adjective, wfm:WF, evtl:E, arg:A, con:C2]) }, 
  WF.


% ------------------------------------------------------------------------
% Comparative phrase
% ------------------------------------------------------------------------

comparative_phrase([evtl:E,
	            arg:A,
                    drs:[drs(U1, C1)|Top]-[drs(U1, [C2|C1])|Top],
                    ana:N-N,
		    para:P1-[WF|P1],
                    tree:[cp, WF]])
  -->
  { lexicon([cat:comparative, wfm:WF, evtl:E, arg:A, con:C2]) }, 
  WF.


% ------------------------------------------------------------------------
% Preposition
% ------------------------------------------------------------------------

preposition([wfm:WF,
	     evtl:E,
	     arg:A,
             drs:[drs(U1, C1)|Top]-[drs(U1, [C2|C1])|Top],
             ana:N-N,
	     para:P1-[WF|P1],
             tree:[prep_1, WF]])
  -->
  { lexicon([cat:preposition, wfm:WF, evtl:E, arg:A, con:C2]) }, 
  WF.


preposition([wfm:WF,
	     arg:A1,
	     arg:A2,
             drs:[drs(U1, C1)|Top]-[drs(U1, [C2|C1])|Top],
             ana:N1-[[preposition(WF)]|N1],
	     para:P1-[WF|P1],
             tree:[prep_2, WF]])
  -->
  { lexicon([cat:preposition, wfm:WF, arg:A1, arg:A2, con:C2]) }, 
  WF.


preposition([wfm:WF,
	     arg:A1,
	     arg:A2,
	     ref:'+', 
             drs:[drs(U1, C1)|Top]-[drs(U1, [C2|C1])|Top],
             ana:N1-[WF|N1],
	     para:P1-[WF|P1],
             tree:[prep_3, WF]])
  -->
  { lexicon([cat:preposition, wfm:WF, ref:'+', snum:_, spos:_, arg:A1, arg:A2, con:C2]) }, 
  WF.


preposition([wfm:WF, ana:N-N, para:P1-[WF|P1], tree:[prep_4, WF]])
  -->
  { lexicon([cat:preposition, wfm:WF]) }, 
  WF.



% ------------------------------------------------------------------------
% Adverb
% ------------------------------------------------------------------------

adverb([wfm:WF, ana:N-N, para:P1-[WF|P1], tree:[adv_1, WF]])
  -->
  { lexicon([cat:adverb, wfm:WF]) }, 
  WF.


adverb([wfm:WF,
        evtl:E,
        drs:[drs(U1, C1)|D2]-[drs(U1, [C2|C1])|D2],
        ana:N-N,
	para:P1-[WF|P1],
        tree:[adv_2, WF]])
  -->
  { lexicon([cat:adverb, wfm:WF, evtl:E, con:C2]) }, 
  WF.



% ------------------------------------------------------------------------
% Negation
% ------------------------------------------------------------------------

negation([wfm:WF, ana:N-N, para:P1-[WF|P1], tree:[neg, WF]]) -->
  { lexicon([cat:negation, wfm:WF]) }, 
  WF.


% ------------------------------------------------------------------------
% Punctuation mark
% ------------------------------------------------------------------------

full_stop([wfm:WF, ana:N-N, para:P1-[WF|P1], tree:[fs, WF]])
  -->
  { lexicon([cat:full_stop, wfm:WF]) }, 
  WF.


question_mark([wfm:WF, ana:N-N, para:P1-[WF|P1], tree:[qm, WF]])
  -->
  { lexicon([cat:question_mark, wfm:WF]) }, 
  WF.


comma([wfm:WF, ana:N-N, para:P1-[WF|P1], tree:[cm, WF]]) -->
  { lexicon([cat:comma, wfm:WF]) }, 
  WF.


% ------------------------------------------------------------------------
% Arithmetic expressions
% ------------------------------------------------------------------------

% -----

%% Interface rules to arithmetic expressions

% [If] a position N1 ... and N1 is ...
%
sentence_0([crd:'-', loc:ante, drs:D, ana:N1-N3, para:P1-P3, tree:[s0_5, NP, VP]])
  -->
  noun_phrase_arithmetic([arg:A, loc:arith, fcn:subj, qnt:def, drs:D, sco:S, ana:N1-N2, para:P1-P2, tree:NP]),
  verb_phrase_arithmetic([crd:'+', arg:A, loc:arith, drs:S, ana:N2-N3, para:P2-P3, tree:VP]).


relative_clause_0([crd:'+', arg:A, loc:ante,
  drs:[drs(U1, [variable(Number, VarName), ordinal(Var, Number)|C1])|Top]-D2,
  ana:N1-N3, para:P1-P3, tree:[rc0_8, RP, VP]])
  -->
  relative_pronoun([wfm:WF, ana:N1-N2, para:P1-P2, tree:RP]),
  verb_phrase_arithmetic([crd:'-', arg:A, loc:arith, 
                          drs:[drs(U1, [variable(Number, VarName), ordinal(Var, Number)|C1])|Top]-D2, 
                          ana:N2-N3, para:P2-P3, tree:VP]).


relative_clause_0([crd:'-', arg:A, loc:ante, 
  drs:[drs(U1, [variable(Number, VarName), ordinal(Var, Number)|C1])|Top]-D2,
  ana:N1-N3, para:P1-P3, tree:[rc0_9, RP, VP]])
  -->
  relative_pronoun([wfm:WF, ana:N1-N2, para:P1-P2, tree:RP]),
  verb_phrase_arithmetic([crd:'-', arg:A, loc:arith,
                          drs:[drs(U1, [variable(Number, VarName), ordinal(Var, Number)|C1])|Top]-D2,
                          ana:N2-N3, para:P2-P3, tree:VP]).


% -----

% Exclude that Pascal is allocated to a position P1 and that Naren is allocated to a position P2 and that P1
% is not equal to P2 minus 3.
%
noun_phrase_arithmetic([arg:A1, loc:arith, fcn:dobj, qnt:def,  drs:D1-D3, sco:S1-D3, ana:N1-N5, para:P1-P5, tree:[np_80, Var, Op, Num]])
  -->
  numeric_variable([arg:A1, arg:A2, app:'-', drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Var]),
  { anaphora_resolution([arg:A1, ref:'+', drs:D1-[], ant:D2, sco:D0-[], ana:N1-N2-N3, para:P1-P2-P3]) },
  operator([arg:A2, arg:A3, drs:R2-S1, ana:N3-N4, para:P3-P4, tree:Op]),
  number([arg:A3, drs:D1-R1, res:R1-R2, sco:S0, ana:N4-N5, para:P4-P5, tree:Num]).



% N1 ...
%
noun_phrase_arithmetic([arg:A2, loc:arith, fcn:subj, qnt:def, drs:D1-D4, sco:D3-D4, ana:N1-N3, para:P1-P3, tree:[np_83, Var]])
  -->
  numeric_variable([arg:A1, arg:A2, app:'-', drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Var]),
  { anaphora_resolution([arg:A2, ref:'+', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) }.


% ... N1
%
noun_phrase_arithmetic([arg:A2, loc:arith, fcn:dobj, qnt:def, drs:D1-D4, sco:D3-D4, ana:N1-N3, para:P1-P3, tree:[np_84, Var]])
  -->
  numeric_variable([arg:A1, arg:A2, app:'-', drs:[drs([], [])]-D2, ana:[]-N2, para:P1-P2, tree:Var]),
  { anaphora_resolution([arg:A2, ref:'+', drs:D1-[], ant:D2, sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) }.


% Exclude that Dominique is allocated to a position N that is greater than or equal to 3.
%
noun_phrase_arithmetic([arg:[num:_, ind:I], loc:arith, fcn:dobj, qnt:Q, drs:D, sco:S1-S2, ana:N1-N1, para:P1-P2, tree:[np_74, Number]])
  -->
  number([arg:[num:_, ind:I], drs:D, res:R-S1, sco:S1-S2, ana:_-_, para:P1-P2, tree:Number]).


verb_phrase_arithmetic([crd:_, arg:A1, loc:arith, drs:D, ana:N1-N4, para:P1-P4, tree:[vp_85, Cop, CP, NP]])
  -->
  copula([wfm:WF, arg:A1, vform:V, evtl:E, drs:S1-S2, ana:N1-N2, para:P1-P2, tree:Cop]),
  comparative_phrase([evtl:E, arg:A2, drs:S2-S3, ana:N2-N3, para:P2-P3, tree:CP]),
  noun_phrase_arithmetic([arg:A2, loc:L, fcn:dobj, qnt:Q2, drs:D, sco:S1-S3, ana:N3-N4, para:P3-P4, tree:NP]).


/*

list_ast(Ls, AST) :- phrase(expression(AST), Ls).

expression(E)       --> term(T), expression_r(T, E).

expression_r(E0, E) --> [+], term(T), expression_r(E0+T, E).
expression_r(E0, E) --> [-], term(T), expression_r(E0-T, E).
expression_r(E, E)  --> [].

term(T)       --> power(P), term_r(P, T).
term_r(T0, T) --> [*], power(P), term_r(T0*P, T).
term_r(T0, T) --> [/], power(P), term_r(T0/P, T).
term_r(T, T)  --> [].

power(P)          --> factor(F), power_r(F, P).
power_r(P0, P0^P) --> [^], factor(P1), power_r(P1, P).
power_r(P, P)     --> [].

factor(N) --> [N], { number(N) }.
factor(E) --> ['('], expression(E), [')'].

*/



 
