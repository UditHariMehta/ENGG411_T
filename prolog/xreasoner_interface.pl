% ========================================================================
%  Project:   PENG Engine
%  Version:   0.01
%  Module:    reasoner_interface.pl
%  Date:      2014-09-23
%  Modified:  2015-09-30
%  Status:    WORK IN PROGRESS!
%  Author:    Rolf Schwitter
%  Copyright: Macquarie University, 2016
% ========================================================================


% -----------------------------------------------------------------------
% call_reasoner/7
%
% -----------------------------------------------------------------------

call_reasoner(Flag, RMode, Token, Drs, ASPAtom, ModelAtom, Answer) :-
  (
     Flag = on,
     reasoner_environment(OSName, FileNameBG, FileNameClingo, FileNameASP, FileNameModel)
     ->
     (
        OSName = 'Windows_NT'
        ->
        (
           RMode = normal -> ENumMode = auto
           ->
           atomic_list_concat(['cmd.exe /C ', FileNameClingo, ' -e ', ENumMode, ' -n 2 --project ', FileNameASP, ' > ', FileNameModel], ReasonerCommand)
        ;
           RMode = brave -> ENumMode = brave
           ->
           atomic_list_concat(['cmd.exe /C ', FileNameClingo, ' -e ', ENumMode, ' -n 0 --project ', FileNameASP, ' > ', FileNameModel], ReasonerCommand)
        ;
           RMode = cautious -> ENumMode = cautious
           ->
           atomic_list_concat(['cmd.exe /C ', FileNameClingo, ' -e ', ENumMode, ' -n 0 --project ', FileNameASP, ' > ', FileNameModel], ReasonerCommand)
        )
     ;
        write('Unkown Operating System'), nl, nl
     ),
     reverse_drs(Drs, RDrs1),
     copy_term(RDrs1, RDrs2),
     translate_drs_to_asp(RDrs2, ASP, TheoryFlags),
     numbervars(ASP, 0, _),
     update_lua_script(FileNameBG, TheoryFlags, BGTheory),
     write_to_file(FileNameASP, ASP, BGTheory),
     display_asp(json, FileNameASP, ASPAtom),
     shell(ReasonerCommand, Status),
     display_model(json, RMode, Token, FileNameModel, ModelAtom, Answer)
  ;
     Flag = off
     ->
     ASPAtom   = [],
     ModelAtom = []
  ).


% -----------------------------------------------------------------------
% display_model/5
%
% -----------------------------------------------------------------------

display_model(Mode, RMode, Token, FileName, Atom, Answer) :-
   open(FileName, read, Stream),
   read_stream_to_chars(Stream, CharList),
   close(Stream),
   (
      Token = '.'
      ->
      extract_answer_from_model_1(CharList, Result),
      (
         Result = [],
         Answer = [['unknown']]
      ;
         Result = Answer
      )
   ;
      Token = '?'
      ->
      extract_answer_from_model_2(RMode, CharList, Result),
      (
         Result = [],
         Answer = [['unknown']]
      ;
         Result = Answer
      )
   ),
   atom_chars(Atom, CharList),
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
% read_stream_to_chars/2
% -----------------------------------------------------------------------

read_stream_to_chars(Stream, []) :-
  peek_char(Stream, -1), !.

read_stream_to_chars(Stream, [Char|Chars]) :-
  get_char(Stream, Char),
  read_stream_to_chars(Stream, Chars).


% -----------------------------------------------------------------------
% extract_answer_from_model_1/2
%
% -----------------------------------------------------------------------

extract_answer_from_model_1(Chars, Output) :-
  check_model_status(Chars, Status, ModelNumber),
  (
     ModelNumber = '0'
     ->
     Output = [Status, ['Model: 0']]
  ;
     ModelNumber = '1'
     ->
     Output = [Status, ['Model: 1']]
  ;
     ModelNumber = '1+'
     ->
     Output = [Status, ['Models: 1+']]
  ;
     ModelNumber = '2'
     ->
     Output = [Status, ['Model: 2']]
  ;
     ModelNumber = '2+'
     ->
     Output = [Status, ['Models: 2+']]
  ;
     ModelNumber = []
     ->
     Output = []
  ).


% -----------------------------------------------------------------------
% extract_answer_from_model_2/3
%   RMode = normal
% -----------------------------------------------------------------------

extract_answer_from_model_2(RMode, Chars, Output) :-
  RMode = normal,
  check_model_status(Chars, Status, ModelNumber),
  (
     ModelNumber = '0'
     ->
     Output = [Status, ['Model: 0']]
  ;
     ModelNumber = '1'
     ->
     extract_answer_from_model(Chars, Result),
     sort(Result, SResult),
     format_answer(SResult, FormatResult),
     Output = [Status, ['Normal Reasoning']|FormatResult]
  ;
     ModelNumber = '1+'
     ->
     Output = [Status, ['Models: 1+']]
  ;
     ModelNumber = '2'
     ->
     Output = [Status, ['Models: 2']]
  ;
     ModelNumber = '2+'
     ->
     Output = [Status, ['Models: 2+']]
  ;
     ModelNumber = []
     ->
     Output = []
  ).


% -----------------------------------------------------------------------
% extract_answer_from_model_2/3
%   RMode = brave
% -----------------------------------------------------------------------

extract_answer_from_model_2(RMode, Chars, Output) :-
  RMode = brave,
  check_model_status(Chars, Status, ModelNumber),
  (
     ModelNumber = '0'
     ->
     Output = [Status, ['Model: 0']]
  ;
     find_last_model(Chars, LastModelChars),
     % nl(user), write(user, LastModelChars), nl(user),
     extract_answer_from_model(LastModelChars, Result1),
     remove_unknown_answers(Result1, Result2),
     format_answer(Result2, FormatResult),
     Output = [Status, ['Brave Reasoning']|FormatResult]
  ).


% -----------------------------------------------------------------------
% find_last_model/2
% 
% -----------------------------------------------------------------------

find_last_model(Chars, LastModel) :-
  extract_all_models(Chars, Models),
  reverse(Models, [LastModel|RestModels]).


% -----------------------------------------------------------------------
% remove_unknown_answers/2
% 
% -----------------------------------------------------------------------

remove_unknown_answers(Answers1, Answers2) :-
  atom_to_term_list(Answers1, AnswersTerm1),
  remove_unknown_answers_2(AnswersTerm1, AnswersTerm2),
  atom_to_term_list(Answers2, AnswersTerm2).
   

remove_unknown_answers_2([], Answers).

remove_unknown_answers_2([[Num, ans(No, 'unknown', Pol, World)]|Rest], Answers) :-
  remove_unknown_answers_2(Rest, Answers).

remove_unknown_answers_2([Answer|Rest], [Answer|Answers]) :-
  remove_unknown_answers_2(Rest, Answers).


atom_to_term_list([], []).

atom_to_term_list([[Num, Atom]|Rest1], [[Num, Term]|Rest2]) :-
  term_to_atom(Term, Atom),
  atom_to_term_list(Rest1, Rest2).


% -----------------------------------------------------------------------
% extract_answer_from_model_2/3
%   RMode = cautious
% -----------------------------------------------------------------------

extract_answer_from_model_2(RMode, Chars, Output) :-
  RMode = cautious,
  check_model_status(Chars, Status, ModelNumber),
  (
     ModelNumber = '0'
     ->
     Output = [Status, ['Model: 0']]
  ;
     find_last_model(Chars, LastModelChars),
     % nl(user), write(user, LastModelChars), nl(user),
     extract_answer_from_model(LastModelChars, Result),
     format_answer(Result, FormatResult),
     Output = [Status, ['Cautious Reasoning']|FormatResult]
  ).


% -----------------------------------------------------------------------
% check_model_status/3
%
% -----------------------------------------------------------------------

check_model_status([], [], []).

check_model_status(['M', o, d, e, l, s, ' ', ' ', ' ', ' ', ' ', ' ', ' ', ':', ' ', '2', '+'|Chars], [], '2+').

check_model_status(['M', o, d, e, l, s, ' ', ' ', ' ', ' ', ' ', ' ', ' ', ':', ' ', '2'|Chars], [], '2').

check_model_status(['M', o, d, e, l, s, ' ', ' ', ' ', ' ', ' ', ' ', ' ', ':', ' ', '1', '+'|Chars], [], '1+').

check_model_status(['M', o, d, e, l, s, ' ', ' ', ' ', ' ', ' ', ' ', ' ', ':', ' ', '1'|Chars], [], '1').

check_model_status(['M', o, d, e, l, s, ' ', ' ', ' ', ' ', ' ', ' ', ' ', ':', ' ', '0'|Chars], [], '0').  

check_model_status(['U', 'N', 'S', 'A', 'T', 'I', 'S', 'F', 'I', 'A', 'B', 'L', 'E'|Chars], ['UNSATISFIABLE'|Status], Result) :-
  check_model_status(Chars, Status, Result).
  
check_model_status(['S', 'A', 'T', 'I', 'S', 'F', 'I', 'A', 'B', 'L', 'E'|Chars], ['SATISFIABLE'|Status], Result) :-
  check_model_status(Chars, Status, Result).

check_model_status(['U', 'N', 'K', 'N', 'O', 'W', 'N'|Chars], ['UNKNOWN'|Status], Result) :-
  check_model_status(Chars, Status, Result).

check_model_status([Char|Chars], Status, Result) :-
  check_model_status(Chars, Status, Result).


% -----------------------------------------------------------------------
% extract_all_models/2
%
% -----------------------------------------------------------------------

extract_all_models([], []).

extract_all_models(Chars1, [Model|Models]) :-  
  append(['A', n, s, w, e, r, :|_], ['\n'|Chars2], Chars1), 
  append(Model, ['\n'|Chars3], Chars2),                   
  extract_all_models(Chars3, Models).

extract_all_models([Char|Chars], Models) :-  
  extract_all_models(Chars, Models).


% -----------------------------------------------------------------------
% extract_answer_from_model/2
%
% -----------------------------------------------------------------------

extract_answer_from_model([], []).

extract_answer_from_model(Chars1, [List|Result]) :-
  append([a, n, s, '('|Rest], [')', ' '|Chars2], Chars1),
  append([a, n, s, '('|Rest], [')'], Answer),
  generate_answer(Answer, List),
  extract_answer_from_model(Chars2, Result).

extract_answer_from_model(Chars1, [List|Result]) :-
  append([a, n, s, '('|Rest], [')', '\n'|Chars2], Chars1),
  append([a, n, s, '('|Rest], [')'], Answer),
  generate_answer(Answer, List),
  extract_answer_from_model(Chars2, Result).

extract_answer_from_model(Answer, [List]) :-
  append([a, n, s, '('|Rest], [')'], Answer),
  generate_answer(Answer, List).

extract_answer_from_model([Char|Chars], Result) :-
  extract_answer_from_model(Chars, Result).


% -----------------------------------------------------------------------
% generate_answer/2
%
% -----------------------------------------------------------------------

generate_answer(Rest, [Atom1, Atom2]) :-
  append([a, n, s, '(', n, o|Number], [','|Answer], Rest),
  atom_codes(Atom1, Number),
  atom_codes(Atom2, Rest).
  

% -----------------------------------------------------------------------
% format_answer/2
%
% -----------------------------------------------------------------------

format_answer([], []).

format_answer([[Number, Answer]|Lists1], [[FAnswer]|FAnswers]) :-
  find_answers_with_same_number(Number, [[Number, Answer]|Lists1], Lists2, Answers),
  atomic_list_concat(Answers, ', ', Atom),
  atomic_list_concat(['No. ', Number, ': ', Atom], FAnswer),
  format_answer(Lists2, FAnswers).

find_answers_with_same_number(Number1, [], [], []).

find_answers_with_same_number(Number1, [[Number2, Answer]|Lists1], Lists2, [Answer|Answers]) :-
  Number1 == Number2,
  find_answers_with_same_number(Number1, Lists1, Lists2, Answers).
  
find_answers_with_same_number(Number1, [[Number2, Answer]|Lists1], [[Number2, Answer]|Lists2], Answers) :-
  find_answers_with_same_number(Number1, Lists1, Lists2, Answers).


% -----------------------------------------------------------------------
% call_asp_solver/2
%
% -----------------------------------------------------------------------

call_asp_solver(CallASPSolver, Status) :-
  shell(CallASPSolver, Status).


% ------------------------------------------------------------------------
% write_to_file/3
% ------------------------------------------------------------------------

write_to_file(File, ASP, []) :-
  open(File, write, Stream),
  write_answer_set_program(Stream, ASP),
  close(Stream).

write_to_file(File, ASP, BGTheory) :-
  open(File, write, Stream),
  write_answer_set_program(Stream, ASP),
  nl(Stream),
  nl(Stream),
  write(Stream, BGTheory),
  close(Stream).


% ------------------------------------------------------------------------
% display_asp/3
% ------------------------------------------------------------------------

display_asp(json, FileName, Atom) :-
  open(FileName, read, Stream),
  read_stream(Stream, CodesList),
  close(Stream),
  atom_codes(Atom, CodesList).


% ------------------------------------------------------------------------
% update_lua_script/3
% ------------------------------------------------------------------------

update_lua_script(FileNameBG, TheoryFlags, BGTheory) :-
  read_file_to_codes(FileNameBG, Codes1, []),
  lua_script_header(Header),
  lua_script_body(TheoryFlags, Body),
  lua_script_footer(Footer),
  atomic_list_concat([Header, Body, Footer], LuaScriptAtom),
  write_to_codes(LuaScriptAtom, Codes2),
  append(Codes1, Codes2, Codes3),
  atom_codes(BGTheory, Codes3).


% ------------------------------------------------------------------------
% Lua script
% ------------------------------------------------------------------------

% Header
%
lua_script_header('\c
% -----------------------------
% LUA SCRIPT:
#script (lua) \n\c
add = table.insert \n\c
function main(prg) \n\c
\s parts = {} \n\c
\s add(parts, {\"base\", {}}) \n\c').


% Body
%
lua_script_body(TheoryFlags, Body) :-
  lua_script_body_parts(TheoryFlags, BodyParts),
  atomic_list_concat(BodyParts, Body).

lua_script_body_parts([], []).

lua_script_body_parts([Flag|TheoryFlags], [BodyPart|BodyParts]) :-
   atomic_list_concat(['\s add(parts, {\"', Flag, '\", {}}) \n\c'], BodyPart),
   lua_script_body_parts(TheoryFlags, BodyParts).

% Footer
%
lua_script_footer('\c
\s prg:ground(parts) \n\c
\s prg:solve() \n\c
\s end \n\c
#end.').




  
