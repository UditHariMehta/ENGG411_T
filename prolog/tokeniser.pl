% =========================================================================
%  Project:   Puzzle Engine
%  Version:   0.01
%  Module:    tokeniser.pl
%  Date:      2012-04-22
%  Modified:  2015-03-20
%  Status:    DEMO VERSION !
%  Author:    Rolf Schwitter
%  Copyright: Rolf Schwitter, Macquarie University, 2016
% =========================================================================


% =========================================================================
%  read_input_file/2
%
%  -- reads in a file and generates a list of codes.
% =========================================================================

read_input_file(InputFile, CodeList) :-
  open(InputFile, read, Stream),
  read_file(Stream, CodeList),
  close(Stream).


% ------------------------------------------------------------------------
%  read_file/2
% ------------------------------------------------------------------------

read_file(Stream, []) :-
  at_end_of_stream(Stream).


read_file(Stream, [Code|Codes]) :-
  \+ at_end_of_stream(Stream),
  get_code(Stream, Code),
  read_file(Stream, Codes).


% ------------------------------------------------------------------------
%  tokeniser/3
% ------------------------------------------------------------------------

tokeniser(CodeList, Discourse, []) :-
   filter_code_list(CodeList, FCodeList),
   generate_token_list(TokenList, FCodeList, []),
   generate_sentence_list(TokenList, Discourse).


%% Remove comments from input file

filter_code_list([], []).

filter_code_list([37|Codes1], FCodes) :-         
   append(Comment, [10|Codes2], Codes1),
   filter_code_list(Codes2, FCodes).

filter_code_list([47, 42|Codes1], FCodes) :-
   append(Comment, [42, 47|Codes2], Codes1),
   filter_code_list(Codes2, FCodes).

filter_code_list([Code|Codes], [Code|FCodes]) :-
   filter_code_list(Codes, FCodes).


generate_sentence_list([], []).


generate_sentence_list(TokenList1, [Sentence|Sentences]) :-
   append(TokenList3, ['.'|TokenList2], TokenList1),
   append(TokenList3, ['.'], Sentence),
   generate_sentence_list(TokenList2, Sentences).


generate_sentence_list(TokenList1, [Sentence|Sentences]) :-
   append(TokenList3, ['?'|TokenList2], TokenList1),
   append(TokenList3, ['?'], Sentence),
   generate_sentence_list(TokenList2, Sentences).


generate_token_list([T|Rest]) -->
  blank,
  token(T), !,
  generate_token_list(Rest).


generate_token_list([]) -->
  blank.

% ------------------------------------------------------------------------

token(T) -->
  timex(Codes),
  { atom_codes(T, Codes) }.


token(T) -->
  word_start(Codes),
  { atom_codes(T, Codes) }.


token(T) -->
  numeral(Codes),
  { number_codes(T, Codes) }.


token(',') -->
  [44], !.


token('.') -->
  [46], !.


token('?') -->
  [63], !.


token('+') -->
  [43], !.


token('-') -->
  [45], !.


token('=') -->
  [61], !.
   

% -----------------------------------------------------------------------


word_start([L|Rest]) -->
  letter(L),
  word(Rest).


word_start([L]) -->
  letter(L).


word([L|Rest]) -->
  ( letter(L) ; digit(L) ),
  word(Rest).


word([L]) -->
  ( letter(L) ; digit(L) ).


% ----------------------------------------------------------------------


numeral([C|N]) -->
  digit(C),
  numeral(N).


numeral([C]) -->
  digit(C).


% ----------------------------------------------------------------------


timex([C1, C2, 58, C3, C4]) -->
  digit(C1),
  digit(C2),
  [58],
  digit(C3),
  digit(C4).


% ----------------------------------------------------------------------


blank --> [Code],
  {character_type(Code, blank)},
  !,
  blank.


blank --> [].


% ----------------------------------------------------------------------


letter(Code) -->
  [Code],
  { character_type(Code, letter) }.


digit(Code) -->
  [Code],
  { character_type(Code, digit) }.


% -----------------------------------------------------------------------------------


character_type(Code, blank) :-   
  Code =< 32, !.


character_type(Code, letter) :-
  (
    ( Code >= 65, Code =< 90 )
  ;
    ( Code >= 97, Code =< 122 )
  ;
     Code = 47                    %% '/'
  ;
     Code = 45                    %% '-'
  ),
  !.


character_type(Code, digit) :-
  Code >= 48, Code =< 57, !.


