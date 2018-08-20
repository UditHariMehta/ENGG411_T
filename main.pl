% ========================================================================
%  Project:   PENG Engine
%  Version:   0.01
%  Module:    main.pl
%  Date:      2013-01-19   
%  Modified:  2017-03-30
%  Status:    WORK IN PROGRESS!
%  Author:    Rolf Schwitter
%  Copyright: Macquarie University, 2017
% ========================================================================


% -----------------------------------------------------------------------
% Style checking
% -----------------------------------------------------------------------

:- style_check([-singleton, -discontiguous]).

:- set_prolog_flag(toplevel_print_options,
   [quoted(true), portray(true), max_depth(100), attributes(portray)]).


% -----------------------------------------------------------------------
% Modules
% -----------------------------------------------------------------------

:- use_module(library(time)).

:- use_module(library(gensym)).


% -----------------------------------------------------------------------
% Operators
% -----------------------------------------------------------------------

:- op(1150, xfy, ==>).
:- op(1150, xfy, ~~>).  
:- op(1125, yfx, or).
:- op(1100, fy,  neg).
:- op(1100, fy,  naf).
:- op(1100, fy,  cstr).


% -----------------------------------------------------------------------
% Multifile definition
% -----------------------------------------------------------------------

:- multifile lex/3, lex/4, lex/5.
:- dynamic lex/3, lex/4, lex/5.


% -----------------------------------------------------------------------
% Consult files
% -----------------------------------------------------------------------

:- consult('prolog/tokeniser.pl').

:- consult('prolog/chart_parser.pl').

:- consult('prolog/grammar.pl').

:- consult('prolog/lexicon.pl').

:- consult('prolog/user_lexicon.pl').

:- consult('prolog/drs_to_asp.pl').

:- consult('prolog/anaphora_resolution.pl').

:- consult('prolog/spelling_checker.pl').

:- consult('prolog/json_interface.pl').

:- consult('prolog/reasoner_interface.pl').

% test grammar module
:- consult('prolog/process_test_discourse.pl').


% -----------------------------------------------------------------------
% Initialise reasoner environment
% -----------------------------------------------------------------------

init_reasoner_environment :-
  (
     getenv(os, OSName),
     OSName = 'Windows_NT'
     ->
     absolute_file_name('clingo-5.1.0-win32/clingo-script.exe', FileNameClingo)
  ;
     process_create(path(uname), ['-s'], [stdout(pipe(Stream))]),
     read_stream(Stream, [76, 105, 110, 117, 120|_]),
     OSName = 'Linux'
     ->
     absolute_file_name('clingo-5.1.0-linux/clingo', FileNameClingo)
  ;
     process_create(path(uname), ['-s'], [stdout(pipe(Stream))]),
     read_stream(Stream, [68, 97, 114, 119, 105, 110|_]),
     OSName = 'Darwin'
     ->
     absolute_file_name('clingo-5.1.0-macos/clingo', FileNameClingo)
  ;
     nl(user),
     write(user, 'Operating System is unknown; no reasoning support available.'),
     nl(user)
  ),
  absolute_file_name('theory/asp_background.lp', FileNameBG),
  absolute_file_name('asp.lp', FileNameASP),
  absolute_file_name('model.txt', FileNameModel),
  asserta(reasoner_environment(OSName, FileNameBG, FileNameClingo, FileNameASP, FileNameModel)).

:- init_reasoner_environment.


% -----------------------------------------------------------------------
% This is the main process that is called by the Prolog server.
%
% main_process/2
% -----------------------------------------------------------------------

main_process(JSTNIn, JSON) :-
  incoming_data(JSTNIn),
  json_interface(JSTNIn, JSTNOut),
  atom_json_term(JSON, JSTNOut, [as(atom)]),
  outgoing_data(JSON).


%---------------------------------------------------------------
% incoming_data/1
%---------------------------------------------------------------

incoming_data(JSTN) :-
  open('data_in.txt', append, Stream),
  writeq(Stream, JSTN),
  nl(Stream),
  nl(Stream),close(Stream).


%---------------------------------------------------------------
% outgoing_data/1
%---------------------------------------------------------------

outgoing_data(JSON) :-
  open('data_out.txt', append, Stream),
  writeq(Stream, JSON),
  nl(Stream),
  nl(Stream),
  close(Stream).    


% -----------------------------------------------------------------------
% Puzzles & Texts
% -----------------------------------------------------------------------

text(0, 'prolog/texts/00-test-suite.txt').

% text(r, 'prolog/texts/00-rtest-suite.txt').

text(1, 'prolog/texts/01-mars-venus.txt').

text(2, 'prolog/texts/02-jobs-puzzle.txt').

text(3, 'prolog/texts/03-paris-marathon.txt').

text(4, 'prolog/texts/04-zebra.txt').

text(5, 'prolog/texts/05-uncaring-parents.txt').

text(6, 'prolog/texts/06-cowardly-student.txt').

text(7, 'prolog/texts/07-successful-student-a.txt').

text(8, 'prolog/texts/08-successful-student-b.txt').

text(9, 'prolog/texts/09-successful-student-owa-a.txt').

text(10, 'prolog/texts/10-successful-student-owa-b.txt').

text(11, 'prolog/texts/11-successful-student-cwa-a.txt').

text(12, 'prolog/texts/12-successful-student-cwa-b.txt').

text(13, 'prolog/texts/13-cardinal-ordinal.txt').

text(14, 'prolog/texts/14-counting-working-persons-a.txt').

text(15, 'prolog/texts/15-counting-working-persons-b.txt').

text(16, 'prolog/texts/16-counting-working-persons-cwa.txt').

text(17, 'prolog/texts/17-counting-not-working-persons-owa.txt').

text(18, 'prolog/texts/18-counting-not-working-persons-cwa.txt').

text(19, 'prolog/texts/19-exactly-one-colour.txt').

text(20, 'prolog/texts/20-exactly-one-distinct-colour.txt').

text(21, 'prolog/texts/21-do-most-persons-work-a.txt').
							   
text(22, 'prolog/texts/22-do-most-persons-work-b.txt').

text(23, 'prolog/texts/23-how-many-which-persons-work-a.txt').

text(24, 'prolog/texts/24-do-most-which-persons-work-b.txt').

text(25, 'prolog/texts/25-do-most-persons-not-work-c.txt').

text(26, 'prolog/texts/26-do-most-persons-work-unknown.txt').

text(27, 'prolog/texts/27-acl.txt').

text(28, 'prolog/texts/28-acl-distinct.txt').

text(29, 'prolog/texts/29-event-calculus-1.txt').

text(30, 'prolog/texts/30-lrec-1.txt').

text(31, 'prolog/texts/31-lrec-2.txt').

text(32, 'prolog/texts/32-lrec-cwa-minus.txt').

text(33, 'prolog/texts/33-lrec-cwa-plus.txt').

text(34, 'prolog/texts/34-lrec-owa-minus.txt').

text(35, 'prolog/texts/35-lrec-owa-plus.txt').

text(36, 'prolog/texts/36-brave-cautious-reasoning-1.txt').

text(37, 'prolog/texts/37-brave-cautious-reasoning-2.txt').

text(38, 'prolog/texts/38-brave-cautious-reasoning-3.txt').



% ========================================================================
% Run test (for testing purposes only)
%
%   ?- run_test(Mode, Number).
%   ?- run_all_tests(Mode).
%
%   Mode = chart
%   Mode = dcg
%
% ========================================================================

:- dynamic current_parsing_mode/1.

current_parsing_mode(chart).


run_test(Mode, Number) :-
  use_module(library('http/json')),
  no_style_check(singleton),
  no_style_check(discontiguous),
  (
     Mode = chart,
     current_parsing_mode(dcg)
     ->
     unload_file('prolog/grammar.pl'),
     unload_file('prolog/dcg_extension.pl'),
     consult('prolog/chart_parser.pl'),
     consult('prolog/grammar.pl'),
     retract(current_parsing_mode(dcg)),
     assert(current_parsing_mode(chart))
  ;
     Mode = dcg,
     current_parsing_mode(chart)
     ->
     unload_file('prolog/chart_parser.pl'),
     unload_file('prolog/grammar.pl'),
     consult('prolog/grammar.pl'),
     consult('prolog/dcg_extension.pl'),
     retract(current_parsing_mode(chart)),
     assert(current_parsing_mode(dcg))
  ;
     current_parsing_mode(Mode)
     ->
     true
  ),
  profile(run_test_1(Mode, Number)),
  nl,
  write('====================================================================='),
  nl, nl.


run_test_1(Mode, Number) :-
  text(Number, InputFile),
  read_input_file(InputFile, CodeList),
  tokeniser(CodeList, Discourse, []), !,
  process_test_discourse(Mode, Number, Discourse),
  (
      Mode = chart
      ->
      clean_up_chart
  ;
      Mode = dcg
      ->
      true
  ).


% -----------------------------------------------------------------------
% run_all_tests/1
% -----------------------------------------------------------------------

run_all_tests(Mode) :-
  findall(Number, text(Number, Path), Numbers),
  use_module(library('http/json')),
  no_style_check(singleton),
  no_style_check(discontiguous),
  (
     Mode = chart,
     current_parsing_mode(dcg)
     ->
     unload_file('prolog/grammar.pl'),
     unload_file('prolog/dcg_extension.pl'),
     consult('prolog/chart_parser.pl'),
     consult('prolog/grammar.pl'),
     retract(current_parsing_mode(dcg)),
     assert(current_parsing_mode(chart))
  ;
     Mode = dcg,
     current_parsing_mode(chart)
     ->
     unload_file('prolog/chart_parser.pl'),
     unload_file('prolog/grammar.pl'),
     consult('prolog/grammar.pl'),
     consult('prolog/dcg_extension.pl'),
     retract(current_parsing_mode(chart)),
     assert(current_parsing_mode(dcg))
  ;
     current_parsing_mode(Mode)
     ->
     true
  ),
  run_tests(Mode, Numbers).


run_tests(Mode, []) :-
  nl, 
  write('========================= ALL TESTS PASSED =========================='),
  nl.


run_tests(Mode, [Number|Numbers]) :-
  profile(run_test_2(Mode, Number)),
  % run_test_2(Mode, Number),
  nl,
  write('====================================================================='),
  nl,
  run_tests(Mode, Numbers).


run_test_2(Mode, Number) :-
  text(Number, InputFile),
  read_input_file(InputFile, CodeList),
  tokeniser(CodeList, Discourse, []), !,
  process_test_discourse(Mode, Number, Discourse),
  (
     Mode = chart
     ->
     clean_up_chart
  ;
     Mode = dcg
     ->
     true
  ).
