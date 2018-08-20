% =========================================================================
%  Project:   PENG Engine
%  Version:   0.01
%  Module:    lexicon.pl
%  Date:      2012-04-22
%  Modified:  2016-01-20
%  Status:    DEMO VERSION !
%  Author:    Rolf Schwitter
%  Copyright: Rolf Schwitter, Macquarie University, 2016
% =========================================================================

% =========================================================================
% Lexicon
% =========================================================================

% ------------------------------------------------------------------------
% Dynamic Predicate
% ------------------------------------------------------------------------

:- dynamic lexicon/1.

% ------------------------------------------------------------------------

%% spc:no -- no spell checking


lexicon([spc:no, cat:temporal_expression, wfm:[TimeEx], arg:[num:_, ind:I], con:timex(I, TimeSym)]) :-
   atom_to_chars(TimeEx, [H1, H2, 58, M1, M2]),
   ( 
      H1 = 48, H2 = 48, M1 = 48, M2 = 48
      ->
      atom_to_chars(TimeSym, [48])
   ;
      H1 = 48, H2 = 48, M1 = 48, M2 > 48, M2 =< 57
      ->
      atom_to_chars(TimeSym, [M2])
   ;
      H1 = 48, H2 = 48,  M1 > 48, M2 >= 48, M2 =< 57
      ->
      atom_to_chars(TimeSym, [M1, M2])
   ;
      H1 = 48, H2 > 48, H2 =< 57,  M1 >= 48, M1 =< 57, M2 >= 48, M2 =< 57
      ->
      atom_to_chars(TimeSym, [H2, M1, M2])
   ;
      H1 > 48, H1 =< 57, H2 >= 48, H2 =< 57, M1 >= 48, M1 =<57, M2>=48, M2 =< 57
      ->
      atom_to_chars(TimeSym, [H1, H2, M1, M2])
   ).
 

% ------------------------------------------------------------------------

lexicon([cat:full_stop, wfm:['.']]).

lexicon([cat:question_mark, wfm:['?']]).

lexicon([cat:comma, wfm:[',']]).


% ------------------------------------------------------------------------

lexicon([cat:adjective, wfm:WF, evtl:E, con:prop(E, Sym)]) :-
   lex(adjective, WF, Sym).

lex(adjective, [absent], absent).
lex(adjective, [awake], awake).
lex(adjective, [educated], educated).
lex(adjective, [employed], employed).
lex(adjective, [female], female).
lex(adjective, [male], male).
lex(adjective, [sellable], sellable).
lex(adjective, [successful], successful).
lex(adjective, [truthful], truthful).

lex(adjective, ['Red'], red).
lex(adjective, [red], red).
lex(adjective, [green], green).
lex(adjective, [ivory], ivory).
lex(adjective, [yellow], yellow).
lex(adjective, [blue], blue).
lex(adjective, [black], black).
lex(adjective, [white], white).

% Experimental
lex(name, ['Red'], red).
% lex(name, [red], red).
lex(name, [green], green).
lex(name, [ivory], ivory).
lex(name, [yellow], yellow).
lex(name, [blue], blue).
lex(name, [white], white).


% -----------------------------------------------------------------------

lexicon([cat:adjective, wfm:WF]) :-
   lex(adjective, WF).

lex(adjective, [distinct]).


% ------------------------------------------------------------------------

lexicon([cat:cardinal, wfm:WF, arg:[num:N, ind:I], con:cardinal(I, Sym, Number)]) :-
   lex(cardinal, N, WF, Sym, Number).

lex(cardinal, sg, [exactly, one],    eq, 1).
lex(cardinal, pl, [exactly, two],    eq, 2).
lex(cardinal, pl, [exactly, three],  eq, 3).
lex(cardinal, pl, [exactly, four],   eq, 4).
lex(cardinal, pl, [exactly, five],   eq, 5).
lex(cardinal, pl, [exactly, six],    eq, 6).
lex(cardinal, pl, [exactly, seven],  eq, 7).
lex(cardinal, pl, [exactly, eight],  eq, 8).
lex(cardinal, pl, [exactly, nine],   eq, 9).
lex(cardinal, pl, [exactly, ten],    eq, 10).
lex(cardinal, pl, [exactly, eleven], eq, 11).
lex(cardinal, pl, [exactly, twelve], eq, 12).


lex(cardinal, sg, [exactly, 1],  eq, 1).
lex(cardinal, pl, [exactly, 2],  eq, 2).
lex(cardinal, pl, [exactly, 3],  eq, 3).
lex(cardinal, pl, [exactly, 4],  eq, 4).
lex(cardinal, pl, [exactly, 5],  eq, 5).
lex(cardinal, pl, [exactly, 6],  eq, 6).
lex(cardinal, pl, [exactly, 7],  eq, 7).
lex(cardinal, pl, [exactly, 8],  eq, 8).
lex(cardinal, pl, [exactly, 9],  eq, 9).
lex(cardinal, pl, [exactly, 10], eq, 10).
lex(cardinal, pl, [exactly, 11], eq, 11).
lex(cardinal, pl, [exactly, 12], eq, 12).

% lex(cardinal, pl, [at, least, two],    eq, 2).


lex(cardinal, pl, [one, or, more],    geq, 1).
lex(cardinal, pl, [two, or, more],    geq, 2).
lex(cardinal, pl, [three, or, more],  geq, 3).
lex(cardinal, pl, [four, or, more],   geq, 4).
lex(cardinal, pl, [five, or, more],   geq, 5).
lex(cardinal, pl, [six, or, more],    geq, 6).
lex(cardinal, pl, [seven, or, more],  geq, 7).
lex(cardinal, pl, [eight, or, more],  geq, 8).
lex(cardinal, pl, [nine, or, more],   geq, 9).
lex(cardinal, pl, [ten, or, more],    geq, 10).
lex(cardinal, pl, [eleven, or, more], geq, 11).
lex(cardinal, pl, [twelve, or, more], geq, 12).


% ------------------------------------------------------------------------

lexicon([cat:number, wfm:WF, arg:[num:N, ind:I], con:number(I, Sym)]) :-
   lex(number, N, WF, Sym).

lex(number, sg, [1],  1).
lex(number, pl, [2],  2).
lex(number, pl, [3],  3).
lex(number, pl, [4],  4).
lex(number, pl, [5],  5).
lex(number, pl, [6],  6).
lex(number, pl, [7],  7).
lex(number, pl, [8],  8).
lex(number, pl, [9],  9).
lex(number, pl, [10], 10).
lex(number, pl, [11], 11).
lex(number, pl, [12], 12).


% ------------------------------------------------------------------------

lexicon([cat:ordinal, wfm:WF, arg:[num:sg, ind:I], con:ordinal(I, Sym)]) :-
  lex(ordinal, WF, Sym).

lex(ordinal, [first],  1).
lex(ordinal, [second], 2).
lex(ordinal, [third],  3).
lex(ordinal, [fourth], 4).
lex(ordinal, [fifth],  5).
lex(ordinal, [sixth],  6).


% ------------------------------------------------------------------------

lexicon([cat:constraint, wfm:['Reject']]).

lexicon([cat:constraint, wfm:['Exclude']]).

lexicon([cat:constraint, wfm:['It', is, not, the, case]]).

lexicon([cat:constraint, wfm:['It', is, false]]).

lexicon([cat:constraint, wfm:[reject]]).

lexicon([cat:constraint, wfm:[exclude]]).

lexicon([cat:constraint, wfm:[it, is, not, the, case]]).

lexicon([cat:constraint, wfm:[it, is, false]]).	


% ------------------------------------------------------------------------

lexicon([cat:determiner, wfm:['For', every], arg:[num:sg, ind:I], qnt:forall]).

lexicon([cat:determiner, wfm:['Every'], arg:[num:sg, ind:I], qnt:all]).

lexicon([cat:determiner, wfm:[every], arg:[num:sg, ind:I], qnt:all]).

lexicon([cat:determiner, wfm:['No'], arg:[num:sg, ind:I], qnt:neg]).

lexicon([cat:determiner, wfm:[no], arg:[num:sg, ind:I], qnt:neg]).

lexicon([cat:determiner, wfm:['A'], arg:[num:sg, ind:I], qnt:exist]).

%% lexicon([cat:determiner, wfm:[another], arg:[num:sg, ind:I], qnt:exist]).

lexicon([cat:determiner, wfm:[a], arg:[num:sg, ind:I], qnt:exist]).

lexicon([cat:determiner, wfm:['An'], arg:[num:sg, ind:I], qnt:exist]).

lexicon([cat:determiner, wfm:[an],  arg:[num:sg, ind:I], qnt:exist]).

lexicon([cat:determiner, wfm:['The'], arg:[num:sg, ind:I], qnt:def]).

lexicon([cat:determiner, wfm:[the], arg:[num:sg, ind:I], qnt:def]).

%% lexicon([cat:determiner, wfm:[the, same], arg:[num:sg, ind:I], qnt:def]).

lexicon([cat:determiner, wfm:[that], arg:[num:sg, ind:I], qnt:def]).

lexicon([cat:determiner, wfm:[most], arg:[num:pl, ind:I], qnt:most]).


% ------------------------------------------------------------------------

lexicon([cat:wh_determiner, wfm:WF, arg:[num:N, ind:I]]) :-
  lex(wh_determiner, WF, N).

lex(wh_determiner, ['How', many], pl).
lex(wh_determiner, [how, many], pl).
lex(wh_determiner, ['Which'], _).
lex(wh_determiner, [which], _).
lex(wh_determiner, [what], _).


% ------------------------------------------------------------------------

lexicon([cat:auxiliary, wfm:WF, arg:[num:N, ind:I]]) :-
  lex(auxiliary, WF, N).

lex(auxiliary, ['Do'], pl).
lex(auxiliary, ['Does'], sg).
lex(auxiliary, [does], sg).
lex(auxiliary, [do], pl).


% ------------------------------------------------------------------------

lexicon([cat:wh_pronoun, wfm:WF, arg:[num:N, ind:I1], con:query(I1, Sym, I2)]) :-
  lex(wh_pronoun, WF, Sym).

lex(wh_pronoun, ['What'], what).
% lex(wh_pronoun, [what], what).
lex(wh_pronoun, ['Who'], who).


% ------------------------------------------------------------------------

lexicon([cat:wh_adverb, wfm:WF, arg:[num:_, ind: I], evtl:E, con:prop(E, I, Sym)]) :-
  lex(wh_adverb, WF, Sym).

lex(wh_adverb, ['Where'], location).



lexicon([cat:wh_adverb, wfm:WF]) :-
  lex(wh_adverb, WF).

lex(wh_adverb, ['Where']).


% ------------------------------------------------------------------------

lexicon([cat:ex_there, wfm:['There', is], arg:[num:sg, ind:I], qnt:exist]).

lexicon([cat:ex_there, wfm:[there, is], arg:[num:sg, ind:I], qnt:exist]).

lexicon([cat:ex_there, wfm:['There', are], arg:[num:pl, ind:I], qnt:exist]).

lexicon([cat:ex_there, wfm:[there, are], arg:[num:pl, ind:I], qnt:exist]).


lexicon([cat:ex_there, wfm:['There', exists], arg:[num:sg, ind:I], qnt:exist]).

lexicon([cat:ex_there, wfm:[there, exists], arg:[num:sg, ind:I], qnt:exist]).

lexicon([cat:ex_there, wfm:['There', exist], arg:[num:pl, ind:I], qnt:exist]).

lexicon([cat:ex_there, wfm:[there, exist], arg:[num:pl, ind:I], qnt:exist]).


% ------------------------------------------------------------------------

lexicon([cat:count_noun, wfm:WF, arg:[num:sg, ind:I], con:object(I, Sym, count)]) :-
   lex(count_noun, sg, WF, Sym).

lex(count_noun, sg, ['martian'], martian).
lex(count_noun, sg, ['Martian'], martian).
lex(count_noun, sg, [runner], runner).
lex(count_noun, sg, [person],  person).
lex(count_noun, sg, [position], position).
lex(count_noun, sg, ['venusian'], venusian).
lex(count_noun, sg, ['Venusian'], venusian).


lex(count_noun, sg, [job], job).
lex(count_noun, sg, [chef], chef).
lex(count_noun, sg, [guard], guard).
lex(count_noun, sg, [nurse], nurse).
lex(count_noun, sg, [telephone, operator], operator).
lex(count_noun, sg, [police, officer], police).
lex(count_noun, sg, [police, man], police_man).

lex(count_noun, sg, [teacher], teacher).
lex(count_noun, sg, [actor], actor).
lex(count_noun, sg, [boxer], boxer).

lex(count_noun, sg, [husband], husband).

lex(count_noun, sg, [child], child).
lex(count_noun, sg, [father], father).
lex(count_noun, sg, [mother], mother).
lex(count_noun, sg, [parent], parent).

lex(count_noun, sg, [student], student).

lex(count_noun, sg, ['Department'], department).
lex(count_noun, sg, ['department'], department).

lex(count_noun, sg, [lecturer], lecturer).

lex(count_noun, sg, [degree, program], degree_program).

lex(count_noun, sg, ['Englishman'], englishman).

lex(count_noun, sg, ['Japanese'], japanese).

lex(count_noun, sg, ['Norwegian'], norwegian).

lex(count_noun, sg, ['Spaniard'], spaniard).

lex(count_noun, sg, ['Ukrainian'], ukrainian).

lex(count_noun, sg, [animal], animal).

lex(count_noun, sg, [dog], dog).

lex(count_noun, sg, [fox], fox).

lex(count_noun, sg, [horse], horse).

lex(count_noun, sg, [snail], snail).

lex(count_noun, sg, [zebra], zebra).

lex(count_noun, sg, [national], national).

lex(count_noun, sg, [animal], animal).

lex(count_noun, sg, [colour], colour).

lex(count_noun, sg, [house], house).

lex(count_noun, sg, [drink], drink).

lex(count_noun, sg, [cigarette, brand], cigarette_brand).


lex(count_noun, sg, [car], car).

lex(count_noun, sg, [vehicle], vehicle).

lex(count_noun, sg, [thing], thing).

lex(count_noun, sg, [casual, job], casual_job).

lex(count_noun, sg, ['English', degree], english_degree).

lex(count_noun, sg, ['Computer', 'Science', degree], computer_science_degree).

lex(count_noun, sg, ['Mathematics', degree], mathematics_degree).

lex(count_noun, sg, [degree, program], degree_program).

lex(count_noun, sg, [course], course).

lex(count_noun, sg, [office], office).  

lex(count_noun, sg, [time, point], time_point). 


lex(count_noun, sg, [man], man).

lex(count_noun, sg, [husband], husband).

lex(count_noun, sg, [bachelor], bachelor).


lex(count_noun, sg, [holding], holding).

lex(count_noun, sg, [company], company).

lex(count_noun, sg, [newspaper], newspaper).

lex(count_noun, sg, [media, company], media_company).

lex(count_noun, sg, [garden], garden).

% ------------------------------------------------------------------------

lexicon([cat:count_noun, wfm:WF, arg:[num:pl, ind:I], con:object(I, Sym, count)]) :-
   lex(count_noun, pl, WF, Sym).

lex(count_noun, pl, [runners], runner).
lex(count_noun, pl, [positions], position).

lex(count_noun, pl, [jobs], job).
lex(count_noun, pl, [persons],  person).

lex(count_noun, pl, [students], student).
lex(count_noun, pl, [lecturers], lecturer).

lex(count_noun, pl, [degree, programs], degree_program).

lex(count_noun, pl, [colours], colour).
lex(count_noun, pl, [drinks], drink).
lex(count_noun, pl, [cigarette, brands], cigarette_brand).

lex(count_noun, pl, [houses], house).
 
lex(count_noun, pl, [cars], car).
lex(count_noun, pl, [vehicles], vehicle).

lex(count_noun, pl, [things], thing).

lex(count_noun, pl, ['Students'], student).
lex(count_noun, pl, ['Parents'], parent).

lex(count_noun, pl, [courses], course).

lex(count_noun, pl, [companies], company).

lex(count_noun, pl, [newspapers], newspaper).

% ------------------------------------------------------------------------

lexicon([cat:name, wfm:WF, arg:[num:sg, ind:I], con:named(I, Sym)]) :-
   lex(name, WF, Sym).

lex(name, ['Dilbert'], dilbert).

lex(name, ['Dominique'], dominique).
lex(name, ['Ignace'], ignace).
lex(name, ['Naren'], naren).
lex(name, ['Olivier'], olivier).
lex(name, ['Pascal'], pascal).
lex(name, ['Philippe'], philippe).

lex(name, ['Bog'], bog).
lex(name, ['Ork'], ork).
lex(name, ['Mars'], mars).
lex(name, ['Venus'], venus).

lex(name, ['Roberta'], roberta).
lex(name, ['Thelma'], thelma).
lex(name, ['Steve'], steve).
lex(name, ['Pete'], pete).

lex(name, ['Chef'], chef).
lex(name, [chef], chef).
lex(name, [guard], guard).
lex(name, [nurse], nurse).

lex(name, [telephone, operator], operator).
lex(name, [police, officer], police).

lex(name, [teacher], teacher).
lex(name, [actor], actor).
lex(name, [boxer], boxer).

lex(name, ['Alice'], alice).
lex(name, ['Sam'], sam).
lex(name, ['John'], john).

lex(name, ['Dave'], dave).
lex(name, ['Mary'], mary).
lex(name, ['Bob'], bob).
lex(name, ['Pat'], pat).

lex(name, ['Ron'], ron).
lex(name, ['Sue'], sue).

lex(name, ['Lin'], lin).

lex(name, ['Mike'], mike).

lex(name, ['Tom'], tom).
lex(name, ['Tom','Miller'], tom_miller).

lex(name, ['English'], english).
lex(name, ['Computer', 'Science'], computer_science).
lex(name, ['Information', 'Technology'], information_technology).
lex(name, ['Macquarie', 'University'], macquarie_university).
lex(name, ['Macquarie'], macquarie_university).
lex(name, ['Mathematics'], mathematics).
lex(name, ['Biology'], biology).

lex(name, ['Web', 'Technology'], web_technology).
lex(name, ['Information', 'Systems'], information_systems).

lex(name, [math], math).
lex(name, ['DMTH137'], dmth137).

% lex(name, ['Coffee'], coffee).
% lex(name, [coffee], coffee).
% lex(name, [tea], tea).
% lex(name, [milk], milk).
% lex(name, [orange, juice], orange_juice).
% lex(name, [water], water).

lex(name, ['Old', 'Gold'], old_gold).
lex(name, ['Kools'], kools).
lex(name, ['Chesterfields'], chesterfields).
lex(name, ['Lucky', 'Strike'], lucky_strike).
lex(name, ['Parliaments'], parliaments).

lex(name, [tutor], tutor).

lex(name, [shop, assistant], shop_assistant).

lex(name, ['Fairfax', 'Media', 'Limited'], fairfax).

lex(name, ['Fairfax'], fairfax).

lex(name, ['The', 'Sydney', 'Morning', 'Herald'], the_smh).

lex(name, ['The', 'Age'], the_age).

lex(name, ['The', 'Australian', 'Financial', 'Review'], the_afr).

lex(name, ['The', 'Australian'], the_australian).

% ------------------------------------------------------------------------

lexicon([cat:mass_noun, wfm:WF, arg:[num:sg, ind:I], con:object(I, Sym, mass)]) :-
   lex(mass_noun, WF, Sym).

lex(mass_noun, ['Coffee'], coffee).
lex(mass_noun, [coffee], coffee).
lex(mass_noun, [tea], tea).
lex(mass_noun, ['Tea'], tea).
lex(mass_noun, [milk], milk).
lex(mass_noun, ['Milk'], milk).
lex(mass_noun, [orange, juice], orange_juice).
lex(mass_noun, ['Orange', juice], orange_juice).
lex(mass_noun, [water], water).
lex(mass_noun, ['Water'], water).  

% ------------------------------------------------------------------------

lexicon([cat:transitive_verb, wfm:WF, arg:[num:Num, ind:I1], arg:[num:_, ind:I2], vform:VForm, evtl:E, con:pred(E, I1, I2, Sym)]) :-
  lex(transitive_verb, VForm, Num, WF, Sym).

lex(transitive_verb, fin, sg, [accommodates], accommodate).
lex(transitive_verb, fin, pl, [accommodate], accommodate).
lex(transitive_verb, inf,  _, [accommodate], accommodate).

lex(transitive_verb, fin, sg, [allocates], allocate).
lex(transitive_verb, fin, pl, [allocate], allocate).
lex(transitive_verb, inf,  _, [allocate], allocate).

lex(transitive_verb, fin, sg, [cares, about], care_about).
lex(transitive_verb, fin, pl, [care, about], care_about).
lex(transitive_verb, inf,  _, [care, about], care_about).

lex(transitive_verb, fin, sg, [drinks], drink).
lex(transitive_verb, fin, pl, [drink], drink).
lex(transitive_verb, inf,  _, [drink], drink).

lex(transitive_verb, fin, sg, [features], feature).
lex(transitive_verb, fin, pl, [feature], feature).
lex(transitive_verb, inf,  _, [feature], feature).

lex(transitive_verb, fin, sg, [has], have).
lex(transitive_verb, fin, pl, [have], have).
lex(transitive_verb, inf,  _, [have], have).

lex(transitive_verb, fin, sg, [holds], hold).
lex(transitive_verb, fin, pl, [hold], hold).
lex(transitive_verb, inf,  _, [hold], hold).

lex(transitive_verb, fin, sg, [owns], own).
lex(transitive_verb, fin, pl, [own], own).
lex(transitive_verb, inf,  _, [own], own).

lex(transitive_verb, fin, sg, [serves], serve).
lex(transitive_verb, fin, pl, [serve], serve).
lex(transitive_verb, inf,  _, [serve], serve).

lex(transitive_verb, fin, sg, [sits, in], sit_in).
lex(transitive_verb, fin, pl, [sit, in], sit_in).
lex(transitive_verb, inf,  _, [sit, in], sit_in).

lex(transitive_verb, fin, sg, [shelters], shelter).
lex(transitive_verb, fin, pl, [shelter], shelter).
lex(transitive_verb, inf,  _, [shelter], shelter).

lex(transitive_verb, fin, sg, [studies, at], study_at).
lex(transitive_verb, fin, pl, [study, at], study_at).
lex(transitive_verb, inf,  _, [study, at], study_at).

lex(transitive_verb, fin, sg, [supervises], supervise).
lex(transitive_verb, fin, pl, [supervise], supervise).
lex(transitive_verb, inf,  _, [supervise], supervise).

lex(transitive_verb, fin, sg, [teaches], teach).
lex(transitive_verb, fin, pl, [teach], teach).
lex(transitive_verb, inf,  _, [teach], teach).

lex(transitive_verb, fin, sg, [uses], use).
lex(transitive_verb, fin, pl, [use], use).
lex(transitive_verb, inf,  _, [use], use).


% ------------------------------------------------------------------------


lexicon([cat:intransitive_verb, wfm:WF, arg:[num:Num, ind:I], vform:VForm, evtl:E, con:pred(E, I, Sym)]) :-
   lex(intransitive_verb, VForm, Num, WF, Sym).

lex(intransitive_verb, fin, sg, [drinks], drink).
lex(intransitive_verb, fin, pl, [drink], drink).
lex(intransitive_verb, inf,  _, [drink], drink).

lex(intransitive_verb, fin, sg, [exercises], exercise).
lex(intransitive_verb, fin, pl, [exercise], exercise).
lex(intransitive_verb, inf,  _, [exercise], exercise).

lex(intransitive_verb, fin, sg, [exists], exist).
lex(intransitive_verb, fin, pl, [exist], exist).
lex(intransitive_verb, inf,  _, [exist], exist).

lex(intransitive_verb, fin, sg, [falls, asleep], fall_asleep).
lex(intransitive_verb, fin, pl, [fall, asleep], fall_asleep).
lex(intransitive_verb, inf,  _, [fall, asleep], fall_asleep).

lex(intransitive_verb, fin, sg, [holds], hold).
lex(intransitive_verb, fin, pl, [hold], hold).
lex(intransitive_verb, inf,  _, [hold], hold).

lex(intransitive_verb, fin, sg, [learns], learn).
lex(intransitive_verb, fin, pl, [learn], learn).
lex(intransitive_verb, inf,  _, [learn], learn).

lex(intransitive_verb, fin, sg, [lies], lie).
lex(intransitive_verb, fin, pl, [lie], lie).
lex(intransitive_verb, inf,  _, [lie], lie).

lex(intransitive_verb, fin, sg, [parties], party).
lex(intransitive_verb, fin, pl, [party], party).
lex(intransitive_verb, inf,  _, [party], party).

% lex(intransitive_verb, fin, sg, [sits], sit).
% lex(intransitive_verb, fin, pl, [sit], sit).
% lex(intransitive_verb, inf,  _, [sit], sit).

lex(intransitive_verb, fin, sg, [sleeps], sleep).
lex(intransitive_verb, fin, pl, [sleep], sleep).
lex(intransitive_verb, inf,  _, [sleep], sleep).

lex(intransitive_verb, fin, sg, [wakes, up], wake_up).
lex(intransitive_verb, fin, pl, [wake, up], wake_up).
lex(intransitive_verb, inf,  _, [wake, up], wake_up).

lex(intransitive_verb, fin, sg, [works], work).
lex(intransitive_verb, fin, pl, [work], work).
lex(intransitive_verb, inf,  _, [work], work).


% ------------------------------------------------------------------------

lexicon([cat:copula, wfm:[is], arg:[num:sg, ind:I1], arg:[num:sg, ind:I2, type:rel], vform:V, evtl:S, con:pred(S, I1, I2, be)]).

lexicon([cat:copula, wfm:[is], arg:[num:sg, ind:I1], arg:[num:sg, ind:I2], vform:V, evtl:S, con:pred(S, I1, I2, isa)]).

lexicon([cat:copula, wfm:[is], arg:[num:sg, ind:I], vform:V, evtl:S, con:pred(S, I, be)]).

lexicon([cat:copula, wfm:[will, be], arg:[num:sg, ind:I], vform:V, evtl:S, con:pred(S, I, will_be)]).

lexicon([cat:copula, wfm:['Is'], arg:[num:sg, ind:I], vform:V, evtl:S, con:pred(S, I, be)]).

lexicon([cat:copula, wfm:[are], arg:[num:pl, ind:I1], arg:[num:pl, ind:I2], vform:V, evtl:S, con:pred(S, I1, I2, isa)]).

lexicon([cat:copula, wfm:[are], arg:[num:pl, ind:I], vform:V, evtl:S, con:pred(S, I, be)]).

lexicon([cat:copula, wfm:['Are'], arg:[num:pl, ind:I], vform:V, evtl:S, con:pred(S, I, be)]).


% ------------------------------------------------------------------------

lexicon([cat:relative_pronoun, wfm:WF]) :-
  lex(relative_pronoun, WF).

lex(relative_pronoun, [who]).
lex(relative_pronoun, [which]).
lex(relative_pronoun, [that]).


% ------------------------------------------------------------------------

lexicon([cat:coordination, wfm:WF]) :-
  lex(coordination, WF).

lex(coordination, [and]).
lex(coordination, [or]).


% ------------------------------------------------------------------------

lexicon([cat:operator, wfm:WF, arg:[num:sg, ind:I1], arg:[num:_, ind:I2], con:operator(I1, Sym, I2)]) :-
  lex(operator, WF, Sym).

lex(operator, [minus], -).
lex(operator, [plus], +).


% ------------------------------------------------------------------------

lexicon([cat:preposition, wfm:WF, evtl:E, arg:[num:_, ind:I], con:prop(E, I, Sym)]) :-
  lex(preposition, WF, Sym).

lex(preposition, [at], at).
lex(preposition, [in], location).
lex(preposition, [before], before).
lex(preposition, [from], origin).



lexicon([cat:preposition, wfm:[of], arg:[num:N1, ind:I1], arg:[num:N2, ind:I2], con:relation(of, I1, I2)]).

lexicon([cat:preposition, wfm:[as], arg:[num:N1, ind:I1], arg:[num:N2, ind:I2], con:relation(as, I1, I2)]).


lexicon([cat:preposition, wfm:WF]) :-
  lex(preposition, WF).

lex(preposition, ['If']).


% ------------------------------------------------------------------------

lexicon([cat:adverb, wfm:WF]) :-
  lex(adverb, WF).

lex(adverb, [then]).


lexicon([cat:adverb, wfm:WF, evtl:E, con:modifier(E, Sym)]) :-
  lex(adverb, WF, Sym).
	
lex(adverb, [normally], normally).

lex(adverb, [abnormally], abnormally).

lex(adverb, [provably], provably).

% ------------------------------------------------------------------------

lexicon([cat:relational_adjective, wfm:WF, evtl:S, arg:[num:_, ind:I], con:prop(S, I, Sym)]) :-
  lex(relational_adjective, WF, Sym).
	
lex(relational_adjective, [allocated, to], allocated_to).

lex(relational_adjective, [located, in], located_in).

lex(relational_adjective, [afraid, of], afraid_of).

lex(relational_adjective, [enrolled, in], enrolled_in).

lex(relational_adjective, [matriculated, in], matriculated_in).

lex(relational_adjective, [right, of], right_of).

lex(relational_adjective, [left, of], left_of).

lex(relational_adjective, [next, to], next_to).


lexicon([cat:relational_adjective, wfm:WF, evtl:S, arg:[num:_, ind:I], con:operator(S, Sym, I)]) :-
  lex(relational_adjective, WF, operator, Sym).

lex(relational_adjective, [the, same, as], operator,  =).
% lex(relational_adjective, [not, the, same, as], operator, \=).

% ------------------------------------------------------------------------

lexicon([cat:comparative, wfm:WF, evtl:E, arg:[num:_, ind:I], con:operator(E, Sym, I)]) :-
  lex(comparative, WF, Sym).

lex(comparative, [smaller, than, or, equal, to], <=).
lex(comparative, [greater, than, or, equal, to], >=).
lex(comparative, [equal, to], =).
lex(comparative, [not, equal, to], \=).
lex(comparative, [the, same, as], =).
lex(comparative, [not, the, same, as], \=).
lex(comparative, [smaller, than],  <).
lex(comparative, [greater, than],  >).


% ------------------------------------------------------------------------

lexicon([cat:string_variable, wfm:WF, arg:[num:sg, ind:I], con:[variable(I, Sym)]]) :-
   lex(string_variable, WF, Sym).

lex(string_variable, ['X'], x).
lex(string_variable, ['X1'], x1).
lex(string_variable, ['X2'], x2).
lex(string_variable, ['X3'], x3).
lex(string_variable, ['X4'], x4).
lex(string_variable, ['X5'], x5).
lex(string_variable, ['X6'], x6).
lex(string_variable, ['X7'], x7).
lex(string_variable, ['X8'], x8).
lex(string_variable, ['X9'], x9).



lexicon([cat:numeric_variable, wfm:WF, arg:[num:sg, ind:I], arg:[num:sg, ind:N], con:[variable(N, Sym), ordinal(I, N)]]) :-
   lex(numeric_variable, WF, Sym).

lex(numeric_variable, ['N'], n).
lex(numeric_variable, ['N1'], n1).
lex(numeric_variable, ['N2'], n2).
lex(numeric_variable, ['N3'], n3).
lex(numeric_variable, ['N4'], n4).
lex(numeric_variable, ['N5'], n5).
lex(numeric_variable, ['N6'], n6).
lex(numeric_variable, ['N7'], n7).
lex(numeric_variable, ['N8'], n8).
lex(numeric_variable, ['N9'], n9).


% ------------------------------------------------------------------------

lexicon([cat:negation, wfm:WF]) :-
   lex(neg, WF).

lex(neg, [does, not]).
lex(neg, [do, not]).
lex(neg, [not]).


% ------------------------------------------------------------------------

collect_categories(json([cat=adjective, wfm=WFS])) :-
    findall(json([wfm=WF]), lexicon([cat:adjective, wfm:WF|Rest]), WFS),
    sort(WFS, SWFS).


collect_categories(json([cat=copula, num=sg, wfm=[is]])).	  

collect_categories(json([cat=copula, num=pl, wfm=[are]])).


collect_categories(json([cat=name, num=sg, wfm=SWFS])) :-
    findall(WF, lexicon([cat:name, wfm:WF, arg:[num:sg, ind:I]|Rest]), WFS),
    sort(WFS, SWFS).
		  

collect_categories(json([cat=noun, num=sg, wfm=SWFS])) :-
    findall(WF, lexicon([cat:noun, wfm:WF, arg:[num:sg, ind:I]|Rest]), WFS),
    sort(WFS, SWFS).
    
collect_categories(json([cat=noun, num=pl, wfm=SWFS])) :-
    findall(json([wfm=WF]), lexicon([cat:noun, wfm:WF, arg:[num:pl, ind:I]|Rest]), WFS),
    sort(WFS, SWFS).


collect_categories(json([cat=intransitive_verb, num=sg, wfm=WFS])) :-
    findall(json([wfm=WF]), lexicon([cat:intransitive_verb, wfm:WF, evtl:E, arg:[num:sg, ind:I]|Rest]), WFS),
    sort(WFS, SWFS).


collect_categories(json([cat=transitive_verb, num=sg, wfm=WFS])) :-
    findall(json([wfm=WF]), lexicon([cat:transitive_verb, wfm:WF, evtl:E, arg:[num:sg, ind:I]|Rest]), WFS),
    sort(WFS, SWFS).

/***

% ------------------------------------------------------------------------
% Frequency list: nouns singular
% ------------------------------------------------------------------------

lex(noun, sg, [ability], ability).
lex(noun, sg, [access], access).
lex(noun, sg, [accident], accident).
lex(noun, sg, [account], account).
lex(noun, sg, [act], act).
lex(noun, sg, [action], action).
lex(noun, sg, [activity], activity).
lex(noun, sg, [advantage], advantage).
lex(noun, sg, [advice], advice).
lex(noun, sg, [afternoon], afternoon).
lex(noun, sg, [age], age).
lex(noun, sg, [agreement], agreement).
lex(noun, sg, [aid], aid).
lex(noun, sg, [air], air).
lex(noun, sg, [amount], amount).
lex(noun, sg, [analysis], analysis).
lex(noun, sg, [animal], animal).
lex(noun, sg, [answer], answer).
lex(noun, sg, [appeal], appeal).
lex(noun, sg, [application], application).
lex(noun, sg, [approach], approach).
lex(noun, sg, [area], area).
lex(noun, sg, [argument], argument).
lex(noun, sg, [arm], arm).
lex(noun, sg, [art], art).
lex(noun, sg, [article], article).
lex(noun, sg, [assessment], assessment).
lex(noun, sg, [attack], attack).
lex(noun, sg, [attempt], attempt).
lex(noun, sg, [attention], attention).
lex(noun, sg, [attitude], attitude).
lex(noun, sg, [authority], authority).
lex(noun, sg, [award], award).
lex(noun, sg, [baby], baby).
lex(noun, sg, [back], back).
lex(noun, sg, [background], background).
lex(noun, sg, [balance], balance).
lex(noun, sg, [ball], ball).
lex(noun, sg, [band], band).
lex(noun, sg, [bank], bank).
lex(noun, sg, [bar], bar).
lex(noun, sg, [base], base).
lex(noun, sg, [basis], basis).
lex(noun, sg, [battle], battle).
lex(noun, sg, [bed], bed).
lex(noun, sg, [beginning], beginning).
lex(noun, sg, [behaviour], behaviour).
lex(noun, sg, [benefit], benefit).
lex(noun, sg, [bit], bit).
lex(noun, sg, [blood], blood).
lex(noun, sg, [board], board).
lex(noun, sg, [body], body).
lex(noun, sg, [book], book).
lex(noun, sg, [box], box).
lex(noun, sg, [boy], boy).
lex(noun, sg, [brother], brother).
lex(noun, sg, [budget], budget).
lex(noun, sg, [building], building).
lex(noun, sg, [business], business).
lex(noun, sg, [campaign], campaign).
lex(noun, sg, [capacity], capacity).
lex(noun, sg, [capital], capital).
lex(noun, sg, [car], car).
lex(noun, sg, [care], care).
lex(noun, sg, [career], career).
lex(noun, sg, [case], case).
lex(noun, sg, [cash], cash).
lex(noun, sg, [cause], cause).
lex(noun, sg, [centre], centre).
lex(noun, sg, [century], century).
lex(noun, sg, [chair], chair).
lex(noun, sg, [chairman], chairman).
lex(noun, sg, [chance], chance).
lex(noun, sg, [change], change).
lex(noun, sg, [chapter], chapter).
lex(noun, sg, [character], character).
lex(noun, sg, [charge], charge).
lex(noun, sg, [child], child).
lex(noun, sg, [choice], choice).
lex(noun, sg, [church], church).
lex(noun, sg, [city], city).
lex(noun, sg, [claim], claim).
lex(noun, sg, [class], class).
lex(noun, sg, [client], client).
lex(noun, sg, [coffee], coffee).
lex(noun, sg, [collection], collection).
lex(noun, sg, [colour], colour).
lex(noun, sg, [communication], communication).
lex(noun, sg, [company], company).
lex(noun, sg, [competition], competition).
lex(noun, sg, [computer], computer).
lex(noun, sg, [concept], concept).
lex(noun, sg, [concern], concern).
lex(noun, sg, [condition], condition).
lex(noun, sg, [conference], conference).
lex(noun, sg, [confidence], confidence).
lex(noun, sg, [construction], construction).
lex(noun, sg, [context], context).
lex(noun, sg, [contract], contract).
lex(noun, sg, [contrast], contrast).
lex(noun, sg, [control], control).
lex(noun, sg, [corner], corner).
lex(noun, sg, [cost], cost).
lex(noun, sg, [country], country).
lex(noun, sg, [county], county).
lex(noun, sg, [couple], couple).
lex(noun, sg, [course], course).
lex(noun, sg, [court], court).
lex(noun, sg, [credit], credit).
lex(noun, sg, [crime], crime).
lex(noun, sg, [culture], culture).
lex(noun, sg, [cup], cup).
lex(noun, sg, [danger], danger).
lex(noun, sg, [date], date).
lex(noun, sg, [daughter], daughter).
lex(noun, sg, [day], day).
lex(noun, sg, [deal], deal).
lex(noun, sg, [death], death).
lex(noun, sg, [debate], debate).
lex(noun, sg, [decision], decision).
lex(noun, sg, [defence], defence).
lex(noun, sg, [degree], degree).
lex(noun, sg, [demand], demand).
lex(noun, sg, [design], design).
lex(noun, sg, [development], development).
lex(noun, sg, [difference], difference).
lex(noun, sg, [difficulty], difficulty).
lex(noun, sg, [dinner], dinner).
lex(noun, sg, [direction], direction).
lex(noun, sg, [director], director).
lex(noun, sg, [discussion], discussion).
lex(noun, sg, [disease], disease).
lex(noun, sg, [distance], distance).
lex(noun, sg, [distribution], distribution).
lex(noun, sg, [doctor], doctor).
lex(noun, sg, [dog], dog).
lex(noun, sg, [door], door).
lex(noun, sg, [duty], duty).
lex(noun, sg, [earth], earth).
lex(noun, sg, [economy], economy).
lex(noun, sg, [edge], edge).
lex(noun, sg, [education], education).
lex(noun, sg, [effect], effect).
lex(noun, sg, [effort], effort).
lex(noun, sg, [election], election).
lex(noun, sg, [employment], employment).
lex(noun, sg, [end], end).
lex(noun, sg, [energy], energy).
lex(noun, sg, [environment], environment).
lex(noun, sg, [equipment], equipment).
lex(noun, sg, [evening], evening).
lex(noun, sg, [event], event).
lex(noun, sg, [evidence], evidence).
lex(noun, sg, [example], example).
lex(noun, sg, [exchange], exchange).
lex(noun, sg, [existence], existence).
lex(noun, sg, [experience], experience).
lex(noun, sg, [expression], expression).
lex(noun, sg, [extent], extent).
lex(noun, sg, [eye], eye).
lex(noun, sg, [face], face).
lex(noun, sg, [fact], fact).
lex(noun, sg, [factor], factor).
lex(noun, sg, [failure], failure).
lex(noun, sg, [father], father).
lex(noun, sg, [feeling], feeling).
lex(noun, sg, [field], field).
lex(noun, sg, [fig], fig).
lex(noun, sg, [figure], figure).
lex(noun, sg, [film], film).
lex(noun, sg, [fire], fire).
lex(noun, sg, [firm], firm).
lex(noun, sg, [floor], floor).
lex(noun, sg, [food], food).
lex(noun, sg, [foot], foot).
lex(noun, sg, [force], force).
lex(noun, sg, [form], form).
lex(noun, sg, [freedom], freedom).
lex(noun, sg, [friend], friend).
lex(noun, sg, [function], function).
lex(noun, sg, [fund], fund).
lex(noun, sg, [future], future).
lex(noun, sg, [game], game).
lex(noun, sg, [garden], garden).
lex(noun, sg, [gas], gas).
lex(noun, sg, [girl], girl).
lex(noun, sg, [glass], glass).
lex(noun, sg, [goal], goal).
lex(noun, sg, [ground], ground).
lex(noun, sg, [growth], growth).
lex(noun, sg, [hair], hair).
lex(noun, sg, [hand], hand).
lex(noun, sg, [head], head).
lex(noun, sg, [health], health).
lex(noun, sg, [heart], heart).
lex(noun, sg, [help], help).
lex(noun, sg, [history], history).
lex(noun, sg, [holiday], holiday).
lex(noun, sg, [home], home).
lex(noun, sg, [horse], horse).
lex(noun, sg, [hospital], hospital).
lex(noun, sg, [hotel], hotel).
lex(noun, sg, [hour], hour).
lex(noun, sg, [house], house).
lex(noun, sg, [husband], husband).
lex(noun, sg, [idea], idea).
lex(noun, sg, [image], image).
lex(noun, sg, [impact], impact).
lex(noun, sg, [importance], importance).
lex(noun, sg, [income], income).
lex(noun, sg, [increase], increase).
lex(noun, sg, [industry], industry).
lex(noun, sg, [influence], influence).
lex(noun, sg, [information], information).
lex(noun, sg, [insurance], insurance).
lex(noun, sg, [interest], interest).
lex(noun, sg, [introduction], introduction).
lex(noun, sg, [investment], investment).
lex(noun, sg, [issue], issue).
lex(noun, sg, [job], job).
lex(noun, sg, [kind], kind).
lex(noun, sg, [king], king).
lex(noun, sg, [kitchen], kitchen).
lex(noun, sg, [knowledge], knowledge).
lex(noun, sg, [labour], labour).
lex(noun, sg, [lack], lack).
lex(noun, sg, [lady], lady).
lex(noun, sg, [land], land).
lex(noun, sg, [language], language).
lex(noun, sg, [law], law).
lex(noun, sg, [leader], leader).
lex(noun, sg, [league], league).
lex(noun, sg, [legislation], legislation).
lex(noun, sg, [length], length).
lex(noun, sg, [letter], letter).
lex(noun, sg, [level], level).
lex(noun, sg, [library], library).
lex(noun, sg, [life], life).
lex(noun, sg, [light], light).
lex(noun, sg, [line], line).
lex(noun, sg, [list], list).
lex(noun, sg, [look], look).
lex(noun, sg, [loss], loss).
lex(noun, sg, [love], love).
lex(noun, sg, [machine], machine).
lex(noun, sg, [man], man).
lex(noun, sg, [manager], manager).
lex(noun, sg, [manner], manner).
lex(noun, sg, [market], market).
lex(noun, sg, [marriage], marriage).
lex(noun, sg, [match], match).
lex(noun, sg, [material], material).
lex(noun, sg, [matter], matter).
lex(noun, sg, [meaning], meaning).
lex(noun, sg, [meeting], meeting).
lex(noun, sg, [member], member).
lex(noun, sg, [memory], memory).
lex(noun, sg, [message], message).
lex(noun, sg, [method], method).
lex(noun, sg, [mind], mind).
lex(noun, sg, [minister], minister).
lex(noun, sg, [model], model).
lex(noun, sg, [moment], moment).
lex(noun, sg, [money], money).
lex(noun, sg, [month], month).
lex(noun, sg, [morning], morning).
lex(noun, sg, [mother], mother).
lex(noun, sg, [mouth], mouth).
lex(noun, sg, [move], move).
lex(noun, sg, [movement], movement).
lex(noun, sg, [mum], mum).
lex(noun, sg, [music], music).
lex(noun, sg, [name], name).
lex(noun, sg, [nature], nature).
lex(noun, sg, [need], need).
lex(noun, sg, [network], network).
lex(noun, sg, [news], news).
lex(noun, sg, [night], night).
lex(noun, sg, [north], north).
lex(noun, sg, [number], number).
lex(noun, sg, [office], office).
lex(noun, sg, [officer], officer).
lex(noun, sg, [oil], oil).
lex(noun, sg, [operation], operation).
lex(noun, sg, [opinion], opinion).
lex(noun, sg, [opportunity], opportunity).
lex(noun, sg, [opposition], opposition).
lex(noun, sg, [order], order).
lex(noun, sg, [organisation], organisation).
lex(noun, sg, [page], page).
lex(noun, sg, [pain], pain).
lex(noun, sg, [paper], paper).
lex(noun, sg, [parliament], parliament).
lex(noun, sg, [part], part).
lex(noun, sg, [past], past).
lex(noun, sg, [path], path).
lex(noun, sg, [pattern], pattern).
lex(noun, sg, [peace], peace).
lex(noun, sg, [performance], performance).
lex(noun, sg, [period], period).
lex(noun, sg, [person], person).
lex(noun, sg, [phone], phone).
lex(noun, sg, [picture], picture).
lex(noun, sg, [piece], piece).
lex(noun, sg, [pizza], pizza).
lex(noun, sg, [place], place).
lex(noun, sg, [plan], plan).
lex(noun, sg, [plant], plant).
lex(noun, sg, [play], play).
lex(noun, sg, [point], point).
lex(noun, sg, [policy], policy).
lex(noun, sg, [population], population).
lex(noun, sg, [position], position).
lex(noun, sg, [possibility], possibility).
lex(noun, sg, [post], post).
lex(noun, sg, [pound], pound).
lex(noun, sg, [power], power).
lex(noun, sg, [practice], practice).
lex(noun, sg, [presence], presence).
lex(noun, sg, [president], president).
lex(noun, sg, [pressure], pressure).
lex(noun, sg, [price], price).
lex(noun, sg, [principle], principle).
lex(noun, sg, [prison], prison).
lex(noun, sg, [problem], problem).
lex(noun, sg, [process], process).
lex(noun, sg, [product], product).
lex(noun, sg, [production], production).
lex(noun, sg, [programme], programme).
lex(noun, sg, [progress], progress).
lex(noun, sg, [project], project).
lex(noun, sg, [property], property).
lex(noun, sg, [proportion], proportion).
lex(noun, sg, [protection], protection).
lex(noun, sg, [provision], provision).
lex(noun, sg, [purpose], purpose).
lex(noun, sg, [quality], quality).
lex(noun, sg, [quarter], quarter).
lex(noun, sg, [question], question).
lex(noun, sg, [race], race).
lex(noun, sg, [radio], radio).
lex(noun, sg, [railway], railway).
lex(noun, sg, [range], range).
lex(noun, sg, [rate], rate).
lex(noun, sg, [reality], reality).
lex(noun, sg, [reason], reason).
lex(noun, sg, [record], record).
lex(noun, sg, [reference], reference).
lex(noun, sg, [region], region).
lex(noun, sg, [relationship], relationship).
lex(noun, sg, [relief], relief).
lex(noun, sg, [report], report).
lex(noun, sg, [research], research).
lex(noun, sg, [response], response).
lex(noun, sg, [responsibility], responsibility).
lex(noun, sg, [rest], rest).
lex(noun, sg, [result], result).
lex(noun, sg, [return], return).
lex(noun, sg, [review], review).
lex(noun, sg, [right], right).
lex(noun, sg, [risk], risk).
lex(noun, sg, [river], river).
lex(noun, sg, [road], road).
lex(noun, sg, [role], role).
lex(noun, sg, [room], room).
lex(noun, sg, [rule], rule).
lex(noun, sg, [safety], safety).
lex(noun, sg, [sale], sale).
lex(noun, sg, [scale], scale).
lex(noun, sg, [scene], scene).
lex(noun, sg, [scheme], scheme).
lex(noun, sg, [school], school).
lex(noun, sg, [science], science).
lex(noun, sg, [sea], sea).
lex(noun, sg, [season], season).
lex(noun, sg, [seat], seat).
lex(noun, sg, [secretary], secretary).
lex(noun, sg, [section], section).
lex(noun, sg, [sector], sector).
lex(noun, sg, [security], security).
lex(noun, sg, [selection], selection).
lex(noun, sg, [sense], sense).
lex(noun, sg, [service], service).
lex(noun, sg, [set], set).
lex(noun, sg, [sex], sex).
lex(noun, sg, [share], share).
lex(noun, sg, [shop], shop).
lex(noun, sg, [show], show).
lex(noun, sg, [side], side).
lex(noun, sg, [sight], sight).
lex(noun, sg, [sign], sign).
lex(noun, sg, [sir], sir).
lex(noun, sg, [sister], sister).
lex(noun, sg, [site], site).
lex(noun, sg, [situation], situation).
lex(noun, sg, [size], size).
lex(noun, sg, [skin], skin).
lex(noun, sg, [smile], smile).
lex(noun, sg, [software], software).
lex(noun, sg, [solution], solution).
lex(noun, sg, [son], son).
lex(noun, sg, [sort], sort).
lex(noun, sg, [sound], sound).
lex(noun, sg, [source], source).
lex(noun, sg, [south], south).
lex(noun, sg, [space], space).
lex(noun, sg, [speaker], speaker).
lex(noun, sg, [speech], speech).
lex(noun, sg, [speed], speed).
lex(noun, sg, [spirit], spirit).
lex(noun, sg, [stage], stage).
lex(noun, sg, [start], start).
lex(noun, sg, [state], state).
lex(noun, sg, [statement], statement).
lex(noun, sg, [station], station).
lex(noun, sg, [status], status).
lex(noun, sg, [step], step).
lex(noun, sg, [stock], stock).
lex(noun, sg, [stone], stone).
lex(noun, sg, [story], story).
lex(noun, sg, [strategy], strategy).
lex(noun, sg, [street], street).
lex(noun, sg, [strength], strength).
lex(noun, sg, [structure], structure).
lex(noun, sg, [student], student).
lex(noun, sg, [studio], studio).
lex(noun, sg, [study], study).
lex(noun, sg, [stuff], stuff).
lex(noun, sg, [style], style).
lex(noun, sg, [subject], subject).
lex(noun, sg, [success], success).
lex(noun, sg, [summer], summer).
lex(noun, sg, [sun], sun).
lex(noun, sg, [support], support).
lex(noun, sg, [surface], surface).
lex(noun, sg, [survey], survey).
lex(noun, sg, [system], system).
lex(noun, sg, [table], table).
lex(noun, sg, [task], task).
lex(noun, sg, [tax], tax).
lex(noun, sg, [tea], tea).
lex(noun, sg, [teacher], teacher).
lex(noun, sg, [technology], technology).
lex(noun, sg, [telephone], telephone).
lex(noun, sg, [television], television).
lex(noun, sg, [term], term).
lex(noun, sg, [test], test).
lex(noun, sg, [text], text).
lex(noun, sg, [theory], theory).
lex(noun, sg, [thing], thing).
lex(noun, sg, [thought], thought).
lex(noun, sg, [time], time).
lex(noun, sg, [title], title).
lex(noun, sg, [top], top).
lex(noun, sg, [town], town).
lex(noun, sg, [trade], trade).
lex(noun, sg, [traffic], traffic).
lex(noun, sg, [train], train).
lex(noun, sg, [training], training).
lex(noun, sg, [transport], transport).
lex(noun, sg, [treatment], treatment).
lex(noun, sg, [tree], tree).
lex(noun, sg, [trial], trial).
lex(noun, sg, [trouble], trouble).
lex(noun, sg, [truth], truth).
lex(noun, sg, [turn], turn).
lex(noun, sg, [tv], tv).
lex(noun, sg, [type], type).
lex(noun, sg, [unemployment], unemployment).
lex(noun, sg, [unit], unit).
lex(noun, sg, [university], university).
lex(noun, sg, [use], use).
lex(noun, sg, [user], user).
lex(noun, sg, [value], value).
lex(noun, sg, [variety], variety).
lex(noun, sg, [version], version).
lex(noun, sg, [video], video).
lex(noun, sg, [view], view).
lex(noun, sg, [village], village).
lex(noun, sg, [visit], visit).
lex(noun, sg, [voice], voice).
lex(noun, sg, [wall], wall).
lex(noun, sg, [war], war).
lex(noun, sg, [water], water).
lex(noun, sg, [way], way).
lex(noun, sg, [week], week).
lex(noun, sg, [weekend], weekend).
lex(noun, sg, [weight], weight).
lex(noun, sg, [while], while).
lex(noun, sg, [whole], whole).
lex(noun, sg, [wife], wife).
lex(noun, sg, [will], will).
lex(noun, sg, [wind], wind).
lex(noun, sg, [window], window).
lex(noun, sg, [wine], wine).
lex(noun, sg, [winter], winter).
lex(noun, sg, [woman], woman).
lex(noun, sg, [word], word).
lex(noun, sg, [work], work).
lex(noun, sg, [world], world).
lex(noun, sg, [year], year).
lex(noun, sg, [adjustment], adjustment).
lex(noun, sg, [agent], agent).
lex(noun, sg, [aircraft], aircraft).
lex(noun, sg, [airflow], airflow).
lex(noun, sg, [approval], approval).
lex(noun, sg, [arrow], arrow).
lex(noun, sg, [assembly], assembly).
lex(noun, sg, [blockage], blockage).
lex(noun, sg, [bond], bond).
lex(noun, sg, [bottom], bottom).
lex(noun, sg, [bubble], bubble).
lex(noun, sg, [bypass], bypass).
lex(noun, sg, [calibration], calibration).
lex(noun, sg, [can], can).
lex(noun, sg, [chemical], chemical).
lex(noun, sg, [clearance], clearance).
lex(noun, sg, [click], click).
lex(noun, sg, [code], code).
lex(noun, sg, [coil], coil).
lex(noun, sg, [component], component).
lex(noun, sg, [compound], compound).
lex(noun, sg, [connection], connection).
lex(noun, sg, [container], container).
lex(noun, sg, [contamination], contamination).
lex(noun, sg, [contour], contour).
lex(noun, sg, [copy], copy).
lex(noun, sg, [correction], correction).
lex(noun, sg, [corrosion], corrosion).
lex(noun, sg, [curve], curve).
lex(noun, sg, [cycle], cycle).
lex(noun, sg, [data], data).
lex(noun, sg, [deformation], deformation).
lex(noun, sg, [depth], depth).
lex(noun, sg, [device], device).
lex(noun, sg, [dimension], dimension).
lex(noun, sg, [emergency], emergency).
lex(noun, sg, [entry], entry).
lex(noun, sg, [entrance], entrance).
lex(noun, sg, [error], error).
lex(noun, sg, [estimate], estimate).
lex(noun, sg, [exhaust], exhaust).
lex(noun, sg, [exit], exit).
lex(noun, sg, [explosion], explosion).
lex(noun, sg, [explosive], explosive).
lex(noun, sg, [extension], extension).
lex(noun, sg, [feather], feather).
lex(noun, sg, [ferry], ferry).
lex(noun, sg, [flame], flame).
lex(noun, sg, [flange], flange).
lex(noun, sg, [flash], flash).
lex(noun, sg, [flight], flight).
lex(noun, sg, [fluid], fluid).
lex(noun, sg, [flush], flush).
lex(noun, sg, [fume], fume).
lex(noun, sg, [groove], groove).
lex(noun, sg, [heat], heat).
lex(noun, sg, [height], height).
lex(noun, sg, [hole], hole).
lex(noun, sg, [ignition], ignition).
lex(noun, sg, [incident], incident).
lex(noun, sg, [increment], increment).
lex(noun, sg, [indication], indication).
lex(noun, sg, [injury], injury).
lex(noun, sg, [input], input).
lex(noun, sg, [inspection], inspection).
lex(noun, sg, [installation], installation).
lex(noun, sg, [instruction], instruction).
lex(noun, sg, [instrument], instrument).
lex(noun, sg, [insulation], insulation).
lex(noun, sg, [intensity], intensity).
lex(noun, sg, [interchange], interchange).
lex(noun, sg, [interface], interface).
lex(noun, sg, [interference], interference).
lex(noun, sg, [interval], interval).
lex(noun, sg, [item], item).
lex(noun, sg, [lamination], lamination).
lex(noun, sg, [latch], latch).
lex(noun, sg, [layer], layer).
lex(noun, sg, [leak], leak).
lex(noun, sg, [leakage], leakage).
lex(noun, sg, [lighting], lighting).
lex(noun, sg, [liquid], liquid).
lex(noun, sg, [location], location).
lex(noun, sg, [lock], lock).
lex(noun, sg, [loop], loop).
lex(noun, sg, [maintenance], maintenance).
lex(noun, sg, [malfunction], malfunction).
lex(noun, sg, [manual], manual).
lex(noun, sg, [mass], mass).
lex(noun, sg, [mechanism], mechanism).
lex(noun, sg, [mixture], mixture).
lex(noun, sg, [mode], mode).
lex(noun, sg, [noise], noise).
lex(noun, sg, [nose], nose).
lex(noun, sg, [notch], notch).
lex(noun, sg, [object], object).
lex(noun, sg, [opening], opening).
lex(noun, sg, [output], output).
lex(noun, sg, [paint], paint).
lex(noun, sg, [pair], pair).
lex(noun, sg, [particle], particle).
lex(noun, sg, [paste], paste).
lex(noun, sg, [patch], patch).
lex(noun, sg, [precaution], precaution).
lex(noun, sg, [precision], precision).
lex(noun, sg, [procedure], procedure).
lex(noun, sg, [quantity], quantity).
lex(noun, sg, [rear], rear).
lex(noun, sg, [recess], recess).
lex(noun, sg, [reflection], reflection).
lex(noun, sg, [relation], relation).
lex(noun, sg, [removal], removal).
lex(noun, sg, [replacement], replacement).
lex(noun, sg, [retraction], retraction).
lex(noun, sg, [routing], routing).
lex(noun, sg, [row], row).
lex(noun, sg, [sample], sample).
lex(noun, sg, [schedule], schedule).
lex(noun, sg, [seal], seal).
lex(noun, sg, [separation], separation).
lex(noun, sg, [sequence], sequence).
lex(noun, sg, [serration], serration).
lex(noun, sg, [servicing], servicing).
lex(noun, sg, [shape], shape).
lex(noun, sg, [sheet], sheet).
lex(noun, sg, [shock], shock).
lex(noun, sg, [slope], slope).
lex(noun, sg, [slot], slot).
lex(noun, sg, [smoke], smoke).
lex(noun, sg, [spark], spark).
lex(noun, sg, [spray], spray).
lex(noun, sg, [strain], strain).
lex(noun, sg, [stripe], stripe).
lex(noun, sg, [sum], sum).
lex(noun, sg, [symbol], symbol).
lex(noun, sg, [symptom], symptom).
lex(noun, sg, [tag], tag).
lex(noun, sg, [tap], tap).
lex(noun, sg, [taxi], taxi).
lex(noun, sg, [thickness], thickness).
lex(noun, sg, [tension], tension).
lex(noun, sg, [tolerance], tolerance).
lex(noun, sg, [tool], tool).
lex(noun, sg, [torque], torque).
lex(noun, sg, [tune], tune).
lex(noun, sg, [volume], volume).
lex(noun, sg, [weather], weather).
lex(noun, sg, [width], width).


% ------------------------------------------------------------------------
% Frequency list: nouns plural
% ------------------------------------------------------------------------

lex(noun, pl, [accounts], account).
lex(noun, pl, [actions], action).
lex(noun, pl, [activities], activity).
lex(noun, pl, [acts], act).
lex(noun, pl, [adults], adult).
lex(noun, pl, [advantages], advantage).
lex(noun, pl, [affairs], affair).
lex(noun, pl, [agencies], agency).
lex(noun, pl, [agents], agent).
lex(noun, pl, [ages], age).
lex(noun, pl, [agreements], agreement).
lex(noun, pl, [aims], aim).
lex(noun, pl, [americans], american).
lex(noun, pl, [amounts], amount).
lex(noun, pl, [animals], animal).
lex(noun, pl, [answers], answer).
lex(noun, pl, [applications], application).
lex(noun, pl, [approaches], approach).
lex(noun, pl, [areas], area).
lex(noun, pl, [arguments], argument).
lex(noun, pl, [arms], arm).
lex(noun, pl, [arrangements], arrangement).
lex(noun, pl, [articles], article).
lex(noun, pl, [artists], artist).
lex(noun, pl, [arts], art).
lex(noun, pl, [aspects], aspect).
lex(noun, pl, [assets], asset).
lex(noun, pl, [assumptions], assumption).
lex(noun, pl, [attempts], attempt).
lex(noun, pl, [attitudes], attitude).
lex(noun, pl, [authorities], authority).
lex(noun, pl, [authors], author).
lex(noun, pl, [babies], baby).
lex(noun, pl, [bands], band).
lex(noun, pl, [banks], bank).
lex(noun, pl, [bars], bar).
lex(noun, pl, [beliefs], belief).
lex(noun, pl, [benefits], benefit).
lex(noun, pl, [bills], bill).
lex(noun, pl, [birds], bird).
lex(noun, pl, [bits], bit).
lex(noun, pl, [boards], board).
lex(noun, pl, [bodies], body).
lex(noun, pl, [bones], bone).
lex(noun, pl, [books], book).
lex(noun, pl, [boots], boot).
lex(noun, pl, [boundaries], boundary).
lex(noun, pl, [boxes], box).
lex(noun, pl, [boys], boy).
lex(noun, pl, [branches], branch).
lex(noun, pl, [brothers], brother).
lex(noun, pl, [buildings], building).
lex(noun, pl, [businesses], business).
lex(noun, pl, [calls], call).
lex(noun, pl, [candidates], candidate).
lex(noun, pl, [cards], card).
lex(noun, pl, [cars], car).
lex(noun, pl, [cases], case).
lex(noun, pl, [categories], category).
lex(noun, pl, [cattle], cattle).
lex(noun, pl, [causes], cause).
lex(noun, pl, [cells], cell).
lex(noun, pl, [centres], centre).
lex(noun, pl, [centuries], century).
lex(noun, pl, [chances], chance).
lex(noun, pl, [changes], change).
lex(noun, pl, [characteristics], characteristic).
lex(noun, pl, [characters], character).
lex(noun, pl, [charges], charge).
lex(noun, pl, [chemicals], chemical).
lex(noun, pl, [children], child).
lex(noun, pl, [churches], church).
lex(noun, pl, [circumstances], circumstance).
lex(noun, pl, [cities], city).
lex(noun, pl, [citizens], citizen).
lex(noun, pl, [claims], claim).
lex(noun, pl, [classes], class).
lex(noun, pl, [clients], client).
lex(noun, pl, [clothes], clothe).
lex(noun, pl, [clubs], club).
lex(noun, pl, [colleagues], colleague).
lex(noun, pl, [colleges], college).
lex(noun, pl, [colours], colour).
lex(noun, pl, [comments], comment).
lex(noun, pl, [committees], committee).
lex(noun, pl, [communications], communication).
lex(noun, pl, [communities], community).
lex(noun, pl, [companies], company).
lex(noun, pl, [complaints], complaint).
lex(noun, pl, [components], component).
lex(noun, pl, [computers], computer).
lex(noun, pl, [concepts], concept).
lex(noun, pl, [concerns], concern).
lex(noun, pl, [conclusions], conclusion).
lex(noun, pl, [conditions], condition).
lex(noun, pl, [connections], connection).
lex(noun, pl, [consequences], consequence).
lex(noun, pl, [conservatives], conservative).
lex(noun, pl, [considerations], consideration).
lex(noun, pl, [consumers], consumer).
lex(noun, pl, [contents], content).
lex(noun, pl, [contracts], contract).
lex(noun, pl, [contributions], contribution).
lex(noun, pl, [controls], control).
lex(noun, pl, [copies], copy).
lex(noun, pl, [costs], cost).
lex(noun, pl, [councils], council).
lex(noun, pl, [countries], country).
lex(noun, pl, [courses], course).
lex(noun, pl, [courts], court).
lex(noun, pl, [criteria], criteria).
lex(noun, pl, [critics], critic).
lex(noun, pl, [customers], customer).
lex(noun, pl, [cuts], cut).
lex(noun, pl, [dates], date).
lex(noun, pl, [days], day).
lex(noun, pl, [deaths], death).
lex(noun, pl, [decades], decade).
lex(noun, pl, [decisions], decision).
lex(noun, pl, [degrees], degree).
lex(noun, pl, [demands], demand).
lex(noun, pl, [departments], department).
lex(noun, pl, [designs], design).
lex(noun, pl, [details], detail).
lex(noun, pl, [developments], development).
lex(noun, pl, [devices], device).
lex(noun, pl, [differences], difference).
lex(noun, pl, [difficulties], difficulty).
lex(noun, pl, [directions], direction).
lex(noun, pl, [directors], director).
lex(noun, pl, [discussions], discussion).
lex(noun, pl, [divisions], division).
lex(noun, pl, [doctors], doctor).
lex(noun, pl, [documents], document).
lex(noun, pl, [dogs], dog).
lex(noun, pl, [doors], door).
lex(noun, pl, [drawings], drawing).
lex(noun, pl, [dreams], dream).
lex(noun, pl, [drivers], driver).
lex(noun, pl, [drugs], drug).
lex(noun, pl, [duties], duty).
lex(noun, pl, [earnings], earning).
lex(noun, pl, [ears], ear).
lex(noun, pl, [effects], effect).
lex(noun, pl, [efforts], effort).
lex(noun, pl, [eggs], egg).
lex(noun, pl, [elections], election).
lex(noun, pl, [elements], element).
lex(noun, pl, [employees], employee).
lex(noun, pl, [employers], employer).
lex(noun, pl, [ends], end).
lex(noun, pl, [errors], error).
lex(noun, pl, [events], event).
lex(noun, pl, [examples], example).
lex(noun, pl, [expectations], expectation).
lex(noun, pl, [experiences], experience).
lex(noun, pl, [experiments], experiment).
lex(noun, pl, [experts], expert).
lex(noun, pl, [eyes], eye).
lex(noun, pl, [faces], face).
lex(noun, pl, [facilities], facility).
lex(noun, pl, [factors], factor).
lex(noun, pl, [facts], fact).
lex(noun, pl, [families], family).
lex(noun, pl, [fans], fan).
lex(noun, pl, [farmers], farmer).
lex(noun, pl, [fears], fear).
lex(noun, pl, [features], feature).
lex(noun, pl, [feelings], feeling).
lex(noun, pl, [fees], fee).
lex(noun, pl, [feet], foot).
lex(noun, pl, [fields], field).
lex(noun, pl, [figures], figure).
lex(noun, pl, [films], film).
lex(noun, pl, [findings], finding).
lex(noun, pl, [fingers], finger).
lex(noun, pl, [firms], firm).
lex(noun, pl, [flowers], flower).
lex(noun, pl, [forces], force).
lex(noun, pl, [forms], form).
lex(noun, pl, [friends], friend).
lex(noun, pl, [functions], function).
lex(noun, pl, [funds], fund).
lex(noun, pl, [games], game).
lex(noun, pl, [gardens], garden).
lex(noun, pl, [generations], generation).
lex(noun, pl, [girls], girl).
lex(noun, pl, [glasses], glass).
lex(noun, pl, [goals], goal).
lex(noun, pl, [goods], good).
lex(noun, pl, [governments], government).
lex(noun, pl, [grounds], ground).
lex(noun, pl, [groups], group).
lex(noun, pl, [guests], guest).
lex(noun, pl, [guidelines], guideline).
lex(noun, pl, [hands], hand).
lex(noun, pl, [heads], head).
lex(noun, pl, [hills], hill).
lex(noun, pl, [holes], hole).
lex(noun, pl, [holidays], holiday).
lex(noun, pl, [homes], home).
lex(noun, pl, [horses], horse).
lex(noun, pl, [hospitals], hospital).
lex(noun, pl, [hotels], hotel).
lex(noun, pl, [hours], hour).
lex(noun, pl, [houses], house).
lex(noun, pl, [hundreds], hundred).
lex(noun, pl, [ideas], idea).
lex(noun, pl, [images], image).
lex(noun, pl, [implications], implication).
lex(noun, pl, [improvements], improvement).
lex(noun, pl, [inches], inch).
lex(noun, pl, [individuals], individual).
lex(noun, pl, [industries], industry).
lex(noun, pl, [injuries], injury).
lex(noun, pl, [institutions], institution).
lex(noun, pl, [instructions], instruction).
lex(noun, pl, [instruments], instrument).
lex(noun, pl, [interests], interest).
lex(noun, pl, [investors], investor).
lex(noun, pl, [islands], island).
lex(noun, pl, [issues], issue).
lex(noun, pl, [items], item).
lex(noun, pl, [jobs], job).
lex(noun, pl, [judges], judge).
lex(noun, pl, [keys], key).
lex(noun, pl, [kids], kid).
lex(noun, pl, [kinds], kind).
lex(noun, pl, [knees], knee).
lex(noun, pl, [ladies], lady).
lex(noun, pl, [languages], language).
lex(noun, pl, [laws], law).
lex(noun, pl, [lawyers], lawyer).
lex(noun, pl, [leaders], leader).
lex(noun, pl, [leaves], leave).
lex(noun, pl, [legs], leg).
lex(noun, pl, [lessons], lesson).
lex(noun, pl, [letters], letter).
lex(noun, pl, [levels], level).
lex(noun, pl, [libraries], library).
lex(noun, pl, [lights], light).
lex(noun, pl, [limits], limit).
lex(noun, pl, [lines], line).
lex(noun, pl, [links], link).
lex(noun, pl, [lips], lip).
lex(noun, pl, [lists], list).
lex(noun, pl, [lives], live).
lex(noun, pl, [loans], loan).
lex(noun, pl, [losses], loss).
lex(noun, pl, [machines], machine).
lex(noun, pl, [males], male).
lex(noun, pl, [managers], manager).
lex(noun, pl, [manufacturers], manufacturer).
lex(noun, pl, [markets], market).
lex(noun, pl, [marks], mark).
lex(noun, pl, [materials], material).
lex(noun, pl, [matters], matter).
lex(noun, pl, [meals], meal).
lex(noun, pl, [measures], measure).
lex(noun, pl, [meetings], meeting).
lex(noun, pl, [members], member).
lex(noun, pl, [memories], memory).
lex(noun, pl, [men], man).
lex(noun, pl, [methods], method).
lex(noun, pl, [metres], metre).
lex(noun, pl, [miles], mile).
lex(noun, pl, [millions], million).
lex(noun, pl, [minds], mind).
lex(noun, pl, [ministers], minister).
lex(noun, pl, [minutes], minute).
lex(noun, pl, [models], model).
lex(noun, pl, [modules], module).
lex(noun, pl, [moments], moment).
lex(noun, pl, [months], month).
lex(noun, pl, [mothers], mother).
lex(noun, pl, [mountains], mountain).
lex(noun, pl, [movements], movement).
lex(noun, pl, [names], name).
lex(noun, pl, [nations], nation).
lex(noun, pl, [needs], need).
lex(noun, pl, [negotiations], negotiation).
lex(noun, pl, [neighbours], neighbour).
lex(noun, pl, [newspapers], newspaper).
lex(noun, pl, [nights], night).
lex(noun, pl, [notes], note).
lex(noun, pl, [numbers], number).
lex(noun, pl, [nurses], nurse).
lex(noun, pl, [objectives], objective).
lex(noun, pl, [objects], object).
lex(noun, pl, [observations], observation).
lex(noun, pl, [occasions], occasion).
lex(noun, pl, [offences], offence).
lex(noun, pl, [officers], officer).
lex(noun, pl, [offices], office).
lex(noun, pl, [officials], official).
lex(noun, pl, [operations], operation).
lex(noun, pl, [opportunities], opportunity).
lex(noun, pl, [options], option).
lex(noun, pl, [orders], order).
lex(noun, pl, [organisations], organisation).
lex(noun, pl, [others], other).
lex(noun, pl, [owners], owner).
lex(noun, pl, [pages], page).
lex(noun, pl, [paintings], painting).
lex(noun, pl, [pairs], pair).
lex(noun, pl, [papers], paper).
lex(noun, pl, [parents], parent).
lex(noun, pl, [participants], participant).
lex(noun, pl, [parties], party).
lex(noun, pl, [partners], partner).
lex(noun, pl, [parts], part).
lex(noun, pl, [passengers], passenger).
lex(noun, pl, [patients], patient).
lex(noun, pl, [patterns], pattern).
lex(noun, pl, [payments], payment).
lex(noun, pl, [periods], period).
lex(noun, pl, [personnel], personnel).
lex(noun, pl, [persons], person).
lex(noun, pl, [photographs], photograph).
lex(noun, pl, [pictures], picture).
lex(noun, pl, [pieces], piece).
lex(noun, pl, [places], place).
lex(noun, pl, [plans], plan).
lex(noun, pl, [plants], plant).
lex(noun, pl, [players], player).
lex(noun, pl, [points], point).
lex(noun, pl, [police], police).
lex(noun, pl, [policies], policy).
lex(noun, pl, [politicians], politician).
lex(noun, pl, [positions], position).
lex(noun, pl, [possibilities], possibility).
lex(noun, pl, [pounds], pound).
lex(noun, pl, [powers], power).
lex(noun, pl, [practices], practice).
lex(noun, pl, [premises], premise).
lex(noun, pl, [pressures], pressure).
lex(noun, pl, [prices], price).
lex(noun, pl, [principles], principle).
lex(noun, pl, [prisoners], prisoner).
lex(noun, pl, [problems], problem).
lex(noun, pl, [procedures], procedure).
lex(noun, pl, [proceedings], proceeding).
lex(noun, pl, [processes], process).
lex(noun, pl, [products], product).
lex(noun, pl, [professionals], professional).
lex(noun, pl, [profits], profit).
lex(noun, pl, [programmes], programme).
lex(noun, pl, [projects], project).
lex(noun, pl, [properties], property).
lex(noun, pl, [proposals], proposal).
lex(noun, pl, [provisions], provision).
lex(noun, pl, [pupils], pupil).
lex(noun, pl, [purposes], purpose).
lex(noun, pl, [qualifications], qualification).
lex(noun, pl, [qualities], quality).
lex(noun, pl, [questions], question).
lex(noun, pl, [rates], rate).
lex(noun, pl, [readers], reader).
lex(noun, pl, [reasons], reason).
lex(noun, pl, [recommendations], recommendation).
lex(noun, pl, [records], record).
lex(noun, pl, [reforms], reform).
lex(noun, pl, [regions], region).
lex(noun, pl, [regulations], regulation).
lex(noun, pl, [relations], relation).
lex(noun, pl, [relationships], relationship).
lex(noun, pl, [relatives], relative).
lex(noun, pl, [reports], report).
lex(noun, pl, [representatives], representative).
lex(noun, pl, [requirements], requirement).
lex(noun, pl, [researchers], researcher).
lex(noun, pl, [residents], resident).
lex(noun, pl, [resources], resource).
lex(noun, pl, [responses], response).
lex(noun, pl, [responsibilities], responsibility).
lex(noun, pl, [restrictions], restriction).
lex(noun, pl, [results], result).
lex(noun, pl, [rights], right).
lex(noun, pl, [rivers], river).
lex(noun, pl, [roads], road).
lex(noun, pl, [rocks], rock).
lex(noun, pl, [roles], role).
lex(noun, pl, [rooms], room).
lex(noun, pl, [roots], root).
lex(noun, pl, [rules], rule).
lex(noun, pl, [sales], sale).
lex(noun, pl, [samples], sample).
lex(noun, pl, [savings], saving).
lex(noun, pl, [schemes], scheme).
lex(noun, pl, [schools], school).
lex(noun, pl, [sciences], science).
lex(noun, pl, [scientists], scientist).
lex(noun, pl, [seats], seat).
lex(noun, pl, [seconds], second).
lex(noun, pl, [sections], section).
lex(noun, pl, [sectors], sector).
lex(noun, pl, [sentences], sentence).
lex(noun, pl, [servants], servant).
lex(noun, pl, [services], service).
lex(noun, pl, [sessions], session).
lex(noun, pl, [sets], set).
lex(noun, pl, [shareholders], shareholder).
lex(noun, pl, [shares], share).
lex(noun, pl, [sheets], sheet).
lex(noun, pl, [ships], ship).
lex(noun, pl, [shoes], shoe).
lex(noun, pl, [shops], shop).
lex(noun, pl, [shoulders], shoulder).
lex(noun, pl, [sides], side).
lex(noun, pl, [signs], sign).
lex(noun, pl, [sites], site).
lex(noun, pl, [situations], situation).
lex(noun, pl, [skills], skill).
lex(noun, pl, [societies], society).
lex(noun, pl, [soldiers], soldier).
lex(noun, pl, [solicitors], solicitor).
lex(noun, pl, [solutions], solution).
lex(noun, pl, [songs], song).
lex(noun, pl, [sons], son).
lex(noun, pl, [sorts], sort).
lex(noun, pl, [sounds], sound).
lex(noun, pl, [sources], source).
lex(noun, pl, [speakers], speaker).
lex(noun, pl, [sports], sport).
lex(noun, pl, [stages], stage).
lex(noun, pl, [stairs], stair).
lex(noun, pl, [standards], standard).
lex(noun, pl, [stars], star).
lex(noun, pl, [statements], statement).
lex(noun, pl, [states], state).
lex(noun, pl, [stations], station).
lex(noun, pl, [steps], step).
lex(noun, pl, [stones], stone).
lex(noun, pl, [stories], story).
lex(noun, pl, [strategies], strategy).
lex(noun, pl, [streets], street).
lex(noun, pl, [structures], structure).
lex(noun, pl, [students], student).
lex(noun, pl, [studies], study).
lex(noun, pl, [subjects], subject).
lex(noun, pl, [supporters], supporter).
lex(noun, pl, [symptoms], symptom).
lex(noun, pl, [systems], system).
lex(noun, pl, [tables], table).
lex(noun, pl, [talks], talk).
lex(noun, pl, [tasks], task).
lex(noun, pl, [taxes], tax).
lex(noun, pl, [teachers], teacher).
lex(noun, pl, [teams], team).
lex(noun, pl, [tears], tear).
lex(noun, pl, [techniques], technique).
lex(noun, pl, [teeth], tooth).
lex(noun, pl, [terms], term).
lex(noun, pl, [tests], test).
lex(noun, pl, [texts], text).
lex(noun, pl, [thanks], thank).
lex(noun, pl, [theories], theory).
lex(noun, pl, [things], thing).
lex(noun, pl, [thoughts], thought).
lex(noun, pl, [thousands], thousand).
lex(noun, pl, [tickets], ticket).
lex(noun, pl, [times], time).
lex(noun, pl, [tools], tool).
lex(noun, pl, [towns], town).
lex(noun, pl, [transactions], transaction).
lex(noun, pl, [trees], tree).
lex(noun, pl, [trends], trend).
lex(noun, pl, [trials], trial).
lex(noun, pl, [troops], troop).
lex(noun, pl, [trousers], trouser).
lex(noun, pl, [types], type).
lex(noun, pl, [unions], union).
lex(noun, pl, [units], unit).
lex(noun, pl, [universities], university).
lex(noun, pl, [users], user).
lex(noun, pl, [values], value).
lex(noun, pl, [variables], variable).
lex(noun, pl, [variations], variation).
lex(noun, pl, [vehicles], vehicle).
lex(noun, pl, [versions], version).
lex(noun, pl, [victims], victim).
lex(noun, pl, [views], view).
lex(noun, pl, [villages], village).
lex(noun, pl, [visitors], visitor).
lex(noun, pl, [voices], voice).
lex(noun, pl, [votes], vote).
lex(noun, pl, [wages], wage).
lex(noun, pl, [walls], wall).
lex(noun, pl, [waves], wave).
lex(noun, pl, [ways], way).
lex(noun, pl, [weapons], weapon).
lex(noun, pl, [weeks], week).
lex(noun, pl, [windows], window).
lex(noun, pl, [wings], wing).
lex(noun, pl, [women], woman).
lex(noun, pl, [words], word).
lex(noun, pl, [workers], worker).
lex(noun, pl, [writers], writer).
lex(noun, pl, [yards], yard).
lex(noun, pl, [years], year).
lex(noun, pl, [gauge], gauge).
lex(noun, pl, [group], group).


% ------------------------------------------------------------------------
% Frequency list: nouns plural; gen (at the start of a sentence
% ------------------------------------------------------------------------

lex(noun, pl, gen, ['Runners'], runner).
lex(noun, pl, gen, ['Positions'], position).
lex(noun, pl, gen, ['Jobs'], job).
lex(noun, pl, gen, ['Persons'], person).
lex(noun, pl, gen, ['Students'], student).
lex(noun, pl, gen, ['Accounts'], account).
lex(noun, pl, gen, ['Actions'], action).
lex(noun, pl, gen, ['Activities'], activity).
lex(noun, pl, gen, ['Acts'], act).
lex(noun, pl, gen, ['Adults'], adult).
lex(noun, pl, gen, ['Advantages'], advantage).
lex(noun, pl, gen, ['Affairs'], affair).
lex(noun, pl, gen, ['Agencies'], agency).
lex(noun, pl, gen, ['Agents'], agent).
lex(noun, pl, gen, ['Ages'], age).
lex(noun, pl, gen, ['Agreements'], agreement).
lex(noun, pl, gen, ['Aims'], aim).
lex(noun, pl, gen, ['Americans'], american).
lex(noun, pl, gen, ['Amounts'], amount).
lex(noun, pl, gen, ['Animals'], animal).
lex(noun, pl, gen, ['Answers'], answer).
lex(noun, pl, gen, ['Applications'], application).
lex(noun, pl, gen, ['Approaches'], approach).
lex(noun, pl, gen, ['Areas'], area).
lex(noun, pl, gen, ['Arguments'], argument).
lex(noun, pl, gen, ['Arms'], arm).
lex(noun, pl, gen, ['Arrangements'], arrangement).
lex(noun, pl, gen, ['Articles'], article).
lex(noun, pl, gen, ['Artists'], artist).
lex(noun, pl, gen, ['Arts'], art).
lex(noun, pl, gen, ['Aspects'], aspect).
lex(noun, pl, gen, ['Assets'], asset).
lex(noun, pl, gen, ['Assumptions'], assumption).
lex(noun, pl, gen, ['Attempts'], attempt).
lex(noun, pl, gen, ['Attitudes'], attitude).
lex(noun, pl, gen, ['Authorities'], authority).
lex(noun, pl, gen, ['Authors'], author).
lex(noun, pl, gen, ['Babies'], baby).
lex(noun, pl, gen, ['Bands'], band).
lex(noun, pl, gen, ['Banks'], bank).
lex(noun, pl, gen, ['Bars'], bar).
lex(noun, pl, gen, ['Beliefs'], belief).
lex(noun, pl, gen, ['Benefits'], benefit).
lex(noun, pl, gen, ['Bills'], bill).
lex(noun, pl, gen, ['Birds'], bird).
lex(noun, pl, gen, ['Bits'], bit).
lex(noun, pl, gen, ['Boards'], board).
lex(noun, pl, gen, ['Bodies'], body).
lex(noun, pl, gen, ['Bones'], bone).
lex(noun, pl, gen, ['Books'], book).
lex(noun, pl, gen, ['Boots'], boot).
lex(noun, pl, gen, ['Boundaries'], boundary).
lex(noun, pl, gen, ['Boxes'], box).
lex(noun, pl, gen, ['Boys'], boy).
lex(noun, pl, gen, ['Branches'], branch).
lex(noun, pl, gen, ['Brothers'], brother).
lex(noun, pl, gen, ['Buildings'], building).
lex(noun, pl, gen, ['Businesses'], business).
lex(noun, pl, gen, ['Calls'], call).
lex(noun, pl, gen, ['Candidates'], candidate).
lex(noun, pl, gen, ['Cards'], card).
lex(noun, pl, gen, ['Cars'], car).
lex(noun, pl, gen, ['Cases'], case).
lex(noun, pl, gen, ['Categories'], category).
lex(noun, pl, gen, ['Cattle'], cattle).
lex(noun, pl, gen, ['Causes'], cause).
lex(noun, pl, gen, ['Cells'], cell).
lex(noun, pl, gen, ['Centres'], centre).
lex(noun, pl, gen, ['Centuries'], century).
lex(noun, pl, gen, ['Chances'], chance).
lex(noun, pl, gen, ['Changes'], change).
lex(noun, pl, gen, ['Characteristics'], characteristic).
lex(noun, pl, gen, ['Characters'], character).
lex(noun, pl, gen, ['Charges'], charge).
lex(noun, pl, gen, ['Chemicals'], chemical).
lex(noun, pl, gen, ['Children'], child).
lex(noun, pl, gen, ['Churches'], church).
lex(noun, pl, gen, ['Circumstances'], circumstance).
lex(noun, pl, gen, ['Cities'], city).
lex(noun, pl, gen, ['Citizens'], citizen).
lex(noun, pl, gen, ['Claims'], claim).
lex(noun, pl, gen, ['Classes'], class).
lex(noun, pl, gen, ['Clients'], client).
lex(noun, pl, gen, ['Clothes'], clothe).
lex(noun, pl, gen, ['Clubs'], club).
lex(noun, pl, gen, ['Colleagues'], colleague).
lex(noun, pl, gen, ['Colleges'], college).
lex(noun, pl, gen, ['Colours'], colour).
lex(noun, pl, gen, ['Comments'], comment).
lex(noun, pl, gen, ['Committees'], committee).
lex(noun, pl, gen, ['Communications'], communication).
lex(noun, pl, gen, ['Communities'], community).
lex(noun, pl, gen, ['Companies'], company).
lex(noun, pl, gen, ['Complaints'], complaint).
lex(noun, pl, gen, ['Components'], component).
lex(noun, pl, gen, ['Computers'], computer).
lex(noun, pl, gen, ['Concepts'], concept).
lex(noun, pl, gen, ['Concerns'], concern).
lex(noun, pl, gen, ['Conclusions'], conclusion).
lex(noun, pl, gen, ['Conditions'], condition).
lex(noun, pl, gen, ['Connections'], connection).
lex(noun, pl, gen, ['Consequences'], consequence).
lex(noun, pl, gen, ['Conservatives'], conservative).
lex(noun, pl, gen, ['Considerations'], consideration).
lex(noun, pl, gen, ['Consumers'], consumer).
lex(noun, pl, gen, ['Contents'], content).
lex(noun, pl, gen, ['Contracts'], contract).
lex(noun, pl, gen, ['Contributions'], contribution).
lex(noun, pl, gen, ['Controls'], control).
lex(noun, pl, gen, ['Copies'], copy).
lex(noun, pl, gen, ['Costs'], cost).
lex(noun, pl, gen, ['Councils'], council).
lex(noun, pl, gen, ['Countries'], country).
lex(noun, pl, gen, ['Courses'], course).
lex(noun, pl, gen, ['Courts'], court).
lex(noun, pl, gen, ['Criteria'], criteria).
lex(noun, pl, gen, ['Critics'], critic).
lex(noun, pl, gen, ['Customers'], customer).
lex(noun, pl, gen, ['Cuts'], cut).
lex(noun, pl, gen, ['Dates'], date).
lex(noun, pl, gen, ['Days'], day).
lex(noun, pl, gen, ['Deaths'], death).
lex(noun, pl, gen, ['Decades'], decade).
lex(noun, pl, gen, ['Decisions'], decision).
lex(noun, pl, gen, ['Degrees'], degree).
lex(noun, pl, gen, ['Demands'], demand).
lex(noun, pl, gen, ['Departments'], department).
lex(noun, pl, gen, ['Designs'], design).
lex(noun, pl, gen, ['Details'], detail).
lex(noun, pl, gen, ['Developments'], development).
lex(noun, pl, gen, ['Devices'], device).
lex(noun, pl, gen, ['Differences'], difference).
lex(noun, pl, gen, ['Difficulties'], difficulty).
lex(noun, pl, gen, ['Directions'], direction).
lex(noun, pl, gen, ['Directors'], director).
lex(noun, pl, gen, ['Discussions'], discussion).
lex(noun, pl, gen, ['Divisions'], division).
lex(noun, pl, gen, ['Doctors'], doctor).
lex(noun, pl, gen, ['Documents'], document).
lex(noun, pl, gen, ['Dogs'], dog).
lex(noun, pl, gen, ['Doors'], door).
lex(noun, pl, gen, ['Drawings'], drawing).
lex(noun, pl, gen, ['Dreams'], dream).
lex(noun, pl, gen, ['Drivers'], driver).
lex(noun, pl, gen, ['Drugs'], drug).
lex(noun, pl, gen, ['Duties'], duty).
lex(noun, pl, gen, ['Earnings'], earning).
lex(noun, pl, gen, ['Ears'], ear).
lex(noun, pl, gen, ['Effects'], effect).
lex(noun, pl, gen, ['Efforts'], effort).
lex(noun, pl, gen, ['Eggs'], egg).
lex(noun, pl, gen, ['Elections'], election).
lex(noun, pl, gen, ['Elements'], element).
lex(noun, pl, gen, ['Employees'], employee).
lex(noun, pl, gen, ['Employers'], employer).
lex(noun, pl, gen, ['Ends'], end).
lex(noun, pl, gen, ['Errors'], error).
lex(noun, pl, gen, ['Events'], event).
lex(noun, pl, gen, ['Examples'], example).
lex(noun, pl, gen, ['Expectations'], expectation).
lex(noun, pl, gen, ['Experiences'], experience).
lex(noun, pl, gen, ['Experiments'], experiment).
lex(noun, pl, gen, ['Experts'], expert).
lex(noun, pl, gen, ['Eyes'], eye).
lex(noun, pl, gen, ['Faces'], face).
lex(noun, pl, gen, ['Facilities'], facility).
lex(noun, pl, gen, ['Factors'], factor).
lex(noun, pl, gen, ['Facts'], fact).
lex(noun, pl, gen, ['Families'], family).
lex(noun, pl, gen, ['Fans'], fan).
lex(noun, pl, gen, ['Farmers'], farmer).
lex(noun, pl, gen, ['Fears'], fear).
lex(noun, pl, gen, ['Features'], feature).
lex(noun, pl, gen, ['Feelings'], feeling).
lex(noun, pl, gen, ['Fees'], fee).
lex(noun, pl, gen, ['Feet'], foot).
lex(noun, pl, gen, ['Fields'], field).
lex(noun, pl, gen, ['Figures'], figure).
lex(noun, pl, gen, ['Films'], film).
lex(noun, pl, gen, ['Findings'], finding).
lex(noun, pl, gen, ['Fingers'], finger).
lex(noun, pl, gen, ['Firms'], firm).
lex(noun, pl, gen, ['Flowers'], flower).
lex(noun, pl, gen, ['Forces'], force).
lex(noun, pl, gen, ['Forms'], form).
lex(noun, pl, gen, ['Friends'], friend).
lex(noun, pl, gen, ['Functions'], function).
lex(noun, pl, gen, ['Funds'], fund).
lex(noun, pl, gen, ['Games'], game).
lex(noun, pl, gen, ['Gardens'], garden).
lex(noun, pl, gen, ['Generations'], generation).
lex(noun, pl, gen, ['Girls'], girl).
lex(noun, pl, gen, ['Glasses'], glass).
lex(noun, pl, gen, ['Goals'], goal).
lex(noun, pl, gen, ['Goods'], good).
lex(noun, pl, gen, ['Governments'], government).
lex(noun, pl, gen, ['Grounds'], ground).
lex(noun, pl, gen, ['Groups'], group).
lex(noun, pl, gen, ['Guests'], guest).
lex(noun, pl, gen, ['Guidelines'], guideline).
lex(noun, pl, gen, ['Hands'], hand).
lex(noun, pl, gen, ['Heads'], head).
lex(noun, pl, gen, ['Hills'], hill).
lex(noun, pl, gen, ['Holes'], hole).
lex(noun, pl, gen, ['Holidays'], holiday).
lex(noun, pl, gen, ['Homes'], home).
lex(noun, pl, gen, ['Horses'], horse).
lex(noun, pl, gen, ['Hospitals'], hospital).
lex(noun, pl, gen, ['Hotels'], hotel).
lex(noun, pl, gen, ['Hours'], hour).
lex(noun, pl, gen, ['Houses'], house).
lex(noun, pl, gen, ['Hundreds'], hundred).
lex(noun, pl, gen, ['Ideas'], idea).
lex(noun, pl, gen, ['Images'], image).
lex(noun, pl, gen, ['Implications'], implication).
lex(noun, pl, gen, ['Improvements'], improvement).
lex(noun, pl, gen, ['Inches'], inch).
lex(noun, pl, gen, ['Individuals'], individual).
lex(noun, pl, gen, ['Industries'], industry).
lex(noun, pl, gen, ['Injuries'], injury).
lex(noun, pl, gen, ['Institutions'], institution).
lex(noun, pl, gen, ['Instructions'], instruction).
lex(noun, pl, gen, ['Instruments'], instrument).
lex(noun, pl, gen, ['Interests'], interest).
lex(noun, pl, gen, ['Investors'], investor).
lex(noun, pl, gen, ['Islands'], island).
lex(noun, pl, gen, ['Issues'], issue).
lex(noun, pl, gen, ['Items'], item).
lex(noun, pl, gen, ['Jobs'], job).
lex(noun, pl, gen, ['Judges'], judge).
lex(noun, pl, gen, ['Keys'], key).
lex(noun, pl, gen, ['Kids'], kid).
lex(noun, pl, gen, ['Kinds'], kind).
lex(noun, pl, gen, ['Knees'], knee).
lex(noun, pl, gen, ['Ladies'], lady).
lex(noun, pl, gen, ['Languages'], language).
lex(noun, pl, gen, ['Laws'], law).
lex(noun, pl, gen, ['Lawyers'], lawyer).
lex(noun, pl, gen, ['Leaders'], leader).
lex(noun, pl, gen, ['Leaves'], leave).
lex(noun, pl, gen, ['Legs'], leg).
lex(noun, pl, gen, ['Lessons'], lesson).
lex(noun, pl, gen, ['Letters'], letter).
lex(noun, pl, gen, ['Levels'], level).
lex(noun, pl, gen, ['Libraries'], library).
lex(noun, pl, gen, ['Lights'], light).
lex(noun, pl, gen, ['Limits'], limit).
lex(noun, pl, gen, ['Lines'], line).
lex(noun, pl, gen, ['Links'], link).
lex(noun, pl, gen, ['Lips'], lip).
lex(noun, pl, gen, ['Lists'], list).
lex(noun, pl, gen, ['Lives'], live).
lex(noun, pl, gen, ['Loans'], loan).
lex(noun, pl, gen, ['Losses'], loss).
lex(noun, pl, gen, ['Machines'], machine).
lex(noun, pl, gen, ['Males'], male).
lex(noun, pl, gen, ['Managers'], manager).
lex(noun, pl, gen, ['Manufacturers'], manufacturer).
lex(noun, pl, gen, ['Markets'], market).
lex(noun, pl, gen, ['Marks'], mark).
lex(noun, pl, gen, ['Materials'], material).
lex(noun, pl, gen, ['Matters'], matter).
lex(noun, pl, gen, ['Meals'], meal).
lex(noun, pl, gen, ['Measures'], measure).
lex(noun, pl, gen, ['Meetings'], meeting).
lex(noun, pl, gen, ['Members'], member).
lex(noun, pl, gen, ['Memories'], memory).
lex(noun, pl, gen, ['Men'], man).
lex(noun, pl, gen, ['Methods'], method).
lex(noun, pl, gen, ['Metres'], metre).
lex(noun, pl, gen, ['Miles'], mile).
lex(noun, pl, gen, ['Millions'], million).
lex(noun, pl, gen, ['Minds'], mind).
lex(noun, pl, gen, ['Ministers'], minister).
lex(noun, pl, gen, ['Minutes'], minute).
lex(noun, pl, gen, ['Models'], model).
lex(noun, pl, gen, ['Modules'], module).
lex(noun, pl, gen, ['Moments'], moment).
lex(noun, pl, gen, ['Months'], month).
lex(noun, pl, gen, ['Mothers'], mother).
lex(noun, pl, gen, ['Mountains'], mountain).
lex(noun, pl, gen, ['Movements'], movement).
lex(noun, pl, gen, ['Names'], name).
lex(noun, pl, gen, ['Nations'], nation).
lex(noun, pl, gen, ['Needs'], need).
lex(noun, pl, gen, ['Negotiations'], negotiation).
lex(noun, pl, gen, ['Neighbours'], neighbour).
lex(noun, pl, gen, ['Newspapers'], newspaper).
lex(noun, pl, gen, ['Nights'], night).
lex(noun, pl, gen, ['Notes'], note).
lex(noun, pl, gen, ['Numbers'], number).
lex(noun, pl, gen, ['Nurses'], nurse).
lex(noun, pl, gen, ['Objectives'], objective).
lex(noun, pl, gen, ['Objects'], object).
lex(noun, pl, gen, ['Observations'], observation).
lex(noun, pl, gen, ['Occasions'], occasion).
lex(noun, pl, gen, ['Offences'], offence).
lex(noun, pl, gen, ['Officers'], officer).
lex(noun, pl, gen, ['Offices'], office).
lex(noun, pl, gen, ['Officials'], official).
lex(noun, pl, gen, ['Operations'], operation).
lex(noun, pl, gen, ['Opportunities'], opportunity).
lex(noun, pl, gen, ['Options'], option).
lex(noun, pl, gen, ['Orders'], order).
lex(noun, pl, gen, ['Organisations'], organisation).
lex(noun, pl, gen, ['Others'], other).
lex(noun, pl, gen, ['Owners'], owner).
lex(noun, pl, gen, ['Pages'], page).
lex(noun, pl, gen, ['Paintings'], painting).
lex(noun, pl, gen, ['Pairs'], pair).
lex(noun, pl, gen, ['Papers'], paper).
lex(noun, pl, gen, ['Parents'], parent).
lex(noun, pl, gen, ['Participants'], participant).
lex(noun, pl, gen, ['Parties'], party).
lex(noun, pl, gen, ['Partners'], partner).
lex(noun, pl, gen, ['Parts'], part).
lex(noun, pl, gen, ['Passengers'], passenger).
lex(noun, pl, gen, ['Patients'], patient).
lex(noun, pl, gen, ['Patterns'], pattern).
lex(noun, pl, gen, ['Payments'], payment).
lex(noun, pl, gen, ['Periods'], period).
lex(noun, pl, gen, ['Personnel'], personnel).
lex(noun, pl, gen, ['Persons'], person).
lex(noun, pl, gen, ['Photographs'], photograph).
lex(noun, pl, gen, ['Pictures'], picture).
lex(noun, pl, gen, ['Pieces'], piece).
lex(noun, pl, gen, ['Places'], place).
lex(noun, pl, gen, ['Plans'], plan).
lex(noun, pl, gen, ['Plants'], plant).
lex(noun, pl, gen, ['Players'], player).
lex(noun, pl, gen, ['Points'], point).
lex(noun, pl, gen, ['Police'], police).
lex(noun, pl, gen, ['Policies'], policy).
lex(noun, pl, gen, ['Politicians'], politician).
lex(noun, pl, gen, ['Positions'], position).
lex(noun, pl, gen, ['Possibilities'], possibility).
lex(noun, pl, gen, ['Pounds'], pound).
lex(noun, pl, gen, ['Powers'], power).
lex(noun, pl, gen, ['Practices'], practice).
lex(noun, pl, gen, ['Premises'], premise).
lex(noun, pl, gen, ['Pressures'], pressure).
lex(noun, pl, gen, ['Prices'], price).
lex(noun, pl, gen, ['Principles'], principle).
lex(noun, pl, gen, ['Prisoners'], prisoner).
lex(noun, pl, gen, ['Problems'], problem).
lex(noun, pl, gen, ['Procedures'], procedure).
lex(noun, pl, gen, ['Proceedings'], proceeding).
lex(noun, pl, gen, ['Processes'], process).
lex(noun, pl, gen, ['Products'], product).
lex(noun, pl, gen, ['Professionals'], professional).
lex(noun, pl, gen, ['Profits'], profit).
lex(noun, pl, gen, ['Programmes'], programme).
lex(noun, pl, gen, ['Projects'], project).
lex(noun, pl, gen, ['Properties'], property).
lex(noun, pl, gen, ['Proposals'], proposal).
lex(noun, pl, gen, ['Provisions'], provision).
lex(noun, pl, gen, ['Pupils'], pupil).
lex(noun, pl, gen, ['Purposes'], purpose).
lex(noun, pl, gen, ['Qualifications'], qualification).
lex(noun, pl, gen, ['Qualities'], quality).
lex(noun, pl, gen, ['Questions'], question).
lex(noun, pl, gen, ['Rates'], rate).
lex(noun, pl, gen, ['Readers'], reader).
lex(noun, pl, gen, ['Reasons'], reason).
lex(noun, pl, gen, ['Recommendations'], recommendation).
lex(noun, pl, gen, ['Records'], record).
lex(noun, pl, gen, ['Reforms'], reform).
lex(noun, pl, gen, ['Regions'], region).
lex(noun, pl, gen, ['Regulations'], regulation).
lex(noun, pl, gen, ['Relations'], relation).
lex(noun, pl, gen, ['Relationships'], relationship).
lex(noun, pl, gen, ['Relatives'], relative).
lex(noun, pl, gen, ['Reports'], report).
lex(noun, pl, gen, ['Representatives'], representative).
lex(noun, pl, gen, ['Requirements'], requirement).
lex(noun, pl, gen, ['Researchers'], researcher).
lex(noun, pl, gen, ['Residents'], resident).
lex(noun, pl, gen, ['Resources'], resource).
lex(noun, pl, gen, ['Responses'], response).
lex(noun, pl, gen, ['Responsibilities'], responsibility).
lex(noun, pl, gen, ['Restrictions'], restriction).
lex(noun, pl, gen, ['Results'], result).
lex(noun, pl, gen, ['Rights'], right).
lex(noun, pl, gen, ['Rivers'], river).
lex(noun, pl, gen, ['Roads'], road).
lex(noun, pl, gen, ['Rocks'], rock).
lex(noun, pl, gen, ['Roles'], role).
lex(noun, pl, gen, ['Rooms'], room).
lex(noun, pl, gen, ['Roots'], root).
lex(noun, pl, gen, ['Rules'], rule).
lex(noun, pl, gen, ['Sales'], sale).
lex(noun, pl, gen, ['Samples'], sample).
lex(noun, pl, gen, ['Savings'], saving).
lex(noun, pl, gen, ['Schemes'], scheme).
lex(noun, pl, gen, ['Schools'], school).
lex(noun, pl, gen, ['Sciences'], science).
lex(noun, pl, gen, ['Scientists'], scientist).
lex(noun, pl, gen, ['Seats'], seat).
lex(noun, pl, gen, ['Seconds'], second).
lex(noun, pl, gen, ['Sections'], section).
lex(noun, pl, gen, ['Sectors'], sector).
lex(noun, pl, gen, ['Sentences'], sentence).
lex(noun, pl, gen, ['Servants'], servant).
lex(noun, pl, gen, ['Services'], service).
lex(noun, pl, gen, ['Sessions'], session).
lex(noun, pl, gen, ['Sets'], set).
lex(noun, pl, gen, ['Shareholders'], shareholder).
lex(noun, pl, gen, ['Shares'], share).
lex(noun, pl, gen, ['Sheets'], sheet).
lex(noun, pl, gen, ['Ships'], ship).
lex(noun, pl, gen, ['Shoes'], shoe).
lex(noun, pl, gen, ['Shops'], shop).
lex(noun, pl, gen, ['Shoulders'], shoulder).
lex(noun, pl, gen, ['Sides'], side).
lex(noun, pl, gen, ['Signs'], sign).
lex(noun, pl, gen, ['Sites'], site).
lex(noun, pl, gen, ['Situations'], situation).
lex(noun, pl, gen, ['Skills'], skill).
lex(noun, pl, gen, ['Societies'], society).
lex(noun, pl, gen, ['Soldiers'], soldier).
lex(noun, pl, gen, ['Solicitors'], solicitor).
lex(noun, pl, gen, ['Solutions'], solution).
lex(noun, pl, gen, ['Songs'], song).
lex(noun, pl, gen, ['Sons'], son).
lex(noun, pl, gen, ['Sorts'], sort).
lex(noun, pl, gen, ['Sounds'], sound).
lex(noun, pl, gen, ['Sources'], source).
lex(noun, pl, gen, ['Speakers'], speaker).
lex(noun, pl, gen, ['Sports'], sport).
lex(noun, pl, gen, ['Stages'], stage).
lex(noun, pl, gen, ['Stairs'], stair).
lex(noun, pl, gen, ['Standards'], standard).
lex(noun, pl, gen, ['Stars'], star).
lex(noun, pl, gen, ['Statements'], statement).
lex(noun, pl, gen, ['States'], state).
lex(noun, pl, gen, ['Stations'], station).
lex(noun, pl, gen, ['Steps'], step).
lex(noun, pl, gen, ['Stones'], stone).
lex(noun, pl, gen, ['Stories'], story).
lex(noun, pl, gen, ['Strategies'], strategy).
lex(noun, pl, gen, ['Streets'], street).
lex(noun, pl, gen, ['Structures'], structure).
lex(noun, pl, gen, ['Students'], student).
lex(noun, pl, gen, ['Studies'], study).
lex(noun, pl, gen, ['Subjects'], subject).
lex(noun, pl, gen, ['Supporters'], supporter).
lex(noun, pl, gen, ['Symptoms'], symptom).
lex(noun, pl, gen, ['Systems'], system).
lex(noun, pl, gen, ['Tables'], table).
lex(noun, pl, gen, ['Talks'], talk).
lex(noun, pl, gen, ['Tasks'], task).
lex(noun, pl, gen, ['Taxes'], tax).
lex(noun, pl, gen, ['Teachers'], teacher).
lex(noun, pl, gen, ['Teams'], team).
lex(noun, pl, gen, ['Tears'], tear).
lex(noun, pl, gen, ['Techniques'], technique).
lex(noun, pl, gen, ['Teeth'], tooth).
lex(noun, pl, gen, ['Terms'], term).
lex(noun, pl, gen, ['Tests'], test).
lex(noun, pl, gen, ['Texts'], text).
lex(noun, pl, gen, ['Thanks'], thank).
lex(noun, pl, gen, ['Theories'], theory).
lex(noun, pl, gen, ['Things'], thing).
lex(noun, pl, gen, ['Thoughts'], thought).
lex(noun, pl, gen, ['Thousands'], thousand).
lex(noun, pl, gen, ['Tickets'], ticket).
lex(noun, pl, gen, ['Times'], time).
lex(noun, pl, gen, ['Tools'], tool).
lex(noun, pl, gen, ['Towns'], town).
lex(noun, pl, gen, ['Transactions'], transaction).
lex(noun, pl, gen, ['Trees'], tree).
lex(noun, pl, gen, ['Trends'], trend).
lex(noun, pl, gen, ['Trials'], trial).
lex(noun, pl, gen, ['Troops'], troop).
lex(noun, pl, gen, ['Trousers'], trouser).
lex(noun, pl, gen, ['Types'], type).
lex(noun, pl, gen, ['Unions'], union).
lex(noun, pl, gen, ['Units'], unit).
lex(noun, pl, gen, ['Universities'], university).
lex(noun, pl, gen, ['Users'], user).
lex(noun, pl, gen, ['Values'], value).
lex(noun, pl, gen, ['Variables'], variable).
lex(noun, pl, gen, ['Variations'], variation).
lex(noun, pl, gen, ['Vehicles'], vehicle).
lex(noun, pl, gen, ['Versions'], version).
lex(noun, pl, gen, ['Victims'], victim).
lex(noun, pl, gen, ['Views'], view).
lex(noun, pl, gen, ['Villages'], village).
lex(noun, pl, gen, ['Visitors'], visitor).
lex(noun, pl, gen, ['Voices'], voice).
lex(noun, pl, gen, ['Votes'], vote).
lex(noun, pl, gen, ['Wages'], wage).
lex(noun, pl, gen, ['Walls'], wall).
lex(noun, pl, gen, ['Waves'], wave).
lex(noun, pl, gen, ['Ways'], way).
lex(noun, pl, gen, ['Weapons'], weapon).
lex(noun, pl, gen, ['Weeks'], week).
lex(noun, pl, gen, ['Windows'], window).
lex(noun, pl, gen, ['Wings'], wing).
lex(noun, pl, gen, ['Women'], woman).
lex(noun, pl, gen, ['Words'], word).
lex(noun, pl, gen, ['Workers'], worker).
lex(noun, pl, gen, ['Writers'], writer).
lex(noun, pl, gen, ['Yards'], yard).
lex(noun, pl, gen, ['Years'], year).
lex(noun, pl, gen, ['Gauge'], gauge).
lex(noun, pl, gen, ['Group'], group).


% ------------------------------------------------------------------------
% Frequency list: intransitive verbs
% ------------------------------------------------------------------------

lex(intransitive_verb,  VForm, Num, WF, Sem) :-
   lex(intransitive_verb, VForm, Num, Event, WF, Sem).

lex(intransitive_verb, fin, sg, event, [dreams], dream).
lex(intransitive_verb, fin, pl, event, [dream], dream).
lex(intransitive_verb, inf,  _, event, [dream], dream).

lex(intransitive_verb, fin, sg, event, [snores], snore).
lex(intransitive_verb, fin, pl, event, [snore], snore).
lex(intransitive_verb, inf,  _, event, [snore], snore).

lex(intransitive_verb, fin, sg, event, [runs], run).
lex(intransitive_verb, inf, pl, event, [run], run).
lex(intransitive_verb, inf,  _, event, [run], run).

lex(intransitive_verb, fin, sg, event, [acts], act).
lex(intransitive_verb, fin, pl, event, [act], act).
lex(intransitive_verb, inf,  _, event, [act], act).

lex(intransitive_verb, fin, sg, event, [agrees], agree).
lex(intransitive_verb, fin, pl, event, [agree], agree).
lex(intransitive_verb, inf,  _, event, [agree], agree).

lex(intransitive_verb, fin, sg, event, [appears], appear).
lex(intransitive_verb, fin, pl, event, [appear], appear).
lex(intransitive_verb, inf,  _, event, [appear], appear).

lex(intransitive_verb, fin, sg, event, [approves], approve).
lex(intransitive_verb, fin, pl, event, [approve], approve).
lex(intransitive_verb, inf,  _, event, [approve], approve).

lex(intransitive_verb, fin, sg, event, [comes], come).
lex(intransitive_verb, fin, pl, event, [come], come).
lex(intransitive_verb, inf,  _, event, [come], come).

lex(intransitive_verb, fin, sg, event, [continues], continue).
lex(intransitive_verb, fin, pl, event, [continue], continue).
lex(intransitive_verb, inf,  _, event, [continue], continue).

lex(intransitive_verb, fin, sg, event, [cries], cry).
lex(intransitive_verb, fin, pl, event, [cry], cry).
lex(intransitive_verb, inf,  _, event, [cry], cry).

lex(intransitive_verb, fin, sg, event, [dies], die).
lex(intransitive_verb, fin, pl, event, [die], die).
lex(intransitive_verb, inf,  _, event, [die], die).

lex(intransitive_verb, fin, sg, state, [differs], differ).
lex(intransitive_verb, fin, pl, state, [differ], differ).
lex(intransitive_verb, inf,  _, state, [differ], differ).

lex(intransitive_verb, fin, sg, event, [disappears], disappear).
lex(intransitive_verb, fin, pl, event, [disappear], disappear).
lex(intransitive_verb, inf,  _, event, [disappear], disappear).

lex(intransitive_verb, fin, sg, event, [exercises], exercise).
lex(intransitive_verb, fin, pl, event, [exercise], exercise).
lex(intransitive_verb, inf,  _, event, [exercise], exercise).

lex(intransitive_verb, fin, sg, state, [exists], exist).
lex(intransitive_verb, fin, pl, state, [exist], exist).
lex(intransitive_verb, inf,  _, state, [exist], exist).

lex(intransitive_verb, fin, sg, event, [falls], fall).
lex(intransitive_verb, fin, pl, event, [fall], fall).
lex(intransitive_verb, inf,  _, event, [fall], fall).

lex(intransitive_verb, fin, sg, event, [goes], go).
lex(intransitive_verb, fin, pl, event, [go], go).
lex(intransitive_verb, inf,  _, event, [go], go).

lex(intransitive_verb, fin, sg, event, [insists], insist).
lex(intransitive_verb, fin, pl, event, [insist], insist).
lex(intransitive_verb, inf,  _, event, [insist], insist).

lex(intransitive_verb, fin, sg, event, [interferes], interfere).
lex(intransitive_verb, fin, pl, event, [interfere], interfere).
lex(intransitive_verb, inf,  _, event, [interfere], interfere).

lex(intransitive_verb, fin, sg, event, [intervenes], intervene).
lex(intransitive_verb, fin, pl, event, [intervene], intervene).
lex(intransitive_verb, inf,  _, event, [intervene], intervene).

lex(intransitive_verb, fin, sg, state, [lasts], last).
lex(intransitive_verb, fin, pl, state, [last], last).
lex(intransitive_verb, inf,  _, state, [last], last).

lex(intransitive_verb, fin, sg, event, [lives], live).
lex(intransitive_verb, fin, pl, event, [live], live).
lex(intransitive_verb, inf,  _, event, [live], live).

lex(intransitive_verb, fin, sg, event, [matters], matter).
lex(intransitive_verb, fin, pl, event, [matter], matter).
lex(intransitive_verb, inf,  _, event, [matter], matter).

lex(intransitive_verb, fin, sg, event, [minds], mind).
lex(intransitive_verb, fin, pl, event, [mind], mind).
lex(intransitive_verb, inf,  _, event, [mind], mind).

lex(intransitive_verb, fin, sg, event, [proceeds], proceed).
lex(intransitive_verb, fin, pl, event, [proceed], proceed).
lex(intransitive_verb, inf,  _, event, [proceed], proceed).

lex(intransitive_verb, fin, sg, event, [reacts], react).
lex(intransitive_verb, fin, pl, event, [react], react).
lex(intransitive_verb, inf,  _, event, [react], react).

lex(intransitive_verb, fin, sg, event, [relaxes], relax).
lex(intransitive_verb, fin, pl, event, [relax], relax).
lex(intransitive_verb, inf,  _, event, [relax], relax).

lex(intransitive_verb, fin, sg, event, [resigns], resign).
lex(intransitive_verb, fin, pl, event, [resign], resign).
lex(intransitive_verb, inf,  _, event, [resign], resign).

lex(intransitive_verb, fin, sg, event, [rests], rest).
lex(intransitive_verb, fin, pl, event, [rest], rest).
lex(intransitive_verb, inf,  _, event, [rest], rest).

lex(intransitive_verb, fin, sg, event, [retires], retire).
lex(intransitive_verb, fin, pl, event, [retire], retire).
lex(intransitive_verb, inf,  _, event, [retire], retire).

lex(intransitive_verb, fin, sg, event, [returns], return).
lex(intransitive_verb, fin, pl, event, [return], return).
lex(intransitive_verb, inf,  _, event, [return], return).

lex(intransitive_verb, fin, sg, event, [rises], rise).
lex(intransitive_verb, fin, pl, event, [rise], rise).
lex(intransitive_verb, inf,  _, event, [rise], rise).

lex(intransitive_verb, fin, sg, event, [sings], sing).
lex(intransitive_verb, fin, pl, event, [sing], sing).
lex(intransitive_verb, inf,  _, event, [sing], sing).

lex(intransitive_verb, fin, sg, state, [sits], sit).
lex(intransitive_verb, fin, pl, state, [sit], sit).
lex(intransitive_verb, inf,  _, state, [sit], sit).

lex(intransitive_verb, fin, sg, event, [sleeps], sleep).
lex(intransitive_verb, fin, pl, event, [sleep], sleep).
lex(intransitive_verb, inf,  _, event, [sleep], sleep).

lex(intransitive_verb, fin, sg, event, [slips], slip).
lex(intransitive_verb, fin, pl, event, [slip], slip).
lex(intransitive_verb, inf,  _, event, [slip], slip).

lex(intransitive_verb, fin, sg, event, [smiles], smile).
lex(intransitive_verb, fin, pl, event, [smile], smile).
lex(intransitive_verb, inf,  _, event, [smile], smile).

lex(intransitive_verb, fin, sg, state, [stands], stand).
lex(intransitive_verb, fin, pl, state, [stand], stand).
lex(intransitive_verb, inf,  _, state, [stand], stand).

lex(intransitive_verb, fin, sg, event, [steps], step).
lex(intransitive_verb, fin, pl, event, [step], step).
lex(intransitive_verb, inf,  _, event, [step], step).

lex(intransitive_verb, fin, sg, event, [stops], stop).
lex(intransitive_verb, fin, pl, event, [stop], stop).
lex(intransitive_verb, inf,  _, event, [stop], stop).

lex(intransitive_verb, fin, sg, event, [succeeds], succeed).
lex(intransitive_verb, fin, pl, event, [succeed], succeed).
lex(intransitive_verb, inf,  _, event, [succeed], succeed).

lex(intransitive_verb, fin, sg, state, [suffers], suffer).
lex(intransitive_verb, fin, pl, state, [suffer], suffer).
lex(intransitive_verb, inf,  _, state, [suffer], suffer).

lex(intransitive_verb, fin, sg, event, [suits], suit).
lex(intransitive_verb, fin, pl, event, [suit], suit).
lex(intransitive_verb, inf,  _, event, [suit], suit).

lex(intransitive_verb, fin, sg, event, [survives], survive).
lex(intransitive_verb, fin, pl, event, [survive], survive).
lex(intransitive_verb, inf,  _, event, [survive], survive).

lex(intransitive_verb, fin, sg, event, [thinks], think).
lex(intransitive_verb, fin, pl, event, [think], think).
lex(intransitive_verb, inf,  _, event, [think], think).

lex(intransitive_verb, fin, sg, event, [votes], vote).
lex(intransitive_verb, fin, pl, event, [vote], vote).
lex(intransitive_verb, inf,  _, event, [vote], vote).

lex(intransitive_verb, fin, sg, state, [waits], wait).
lex(intransitive_verb, fin, pl, state, [wait], wait).
lex(intransitive_verb, inf,  _, state, [wait], wait).

lex(intransitive_verb, fin, sg, event, [wakes], wake).
lex(intransitive_verb, fin, pl, event, [wake], wake).
lex(intransitive_verb, inf,  _, event, [wake], wake).

lex(intransitive_verb, fin, sg, event, [wans], wan).
lex(intransitive_verb, fin, pl, event, [wan], wan).
lex(intransitive_verb, inf,  _, event, [wan], wan).

lex(intransitive_verb, fin, sg, event, [welcomes], welcome).
lex(intransitive_verb, fin, pl, event, [welcome], welcome).
lex(intransitive_verb, inf,  _, event, [welcome], welcome).

lex(intransitive_verb, fin, sg, event, [works], work).
lex(intransitive_verb, fin, pl, event, [work], work).
lex(intransitive_verb, inf,  _, event, [work], work).

lex(intransitive_verb, fin, sg, event, [decreases], decrease).
lex(intransitive_verb, fin, pl, event, [decrease], decrease).
lex(intransitive_verb, inf,  _, event, [decrease], decrease).

lex(intransitive_verb, fin, sg, state, [flows], flow).
lex(intransitive_verb, fin, pl, state, [flow], flow).
lex(intransitive_verb, inf,  _, state, [flow], flow).

lex(intransitive_verb, fin, sg, event, [freezes], freeze).
lex(intransitive_verb, fin, pl, event, [freeze], freeze).
lex(intransitive_verb, inf,  _, event, [freeze], freeze).

lex(intransitive_verb, fin, sg, event, [melts], melt).
lex(intransitive_verb, fin, pl, event, [melt], melt).
lex(intransitive_verb, inf,  _, event, [melt], melt).

lex(intransitive_verb, fin, sg, event, [occurs], occur).
lex(intransitive_verb, fin, pl, event, [occur], occur).
lex(intransitive_verb, inf,  _, event, [occur], occur).

lex(intransitive_verb, fin, sg, event, [recoils], recoil).
lex(intransitive_verb, fin, pl, event, [recoil], recoil).
lex(intransitive_verb, inf, sg, event, [recoil], recoil).


% ------------------------------------------------------------------------
% Frequency list: transitive verbs
% ------------------------------------------------------------------------

lex(transitive_verb, VForm, Num, Lex, Sym) :-
  lex(transitive_verb, VForm, Num, Event, Lex, Sym).

lex(transitive_verb, fin, sg, state, [has], have).
lex(transitive_verb, fin, pl, state, [have], have).
lex(transitive_verb, inf,  _, state, [have], have).

lex(transitive_verb, fin, sg, event, [repairs], repair).
lex(transitive_verb, fin, pl, event, [repair], repair).
lex(transitive_verb, inf,  _, event, [repair], repair).

lex(transitive_verb, fin, sg, event, [abandons], abandon).
lex(transitive_verb, fin, pl, event, [abandon], abandon).
lex(transitive_verb, inf,  _, event, [abandon], abandon).

lex(transitive_verb, fin, sg, event, [accepts], accept).
lex(transitive_verb, fin, pl, event, [accept], accept).
lex(transitive_verb, inf,  _, event, [accept], accept).

lex(transitive_verb, fin, sg, event, [accommodates], accommodate).
lex(transitive_verb, fin, pl, event, [accommodate], accommodate).
lex(transitive_verb, inf,  _, event, [accommodate], accommodate).

lex(transitive_verb, fin, sg, event, [achieves], achieve).
lex(transitive_verb, fin, pl, event, [achieve], achieve).
lex(transitive_verb, inf,  _, event, [achieve], achieve).

lex(transitive_verb, fin, sg, event, [acknowledges], acknowledge).
lex(transitive_verb, fin, pl, event, [acknowledge], acknowledge).
lex(transitive_verb, inf,  _, event, [acknowledge], acknowledge).

lex(transitive_verb, fin, sg, event, [acquires], acquire).
lex(transitive_verb, fin, pl, event, [acquire], acquire).
lex(transitive_verb, inf,  _, event, [acquire], acquire).

lex(transitive_verb, fin, sg, event, [adds], add).
lex(transitive_verb, fin, pl, event, [add], add).
lex(transitive_verb, inf,  _, event, [add], add).

lex(transitive_verb, fin, sg, event, [addresses], address).
lex(transitive_verb, fin, pl, event, [address], address).
lex(transitive_verb, inf,  _, event, [address], address).

lex(transitive_verb, fin, sg, event, [adjusts], adjust).
lex(transitive_verb, fin, pl, event, [adjust], adjust).
lex(transitive_verb, inf,  _, event, [adjust], adjust).

lex(transitive_verb, fin, sg, event, [admits], admit).
lex(transitive_verb, fin, pl, event, [admit], admit).
lex(transitive_verb, inf,  _, event, [admit], admit).

lex(transitive_verb, fin, sg, event, [adopts], adopt).
lex(transitive_verb, fin, pl, event, [adopt], adopt).
lex(transitive_verb, inf,  _, event, [adopt], adopt).

lex(transitive_verb, fin, sg, event, [advises], advise).
lex(transitive_verb, fin, pl, event, [advise], advise).
lex(transitive_verb, inf,  _, event, [advise], advise).

lex(transitive_verb, fin, sg, event, [affects], affect).
lex(transitive_verb, fin, pl, event, [affect], affect).
lex(transitive_verb, inf,  _, event, [affect], affect).

lex(transitive_verb, fin, sg, event, [affords], afford).
lex(transitive_verb, fin, pl, event, [afford], afford).
lex(transitive_verb, inf,  _, event, [afford], afford).

lex(transitive_verb, fin, sg, event, [allows], allow).
lex(transitive_verb, fin, pl, event, [allow], allow).
lex(transitive_verb, inf,  _, event, [allow], allow).

lex(transitive_verb, fin, sg, event, [alters], alter).
lex(transitive_verb, fin, pl, event, [alter], alter).
lex(transitive_verb, inf,  _, event, [alter], alter).

lex(transitive_verb, fin, sg, event, [analyses], analyse).
lex(transitive_verb, fin, pl, event, [analyse], analyse).
lex(transitive_verb, inf,  _, event, [analyse], analyse).

lex(transitive_verb, fin, sg, event, [announces], announce).
lex(transitive_verb, fin, pl, event, [announce], announce).
lex(transitive_verb, inf,  _, event, [announce], announce).

lex(transitive_verb, fin, sg, event, [answers], answer).
lex(transitive_verb, fin, pl, event, [answer], answer).
lex(transitive_verb, inf,  _, event, [appeal], appeal).

lex(transitive_verb, fin, sg, event, [appeals], appeal).
lex(transitive_verb, fin, pl, event, [appeal], appeal).
lex(transitive_verb, inf,  _, event, [appeal], appeal).

lex(transitive_verb, fin, sg, event, [appoints], appoint).
lex(transitive_verb, fin, pl, event, [appoint], appoint).
lex(transitive_verb, inf,  _, event, [appoint], appoint).

lex(transitive_verb, fin, sg, state, [appreciates], appreciate).
lex(transitive_verb, fin, pl, state, [appreciate], appreciate).
lex(transitive_verb, inf,  _, state, [appreciate], appreciate).

lex(transitive_verb, fin, sg, event, [approaches], approach).
lex(transitive_verb, fin, pl, event, [approach], approach).
lex(transitive_verb, inf,  _, event, [approach], approach).

lex(transitive_verb, fin, sg, event, [approves], approve).
lex(transitive_verb, fin, pl, event, [approve], approve).
lex(transitive_verb, inf,  _, event, [approve], approve).

lex(transitive_verb, fin, sg, event, [argues], argue).
lex(transitive_verb, fin, pl, event, [argue], argue).
lex(transitive_verb, inf,  _, event, [argue], argue).

lex(transitive_verb, fin, sg, event, [arranges], arrange).
lex(transitive_verb, fin, pl, event, [arrange], arrange).
lex(transitive_verb, inf,  _, event, [arrange], arrange).

lex(transitive_verb, fin, sg, event, [assesses], assess).
lex(transitive_verb, fin, pl, event, [assess], assess).
lex(transitive_verb, inf,  _, event, [assess], assess).

lex(transitive_verb, fin, sg, event, [assists], assist).
lex(transitive_verb, fin, pl, event, [assist], assist).
lex(transitive_verb, inf,  _, event, [assist], assist).

lex(transitive_verb, fin, sg, event, [assumes], assume).
lex(transitive_verb, fin, pl, event, [assume], assume).
lex(transitive_verb, inf,  _, event, [assume], assume).

lex(transitive_verb, fin, sg, event, [attacks], attack).
lex(transitive_verb, fin, pl, event, [attack], attack).
lex(transitive_verb, inf,  _, event, [attack], attack).

lex(transitive_verb, fin, sg, event, [attends], attend).
lex(transitive_verb, fin, pl, event, [attend], attend).
lex(transitive_verb, inf,  _, event, [attend], attend).

lex(transitive_verb, fin, sg, event, [attracts], attract).
lex(transitive_verb, fin, pl, event, [attract], attract).
lex(transitive_verb, inf,  _, event, [attract], attract).

lex(transitive_verb, fin, sg, event, [avoids], avoid).
lex(transitive_verb, fin, pl, event, [avoid], avoid).
lex(transitive_verb, inf,  _, event, [avoid], avoid).

lex(transitive_verb, fin, sg, event, [backs], back).
lex(transitive_verb, fin, pl, event, [back], back).
lex(transitive_verb, inf,  _, event, [back], back).

lex(transitive_verb, fin, sg, event, [bears], bear).
lex(transitive_verb, fin, pl, event, [bear], bear).
lex(transitive_verb, inf,  _, event, [bear], bear).

lex(transitive_verb, fin, sg, event, [beats], beat).
lex(transitive_verb, fin, pl, event, [beat], beat).
lex(transitive_verb, inf,  _, event, [beat], beat).

lex(transitive_verb, fin, sg, event, [becomes], become).
lex(transitive_verb, fin, pl, event, [become], become).
lex(transitive_verb, inf,  _, event, [become], become).

lex(transitive_verb, fin, sg, event, [begins], begin).
lex(transitive_verb, fin, pl, event, [begin], begin).
lex(transitive_verb, inf,  _, event, [begin], begin).

lex(transitive_verb, fin, sg, event, [benefits], benefit).
lex(transitive_verb, fin, pl, event, [benefit], benefit).
lex(transitive_verb, inf,  _, event, [benefit], benefit).

lex(transitive_verb, fin, sg, event, [blames], blame).
lex(transitive_verb, fin, pl, event, [blame], blame).
lex(transitive_verb, inf,  _, event, [blame], blame).

lex(transitive_verb, fin, sg, event, [blows], blow).
lex(transitive_verb, fin, pl, event, [blow], blow).
lex(transitive_verb, inf,  _, event, [blow], blow).

lex(transitive_verb, fin, sg, event, [boosts], boost).
lex(transitive_verb, fin, pl, event, [boost], boost).
lex(transitive_verb, inf,  _, event, [boost], boost).

lex(transitive_verb, fin, sg, event, [borrows], borrow).
lex(transitive_verb, fin, pl, event, [borrow], borrow).
lex(transitive_verb, inf,  _, event, [borrow], borrow).

lex(transitive_verb, fin, sg, event, [bothers], bother).
lex(transitive_verb, fin, pl, event, [bother], bother).
lex(transitive_verb, inf,  _, event, [bother], bother).

lex(transitive_verb, fin, sg, event, [breaks], break).
lex(transitive_verb, fin, pl, event, [break], break).
lex(transitive_verb, inf,  _, event, [break], break).

lex(transitive_verb, fin, sg, event, [breathes], breathe).
lex(transitive_verb, fin, pl, event, [breathe], breathe).
lex(transitive_verb, inf,  _, event, [breathe], breathe).

lex(transitive_verb, fin, sg, event, [brings], bring).
lex(transitive_verb, fin, pl, event, [bring], bring).
lex(transitive_verb, inf,  _, event, [bring], bring).

lex(transitive_verb, fin, sg, event, [builds], build).
lex(transitive_verb, fin, pl, event, [build], build).
lex(transitive_verb, inf,  _, event, [build], build).

lex(transitive_verb, fin, sg, event, [burns], burn).
lex(transitive_verb, fin, pl, event, [burn], burn).
lex(transitive_verb, inf,  _, event, [burn], burn).

lex(transitive_verb, fin, sg, event, [buys], buy).
lex(transitive_verb, fin, pl, event, [buy], buy).
lex(transitive_verb, inf,  _, event, [buy], buy).

lex(transitive_verb, fin, sg, event, [calls], call).
lex(transitive_verb, fin, pl, event, [call], call).
lex(transitive_verb, inf,  _, event, [call], call).

lex(transitive_verb, fin, sg, event, [carries], carry).
lex(transitive_verb, fin, pl, event, [carry], carry).
lex(transitive_verb, inf,  _, event, [carry], carry).

lex(transitive_verb, fin, sg, event, [catches], catch).
lex(transitive_verb, fin, pl, event, [catch], catch).
lex(transitive_verb, inf,  _, event, [catch], catch).

lex(transitive_verb, fin, sg, event, [causes], cause).
lex(transitive_verb, fin, pl, event, [cause], cause).
lex(transitive_verb, inf,  _, event, [cause], cause).

lex(transitive_verb, fin, sg, event, [celebrates], celebrate).
lex(transitive_verb, fin, pl, event, [celebrate], celebrate).
lex(transitive_verb, inf,  _, event, [celebrate], celebrate).

lex(transitive_verb, fin, sg, event, [challenges], challenge).
lex(transitive_verb, fin, pl, event, [challenge], challenge).
lex(transitive_verb, inf,  _, event, [challenge], challenge).

lex(transitive_verb, fin, sg, event, [changes], change).
lex(transitive_verb, fin, pl, event, [change], change).
lex(transitive_verb, inf,  _, event, [change], change).

lex(transitive_verb, fin, sg, event, [charges], charge).
lex(transitive_verb, fin, pl, event, [charge], charge).
lex(transitive_verb, inf,  _, event, [charge], charge).

lex(transitive_verb, fin, sg, event, [checks], check).
lex(transitive_verb, fin, pl, event, [check], check).
lex(transitive_verb, inf,  _, event, [check], check).

lex(transitive_verb, fin, sg, event, [chooses], choose).
lex(transitive_verb, fin, pl, event, [choose], choose).
lex(transitive_verb, inf,  _, event, [choose], choose).

lex(transitive_verb, fin, sg, event, [claims], claim).
lex(transitive_verb, fin, pl, event, [claim], claim).
lex(transitive_verb, inf,  _, event, [claim], claim).

lex(transitive_verb, fin, sg, event, [clarifies], clarify).
lex(transitive_verb, fin, pl, event, [clarify], clarify).
lex(transitive_verb, inf,  _, event, [clarify], clarify).

lex(transitive_verb, fin, sg, event, [cleans], clean).
lex(transitive_verb, fin, pl, event, [clean], clean).
lex(transitive_verb, inf,  _, event, [clean], clean).

lex(transitive_verb, fin, sg, event, [clears], clear).
lex(transitive_verb, fin, pl, event, [clear], clear).
lex(transitive_verb, inf,  _, event, [clear], clear).

lex(transitive_verb, fin, sg, event, [climbs], climb).
lex(transitive_verb, fin, pl, event, [climb], climb).
lex(transitive_verb, inf,  _, event, [climb], climb).

lex(transitive_verb, fin, sg, event, [closes], close).
lex(transitive_verb, fin, pl, event, [close], close).
lex(transitive_verb, inf,  _, event, [close], close).

lex(transitive_verb, fin, sg, event, [collects], collect).
lex(transitive_verb, fin, pl, event, [collect], collect).
lex(transitive_verb, inf,  _, event, [collect], collect).

lex(transitive_verb, fin, sg, event, [comments], comment).
lex(transitive_verb, fin, pl, event, [comment], comment).
lex(transitive_verb, inf,  _, event, [comment], comment).

lex(transitive_verb, fin, sg, event, [commits], commit).
lex(transitive_verb, fin, pl, event, [commit], commit).
lex(transitive_verb, inf,  _, event, [commit], commit).

lex(transitive_verb, fin, sg, event, [communicates], communicate).
lex(transitive_verb, fin, pl, event, [communicate], communicate).
lex(transitive_verb, inf,  _, event, [communicate], communicate).

lex(transitive_verb, fin, sg, event, [compares], compare).
lex(transitive_verb, fin, pl, event, [compare], compare).
lex(transitive_verb, inf,  _, event, [compare], compare).

lex(transitive_verb, fin, sg, event, [compensates], compensate).
lex(transitive_verb, fin, pl, event, [compensate], compensate).
lex(transitive_verb, inf,  _, event, [compensate], compensate).

lex(transitive_verb, fin, sg, event, [completes], complete).
lex(transitive_verb, fin, pl, event, [complete], complete).
lex(transitive_verb, inf,  _, event, [complete], complete).

lex(transitive_verb, fin, sg, event, [concludes], conclude).
lex(transitive_verb, fin, pl, event, [conclude], conclude).
lex(transitive_verb, inf,  _, event, [conclude], conclude).

lex(transitive_verb, fin, sg, event, [conducts], conduct).
lex(transitive_verb, fin, pl, event, [conduct], conduct).
lex(transitive_verb, inf,  _, event, [conduct], conduct).

lex(transitive_verb, fin, sg, event, [confirms], confirm).
lex(transitive_verb, fin, pl, event, [confirm], confirm).
lex(transitive_verb, inf,  _, event, [confirm], confirm).

lex(transitive_verb, fin, sg, event, [considers], consider).
lex(transitive_verb, fin, pl, event, [consider], consider).
lex(transitive_verb, inf,  _, event, [consider], consider).

lex(transitive_verb, fin, sg, event, [constitutes], constitute).
lex(transitive_verb, fin, pl, event, [constitute], constitute).
lex(transitive_verb, inf,  _, event, [constitute], constitute).

lex(transitive_verb, fin, sg, event, [constructs], construct).
lex(transitive_verb, fin, pl, event, [construct], construct).
lex(transitive_verb, inf,  _, event, [construct], construct).

lex(transitive_verb, fin, sg, event, [consults], consult).
lex(transitive_verb, fin, pl, event, [consult], consult).
lex(transitive_verb, inf,  _, event, [consult], consult).

lex(transitive_verb, fin, sg, event, [contacts], contact).
lex(transitive_verb, fin, pl, event, [contact], contact).
lex(transitive_verb, inf,  _, event, [contact], contact).

lex(transitive_verb, fin, sg, event, [contains], contain).
lex(transitive_verb, fin, pl, event, [contain], contain).
lex(transitive_verb, inf,  _, event, [contain], contain).

lex(transitive_verb, fin, sg, event, [continues], continue).
lex(transitive_verb, fin, pl, event, [continue], continue).
lex(transitive_verb, inf,  _, event, [continue], continue).

lex(transitive_verb, fin, sg, event, [contributes], contribute).
lex(transitive_verb, fin, pl, event, [contribute], contribute).
lex(transitive_verb, inf,  _, event, [contribute], contribute).

lex(transitive_verb, fin, sg, event, [controls], control).
lex(transitive_verb, fin, pl, event, [control], control).
lex(transitive_verb, inf,  _, event, [control], control).

lex(transitive_verb, fin, sg, event, [converts], convert).
lex(transitive_verb, fin, pl, event, [convert], convert).
lex(transitive_verb, inf,  _, event, [convert], convert).

lex(transitive_verb, fin, sg, event, [conveys], convey).
lex(transitive_verb, fin, pl, event, [convey], convey).
lex(transitive_verb, inf,  _, event, [convey], convey).

lex(transitive_verb, fin, sg, event, [convinces], convince).
lex(transitive_verb, fin, pl, event, [convince], convince).
lex(transitive_verb, inf,  _, event, [convince], convince).

lex(transitive_verb, fin, sg, event, [cooks], cook).
lex(transitive_verb, fin, pl, event, [cook], cook).
lex(transitive_verb, inf,  _, event, [cook], cook).

lex(transitive_verb, fin, sg, event, [costs], cost).
lex(transitive_verb, fin, pl, event, [cost], cost).
lex(transitive_verb, inf,  _, event, [cost], cost).

lex(transitive_verb, fin, sg, event, [counts], count).
lex(transitive_verb, fin, pl, event, [count], count).
lex(transitive_verb, inf,  _, event, [count], count).

lex(transitive_verb, fin, sg, event, [covers], cover).
lex(transitive_verb, fin, pl, event, [cover], cover).
lex(transitive_verb, inf,  _, event, [cover], cover).

lex(transitive_verb, fin, sg, event, [creates], create).
lex(transitive_verb, fin, pl, event, [create], create).
lex(transitive_verb, inf,  _, event, [create], create).

lex(transitive_verb, fin, sg, event, [crosses], cross).
lex(transitive_verb, fin, pl, event, [cross], cross).
lex(transitive_verb, inf,  _, event, [cross], cross).

lex(transitive_verb, fin, sg, event, [cuts], cut).
lex(transitive_verb, fin, pl, event, [cut], cut).
lex(transitive_verb, inf,  _, event, [cut], cut).

lex(transitive_verb, fin, sg, event, [damages], damage).
lex(transitive_verb, fin, pl, event, [damage], damage).
lex(transitive_verb, inf,  _, event, [damage], damage).

lex(transitive_verb, fin, sg, event, [dates], date).
lex(transitive_verb, fin, pl, event, [date], date).
lex(transitive_verb, inf,  _, event, [date], date).

lex(transitive_verb, fin, sg, event, [deals], deal).
lex(transitive_verb, fin, pl, event, [deal], deal).
lex(transitive_verb, inf,  _, event, [deal], deal).

lex(transitive_verb, fin, sg, event, [decides], decide).
lex(transitive_verb, fin, pl, event, [decide], decide).
lex(transitive_verb, inf,  _, event, [decide], decide).

lex(transitive_verb, fin, sg, event, [defends], defend).
lex(transitive_verb, fin, pl, event, [defend], defend).
lex(transitive_verb, inf,  _, event, [defend], defend).

lex(transitive_verb, fin, sg, event, [defines], define).
lex(transitive_verb, fin, pl, event, [define], define).
lex(transitive_verb, inf,  _, event, [define], define).

lex(transitive_verb, fin, sg, event, [delivers], deliver).
lex(transitive_verb, fin, pl, event, [deliver], deliver).
lex(transitive_verb, inf,  _, event, [deliver], deliver).

lex(transitive_verb, fin, sg, event, [demands], demand).
lex(transitive_verb, fin, pl, event, [demand], demand).
lex(transitive_verb, inf,  _, event, [demand], demand).

lex(transitive_verb, fin, sg, event, [demonstrates], demonstrate).
lex(transitive_verb, fin, pl, event, [demonstrate], demonstrate).
lex(transitive_verb, inf,  _, event, [demonstrate], demonstrate).

lex(transitive_verb, fin, sg, event, [denies], deny).
lex(transitive_verb, fin, pl, event, [deny], deny).
lex(transitive_verb, inf,  _, event, [deny], deny).

lex(transitive_verb, fin, sg, event, [describes], describe).
lex(transitive_verb, fin, pl, event, [describe], describe).
lex(transitive_verb, inf,  _, event, [describe], describe).

lex(transitive_verb, fin, sg, event, [destroys], destroy).
lex(transitive_verb, fin, pl, event, [destroy], destroy).
lex(transitive_verb, inf,  _, event, [destroy], destroy).

lex(transitive_verb, fin, sg, event, [detects], detect).
lex(transitive_verb, fin, pl, event, [detect], detect).
lex(transitive_verb, inf,  _, event, [detect], detect).

lex(transitive_verb, fin, sg, event, [determines], determine).
lex(transitive_verb, fin, pl, event, [determine], determine).
lex(transitive_verb, inf,  _, event, [determine], determine).

lex(transitive_verb, fin, sg, event, [develops], develop).
lex(transitive_verb, fin, pl, event, [develop], develop).
lex(transitive_verb, inf,  _, event, [develop], develop).

lex(transitive_verb, fin, sg, event, [directs], direct).
lex(transitive_verb, fin, pl, event, [direct], direct).
lex(transitive_verb, inf,  _, event, [direct], direct).

lex(transitive_verb, fin, sg, event, [discovers], discover).
lex(transitive_verb, fin, pl, event, [discover], discover).
lex(transitive_verb, inf,  _, event, [discover], discover).

lex(transitive_verb, fin, sg, event, [discusses], discuss).
lex(transitive_verb, fin, pl, event, [discuss], discuss).
lex(transitive_verb, inf,  _, event, [discuss], discuss).

lex(transitive_verb, fin, sg, event, [displays], display).
lex(transitive_verb, fin, pl, event, [display], display).
lex(transitive_verb, inf,  _, event, [display], display).

lex(transitive_verb, fin, sg, event, [distinguishes], distinguish).
lex(transitive_verb, fin, pl, event, [distinguish], distinguish).
lex(transitive_verb, inf,  _, event, [distinguish], distinguish).

lex(transitive_verb, fin, sg, event, [draws], draw).
lex(transitive_verb, fin, pl, event, [draw], draw).
lex(transitive_verb, inf,  _, event, [draw], draw).

lex(transitive_verb, fin, sg, event, [drinks], drink).
lex(transitive_verb, fin, pl, event, [drink], drink).
lex(transitive_verb, inf,  _, event, [drink], drink).

lex(transitive_verb, fin, sg, event, [drives], drive).
lex(transitive_verb, fin, pl, event, [drive], drive).
lex(transitive_verb, inf,  _, event, [drive], drive).

lex(transitive_verb, fin, sg, event, [drops], drop).
lex(transitive_verb, fin, pl, event, [drop], drop).
lex(transitive_verb, inf,  _, event, [drop], drop).

lex(transitive_verb, fin, sg, event, [dries], dry).
lex(transitive_verb, fin, pl, event, [dry], dry).
lex(transitive_verb, inf,  _, event, [dry], dry).

lex(transitive_verb, fin, sg, event, [earns], earn).
lex(transitive_verb, fin, pl, event, [earn], earn).
lex(transitive_verb, inf,  _, event, [earn], earn).

lex(transitive_verb, fin, sg, event, [eases], ease).
lex(transitive_verb, fin, pl, event, [ease], ease).
lex(transitive_verb, inf,  _, event, [ease], ease).

lex(transitive_verb, fin, sg, event, [eats], eat).
lex(transitive_verb, fin, pl, event, [eat], eat).
lex(transitive_verb, inf,  _, event, [eat], eat).

lex(transitive_verb, fin, sg, event, [eliminates], eliminate).
lex(transitive_verb, fin, pl, event, [eliminate], eliminate).
lex(transitive_verb, inf,  _, event, [eliminate], eliminate).

lex(transitive_verb, fin, sg, event, [emerges], emerge).
lex(transitive_verb, fin, pl, event, [emerge], emerge).
lex(transitive_verb, inf,  _, event, [emerge], emerge).

lex(transitive_verb, fin, sg, event, [employs], employ).
lex(transitive_verb, fin, pl, event, [employ], employ).
lex(transitive_verb, inf,  _, event, [employ], employ).

lex(transitive_verb, fin, sg, event, [enables], enable).
lex(transitive_verb, fin, pl, event, [enable], enable).
lex(transitive_verb, inf,  _, event, [enable], enable).

lex(transitive_verb, fin, sg, event, [encourages], encourage).
lex(transitive_verb, fin, pl, event, [encourage], encourage).
lex(transitive_verb, inf,  _, event, [encourage], encourage).

lex(transitive_verb, fin, sg, event, [ends], end).
lex(transitive_verb, fin, pl, event, [end], end).
lex(transitive_verb, inf,  _, event, [end], end).

lex(transitive_verb, fin, sg, event, [enforces], enforce).
lex(transitive_verb, fin, pl, event, [enforce], enforce).
lex(transitive_verb, inf,  _, event, [enforce], enforce).

lex(transitive_verb, fin, sg, event, [engages], engage).
lex(transitive_verb, fin, pl, event, [engage], engage).
lex(transitive_verb, inf,  _, event, [engage], engage).

lex(transitive_verb, fin, sg, event, [enhances], enhance).
lex(transitive_verb, fin, pl, event, [enhance], enhance).
lex(transitive_verb, inf,  _, event, [enhance], enhance).

lex(transitive_verb, fin, sg, event, [enjoys], enjoy).
lex(transitive_verb, fin, pl, event, [enjoy], enjoy).
lex(transitive_verb, inf,  _, event, [enjoy], enjoy).

lex(transitive_verb, fin, sg, event, [ensures], ensure).
lex(transitive_verb, fin, pl, event, [ensure], ensure).
lex(transitive_verb, inf,  _, event, [ensure], ensure).

lex(transitive_verb, fin, sg, event, [enters], enter).
lex(transitive_verb, fin, pl, event, [enter], enter).
lex(transitive_verb, inf,  _, event, [enter], enter).

lex(transitive_verb, fin, sg, event, [escapes], escape).
lex(transitive_verb, fin, pl, event, [escape], escape).
lex(transitive_verb, inf,  _, event, [escape], escape).

lex(transitive_verb, fin, sg, event, [establishes], establish).
lex(transitive_verb, fin, pl, event, [establish], establish).
lex(transitive_verb, inf,  _, event, [establish], establish).

lex(transitive_verb, fin, sg, event, [evaluates], evaluate).
lex(transitive_verb, fin, pl, event, [evaluate], evaluate).
lex(transitive_verb, inf,  _, event, [evaluate], evaluate).

lex(transitive_verb, fin, sg, event, [examines], examine).
lex(transitive_verb, fin, pl, event, [examine], examine).
lex(transitive_verb, inf,  _, event, [examine], examine).

lex(transitive_verb, fin, sg, event, [excludes], exclude).
lex(transitive_verb, fin, pl, event, [exclude], exclude).
lex(transitive_verb, inf,  _, event, [exclude], exclude).

lex(transitive_verb, fin, sg, event, [exercises], exercise).
lex(transitive_verb, fin, pl, event, [exercise], exercise).
lex(transitive_verb, inf,  _, event, [exercise], exercise).

lex(transitive_verb, fin, sg, event, [expands], expand).
lex(transitive_verb, fin, pl, event, [expand], expand).
lex(transitive_verb, inf,  _, event, [expand], expand).

lex(transitive_verb, fin, sg, event, [expects], expect).
lex(transitive_verb, fin, pl, event, [expect], expect).
lex(transitive_verb, inf,  _, event, [expect], expect).

lex(transitive_verb, fin, sg, event, [experiences], experience).
lex(transitive_verb, fin, pl, event, [experience], experience).
lex(transitive_verb, inf,  _, event, [experience], experience).

lex(transitive_verb, fin, sg, event, [explains], explain).
lex(transitive_verb, fin, pl, event, [explain], explain).
lex(transitive_verb, inf,  _, event, [explain], explain).

lex(transitive_verb, fin, sg, event, [exploits], exploit).
lex(transitive_verb, fin, pl, event, [exploit], exploit).
lex(transitive_verb, inf,  _, event, [exploit], exploit).

lex(transitive_verb, fin, sg, event, [explores], explore).
lex(transitive_verb, fin, pl, event, [explore], explore).
lex(transitive_verb, inf,  _, event, [explore], explore).

lex(transitive_verb, fin, sg, event, [expresses], express).
lex(transitive_verb, fin, pl, event, [express], express).
lex(transitive_verb, inf,  _, event, [express], express).

lex(transitive_verb, fin, sg, event, [extends], extend).
lex(transitive_verb, fin, pl, event, [extend], extend).
lex(transitive_verb, inf,  _, event, [extend], extend).

lex(transitive_verb, fin, sg, event, [faces], face).
lex(transitive_verb, fin, pl, event, [face], face).
lex(transitive_verb, inf,  _, event, [face], face).

lex(transitive_verb, fin, sg, event, [facilitates], facilitate).
lex(transitive_verb, fin, pl, event, [facilitate], facilitate).
lex(transitive_verb, inf,  _, event, [facilitate], facilitate).

lex(transitive_verb, fin, sg, event, [fails], fail).
lex(transitive_verb, fin, pl, event, [fail], fail).
lex(transitive_verb, inf,  _, event, [fail], fail).

lex(transitive_verb, fin, sg, event, [feeds], feed).
lex(transitive_verb, fin, pl, event, [feed], feed).
lex(transitive_verb, inf,  _, event, [feed], feed).

lex(transitive_verb, fin, sg, event, [feels], feel).
lex(transitive_verb, fin, pl, event, [feel], feel).
lex(transitive_verb, inf,  _, event, [feel], feel).

lex(transitive_verb, fin, sg, event, [fetches], fetch).
lex(transitive_verb, fin, pl, event, [fetch], fetch).
lex(transitive_verb, inf,  _, event, [fetch], fetch).

lex(transitive_verb, fin, sg, event, [fights], fight).
lex(transitive_verb, fin, pl, event, [fight], fight).
lex(transitive_verb, inf,  _, event, [fight], fight).

lex(transitive_verb, fin, sg, event, [fills], fill).
lex(transitive_verb, fin, pl, event, [fill], fill).
lex(transitive_verb, inf,  _, event, [fill], fill).

lex(transitive_verb, fin, sg, event, [finances], finance).
lex(transitive_verb, fin, pl, event, [finance], finance).
lex(transitive_verb, inf,  _, event, [finance], finance).

lex(transitive_verb, fin, sg, event, [finds], find).
lex(transitive_verb, fin, pl, event, [find], find).
lex(transitive_verb, inf,  _, event, [find], find).

lex(transitive_verb, fin, sg, event, [finishes], finish).
lex(transitive_verb, fin, pl, event, [finish], finish).
lex(transitive_verb, inf,  _, event, [finish], finish).

lex(transitive_verb, fin, sg, event, [fits], fit).
lex(transitive_verb, fin, pl, event, [fit], fit).
lex(transitive_verb, inf,  _, event, [fit], fit).

lex(transitive_verb, fin, sg, event, [fixes], fix).
lex(transitive_verb, fin, pl, event, [fix], fix).
lex(transitive_verb, inf,  _, event, [fix], fix).

lex(transitive_verb, fin, sg, event, [flies], fly).
lex(transitive_verb, fin, pl, event, [fly], fly).
lex(transitive_verb, inf,  _, event, [fly], fly).

lex(transitive_verb, fin, sg, event, [focuses], focus).
lex(transitive_verb, fin, pl, event, [focus], focus).
lex(transitive_verb, inf,  _, event, [focus], focus).

lex(transitive_verb, fin, sg, event, [follows], follow).
lex(transitive_verb, fin, pl, event, [follow], follow).
lex(transitive_verb, inf,  _, event, [follow], follow).

lex(transitive_verb, fin, sg, event, [forces], force).
lex(transitive_verb, fin, pl, event, [force], force).
lex(transitive_verb, inf,  _, event, [force], force).

lex(transitive_verb, fin, sg, event, [forgets], forget).
lex(transitive_verb, fin, pl, event, [forget], forget).
lex(transitive_verb, inf,  _, event, [forget], forget).

lex(transitive_verb, fin, sg, event, [forgives], forgive).
lex(transitive_verb, fin, pl, event, [forgive], forgive).
lex(transitive_verb, inf,  _, event, [forgive], forgive).

lex(transitive_verb, fin, sg, event, [forms], form).
lex(transitive_verb, fin, pl, event, [form], form).
lex(transitive_verb, inf,  _, event, [form], form).

lex(transitive_verb, fin, sg, event, [frees], free).
lex(transitive_verb, fin, pl, event, [free], free).
lex(transitive_verb, inf,  _, event, [free], free).

lex(transitive_verb, fin, sg, event, [fulfils], fulfil).
lex(transitive_verb, fin, pl, event, [fulfil], fulfil).
lex(transitive_verb, inf,  _, event, [fulfil], fulfil).

lex(transitive_verb, fin, sg, event, [gains], gain).
lex(transitive_verb, fin, pl, event, [gain], gain).
lex(transitive_verb, inf,  _, event, [gain], gain).

lex(transitive_verb, fin, sg, event, [gathers], gather).
lex(transitive_verb, fin, pl, event, [gather], gather).
lex(transitive_verb, inf,  _, event, [gather], gather).

lex(transitive_verb, fin, sg, event, [generates], generate).
lex(transitive_verb, fin, pl, event, [generate], generate).
lex(transitive_verb, inf,  _, event, [generate], generate).

lex(transitive_verb, fin, sg, event, [gets], get).
lex(transitive_verb, fin, pl, event, [get], get).
lex(transitive_verb, inf,  _, event, [get], get).

lex(transitive_verb, fin, sg, event, [grants], grant).
lex(transitive_verb, fin, pl, event, [grant], grant).
lex(transitive_verb, inf,  _, event, [grant], grant).

lex(transitive_verb, fin, sg, event, [grows], grow).
lex(transitive_verb, fin, pl, event, [grow], grow).
lex(transitive_verb, inf,  _, event, [grow], grow).

lex(transitive_verb, fin, sg, event, [guarantees], guarantee).
lex(transitive_verb, fin, pl, event, [guarantee], guarantee).
lex(transitive_verb, inf,  _, event, [guarantee], guarantee).

lex(transitive_verb, fin, sg, event, [guesses], guess).
lex(transitive_verb, fin, pl, event, [guess], guess).
lex(transitive_verb, inf,  _, event, [guess], guess).

lex(transitive_verb, fin, sg, event, [handles], handle).
lex(transitive_verb, fin, pl, event, [handle], handle).
lex(transitive_verb, inf,  _, event, [handle], handle).

lex(transitive_verb, fin, sg, event, [hangs], hang).
lex(transitive_verb, fin, pl, event, [hang], hang).
lex(transitive_verb, inf,  _, event, [hang], hang).

lex(transitive_verb, fin, sg, event, [hates], hate).
lex(transitive_verb, fin, pl, event, [hate], hate).
lex(transitive_verb, inf,  _, event, [hate], hate).

lex(transitive_verb, fin, sg, event, [helps], help).
lex(transitive_verb, fin, pl, event, [help], help).
lex(transitive_verb, inf,  _, event, [help], help).

lex(transitive_verb, fin, sg, event, [hears], hear).
lex(transitive_verb, fin, pl, event, [hear], hear).
lex(transitive_verb, inf,  _, event, [hear], hear).

lex(transitive_verb, fin, sg, event, [hides], hide).
lex(transitive_verb, fin, pl, event, [hide], hide).
lex(transitive_verb, inf,  _, event, [hide], hide).

lex(transitive_verb, fin, sg, event, [hits], hit).
lex(transitive_verb, fin, pl, event, [hit], hit).
lex(transitive_verb, inf,  _, event, [hit], hit).

lex(transitive_verb, fin, sg, event, [holds], hold).
lex(transitive_verb, fin, pl, event, [hold], hold).
lex(transitive_verb, inf,  _, event, [hold], hold).

lex(transitive_verb, fin, sg, event, [hurts], hurt).
lex(transitive_verb, fin, pl, event, [hurt], hurt).
lex(transitive_verb, inf,  _, event, [hurt], hurt).

lex(transitive_verb, fin, sg, event, [identifies], identify).
lex(transitive_verb, fin, pl, event, [identify], identify).
lex(transitive_verb, inf,  _, event, [identify], identify).

lex(transitive_verb, fin, sg, event, [ignores], ignore).
lex(transitive_verb, fin, pl, event, [ignore], ignore).
lex(transitive_verb, inf,  _, event, [ignore], ignore).

lex(transitive_verb, fin, sg, event, [illustrates], illustrate).
lex(transitive_verb, fin, pl, event, [illustrate], illustrate).
lex(transitive_verb, inf,  _, event, [illustrate], illustrate).

lex(transitive_verb, fin, sg, event, [imagines], imagine).
lex(transitive_verb, fin, pl, event, [imagine], imagine).
lex(transitive_verb, inf,  _, event, [imagine], imagine).

lex(transitive_verb, fin, sg, event, [implements], implement).
lex(transitive_verb, fin, pl, event, [implement], implement).
lex(transitive_verb, inf,  _, event, [implement], implement).

lex(transitive_verb, fin, sg, event, [implies], imply).
lex(transitive_verb, fin, pl, event, [imply], imply).
lex(transitive_verb, inf,  _, event, [imply], imply).

lex(transitive_verb, fin, sg, event, [imposes], impose).
lex(transitive_verb, fin, pl, event, [impose], impose).
lex(transitive_verb, inf,  _, event, [impose], impose).

lex(transitive_verb, fin, sg, event, [improves], improve).
lex(transitive_verb, fin, pl, event, [improve], improve).
lex(transitive_verb, inf,  _, event, [improve], improve).

lex(transitive_verb, fin, sg, event, [includes], include).
lex(transitive_verb, fin, pl, event, [include], include).
lex(transitive_verb, inf,  _, event, [include], include).

lex(transitive_verb, fin, sg, event, [incorporates], incorporate).
lex(transitive_verb, fin, pl, event, [incorporate], incorporate).
lex(transitive_verb, inf,  _, event, [incorporate], incorporate).

lex(transitive_verb, fin, sg, event, [increases], increase).
lex(transitive_verb, fin, pl, event, [increase], increase).
lex(transitive_verb, inf,  _, event, [increase], increase).

lex(transitive_verb, fin, sg, event, [indicates], indicate).
lex(transitive_verb, fin, pl, event, [indicate], indicate).
lex(transitive_verb, inf,  _, event, [indicate], indicate).

lex(transitive_verb, fin, sg, event, [influences], influence).
lex(transitive_verb, fin, pl, event, [influence], influence).
lex(transitive_verb, inf,  _, event, [influence], influence).

lex(transitive_verb, fin, sg, event, [informs], inform).
lex(transitive_verb, fin, pl, event, [inform], inform).
lex(transitive_verb, inf,  _, event, [inform], inform).

lex(transitive_verb, fin, sg, event, [interprets], interpret).
lex(transitive_verb, fin, pl, event, [interpret], interpret).
lex(transitive_verb, inf,  _, event, [interpret], interpret).

lex(transitive_verb, fin, sg, event, [introduces], introduce).
lex(transitive_verb, fin, pl, event, [introduce], introduce).
lex(transitive_verb, inf,  _, event, [introduce], introduce).

lex(transitive_verb, fin, sg, event, [invests], invest).
lex(transitive_verb, fin, pl, event, [invest], invest).
lex(transitive_verb, inf,  _, event, [invest], invest).

lex(transitive_verb, fin, sg, event, [investigates], investigate).
lex(transitive_verb, fin, pl, event, [investigate], investigate).
lex(transitive_verb, inf,  _, event, [investigate], investigate).

lex(transitive_verb, fin, sg, event, [invites], invite).
lex(transitive_verb, fin, pl, event, [invite], invite).
lex(transitive_verb, inf,  _, event, [invite], invite).

lex(transitive_verb, fin, sg, event, [involves], involve).
lex(transitive_verb, fin, pl, event, [involve], involve).
lex(transitive_verb, inf,  _, event, [involve], involve).

lex(transitive_verb, fin, sg, event, [issues], issue).
lex(transitive_verb, fin, pl, event, [issue], issue).
lex(transitive_verb, inf,  _, event, [issue], issue).

lex(transitive_verb, fin, sg, event, [joins], join).
lex(transitive_verb, fin, pl, event, [join], join).
lex(transitive_verb, inf,  _, event, [join], join).

lex(transitive_verb, fin, sg, event, [judges], judge).
lex(transitive_verb, fin, pl, event, [judge], judge).
lex(transitive_verb, inf,  _, event, [judge], judge).

lex(transitive_verb, fin, sg, event, [jumps], jump).
lex(transitive_verb, fin, pl, event, [jump], jump).
lex(transitive_verb, inf,  _, event, [jump], jump).

lex(transitive_verb, fin, sg, event, [justifies], justify).
lex(transitive_verb, fin, pl, event, [justify], justify).
lex(transitive_verb, inf,  _, event, [justify], justify).

lex(transitive_verb, fin, sg, event, [keeps], keep).
lex(transitive_verb, fin, pl, event, [keep], keep).
lex(transitive_verb, inf,  _, event, [keep], keep).

lex(transitive_verb, fin, sg, event, [kills], kill).
lex(transitive_verb, fin, pl, event, [kill], kill).
lex(transitive_verb, inf,  _, event, [kill], kill).

lex(transitive_verb, fin, sg, event, [kisses], kiss).
lex(transitive_verb, fin, pl, event, [kiss], kiss).
lex(transitive_verb, inf,  _, event, [kiss], kiss).

lex(transitive_verb, fin, sg, event, [knows], know).
lex(transitive_verb, fin, pl, event, [know], know).
lex(transitive_verb, inf,  _, event, [know], know).

lex(transitive_verb, fin, sg, event, [lands], land).
lex(transitive_verb, fin, pl, event, [land], land).
lex(transitive_verb, inf,  _, event, [land], land).

lex(transitive_verb, fin, sg, event, [launches], launch).
lex(transitive_verb, fin, pl, event, [launch], launch).
lex(transitive_verb, inf,  _, event, [launch], launch).

lex(transitive_verb, fin, sg, event, [lays], lay).
lex(transitive_verb, fin, pl, event, [lay], lay).
lex(transitive_verb, inf,  _, event, [lay], lay).

lex(transitive_verb, fin, sg, event, [leads], lead).
lex(transitive_verb, fin, pl, event, [lead], lead).
lex(transitive_verb, inf,  _, event, [lead], lead).

lex(transitive_verb, fin, sg, event, [learns], learn).
lex(transitive_verb, fin, pl, event, [learn], learn).
lex(transitive_verb, inf,  _, event, [learn], learn).

lex(transitive_verb, fin, sg, event, [leaves], leave).
lex(transitive_verb, fin, pl, event, [leave], leave).
lex(transitive_verb, inf,  _, event, [leave], leave).

lex(transitive_verb, fin, sg, event, [lends], lend).
lex(transitive_verb, fin, pl, event, [lend], lend).
lex(transitive_verb, inf,  _, event, [lend], lend).

lex(transitive_verb, fin, sg, event, [lifts], lift).
lex(transitive_verb, fin, pl, event, [lift], lift).
lex(transitive_verb, inf,  _, event, [lift], lift).

lex(transitive_verb, fin, sg, event, [lights], light).
lex(transitive_verb, fin, pl, event, [light], light).
lex(transitive_verb, inf,  _, event, [light], light).

lex(transitive_verb, fin, sg, event, [likes], like).
lex(transitive_verb, fin, pl, event, [like], like).
lex(transitive_verb, inf,  _, event, [like], like).

lex(transitive_verb, fin, sg, event, [limits], limit).
lex(transitive_verb, fin, pl, event, [limit], limit).
lex(transitive_verb, inf,  _, event, [limit], limit).

lex(transitive_verb, fin, sg, event, [links], link).
lex(transitive_verb, fin, pl, event, [link], link).
lex(transitive_verb, inf,  _, event, [link], link).

lex(transitive_verb, fin, sg, event, [loses], lose).
lex(transitive_verb, fin, pl, event, [lose], lose).
lex(transitive_verb, inf,  _, event, [lose], lose).

lex(transitive_verb, fin, sg, event, [loves], love).
lex(transitive_verb, fin, pl, event, [love], love).
lex(transitive_verb, inf,  _, event, [love], love).

lex(transitive_verb, fin, sg, event, [maintains], maintain).
lex(transitive_verb, fin, pl, event, [maintain], maintain).
lex(transitive_verb, inf,  _, event, [maintain], maintain).

lex(transitive_verb, fin, sg, event, [makes], make).
lex(transitive_verb, fin, pl, event, [make], make).
lex(transitive_verb, inf,  _, event, [make], make).

lex(transitive_verb, fin, sg, event, [manages], manage).
lex(transitive_verb, fin, pl, event, [manage], manage).
lex(transitive_verb, inf,  _, event, [manage], manage).

lex(transitive_verb, fin, sg, event, [marks], mark).
lex(transitive_verb, fin, pl, event, [mark], mark).
lex(transitive_verb, inf,  _, event, [mark], mark).

lex(transitive_verb, fin, sg, event, [markets], market).
lex(transitive_verb, fin, pl, event, [market], market).
lex(transitive_verb, inf,  _, event, [market], market).

lex(transitive_verb, fin, sg, event, [marries], marry).
lex(transitive_verb, fin, pl, event, [marry], marry).
lex(transitive_verb, inf,  _, event, [marry], marry).

lex(transitive_verb, fin, sg, event, [matches], match).
lex(transitive_verb, fin, pl, event, [match], match).
lex(transitive_verb, inf,  _, event, [match], match).

lex(transitive_verb, fin, sg, event, [measures], measure).
lex(transitive_verb, fin, pl, event, [measure], measure).
lex(transitive_verb, inf,  _, event, [measure], measure).

lex(transitive_verb, fin, sg, event, [meets], meet).
lex(transitive_verb, fin, pl, event, [meet], meet).
lex(transitive_verb, inf,  _, event, [meet], meet).

lex(transitive_verb, fin, sg, event, [mentions], mention).
lex(transitive_verb, fin, pl, event, [mention], mention).
lex(transitive_verb, inf,  _, event, [mention], mention).

lex(transitive_verb, fin, sg, event, [misses], miss).
lex(transitive_verb, fin, pl, event, [miss], miss).
lex(transitive_verb, inf,  _, event, [miss], miss).

lex(transitive_verb, fin, sg, event, [monitors], monitor).
lex(transitive_verb, fin, pl, event, [monitor], monitor).
lex(transitive_verb, inf,  _, event, [monitor], monitor).

lex(transitive_verb, fin, sg, event, [moves], move).
lex(transitive_verb, fin, pl, event, [move], move).
lex(transitive_verb, inf,  _, event, [move], move).

lex(transitive_verb, fin, sg, event, [names], name).
lex(transitive_verb, fin, pl, event, [name], name).
lex(transitive_verb, inf,  _, event, [name], name).

lex(transitive_verb, fin, sg, event, [needs], need).
lex(transitive_verb, fin, pl, event, [need], need).
lex(transitive_verb, inf,  _, event, [need], need).

lex(transitive_verb, fin, sg, event, [negotiates], negotiate).
lex(transitive_verb, fin, pl, event, [negotiate], negotiate).
lex(transitive_verb, inf,  _, event, [negotiate], negotiate).

lex(transitive_verb, fin, sg, event, [notes], note).
lex(transitive_verb, fin, pl, event, [note], note).
lex(transitive_verb, inf,  _, event, [note], note).

lex(transitive_verb, fin, sg, event, [notices], notice).
lex(transitive_verb, fin, pl, event, [notice], notice).
lex(transitive_verb, inf,  _, event, [notice], notice).

lex(transitive_verb, fin, sg, event, [observes], observe).
lex(transitive_verb, fin, pl, event, [observe], observe).
lex(transitive_verb, inf,  _, event, [observe], observe).

lex(transitive_verb, fin, sg, event, [obtains], obtain).
lex(transitive_verb, fin, pl, event, [obtain], obtain).
lex(transitive_verb, inf,  _, event, [obtain], obtain).

lex(transitive_verb, fin, sg, event, [opens], open).
lex(transitive_verb, fin, pl, event, [open], open).
lex(transitive_verb, inf,  _, event, [open], open).

lex(transitive_verb, fin, sg, event, [operates], operate).
lex(transitive_verb, fin, pl, event, [operate], operate).
lex(transitive_verb, inf,  _, event, [operate], operate).

lex(transitive_verb, fin, sg, event, [orders], order).
lex(transitive_verb, fin, pl, event, [order], order).
lex(transitive_verb, inf,  _, event, [order], order).

lex(transitive_verb, fin, sg, event, [organises], organise).
lex(transitive_verb, fin, pl, event, [organise], organise).
lex(transitive_verb, inf,  _, event, [organise], organise).

lex(transitive_verb, fin, sg, event, [overcomes], overcome).
lex(transitive_verb, fin, pl, event, [overcome], overcome).
lex(transitive_verb, inf,  _, event, [overcome], overcome).

lex(transitive_verb, fin, sg, event, [owns], own).
lex(transitive_verb, fin, pl, event, [own], own).
lex(transitive_verb, inf,  _, event, [own], own).

lex(transitive_verb, fin, sg, event, [passes], pass).
lex(transitive_verb, fin, pl, event, [pass], pass).
lex(transitive_verb, inf,  _, event, [pass], pass).

lex(transitive_verb, fin, sg, event, [pays], pay).
lex(transitive_verb, fin, pl, event, [pay], pay).
lex(transitive_verb, inf,  _, event, [pay], pay).

lex(transitive_verb, fin, sg, event, [performs], perform).
lex(transitive_verb, fin, pl, event, [perform], perform).
lex(transitive_verb, inf,  _, event, [perform], perform).

lex(transitive_verb, fin, sg, event, [permits], permit).
lex(transitive_verb, fin, pl, event, [permit], permit).
lex(transitive_verb, inf,  _, event, [permit], permit).

lex(transitive_verb, fin, sg, event, [persuades], persuade).
lex(transitive_verb, fin, pl, event, [persuade], persuade).
lex(transitive_verb, inf,  _, event, [persuade], persuade).

lex(transitive_verb, fin, sg, event, [phones], phone).
lex(transitive_verb, fin, pl, event, [phone], phone).
lex(transitive_verb, inf,  _, event, [phone], phone).

lex(transitive_verb, fin, sg, event, [picks], pick).
lex(transitive_verb, fin, pl, event, [pick], pick).
lex(transitive_verb, inf,  _, event, [pick], pick).

lex(transitive_verb, fin, sg, event, [places], place).
lex(transitive_verb, fin, pl, event, [place], place).
lex(transitive_verb, inf,  _, event, [place], place).

lex(transitive_verb, fin, sg, event, [plans], plan).
lex(transitive_verb, fin, pl, event, [plan], plan).
lex(transitive_verb, inf,  _, event, [plan], plan).

lex(transitive_verb, fin, sg, event, [plays], play).
lex(transitive_verb, fin, pl, event, [play], play).
lex(transitive_verb, inf,  _, event, [play], play).

lex(transitive_verb, fin, sg, event, [pleases], please).
lex(transitive_verb, fin, pl, event, [please], please).
lex(transitive_verb, inf,  _, event, [please], please).

lex(transitive_verb, fin, sg, event, [possesses], possess).
lex(transitive_verb, fin, pl, event, [possess], possess).
lex(transitive_verb, inf,  _, event, [possess], possess).

lex(transitive_verb, fin, sg, event, [practises], practise).
lex(transitive_verb, fin, pl, event, [practise], practise).
lex(transitive_verb, inf,  _, event, [practise], practise).

lex(transitive_verb, fin, sg, event, [predicts], predict).
lex(transitive_verb, fin, pl, event, [predict], predict).
lex(transitive_verb, inf,  _, event, [predict], predict).

lex(transitive_verb, fin, sg, event, [prefers], prefer).
lex(transitive_verb, fin, pl, event, [prefer], prefer).
lex(transitive_verb, inf,  _, event, [prefer], prefer).

lex(transitive_verb, fin, sg, event, [prepares], prepre).
lex(transitive_verb, fin, pl, event, [prepare], prepare).
lex(transitive_verb, inf,  _, event, [prepare], prepare).

lex(transitive_verb, fin, sg, event, [presents], present).
lex(transitive_verb, fin, pl, event, [present], present).
lex(transitive_verb, inf,  _, event, [present], present).

lex(transitive_verb, fin, sg, event, [preserves], preserve).
lex(transitive_verb, fin, pl, event, [preserve], preserve).
lex(transitive_verb, inf,  _, event, [preserve], preserve).

lex(transitive_verb, fin, sg, event, [presses], press).
lex(transitive_verb, fin, pl, event, [press], press).
lex(transitive_verb, inf,  _, event, [press], press).

lex(transitive_verb, fin, sg, event, [prevents], prevent).
lex(transitive_verb, fin, pl, event, [prevent], prevent).
lex(transitive_verb, inf,  _, event, [prevent], prevent).

lex(transitive_verb, fin, sg, event, [produces], produce).
lex(transitive_verb, fin, pl, event, [produce], produce).
lex(transitive_verb, inf,  _, event, [produce], produce).

lex(transitive_verb, fin, sg, event, [promotes], promote).
lex(transitive_verb, fin, pl, event, [promote], promote).
lex(transitive_verb, inf,  _, event, [promote], promote).

lex(transitive_verb, fin, sg, event, [protects], protect).
lex(transitive_verb, fin, pl, event, [protect], protect).
lex(transitive_verb, inf,  _, event, [protect], protect).

lex(transitive_verb, fin, sg, event, [proves], prove).
lex(transitive_verb, fin, pl, event, [prove], prove).
lex(transitive_verb, inf,  _, event, [prove], prove).

lex(transitive_verb, fin, sg, event, [provides], provide).
lex(transitive_verb, fin, pl, event, [provide], provide).
lex(transitive_verb, inf,  _, event, [provide], provide).

lex(transitive_verb, fin, sg, event, [publishes], publish).
lex(transitive_verb, fin, pl, event, [publish], publish).
lex(transitive_verb, inf,  _, event, [publish], publish).

lex(transitive_verb, fin, sg, event, [pulls], pull).
lex(transitive_verb, fin, pl, event, [pull], pull).
lex(transitive_verb, inf,  _, event, [pull], pull).

lex(transitive_verb, fin, sg, event, [purchases], purchase).
lex(transitive_verb, fin, pl, event, [purchase], purchase).
lex(transitive_verb, inf,  _, event, [purchase], purchase).

lex(transitive_verb, fin, sg, event, [pursues], pursue).
lex(transitive_verb, fin, pl, event, [pursue], pursue).
lex(transitive_verb, inf,  _, event, [pursue], pursue).

lex(transitive_verb, fin, sg, event, [pushes], push).
lex(transitive_verb, fin, pl, event, [push], push).
lex(transitive_verb, inf,  _, event, [push], push).

lex(transitive_verb, fin, sg, event, [questions], question).
lex(transitive_verb, fin, pl, event, [question], question).
lex(transitive_verb, inf,  _, event, [question], question).

lex(transitive_verb, fin, sg, event, [raises], raise).
lex(transitive_verb, fin, pl, event, [raise], raise).
lex(transitive_verb, inf,  _, event, [raise], raise).

lex(transitive_verb, fin, sg, event, [reaches], reach).
lex(transitive_verb, fin, pl, event, [reach], reach).
lex(transitive_verb, inf,  _, event, [reach], reach).

lex(transitive_verb, fin, sg, event, [reads], read).
lex(transitive_verb, fin, pl, event, [read], read).
lex(transitive_verb, inf,  _, event, [read], read).

lex(transitive_verb, fin, sg, event, [realises], realise).
lex(transitive_verb, fin, pl, event, [realise], realise).
lex(transitive_verb, inf,  _, event, [realise], realise).

lex(transitive_verb, fin, sg, event, [recalls], recall).
lex(transitive_verb, fin, pl, event, [recall], recall).
lex(transitive_verb, inf,  _, event, [recall], recall).

lex(transitive_verb, fin, sg, event, [receives], receive).
lex(transitive_verb, fin, pl, event, [receive], receive).
lex(transitive_verb, inf,  _, event, [receive], receive).

lex(transitive_verb, fin, sg, event, [recognises], recognise).
lex(transitive_verb, fin, pl, event, [recognise], recognise).
lex(transitive_verb, inf,  _, event, [recognise], recognise).

lex(transitive_verb, fin, sg, event, [recommends], recommend).
lex(transitive_verb, fin, pl, event, [recommend], recommend).
lex(transitive_verb, inf,  _, event, [recommend], recommend).

lex(transitive_verb, fin, sg, event, [records], record).
lex(transitive_verb, fin, pl, event, [record], record).
lex(transitive_verb, inf,  _, event, [record], record).

lex(transitive_verb, fin, sg, event, [recovers], recover).
lex(transitive_verb, fin, pl, event, [recover], recover).
lex(transitive_verb, inf,  _, event, [recover], recover).

lex(transitive_verb, fin, sg, event, [reduces], reduce).
lex(transitive_verb, fin, pl, event, [reduce], reduce).
lex(transitive_verb, inf,  _, event, [reduce], reduce).

lex(transitive_verb, fin, sg, event, [reflects], reflect).
lex(transitive_verb, fin, pl, event, [reflect], reflect).
lex(transitive_verb, inf,  _, event, [reflect], reflect).

lex(transitive_verb, fin, sg, event, [refuses], refuse).
lex(transitive_verb, fin, pl, event, [refuse], refuse).
lex(transitive_verb, inf,  _, event, [refuse], refuse).

lex(transitive_verb, fin, sg, event, [registers], register).
lex(transitive_verb, fin, pl, event, [register], register).
lex(transitive_verb, inf,  _, event, [register], register).

lex(transitive_verb, fin, sg, event, [rejects], reject).
lex(transitive_verb, fin, pl, event, [reject], reject).
lex(transitive_verb, inf,  _, event, [reject], reject).

lex(transitive_verb, fin, sg, event, [relates], relate).
lex(transitive_verb, fin, pl, event, [relate], relate).
lex(transitive_verb, inf,  _, event, [relate], relate).

lex(transitive_verb, fin, sg, event, [releases], release).
lex(transitive_verb, fin, pl, event, [release], release).
lex(transitive_verb, inf,  _, event, [release], release).

lex(transitive_verb, fin, sg, event, [remembers], remember).
lex(transitive_verb, fin, pl, event, [remember], remember).
lex(transitive_verb, inf,  _, event, [remember], remember).

lex(transitive_verb, fin, sg, event, [reminds], remind).
lex(transitive_verb, fin, pl, event, [remind], remind).
lex(transitive_verb, inf,  _, event, [remind], remind).

lex(transitive_verb, fin, sg, event, [removes], remove).
lex(transitive_verb, fin, pl, event, [remove], remove).
lex(transitive_verb, inf,  _, event, [remove], remove).

lex(transitive_verb, fin, sg, event, [repeats], repeat).
lex(transitive_verb, fin, pl, event, [repeat], repeat).
lex(transitive_verb, inf,  _, event, [repeat], repeat).

lex(transitive_verb, fin, sg, event, [replaces], replace).
lex(transitive_verb, fin, pl, event, [replace], replace).
lex(transitive_verb, inf,  _, event, [replace], replace).

lex(transitive_verb, fin, sg, event, [reports], report).
lex(transitive_verb, fin, pl, event, [report], report).
lex(transitive_verb, inf,  _, event, [report], report).

lex(transitive_verb, fin, sg, event, [represents], represent).
lex(transitive_verb, fin, pl, event, [represent], represent).
lex(transitive_verb, inf,  _, event, [represent], represent).

lex(transitive_verb, fin, sg, event, [requires], require).
lex(transitive_verb, fin, pl, event, [require], require).
lex(transitive_verb, inf,  _, event, [require], require).

lex(transitive_verb, fin, sg, event, [resists], resist).
lex(transitive_verb, fin, pl, event, [resist], resist).
lex(transitive_verb, inf,  _, event, [resist], resist).

lex(transitive_verb, fin, sg, event, [resolves], resolve).
lex(transitive_verb, fin, pl, event, [resolve], resolve).
lex(transitive_verb, inf,  _, event, [resolve], resolve).

lex(transitive_verb, fin, sg, event, [restores], restore).
lex(transitive_verb, fin, pl, event, [restore], restore).
lex(transitive_verb, inf,  _, event, [restore], restore).

lex(transitive_verb, fin, sg, event, [restricts], restrict).
lex(transitive_verb, fin, pl, event, [restrict], restrict).
lex(transitive_verb, inf,  _, event, [restrict], restrict).

lex(transitive_verb, fin, sg, event, [retains], retain).
lex(transitive_verb, fin, pl, event, [retain], retain).
lex(transitive_verb, inf,  _, event, [retain], retain).

lex(transitive_verb, fin, sg, event, [reveals], reveal).
lex(transitive_verb, fin, pl, event, [reveal], reveal).
lex(transitive_verb, inf,  _, event, [reveal], reveal).

lex(transitive_verb, fin, sg, event, [reviews], review).
lex(transitive_verb, fin, pl, event, [revie], review).
lex(transitive_verb, inf,  _, event, [review], review).

lex(transitive_verb, fin, sg, event, [rides], ride).
lex(transitive_verb, fin, pl, event, [ride], ride).
lex(transitive_verb, inf,  _, event, [ride], ride).

lex(transitive_verb, fin, sg, event, [rings], ring).
lex(transitive_verb, fin, pl, event, [ring], ring).
lex(transitive_verb, inf,  _, event, [ring], ring).

lex(transitive_verb, fin, sg, event, [risks], risk).
lex(transitive_verb, fin, pl, event, [risk], risk).
lex(transitive_verb, inf,  _, event, [risk], risk).

lex(transitive_verb, fin, sg, event, [rules], rule).
lex(transitive_verb, fin, pl, event, [rule], rule).
lex(transitive_verb, inf,  _, event, [rule], rule).

lex(transitive_verb, fin, sg, event, [runs], run).
lex(transitive_verb, fin, pl, event, [run], run).
lex(transitive_verb, inf,  _, event, [run], run).

lex(transitive_verb, fin, sg, event, [satisfies], satisfy).
lex(transitive_verb, fin, pl, event, [satisfy], satisfy).
lex(transitive_verb, inf,  _, event, [satisfy], satisfy).

lex(transitive_verb, fin, sg, event, [saves], save).
lex(transitive_verb, fin, pl, event, [save], save).
lex(transitive_verb, inf,  _, event, [save], save).

lex(transitive_verb, fin, sg, event, [says], say).
lex(transitive_verb, fin, pl, event, [say], say).
lex(transitive_verb, inf,  _, event, [say], say).

lex(transitive_verb, fin, sg, event, [scores], score).
lex(transitive_verb, fin, pl, event, [score], score).
lex(transitive_verb, inf,  _, event, [score], score).

lex(transitive_verb, fin, sg, event, [searches], search).
lex(transitive_verb, fin, pl, event, [search], search).
lex(transitive_verb, inf,  _, event, [search], search).

lex(transitive_verb, fin, sg, event, [secures], secure).
lex(transitive_verb, fin, pl, event, [secure], secure).
lex(transitive_verb, inf,  _, event, [secure], secure).

lex(transitive_verb, fin, sg, event, [sees], see).
lex(transitive_verb, fin, pl, event, [see], see).
lex(transitive_verb, inf,  _, event, [see], see).

lex(transitive_verb, fin, sg, event, [seeks], seek).
lex(transitive_verb, fin, pl, event, [seek], seek).
lex(transitive_verb, inf,  _, event, [seek], seek).

lex(transitive_verb, fin, sg, event, [selects], select).
lex(transitive_verb, fin, pl, event, [select], select).
lex(transitive_verb, inf,  _, event, [select], select).

lex(transitive_verb, fin, sg, event, [sells], sell).
lex(transitive_verb, fin, pl, event, [sell], sell).
lex(transitive_verb, inf,  _, event, [sell], sell).

lex(transitive_verb, fin, sg, event, [sends], send).
lex(transitive_verb, fin, pl, event, [send], send).
lex(transitive_verb, inf,  _, event, [send], send).

lex(transitive_verb, fin, sg, event, [separates], separate).
lex(transitive_verb, fin, pl, event, [separate], separate).
lex(transitive_verb, inf,  _, event, [separate], separate).

lex(transitive_verb, fin, sg, event, [serves], serve).
lex(transitive_verb, fin, pl, event, [serve], serve).
lex(transitive_verb, inf,  _, event, [serve], serve).

lex(transitive_verb, fin, sg, event, [sets], set).
lex(transitive_verb, fin, pl, event, [set], set).
lex(transitive_verb, inf,  _, event, [set], set).

lex(transitive_verb, fin, sg, event, [settles], settle).
lex(transitive_verb, fin, pl, event, [settle], settle).
lex(transitive_verb, inf,  _, event, [settle], settle).

lex(transitive_verb, fin, sg, event, [shakes], shake).
lex(transitive_verb, fin, pl, event, [shake], shake).
lex(transitive_verb, inf,  _, event, [shake], shake).

lex(transitive_verb, fin, sg, event, [shares], share).
lex(transitive_verb, fin, pl, event, [share], share).
lex(transitive_verb, inf,  _, event, [share], share).

lex(transitive_verb, fin, sg, event, [shifts], shift).
lex(transitive_verb, fin, pl, event, [shift], shift).
lex(transitive_verb, inf,  _, event, [shift], shift).

lex(transitive_verb, fin, sg, event, [shoots], shoot).
lex(transitive_verb, fin, pl, event, [shoot], shoot).
lex(transitive_verb, inf,  _, event, [shoot], shoot).

lex(transitive_verb, fin, sg, event, [shows], show).
lex(transitive_verb, fin, pl, event, [show], show).
lex(transitive_verb, inf,  _, event, [show], show).

lex(transitive_verb, fin, sg, event, [shuts], shut).
lex(transitive_verb, fin, pl, event, [shut], shut).
lex(transitive_verb, inf,  _, event, [shut], shut).

lex(transitive_verb, fin, sg, event, [signs], sign).
lex(transitive_verb, fin, pl, event, [sign], sign).
lex(transitive_verb, inf,  _, event, [sign], sign).

lex(transitive_verb, fin, sg, event, [sings], sing).
lex(transitive_verb, fin, pl, event, [sing], sing).
lex(transitive_verb, inf,  _, event, [sing], sing).

lex(transitive_verb, fin, sg, event, [smells], smell).
lex(transitive_verb, fin, pl, event, [smell], smell).
lex(transitive_verb, inf,  _, event, [smell], smell).

lex(transitive_verb, fin, sg, event, [solves], solve).
lex(transitive_verb, fin, pl, event, [solve], solve).
lex(transitive_verb, inf,  _, event, [solve], solve).

lex(transitive_verb, fin, sg, event, [sorts], sort).
lex(transitive_verb, fin, pl, event, [sort], sort).
lex(transitive_verb, inf,  _, event, [sort], sort).

lex(transitive_verb, fin, sg, event, [sounds], sound).
lex(transitive_verb, fin, pl, event, [sound], sound).
lex(transitive_verb, inf,  _, event, [sound], sound).

lex(transitive_verb, fin, sg, event, [spares], spare).
lex(transitive_verb, fin, pl, event, [spare], spare).
lex(transitive_verb, inf,  _, event, [spare], spare).

lex(transitive_verb, fin, sg, event, [specifies], specify).
lex(transitive_verb, fin, pl, event, [specify], specify).
lex(transitive_verb, inf,  _, event, [specify], specify).

lex(transitive_verb, fin, sg, event, [spends], spend).
lex(transitive_verb, fin, pl, event, [spend], spend).
lex(transitive_verb, inf,  _, event, [spend], spend).

lex(transitive_verb, fin, sg, event, [spreads], spread).
lex(transitive_verb, fin, pl, event, [spread], spread).
lex(transitive_verb, inf,  _, event, [spread], spread).

lex(transitive_verb, fin, sg, event, [starts], start).
lex(transitive_verb, fin, pl, event, [start], start).
lex(transitive_verb, inf,  _, event, [start], start).

lex(transitive_verb, fin, sg, event, [states], state).
lex(transitive_verb, fin, pl, event, [state], state).
lex(transitive_verb, inf,  _, event, [state], state).

lex(transitive_verb, fin, sg, event, [stimulates], stimulate).
lex(transitive_verb, fin, pl, event, [stimulate], stimulate).
lex(transitive_verb, inf,  _, event, [stimulate], stimulate).

lex(transitive_verb, fin, sg, event, [stops], stop).
lex(transitive_verb, fin, pl, event, [stop], stop).
lex(transitive_verb, inf,  _, event, [stop], stop).

lex(transitive_verb, fin, sg, event, [strengthens], strengthen).
lex(transitive_verb, fin, pl, event, [strengthen], strengthen).
lex(transitive_verb, inf,  _, event, [strengthen], strengthen).

lex(transitive_verb, fin, sg, event, [strikes], strike).
lex(transitive_verb, fin, pl, event, [strike], strike).
lex(transitive_verb, inf,  _, event, [strike], strike).

lex(transitive_verb, fin, sg, event, [studies], study).
lex(transitive_verb, fin, pl, event, [study], study).
lex(transitive_verb, inf,  _, event, [study], study).

lex(transitive_verb, fin, sg, event, [submits], submit).
lex(transitive_verb, fin, pl, event, [submit], submit).
lex(transitive_verb, inf,  _, event, [submit], submit).

lex(transitive_verb, fin, sg, event, [sues], sue).
lex(transitive_verb, fin, pl, event, [sue], sue).
lex(transitive_verb, inf,  _, event, [sue], sue).

lex(transitive_verb, fin, sg, event, [suggests], suggest).
lex(transitive_verb, fin, pl, event, [suggest], suggest).
lex(transitive_verb, inf,  _, event, [suggest], suggest).

lex(transitive_verb, fin, sg, event, [suits], suit).
lex(transitive_verb, fin, pl, event, [suit], suit).
lex(transitive_verb, inf,  _, event, [suit], suit).

lex(transitive_verb, fin, sg, event, [supplies], supply).
lex(transitive_verb, fin, pl, event, [supply], supply).
lex(transitive_verb, inf,  _, event, [supply], supply).

lex(transitive_verb, fin, sg, event, [supports], support).
lex(transitive_verb, fin, pl, event, [support], support).
lex(transitive_verb, inf,  _, event, [support], support).

lex(transitive_verb, fin, sg, event, [survives], survive).
lex(transitive_verb, fin, pl, event, [survive], survive).
lex(transitive_verb, inf,  _, event, [survive], survive).

lex(transitive_verb, fin, sg, event, [sustains], sustain).
lex(transitive_verb, fin, pl, event, [sustain], sustain).
lex(transitive_verb, inf,  _, event, [sustain], sustain).

lex(transitive_verb, fin, sg, event, [switches], switch).
lex(transitive_verb, fin, pl, event, [switch], switch).
lex(transitive_verb, inf,  _, event, [switch], switch).

lex(transitive_verb, fin, sg, event, [tackles], tackle).
lex(transitive_verb, fin, pl, event, [tackle], tackle).
lex(transitive_verb, inf,  _, event, [tackle], tackle).

lex(transitive_verb, fin, sg, event, [takes], take).
lex(transitive_verb, fin, pl, event, [take], take).
lex(transitive_verb, inf,  _, event, [take], take).

lex(transitive_verb, fin, sg, event, [teaches], teach).
lex(transitive_verb, fin, pl, event, [teach], teach).
lex(transitive_verb, inf,  _, event, [teach], teach).

lex(transitive_verb, fin, sg, event, [tests], test).
lex(transitive_verb, fin, pl, event, [test], test).
lex(transitive_verb, inf,  _, event, [test], test).

lex(transitive_verb, fin, sg, event, [thanks], thank).
lex(transitive_verb, fin, pl, event, [thank], thank).
lex(transitive_verb, inf,  _, event, [thank], thank).

lex(transitive_verb, fin, sg, event, [throws], throw).
lex(transitive_verb, fin, pl, event, [throw], throw).
lex(transitive_verb, inf,  _, event, [throw], throw).

lex(transitive_verb, fin, sg, event, [touches], touch).
lex(transitive_verb, fin, pl, event, [touch], touch).
lex(transitive_verb, inf,  _, event, [touch], touch).

lex(transitive_verb, fin, sg, event, [trains], train).
lex(transitive_verb, fin, pl, event, [train], train).
lex(transitive_verb, inf,  _, event, [train], train).

lex(transitive_verb, fin, sg, event, [transfers], transfer).
lex(transitive_verb, fin, pl, event, [transfer], transfer).
lex(transitive_verb, inf,  _, event, [transfer], transfer).

lex(transitive_verb, fin, sg, event, [travels], travel).
lex(transitive_verb, fin, pl, event, [trave], travel).
lex(transitive_verb, inf,  _, event, [travel], travel).

lex(transitive_verb, fin, sg, event, [treats], treat).
lex(transitive_verb, fin, pl, event, [treat], treat).
lex(transitive_verb, inf,  _, event, [treat], treat).

lex(transitive_verb, fin, sg, event, [trusts], trust).
lex(transitive_verb, fin, pl, event, [trust], trust).
lex(transitive_verb, inf,  _, event, [trust], trust).

lex(transitive_verb, fin, sg, event, [tries], try).
lex(transitive_verb, fin, pl, event, [try], try).
lex(transitive_verb, inf,  _, event, [try], try).

lex(transitive_verb, fin, sg, event, [turns], turn).
lex(transitive_verb, fin, pl, event, [turn], turn).
lex(transitive_verb, inf,  _, event, [turn], turn).

lex(transitive_verb, fin, sg, event, [understands], understand).
lex(transitive_verb, fin, pl, event, [understand], understand).
lex(transitive_verb, inf,  _, event, [understand], understand).

lex(transitive_verb, fin, sg, event, [undertakes], undertake).
lex(transitive_verb, fin, pl, event, [undertake], undertake).
lex(transitive_verb, inf,  _, event, [undertake], undertake).

lex(transitive_verb, fin, sg, event, [uses], use).
lex(transitive_verb, fin, pl, event, [use], use).
lex(transitive_verb, inf,  _, event, [use], use).

lex(transitive_verb, fin, sg, event, [varies], vary).
lex(transitive_verb, fin, pl, event, [vary], vary).
lex(transitive_verb, inf,  _, event, [vary], vary).

lex(transitive_verb, fin, sg, event, [views], view).
lex(transitive_verb, fin, pl, event, [view], view).
lex(transitive_verb, inf,  _, event, [view], view).

lex(transitive_verb, fin, sg, event, [visits], visit).
lex(transitive_verb, fin, pl, event, [visit], visit).
lex(transitive_verb, inf,  _, event, [visit], visit).

lex(transitive_verb, fin, sg, event, [wakes], wake).
lex(transitive_verb, fin, pl, event, [wake], wake).
lex(transitive_verb, inf,  _, event, [wake], wake).

lex(transitive_verb, fin, sg, event, [wants], want).
lex(transitive_verb, fin, pl, event, [want], want).
lex(transitive_verb, inf,  _, event, [want], want).

lex(transitive_verb, fin, sg, event, [warns], warn).
lex(transitive_verb, fin, pl, event, [warn], warn).
lex(transitive_verb, inf,  _, event, [warn], warn).

lex(transitive_verb, fin, sg, event, [washes], wash).
lex(transitive_verb, fin, pl, event, [wash], wash).
lex(transitive_verb, inf,  _, event, [wash], wash).

lex(transitive_verb, fin, sg, event, [wastes], waste).
lex(transitive_verb, fin, pl, event, [waste], waste).
lex(transitive_verb, inf,  _, event, [waste], waste).

lex(transitive_verb, fin, sg, event, [watches], watch).
lex(transitive_verb, fin, pl, event, [watch], watch).
lex(transitive_verb, inf,  _, event, [watch], watch).

lex(transitive_verb, fin, sg, event, [wears], wear).
lex(transitive_verb, fin, pl, event, [wear], wear).
lex(transitive_verb, inf,  _, event, [wear], wear).

lex(transitive_verb, fin, sg, event, [wins], win).
lex(transitive_verb, fin, pl, event, [win], win).
lex(transitive_verb, inf,  _, event, [win], win).

lex(transitive_verb, fin, sg, event, [withdraws], withdraw).
lex(transitive_verb, fin, pl, event, [withdraw], withdraw).
lex(transitive_verb, inf,  _, event, [withdraw], withdraw).

lex(transitive_verb, fin, sg, event, [writes], write).
lex(transitive_verb, fin, pl, event, [write], write).
lex(transitive_verb, inf,  _, event, [write], write).

lex(transitive_verb, fin, sg, event, [subtracts], subtract).
lex(transitive_verb, fin, pl, event, [subtract], subtract).
lex(transitive_verb, inf,  _, event, [subtract], subtract).

lex(transitive_verb, fin, sg, event, [absorbs], absorb).
lex(transitive_verb, fin, pl, event, [absorb], absorb).
lex(transitive_verb, inf,  _, event, [absorb], absorb).

lex(transitive_verb, fin, sg, event, [aligns], align).
lex(transitive_verb, fin, pl, event, [align], align).
lex(transitive_verb, inf,  _, event, [align], align).

lex(transitive_verb, fin, sg, event, [assembles], assemble).
lex(transitive_verb, fin, pl, event, [assemble], assemble).
lex(transitive_verb, inf,  _, event, [assemble], assemble).

lex(transitive_verb, fin, sg, event, [calculates], calculate).
lex(transitive_verb, fin, pl, event, [calculate], calculate).
lex(transitive_verb, inf,  _, event, [calculate], calculate).

lex(transitive_verb, fin, sg, event, [attaches], attach).
lex(transitive_verb, fin, pl, event, [attach], attach).
lex(transitive_verb, inf,  _, event, [attach], attach).

lex(transitive_verb, fin, sg, event, [bends], bend).
lex(transitive_verb, fin, pl, event, [bend], bend).
lex(transitive_verb, inf,  _, event, [bend], bend).

lex(transitive_verb, fin, sg, event, [bleeds], bleed).
lex(transitive_verb, fin, pl, event, [bleed], bleed).
lex(transitive_verb, inf,  _, event, [bleed], bleed).

lex(transitive_verb, fin, sg, event, [calibrates], calibrate).
lex(transitive_verb, fin, pl, event, [calibrate], calibrate).
lex(transitive_verb, inf,  _, event, [calibrate], calibrate).

lex(transitive_verb, fin, sg, event, [cancels], cancel).
lex(transitive_verb, fin, pl, event, [cancel], cancel).
lex(transitive_verb, inf,  _, event, [cancel], cancel).

lex(transitive_verb, fin, sg, state, [compresses], compress).
lex(transitive_verb, fin, pl, state, [compress], compress).
lex(transitive_verb, inf,  _, state, [compress], compress).

lex(transitive_verb, fin, sg, event, [connects], connect).
lex(transitive_verb, fin, pl, event, [connect], connect).
lex(transitive_verb, inf, sg, event, [connect], connect).

lex(transitive_verb, fin, sg, event, [deflates], deflate).
lex(transitive_verb, fin, pl, event, [deflate], deflate).
lex(transitive_verb, inf,  _, event, [deflate], deflate).

lex(transitive_verb, fin, sg, event, [defuels], defuel).
lex(transitive_verb, fin, pl, event, [defuel], defuel).
lex(transitive_verb, inf,  _, event, [defuel], defuel).

lex(transitive_verb, fin, sg, event, [deploys], deploy).
lex(transitive_verb, fin, pl, event, [deploy], deploy).
lex(transitive_verb, inf,  _, event, [deploy], deploy).

lex(transitive_verb, fin, sg, event, [digitises], digitise).
lex(transitive_verb, fin, pl, event, [digitise], digitise).
lex(transitive_verb, inf,  _, event, [digitise], digitise).

lex(transitive_verb, fin, sg, event, [disarms], disarm).
lex(transitive_verb, fin, pl, event, [disarm], disarm).
lex(transitive_verb, inf,  _, event, [disarm], disarm).

lex(transitive_verb, fin, sg, event, [disassembles], disassemble).
lex(transitive_verb, fin, pl, event, [disassemble], disassemble).
lex(transitive_verb, inf,  _, event, [disassemble], disassemble).

lex(transitive_verb, fin, sg, event, [discards], discard).
lex(transitive_verb, fin, pl, event, [discard], discard).
lex(transitive_verb, inf,  _, event, [discard], discard).

lex(transitive_verb, fin, sg, event, [disconnects], disconnect).
lex(transitive_verb, fin, pl, event, [disconnect], disconnect).
lex(transitive_verb, inf,  _, event, [disconnect], disconnect).

lex(transitive_verb, fin, sg, event, [disengages], disengage).
lex(transitive_verb, fin, pl, event, [disengage], disengage).
lex(transitive_verb, inf,  _, event, [disengage], disengage).

lex(transitive_verb, fin, sg, event, [divides], divide).
lex(transitive_verb, fin, pl, event, [divide], divide).
lex(transitive_verb, inf,  _, event, [divide], divide).

lex(transitive_verb, fin, sg, event, [ejects], eject).
lex(transitive_verb, fin, pl, event, [eject], eject).
lex(transitive_verb, inf,  _, event, [eject], eject).

lex(transitive_verb, fin, sg, event, [energizes], energize).
lex(transitive_verb, fin, pl, event, [energize], energize).
lex(transitive_verb, inf,  _, event, [energize], energize).

lex(transitive_verb, fin, sg, event, [erases], erase).
lex(transitive_verb, fin, pl, event, [erase], erase).
lex(transitive_verb, inf,  _, event, [erase], erase).

lex(transitive_verb, fin, sg, event, [extinguishes], extinguish).
lex(transitive_verb, fin, pl, event, [extinguish], extinguish).
lex(transitive_verb, inf,  _, event, [extinguish], extinguish).

lex(transitive_verb, fin, sg, event, [folds], fold).
lex(transitive_verb, fin, pl, event, [fold], fold).
lex(transitive_verb, inf,  _, event, [fold], fold).

lex(transitive_verb, fin, sg, event, [illuminates], illuminate).
lex(transitive_verb, fin, pl, event, [illuminate], illuminate).
lex(transitive_verb, inf,  _, event, [illuminate], illuminate).

lex(transitive_verb, fin, sg, event, [inflates], inflate).
lex(transitive_verb, fin, pl, event, [inflate], inflate).
lex(transitive_verb, inf,  _, event, [inflate], inflate).

lex(transitive_verb, fin, sg, event, [installs], install).
lex(transitive_verb, fin, pl, event, [install], install).
lex(transitive_verb, inf,  _, event, [install], install).

lex(transitive_verb, fin, sg, event, [isolates], isolate).
lex(transitive_verb, fin, pl, event, [isolate], isolate).
lex(transitive_verb, inf,  _, event, [isolate], isolate).

lex(transitive_verb, fin, sg, event, [loosens], loosen).
lex(transitive_verb, fin, pl, event, [loosen], loosen).
lex(transitive_verb, inf,  _, event, [loosen], loosen).

lex(transitive_verb, fin, sg, event, [lubricates], lubricate).
lex(transitive_verb, fin, pl, event, [lubricate], lubricate).
lex(transitive_verb, inf,  _, event, [lubricate], lubricate).

lex(transitive_verb, fin, sg, event, [mixes], mix).
lex(transitive_verb, fin, pl, event, [mix], mix).
lex(transitive_verb, inf,  _, event, [mix], mix).

lex(transitive_verb, fin, sg, event, [moors], moor).
lex(transitive_verb, fin, pl, event, [moor], moor).
lex(transitive_verb, inf,  _, event, [moor], moor).

lex(transitive_verb, fin, sg, event, [multiplys], multiply).
lex(transitive_verb, fin, pl, event, [multiply], multiply).
lex(transitive_verb, inf,  _, event, [multiply], multiply).

lex(transitive_verb, fin, sg, event, [obeys], obey).
lex(transitive_verb, fin, pl, event, [obey], obey).
lex(transitive_verb, inf,  _, event, [obey], obey).

lex(transitive_verb, fin, sg, event, [overhauls], overhaul).
lex(transitive_verb, fin, pl, event, [overhaul], overhaul).
lex(transitive_verb, inf,  _, event, [overhaul], overhaul).

lex(transitive_verb, fin, sg, event, [overlaps], overlap).
lex(transitive_verb, fin, pl, event, [overlap], overlap).
lex(transitive_verb, inf,  _, event, [overlap], overlap).

lex(transitive_verb, fin, sg, event, [overrides], override).
lex(transitive_verb, fin, pl, event, [override], override).
lex(transitive_verb, inf,  _, event, [override], override).

lex(transitive_verb, fin, sg, event, [polishes], polish).
lex(transitive_verb, fin, pl, event, [polish], polish).
lex(transitive_verb, inf,  _, event, [polish], polish).

lex(transitive_verb, fin, sg, event, [pressurises], pressurise).
lex(transitive_verb, fin, pl, event, [pressurise], pressurise).
lex(transitive_verb, inf,  _, event, [pressurise], pressurise).

lex(transitive_verb, fin, sg, event, [refuels], refuel).
lex(transitive_verb, fin, pl, event, [refuel], refuel).
lex(transitive_verb, inf,  _, event, [refuel], refuel).

lex(transitive_verb, fin, sg, event, [retracts], retract).
lex(transitive_verb, fin, pl, event, [retract], retract).
lex(transitive_verb, inf,  _, event, [retract], retract).

lex(transitive_verb, fin, sg, event, [simulates], simulate).
lex(transitive_verb, fin, pl, event, [simulate], simulate).
lex(transitive_verb, inf,  _, event, [simulate], simulate).

lex(transitive_verb, fin, sg, event, [soaks], soak).
lex(transitive_verb, fin, pl, event, [soak], soak).
lex(transitive_verb, inf,  _, event, [soak], soak).

lex(transitive_verb, fin, sg, event, [spills], spill).
lex(transitive_verb, fin, pl, event, [spill], spill).
lex(transitive_verb, inf,  _, event, [spill], spill).

lex(transitive_verb, fin, sg, event, [stows], stow).
lex(transitive_verb, fin, pl, event, [stow], stow).
lex(transitive_verb, inf,  _, event, [stow], stow).

lex(transitive_verb, fin, sg, event, [strips], strip).
lex(transitive_verb, fin, pl, event, [strip], strip).
lex(transitive_verb, inf,  _, event, [strip], strip).

lex(transitive_verb, fin, sg, event, [subtracts], subtract).
lex(transitive_verb, fin, pl, event, [subtract], subtract).
lex(transitive_verb, inf,  _, event, [subtract], subtract).

lex(transitive_verb, fin, sg, event, [tightens], tighten).
lex(transitive_verb, fin, pl, event, [tighten], tighten).
lex(transitive_verb, inf,  _, event, [tighten], tighten).

lex(transitive_verb, fin, sg, event, [tilts], tilt).
lex(transitive_verb, fin, pl, event, [tilt], tilt).
lex(transitive_verb, inf,  _, event, [tilt], tilt).

lex(transitive_verb, fin, sg, event, [tows], tow).
lex(transitive_verb, fin, pl, event, [tow], tow).
lex(transitive_verb, inf,  _, event, [tow], tow).

lex(transitive_verb, fin, sg, event, [transmits], transmit).
lex(transitive_verb, fin, pl, event, [transmit], transmit).
lex(transitive_verb, inf,  _, event, [transmit], transmit).

lex(transitive_verb, fin, sg, event, [twists], twist).
lex(transitive_verb, fin, pl, event, [twist], twist).
lex(transitive_verb, inf,  _, event, [twist], twist).

lex(transitive_verb, fin, sg, event, [unfolds], unfold).
lex(transitive_verb, fin, pl, event, [unfold], unfold).
lex(transitive_verb, inf,  _, event, [unfold], unfold).

lex(transitive_verb, fin, sg, event, [unlocks], unlock).
lex(transitive_verb, fin, pl, event, [unlock], unlock).
lex(transitive_verb, inf,  _, event, [unlock], unlock).

lex(transitive_verb, fin, sg, event, [unwinds], unwind).
lex(transitive_verb, fin, pl, event, [unwind], unwind).
lex(transitive_verb, inf, _, event, [unwind], unwind).

lex(transitive_verb, fin, sg, event, [weighs], weigh).
lex(transitive_verb, fin, pl, event, [weigh], weigh).
lex(transitive_verb, inf,  _, event, [weigh], weigh).


% ------------------------------------------------------------------------
% Frequency list: adjectives
% ------------------------------------------------------------------------

lexicon([cat:adjective, wfm:WF, evtl:E, con:property(E, Sym)]) :-
   lex(adjective, WF, Sym).

lex(adjective, [fat], fat).
lex(adjective, [industrious], industrious).
lex(adjective, [nasty], nasty).
lex(adjective, [slim], slim).

lex(adjective, [able], able).
lex(adjective, [absolute], absolute).
lex(adjective, [academic], academic).
lex(adjective, [acceptable], acceptable).
lex(adjective, [accurate], accurate).
lex(adjective, [active], active).
lex(adjective, [actual], actual).
lex(adjective, [acute], acute).
lex(adjective, [additional], additional).
lex(adjective, [adequate], adequate).
lex(adjective, [administrative], administrative).
lex(adjective, [advanced], advanced).
lex(adjective, [afraid], afraid).
lex(adjective, [african], african).
lex(adjective, [agricultural], agricultural).
lex(adjective, [alive], alive).
lex(adjective, [alone], alone).
lex(adjective, [alright], alright).
lex(adjective, [alternative], alternative).
lex(adjective, [american], american).
lex(adjective, [ancient], ancient).
lex(adjective, [angry], angry).
lex(adjective, [annual], annual).
lex(adjective, [anxious], anxious).
lex(adjective, [apparent], apparent).
lex(adjective, [appropriate], appropriate).
lex(adjective, [armed], armed).
lex(adjective, [asleep], asleep).
lex(adjective, [attractive], attractive).
lex(adjective, [australian], australian).
lex(adjective, [available], available).
lex(adjective, [average], average).
lex(adjective, [aware], aware).
lex(adjective, [awful], awful).
lex(adjective, [bad], bad).
lex(adjective, [bare], bare).
lex(adjective, [basic], basic).
lex(adjective, [beautiful], beautiful).
lex(adjective, [big], big).
lex(adjective, [bitter], bitter).
lex(adjective, [black], black).
lex(adjective, [blind], blind).
lex(adjective, [bloody], bloody).
lex(adjective, [blue], blue).
lex(adjective, [brief], brief).
lex(adjective, [bright], bright).
lex(adjective, [brilliant], brilliant).
lex(adjective, [british], british).
lex(adjective, [broad], broad).
lex(adjective, [broken], broken).
lex(adjective, [brown], brown).
lex(adjective, [busy], busy).
lex(adjective, [capable], capable).
lex(adjective, [careful], careful).
lex(adjective, [central], central).
lex(adjective, [certain], certain).
lex(adjective, [cheap], cheap).
lex(adjective, [chief], chief).
lex(adjective, [christian], christian).
lex(adjective, [civil], civil).
lex(adjective, [classical], classical).
lex(adjective, [clean], clean).
lex(adjective, [clear], clear).
lex(adjective, [clever], clever).
lex(adjective, [clinical], clinical).
lex(adjective, [close], close).
lex(adjective, [cold], cold).
lex(adjective, [comfortable], comfortable).
lex(adjective, [commercial], commercial).
lex(adjective, [common], common).
lex(adjective, [competitive], competitive).
lex(adjective, [complete], complete).
lex(adjective, [complex], complex).
lex(adjective, [comprehensive], comprehensive).
lex(adjective, [concerned], concerned).
lex(adjective, [confident], confident).
lex(adjective, [conscious], conscious).
lex(adjective, [conservative], conservative).
lex(adjective, [considerable], considerable).
lex(adjective, [consistent], consistent).
lex(adjective, [constant], constant).
lex(adjective, [constitutional], constitutional).
lex(adjective, [contemporary], contemporary).
lex(adjective, [continuous], continuous).
lex(adjective, [conventional], conventional).
lex(adjective, [corporate], corporate).
lex(adjective, [correct], correct).
lex(adjective, [creative], creative).
lex(adjective, [criminal], criminal).
lex(adjective, [critical], critical).
lex(adjective, [crucial], crucial).
lex(adjective, [cultural], cultural).
lex(adjective, [curious], curious).
lex(adjective, [current], current).
lex(adjective, [daily], daily).
lex(adjective, [damaged], damaged).
lex(adjective, [dangerous], dangerous).
lex(adjective, [dark], dark).
lex(adjective, [dead], dead).
lex(adjective, [deaf], deaf).
lex(adjective, [dear], dear).
lex(adjective, [deep], deep).
lex(adjective, [democratic], democratic).
lex(adjective, [dependent], dependent).
lex(adjective, [desperate], desperate).
lex(adjective, [detailed], detailed).
lex(adjective, [different], different).
lex(adjective, [difficult], difficult).
lex(adjective, [direct], direct).
lex(adjective, [dirty], dirty).
lex(adjective, [disabled], disabled).
lex(adjective, [distant], distant).
lex(adjective, [distinct], distinct).
lex(adjective, [domestic], domestic).
lex(adjective, [dominant], dominant).
lex(adjective, [double], double).
lex(adjective, [dramatic], dramatic).
lex(adjective, [dry], dry).
lex(adjective, [due], due).
lex(adjective, [early], early).
lex(adjective, [eastern], eastern).
lex(adjective, [easy], easy).
lex(adjective, [economic], economic).
lex(adjective, [educational], educational).
lex(adjective, [effective], effective).
lex(adjective, [efficient], efficient).
lex(adjective, [elderly], elderly).
lex(adjective, [electoral], electoral).
lex(adjective, [electric], electric).
lex(adjective, [electrical], electrical).
lex(adjective, [electronic], electronic).
lex(adjective, [emotional], emotional).
lex(adjective, [empty], empty).
lex(adjective, [english], english).
lex(adjective, [enormous], enormous).
lex(adjective, [entire], entire).
lex(adjective, [environmental], environmental).
lex(adjective, [equal], equal).
lex(adjective, [essential], essential).
lex(adjective, [ethnic], ethnic).
lex(adjective, [european], european).
lex(adjective, [evident], evident).
lex(adjective, [exact], exact).
lex(adjective, [excellent], excellent).
lex(adjective, [exciting], exciting).
lex(adjective, [existing], existing).
lex(adjective, [expensive], expensive).
lex(adjective, [experimental], experimental).
lex(adjective, [extensive], extensive).
lex(adjective, [external], external).
lex(adjective, [extra], extra).
lex(adjective, [extraordinary], extraordinary).
lex(adjective, [extreme], extreme).
lex(adjective, [fair], fair).
lex(adjective, [familiar], familiar).
lex(adjective, [famous], famous).
lex(adjective, [far], far).
lex(adjective, [federal], federal).
lex(adjective, [female], female).
lex(adjective, [final], final).
lex(adjective, [financial], financial).
lex(adjective, [fine], fine).
lex(adjective, [fixed], fixed).
lex(adjective, [flexible], flexible).
lex(adjective, [following], following).
lex(adjective, [foreign], foreign).
lex(adjective, [formal], formal).
lex(adjective, [free], free).
lex(adjective, [french], french).
lex(adjective, [frequent], frequent).
lex(adjective, [fresh], fresh).
lex(adjective, [friendly], friendly).
lex(adjective, [front], front).
lex(adjective, [full], full).
lex(adjective, [fundamental], fundamental).
lex(adjective, [funny], funny).
lex(adjective, [future], future).
lex(adjective, [general], general).
lex(adjective, [generous], generous).
lex(adjective, [gentle], gentle).
lex(adjective, [genuine], genuine).
lex(adjective, [german], german).
lex(adjective, [given], given).
lex(adjective, [glad], glad).
lex(adjective, [global], global).
lex(adjective, [golden], golden).
lex(adjective, [good], good).
lex(adjective, [grand], grand).
lex(adjective, [grateful], grateful).
lex(adjective, [great], great).
lex(adjective, [green], green).
lex(adjective, [grey], grey).
lex(adjective, [growing], growing).
lex(adjective, [guilty], guilty).
lex(adjective, [happy], happy).
lex(adjective, [hard], hard).
lex(adjective, [healthy], healthy).
lex(adjective, [heavy], heavy).
lex(adjective, [helpful], helpful).
lex(adjective, [high], high).
lex(adjective, [historical], historical).
lex(adjective, [holy], holy).
lex(adjective, [honest], honest).
lex(adjective, [hot], hot).
lex(adjective, [huge], huge).
lex(adjective, [human], human).
lex(adjective, [ideal], ideal).
lex(adjective, [identical], identical).
lex(adjective, [ill], ill).
lex(adjective, [illegal], illegal).
lex(adjective, [immediate], immediate).
lex(adjective, [important], important).
lex(adjective, [impossible], impossible).
lex(adjective, [impressive], impressive).
lex(adjective, [inadequate], inadequate).
lex(adjective, [increased], increased).
lex(adjective, [independent], independent).
lex(adjective, [indian], indian).
lex(adjective, [individual], individual).
lex(adjective, [industrial], industrial).
lex(adjective, [inevitable], inevitable).
lex(adjective, [informal], informal).
lex(adjective, [initial], initial).
lex(adjective, [inner], inner).
lex(adjective, [intense], intense).
lex(adjective, [interested], interested).
lex(adjective, [interesting], interesting).
lex(adjective, [internal], internal).
lex(adjective, [international], international).
lex(adjective, [involved], involved).
lex(adjective, [irish], irish).
lex(adjective, [isolated], isolated).
lex(adjective, [italian], italian).
lex(adjective, [japanese], japanese).
lex(adjective, [joint], joint).
lex(adjective, [judicial], judicial).
lex(adjective, [junior], junior).
lex(adjective, [keen], keen).
lex(adjective, [key], key).
lex(adjective, [labour], labour).
lex(adjective, [large], large).
lex(adjective, [late], late).
lex(adjective, [leading], leading).
lex(adjective, [left], left).
lex(adjective, [legal], legal).
lex(adjective, [liable], liable).
lex(adjective, [liberal], liberal).
lex(adjective, [light], light).
lex(adjective, [like], like).
lex(adjective, [likely], likely).
lex(adjective, [limited], limited).
lex(adjective, [linguistic], linguistic).
lex(adjective, [literary], literary).
lex(adjective, [little], little).
lex(adjective, [live], live).
lex(adjective, [living], living).
lex(adjective, [local], local).
lex(adjective, [logical], logical).
lex(adjective, [long], long).
lex(adjective, [lovely], lovely).
lex(adjective, [low], low).
lex(adjective, [lucky], lucky).
lex(adjective, [mad], mad).
lex(adjective, [main], main).
lex(adjective, [major], major).
lex(adjective, [male], male).
lex(adjective, [married], married).
lex(adjective, [massive], massive).
lex(adjective, [maximum], maximum).
lex(adjective, [mean], mean).
lex(adjective, [medical], medical).
lex(adjective, [mental], mental).
lex(adjective, [mere], mere).
lex(adjective, [middle], middle).
lex(adjective, [military], military).
lex(adjective, [minor], minor).
lex(adjective, [modern], modern).
lex(adjective, [modest], modest).
lex(adjective, [monetary], monetary).
lex(adjective, [moral], moral).
lex(adjective, [multiple], multiple).
lex(adjective, [musical], musical).
lex(adjective, [mutual], mutual).
lex(adjective, [narrow], narrow).
lex(adjective, [national], national).
lex(adjective, [natural], natural).
lex(adjective, [necessary], necessary).
lex(adjective, [negative], negative).
lex(adjective, [nervous], nervous).
lex(adjective, [net], net).
lex(adjective, [new], new).
lex(adjective, [nice], nice).
lex(adjective, [normal], normal).
lex(adjective, [northern], northern).
lex(adjective, [nuclear], nuclear).
lex(adjective, [numerous], numerous).
lex(adjective, [obvious], obvious).
lex(adjective, [occasional], occasional).
lex(adjective, [odd], odd).
lex(adjective, [official], official).
lex(adjective, [old], old).
lex(adjective, [open], open).
lex(adjective, [opposite], opposite).
lex(adjective, [ordinary], ordinary).
lex(adjective, [original], original).
lex(adjective, [other], other).
lex(adjective, [outer], outer).
lex(adjective, [outside], outside).
lex(adjective, [outstanding], outstanding).
lex(adjective, [overall], overall).
lex(adjective, [overseas], overseas).
lex(adjective, [pale], pale).
lex(adjective, [parliamentary], parliamentary).
lex(adjective, [particular], particular).
lex(adjective, [past], past).
lex(adjective, [perfect], perfect).
lex(adjective, [permanent], permanent).
lex(adjective, [personal], personal).
lex(adjective, [physical], physical).
lex(adjective, [pink], pink).
lex(adjective, [pleasant], pleasant).
lex(adjective, [poor], poor).
lex(adjective, [popular], popular).
lex(adjective, [positive], positive).
lex(adjective, [possible], possible).
lex(adjective, [potential], potential).
lex(adjective, [powerful], powerful).
lex(adjective, [practical], practical).
lex(adjective, [precise], precise).
lex(adjective, [pregnant], pregnant).
lex(adjective, [present], present).
lex(adjective, [previous], previous).
lex(adjective, [primary], primary).
lex(adjective, [prime], prime).
lex(adjective, [principal], principal).
lex(adjective, [private], private).
lex(adjective, [professional], professional).
lex(adjective, [proper], proper).
lex(adjective, [proposed], proposed).
lex(adjective, [proud], proud).
lex(adjective, [psychological], psychological).
lex(adjective, [public], public).
lex(adjective, [pure], pure).
lex(adjective, [quick], quick).
lex(adjective, [quiet], quiet).
lex(adjective, [radical], radical).
lex(adjective, [rapid], rapid).
lex(adjective, [rare], rare).
lex(adjective, [rational], rational).
lex(adjective, [raw], raw).
lex(adjective, [ready], ready).
lex(adjective, [real], real).
lex(adjective, [reasonable], reasonable).
lex(adjective, [recent], recent).
lex(adjective, [red], red).
lex(adjective, [regional], regional).
lex(adjective, [regular], regular).
lex(adjective, [relative], relative).
lex(adjective, [relevant], relevant).
lex(adjective, [reliable], reliable).
lex(adjective, [religious], religious).
lex(adjective, [remaining], remaining).
lex(adjective, [remarkable], remarkable).
lex(adjective, [remote], remote).
lex(adjective, [residential], residential).
lex(adjective, [responsible], responsible).
lex(adjective, [revolutionary], revolutionary).
lex(adjective, [rich], rich).
lex(adjective, [right], right).
lex(adjective, [roman], roman).
lex(adjective, [rough], rough).
lex(adjective, [round], round).
lex(adjective, [royal], royal).
lex(adjective, [rural], rural).
lex(adjective, [russian], russian).
lex(adjective, [sad], sad).
lex(adjective, [safe], safe).
lex(adjective, [satisfactory], satisfactory).
lex(adjective, [scientific], scientific).
lex(adjective, [scottish], scottish).
lex(adjective, [secondary], secondary).
lex(adjective, [senior], senior).
lex(adjective, [sensible], sensible).
lex(adjective, [sensitive], sensitive).
lex(adjective, [separate], separate).
lex(adjective, [serious], serious).
lex(adjective, [severe], severe).
lex(adjective, [sexual], sexual).
lex(adjective, [sharp], sharp).
lex(adjective, [short], short).
lex(adjective, [sick], sick).
lex(adjective, [significant], significant).
lex(adjective, [silent], silent).
lex(adjective, [silly], silly).
lex(adjective, [similar], similar).
lex(adjective, [simple], simple).
lex(adjective, [single], single).
lex(adjective, [slight], slight).
lex(adjective, [slow], slow).
lex(adjective, [small], small).
lex(adjective, [smooth], smooth).
lex(adjective, [social], social).
lex(adjective, [soft], soft).
lex(adjective, [solid], solid).
lex(adjective, [sophisticated], sophisticated).
lex(adjective, [sorry], sorry).
lex(adjective, [southern], southern).
lex(adjective, [soviet], soviet).
lex(adjective, [spanish], spanish).
lex(adjective, [special], special).
lex(adjective, [specific], specific).
lex(adjective, [spiritual], spiritual).
lex(adjective, [standard], standard).
lex(adjective, [statutory], statutory).
lex(adjective, [strange], strange).
lex(adjective, [strategic], strategic).
lex(adjective, [strong], strong).
lex(adjective, [stupid], stupid).
lex(adjective, [subsequent], subsequent).
lex(adjective, [substantial], substantial).
lex(adjective, [successful], successful).
lex(adjective, [sudden], sudden).
lex(adjective, [sufficient], sufficient).
lex(adjective, [suitable], suitable).
lex(adjective, [supreme], supreme).
lex(adjective, [sure], sure).
lex(adjective, [surprised], surprised).
lex(adjective, [surprising], surprising).
lex(adjective, [sweet], sweet).
lex(adjective, [tall], tall).
lex(adjective, [technical], technical).
lex(adjective, [temporary], temporary).
lex(adjective, [terrible], terrible).
lex(adjective, [theoretical], theoretical).
lex(adjective, [thick], thick).
lex(adjective, [thin], thin).
lex(adjective, [tiny], tiny).
lex(adjective, [tired], tired).
lex(adjective, [top], top).
lex(adjective, [tory], tory).
lex(adjective, [total], total).
lex(adjective, [tough], tough).
lex(adjective, [traditional], traditional).
lex(adjective, [typical], typical).
lex(adjective, [ultimate], ultimate).
lex(adjective, [unable], unable).
lex(adjective, [underlying], underlying).
lex(adjective, [unemployed], unemployed).
lex(adjective, [unique], unique).
lex(adjective, [united], united).
lex(adjective, [universal], universal).
lex(adjective, [unknown], unknown).
lex(adjective, [unlikely], unlikely).
lex(adjective, [unusual], unusual).
lex(adjective, [upper], upper).
lex(adjective, [urban], urban).
lex(adjective, [used], used).
lex(adjective, [useful], useful).
lex(adjective, [usual], usual).
lex(adjective, [valid], valid).
lex(adjective, [valuable], valuable).
lex(adjective, [various], various).
lex(adjective, [vast], vast).
lex(adjective, [very], very).
lex(adjective, [victorian], victorian).
lex(adjective, [violent], violent).
lex(adjective, [visible], visible).
lex(adjective, [visual], visual).
lex(adjective, [vital], vital).
lex(adjective, [voluntary], voluntary).
lex(adjective, [vulnerable], vulnerable).
lex(adjective, [warm], warm).
lex(adjective, [weak], weak).
lex(adjective, [welsh], welsh).
lex(adjective, [western], western).
lex(adjective, [wet], wet).
lex(adjective, [white], white).
lex(adjective, [whole], whole).
lex(adjective, [wide], wide).
lex(adjective, [widespread], widespread).
lex(adjective, [wild], wild).
lex(adjective, [willing], willing).
lex(adjective, [wonderful], wonderful).
lex(adjective, [wooden], wooden).
lex(adjective, [worried], worried).
lex(adjective, [written], written).
lex(adjective, [wrong], wrong).
lex(adjective, [yellow], yellow).
lex(adjective, [young], young).
lex(adjective, [abrasive], abrasive).
lex(adjective, [accidental], accidental).
lex(adjective, [adjacent], adjacent).
lex(adjective, [adjustable], adjustable).
lex(adjective, [airborne], airborne).
lex(adjective, [analog], analog).
lex(adjective, [angular], angular).
lex(adjective, [applicable], applicable).
lex(adjective, [automatic], automatic).
lex(adjective, [auxiliary], auxiliary).
lex(adjective, [axial], axial).
lex(adjective, [blunt], blunt).
lex(adjective, [circular], circular).
lex(adjective, [cool], cool).
lex(adjective, [defective], defective).
lex(adjective, [digital], digital).
lex(adjective, [dim], dim).
lex(adjective, [first], first).
lex(adjective, [flammable], flammable).
lex(adjective, [flat], flat).
lex(adjective, [glossy], glossy).
lex(adjective, [horizontal], horizontal).
lex(adjective, [hydraulic], hydraulic).
lex(adjective, [inboard], inboard).
lex(adjective, [laminated], laminated).
lex(adjective, [lateral], lateral).
lex(adjective, [linear], linear).
lex(adjective, [loose], loose).
lex(adjective, [lower], lower).
lex(adjective, [magnetic], magnetic).
lex(adjective, [mandatory], mandatory).
lex(adjective, [mechanical], mechanical).
lex(adjective, [missing], missing).
lex(adjective, [mobile], mobile).
lex(adjective, [moderate], moderate).
lex(adjective, [moist], moist).
lex(adjective, [movable], movable).
lex(adjective, [neutral], neutral).
lex(adjective, [optional], optional).
lex(adjective, [outboard], outboard).
lex(adjective, [parallel], parallel).
lex(adjective, [permitted], permitted).
lex(adjective, [pneumatic], pneumatic).
lex(adjective, [poisonous], poisonous).
lex(adjective, [radial], radial).
lex(adjective, [random], random).
lex(adjective, [related], related).
lex(adjective, [resistant], resistant).
lex(adjective, [rigid], rigid).
lex(adjective, [rounded], rounded).
lex(adjective, [shiny], shiny).
lex(adjective, [spherical], spherical).
lex(adjective, [stable], stable).
lex(adjective, [straight], straight).
lex(adjective, [tacky], tacky).
lex(adjective, [telescopic], telescopic).
lex(adjective, [tight], tight).
lex(adjective, [upstream], upstream).
lex(adjective, [vertical], vertical).

***/
