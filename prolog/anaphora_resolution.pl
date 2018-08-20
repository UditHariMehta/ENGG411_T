% =========================================================================
%  Project:   PENG Engine
%  Version:   0.01
%  Module:    anaphora_resolution.pl
%  Date:      2012-04-22
%  Modified:  2016-01-05
%  Status:    DEMO VERSION !
%  Author:    Rolf Schwitter
%  Copyright: Rolf Schwitter, Macquarie University, 2016
% =========================================================================


anaphora_resolution([arg:[num:N, ind:I], ref:'?', drs:[drs(U1, Con1)|Drs]-[], ant:[drs(U2, Con2)], sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) :-
  ( 
     find_antecedent(I, Con2, [drs(U1, Con1)|Drs], true)
     ->
     [drs(U1, Con1)|Drs] = D3,
     append(P0, P1, P2),
     append([['&lt;/ana&gt;']|P0], [['&lt;ana&gt;']], PB),
     append(PB, P1, P3),
     N1 = N3
  ;
     ( member(named(V, Name), Con2) ; member(timex(V, TP), Con2) ; member(object(V, OName, mass), Con2) )
     ->
     reverse([drs(U1, Con1)|Drs], [drs(RU1, RCon1)|RDrs]),
     append(U2, RU1, RU3),
     append(Con2, RCon1, RCon3),
     reverse([drs(RU3, RCon3)|RDrs], D3),
     P2 = P3,
     % flatten(N2, FN2),  nl(user), write(user, 'Flat: '), write(user, FN2), nl(user),
     append([N2], N1, N3)
  ;
     append(U2, U1, U3),
     append(Con2, Con1, Con3),
     [drs(U3, Con3)|Drs] = D3,
     P2 = P3,
     % flatten(N2, FN2), nl(user), write(user, 'Flat: '), write(user, FN2), nl(user),
     append([N2], N1, N3)
  ).
 

anaphora_resolution([arg:[num:N, ind:I], ref:'+', drs:[drs(U1, Con1)|Drs]-[], ant:[drs(U2, Con2)], sco:D3-[], ana:N1-N2-N3, para:P1-P2-P3]) :-
  %% nl(user), write(user, 'Anaphora: '), write(user, Con2), nl(user), nl(user),
  (
     find_antecedent(I, Con2, [drs(U1, Con1)|Drs], true)
     ->
     [drs(U1, Con1)|Drs] = D3,
     append(P0, P1, P2),
     append([['&lt;/ana&gt;']|P0], [['&lt;ana&gt;']], PB),
     append(PB, P1, P3),
     N1 = N3
  ;
     ( member(named(V, Name), Con2) ; member(timex(V, TP), Con2) ; member(object(V, OName, mass), Con2) )
     ->
     %% nl(user), nl(user), write(user, 'TP: '), write(user, TP), nl(user), nl(user),
     reverse([drs(U1, Con1)|Drs], [drs(RU1, RCon1)|RDrs]),
     append(U2, RU1, RU3),
     append(Con2, RCon1, RCon3),
     reverse([drs(RU3, RCon3)|RDrs], D3),
     P2 = P3,
     % flatten(N2, FN2),  nl(user), write(user, 'Flat: '), write(user, FN2), nl(user),
     append([N2], N1, N3)
  ).


find_antecedent(I, Con2, [], false).

  
find_antecedent(I, Con2, [drs(U1, Con1)|Drs], true) :-
  Con1 \= [],
  check_conditions(I, Con2, Con1, true).

check_conditions(I, Con2, [neg drs(U1, Con1)|Drs], true) :-
  Con1 \= [],
  check_conditions(I, Con2, Con1, true).


check_conditions(I, Con2, [neg drs(U1, Con1)|Drs], Result) :-
  find_antecedent(I, Con2, Drs, Result).


check_conditions(I, Con2, [naf drs(U1, Con1)|Drs], true) :-
  Con1 \= [],
  check_conditions(I, Con2, Con1, true).


check_conditions(I, Con2, [naf drs(U1, Con1)|Drs], Result) :-
    find_antecedent(I, Con2, Drs, Result).


find_antecedent(I, Con2, [drs(U1, Con1)|Drs], Result) :-
    find_antecedent(I, Con2, Drs, Result).


check_conditions(I, Con2, [], false).

check_conditions(I1, [Con1, Con2, Con3|Cons1], [Con4, Con5, Con6|Cons2], true) :-
  Con1 = variable(Num1, VarName1),
  Con2 = ordinal(I1, Num1),
  Con3 = object(I1, Name1, P1),
  Con4 = variable(Num2, VarName2),
  Con5 = ordinal(I2, Num2),
  Con6 = object(I2, Name2, P2),
  VarName1 = VarName2,
  Name1 == Name2,
  Num1 = Num2,
  I1 = I2.



% Var: [variable(_G85397,n1),ordinal(_G85397,_G85397)]
% Con: [variable(_G85397,n1),ordinal(_G85645,_G85397),object(_G85645,house)]
%
% lexicon([cat:numeric_variable, wfm:WF, arg:[num:sg, ind:I], arg:[num:sg, ind:N], con:[variable(N, Sym), ordinal(I, N)]]) :-
%   lex(numeric_variable, WF, Sym).


check_conditions(I1, [Con1, Con2|Cons1], [Con3, Con4|Cons2], true) :-
  Con1 = variable(Num1, VarName1),
  Con2 = ordinal(I1, Number),
  Con3 = variable(Num2, VarName2),
  Con4 = ordinal(I2, Name),
  VarName1 == VarName2,
  Num1 = Num2.


check_conditions(I1, [Con1, Con2|Cons1], [Con3, Con4|Cons2], true) :-
 % nl, nl, write('Var: '), write([Con1|Cons1]), nl,
 % write('Con: '), write([Con2|Cons2]), nl, nl,
  Con1 = object(I1, ObjName1, P1),
  Con2 = ordinal(I1, Number1),
  Con3 = object(I2, ObjName2, P2),
  Con4 = ordinal(I2, Number2),
  ObjName1 == ObjName2,
  Number1 == Number2,
  I1 = I2.


check_conditions(I1, [Con1, Con2|Cons1], [Con3, Con4|Cons2], true) :-
  Con1 = variable(I1, VarName1),
  Con2 = object(I1, Name1, P1),
  Con3 = variable(I2, VarName2),
  Con4 = object(I2, Name2, P2),
  VarName1 = VarName2,
  Name1 == Name2,
  I1 = I2.


check_conditions(I1, [Con1, Con2, Con3|Cons1], [Con4, Con5, Con6|Cons2], true) :-
  Con1 = named(I2, PropName1),
  Con2 = relation(of, I1, I2),
  Con3 = object(I1, ObjName1, P1),
  Con4 = named(I4, PropName2),
  Con5 = relation(of, I3, I4),
  Con6 = object(I3, ObjName2, P2),
  PropName1 == PropName2,
  ObjName1  == ObjName2,
  I1 = I3,
  I2 = I4.


check_conditions(I1, [Con1, Con2, Con3|Cons1], [Con4, Con5, Con6|Cons2], true) :-
  Con1 = relation(of, I1, I3),
  Con2 = object(I1, Name1, P1),
  Con3 = prop(I1, Prop1),
  Con4 = relation(of, I2, I4),
  Con5 = object(I2, Name2, P2),
  Con6 = prop(I2, Prop2),
  Name1 == Name2,
  Prop1 == Prop2,
  I1 = I2.


check_conditions(I1, [Con1, Con2|Cons1], [Con3, Con4|Cons2], true) :-
  Con1 = object(I1, Name1, P1),
  Con2 = prop(I1, Prop1),
  Con3 = object(I2, Name2, P2),
  Con4 = prop(I2, Prop2),
  Name1 == Name2,
  Prop1 == Prop2,
  I1 = I2.


check_conditions(I1, [Con1, Con2], [Con3, Con4|Cons2], true) :-
  Con1 = relation(of, I1, I3),
  Con2 = object(I1, Name1, P1),
  Con3 = relation(of, I2, I4),
  Con4 = object(I2, Name2, P2),
  Name1 == Name2,
  I1 = I2.


check_conditions(I1, [Con1], [Con2|Cons2], true) :-
  Con1 = object(I1, Name1, P1),
  Con2 = object(I2, Name2, P2),
  Name1 == Name2,
  I1 = I2.


check_conditions(I1, [Con1], [Con2|Cons2], true) :-
  Con1 = named(I1, Name1),
  Con2 = named(I2, Name2),
  Name1 == Name2,
  I1 = I2.


check_conditions(I1, [Con1], [Con2|Cons2], true) :-
  Con1 = timex(I1, TName1),
  Con2 = timex(I2, TName2),
  TName1 == TName2,
  I1 = I2.


check_conditions(I1, [Con1], [Con2|Cons2], true) :-
  % nl, nl, write('Var: '), write([Con1|Cons1]), nl, nl,
  Con1 = variable(I1, Name1),
  Con2 = variable(I2, Name2),
  Name1 == Name2,
  I1 = I2.


check_conditions(I, Cons1, [Con2|Cons2], Result) :-
  check_conditions(I, Cons1, Cons2, Result).

