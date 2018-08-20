% =========================================================================
%  Project:   PENG Engine
%  Version:   0.01
%  Module:    spelling_ckecker.pl
%  Date:      2015-08-09  
%  Modified:  2016-01-20
%  Status:    DEMO VERSION !
%  Author:    Rolf Schwitter
%  Copyright: Rolf Schwitter, Macquarie University, 2016
% =========================================================================


% ------------------------------------------------------------------------
% Initialisation
% ------------------------------------------------------------------------

:- no_style_check(singleton).
:- no_style_check(discontiguous).


:- dynamic spelling_lexicon/1.


% ------------------------------------------------------------------------
% load_spelling_lexicon/0
% ------------------------------------------------------------------------

load_spelling_lexicon :-
  findall(Term, lexicon([cat:Cat, wfm:Term|Rest]), Terms),
  flatten(Terms, FTerms),
  remove_duplicates(FTerms, CTerms),
  assert_to_spelling_lexicon(CTerms).

assert_to_spelling_lexicon([]).
assert_to_spelling_lexicon([Term|Terms]) :-
  assert(spelling_lexicon(Term)),
  assert_to_spelling_lexicon(Terms).


% ------------------------------------------------------------------------
%  remove_duplicates/2
% ------------------------------------------------------------------------

remove_duplicates([], []).
remove_duplicates([Head|Tail1], [Head|Tail2]) :-
  delete(Tail1, Head, Residue),
  remove_duplicates(Residue, Tail2).


% ------------------------------------------------------------------------
%  Load spelling lexicon on start
% ------------------------------------------------------------------------

:- nl(user), 
   write(user, 'Loading spelling lexicon: ***'),
   nl(user),
   load_spelling_lexicon,
   write(user, 'Spelling lexicon loaded.     '),
   nl(user), nl(user).


% ------------------------------------------------------------------------
% spelling_checker(IMode, SNum, SPos, [Token], FJSONTermResult).
%
% IMode can be text or speech (not yet implemented)
% ------------------------------------------------------------------------

spelling_checker(text, SNum, SPos, [Token], JSONTermResult) :-
  findall(Category, lookahead(SNum, SPos, [cat:Category|Rest]), CategoryList),
  damerau_rules(Token, Candidates),
  lexicon_lookup_categories(CategoryList, Candidates, JSONTerm),
  flatten(JSONTerm, FJSONTerm),
  remove_duplicates(FJSONTerm, JSONTermResult).

damerau_rules(Token, Candidates) :-
  atom_codes(Token, CharList),
  (
     CharList = [Char]            % fix this in Damerau rules
     ->
     Candidates = []
  ;
     setof(NewCharList,
           transposition(CharList, NewCharList),
           CList1),
     setof(NewCharList,
           one_letter_extra(CharList, NewCharList),
           CList2), 
     setof(NewCharList,
           one_letter_missing(CharList, NewCharList),
           CList3), 
     setof(NewCharList,
           one_letter_wrong(CharList, NewCharList),
           CList4),
     collect_candidates(CList1, CList2, CList3, CList4, Candidates)
  ).


collect_candidates(CList1, CList2, CList3, CList4, Candidates) :-
  append(CList1, CList2, CSet1),
  append(CSet1, CList3, CSet2),
  append(CSet2, CList4, CSet3),
  char_list_atom_list(CSet3, Candidates).

char_list_atom_list([], []).

char_list_atom_list([List|Rest1], [Atom|Rest2]) :-
	atom_codes(Atom, List),
	char_list_atom_list(Rest1, Rest2).


% ------------------------------------------------------------------------------
%  lexicon_lookup_categories(Category, Candidates, Solutions) 
% ------------------------------------------------------------------------------

lexicon_lookup_categories([], _, []).

lexicon_lookup_categories([Category1|Categories], Candidates, Solutions) :-
  lexicon_lookup(Category1, Candidates, WordFormList), 
  ( 
      WordFormList \= []
      ->
      atom_codes(Category1, CategoryCodes1),
      replace_underscore_by_blank(CategoryCodes1, CategoryCodes2),
      atom_codes(Category2, CategoryCodes2),
      Solutions = [json([cat=Category2, wfm=WordFormList])|Rest]
  ;
      Solutions = Rest
  ),
  lexicon_lookup_categories(Categories, Candidates, Rest).

lexicon_lookup(Category, [], []).

lexicon_lookup(Category, [Candidate|Candidates], [[Candidate]|Solutions]) :-
               (
                  Category \= compound
                  ->
	          lexicon([cat:Category, wfm:Term|Rest]), 
		  member(Candidate, Term), !					      
	       ;
	  	  call(compound_word(SN, V1, V2, LHS, Found, [LAHs])),
		  Candidate == LAHs
	       ),
	       lexicon_lookup(Category, Candidates, Solutions).

lexicon_lookup(Category, [Candidate|Candidates], Solutions) :-
	       lexicon_lookup(Category, Candidates, Solutions).

replace_underscore_by_blank([], []).

replace_underscore_by_blank([95|Codes1], [32|Codes2]) :-
  replace_underscore_by_blank(Codes1, Codes2).

replace_underscore_by_blank([Code|Codes1], [Code|Codes2]) :-
  replace_underscore_by_blank(Codes1, Codes2).


% ------------------------------------------------------------------------------
%  transposition/2 transposes two letters.
% ------------------------------------------------------------------------------

transposition([Char1,Char2|Chars], [Char2,Char1|Chars]).

transposition([Char|Chars1], [Char|Chars2]) :-
  transposition(Chars1, Chars2).


% ------------------------------------------------------------------------------
%  one_letter_extra/2 deletes one letter.
% ------------------------------------------------------------------------------

one_letter_extra([_Char|Chars], Chars).

one_letter_extra([Char|Chars1], [Char|Chars2]) :-
  one_letter_extra(Chars1, Chars2).


% ------------------------------------------------------------------------------
%  one_letter_missing/2 adds one letter.
% ------------------------------------------------------------------------------

one_letter_missing(Chars, [Char|Chars]) :-
  (
    propose_letter(Char)
  ;
    propose_capital_letter(Char)
  ).

one_letter_missing([Char|Chars1], [Char|Chars2]) :-
  a_letter_missing(Chars1, Chars2).

a_letter_missing(Chars, [Char|Chars]) :-
  propose_letter(Char).

a_letter_missing([Char|Chars1], [Char|Chars2]) :-
  a_letter_missing(Chars1, Chars2).


% ------------------------------------------------------------------------------
%  one_letter_wrong/2 exchanges one letter.
% ------------------------------------------------------------------------------

one_letter_wrong([_Char|Chars], [Char|Chars]) :-
  (
    propose_letter(Char)
  ;
    propose_capital_letter(Char)
  ).

one_letter_wrong([Char|Chars1], [Char|Chars2]) :-
  a_letter_wrong(Chars1,Chars2).

a_letter_wrong([_Char|Chars], [Char|Chars]) :-
  propose_letter(Char).

a_letter_wrong([Char|Chars1], [Char|Chars2]) :-
  a_letter_wrong(Chars1, Chars2).


% ------------------------------------------------------------------------------
%  propose_letter/1 provides a new letter.
% ------------------------------------------------------------------------------

propose_capital_letter(Char) :-
  % prolog_flag(double_quotes,codes), !,
  % member(Char,"ABCDEFGHIJKLMNOPQRSTUVWXYZ"),
  member(Char, [65, 66, 67, 68, 69, 70, 71, 72, 73, 74,
		75, 76, 77, 78, 79, 80, 81, 82, 83, 84,
		85, 86, 87, 88, 89, 90]).

propose_letter(Char) :-
  % prolog_flag(double_quotes,codes), !,
  % member(Char,"abcdefghijklmnopqrstuvwxyz").
  member(Char, [97, 98, 99, 100, 101, 102, 103, 104, 105,
		106, 107, 108, 109, 110, 111, 112, 113, 114, 115,
		116, 117, 118, 119, 120, 121, 122]).


% ------------------------------------------------------------------------
% spelling_checker(speech, SNum, SPos, NBest, FJSONTermResult).
%
% IMode can be text or speech (not yet implemented)
% ------------------------------------------------------------------------

spelling_checker(speech, SNum, SPos, NBest, JSONListResult) :-
  %% nl(user), write(user, 'SPos: '), write(user, SPos), nl(user), nl(user),
  %% nl(user), write(user, 'NBest: '), write(user, NBest), nl(user), nl(user),
  Algorithm = simple_token,
  %% Algorithm = double_metaphone,
  MaxNumberOfResults = 5,
  findall(Cat, lookahead(SNum, SPos, [cat:Cat|Rest]), CatList),
  collect_lexical_entries(SPos, CatList, [], CatEntryList1),
  collect_compound_words(SNum, SPos, CatEntryList2),
  append(CatEntryList1, CatEntryList2, CatEntryList3),
  (
     Algorithm = simple_token
     ->
     process_nbest_list(simple_token, NBest, Trashhold, CatEntryList3, [], DistResult)
  ;
     Algorithm = double_metaphone
     ->
     process_nbest_list(double_metaphone, NBest, Trashhold, CatEntryList3, [], DistResult)
  ),
  %% nl(user), write(user, 'DistResult: '), write(user, DistResult), nl(user), nl(user),
  sort(0, @<, DistResult, SortedDistResult),
  max_number_of_results(MaxNumberOfResults, SortedDistResult, MaxResult),
  remove_duplicates(MaxResult, FMaxResult), 
  SpeechCatList = [verbs, names, nouns, adjectives, adverbs, compound, 'function words'],
  %% nl(user), write(user, 'MaxResult: '), write(user, MaxResult), nl(user), nl(user),
  group_into_categories(SPos, SpeechCatList, FMaxResult, JSONListResult).


% ------------------------------------------------------
% group_into_categories/4
% ------------------------------------------------------

group_into_categories(_SPos, _Cats, [], []).

group_into_categories(SPos, [Cat|Cats], MaxResultIn, Result) :-
  check_same_category(SPos, Cat, MaxResultIn, MaxResultOut, JSONList),
  (
     JSONList \= []
     ->
     Result = [json([cat=Cat, wfm=JSONList])|JSONTerms]
  ;
     Result = JSONTerms
  ),  
  group_into_categories(SPos, Cats, MaxResultOut, JSONTerms).


% ------------------------------------------------------
% check_same_category/3
% ------------------------------------------------------

check_same_category(_SPos, _Cat, [], [], []).

check_same_category(SPos, verbs, [[Cat, Entry]|Rest], MaxResult, Result) :-
  (
     Cat = transitive_verb,
     (
        lookahead(SN, SPos, [cat:transitive_verb, wfm:[], num:Num, vform:fin]),
        lexicon([cat:transitive_verb, wfm:[Entry|_], arg:[num:Num, ind:I1], arg:[num:_, ind:I2], vform:fin, evtl:E, con:pred(E, I1, I2, Sym)]),
        Result = [[Entry]|JSON]
     ;
        lookahead(SN, SPos, [cat:transitive_verb, wfm:[], vform:inf]),
        lexicon([cat:transitive_verb, wfm:[Entry|_], arg:[num:Num, ind:I1], arg:[num:_, ind:I2], vform:inf, evtl:E, con:pred(E, I1, I2, Sym)]),
	Result = [[Entry]|JSON]
     ;
        Result = JSON
     )
  ;
     Cat = intransitive_verb,
     (
        lookahead(SN, SPos, [cat:intransitive_verb, wfm:[], num:Num, vform:fin]), 
	lexicon([cat:intransitive_verb, wfm:[Entry|_], arg:[num:Num, ind:I], vform:fin, evtl:E, con:pred(E, I, Sym)]),
        Result = [[Entry]|JSON]
     ;
        lookahead(SN, SPos, [cat:intransitive_verb, wfm:[], vform:inf]),
        lexicon([cat:intransitive_verb, wfm:[Entry|_], arg:[num:Num, ind:I], vform:inf, evtl:E, con:pred(E, I, Sym)]),
	Result = [[Entry]|JSON]
     ;
        Result = JSON
     )
  ;
     Cat = copula,
     (
        lookahead(SN, SPos, [cat:copula, wfm:[], num:Num]),
        lexicon([cat:copula, wfm:[Entry|_], arg:[num:Num, ind:I], vform:V, evtl:E|Rest]), 
        Result = [[Entry]|JSON]
     ;
        Result = JSON
     )
  ),
  check_same_category(SPos, verbs, Rest, MaxResult, JSON).


check_same_category(SPos, names, [[Cat, Entry]|Rest], MaxResult, [[Entry]|JSON]) :-
  (
     Cat = name
  ;
     Cat = numeric_variable
  ;
     Cat = string_variable
  ),
  check_same_category(SPos, names, Rest, MaxResult, JSON).


check_same_category(SPos, nouns, [[Cat, Entry]|Rest], MaxResult, Result) :-
  (
     Cat = count_noun,
     (
        (
           lookahead(SN, SPos, [cat:count_noun, wfm:[], num:Num])
        ;
           lookahead(SN, SPos, [cat:count_noun, wfm:[], ref:'+', num:Num])
        ),
        lexicon([cat:count_noun, wfm:[Entry], arg:[num:Num, ind:I], con:object(I, Sym, count)]),   
        Result = [[Entry]|JSON] 
     ;
        Result = JSON
     )
  ;
     Cat = mass_noun,
     (
        lookahead(SN, SPos, [cat:mass_noun, wfm:[], num:Num]),
        lexicon([cat:mass_noun, wfm:[Entry], arg:[num:Num, ind:I], con:object(I, Sym, mass)]),
        Result = [[Entry]|JSON]
     ;
        Result = JSON
     )
  ),
  check_same_category(SPos, nouns, Rest, MaxResult, JSON).


check_same_category(SPos, adjectives, [[Cat, Entry]|Rest], MaxResult, [[Entry]|JSON]) :-
  (
     Cat = adjective
  ;
     Cat = relational_adjective
  ),
  check_same_category(SPos, adjectives, Rest, MaxResult, JSON).


check_same_category(SPos, adverbs, [[Cat, Entry]|Rest], MaxResult, [[Entry]|JSON]) :-
  Cat = adverb,
  check_same_category(SPos, adverbs, Rest, MaxResult, JSON).


check_same_category(SPos, compound, [[Cat, Entry]|Rest], MaxResult, [[Entry]|JSON]) :-
  Cat = compound,
  check_same_category(SPos, compound, Rest, MaxResult, JSON).


check_same_category(SPos, 'function words', [[Cat, Entry]|Rest], MaxResult, Result) :-
  (
     Cat = auxiliary,
     (
        lookahead(SN, SPos, [cat:auxiliary, wfm:[], num:Num]), 
        lexicon([cat:auxiliary, wfm:[Entry|_], arg:[num:Num, ind:I]]), %% nl(user), nl(user), write(user, 'Entry: '), write(user, Entry), write(user, ' '), write(user, Num), nl(user), nl(user),
        Result = [[Entry]|JSON] 
     ;
        Result = JSON
     )
  ;
     Result = [[Entry]|JSON]
  ),
  check_same_category(SPos, 'function words', Rest, MaxResult, JSON).


check_same_category(SPos, Cat, [CatEntry|Rest1], [CatEntry|Rest2], JSON) :-
  check_same_category(SPos, Cat, Rest1, Rest2, JSON).


% ------------------------------------------------------
% max_number_of_results/4
% ------------------------------------------------------

max_number_of_results(0, _SortedProbDistResult, []).

max_number_of_results(MaxNumberOfResults, [], []).

max_number_of_results(MaxNumberOfResultsIn, [[MindDist, Cat, Entry-Token|_]|Rest1], [[Cat, Entry]|Rest2]) :-
  MaxNumberOfResultsOut is MaxNumberOfResultsIn - 1,
  max_number_of_results(MaxNumberOfResultsOut, Rest1, Rest2).


% ------------------------------------------------------
% collect_lexical_entries/4
% ------------------------------------------------------

collect_lexical_entries(SPos, [], Result, Result).
  
collect_lexical_entries(SPos, [Cat|Cats], EntriesIn, Result) :-
  SPos = 0,
  findall([Cat, Term], lexicon([cat:Cat, wfm:[Term|_]|Rest]),  Entries1),
  remove_lower_cases(Entries1, Entries2), 
  append(Entries2, EntriesIn, EntriesOut),
  collect_lexical_entries(SPos, Cats, EntriesOut, Result).


collect_lexical_entries(SPos, [Cat|Cats], EntriesIn, Result) :-
  SPos >= 1,
  findall([Cat, Term], lexicon([cat:Cat, wfm:[Term|_]|Rest]), Entries1),
  remove_upper_cases(Entries1, Entries2),
  append(Entries2, EntriesIn, EntriesOut),
  collect_lexical_entries(SPos, Cats, EntriesOut, Result).


remove_lower_cases([], []).

remove_lower_cases([[Cat, Term]|Terms1], Terms2) :-
  atom_codes(Term, [Code|Codes]),
  Code >= 97, Code =< 122,
  remove_lower_cases(Terms1, Terms2).

remove_lower_cases([[Cat, Term]|Terms1], [[Cat, Term]|Terms2]) :-
  remove_lower_cases(Terms1, Terms2).


remove_upper_cases([], []).

remove_upper_cases([[Cat, Term]|Terms1], Terms2) :-
  ( Cat \= name ; Cat \= string_variable ; Cat \= numeric_variable ; Cat \= number ; Cat \= cardinal ),
  atom_codes(Term, [Code|Codes]),
  Code >= 65, Code =< 90,
  remove_upper_cases(Terms1, Terms2).

remove_upper_cases([[Cat, Term]|Terms1], [[Cat, Term]|Terms2]) :-
  remove_upper_cases(Terms1, Terms2).


% ------------------------------------------------------
% collect_compound_words/3
% ------------------------------------------------------

collect_compound_words(SNum, SPos, Result) :-
  findall([compound, Term], compound_word(SNum, V1, SPos, LHS, Found, [Term|_]), Result).


% ------------------------------------------------------
% process_nbest_list/6
% ------------------------------------------------------

process_nbest_list(_Algorithm, [], _Trashhold, _CatEntryList, ProbDistResult, ProbDistResult).

process_nbest_list(Algorithm, [Token|NBests], Trashhold, CatEntryList, ProbDistIn, ProbDistResult) :-
  calculate_edit_distance(Algorithm, Token, Trashhold, CatEntryList, ProbDist),
  append(ProbDist, ProbDistIn, ProbDistOut),
  process_nbest_list(Algorithm, NBests, Trashhold, CatEntryList, ProbDistOut, ProbDistResult).
  

% ------------------------------------------------------
% calculate_edit_distance/5
% - simple_token
% ------------------------------------------------------

calculate_edit_distance(simple_token, NBest, Trashhold, Entries, ProbDistResult) :-
  calculate_edit_distance_1(NBest, Trashhold, Entries, ProbDistResult).


calculate_edit_distance_1(Token, _Trashhold, [], []).

calculate_edit_distance_1(Token, Trashhold, [[Cat, Entry]|Entries], [[Dist, Cat, Entry-Token]|Results]) :-
  edit_distance(Token, Entry, Dist),
  calculate_edit_distance_1(Token, Trashhold, Entries, Results).


% ------------------------------------------------------
% calculate_edit_distance/5
%  - double metaphone
% ------------------------------------------------------

calculate_edit_distance(double_metaphone, Token, Trashhold, Entries, ProbDistResult) :-	 
  double_metaphone(Token, Metaphone1a, Metaphone1b),
  calculate_edit_distance_2(Token, Trashhold, Metaphone1a, Metaphone1b, Entries, ProbDistResult).


calculate_edit_distance_2(Token, _Trashhold, _Metaphone1a, Metaphone1b, [], []).

calculate_edit_distance_2(Token, Trashhold, Metaphone1a, Metaphone1b, [[Cat, Entry]|Entries],
					 [[MinDist, Cat, Entry-Token, [Metaphone1a-Metaphone1b], [Metaphone2a-Metaphone2b]]|Results]) :-		 
     double_metaphone(Entry, Metaphone2a, Metaphone2b),
     (
        Metaphone1a \= Metaphone1b,
        Metaphone2a \= Metaphone2b		     
        ->
        (
           edit_distance(Metaphone1a, Metaphone2a, Dist1),
           edit_distance(Metaphone1b, Metaphone2b, Dist2),
           edit_distance(Metaphone1b, Metaphone2a, Dist3),
           edit_distance(Metaphone1a, Metaphone2b, Dist4)
        ),
        min_list([Dist1, Dist2, Dist3, Dist4], MinDist)
     ;
        Metaphone1a \= Metaphone1b,
        Metaphone2a == Metaphone2b		   
        ->
        edit_distance(Metaphone1a, Metaphone2a, Dist1),
        edit_distance(Metaphone1b, Metaphone2a, Dist2),
        min_list([Dist1, Dist2], MinDist)
     ;
        Metaphone1a == Metaphone1b,
        Metaphone2a \= Metaphone2b
        ->
        edit_distance(Metaphone1a, Metaphone2a, Dist1),
        edit_distance(Metaphone1a, Metaphone2b, Dist2),
        min_list([Dist1, Dist2], MinDist)
     ;
        Metaphone1a == Metaphone1b,
        Metaphone2a == Metaphone2b
        ->
        edit_distance(Metaphone1a, Metaphone2a, MinDist)
     ),
  calculate_edit_distance_2(Token, Trashhold, Metaphone1a, Metaphone1b,  Entries, Results).


% ------------------------------------------------------
% edit_distance/3
% ------------------------------------------------------

edit_distance(AtomA, AtomB, Distance) :-
  atom_codes(AtomA, CodesA),
  atom_codes(AtomB, CodesB),
  length(CodesA, N),
  length(CodesB, M),
  N1 is N + 1,
  M1 is M + 1,
  make_matrix(N1, M1, Matrix),
  cell_value(CodesA, CodesB, N, M, Matrix, Distance).

% Cell (0,0) is 0
%
cell_value(_CodesA,_CodesB, 0, 0, Matrix, 0) :-
  !,
  set_cell_value(0, 0 ,Matrix, 0).

% Cell (O, J)
%
cell_value(_CodesA,_CodesB, I, J, Matrix, J) :-
  I = 0, !,
  set_cell_value(I, J, Matrix, J).

% Cell (I, J)
%
cell_value(_CodesA,_CodesB, I, J, Matrix, I) :-
  J = 0, !,
  set_cell_value(I, J, Matrix, J).

% The cell value has already been computed
%
cell_value(_CodesA, _CodesB, I, J, Matrix, Value) :-
  set_cell_value(I, J, Matrix, Value),
  \+ var(Value), !.

% Otherwise, compute it (recursively)
%
cell_value(CodesA, CodesB, I, J, Matrix, Distance) :-
  I1 is I-1,
  J1 is J-1,
  cell_value(CodesA, CodesB, I1, J,  Matrix, I1xJ),            % (i-1,j) 
  deleting_cost(CodesA, I, DelCost),                           % cost of deleting ith code from A
  Del is DelCost + I1xJ, 
  cell_value(CodesA, CodesB, I,  J1, Matrix, IxJ1),            % (i,j-1)
  inserting_cost(CodesA, I, InsCost),                          % cost of inserting ith code in A
  Ins is InsCost + IxJ1,                         
  cell_value(CodesA, CodesB, I1, J1, Matrix, I1xJ1), % (i,j-1)
  substituting_cost(CodesA, CodesB, I, J, SubCost),            % cost of substituting ith in A by jth in B
  Sub is SubCost + I1xJ1,                        
  min_list([Del, Ins, Sub], Distance),
  set_cell_value(I, J, Matrix, Distance).

deleting_cost(_Str, _Position, 1).

inserting_cost(_Str, _Position, 1).

substituting_cost(CodesA, CodesB, CodesAPosition, CodesBPosition, 0) :-
  nth1(CodesAPosition, CodesA, Char),
  nth1(CodesBPosition, CodesB, Char), !.

substituting_cost(_CodesA, _CodesB, _CodesAPosition, _CodesBPosition, 1).

set_cell_value(I, J, Matrix, Value) :-
  nth0(I, Matrix, Col),
  nth0(J, Col, Value).

%--------------------------------------------------------------- 
%% Create an N x M matrix 
% --------------------------------------------------------------

make_matrix(N, M, Matrix) :-
  length(Rows, N),
  findall(Col,( member(Col, Rows), length(Col, M) ), Matrix).




