%========================================================================
%  Project:   PENG Engine
%  Version:   0.01
%  Module:    chart_parser.pl
%  Date:      2009-06-25
%  Modified:  2016-06-30
%  Status:    WORK IN PROGRESS!
%  Author:    Rolf Schwitter
%  Copyright: Macquarie University, 2016
%------------------------------------------------------------------------

%========================================================================
% Initialisation
%========================================================================

:- dynamic anaphora/1, compound_word/6, edge/6, lookahead/3.


% -----------------------------------------------------------------------
% Style checking
% -----------------------------------------------------------------------

% :- style_check([-discontiguous, -singleton]).


% -----------------------------------------------------------------------
% term_expansion/2
% -----------------------------------------------------------------------

term_expansion((LHS --> RHS), Format) :-
  (
     RHS    = ( { lexicon(List) }, Word )
     ->
     Format = ( rule(LHS, [ lexicon(List) ]) )
  ;
     RHS    = ( Word, { lexicon(List) } )
     ->
     Format = ( rule(LHS, [ lexicon(List) ]) )
  ;
     conjunction_to_list_rhs(RHS, RHSList)
     ->
     Format = ( rule(LHS, RHSList) )
  ;
     Format = ( rule(LHS, RHS ) )
  ).

conjunction_to_list_rhs(RHS, RHSList) :-
  \+ is_list(RHS), 
  conjunction_to_list(RHS, RHSList).

conjunction_to_list((Term, Terms), [Term|ListofTerms]) :- !, 
  nonvar(Term), 
  conjunction_to_list(Terms, ListofTerms).

conjunction_to_list(Term, [Term]).


%========================================================================
% init_chart_parser/2
%========================================================================

init_chart_parser(LHS, [SNum, 0, _]) :-
  SNum = 1,
  clean_up_chart,
  init_chart(SNum, 0, LHS).

init_chart_parser(LHS, [SNum, 0, _]) :-
  SNum > 1,
  clean_up_chart,
  % nl(user), write(user, 'LHS: '), write(user, LHS), nl(user), nl(user),
  init_chart(SNum, 0, LHS).

% init_chart_parser(LHS, [SN, 0, _]) :-
%  clean_up_chart, 
%  init_chart(SN, 0, LHS).

init_chart(SN, V0, LHS) :-
  foreach(rule(LHS, RHS), init_edge(SN, V0, V0, LHS, [], RHS)).

init_edge(SN, V0, V0, LHS, Found, RHS) :-
  edge(SN, V0, V0, LHS, Found, RHS), !.

init_edge(SN, V0, V0, LHS, Found, [RHS1|RHSs]) :- 
  assert_edge(SN, V0, V0, LHS, Found, [RHS1|RHSs]), 
  foreach(rule(RHS1, RHS2), init_edge(SN, V0, V0, RHS1, [], RHS2)),
  update_lookahead_anaphora(SN, V0, RHS1).


% -----------------------------------------------------------------------
% clean_up_chart/0
% -----------------------------------------------------------------------

clean_up_chart :-
   retractall(compound_word(_, _, _, _, _, _)), 
   retractall(edge(_, _, _, _, _, _)), 
   retractall(lookahead(_, _, _)),
   retractall(anaphora(_)),
   retractall(lexicon([cat:_, wfm:_, ref:'+', snum:_, spos:_|Rest])).


%========================================================================
% chart_parser/2
%========================================================================

chart_parser(Word, [SN, V1, V2]) :-
  start_chart(SN, V1, V2, Word).


%-----------------------------------------------------------------------
% start_chart/4
%-----------------------------------------------------------------------

start_chart(SN, V1, V2, Word) :-	
  foreach_word(word(SN, V1, V2, Word, LHS), 
	        add_edge(SN, V1, V2, LHS, Word, [])), !.


% -----------------------------------------------------------------------
% predict_active_edges/3
%
% Add active edges of type LHS at vertex V0 by looking up
% the rules which expand LHS in the grammar
% -----------------------------------------------------------------------

predict_active_edges(SN, V0, LHS) :-
  foreach(rule(LHS, RHS), 
          add_edge(SN, V0, V0, LHS, [], RHS)).


% -----------------------------------------------------------------------
% add_edge/6
%   - check if an edge is already available
%   - for an inactive edge apply the fundamental rule
%   - for an active edge apply the fundamental rule and
%     predict_active_edges.
% -----------------------------------------------------------------------

add_edge(SN, V1, V2, LHS, Found, [{Goal}|RHS]) :-
  call(Goal), 
  add_edge(SN, V1, V2, LHS, [{Goal}|Found], RHS).

add_edge(SN, V1, V2, LHS, Found, RHS) :-
  edge(SN, V1, V2, LHS, Found, RHS), !.

add_edge(SN, V1, V2, LHS, Found, []) :- 
  assert_edge(SN, V1, V2, LHS, Found, []), 
  apply_fundamental_rule(SN, V1, V2, LHS, []).

add_edge(SN, V1, V2, LHS, Found, [RHS|RHSs]) :-
  assert_edge(SN, V1, V2, LHS, Found, [RHS|RHSs]), 
  apply_fundamental_rule(SN, V1, V2, LHS, [RHS|RHSs]), 
  predict_active_edges(SN, V2, RHS),
  update_lookahead_anaphora(SN, V2, RHS).


% -----------------------------------------------------------------------
% update_lookahead_anaphora/3
% -----------------------------------------------------------------------

update_lookahead_anaphora(SN, Pos, RHS) :-
  (
     RHS = noun_phrase([arg:A, loc:L, fcn:F, qnt:Q, drs:D, sco:S, ana:N0-N2, para:P, tree:T])
  ;
     RHS = noun_phrase([arg:A, loc:L, fcn:pobj, qnt:Q, drs:D, sco:S, ana:N0-N1-N2, para:P, tree:T])
  ;
     RHS = noun_phrase([arg:A, loc:L, fcn:F, qnt:_, drs:D, res:R, sco:S, ana:N0-N2, para:P, tree:T])
  %;
  %   RHS = noun_phrase([arg:A, loc:decl, fcn:tex, drs:D1-D2, sco:D4-D5, ana:N1-N3, para:P1-P3, tree:T])
		   
 % ;
 %    RHS = noun_phrase([arg:A, loc:L, fcn:F, qnt:Q, drs:D, sco:S, ana:N0-N2, para:P, tree:T])
 % ;
 %     RHS = discoure_element([drs:D, ana:N0-N2, para:P, tree:T])
   ;
      RHS = full_stop([wfm:['.'], ana:N0-N2, para:P2-P3, tree:T2])
  ),
  \+ N0 = []
  ->
  (
     call(anaphora(N0))
  ;
     retractall(anaphora(_)),
     asserta(anaphora(N0))
  ).


%  nl(user),
%  write(user, 'AnaphoraEX: '),
%  write(user, N0), nl(user), nl(user).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:count_noun, wfm:WF, arg:[num:Num, ind:I]|Rest]), 
  (
    call(lookahead(SN, Pos, [cat:count_noun, wfm:[], num:Num]))
  ;
    asserta(lookahead(SN, Pos, [cat:count_noun, wfm:[], num:Num]))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:count_noun, wfm:WF, ref:'+', snum:_, spos:_, arg:[num:Num, ind:I]|Rest]),
  (
    call(lookahead(SN, Pos, [cat:count_noun, wfm:[], ref:'+', num:Num]))
  ;
    asserta(lookahead(SN, Pos, [cat:count_noun, wfm:[], ref:'+', num:Num]))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:name, wfm:WF, arg:[num:Num, ind:I]|Rest]), 
  (
    call(lookahead(SN, Pos, [cat:name, wfm:[], num:Num]))
  ;
    asserta(lookahead(SN, Pos, [cat:name, wfm:[], num:Num]))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:mass_noun, wfm:WF, arg:[num:Num, ind:I]|Rest]), 
  (
    call(lookahead(SN, Pos, [cat:mass_noun, wfm:[], num:Num]))
  ;
    asserta(lookahead(SN, Pos, [cat:mass_noun, wfm:[], num:Num]))	 
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:intransitive_verb, wfm:WF, arg:[num:Num, ind:I], vform:inf, evtl:E|Rest]), 
  (
    call(lookahead(SN, Pos, [cat:intransitive_verb, wfm:[], vform:inf]))
  ;
    asserta(lookahead(SN, Pos, [cat:intransitive_verb, wfm:[], vform:inf]))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:transitive_verb, wfm:WF, arg:[num:Num, ind:I1], arg:[num:_, ind:I2], vform:inf, evtl:E|Rest]), 
  (
    call(lookahead(SN, Pos, [cat:transitive_verb, wfm:[], vform:inf]))
  ;
    asserta(lookahead(SN, Pos, [cat:transitive_verb, wfm:[], vform:inf]))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:intransitive_verb, wfm:WF, arg:[num:Num, ind:I], vform:V, evtl:E|Rest]), 
  (
    call(lookahead(SN, Pos, [cat:intransitive_verb, wfm:[], num:Num, vform:V]))
  ;
    asserta(lookahead(SN, Pos, [cat:intransitive_verb, wfm:[], num:Num, vform:V]))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:transitive_verb, wfm:WF, arg:[num:Num, ind:I1], arg:[num:_, ind:I2], vform:V, evtl:E|Rest]), 
  (
    call(lookahead(SN, Pos, [cat:transitive_verb, wfm:[], num:Num, vform:V]))
  ;
    asserta(lookahead(SN, Pos, [cat:transitive_verb, wfm:[], num:Num, vform:V]))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:determiner, wfm:WF, ref:'+'|Rest]), 
  (
    call(lookahead(SN, Pos, [cat:determiner, wfm:[], ref:'+']))
  ;
    asserta(lookahead(SN, Pos, [cat:determiner, wfm:[], ref:'+']))
  ).

	   
update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:determiner, wfm:WF, arg:[num:Num, ind:I], qnt:Q|Rest]), 
  (
    call(lookahead(SN, Pos, [cat:determiner, wfm:[], num:Num, qnt:Q]))
  ;
    asserta(lookahead(SN, Pos, [cat:determiner, wfm:[], num:Num, qnt:Q]))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([spc:no, cat:temporal_expression, wfm:WF|Rest]), 
  (
    call(lookahead(SN, Pos, [cat:temporal_expression, wfm:[]]))
  ;
    asserta(lookahead(SN, Pos, [cat:temporal_expression, wfm:[]]))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:adjective, wfm:WF]), 
  (
    call(lookahead(SN, Pos, [cat:adjective, wfm:[]]))
  ;
    asserta(lookahead(SN, Pos, [cat:adjective, wfm:[]]))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:adjective, wfm:WF, evtl:E|Rest]), 
  (
    call(lookahead(SN, Pos, [cat:adjective, wfm:[], evtl:[]]))
  ;
    asserta(lookahead(SN, Pos, [cat:adjective, wfm:[], evtl:[]]))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:adjective, wfm:WF, ref:'+', snum:_, spos:_, evtl:E|Rest]),
  (
    call(lookahead(SN, Pos, [cat:adjective, wfm:[], ref:'+', evtl:[]]))
  ;
    asserta(lookahead(SN, Pos, [cat:adjective, wfm:[], ref:'+', evtl:[]]))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:numeric_variable, wfm:WF, ref:'+', snum:_, spos:_|Rest]), 
  (
    call(lookahead(SN, Pos, [cat:numeric_variable, wfm:[], ref:'+']))
  ;
    asserta(lookahead(SN, Pos, [cat:numeric_variable, wfm:[], ref:'+']))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:numeric_variable, wfm:WF|Rest]), 
  (
    call(lookahead(SN, Pos, [cat:numeric_variable, wfm:[]]))
  ;
    asserta(lookahead(SN, Pos, [cat:numeric_variable, wfm:[]]))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:string_variable, wfm:WF, ref:'+', snum:_, spos:_|Rest]), 
  (
    call(lookahead(SN, Pos, [cat:string_variable, wfm:[], ref:'+']))
  ;
    asserta(lookahead(SN, Pos, [cat:string_variable, wfm:[], ref:'+']))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:string_variable, wfm:WF, arg:A|Rest]), 
  (
    call(lookahead(SN, Pos, [cat:string_variable, wfm:[]]))
  ;
    asserta(lookahead(SN, Pos, [cat:string_variable, wfm:[]]))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:copula, wfm:WF, arg:[num:Num, ind:I], vform:V, evtl:E|Rest]), 
  (
    call(lookahead(SN, Pos, [cat:copula, wfm:[], num:Num]))
  ;
    asserta(lookahead(SN, Pos, [cat:copula, wfm:[], num:Num]))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:ex_there, wfm:WF|Rest])
  ->
  (
    call(lookahead(SN, Pos, [cat:ex_there, wfm:[]]))
  ;
    asserta(lookahead(SN, Pos, [cat:ex_there, wfm:[]]))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:cardinal, wfm:[W|WF], arg:[num:Num, ind:I]|Rest])
  ->
  (
    call(lookahead(SN, Pos, [cat:cardinal, wfm:[W|_], num:Num]))
  ;
    asserta(lookahead(SN, Pos, [cat:cardinal, wfm:[W|_], num:Num]))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:ordinal, wfm:WF, arg:[num:Num, ind:I]|Rest])
  ->
  (
    call(lookahead(SN, Pos, [cat:ordinal, wfm:[]]))
  ;
    asserta(lookahead(SN, Pos, [cat:ordinal, wfm:[]]))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:ordinal, wfm:WF, ref:'+', snum:_, spos:_, arg:[num:Num, ind:I]|Rest])
  ->
  (
    call(lookahead(SN, Pos, [cat:ordinal, wfm:[], ref:'+']))
  ;
    asserta(lookahead(SN, Pos, [cat:ordinal, wfm:[], ref:'+']))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:preposition, wfm:WF, ref:'+', snum:_, spos:_|Rest]), 
  (
    call(lookahead(SN, Pos, [cat:preposition, wfm:[], ref:'+']))
  ;
    asserta(lookahead(SN, Pos, [cat:preposition, wfm:[], ref:'+']))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:preposition, wfm:WF, arg:_, arg:_|Rest]), 
  (
    call(lookahead(SN, Pos, [cat:preposition, wfm:WF, arg:_, arg:_]))
  ;
    asserta(lookahead(SN, Pos, [cat:preposition, wfm:WF, arg:_, arg:_]))
  ).
 %%  nl(user), write(user, 'Preposition: '), write(user, WF), nl(user), nl(user).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:preposition, wfm:WF, evtl:E|Rest]), 
  (
    call(lookahead(SN, Pos, [cat:preposition, wfm:[], evtl:_]))
  ;
    asserta(lookahead(SN, Pos, [cat:preposition, wfm:[], evtl:_]))
  ).

update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:preposition, wfm:WF]), 
  (
    call(lookahead(SN, Pos, [cat:preposition, wfm:[]]))
  ;
    asserta(lookahead(SN, Pos, [cat:preposition, wfm:[]]))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:wh_determiner, wfm:WF|Rest]), 
  (
    call(lookahead(SN, Pos, [cat:wh_determiner, wfm:[]]))
  ;
    asserta(lookahead(SN, Pos, [cat:wh_determiner, wfm:[]]))
  ).


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:auxiliary, wfm:WF, arg:[num:Num, ind:I]|Rest]), 
  (
    call(lookahead(SN, Pos, [cat:auxiliary, wfm:[], num:Num]))
  ;
    asserta(lookahead(SN, Pos, [cat:auxiliary, wfm:[], num:Num]))
  ).


%%% lexicon([cat:auxiliary, wfm:WF, arg:[num:N, ind:I]])


update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:constraint, wfm:WF|Rest]),
  (
    call(lookahead(SN, Pos, [cat:constraint, wfm:[]]))
  ;
    asserta(lookahead(SN, Pos, [cat:constraint, wfm:[]]))
  ).


update_lookahead_anaphora(SN, Pos, Word) :-
  is_list(Word)  
  ->
  (
    call(lookahead(SN, Pos, [cat:compound, wfm:Word]))
  ;
    asserta(lookahead(SN, Pos, [cat:compound, wfm:Word]))
  ).
  % nl(user), write(user, 'Compound: '), write(user, Word), nl(user), nl(user). 



update_lookahead_anaphora(SN, Pos, RHS) :-
  RHS = lexicon([cat:Cat, wfm:WF|Rest])
  % nl(user), nl(user), write(user, 'Cat: '), write(user, Cat), nl(user), nl(user)
  ->
  (
    call(lookahead(SN, Pos, [cat:Cat, wfm:WF]))
  ;
    asserta(lookahead(SN, Pos, [cat:Cat, wfm:WF]))
  ).


% -------------------------------------------------------------------------
% apply_fundamental_rule/5
% -------------------------------------------------------------------------

apply_fundamental_rule(SN, V1, V2, RHS, []) :-
  foreach(edge(SN, V0, V1, LHS, Found, [RHS|RHSs]), 
          add_edge(SN, V0, V2, LHS, [RHS|Found], RHSs)).

apply_fundamental_rule(SN, V1, V2, LHS, [RHS|RHSs]) :-
  foreach(edge(SN, V2, V3, RHS, Found, []), 
          add_edge(SN, V1, V3, LHS, [RHS|Found], RHSs)).


% -------------------------------------------------------------------------
% assert_edge/6
%    - asserts an edge
%    - pretty print edge
% -------------------------------------------------------------------------

assert_edge(SN, V1, V2, LHS, Found, RHS) :-
  assertz(edge(SN, V1, V2, LHS, Found, RHS)).
  %% LHS   =.. [L1|R1],
  %% write(edge(SN, V1, V2, L1)), nl, nl, nl.
  %% write('<br/>'), write('<br/>'), 
  %% pretty_print_edge(edge(SN, V1, V2, LHS, Found, RHS)), nl.
  %% write('<br/>'), write('<br/>').


% -------------------------------------------------------------------------
% pretty_print_edge/1
% -------------------------------------------------------------------------

pretty_print_edge(edge(SN, V1, V2, LHSCategory, Found, RHSCategories)) :-
  LHSCategory =.. [LHSFunctor|LHSArguments], 
  decompose_terms(RHSCategories, RHSFunctors), 
  decompose_terms(Found, FoundFunctors), !, 
  tab(3), 
  write(edge(SN, V1, V2, LHSFunctor, FoundFunctors, RHSFunctors)).

decompose_terms([], []).

decompose_terms([{Category}|Categories], [Functor|Functors]) :-
  nonvar(Category)
  ->
  Category =.. [Functor|Arguments], 
  decompose_terms(Categories, Functors).

decompose_terms([Category|Categories], [Functor|Functors]) :-
  nonvar(Category)
  ->
  Category =.. [Functor|Arguments], 
  decompose_terms(Categories, Functors).

decompose_terms([Category|Categories], [Category|Functors]) :-
  decompose_terms(Categories, Functors).


% -------------------------------------------------------------------------
% foreach_word(X, Y)
% foreach(X, Y).
%
% implements a failure-driven loop to find all possible solutions for Word.
% For each solution, Y is called once. If Word is not in the lexiocn, then
% the loop fails otherwise it succeeds.
% -------------------------------------------------------------------------

foreach_word(word(SN, V1, V2, Word, LHS), Y) :-
  (
     call(word(simple, SN, V1, V2, Word, LHS)), 
     once(Y), 
     fail
  ;
     call(word(compound, SN, V1, V2, Word, LHS)), 
     fail 
  ;
     true
  ).


foreach(X, Y) :-
  call(X), 
  once(Y), 
  fail.

foreach(X, Y) :- 
  true. 


% --------------------------------------------------------------------------
% Word rule
%
% --------------------------------------------------------------------------

word(compound, SN, V1, V2, [Word], LHS) :-
   compound_word(SN, V0, V1, LHS, Found, [Word]), 
   add_edge(SN, V0, V2, LHS, [Word|Found], []).

word(compound, SN, V1, V2, [Word], LHS) :-
   compound_word(SN, V0, V1, LHS, Found, [Word, LAH|LAHs]), 
   edge(SN, V0, V0, LHS, [], [RHS|RHSs]),
   update_compound_word(SN, V0, V2, LHS, [Word|Found], [LAH|LAHs]), 
   update_lookahead_anaphora(SN, V2, [LAH|LAHs]).

word(compound, SN, V1, V2, [Word], LHS) :-
   call( rule(LHS, [ lexicon([cat:Cat, wfm:[Word, LAH|LAHs]|Rest]) ]) ), 
   edge(SN, V1, V1, LHS, [], [RHS|RHSs]), 
   call( lexicon([cat:Cat, wfm:[Word, LAH|LAHs]|Rest]) ),
   update_compound_word(SN, V1, V2, LHS, [Word], [LAH|LAHs]), 
   update_lookahead_anaphora(SN, V2, [LAH|LAHs]).

word(simple, SN, V1, V2, [Word], LHS) :-
   \+ compound_word(SN, V0, V1, _, Found, [Word]),
   (		
      call( rule(LHS, [lexicon([cat:Cat, wfm:[Word]|Rest]) ]) ), 
      call( lexicon([cat:Cat, wfm:[Word]|Rest]) )
   ;
      call( lexicon([spc:no, cat:Cat, wfm:[Word]|Rest]) ),
      call( rule(LHS, [lexicon([spc:no, cat:Cat, wfm:[Word]|Rest]) ]) )
   ).

%word(simple, SN, V1, V2, [Word], LHS) :-
%   \+ compound_word(SN, V0, V1, _, Found, [Word]), !, fail.

%   \+ compound_word(SN, V0, V1, _, Found, [Word]), 
%   call( rule(LHS, [lexicon([cat:Cat, wfm:[Word]|Rest]) ]) ), 
%   call( lexicon([cat:Cat, wfm:[Word]|Rest]) ).

 
% --------------------------------------------------------------------------
% update_compound_word/6
% --------------------------------------------------------------------------

update_compound_word(SN, V1, V2, LHS, Found, LAHs) :-
  (
     call(compound_word(SN, V1, V2, LHS, Found, LAHs))
  ;
     assert(compound_word(SN, V1, V2, LHS, Found, LAHs))
  ).
 


