% =========================================================================
%  Project:   Puzzle Engine
%  Version:   0.01
%  Module:    process_test_discourse.pl
%  Date:      2014-09-23
%  Modified:  2016-04-17
%  Status:    DEMO VERSION !
%  Author:    Rolf Schwitter
%  Copyright: Rolf Schwitter, Macquarie University, 2016
% =========================================================================


% ------------------------------------------------------------------------
% process_test_discouse/3
%
% ------------------------------------------------------------------------

process_test_discourse(chart, Number, Discourse) :-
  DRSIn  = [drs([], [])],
  AnaIn  = [],
  ParaIn = [],
  SNum = 1,
  nl, nl,
  write('==============================================================='),
  nl, nl,
  write('DISCOURSE: '),
  write(Number),
  nl, nl,
  write('TOKENISED SENTENCES: '),
  nl, nl,
  write_discourse(Discourse),
  nl, nl, nl,
  write('PARSED SENTENCES: '),
  nl,
  chart_parser_discourse(Discourse, DRSIn, AnaIn, ParaIn, TreeIn, SNum).


process_test_discourse(dcg, Number, Discourse) :-
  nl, nl,
  write('==============================================================='),
  nl, nl,
  write('DISCOURSE: '),
  write(Number),
  nl, nl,
  write('TOKENISED SENTENCES:'),
  nl, nl,
  write_discourse(Discourse),
  nl, nl, nl,
  write('PARSED SENTENCES:'),
  dcg_parser_discourse([drs:[drs([], [])]-Drs, ana:[]-N2, para:[]-P2, tree:Tree], Discourse), 
  nl, nl, 
  write('SYNTAX TREES: '),
  write_syntax_tree(Tree), 
  nl, nl, 
  reverse(N2, RevN2),
  write('ANAPHORIC EXPRESSIONS:'),
  nl, nl,
  write(RevN2),
  nl,
  reverse_drs(Drs, RDrs1), 
  copy_term(RDrs1, RDrs2),
  numbervars(RDrs1, 0, _),
  nl, nl, 
  write('DISCOURSE REPRESENTATION STRUCTURE:'),
  nl, nl,
  write_drs(RDrs1, 0),
  translate_drs_to_asp(RDrs2, ASP, TheoryFlags),
  numbervars(ASP, 0, _),
  nl, nl, 
  write('ANSWER SET PROGRAM:'),
  nl, nl,
  write_answer_set_program(user, ASP),
  reasoner_environment(OSName, FileNameBG, FileNameClingo, FileNameASP, FileNameModel)
  ->
  (
     OSName = 'Windows_NT'
     ->
     (
        RMode = normal -> ENumMode = auto 
        ->
        atomic_list_concat(['cmd.exe /C ', FileNameClingo, ' -e ', ENumMode, ' -n 2 --project ', FileNameASP, ' > ', FileNameModel], ReasonerCommand)
        %% nl(user), write(user, ReasonerCommand), nl(user), nl(user)
     ;
        RMode = brave  -> ENumMode = brave
        ->
        atomic_list_concat(['cmd.exe /C ', FileNameClingo, ' -e ', ENumMode, ' -n 0 --project ', FileNameASP, ' > ', FileNameModel], ReasonerCommand)
     ;
        RMode = cautious -> ENumMode = cautious
        ->
        atomic_list_concat(['cmd.exe /C ', FileNameClingo, ' -e ', ENumMode, ' -n 0 --project ', FileNameASP, ' > ', FileNameModel], ReasonerCommand)
     )
  ;
     ( OSName = 'Linux' ; OSName = 'Darwin')
        ->
        (
           RMode = normal -> ENumMode = auto
           ->
           atomic_list_concat([FileNameClingo, ' -e ', ENumMode, ' -n 2 --project ', FileNameASP, ' > ', FileNameModel], ReasonerCommand)
        ;
           RMode = brave -> ENumMode = brave
           ->
           atomic_list_concat([FileNameClingo, ' -e ', ENumMode, ' -n 0 --project ', 'asp.lp', ' > ', 'model.txt'], ReasonerCommand)
        ;
           RMode = cautious -> ENumMode = cautious
           ->
           atomic_list_concat([FileNameClingo, ' -e ', ENumMode, ' -n 0 --project ', 'asp.lp', ' > ', 'model.txt'], ReasonerCommand)
        )
  ),
  update_lua_script(FileNameBG, TheoryFlags, BGTheory),
  nl,
  write(user, BGTheory),
  nl, nl,
  write('Write ASP Program to file ...'),
  nl,
  write_to_file(FileNameASP, ASP, BGTheory),
  nl,
  write('Call ASP tool ... '),
  shell(ReasonerCommand, Status),
  nl, nl,
  %% write(Status), nl, nl,
  display_model(user, FileNameModel, _),
  nl, 
  nl.

% -----------------------------------------------------------------------
% write_discourse/1
% -----------------------------------------------------------------------

write_discourse([Sentence]) :-
   write(Sentence).

write_discourse([Sentence|Sentences]) :-
   write(Sentence),
   nl, nl,
   write_discourse(Sentences).


% -----------------------------------------------------------------------
% chart_parser_discourse/6
% -----------------------------------------------------------------------

chart_parser_discourse([], Drs, Ana, Para, Tree, SNum) :-
   nl,
   write('SYNTAX TREES: '),
   reverse(Tree, RTree),
   write_syntax_tree(RTree),
   nl, nl, 
   write('ANAPHORIC EXPRESSIONS: '), 
   nl, nl,
   %%% prepare_anaphoric_expressions(Ana, RAna), 
   write(Ana),  
   reverse_drs(Drs, RDrs1), 
   copy_term(RDrs1, RDrs2),
   numbervars(RDrs1, 0, _),
   nl, nl, nl,
   write('DISCOURSE REPRESENTATION STRUCTURE:'),
   nl, nl,
   write_drs(RDrs1, 0), 
   translate_drs_to_asp(RDrs2, ASP, TheoryFlags),
   numbervars(ASP, 0, _),
   nl, nl, nl,
   write('PARAPHRASE:'),
   nl, nl,
   reverse_paraphrase(Para, RevPara),
   write(RevPara),
   nl, nl, 
   write('ANSWER SET PROGRAM:'),
   nl, nl,
   write_answer_set_program(user, ASP),
   reasoner_environment(OSName, FileNameBG, FileNameClingo, FileNameASP, FileNameModel)
   ->
   (
      OSName = 'Windows_NT'
      ->
      (
         RMode = normal -> ENumMode = auto 
         ->
         atomic_list_concat(['cmd.exe /C ', FileNameClingo, ' -e ', ENumMode, ' -n 2 --project ', FileNameASP, ' > ', FileNameModel], ReasonerCommand),
         nl(user), write(user, ReasonerCommand), nl(user), nl(user)
      ;
         RMode = brave  -> ENumMode = brave
         ->
         atomic_list_concat(['cmd.exe /C ', FileNameClingo, ' -e ', ENumMode, ' -n 0 --project ', FileNameASP, ' > ', FileNameModel], ReasonerCommand)
      ;
         RMode = cautious -> ENumMode = cautious
         ->
         atomic_list_concat(['cmd.exe /C ', FileNameClingo, ' -e ', ENumMode, ' -n 0 --project ', FileNameASP, ' > ', FileNameModel], ReasonerCommand)
      )
   ;
       ( OSName = 'Linux' ; OSName = 'Darwin')
        ->
        (
           RMode = normal -> ENumMode = auto
           ->
           atomic_list_concat([FileNameClingo, ' -e ', ENumMode, ' -n 2 --project ', FileNameASP, ' > ', FileNameModel], ReasonerCommand)
        ;
           RMode = brave -> ENumMode = brave
           ->
           atomic_list_concat([FileNameClingo, ' -e ', ENumMode, ' -n 0 --project ', 'asp.lp', ' > ', 'model.txt'], ReasonerCommand)
        ;
           RMode = cautious -> ENumMode = cautious
           ->
           atomic_list_concat([FileNameClingo, ' -e ', ENumMode, ' -n 0 --project ', 'asp.lp', ' > ', 'model.txt'], ReasonerCommand)
        )
   ), 
   update_lua_script(FileNameBG, TheoryFlags, BGTheory),
   nl,
   write(user, BGTheory),
   nl, nl,
   write('Write ASP Program to file ...'),
   nl,
   write_to_file(FileNameASP, ASP, BGTheory),
   nl,
   write('Call ASP tool ... '), nl,
   shell(ReasonerCommand, Status), 
   write('Status:        '), write(Status), nl,
   nl, nl,
   %% write(Status), nl, nl,
   display_model(user, FileNameModel, _),
   nl,
   nl.

/*
   write('Would you like to continue? (yes./no.)'),
   nl,
   read(Term),
   (
     Term = yes -> true
   ;
     Term = no  ->  abort
   ).
*/

chart_parser_discourse([Sentence|Sentences], DRSIn, AnaIn, ParaIn, TreeIn, SNumIn) :-
   LHS = discourse_element([drs:DRSIn-DRSOut, ana:AnaIn-AnaOut, para:ParaIn-ParaOut, tree:TreeOut]),
   init_chart_parser(LHS, [SNumIn, 0, _]),
   (
      collect_lookahead_anaphora(text, init, SNumIn, 0, LAHCats, AnaEx)
   ;
      true
   ), !,
   nl,
   write(Sentence),
   time(chart_parser_loop(Sentence, SNumIn, 0, NPos)),
   nl, 
   edge(SNumIn, 0, NPos, LHS, _, _),
   SNumOut is SNumIn + 1,
   chart_parser_discourse(Sentences, DRSOut, AnaOut, ParaOut, [TreeOut|TreeIn], SNumOut).


% -----------------------------------------------------------------------
% chart_parser_loop/4
% -----------------------------------------------------------------------

chart_parser_loop([], SNum, SPos, SPos).

chart_parser_loop([Token|Tokens], SNum, SPos, Accu) :-
   EPos is SPos + 1,
   (
      chart_parser([Token], [SNum, SPos, EPos]),
      collect_lookahead_anaphora(text, next, SNum, EPos, LAHCats, AnaEx),
      %% nl, write('LAHCats:            '), write(LAHCats), nl, nl,
      !
   ;
      spelling_checker(text, SNum, SPos, [Token], Solution), 
      nl, write('Unknown Token:      '), write(Token), 
      nl, write('Suggested Spelling: '), write(Solution), nl, nl,
      !, fail
   ),
   % (
   %  collect_lookahead_anaphora(text, next, SNum, EPos, LAHCats, AnaEx),
   % ),
   chart_parser_loop(Tokens, SNum, EPos, Accu).


% -----------------------------------------------------------------------
% dcg_parser_discourse/1
% -----------------------------------------------------------------------

dcg_parser_discourse([drs:D, ana:N, para:P, tree:T], [Sentence]) :-
  nl, nl,
  write(Sentence),
  time(discourse_element([drs:D, ana:N, para:P, tree:T], Sentence, [])).

dcg_parser_discourse([drs:D1-D3, ana:N1-N3, para:P1-P3, tree:[T1|T2]], [Sentence|Discourse]) :-
  nl, nl,
  write(Sentence),
  time(discourse_element([drs:D1-D2, ana:N1-N2, para:P1-P2, tree:T1], Sentence, [])),
  dcg_parser_discourse([drs:D2-D3, ana:N2-N3, para:P2-P3, tree:T2], Discourse).


% -----------------------------------------------------------------------
% write_syntax_tree/1
% -----------------------------------------------------------------------

write_syntax_tree([]).

write_syntax_tree([Tree|Trees]) :-
  nl, nl,
  atom_json_term(FS, json([tree=Tree]), [as(string)]),
  write(FS),
  nl, 
  write_syntax_tree(Trees).


% -----------------------------------------------------------------------
% write_lookahead_categories/1
% -----------------------------------------------------------------------

write_lookahead_categories([]).

write_lookahead_categories([JSONTerm|JSONTerms]) :-
  nl,
  writeq(JSONTerm),
  nl,
  write_lookahead_categories(JSONTerms).



% -----------------------------------------------------------------------
% prepare_anaphoric_expressions/2
%
% -----------------------------------------------------------------------

prepare_anaphoric_expressions([], []).

prepare_anaphoric_expressions([Expression|Expressions], [FlatExpression|FlatExpressions]) :-
  reverse(Expression, RevExpression),
  flatten(RevExpression, FlatExpression),
  prepare_anaphoric_expressions(Expressions, FlatExpressions).


% -----------------------------------------------------------------------
% reverse_paraphrase/2
%
% -----------------------------------------------------------------------

reverse_paraphrase(ParaOut, FlatPara) :-
  reverse(ParaOut, RevPara),
  flatten(RevPara, FlatPara).


% ------------------------------------------------------------------------
% write_discourse/1
% ------------------------------------------------------------------------

write_discourse([]).

write_discourse([Sentence|Sentences]) :-
  write_sentence(Sentence),
  nl, nl,
  write_discourse(Sentences).

write_sentence([]).

write_sentence([Word, '.']) :-
  write(Word),
  write('.').

write_sentence([Word|Words]) :-
  write(Word),
  write(' '),
  write_sentence(Words).


% ------------------------------------------------------------------------
% reverse_drs/2
% ------------------------------------------------------------------------

reverse_drs([drs(U, Con)], [drs(RU, RCon)]) :-
  reverse(U, RU),
  reverse_con(Con, [], RCon).

reverse_con([], Reversed, Reversed).

reverse_con([Drs1 or Drs2|Tail], SoFar, Reversed) :-
  reverse_drs([Drs1], [RDrs1]),
  reverse_drs([Drs2], [RDrs2]),
  reverse_con(Tail, [RDrs1 or RDrs2|SoFar], Reversed).

reverse_con([Drs1 ==> Drs2|Tail], SoFar, Reversed) :-
  reverse_drs([Drs1], [RDrs1]),
  reverse_drs([Drs2], [RDrs2]),
  reverse_con(Tail, [RDrs1 ==> RDrs2|SoFar], Reversed).

reverse_con([Drs1 ~~> Drs2|Tail], SoFar, Reversed) :-
  reverse_drs([Drs1], [RDrs1]),
  reverse_drs([Drs2], [RDrs2]),
  reverse_con(Tail, [RDrs1 ~~> RDrs2|SoFar], Reversed).

reverse_con([cstr (Drs)|Tail], SoFar, Reversed) :-
  reverse_drs([Drs], [RDrs]),
  reverse_con(Tail, [cstr (RDrs)|SoFar], Reversed).

reverse_con([naf (Drs)|Tail], SoFar, Reversed) :-
  reverse_drs([Drs], [RDrs]),
  reverse_con(Tail, [naf (RDrs)|SoFar], Reversed).

reverse_con([neg (Drs)|Tail], SoFar, Reversed) :-
  reverse_drs([Drs], [RDrs]),
  reverse_con(Tail, [neg (RDrs)|SoFar], Reversed).

reverse_con([Head|Tail], SoFar, Reversed) :-
  reverse_con(Tail, [Head|SoFar], Reversed).


% ------------------------------------------------------------------------
% write_drs/1
% ------------------------------------------------------------------------

write_drs([drs(U, Con)], Ind) :-
   write_ref(U, Ind),
   write_con(Con, Ind).

write_drs([drs(U, Con)|Drs], Ind1) :-
   write_ref(U, Ind1),
   write_con(Con, Ind1),
   Ind2 is Ind1 + 3,
   write_drs(Drs, Ind2).

write_ref(U, Ind) :-
   tab(Ind),
   write(U).

write_con([], Ind).

write_con([drs(U, Con) ==> Drs2, cstr (Drs3)|Drs], Ind1) :-
   nl, nl,
   Ind2 is Ind1 + 3,
   write_ref(U, Ind2),
   write_con(Con, Ind2),
   nl,
   tab(Ind2),
   write('==>'),
   nl,
   Ind3 is Ind2 + 3,
   write_drs([Drs2], Ind3),
   write_con([cstr (Drs3)|Drs], Ind1).

write_con([drs(U, Con) ==> Drs2, Drs3 ==> Drs4|Drs], Ind1) :-
   nl, nl,
   Ind2 is Ind1 + 3,
   write_ref(U, Ind2),
   write_con(Con, Ind2),
   nl,
   tab(Ind2),
   write('==>'),
   nl,
   Ind3 is Ind2 + 3,
   write_drs([Drs2], Ind3),
   write_con([Drs3 ==> Drs4|Drs], Ind1).

write_con([drs(U, Con) ==> Drs2|Drs], Ind1) :-
   nl, nl,
   Ind2 is Ind1 + 3,
   write_ref(U, Ind2),
   write_con(Con, Ind2),
   nl,
   tab(Ind2),
   write('==>'),
   nl,
   Ind3 is Ind2 + 3,
   write_drs([Drs2], Ind3),
   nl,
   write_con(Drs, Ind1).

write_con([drs(U, Con) ~~> Drs2|Drs], Ind1) :-
   nl, nl,
   Ind2 is Ind1 + 3,
   write_ref(U, Ind2),
   write_con(Con, Ind2),
   nl,
   tab(Ind2),
   write('~~>'),
   nl,
   Ind3 is Ind2 + 3,
   write_drs([Drs2], Ind3),
   nl,
   write_con(Drs, Ind1).

write_con([drs(U, Con) or Drs2|Drs], Ind1) :-
   nl,
   Ind2 is Ind1 + 3,
   write_ref(U, Ind2),
   write_con(Con, Ind2),
   nl,
   tab(Ind1),
   write('OR'),
   nl,
   write_drs([Drs2], Ind2),
   write_con(Drs, Ind1).

write_con([cstr (drs(U, Con))|Drs], Ind1) :-
   Ind2 is Ind1 + 3,
   nl, nl,
   tab(Ind2),
   write('CSTR'),
   Ind3 is Ind2 + 3,
   nl,
   write_ref(U, Ind3),
   write_con(Con, Ind3),
   write_con(Drs, Ind1).

write_con([naf (drs(U, Con))|Drs], Ind1) :-
   Ind2 is Ind1 + 3,
   nl, 
   tab(Ind2),
   write('NAF'),
   Ind3 is Ind2 + 3,
   nl,
   write_ref(U, Ind3),
   write_con(Con, Ind3),
   write_con(Drs, Ind1).

write_con([neg (drs(U, Con))|Drs], Ind1) :-
   Ind2 is Ind1 + 3,
   nl, 
   tab(Ind2),
   write('NEG'),
   Ind3 is Ind2 + 3,
   nl,
   write_ref(U, Ind3),
   write_con(Con, Ind3),
   write_con(Drs, Ind1).

write_con([Con|Cons], Ind) :-
   nl,
   tab(Ind),
   write(Con),
   write_con(Cons, Ind).


% -----------------------------------------------------------------------
% display_model/3
% -----------------------------------------------------------------------

display_model(Mode, FileName, Atom) :-
   open(FileName, read, Stream),
   read_stream(Stream, CodesList),
   close(Stream),
   atom_codes(Atom, CodesList),
   (
      Mode = json
      ->
      true
   ;
      Mode = user
      ->
      write(Atom)
   ).


% -----------------------------------------------------------------------
% read_stream/2
% -----------------------------------------------------------------------

read_stream(Stream, []) :-
   peek_code(Stream, -1), !.

read_stream(Stream, Chars1) :-
   get_code(Stream, Char),
   (
     Char = 13
     ->
     Chars1 = Chars2
   ;
     Chars1 = [Char|Chars2]
   ),
   read_stream(Stream, Chars2).
