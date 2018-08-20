% ========================================================================
%  Project:   PENG Engine
%  Version:   0.01
%  Module:    json_interface.pl
%  Date:      2013-02-24
%  Modified:  2016-10-11
%  Status:    WORK IN PROGRESS!
%  Author:    Rolf Schwitter
%  Copyright: Macquarie University, 2016
% ========================================================================


% ------------------------------------------------------------------------
% Style checking
% ------------------------------------------------------------------------

:- no_style_check(singleton).
:- no_style_check(discontiguous).


% ------------------------------------------------------------------------
% json_interface/2
%
% - adds new content words and resumes parsing
%
% ------------------------------------------------------------------------

json_interface(json([id=Id, inputmode=IMode, editmode=add, token=TokenAtom, nbest=NBest, featurestructure=FS, filename=FName, spectext=Text,
		     snum=SNumAtom, spos=SPosAtom, reasoner=Flag, reasonermode=RMode]), Output) :-
  atom_json_term(FS, JSONTerm, [as(string)]),
  (
     JSONTerm = json([cat='intransitive verb', wfm=WFM, vform=fin, num=sg]),
     stemmer(remove_suffix, WFM, Base),
     Entry = [lex(intransitive_verb, fin, sg, [WFM], Base),
              lex(intransitive_verb, fin, pl, [Base], Base),
              lex(intransitive_verb, inf,  _, [Base], Base)],
     add_to_lexicon(Entry),
     assert(spelling_lexicon(WFM)),
     assert(spelling_lexicon(Base))
  ;
     JSONTerm = json([cat='intransitive verb', wfm=WFM, vform=fin, num=pl]),
     stemmer(add_suffix, WFM, WFMS),
     Entry = [lex(intransitive_verb, fin, sg, [WFMS], WFM),
              lex(intransitive_verb, fin, pl, [WFM],  WFM),
              lex(intransitive_verb, inf,  _, [WFM],  WFM)],
     add_to_lexicon(Entry),
     assert(spelling_lexicon(WFMS)),
     assert(spelling_lexicon(WFM))
  ;
     JSONTerm = json([cat='intransitive verb', wfm=WFM, vform=inf]),
     stemmer(add_suffix, WFM, WFMS),
     Entry = [lex(intransitive_verb, fin, sg, [WFMS], WFM),
              lex(intransitive_verb, fin, pl, [WFM],  WFM),
              lex(intransitive_verb, inf,  _, [WFM],  WFM)],
     add_to_lexicon(Entry),
     assert(spelling_lexicon(WFMS)),
     assert(spelling_lexicon(WFM))
  ;
     JSONTerm = json([cat='transitive verb', wfm=WFM, vform=fin, num=sg]),
     stemmer(remove_suffix, WFM, Base),
     Entry = [lex(transitive_verb, V,   Num, [WFM],  Base),
              lex(transitive_verb, fin, pl,  [Base], Base),
              lex(transitive_verb, inf,  _, [Base], Base)],
     add_to_lexicon(Entry),
     assert(spelling_lexicon(WFM)),
     assert(spelling_lexicon(Base))
 ;
     JSONTerm = json([cat='transitive verb', wfm=WFM, vform=fin, num=pl]),
     stemmer(add_suffix, WFM, WFMS),
     Entry = [lex(transitive_verb, fin, sg, [WFMS], WFM),
              lex(transitive_verb, fin, pl, [WFM],  WFM),
              lex(transitive_verb, inf,  _, [WFM],  WFM)],
     add_to_lexicon(Entry),
     assert(spelling_lexicon(WFMS)),
     assert(spelling_lexicon(WFM))
  ;
     JSONTerm = json([cat='transitive verb', wfm=WFM, vform=inf]),
     stemmer(add_suffix, WFM, WFMS),
     Entry = [lex(transitive_verb, fin, sg, [WFMS], WFM),
              lex(transitive_verb, fin, pl, [WFM],  WFM),
              lex(transitive_verb, inf,  _, [WFM],  WFM)],
     add_to_lexicon(Entry),
     assert(spelling_lexicon(WFMS)),
     assert(spelling_lexicon(WFM))
  ;
     JSONTerm = json([cat=name, wfm=WFM, num=Num]),
     downcase_atom(WFM, Base),
     Entry = [lex(name, [WFM], Base)],
     add_to_lexicon(Entry),
     assert(spelling_lexicon(WFM))
  ;
     JSONTerm = json([cat='count noun', wfm=WFM, num=sg]),
     stemmer(add_suffix, WFM, WFMS),
     Entry = [lex(count_noun, sg, [WFM],  WFM),
              lex(count_noun, pl, [WFMS], WFM)],
     add_to_lexicon(Entry),
     assert(spelling_lexicon(WFMS)),
     assert(spelling_lexicon(WFM))
  ;
     JSONTerm = json([cat='count noun', wfm=WFM, num=pl]),
     stemmer(remove_suffix, WFM, Base),
     Entry = [lex(count_noun, pl, [WFM],  Base),
              lex(count_noun, sg, [Base], Base)],
     add_to_lexicon(Entry),
     assert(spelling_lexicon(WFM)),
     assert(spelling_lexicon(Base))
  ;
     JSONTerm = json([cat='mass noun', wfm=WFM]),
     downcase_atom(WFM, DBase),
     Entry = [lex(mass_noun, [WFM], DBase)],
     add_to_lexicon(Entry),
     assert(spelling_lexicon(WFM))
  ;
     JSONTerm = json([cat=adjective, wfm=WFM]),
     Entry = [lex(adjective, [WFM], WFM)],
     add_to_lexicon(Entry),
     assert(spelling_lexicon(WFM))
  ;
     JSONTerm = json([cat=adverb, wfm=WFM]),
     Entry = lex(adjverb, [WFM], WFM),
     add_to_lexicon(Entry),
     assert(spelling_lexicon(WFM))
  ),
  (
     atom_number(TokenAtom, Token)
  ;
     TokenAtom = Token
  ),
  atom_number(SNumAtom, SNum),
  atom_number(SPosAtom, SPos),
  %  chart_handler(Id, Token, SNum, SPos, Flag, RMode, Output).
  chart_handler(Id, IMode, Token, NBest, SNum, SPos, Flag, RMode, Output).

% ------------------------------------------------------------------------
% add_to_lexicon/1
%
% ------------------------------------------------------------------------

add_to_lexicon(Entries) :-
  absolute_file_name('prolog/user_lexicon.pl', Absolute),
  open(Absolute, append, Stream),
  add_lexical_entries(Entries, Stream),
  close(Stream).

add_lexical_entries([], Stream).

add_lexical_entries([Entry|Entries], Stream) :-
  assert(Entry),               % assert entry to knowledge base
  writeq(Stream, Entry),       % add entry to user lexicon
  write(Stream, '.'),
  nl(Stream),
  nl(Stream),
  add_lexical_entries(Entries, Stream).


% ------------------------------------------------------------------------
% stemmer/3
%
% ------------------------------------------------------------------------

stemmer(remove_suffix, WFM, Base) :-
  atom_chars(WFM, Chars1),
  (
     append(Chars2, [z, z, e, s], Chars1),
     append(Chars2, [z], CharsBase)
  ;
     append(Chars2, [s, s, e, s], Chars1),
     append(Chars2, [s], CharsBase)
  ;
     append(Chars2, [z, e, s], Chars1),
     append(Chars2, [z], CharsBase)
  ;
     append(Chars2, [c, h, e, s], Chars1),
     append(Chars2, [c, h], CharsBase)
  ;
     append(Chars2, [s, h, e, s], Chars1),
     append(Chars2, [s, h], CharsBase)
  ;
     append(Chars2, [C, i, e, s], Chars1),
     \+ vowel(C),
     append(Chars2, [C, y], CharsBase)
  ;
     append(Chars2, [s], Chars1),
     append(Chars2, [], CharsBase)
  ;
     Chars1 = CharsBase
  ),
  atom_chars(Base, CharsBase).


stemmer(add_suffix, WFM, Base) :-
  atom_chars(WFM, Chars1),
  (
     append(Chars2, [z, z], Chars1),
     append(Chars2, [z, z, e, s], CharsBase)
  ;
     append(Chars2, [s, s], Chars1),
     append(Chars2, [s, s, e, s], CharsBase)
  ;
     append(Chars2, [z], Chars1),
     append(Chars2, [z, e, s], CharsBase)
  ;
     append(Chars2, [c, h], Chars1),
     append(Chars2, [c, h, e, s], CharsBase)
  ;
     append(Chars2, [s, h], Chars1),
     append(Chars2, [s, h, e, s], CharsBase)
  ;
     append(Chars2, [C, y], Chars1),
     \+ vowel(C),
     append(Chars2, [C, i, e, s], CharsBase)
  ;
     append(Chars2, [], Chars1),
     append(Chars2, [s], CharsBase)
  ;
     Chars1 = CharsBase
  ),
  atom_chars(Base, CharsBase).

stemmer(_, WFM, Base) :-
  WFM = Base.


vowel(a).
vowel(e).
vowel(i).
vowel(o).
vowel(u).
vowel(y).


% ------------------------------------------------------------------------
% json_interface/2
%
% - save the current puzzle
%   Example: FName = 'test.txt'
%            Text  = 'Roberta and Thelma are female.'
% ------------------------------------------------------------------------

json_interface(json([id=Id, inputmode=IMode, editmode=save, token=TokenAtom, nbest=NBest, featurestructure=FS, filename=FName, spectext=Text,
		     snum=SNumAtom, spos=SPosAtom, reasoner=Flag, reasonermode=RMode]), Output) :-
  (
     nonvar(FName),
     nonvar(Text),
     atom_concat('prolog/texts/', FName, Path),
     atom_chars(Text, CharList),
     open(Path, write, Stream),
     write_char_list(CharList, Stream),
     close(Stream),
     Output = json([id=Id, saved=yes])
  ;
     Output = json([id=Id, saved=no])
  ).

write_char_list([], Stream).

write_char_list([Char|Chars], Stream) :-
  atom_chars(Atom, [Char]),
  write(Stream, Atom),
  write_char_list(Chars, Stream).


% ------------------------------------------------------------------------
% json_interface/2
%
% - 'load' returns names of all available puzzles; note FName = ' '
% ------------------------------------------------------------------------

json_interface(json([id=Id, inputmode=IMode, editmode=load, token=TokenAtom, nbest=NBest, featurestructure=FS, filename=FName, spectext=Text,
		     snum=SNumAtom, spos=SPosAtom, reasoner=Flag, reasonermode=RMode]), Output) :-
  FName = ' '
  ->
  directory_files('prolog/texts/', Entries),
  filter_entries(Entries, FilteredEntries),
  sort(FilteredEntries, SFilteredEntries),
  Output = json([id=Id, filenames=SFilteredEntries]).

filter_entries([], []).

filter_entries(['.'|Entries], FilteredEntries) :-
  filter_entries(Entries, FilteredEntries).

filter_entries([..|Entries], FilteredEntries) :-
  filter_entries(Entries, FilteredEntries).

filter_entries([Entry|Entries], [Entry|FilteredEntries]) :-
  filter_entries(Entries, FilteredEntries).


% ------------------------------------------------------------------------
% json_interface/2
%
% - mode=load; this loads a specific filename (for example:
%   'jobs-puzzle.txt')
% ------------------------------------------------------------------------

json_interface(json([id=Id, inputmode=IMode, editmode=load, token=TokenAtom, nbest=NBest, featurestructure=FS, filename=FName, spectext=Text,
		     snum=SNumAtom, spos=SPosAtom, reasoner=Flag, reasonermode=RMode]), Output) :-
  FName \= ' '
  ->
  atom_concat('prolog/texts/', FName, Path),
  read_input_file_x(Path, CodeList),
  atom_codes(Atom, CodeList),
  Output = json([id=Id, spectext=Atom]).

read_input_file_x(Path, CodeList) :-
  open(Path, read, Stream),
  read_file_x(Stream, CodeList),
  close(Stream).

read_file_x(Stream, []) :-
  at_end_of_stream(Stream).


read_file_x(Stream, [Code|Codes]) :-
  \+ at_end_of_stream(Stream),
  get_code(Stream, Code),
  read_file_x(Stream, Codes).


% ------------------------------------------------------------------------
% json_interface/2
%
% ------------------------------------------------------------------------

json_interface(json([id=Id, inputmode=IMode, editmode=parse, token=TokenAtom, nbest=NBest, featurestructure=FS, filename=FName, spectext=Text,
		     snum=SNumAtom, spos=SPosAtom, reasoner=Flag, reasonermode=RMode]), Output) :-
  (
     atom_number(TokenAtom, Token)
  ;
     TokenAtom = Token
  ),
  atom_number(SNumAtom, SNum),
  atom_number(SPosAtom, SPos),
  chart_handler(Id, IMode, Token, NBest, SNum, SPos, Flag, RMode, Output).


% ------------------------------------------------------------------------
% json_lexicon/1
%
% ------------------------------------------------------------------------

json_lexicon(json([lexicon=JSONTerms])) :-
  findall(JSONTerm, collect_categories(JSONTerm), JSONTerms).


% ------------------------------------------------------------------------
% chart_handler/9
%
% ------------------------------------------------------------------------

% ------------------------------------------------------------------------
% chart_handler
% initialise first sentence
% ------------------------------------------------------------------------

chart_handler(Id, IMode, Token, NBest, SNum, SPos, Flag, RMode, Output) :-
  Token = ' ',
  SNum  = 1,
  SPos  = 0,
  Flag  = off
  ->
  init_chart_parser(discourse_element([drs:[drs([], [])]-DRSOut, ana:[]-AnaOut, para:[]-ParaOut, tree:TreeIn]), [SNum, SPos, _]),
  collect_lookahead_anaphora(IMode, init, SNum, SPos, LAHCats, AnaEx),
  Output = json([id=Id, lookahead=LAHCats, ana=AnaEx]).


% ------------------------------------------------------------------------
% initialise subsequent sentences
% ------------------------------------------------------------------------

chart_handler(Id, IMode, Token, NBest, SNum, SPos, Flag, RMode, Output) :-
  Token = ' ',
  SNum  > 1,
  SPos  = 0,
  Flag  = off
  ->
  edge_handler_1(SNum, SPos, SNumP, EPosP),
  inspect_chart(SNumP, _, EPosP, DrsIn, AnaIn, ParaIn, RevPara, Tree),
  init_chart_parser(discourse_element([drs:DrsIn-DrsOut, ana:AnaIn-AnaOut, para:ParaIn-ParaOut, tree:TreeIn]), [SNum, SPos, _]),
  collect_lookahead_anaphora(IMode, init, SNum, SPos, LAHCats, AnaEx),
  Output = json([id=Id, lookahead=LAHCats, ana=AnaEx]).


% ------------------------------------------------------------------------
% all other cases
% ------------------------------------------------------------------------

chart_handler(Id, IMode, Token, NBest, SNum, SPos, Flag, RMode, Output) :-
  EPos is SPos + 1,
  edge_handler_2(SNum, EPos),
  (
     % Process full stop
     Token = '.',
     chart_parser([Token], [SNum, SPos, EPos]),
     inspect_chart(SNum, SPos, EPos, Drs, Ana, Para, RevPara, Tree),
     call_reasoner(Flag, RMode, Token, Drs, ASP, Res, Ans),
     LAHCats = [],
     AnaEx   = [],
     Output = json([id=Id, lookahead=LAHCats, ana=AnaEx, answer=Ans, para=RevPara, tree=Tree, asp=ASP, reasoner=Res])
  ;
     % Process question mark
     Token = '?',
     chart_parser([Token], [SNum, SPos, EPos]),
     inspect_chart(SNum, SPos, EPos, Drs, Ana, Para, RevPara, Tree),
     call_reasoner(Flag, RMode, Token, Drs, ASP, Res, Ans),
     LAHCats = [],
     AnaEx   = [],
     % collect_lookahead_anaphora(init, SNum, SPos, LAHCats, AnaEx),
     Output = json([id=Id, lookahead=LAHCats, ana=AnaEx, answer=Ans, para=RevPara, tree=Tree, asp=ASP, reasoner=Res])
  ;
     % Process text token
     IMode == text,
     Flag = off,
     (
        ( spelling_lexicon(Token) ; timex_checker(Token) ),
        chart_parser([Token], [SNum, SPos, EPos]),
        collect_lookahead_anaphora(IMode, next, SNum, EPos, LAHCats, AnaEx),
        Output = json([id=Id, lookahead=LAHCats, ana=AnaEx])
     ;
        spelling_checker(text, SNum, SPos, [Token], Solution),
        Output = json([id=Id, 'spelling suggestions'=Solution])
        %nl(user), write(user, 'Spelling checker text: '), write(user, Solution), nl(user), nl(user)
     )
  ;
     % Process speech token
     IMode == speech,
     Flag = off,
     (
        ( spelling_lexicon(Token) ; timex_checker(Token) ),
	chart_parser([Token], [SNum, SPos, EPos]),
	%% write(user, 'Speech Token: '), write(user, Token), nl(user), nl(user)
        collect_lookahead_anaphora(IMode, next, SNum, EPos, LAHCats, AnaEx),
        Output = json([id=Id, lookahead=LAHCats, ana=AnaEx])
     ;
        process_nbest_list(Token, NBest, NBestTokenList),
        %% write(user, 'NBestTokenList: '), writeq(user, NBestTokenList), nl(user), nl(user),
        ( spelling_checker(speech, SNum, SPos, [Token|NBestTokenList], Solution), ! ; Solution = [] ),
        Output = json([id=Id, 'spelling suggestions'=Solution])
        %write(user, 'Spelling checker: '), writeq(user, Output), nl(user), nl(user)
     )
  ).


% -----------------------------------------------------------------------
% timex_checker/1
%
% -----------------------------------------------------------------------

timex_checker(Token) :-
   atom_codes(Token, [H1, H2, 58, M1, M2]),
   (
      H1 = 48, H2 = 48, M1 = 48, M2 = 48
   ;
      H1 = 48, H2 = 48, M1 = 48, M2 > 48, M2 =< 57
   ;
      H1 = 48, H2 = 48,  M1 > 48, M2 >= 48, M2 =< 57
   ;
      H1 = 48, H2 > 48, H2 =< 57,  M1 >= 48, M1 =< 57, M2 >= 48, M2 =< 57
   ;
      H1 > 48, H1 =< 57, H2 >= 48, H2 =< 57, M1 >= 48, M1 =<57, M2>=48, M2 =< 57
   ).


% -----------------------------------------------------------------------
% process_nbest_list/3
%
% -----------------------------------------------------------------------

process_nbest_list(Token, NBest, NBestTokenList) :-
  term_to_atom(List, NBest),
  nbest_list(List, TokenList),
  remove_duplicates([Token|TokenList], [Token|NBestTokenList]).

nbest_list([], []).

nbest_list([[Atom1, Prob]|Rest1], [Atom2|Rest2]) :-
  atom_codes(Atom1, Chars),
  filter_nbest_chars(Chars, FilteredChars),
  atom_codes(Atom2, FilteredChars),
  nbest_list(Rest1, Rest2).

filter_nbest_chars(Chars1, Chars2) :-
  (
     append(Chars2, [44, 32|Rest], Chars1)
  ;
     append(Chars2, [46, 32|Rest], Chars1)
  ;
     append(Chars2, [63, 32|Rest], Chars1)
  ;
     append(Chars2, [32|Rest], Chars1)
  ;
     Chars1 = Chars2
  ).

% -----------------------------------------------------------------------
% edge_handler_1/4
%
% -----------------------------------------------------------------------

edge_handler_1(SNum1, EPos1, SNumP, EPosP) :-
  (
    find_max_sent_pos(SNum1, EPos1, [SNum2, EPos2]),
    SNum2 >= SNum1,
    check_edges(SNum1, EPos1, SNum2, EPos2)
  ;
    true
  ),
  SNumP is SNum1 - 1,
  find_max_pos(SNumP, EPosP).


% -----------------------------------------------------------------------
% edge_handler_2/2
%
% -----------------------------------------------------------------------

edge_handler_2(SNum1, EPos1) :-
  find_max_sent_pos(SNum1, EPos1, [SNum2, EPos2]),
  check_edges(SNum1, EPos1, SNum2, EPos2).


% -----------------------------------------------------------------------
% find_max_sent_pos/3
%
% -----------------------------------------------------------------------

find_max_sent_pos(SNum1, EPos1, [SNum2, EPos2]) :-
  findall([SNum1, EPos1], edge(SNum1, _, EPos1, _, _, _), Lists),
  (
     Lists = []
     ->
     SNum1 = SNum2,
     EPos1 = EPos2
  ;
     max_list_of_lists(Lists, [SNum2, EPos2])
  ).


% -----------------------------------------------------------------------
% find_max_pos/2
%
% -----------------------------------------------------------------------

find_max_pos(SNum, MaxPos) :-
  findall(EPos, edge(SNum, _, EPos, _, _, _), List),
  max_list(List, MaxPos).


% -----------------------------------------------------------------------
% check_edges/4
%
% -----------------------------------------------------------------------

check_edges(SNum1, EPos1, SNum2, EPos2) :-
  (
     SNum1 =  SNum2,
     EPos2 >= EPos1
     ->
     delete_edges_within_sentence(SNum1, EPos1, EPos2)
  ;
     SNum1 = SNum2
     ->
     true
  ;
     SNum2 > SNum1
     ->
     delete_edges_outside_sentence(SNum1, EPos1, SNum2)
  ).


% -----------------------------------------------------------------------
% delete_edges_within_sentence/3
%
% -----------------------------------------------------------------------

delete_edges_within_sentence(SNum, EPos, EPos) :-
   retractall(edge(SNum, _, EPos, _, _, _)),
   retractall(lookahead(SNum, EPos, _)),
   retractall(compound_word(SNum, _, EPos, _, _, _)),
   retractall(lexicon([cat:Cat, wfm:WF, ref:'+', snum:SNum, spos:EPos|Rest])).

delete_edges_within_sentence(SNum, EPos1, EPos3) :-
   EPos2 is EPos3 - 1,
   retractall(edge(SNum, _, EPos3, _, _, _)),
   retractall(lookahead(SNum, EPos3, _)),
   retractall(compound_word(SNum, _, EPos3, _, _, _)),
   retractall(lexicon([cat:Cat, wfm:WF, ref:'+', snum:SNum, spos:EPos3|Rest])),
   delete_edges_within_sentence(SNum, EPos1, EPos2).


% -----------------------------------------------------------------------
% delete_edges_outside_sentence/3
%
% -----------------------------------------------------------------------

delete_edges_outside_sentence(SNum, EPos1, SNum) :-
  find_max_pos(SNum, EPos2),
  Pos2 >= EPos1,
  delete_edges_within_sentence(SNum, EPos1, EPos2).

delete_edges_outside_sentence(SNum1, EPos1, SNum3) :-
  SNum2 is SNum3 - 1,
  retractall(edge(SNum3, _, EPos3, _, _, _)),
  retractall(lookahead(SNum3, EPos3, _)),
  retractall(compound_word(SNum3, _, EPos3, _, _, _)),
  retractall(lexicon([cat:Cat, wfm:WF, ref:'+', snum:SNum3, spos:EPos3|Rest])),
  delete_edges_outside_sentence(SNum1, EPos1, SNum2).


% -----------------------------------------------------------------------
% collect_lookahead_anaphora/6
%
% -----------------------------------------------------------------------

collect_lookahead_anaphora(IMode, Pos, SNum, SPos, LAHCats, AnaEx) :-
  collect_lookahead_categories(IMode, Pos, SNum, SPos, LAHCats),
  collect_anaphoric_expressions(Pos, SNum, SPos, AnaEx).


collect_lookahead_categories(IMode, Pos, SNum, SPos, LAHCats) :-
  IMode = text,
  (
    setof(L, lookahead(SNum, SPos, L), AVPList),
    %% nl(user), write(user, 'AVPList'), write(user, AVPList), nl(user), nl(user),
    avp_to_json(Pos, SNum, SPos, AVPList, LAHCats)
  ;
     LAHCats = []
  ).


collect_lookahead_categories(IMode, Pos, SNum, SPos, SpeechLAHCats) :-
  IMode = speech,
  (
     setof(L, lookahead(SNum, SPos, L), AVPList),
     avp_to_json(Pos, SNum, SPos, AVPList, LAHCats),
     json_speech_interface(LAHCats, SpeechLAHCats, [])
     %% nl(user), write(user, 'SpeechLAHCats: '), write(user, SpeechLAHCats), nl(user), nl(user)
     %% retractall(lookahead(_))
  ;
     LAHCats = []
  ).


collect_anaphoric_expressions(Pos, SNum, SPos, SAnaEx) :-
  (
     anaphora(Anaphora),
     %% nl(user), nl(user), write(user, 'Anaphora: '), writeq(user, Anaphora), nl(user), nl(user),
     generate_anaphoric_surface_expressions(Pos, SNum, SPos, Anaphora, AnaEx),
     %% nl(user), nl(user), write(user, 'AnaEx: '), writeq(user, AnaEx), nl(user), nl(user),
     sort(AnaEx, SAnaEx),
     retractall(anaphora(_)), !
  ;
     SAnaEx = []
  ).


% -----------------------------------------------------------------------
% generate_anaphoric_surface_expressions/5
%
% -----------------------------------------------------------------------

generate_anaphoric_surface_expressions(Pos, SNum, SPos, Var, []) :- var(Var).

generate_anaphoric_surface_expressions(Pos, SNum, SPos, [], []).

generate_anaphoric_surface_expressions(Pos, SNum, SPos, [['<sub>']], []).

generate_anaphoric_surface_expressions(Pos, SNum, SPos, [['</sub>']|Rest], AnaEx) :-
  append(SubList, [['<sub>']|List], Rest),
  filter_anaphoric_expressions(Pos, SubList, SubListOfElements),
  generate_anaphoric_surface_expressions(Pos, SNum, SPos, List, ListOfElements),
  append(SubListOfElements, ListOfElements, AnaEx).

generate_anaphoric_surface_expressions(next, SNum, SPos, [[ListOfElements]|Rest], [ListOfElements|AnaEx]) :-
  check_atomic_elements(ListOfElements),
  generate_anaphoric_surface_expressions(next, SNum, SPos, Rest, AnaEx).

generate_anaphoric_surface_expressions(init, SNum, SPos, [[ListOfElements1]|Rest], [ListOfElements2|AnaEx]) :-
  check_atomic_elements(ListOfElements1),
  check_first_code_uppercase(ListOfElements1, ListOfElements2),
  generate_anaphoric_surface_expressions(init, SNum, SPos, Rest, AnaEx).

generate_anaphoric_surface_expressions(Pos, SNum, SPos, [List|Rest], [ListOfElements2|AnaEx]) :-
  is_list(List),
  generate_anaphoric_surface_expression(Pos, List, ListOfElements1),
  construct_temp_lexicon(SNum, SPos, ListOfElements1, ListOfElements2),
  generate_anaphoric_surface_expressions(Pos, SNum, SPos, Rest, AnaEx).


% -----------------------------------------------------------------------
% filter_anaphoric_expressions/3
%
% -----------------------------------------------------------------------

filter_anaphoric_expressions(Pos, [], []).

filter_anaphoric_expressions(next, [[ListOfElements]|Lists1], [ListOfElements|Lists2]) :-
  check_atomic_elements(ListOfElements),
  filter_anaphoric_expressions(next, Lists1, Lists2).

filter_anaphoric_expressions(init, [[ListOfElements1]|Lists1], [ListOfElements2|Lists2]) :-
  check_atomic_elements(ListOfElements1),
  check_first_code_uppercase(ListOfElements1, ListOfElements2),
  filter_anaphoric_expressions(init, Lists1, Lists2).

filter_anaphoric_expressions(Pos, [ListOfLists|Lists1], Lists2) :-
  filter_anaphoric_expressions(Pos, Lists1, Lists2).


% -----------------------------------------------------------------------
% generate_anaphoric_surface_expression/3
%
% -----------------------------------------------------------------------

generate_anaphoric_surface_expression(next, ListOfLists, ListOfElements) :-
  reverse(ListOfLists, RevListOfLists),
  flatten(RevListOfLists, ListOfElements).

generate_anaphoric_surface_expression(init, ListOfLists, ListOfElements2) :-
  reverse(ListOfLists, RevListOfLists),
  flatten(RevListOfLists, ListOfElements1),
  check_first_code_uppercase(ListOfElements1, ListOfElements2).


% -----------------------------------------------------------------------
% check_atomic_elements/1
%
% -----------------------------------------------------------------------

check_atomic_elements([]).

check_atomic_elements([Element|Elements]) :-
  Element \= '<sub>',
  %% nl(user), nl(user), write(user, 'Element: '), write(user, Element), nl(user), nl(user),
  atomic(Element),
  check_atomic_elements(Elements).


% -----------------------------------------------------------------------
% check_first_code_uppercase/2
%
% -----------------------------------------------------------------------

check_first_code_uppercase([ElementIn|Elements], [ElementOut|Elements]) :-
  (
     atom(ElementIn)
     ->
     atom_codes(ElementIn, [Code1|Codes]),
     (
        Code1 >= 97, Code1 =< 122
        ->
        Code2 is Code1 - 32
     ;
        Code2 = Code1
     ),
     atom_codes(ElementOut, [Code2|Codes])
  ;
     compound(ElementIn)
     ->
     ElementIn =.. [Functor, [Element1|Rest]],
     atom_codes(Element1, [Code1|Codes]),
     (
        Code1 >= 97, Code1 =< 122
        ->
        Code2 is Code1 - 32
     ;
        Code2 = Code1
     ),
     atom_codes(Element2, [Code2|Codes]),
     ElementOut =.. [Functor, [Element2|Rest]]
  ).


% -----------------------------------------------------------------------
% construct_temp_lexicon/4
%
% -----------------------------------------------------------------------

construct_temp_lexicon(SNum, SPos, [], []).

construct_temp_lexicon(SNum, SPos, [adjective(WF)|ListOfElements1], ListOfElements3) :-
  lexicon([cat:adjective, wfm:WF, evtl:I, con:Con]),
  asserta(lexicon([cat:adjective, wfm:WF, ref:'+', snum:SNum, spos:SPos, evtl:I, con:Con])),
  construct_temp_lexicon(SNum, SPos, ListOfElements1, ListOfElements2),
  append(WF, ListOfElements2, ListOfElements3).

construct_temp_lexicon(SNum, SPos, [ordinal(WF)|ListOfElements1], ListOfElements3) :-
  lexicon([cat:ordinal, wfm:WF, arg:A, con:Con]),
  asserta(lexicon([cat:ordinal, wfm:WF, ref:'+', snum:SNum, spos:SPos, arg:A, con:Con])),
  construct_temp_lexicon(SNum, SPos, ListOfElements1, ListOfElements2),
  append(WF, ListOfElements2, ListOfElements3).

construct_temp_lexicon(SNum, SPos, [count_noun(WF)|ListOfElements1], ListOfElements3) :-
  lexicon([cat:count_noun, wfm:WF, arg:[num:N, ind:I], con:Con]),
  asserta(lexicon([cat:count_noun, wfm:WF, ref:'+', snum:SNum, spos:SPos, arg:[num:N, ind:I], con:Con])),
  construct_temp_lexicon(SNum, SPos, ListOfElements1, ListOfElements2),
  append(WF, ListOfElements2, ListOfElements3).

construct_temp_lexicon(SNum, SPos, [determiner([the])|ListOfElements1], ListOfElements3) :-
  lexicon([cat:determiner, wfm:[the], arg:[num:N, ind:I], qnt:Q]),
  asserta(lexicon([cat:determiner, wfm:[the], ref:'+', snum:SNum, spos:SPos, arg:[num:N, ind:I], qnt:Q])),
  asserta(lexicon([cat:determiner, wfm:[that], ref:'+', snum:SNum, spos:SPos, arg:[num:N, ind:I], qnt:Q])),
  construct_temp_lexicon(SNum, SPos, ListOfElements1, ListOfElements2),
  append([the], ListOfElements2, ListOfElements3).

construct_temp_lexicon(SNum, SPos, [determiner(WF)|ListOfElements1], ListOfElements3) :-
  lexicon([cat:determiner, wfm:WF, arg:[num:N, ind:I], qnt:Q]),
  asserta(lexicon([cat:determiner, wfm:WF, ref:'+', snum:SNum, spos:SPos, arg:[num:N, ind:I], qnt:Q])),
  construct_temp_lexicon(SNum, SPos, ListOfElements1, ListOfElements2),
  append(WF, ListOfElements2, ListOfElements3).

construct_temp_lexicon(SNum, SPos, [preposition(WF)|ListOfElements1], ListOfElements3) :-
  lexicon([cat:preposition, wfm:WF, arg:A1, arg:A2, con:Con]),
  asserta(lexicon([cat:preposition, wfm:WF, ref:'+', snum:SNum, spos:SPos, arg:A1, arg:A2, con:Con])),
  construct_temp_lexicon(SNum, SPos, ListOfElements1, ListOfElements2),
  append(WF, ListOfElements2, ListOfElements3).

construct_temp_lexicon(SNum, SPos, [numeric_variable(WF)|ListOfElements1], ListOfElements3) :-
  lexicon([cat:numeric_variable, wfm:WF, arg:A1, arg:A2, con:Con]),
  asserta(lexicon([cat:numeric_variable, wfm:WF, ref:'+', snum:SNum, spos:SPos, arg:A1, arg:A2, con:Con])),
  construct_temp_lexicon(SNum, SPos, ListOfElements1, ListOfElements2),
  append(WF, ListOfElements2, ListOfElements3).

construct_temp_lexicon(SNum, SPos, [string_variable(WF)|ListOfElements1], ListOfElements3) :-
  lexicon([cat:string_variable, wfm:WF, arg:A, con:Con]),
  asserta(lexicon([cat:string_variable, wfm:WF, ref:'+', snum:SNum, spos:SPos, arg:A, con:Con])),
  construct_temp_lexicon(SNum, SPos, ListOfElements1, ListOfElements2),
  append(WF, ListOfElements2, ListOfElements3).

construct_temp_lexicon(SNum, SPos, [Element|ListOfElements1], [Element|ListOfElements2]) :-
  construct_temp_lexicon(SNum, SPos, ListOfElements1, ListOfElements2).


% -----------------------------------------------------------------------
% json_speech_interface/3
% -----------------------------------------------------------------------

json_speech_interface([], [json([cat='function words', wfm=SWF])], WFFunc) :-
  WFFunc \= [],
  sort(WFFunc, SWF).

json_speech_interface([], [], []).

json_speech_interface(JSONList1, [json([cat=adjectives, wfm=SWF])|Rest2], WFFunc) :-
  nth0(I1, JSONList1, json([cat='adjective', wfm=WF1|LAH1]), JSONList2),
  nth0(I2, JSONList2, json([cat='relational adjective', wfm=WF2|LAH2]), JSONList3),
  append(WF1, WF2, WF3),
  sort(WF3, SWF),
  json_speech_interface(JSONList3, Rest2, WFFunc).

json_speech_interface([json([cat=adjective, wfm=WF|LAH])|Rest1], [json([cat=adjectives, wfm=WF|LAH])|Rest2], WFFunc) :-
  json_speech_interface(Rest1, Rest2, WFFunc).

json_speech_interface([json([cat=adverb, wfm=WF|LAH])|Rest1], [json([cat=adverbs, wfm=WF|LAH])|Rest2], WFFunc) :-
  json_speech_interface(Rest1, Rest2, WFFunc).

json_speech_interface(JSONList1, [json([cat=names, wfm=SWF, num=sg])|Rest2], WFFunc) :-
  nth0(I1, JSONList1, json([cat='name', wfm=WF1|LAH1]), JSONList2),
  nth0(I2, JSONList2, json([cat='numeric variable', wfm=WF2|LAH2]), JSONList3),
  nth0(I3, JSONList3, json([cat='string variable', wfm=WF3|LAH3]), JSONList4),
  append(WF1, WF2, WFI),
  append(WFI, WF3, WF4),
  sort(WF4, SWF),
  json_speech_interface(JSONList4, Rest2, WFFunc).

json_speech_interface(JSONList1, [json([cat=names, wfm=SWF, num=sg])|Rest2], WFFunc) :-
  nth0(I2, JSONList1, json([cat='variable (numeric)', wfm=WF1|LAH1]), JSONList2),
  nth0(I2, JSONList2, json([cat='variable (string)', wfm=WF2|LAH2]), JSONList3),
  append(WF1, WF2, WF3),
  sort(WF3, SWF),
  json_speech_interface(JSONList3, Rest2, WFFunc).

json_speech_interface([json([cat=name, wfm=WF|LAH])|Rest1], [json([cat=names, wfm=WF|LAH])|Rest2], WFFunc) :-
  json_speech_interface(Rest1, Rest2, WFFunc).

json_speech_interface([json([cat='variable (numeric)', wfm=WF|LAH])|Rest1], [json([cat=names, wfm=WF|LAH])|Rest2], WFFunc) :-
  json_speech_interface(Rest1, Rest2, WFFunc).

json_speech_interface([json([cat='variable (string)', wfm=WF|LAH])|Rest1], [json([cat=names, wfm=WF|LAH])|Rest2], WFFunc) :-
  json_speech_interface(Rest1, Rest2, WFFunc).

json_speech_interface(JSONList1, [json([cat=nouns, wfm=SWF])|Rest2], WFFunc) :-
  nth0(I1, JSONList1, json([cat='count noun', wfm=WF1|LAH1]), JSONList2),
  nth0(I2, JSONList2, json([cat='mass noun', wfm=WF2|LAH2]), JSONList3),
  append(WF1, WF2, WF3),
  sort(WF3, SWF),
  json_speech_interface(JSONList3, Rest2, WFFunc).

json_speech_interface([json([cat='count noun', wfm=WF|LAH])|Rest1], [json([cat=nouns, wfm=WF|LAH])|Rest2], WFFunc) :-
  json_speech_interface(Rest1, Rest2, WFFunc).

json_speech_interface([json([cat='mass noun', wfm=WF|LAH])|Rest1], [json([cat=nouns, wfm=WF|LAH])|Rest2], WFFunc) :-
  json_speech_interface(Rest1, Rest2, WFFunc).

json_speech_interface(JSONList1, [json([cat=verbs, wfm=SWF, num=sg, vform=fin])|Rest2], WFFunc) :-
  nth0(I1, JSONList1, json([cat='intransitive verb', wfm=WF1, num=sg, vform=fin]), JSONList2),
  nth0(I2, JSONList2, json([cat='transitive verb', wfm=WF2, num=sg, vform=fin]), JSONList3),
  nth0(I3, JSONList3, json([cat=copula, wfm=WF3]), JSONList4),
  append(WF1, WF2, WFI),
  append(WFI, WF3, WF4),
  sort(WF4, SWF),
  json_speech_interface(JSONList4, Rest2, WFFunc).

json_speech_interface(JSONList1, [json([cat=verbs, wfm=SWF, num=pl, vform=fin])|Rest2], WFFunc) :-
  nth0(I1, JSONList1, json([cat='intransitive verb', wfm=WF1, num=pl, vform=fin]), JSONList2),
  nth0(I2, JSONList2, json([cat='transitive verb', wfm=WF2, num=pl, vform=fin]), JSONList3),
  nth0(I3, JSONList3, json([cat=copula, wfm=WF3]), JSONList4),
  append(WF1, WF2, WFI),
  append(WFI, WF3, WF4),
  sort(WF4, SWF),
  json_speech_interface(JSONList4, Rest2, WFFunc).

json_speech_interface(JSONList1, [json([cat=verbs, wfm=SWF, vform=inf])|Rest2], WFFunc) :-
  nth0(I1, JSONList1, json([cat='intransitive verb', wfm=WF1, vform=inf]), JSONList2),
  nth0(I2, JSONList2, json([cat='transitive verb', wfm=WF2,  vform=inf]), JSONList3),
  append(WF1, WF2, WF3),
  sort(WF3, SWF),
  json_speech_interface(JSONList3, Rest2, WFFunc).

json_speech_interface([json([cat=compound, wfm=WF|LAH])|Rest1], [json([cat=compound, wfm=WF|LAH])|Rest2], WFFunc) :-
  json_speech_interface(Rest1, Rest2, WFFunc).

json_speech_interface([json([cat='full stop', wfm=WF|LAH])|Rest1], [json([cat='punctuation mark', wfm=WF|LAH])|Rest2], WFFunc) :-
  json_speech_interface(Rest1, Rest2, WFFunc).

json_speech_interface([json([cat='question mark', wfm=WF|LAH])|Rest1], [json([cat='punctuation mark', wfm=WF|LAH])|Rest2], WFFunc) :-
  json_speech_interface(Rest1, Rest2, WFFunc).

json_speech_interface([json([cat=comma, wfm=WF|LAH])|Rest1], [json([cat='punctuation mark', wfm=WF|LAH])|Rest2], WFFunc) :-
  json_speech_interface(Rest1, Rest2, WFFunc).

json_speech_interface([json([cat=Cat, wfm=WF|LAH])|Rest1], JSONTermList, WFIn) :-
  append(WF, WFIn, WFOut),
  json_speech_interface(Rest1, JSONTermList, WFOut).


% -----------------------------------------------------------------------

avp_to_json(_, _, _,  [], []).

% -----------------------------------------------------------------------

avp_to_json(init, SNum, SPos,  [[cat:determiner, wfm:[], num:Num, qnt:Q]|Rest1], [json([cat=determiner, wfm=SWfms])|Rest3]) :-
  collect_determiners(init, [[cat:determiner, wfm:[], num:Num, qnt:Q]|Rest1], [], Rest2, Wfms),
  filter_out_lower_cases(Wfms, FWfms),
  sort(FWfms, SWfms),
  avp_to_json(init, SNum, SPos, Rest2, Rest3).

collect_determiners(init, [], Wfms, Rest2, Wfms).

collect_determiners(init, [[cat:determiner, wfm:[], num:Num, qnt:Q]|Rest1], Wfms1, Rest2, Wfms3) :-
  findall(Wfm, lexicon([cat:determiner, wfm:Wfm, arg:[num:Num, ind:I], qnt:Q|Rest]), Wfms),
  append(Wfms, Wfms1, Wfms2),
  collect_determiners(init, Rest1, Wfms2, Rest2, Wfms3).

collect_determiners(init, [Class|Rest1], Wfms1, [Class|Rest2], Wfms3) :-
  collect_determiners(init, Rest1, Wfms1, Rest2, Wfms3).


avp_to_json(init, SNum, SPos, [[cat:ex_there, wfm:[]]|Rest1], [json([cat='existential there', wfm=[['There', is], ['There', are]]])|Rest2]) :-
  avp_to_json(init, SNum, SPos, Rest1, Rest2).


avp_to_json(init, SNum, SPos, [[cat:constraint, wfm:[]]|Rest1], [json([cat=constraint, wfm=[['Exclude'], ['It', is, not, the, case]]])|Rest2]) :-
  avp_to_json(init, SNum, SPos, Rest1, Rest2).


avp_to_json(init, SNum, SPos, [[cat:string_variable, wfm:[]]|Rest1], [json([cat='variable (string)', wfm=SWfms])|Rest2]) :-
  findall(Wfm, lexicon([cat:string_variable, wfm:Wfm|Rest]), Wfms),
  sort(Wfms, SWfms),
  avp_to_json(init, SNum, SPos, Rest1, Rest2).


avp_to_json(init, SNum, SPos, [[cat:preposition, wfm:[]]|Rest1], [json([cat='preposition', wfm=SWfms])|Rest2]) :-
  findall(Wfm, lexicon([cat:preposition, wfm:Wfm]), Wfms),
  sort(Wfms, SWfms),
  avp_to_json(init, SNum, SPos, Rest1, Rest2).

avp_to_json(init, SNum, SPos,  [[cat:Cat, wfm:_|R]|Rest1], [json([cat='query word',
                   wfm=[['Are'], ['Do'], ['Does'], ['Is'], ['How', many], ['What'], ['Where'], ['Which'], ['Who']]])|Rest7]) :-
  (
    Cat = wh_determiner
  ;
    Cat = auxiliary
  ;
    Cat = wh_pronoun
  ;
    Cat = wh_adverb
  ;
    Cat = copula
  ),
  delete(Rest1, [cat:wh_determiner, wfm:_|R1], Rest2),
  delete(Rest2, [cat:auxiliary, wfm:_|R2], Rest3),
  delete(Rest3, [cat:wh_pronoun, wfm:_|R2], Rest4),
  delete(Rest4, [cat:wh_adverb, wfm:_|R4], Rest5),
  delete(Rest5, [cat:copula, wfm:[], num:_|R5], Rest6), 
  avp_to_json(init, SNum, SPos, Rest6, Rest7).

avp_to_json(init, SNum, SPos, [[cat:name, wfm:[], num:Num]|Rest1], [json([cat=name, wfm=Wfms3, num=sg])|Rest2]) :-
  findall(Wfm, lexicon([cat:name, wfm:Wfm, arg:[num:Num, ind:I]|Rest]), Wfms1),
  filter_out_lower_cases(Wfms1, Wfms2),
  sort(Wfms2, Wfms3),
  \+ Wfms3 = [],
  avp_to_json(init, SNum, SPos, Rest1, Rest2).

avp_to_json(init, SNum, SPos, [[cat:mass_noun, wfm:[], num:Num]|Rest1], [json([cat='mass noun', wfm=Wfms3])|Rest2]) :-
  findall(Wfm, lexicon([cat:mass_noun, wfm:Wfm, arg:[num:Num, ind:I]|Rest]), Wfms1),
  filter_out_lower_cases(Wfms1, Wfms2),
  sort(Wfms2, Wfms3),
  \+ Wfms3 = [],
  avp_to_json(init, SNum, SPos, Rest1, Rest2).


avp_to_json(init, SNum, SPos, [[cat:count_noun, wfm:[], num:pl]|Rest1], [json([cat='count noun', wfm=Wfms3, num=pl])|Rest2]) :-
  findall(Wfm, lexicon([cat:count_noun, wfm:Wfm, arg:[num:pl, ind:I]|Rest]), Wfms1),
  filter_out_lower_cases(Wfms1, Wfms2),
  sort(Wfms2, Wfms3),
  \+ Wfms3 = [],
  avp_to_json(init, SNum, SPos, Rest1, Rest2).

filter_out_lower_cases([], []).

filter_out_lower_cases([[Wfm|Rest]|Wfms1], [[Wfm|Rest]|Wfms2]) :-
  atom_codes(Wfm, [Code|Codes]),
  Code >= 65, Code =< 90,
  filter_out_lower_cases(Wfms1, Wfms2).

filter_out_lower_cases([Wfm|Wfms1], Wfms2) :-
  filter_out_lower_cases(Wfms1, Wfms2).


avp_to_json(init, SNum, SPos, [[cat:Cat, wfm:[Wfm], num:Num]|Rest1], [json([cat=Cat, wfm=[[Wfm]], num=Num])|Rest2]) :-
  nonvar(Wfm),
  atom_codes(Wfm, [Code|Codes]),
  Code >= 65, Code =< 90,
  avp_to_json(init, SNum, SPos, Rest1, Rest2).

avp_to_json(init, SNum, SPos, [[cat:Cat, wfm:[Wfm]]|Rest1], [json([cat=Cat, wfm=[[Wfm]]])|Rest2]) :-
  nonvar(Wfm),
  atom_codes(Wfm, [Code|Codes]),
  Code >= 65, Code =< 90,
  avp_to_json(init, SNum, SPos, Rest1, Rest2).


avp_to_json(init, SNum, SPos, [[cat:Cat, wfm:Wfm, num:Num]|Rest1], [json([cat=Cat, wfm=Wfm, num=Num])|Rest2]) :-
  var(Wfm),
  avp_to_json(init, SNum, SPos, Rest1, Rest2).

avp_to_json(init, SNum, SPos, [[cat:Cat, wfm:Wfm]|Rest1], [json([cat=Cat, wfm=Wfm])|Rest2]) :-
  var(Wfm),
  avp_to_json(init, SNum, SPos, Rest1, Rest2).

avp_to_json(init, SNum, SPos, [[cat:Cat, wfm:Wfm, num:Num]|Rest1], Rest2) :-
  avp_to_json(init, SNum, SPos,  Rest1, Rest2).

avp_to_json(init, SNum, SPos, [[cat:Cat, wfm:Wfm]|Rest1], Rest2) :-
  avp_to_json(init, SNum, SPos, Rest1, Rest2).


% -----------------------------------------------------------------------

avp_to_json(next, SNum, SPos, [[cat:determiner, wfm:[], ref:'+']|Rest1], Result) :-
  avp_to_json(next, SNum, SPos, Rest1, Result).


avp_to_json(next, SNum, SPos, [[cat:determiner, wfm:[], num:Num, qnt:Q]|Rest1], [json([cat=determiner, wfm=SWfms])|Rest3]) :-
  collect_determiners(next, [[cat:determiner, wfm:[], num:Num, qnt:Q]|Rest1], [], Rest2, Wfms),
  filter_out_upper_cases(Wfms, FWfms),
  sort(FWfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest2, Rest3).

collect_determiners(next, [], Wfms, Rest2, Wfms).

collect_determiners(next, [[cat:determiner, wfm:[], num:Num, qnt:Q]|Rest1], Wfms1, Rest2, Wfms3) :-
  findall(Wfm, lexicon([cat:determiner, wfm:Wfm, arg:[num:Num, ind:I], qnt:Q|Rest]), Wfms),
  append(Wfms, Wfms1, Wfms2),
  collect_determiners(next, Rest1, Wfms2, Rest2, Wfms3).

collect_determiners(next, [Class|Rest1], Wfms1, [Class|Rest2], Wfms3) :-
  collect_determiners(next, Rest1, Wfms1, Rest2, Wfms3).


avp_to_json(next, SNum, SPos, [[cat:wh_determiner, wfm:[]]|Rest1],
	           [json([cat=wh_determiner, wfm=[[what], [which]]])|Rest2]) :-
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:number, wfm:[], num:Num]|Rest1], [json([cat=number, wfm=SWfms])|Rest2]) :-
  findall(Wfm, lexicon([cat:number, wfm:Wfm, arg:[num:Num, ind:I]|Rest]), Wfms),
  sort(Wfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

%
% For Stephen 2/3/2015: exactly Number
%

% avp_to_json(next, SNum, SPos, [[cat:cardinal, wfm:[exactly|R], num:Num]|Rest1], [json([cat=cardinal, wfm=[exactly, '<ins>Number</ins>']])|Rest2]) :-
%  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:cardinal, wfm:[W|R], num:Num]|Rest1], [json([cat=cardinal, wfm=SWfms])|Rest2]) :-
  var(Num),
  findall([W|R2], lexicon([cat:cardinal, wfm:[W|R2], arg:[num:Num, ind:I]|Rest]), Wfms),
  sort(Wfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:cardinal, wfm:[W|R], num:Num]|Rest1], [json([cat=cardinal, wfm=SWfms, num=Num])|Rest2]) :-
  findall([W|R2], lexicon([cat:cardinal, wfm:[W|R2], arg:[num:Num, ind:I]|Rest]), Wfms),
  sort(Wfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).


% avp_to_json(next, SNum, SPos, [[cat:ordinal, wfm:[], ref:'+']|Rest1], [json([cat=ordinal, wfm=SWfms])|Rest2]) :-
%  findall(WF, lexicon([cat:ordinal, wfm:WF, ref:'+', snum:_, spos:_, arg:[num:Num, ind:I]|Rest]), Wfms),
%  sort(Wfms, SWfms),
%  avp_to_json(next, SNum, SPos, Rest1, Rest2).


avp_to_json(next, SNum, SPos, [[cat:ordinal, wfm:[], ref:'+']|Rest1], Rest2) :-
  findall(WF, lexicon([cat:ordinal, wfm:WF, ref:'+', snum:_, spos:_, arg:[num:Num, ind:I]|Rest]), Wfms),
  sort(Wfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).


avp_to_json(next, SNum, SPos, [[cat:ordinal, wfm:[]]|Rest1], [json([cat=ordinal, wfm=SWfms])|Rest2]) :-
  findall(WF, lexicon([cat:ordinal, wfm:WF, arg:[num:Num, ind:I]|Rest]), Wfms),
  sort(Wfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).


% avp_to_json(next, SNum, SPos, [[cat:adjective, wfm:[]]|Rest1], [json([cat=adjective, wfm=SWfms])|Rest2]) :-
%  findall(Wfm, lexicon([cat:adjective, wfm:Wfm]), Wfms),
%  sort(Wfms, SWfms),
%  avp_to_json(next, SNum, SPos, Rest1, Rest2).

% avp_to_json(next, SNum, SPos, [[cat:adjective, wfm:[], ref:'+', evtl:[]]|Rest1], Rest2) :-
%  findall(Wfm, lexicon([cat:adjective, wfm:Wfm, ref:'+', snum:_, spos:_, evtl:E|Rest]), Wfms),
%  filter_out_upper_cases(Wfms, FWfms),
%  sort(FWfms, SWfms),
%  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:adjective, wfm:[], ref:'+', evtl:[]]|Rest1], Result) :-
  findall(Wfm, lexicon([cat:adjective, wfm:Wfm, ref:'+', snum:_, spos:_, evtl:E|Rest]), Wfms),
  (
     Wfms = []
     ->
     Result = Rest2
  ;
     filter_out_upper_cases(Wfms, FWfms),
     sort(FWfms, SWfms),
     Result = [json([cat=adjective, wfm=SWfms])|Rest2]
  ),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:adjective, wfm:[], evtl:[]]|Rest1], [json([cat=adjective, wfm=SWfms])|Rest2]) :-
  findall(Wfm, lexicon([cat:adjective, wfm:Wfm, evtl:E|Rest]), Wfms),
  filter_out_upper_cases(Wfms, FWfms),
  sort(FWfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:adjective, wfm:[]]|Rest1], [json([cat=adjective, wfm=SWfms])|Rest2]) :-
  findall(Wfm, lexicon([cat:adjective, wfm:Wfm]), Wfms),
  sort(Wfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:count_noun, wfm:[], ref:'+', num:sg]|Rest1], [json([cat='count noun', wfm=SWfms, num=sg])|Rest2]) :-
  findall(Wfm, lexicon([cat:count_noun, wfm:Wfm, ref:'+', snum:_, spos:_, arg:[num:sg, ind:I]|Rest]), Wfms),
  sort(Wfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:count_noun, wfm:[], num:sg]|Rest1], [json([cat='count noun', wfm=SWfms, num=sg])|Rest2]) :-
  findall(Wfm, lexicon([cat:count_noun, wfm:Wfm, arg:[num:sg, ind:I]|Rest]), Wfms),
  sort(Wfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:count_noun, wfm:[], num:pl]|Rest1], [json([cat='count noun', wfm=SWfms, num=pl])|Rest2]) :-
  findall(Wfm, lexicon([cat:count_noun, wfm:Wfm, arg:[num:pl, ind:I]|Rest]), Wfms),
  filter_out_upper_cases(Wfms, FWfms),
  sort(FWfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:temporal_expression, wfm:[]]|Rest1], [json([cat='temporal expression', wfm=[['HH:MM']]])|Rest2]) :-
    avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:name, wfm:[], num:Num]|Rest1], [json([cat=name, wfm=SWfms, num=Num])|Rest2]) :-
  findall(Wfm, lexicon([cat:name, wfm:Wfm, arg:[num:Num, ind:I]|Rest]), Wfms),
  sort(Wfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:mass_noun, wfm:[], num:Num]|Rest1], [json([cat='mass noun', wfm=SWfms])|Rest2]) :-
  findall(Wfm, lexicon([cat:mass_noun, wfm:Wfm, arg:[num:Num, ind:I]|Rest]), Wfms),
  filter_out_upper_cases(Wfms, FWfms),
  sort(FWfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:relative_pronoun, wfm:_]|Rest1], [json([cat='relative pronoun', wfm=SWfms])|Rest2]) :-
  findall(Wfm, lexicon([cat:relative_pronoun, wfm:Wfm|Rest]), Wfms),
  sort(Wfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:transitive_verb, wfm:[], num:Num, vform:V]|Rest1], [json([cat='transitive verb', wfm=SWfms, num=Num, vform=V])|Rest2]) :-
  nonvar(Num),
  findall(Wfm, lexicon([cat:transitive_verb, wfm:Wfm, arg:[num:Num, ind:I1], arg:[num:_, ind:I2], vform:V, evtl:E|Rest]), Wfms),
  sort(Wfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:intransitive_verb, wfm:[], num:Num, vform:V]|Rest1], [json([cat='intransitive verb', wfm=SWfms, num=Num, vform=V])|Rest2]) :-
  nonvar(Num),
  findall(Wfm, lexicon([cat:intransitive_verb, wfm:Wfm, arg:[num:Num, ind:I], vform:V, evtl:E|Rest]), Wfms),
  sort(Wfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:transitive_verb, wfm:[], vform:V]|Rest1], [json([cat='transitive verb', wfm=SWfms, vform=V])|Rest2]) :-
  findall(Wfm, lexicon([cat:transitive_verb, wfm:Wfm, arg:[num:Num, ind:I1], arg:[num:_, ind:I2], vform:V, evtl:E|Rest]), Wfms),
  sort(Wfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:intransitive_verb, wfm:[], vform:V]|Rest1], [json([cat='intransitive verb', wfm=SWfms, vform=V])|Rest2]) :-
  findall(Wfm, lexicon([cat:intransitive_verb, wfm:Wfm, arg:[num:Num, ind:I], vform:V, evtl:E|Rest]), Wfms),
  sort(Wfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:auxiliary, wfm:[], num:Num]|Rest1], [json([cat=auxiliary, wfm=FWfms, num=Num])|Rest2]) :-
  findall(Wfm, lexicon([cat:auxiliary, wfm:Wfm, arg:[num:Num, ind:I]|Rest]), Wfms),
  sort(Wfms, SWfms),
  filter_out_upper_cases(SWfms, FWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:numeric_variable, wfm:[], ref:'+']|Rest1], Result) :-
  findall(Wfm, lexicon([cat:numeric_variable, wfm:Wfm, ref:'+', snum:_, spos:_|Rest]), Wfms),
  (
     Wfms = []
     ->
     Result = Rest2
  ;
     Result = [json([cat='variable (numeric)', wfm=SWfms])|Rest2],
     sort(Wfms, SWfms)
  ),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:numeric_variable, wfm:[]]|Rest1], [json([cat='variable (numeric)', wfm=SWfms])|Rest2]) :-
  findall(Wfm, lexicon([cat:numeric_variable, wfm:Wfm|Rest]), Wfms),
  sort(Wfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).


avp_to_json(next, SNum, SPos, [[cat:string_variable, wfm:[], ref:'+']|Rest1], Result) :-
  findall(Wfm, lexicon([cat:string_variable, wfm:Wfm, ref:'+', snum:_, spos:_|Rest]), Wfms),
  (
     Wfms = []
     ->
     Result = Rest2
  ;
     Result = [json([cat='variable (string)', wfm=SWfms])|Rest2],
     sort(Wfms, SWfms)
  ),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).


avp_to_json(next, SNum, SPos, [[cat:string_variable, wfm:[]]|Rest1], [json([cat='variable (string)', wfm=SWfms])|Rest2]) :-
  findall(Wfm, lexicon([cat:string_variable, wfm:Wfm|Rest]), Wfms),
  sort(Wfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:comparative, wfm:[]]|Rest1], [json([cat=comparative, wfm=SWfms])|Rest2]) :-
  findall(Wfm, lexicon([cat:comparative, wfm:Wfm|Rest]), Wfms),
  sort(Wfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:preposition, wfm:[], ref:'+']|Rest1], Result) :-
  findall(Wfm, lexicon([cat:preposition, wfm:Wfm, ref:'+', snum:_, spos:_|Rest]), Wfms),
  (
     Wfms = []
     ->
     Result = Rest2
  ;
     Result = [json([cat=preposition, wfm=SWfms])|Rest2],
     sort(Wfms, SWfms)
  ),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:preposition, wfm:Wfm, arg:_, arg:_]|Rest1], [json([cat=preposition, wfm=Wfms])|Rest3]) :-
  % nl(user), write(user, 'Wfm: '), nl(user), write(user, Wfm), nl(user),
  (
     Wfm = [of],
     select([cat:preposition, wfm:[as], arg:_, arg:_], Rest1, Rest2),
     Wfms = [[as], [of]]
  ;
     Wfm = [as],
     select([cat:preposition, wfm:[of], arg:_, arg:_], Rest1, Rest2),
     Wfms = [[as], [of]]
  ;
     Wfm = [of],
     Wfms = [[of]],
     Rest1 = Rest2
  ;
     Wfm = [as],
     Wfms = [[as]],
     Rest1 = Rest2
  ),
  avp_to_json(next, SNum, SPos, Rest2, Rest3).

avp_to_json(next, SNum, SPos, [[cat:preposition, wfm:[], evtl:_]|Rest1], [json([cat='preposition (modifier)', wfm=SWfms])|Rest2]) :-
  findall(Wfm, lexicon([cat:preposition, wfm:Wfm, evtl:E|Rest]), Wfms),
  sort(Wfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:operator, wfm:[]]|Rest1], [json([cat=operator, wfm=SWfms])|Rest2]) :-
  findall(Wfm, lexicon([cat:operator, wfm:Wfm|Rest]), Wfms),
  sort(Wfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:relational_adjective, wfm:[]]|Rest1], [json([cat='relational adjective', wfm=SWfms])|Rest2]) :-
  findall(Wfm, lexicon([cat:relational_adjective, wfm:Wfm|Rest]), Wfms),
  sort(Wfms, SWfms),
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

% avp_to_json(next, SNum, SPos, [[cat:ordinal, wfm:[]]|Rest1], [json([cat=ordinal, wfm=SWfms])|Rest2]) :-
%  findall(Wfm, lexicon([cat:ordinal, wfm:Wfm|Rest]), Wfms),
%  sort(Wfms, SWfms),
%  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:copula, wfm:[], num:sg]|Rest1], [json([cat=copula, wfm=[[is]]])|Rest2]) :-
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:copula, wfm:[], num:pl]|Rest1], [json([cat=copula, wfm=[[are]]])|Rest2]) :-
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:full_stop, wfm:WF]|Rest1], [json([cat='full stop', wfm=[WF]])|Rest2]) :-
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:question_mark, wfm:WF]|Rest1], [json([cat='question mark', wfm=[WF]])|Rest2]) :-
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:comma, wfm:WF]|Rest1], [json([cat=comma, wfm=[WF]])|Rest2]) :-
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:negation, wfm:WF]|Rest1], [json([cat=negation, wfm=[WF]])|Rest2]) :-
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:constraint, wfm:[]]|Rest1], [json([cat=constraint, wfm=[[exclude], [it, is, not, the, case]]])|Rest2]) :-
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:ex_there, wfm:WF]|Rest1], [json([cat='existential there', wfm=[[there, is]]])|Rest2]) :-
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:coordination, wfm:WF]|Rest1], [json([cat=coordination, wfm=SWfs])|Rest3]) :-
  collect_coordination([[cat:coordination, wfm:WF]|Rest1], Rest2, Wfs),
  sort(Wfs, SWfs),
  avp_to_json(next, SNum, SPos, Rest2, Rest3).

collect_coordination([], [], []).

collect_coordination([[cat:coordination, wfm:WF]|Rest1], Rest2, [WF|Rest3]) :-
   collect_coordination(Rest1, Rest2, Rest3).

collect_coordination([Cat|Rest1], [Cat|Rest2], Rest3) :-
  collect_coordination(Rest1, Rest2, Rest3).


avp_to_json(next, SNum, SPos, [[cat:compound, wfm:WF]|Rest1], [json([cat=compound, wfm=SWfs])|Rest2]) :-
  findall(WF1, lookahead(SNum, SPos, [cat:compound, wfm:WF1]), Wfs),
  sort(Wfs, SWfs),
  delete_compound(Rest1, NewRest),
  avp_to_json(next, SNum, SPos, NewRest, Rest2).



/*  changed from compound=SWfs to cat=compound, wfm=SWfs
avp_to_json(next, SNum, SPos, [[cat:compound, wfm:WF]|Rest1], [json([compound=SWfs])|Rest2]) :-
  findall(WF1, lookahead(SNum, SPos, [cat:compound, wfm:WF1]), Wfs),
  sort(Wfs, SWfs),
  delete_compound(Rest1, NewRest),
  %% write(user, SWfs), nl(user), nl(user),
  avp_to_json(next, SNum, SPos, NewRest, Rest2).
*/

delete_compound([], []).

delete_compound([[cat:compound, wfm:_]|Rest1], Rest2) :-
  delete_compound(Rest1, Rest2).

delete_compound([E|Rest1], [E|Rest2]) :-
  delete_compound(Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:Cat, wfm:[Wfm], num:Num]|Rest1], [json([cat=Cat, wfm=[[Wfm]], num=Num])|Rest2]) :-
  nonvar(Wfm),
  atom_codes(Wfm, [Code|Codes]),
  Code >= 97, Code =< 122,
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:Cat, wfm:[Wfm]]|Rest1], [json([cat=Cat, wfm=[[Wfm]]])|Rest2]) :-
  nonvar(Wfm),
  atom_codes(Wfm, [Code|Codes]),
  Code >= 97, Code =< 122,
  avp_to_json(next, SNum, SPos, Rest1, Rest2).


avp_to_json(next, SNum, SPos, [[cat:Cat, wfm:Wfm, num:Num]|Rest1], Rest2) :-
  avp_to_json(next, SNum, SPos, Rest1, Rest2).

avp_to_json(next, SNum, SPos, [[cat:Cat, wfm:Wfm]|Rest1], Rest2) :-
  avp_to_json(next, SNum, SPos, Rest1, Rest2).


filter_out_upper_cases([], []).

filter_out_upper_cases([[Wfm|Rest]|Wfms1], [[Wfm|Rest]|Wfms2]) :-
  atom_codes(Wfm, [Code|Codes]),
  Code >= 97, Code =< 122,
  filter_out_upper_cases(Wfms1, Wfms2).

filter_out_upper_cases([Wfm|Wfms1], Wfms2) :-
  filter_out_upper_cases(Wfms1, Wfms2).


% -----------------------------------------------------------------------
% inspect_chart/8
%
% -----------------------------------------------------------------------

inspect_chart(SNum, SPos, EPos, DrsOut, AnaOut, ParaOut, RevPara, Tree) :-
  LHS = discourse_element([drs:DrsIn-DrsOut, ana:AnaIn-AnaOut, para:ParaIn-ParaOut, tree:Tree]),
  edge(SNum, 0, EPos, LHS, _, _),
  reverse_paraphrase(ParaOut, RevPara).


% -----------------------------------------------------------------------
% show_edges/0
%
% -----------------------------------------------------------------------

show_edges(SNum) :-
  findall(edge(SNum, B, C, D, E, F), edge(SNum, B, C, D, E, F), Edges),
  display_edges(Edges).

display_edges([]).

display_edges([edge(A, B, C, D, E, F)|Edges]) :-
  E =.. [E1|R],
  write(user, [edge(A, B, C, D, E1)]), nl(user), nl(user),
  retract(edge(A, B, C, D, E, F)),
  display_edges(Edges).


% -----------------------------------------------------------------------
% max_list/2
%
%   - returns the largest integer of a list of integers
% -----------------------------------------------------------------------

max_list([H|T], M) :-
  max_list(T, H, M).

max_list([], C, C).
max_list([H|T], C, M) :-
  C2 is max(C, H),
  max_list(T, C2, M).


% -----------------------------------------------------------------------
% max_list_of_lists/2
%
%   - returns the the max list of lists
% -----------------------------------------------------------------------

max_list_of_lists([H|T], M) :-
  max_list_of_lists(T, H, M).

max_list_of_lists([], C, C).
max_list_of_lists([[H1, H2]|T], [C1, C2], M) :-
  (
    H1 > C1
    ->
    C3 = H1, C4 = H2
  ;
    H1 < C1
    ->
    C3 = C1, C4 = C2
  ;
    H1 = C1, H2 >= C2
    ->
    C3 = H1, C4 = H2
  ;
    H1 = C1, H1 < C2
    ->
    C3 = C1, C4 = C2
  ),
  max_list_of_lists(T, [C3, C4], M).



% chart_handler(Id, IMode, Token, SNum, SPos, Flag, RMode, Output)

/***

test_syntax_tree :-
  chart_handler(1,  text, ' ', 1, 0, off, normal, Output1),
  chart_handler(2,  text, 'Allice', 1, 0, off, normal, Output2),
  chart_handler(3,  text, 'is', 1, 1, off, normal, Output3),
  chart_handler(4,  text,  'female', 1, 2, off, normal, Output4),
  chart_handler(5,  text, '.', 1, 3, on, normal, Output5),
  chart_handler(6,  text, ' ', 2, 0, off, normal, Output6),
  chart_handler(7,  text, 'Bob', 2, 0, off, normal, Output7),
  chart_handler(8,  text, 'is', 2, 1, off, normal, Output8),
  chart_handler(9,  text, 'male', 2, 2, off, normal, Output9),
  chart_handler(10, text, '.', 2, 3, on, normal, Output10),
  chart_handler(11, text, ' ', 3, 0, off, normal, Output11),
  chart_handler(12, text, 'Steve', 3, 0, off, normal, Output12),
  chart_handler(13, text, 'is', 3, 1, off, normal, Output13),
  chart_handler(14, text, 'male', 3, 2, off, normal, Output14),
  chart_handler(15, text, '.', 3, 3, on, normal, Output15),
  nl(user),
  write(user, Output15),
  nl(user), nl(user).

***/

test_syntax_tree :-
  chart_handler(1,  text, ' ', 1, 0, off, normal, Output1),
  chart_handler(2,  text, 'Joohn', 1, 0, off, normal, Output2),
  nl(user),
  write(user, Output2),
  nl(user), nl(user).
