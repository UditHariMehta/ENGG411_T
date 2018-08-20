% =========================================================================
%  Project:   PENG Engine
%  Version:   0.01
%  Module:    drs_to_asp.pl
%  Date:      2014-08-23
%  Modified:  2016-01-05
%  Status:    DEMO VERSION !
%  Author:    Rolf Schwitter
%  Copyright: Rolf Schwitter, Macquarie University, 2016
% =========================================================================


% -------------------------------------------------------------------------
% Translate Discourse Representation Structure to Answer Set Program
% 
% translate_drs_to_asp/2
% translate_drs_to_asp/3
% -------------------------------------------------------------------------

translate_drs_to_asp([drs(Us, Conds)], ASPFormulasSK, TheoryFlags) :-
   reset_gensym(sk),
   reset_gensym('no'),
   %% nl, nl, write('DRS: '), write(drs(Us, Conds)), nl, nl,
   %% trace,
   drs_to_asp(drs(Us, Conds), ASPFormulas, [], TheoryFlags),
   %% nl(user), nl(user), write(user, 'TheoryFlags: '), write(user, TheoryFlags), nl(user), nl(user),
   skolemize(ASPFormulas, ASPFormulasSK).


% -------------------------------------------------------------------------

skolemize([], []).

skolemize([List|Formulas1], [List|Formulas2]) :-
   is_list(List),
   skolemize(Formulas1, Formulas2).

skolemize([Term1|Formulas1], [Term2|Formulas2]) :-
   term_variables(Term1, List),
   (
      List = []
      ->
      Term1 = Term2
   ;
      generate_skolem_constant(List),
      Term1 = Term2
   ),
   skolemize(Formulas1, Formulas2).

% skolemize([Term|Formulas1], [Term|Formulas2]) :-
%    skolemize(Formulas1, Formulas2).


% -------------------------------------------------------------------------

generate_skolem_constant([]).

generate_skolem_constant([Var|Vars]) :-
  gensym(sk, Var),
  generate_skolem_constant(Vars).


% -------------------------------------------------------------------------

drs_to_asp(drs([], []), [], T, T).


% -------------------------------------------------------------------------

drs_to_asp(drs([], [query(Var1, QWord, Var2)|Conds]), [query(Var1, QWord, Var2)|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2). 


% -------------------------------------------------------------------------

drs_to_asp(drs([], [ans(which, Term1, pos)|Conds]), [ans(which, Term2, pos)|Literals], T1, T2) :-
   (
      Term1 =.. [prop|R]
      ->
      Term2 =.. [prop|R]
   ;
      Term1 =.. [pred, E|R]
      ->
      Term2 =.. [pred|R]
   ),
   drs_to_asp(drs([], Conds), Literals, T1, T2). 

drs_to_asp(drs([], [ans(which, Term1, neg)|Conds]), [ans(which, Term2, neg)|Literals], T1, T2) :-
    (
      Term1 =.. [prop|R]
      ->
      Term2 =.. [prop|R]
   ;
      Term1 =.. [pred, E|R]
      ->
      Term2 =.. [pred|R]
   ),
   drs_to_asp(drs([], Conds), Literals, T1, T2). 


drs_to_asp(drs([], [ans(who_rel, Term1, pos)|Conds]), [ans(who_rel, Term2, pos)|Literals], T1, T2) :-
   (
      Term1 =.. [prop, E|R]
      ->
      Term2 =.. [prop|R]
   ;
      Term1 =.. [pred, E|R]
      ->
      Term2 =.. [pred|R]
   ),
   drs_to_asp(drs([], Conds), Literals, T1, T2). 

drs_to_asp(drs([], [ans(who_rel, Term1, neg)|Conds]), [ans(who_rel, Term2, neg)|Literals], T1, T2) :-
    (
      Term1 =.. [prop, E|R]
      ->
      Term2 =.. [prop|R]
   ;
      Term1 =.. [pred, E|R]
      ->
      Term2 =.. [pred|R]
   ),
   drs_to_asp(drs([], Conds), Literals, T1, T2). 


%%% fix this
drs_to_asp(drs([], [ans(what, Term1, pos)|Conds]), [ans(what, Term2, pos)|Literals], T1, T2) :-
   (
      Term1 =.. [prop|R]
      ->
      Term2 =.. [prop|R]
   ;
      Term1 =.. [pred|R]
      ->
      Term2 =.. [pred|R]
   ),
   drs_to_asp(drs([], Conds), Literals, T1, T2). 

%%% fix this
drs_to_asp(drs([], [ans(what, Term1, neg)|Conds]), [ans(what, Term2, neg)|Literals], T1, T2) :-
   (
      Term1 =.. [prop|R]
      ->
      Term2 =.. [prop|R]
   ;
      Term1 =.. [pred|R]
      ->
      Term2 =.. [pred|R]
   ),
   drs_to_asp(drs([], Conds), Literals, T1, T2). 



drs_to_asp(drs([], [ans(Type, Term, pos)|Conds]), [ans(Type, Term, pos)|Literals], T1, T2) :-
   % var(Var),
   drs_to_asp(drs([], Conds), Literals, T1, T2). 

drs_to_asp(drs([], [ans(Type, Term, neg)|Conds]), [ans(Type, Term, neg)|Literals], T1, T2) :-
   % var(Var),
   drs_to_asp(drs([], Conds), Literals, T1, T2). 


drs_to_asp(drs([], [eval(Type, Term, pos)|Conds]), [eval(Type, Term, pos)|Literals], T1, T2) :-
   % var(Var),
   drs_to_asp(drs([], Conds), Literals, T1, T2). 

drs_to_asp(drs([], [eval(Type, Term, neg)|Conds]), [eval(Type, Term, neg)|Literals], T1, T2) :-
   % var(Var),
   drs_to_asp(drs([], Conds), Literals, T1, T2). 



% -------------------------------------------------------------------------


drs_to_asp(drs([], [number(Var2, Num), pred(S, Var1, be), operator(S, =, Var2)|Conds]), [arithmetic([Var1, '=', Num])|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [number(Var2, Num), pred(S, Var1, be), operator(S, \=, Var2)|Conds]), [arithmetic([Var1, '!=', Num])|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [number(Var2, Num), pred(S, Var1, be), operator(S, <, Var2)|Conds]), [arithmetic([Var1, '<', Num])|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [number(Var2, Num), pred(S, Var1, be), operator(S, =<, Var2)|Conds]), [arithmetic([Var1, '<=', Num])|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [number(Var2, Num), pred(S, Var1, be), operator(S, >, Var2)|Conds]), [arithmetic([Var1, '>', Num])|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [number(Var2, Num), pred(S, Var1, be), operator(S, >=, Var2)|Conds]), [arithmetic([Var1, '>=', Num])|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [number(Var3, Num), operator(Var2, -, Var3), pred(S,  Var1, be), operator(S, \=, Var2)|Conds]),
	   [arithmetic([Var1, '!=', Var2, '-', Num])|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [number(Var3, Num), operator(Var2, +, Var3), pred(S, Var1, be), operator(S, \=, Var2)|Conds]),
	   [arithmetic([Var1, '!=', Var2, '+', Num])|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [number(Var3, Num), operator(Var2, +, Var3), pred(S, Var1, be), operator(S, =, Var2)|Conds]),
	   [arithmetic([Var1, '=', Var2, '+', Num])|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [number(Var3, Num), operator(Var2, -, Var3), pred(S, Var1, be), operator(S, =, Var2)|Conds]),
	   [arithmetic([Var1, '=', Var2, '-', Num])|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).


% -------------------------------------------------------------------------

/*

drs_to_asp(drs([], [cardinal(Var2, eq, Num), object(Var1, ObjName)|Conds]), Literals3, T1, T2) :-
   Var1 == Var2, 
   generate_object_list(Num, ObjName, Literals1),
   drs_to_asp(drs([], Conds), Literals2, T1, T2),
   append(Literals1, Literals2, Literals3).

generate_object_list(1, ObjName, [inst(Var, ObjName), ordinal(Var, 1)|Literals]).

generate_object_list(Num1, ObjName, [inst(Var, ObjName), ordinal(Var, Num1)|Literals]) :-
   Num2 is Num1-1,
   generate_object_list(Num2, ObjName, Literals).
*/

% -------------------------------------------------------------------------

drs_to_asp(drs([], [named(Var1, Name), object(Var2, ObjName, count), pred(E, Var1, Var2, isa)|Conds]), [Literal, const(Name)|Literals], T1, T2) :-
   var(Var1),
   var(Var2),
   Var1 = Name,
   Var2 = Name,
   Literal =.. [inst, Name, ObjName],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [object(Var, Name, mass)|Conds]), [const(Name)|Literals], T1, T2) :-
   Var = Name,
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [named(Var, Name)|Conds]), [const(Name)|Literals], T1, T2) :-
   Var = Name,
   drs_to_asp(drs([], Conds), Literals, T1, T2).


% -------------------------------------------------------------------------

drs_to_asp(drs([], [object(Var1, ObjName, count), relation(as, Var1, Var2), pred(E, Var0, Var2, PName)|Conds]), [Literal1, Literal2|Literals], T1, T2) :-
   Var2 = Var1,
   Literal1 =.. [inst, Var2, ObjName],
   Literal2 =.. [pred, Var0, Var2, PName],
   drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [object(Var1, ObjName, count), relation(as, Var1, Var2), named(Var2, Name), pred(E, Var0, Var2, PName)|Conds]), [Literal1, Literal2|Literals], T1, T2) :-
   Var2 = Var1,
   Var2 = Name,
   Literal1 =.. [inst, Var2, ObjName],
   Literal2 =.. [pred, Var0, Var2, PName],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [object(Var3, ObjName, count), relation(of, Var3, Var2), pred(E, Var1, Var3, be)|Conds]), [Literal|Literals], T1, T2) :-
   Literal =.. [rel, Var1, Var2, ObjName],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [prop(Var1, PropName), object(Var1, ObjName1, count), relation(of, Var1, Var2), object(Var2, ObjName2, count)|Conds]), 
          [Literal1, Literal2, Literal3|Literals], T1, T2) :-
   Literal1 =.. [prop, Var1, PropName],
   Literal2 =.. [rel, Var1, Var2, ObjName1],
   Literal3 =.. [inst, Var2, ObjName2],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [object(Var1, ObjName1, count), relation(of, Var1, Var2), object(Var2, ObjName2, count)|Conds]), [Literal1, Literal2|Literals], T1, T2) :-
   Literal1 =.. [rel, Var1, Var2, ObjName1],
   Literal2 =.. [inst, Var2, ObjName2],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [prop(Var1, PropName), object(Var1, ObjName, count), relation(of, Var1, Var2), named(Var2, Name)|Conds], T1, T2), 
          [Literal1, Literal2, Literal3, const(Name)|Literals]) :-
   Literal1 =.. [prop, Var1, PropName],
   Literal2 =.. [rel, Var1, Var2, ObjName],
   Literal3 =.. [Name, Var2],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [object(Var1, ObjName, count), relation(of, Var1, Var2)|Conds]), [Literal1|Literals], T1, T2) :-
   Literal1 =.. [rel, Var1, Var2, ObjName],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [prop(Var1, PropName), object(Var1, ObjName, count), relation(of, Var1, Var2)|Conds]), [Literal1, Literal2|Literals], T1, T2) :-
   Literal1 =.. [prop, Var1, PropName],
   Literal2 =.. [rel, Var1, Var2, ObjName],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [object(Var1, ObjName, count), relation(of, Var1, Var2), named(Var2, Name)|Conds]), [Literal1, Literal2, const(Name)|Literals], T1, T2) :-
   Literal1 =.. [rel, Var1, Var2, ObjName],
   Literal2 =.. [Name, Var2],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [object(Var1, ObjName, count), relation(of, Var1, Var2)|Conds]), [Literal|Literals], T1, T2) :-
   Literal =.. [rel, Var1, Var2, ObjName],
   drs_to_asp(drs([], Conds), Literals, T1, T2).



% -------------------------------------------------------------------------

drs_to_asp(drs([], [object(Var2, ObjName, count), pred(E, Var1, Var2, isa)|Conds]), Literals3, T1, T2) :-
   is_list(Var1)
   ->
   % atomic_list_concat(Var1, ' ; ', Var),
   % Literal =.. [ObjName, Var],
   generate_object_list_simple(Var1, ObjName, Literals1),
   drs_to_asp(drs([], Conds), Literals2, T1, T2),
   append(Literals1, Literals2, Literals3).

generate_object_list_simple([], ObjName, []).

generate_object_list_simple([Var|Vars], ObjName, [Literal|Literals]) :-
   Literal =.. [inst, Var, ObjName],
   generate_object_list_simple(Vars, ObjName, Literals).

drs_to_asp(drs([], [object(Var2, ObjName, count), pred(E, Var1, Var2, isa)|Conds]), [Literal|Literals], T1, T2) :-
   Var1 = Var2,
   Literal =.. [inst, Var1, ObjName],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


% -------------------------------------------------------------------------

drs_to_asp(drs([], [ordinal(Var, Num), object(Var, ObjName, count)|Conds]), [ordinal(Var, Num), inst(Var, ObjName)|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).


% -------------------------------------------------------------------------

drs_to_asp(drs([], [timex(A, TP)|Conds]), [time_point(TP)|Literals], T1, T3) :-
    A = TP,
    ( member(event_calculus, T1) -> T1 = T2 ; T2 = [event_calculus|T1] ),
    drs_to_asp(drs([], Conds), Literals, T2, T3).


% -------------------------------------------------------------------------



%%% Check the order in this section.



drs_to_asp(drs([], [prop(S, I3, location), '-prop'(S, I2, PName), pred(S, I1, Pred)|Conds]), 
                   [mod(prop(I1, PName), I3, location), '-prop'(I1, I2, PName)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [prop(S, I3, location), prop(S, I2, PName), pred(S, I1, Pred)|Conds]), 
                   [mod(prop(I1, PName), I3, location), prop(I1, I2, PName)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [prop(S, I2, location), '-prop'(S, PName), pred(S, I1, Pred)|Conds]), 
                   [mod(prop(I1, PName), I2, location), prop(I1, PName)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [prop(S, I2, location), prop(S, PName), pred(S, I1, Pred)|Conds]), 
                   [mod(prop(I1, PName), I2, location), prop(I1, PName)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).



drs_to_asp(drs([], [prop(S, I2, location), pred(S, I1, PName)|Conds]), 
                   [mod(pred(I1, PName), I2, location), pred(I1, PName)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [pred(S, I1, PName), prop(S, I2, location)|Conds]), 
                   [pred(I1, PName), mod(pred(I1, PName), I2, location)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [prop(S, I2, location), '-pred'(S, I1, PName)|Conds]), 
                   [mod(neg_pred(I1, PName), I2, location), '-pred'(I1, PName)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], ['-pred'(S, I1, PName), prop(S, I2, location)|Conds]), 
                   ['-pred'(I1, PName), mod(neg_pred(I1, PName), I2, location)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).



drs_to_asp(drs([], [prop(S, I3, location), pred(S, I1, I2, PName)|Conds]), 
                   [mod(pred(I1, I2, PName), I3, location), pred(I1, I2, PName)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [pred(S, I1, I2, PName), prop(S, I3, location)|Conds]), 
                   [pred(I1, I2, PName), mod(pred(I1, I2, PName), I3, location)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], ['-pred'(S, I1, I2, PName), prop(S, I3, location)|Conds]), 
                   ['-pred'(I1, I2, PName), mod(pred(I1, I2, PName), I3, location)|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [prop(S, I3, location), '-pred'(S, I1, I2, PName)|Conds]), 
                   [mod(pred(I1, I2, PName), I3, location), '-pred'(I1, I2, PName) |Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).


% -------------------------------------------------------------------------


drs_to_asp(drs([], [prop(S, I2, at), pred(S, I1, hold)|Conds]), 
                   [holds_at(fluent(I1, S), I2)|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [prop(S, I2, at), '-pred'(S, I1, hold)|Conds]), 
                   ['-holds_at'(fluent(I1, S), I2)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [prop(S, I2, at), prop(S, PName), pred(S, I1, be)|Conds]), 
                   [holds_at(fluent(I1, PName), I2)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [number(L, 1), operator(I, +, L), prop(S, I2, at), prop(S, PName), pred(S, I1, will_be)|Conds]), 
                   [initiates(event(A, EName), fluent(I1, PName), I2+1)|Literals], [ec(event(A, EName), I2)|T1], T3) :-
    drs_to_asp(drs([], Conds), Literals, T2, T3).


drs_to_asp(drs([], [prop(S, I2, at), prop(S, PName), pred(S, I1, will_be)|Conds]), 
                   [initiates(event(A, EName), fluent(I1, PName), I2)|Literals], [ec(event(A, EName), I2)|T1], T3) :-
   drs_to_asp(drs([], Conds), Literals, T2, T3).

drs_to_asp(drs([], [object(B, time_point, count), ordinal(B, C), variable(C, VName), prop(D, B, at), pred(D, A, EName)|Conds]), 
                   [time_point(C), happens(event(A, EName), C)|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, [ec(event(A, EName), C)|T1], T2).


drs_to_asp(drs([], [prop(S, I2, at), pred(S, I1, be), '-prop'(S, PName)|Conds]),
                   ['-holds_at'(fluent(I1, PName), I2)|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [prop(E, I2, at), pred(E, I1, PName)|Conds]), 
                   [happens(event(I1, PName), I2)|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [prop(E, I2, at), '-pred'(E, I1, PName)|Conds]), 
                   ['-happens'(event(I1, PName), I2)|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).


% -------------------------------------------------------------------------


drs_to_asp(drs([], [operator(S, =, Var2), pred(S, Var1, be)|Conds]), [arithmetic([Var1, '==', Var2])|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).

% drs_to_asp(drs([], [pred(S, Var1, be), operator(S, ==, Var2)|Conds]), [arithmetic([Var1, '==', Var2])|Literals], T1, T2) :-
%    drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [operator(S, \=, Var2), pred(S, Var1, be)|Conds]), [arithmetic([Var1, '!=', Var2])|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).

% drs_to_asp(drs([], [pred(S, Var1, be), operator(S, \=, Var2)|Conds]), [arithmetic([Var1, '!=', Var2])|Literals], T1, T2) :-
%   drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [pred(S, Var1, be), operator(S,  <, Var2)|Conds]), [arithmetic([Var1, '<', Var2])|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [pred(S, Var1, be), operator(S, =<, Var2)|Conds]), [arithmetic([Var1, '<=', Var2])|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [pred(S, Var1, be), operator(S, >, Var2)|Conds]), [arithmetic([Var1, '>', Var2])|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [pred(S, Var1, be), operator(S, >=, Var2)|Conds]), [arithmetic([Var1, '>=', Var2])|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).


% -------------------------------------------------------------------------

drs_to_asp(drs([], [pred(E, Var1, Var2, isa)|Conds]), Literals, T1, T2) :-
   Var1 = Var2,
   drs_to_asp(drs([], Conds), Literals, T1, T2).


% -------------------------------------------------------------------------


drs_to_asp(drs([], [pred(S, Var1, be), '-prop'(S, PropName)|Conds]), [Literal|Literals], T1, T2) :-
   S = Var1,
   Literal =.. ['-prop', Var1, PropName],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


%drs_to_asp(drs([], ['-prop'(S, PropName), pred(S, Var1, be) |Conds]), [Literal|Literals], T1, T2) :-
%   S = Var1, 
%   Literal =.. ['-prop', Var1, PropName],
%   drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], ['-prop'(S, Var2, PropName), naf, pred(S, Var1, be)|Conds]), [not, Literal|Literals], T1, T2) :-
   Literal =.. ['-prop', Var1, Var2, PropName],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], ['-prop'(S, Var2, PropName), pred(S, Var1, be)|Conds]), [Literal|Literals], T1, T2) :-
   Literal =.. ['-prop', Var1, Var2, PropName],
   drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [prop(S, Var2, PropName), pred(S, Var1, be)|Conds]), [Literal|Literals], T1, T2) :-
   Literal =.. [prop, Var1, Var2, PropName],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [pred(S, Var1, be), '-prop'(S, Var2, PropName)|Conds]), [Literal|Literals], T1, T2) :-
   % S = Var1,
   Literal =.. ['-prop', Var1, Var2, PropName],
   drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [pred(S, Var1, be), prop(S, Var2, PropName)|Conds]), [Literal|Literals], T1, T2) :-
   S = Var1,
   Literal =.. [prop, Var1, Var2, PropName],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [prop(S, PropName), pred(S, Var1, be)|Conds]), Literals2, T1, T2) :-
   is_list(Var1),
   generate_property_list(Var1, PropName, PropList),
   drs_to_asp(drs([], Conds), Literals1, T1, T2),
   append(PropList, Literals1, Literals2).


drs_to_asp(drs([], [pred(E, Var1, PredName)|Conds]), Literals2, T1, T2) :-
   is_list(Var1),
   generate_predicate_list(Var1, PredName, PredList),
   drs_to_asp(drs([], Conds), Literals1, T1, T2),
   append(PredList, Literals1, Literals2).


drs_to_asp(drs([], [pred(E, Var1, Var2, PredName)|Conds]), Literals2, T1, T2) :-
   is_list(Var1),
   generate_predicate_list(Var1, Var2, PredName, PredList),
   drs_to_asp(drs([], Conds), Literals1, T1, T2),
   append(PredList, Literals1, Literals2).


generate_predicate_list([], PredName, []).

generate_predicate_list([Var|Vars], PredName, [pred(Var, PredName)|Rest]) :-
  generate_predicate_list(Vars, PredName, Rest).


generate_predicate_list([], Var2, PredName, []).

generate_predicate_list([Var|Vars], Var2, PredName, [pred(Var, Var2, PredName)|Rest]) :-
  generate_predicate_list(Vars, Var2, PredName, Rest).


drs_to_asp(drs([], [pred(S, Var1, be), prop(S, PropName)|Conds]), Literals2, T1, T2) :-
   is_list(Var1),
   generate_property_list(Var1, PropName, PropList),
   drs_to_asp(drs([], Conds), Literals1, T1, T2),
   append(PropList, Literals1, Literals2).

generate_property_list([], PropName, []).

generate_property_list([Var|Vars], PropName, [prop(Var, PropName)|Rest]) :-
  generate_property_list(Vars, PropName, Rest).

drs_to_asp(drs([], [prop(S, PropName), pred(S, Var, be)|Conds]), [Literal|Literals], T1, T2) :-
   Var = S,
   Literal =.. [prop, Var, PropName],
   drs_to_asp(drs([], Conds), Literals, T1, T2).




drs_to_asp(drs([], [prop(S, I2, location), '-pred'(S, I1, Pred), naf|Conds]), 
                   [mod(pred(I1, Pred), I2, location), not, '-pred'(I1, Pred)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [prop(S, I3, location), '-pred'(S, I1, I2, Pred), naf|Conds]), 
                   [mod(pred(I1, Pred), I3, location), not, '-pred'(I1, I2, Pred)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [prop(S, I2, location), '-prop'(S, I1, PName), naf, pred(S, I1, be)|Conds]), 
                   [mod(prop(I1, PName), I2, location), not, '-prop'(I1, PName)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).




drs_to_asp(drs([], [prop(S, I2, location), pred(S, I1, Pred), naf|Conds]), 
                   [mod(pred(I1, Pred), I2, location), not, pred(I1, Pred)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [prop(S, I3, location), pred(S, I1, I2, Pred), naf|Conds]), 
                   [mod(pred(I1, Pred), I3, location), not, pred(I1, I2, Pred)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [prop(S, I2, location), prop(S, I1, PName), naf, pred(S, I1, be)|Conds]), 
                   [mod(prop(I1, PName), I2, location), not, prop(I1, PName)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).



drs_to_asp(drs([], [object(Var2, ObjName, count), '-pred'(S, Var1, Var2, isa), naf|Conds]), [not, Literal|Literals], T1, T2) :-
   Literal =.. ['-inst', Var1, ObjName],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [object(Var2, ObjName, count), pred(S, Var1, Var2, isa), naf|Conds]), [not, Literal|Literals], T1, T2) :-
   Literal =.. [inst, Var1, ObjName],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [object(Var2, ObjName, count), '-pred'(S, Var1, Var2, isa)|Conds]), [Literal|Literals], T1, T2) :-
   Literal =.. ['-inst', Var1, ObjName],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], ['-prop'(S, Var2, PropName), naf, pred(S, Var1, be)|Conds]), [not, Literal|Literals], T1, T2) :-
   Literal =.. ['-prop', Var1, Var2, PropName],
   drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [prop(S, Var2, PropName), naf, pred(S, Var1, be)|Conds]), [not, Literal|Literals], T1, T2) :-
   Literal =.. [prop, Var1, Var2, PropName],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], ['-prop'(S, PropName), naf, pred(S, Var, be)|Conds]), [not, Literal|Literals], T1, T2) :-
   Literal =.. ['-prop', Var, PropName],
   drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [prop(S, PropName), naf, pred(S, Var, be)|Conds]), [not, Literal|Literals], T1, T2) :-
   Literal =.. [prop, Var, PropName],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], ['-pred'(S, Var, PName), naf|Conds]), [not, '-pred'(Var, PName)|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], ['-pred'(S, Var1, Var2, PName), naf|Conds]), [not, '-pred'(Var1, Var2, PName)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], ['-pred'(S, Var, PName)|Conds]), ['-pred'(Var, PName)|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], ['-pred'(S, Var1, Var2, PName)|Conds]), ['-pred'(Var1, Var2, PName)|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [pred(S, Var, PName), naf|Conds]), [not, pred(Var, PName)|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).

drs_to_asp(drs([], [pred(S, Var1, Var2, PName), naf|Conds]), [not, pred(Var1, Var2, PName)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [prop(S, PName), pred(S, I1, be)|Conds]), 
                   [prop(I1, PName)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], ['-prop'(S, PName), pred(S, I1, be)|Conds]), 
                   ['-prop'(I1, PName)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [pred(S, I1, be), prop(S, PName)|Conds]), 
                   [prop(I1, PName)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [pred(S, I1, be), '-prop'(S, PName)|Conds]), 
                   ['-prop'(I1, PName)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [prop(S, Var2, PName), pred(S, Var1, be)|Conds]), 
                   [prop(Var1, Var2, PName)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], ['-prop'(S, Var2, PName), pred(S, Var1, be)|Conds]), 
                   ['-prop'(Var1, Var2, PName)|Literals], T1, T2) :-
    drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], ['-prop'(S, PropName)|Conds]), [Literal|Literals], T1, T2) :-
   Literal =.. ['-prop', S, PropName],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


% -------------------------------------------------------------------------
% Default


% drs_to_asp(drs([], [pred(S, Var1, Var2, PredName1), modifier(S, normally)|Conds]), [not, ab(Literal1), not, (Literal2)|Literals], T1, T2) :-
%   atomic_list_concat([d_, PredName1], FName),
%   Literal1 =.. [FName, Var1, Var2],
%   Literal2 =.. ['-pred', Var1, Var2, PredName1],
 %  drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [modifier(S, normally), pred(S, Var1, Var2, PredName1)|Conds]), [not, ab(Literal1), not, (Literal2)|Literals], T1, T2) :-
   atomic_list_concat([d_, PredName1], FName),
   Literal1 =.. [FName, Var1, Var2],
   Literal2 =.. ['-pred', Var1, Var2, PredName1],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [pred(S, Var1, be), modifier(S, normally), prop(S, Var2, PropName1)|Conds]), [not, ab(Literal1), not, (Literal2)|Literals], T1, T2) :-
   atomic_list_concat([d_, PropName1], FName),
   Literal1 =.. [FName, Var1, Var2],
   Literal2 =.. ['-prop', Var1, Var2, PropName1],
   drs_to_asp(drs([], Conds), Literals, T1, T2).



% -------------------------------------------------------------------------

drs_to_asp(drs([], [ordinal(Var, Num), variable(Num, Name)|Conds]), [ordinal(Var, Num)|Literals], T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [variable(Var, VarName)|Conds]), Literals, T1, T2) :-
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [object(Var, ObjName, count)|Conds]), [inst(Var, ObjName)|Literals], T1, T2):-
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [pred(E, Var1, Var2, PredName)|Conds]), [pred(Var1, Var2, PredName)|Literals], T1, T2):-
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [pred(E, Var, PredName)|Conds]), [pred(Var, PredName)|Literals], T1, T2):-
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [prop(E, Var, PropName)|Conds]), [prop(E, Var, PropName)|Literals], T1, T2):-
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp(drs([], [prop(E, PropName)|Conds]), [prop(E, PropName)|Literals], T1, T2):-
   drs_to_asp(drs([], Conds), Literals, T1, T2).


% -------------------------------------------------------------------------

drs_to_asp(drs([], [naf Drs|Conds]), Result, T1, T3) :-
   complex_cond(naf Drs, Literal, T1, T2),
   drs_to_asp(drs([], Conds), Literals, T2, T3),
   append(Literal, Literals, Result).

drs_to_asp(drs([], [neg Drs|Conds]), Result, T1, T3) :-
   complex_cond(neg Drs, Literal, T1, T2),
   drs_to_asp(drs([], Conds), Literals, T2, T3),
   append(Literal, Literals, Result).

drs_to_asp(drs([], [Drs1 ~~> Drs2|Conds]), Result, T1, T3) :-
   complex_cond(Drs1 ~~> Drs2, Literal, T1, T2),
   drs_to_asp(drs([], Conds), Literals, T2, T3),
   append(Literal, Literals, Result).

drs_to_asp(drs([], [Drs1 ==> Drs2|Conds]), Result, T1, T3) :-
   complex_cond(Drs1 ==> Drs2, Literal, T1, T2),
   drs_to_asp(drs([], Conds), Literals, T2, T3),
   append(Literal, Literals, Result).

drs_to_asp(drs([], [cstr Drs|Conds]), Result, T1, T3) :-
   complex_cond(cstr Drs, Literal, T1, T2),
   drs_to_asp(drs([], Conds), Literals, T2, T3),
   append(Literal, Literals, Result).


drs_to_asp(drs([], [Drs1 or Drs2|Conds]), Result, T1, T3) :-
   complex_cond(Drs1 or Drs2, Literal, T1, T2),
   drs_to_asp(drs([], Conds), Literals, T2, T3),
   append(Literal, Literals, Result).
 

drs_to_asp(drs([U|Us], Conds), Literals, T1, T2) :-
   drs_to_asp(drs(Us, Conds), Literals, T1, T2).
 

% ------------------------------------------------------------------------

drs_to_asp_head(drs([], [(Drs1 or Drs2)]), Head, T1, T3) :-
   drs_to_asp(Drs1, Term1, T1, T2),
   drs_to_asp_head(Drs2, Term3, T2, T3),
   flatten(Term3, Term4),
   append(Term1, [';'], Term2),
   append(Term2, Term4, Head).


drs_to_asp_head(drs([U|Us], Conds), Head, T1, T2) :-
   drs_to_asp_head(drs(Us, Conds), Head, T1, T2).


drs_to_asp_head(drs([], [cardinal(Var, eq, Num), object(Var, ObjName, count)|Rest]), Head, T, T) :-
   cardinality_constraint(Var, [cardinal(Var, eq, Num), object(Var, ObjName, count)|Rest], Term1, TermList),
   List1 = [Num, '{', Term1, ':'],
   reverse_comma(TermList, List2, []),
   List3 = ['}', Num],
   append(List1, List2, ListInt),
   append(ListInt, List3, Head).


drs_to_asp_head(drs([], [cardinal(Var, geq, Num), object(Var, ObjName, count)|Rest]), Head, T, T) :-
   cardinality_constraint(Var, [cardinal(Var, geq, Num), object(Var, ObjName, count)|Rest], Term1, TermList),
   List1 = [Num, '{', Term1, ':'],
   reverse_comma(TermList, List2, []),
   List3 = ['}'],
   append(List1, List2, ListInt),
   append(ListInt, List3, Head).


% Default
drs_to_asp_head(drs([], [modifier(E, normally), pred(E, Var1, Var2, PredName)]), [pred(Var1, Var2, PredName)], T, T).


% Default
drs_to_asp_head(drs([], [pred(E, Var1, be), modifier(E, normally), prop(E, Var2, PropName)|R]), [prop(Var1, Var2, PropName)], T, T).


drs_to_asp_head(drs([], [prop(E, Var2, PropName), modifier(S, abnormally), pred(E, Var1, be)|Conds]), [ab(Term)|Literals], T1, T2) :-
   atomic_list_concat([d_, PropName], FName),
   Term =.. [FName, Var1, Var2],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp_head(drs([], [modifier(S, abnormally), pred(E, Var1, PredName)|Conds]), [ab(Term)|Literals], T1, T2) :-
   atomic_list_concat([d_, PredName], FName),
   Term =.. [FName, Var1],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp_head(drs([], [modifier(S, abnormally), pred(E, Var1, Var2, PredName)|Conds]), [ab(Term)|Literals], T1, T2) :-
   atomic_list_concat([d_, PredName], FName),
   Term =.. [FName, Var1, Var2],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp_head(drs([], [pred(E, Var1, PredName), modifier(S, abnormally)|Conds]), [ab(Term)|Literals], T1, T2) :-
   atomic_list_concat([d_, PredName], FName),
   Term =.. [FName, Var1],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp_head(drs([], [pred(E, Var1, Var2, PredName), modifier(S, abnormally)|Conds]), [ab(Term)|Literals], T1, T2) :-
   atomic_list_concat([d_, PredName], FName),
   Term =.. [FName, Var1, Var2],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp_head(drs([], [pred(E, Var1, be), modifier(S, abnormally), prop(E, Var2, PropName)|Conds]), [ab(Term)|Literals], T1, T2) :-
   atomic_list_concat([d_, PropName], FName),
   Term =.. [FName, Var1, Var2],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp_head(drs([], [named(Var1, Name), pred(E, Var2, be),  modifier(S, abnormally), prop(E, Var1, PropName)|Conds]), [ab(Term)|Literals], T1, T2) :-
   atomic_list_concat([d_, PropName], FName),
   Term =.. [FName, Var2, Name],
   drs_to_asp(drs([], Conds), Literals, T1, T2).


drs_to_asp_head(drs([], Conds), Head, T1, T2) :-
   drs_to_asp(drs([], Conds), Head, T1, T2).


% --------------

/*
cardinality_constraint(Var, [predicate(E, prop, Var1, Var2)], Literal, []) :-
   Var == Var2,
   Literal =.. [prop, Var1, Var2].

cardinality_constraint(Var, [predicate(E, prop, Var1, Var2)], Literal, []) :-
   Var == Var1,
   Literal =.. [prop, Var1, Var2]. */

cardinality_constraint(Var, [pred(E, Var1, Var2, PredName)], Literal, []) :-
   Var == Var2,
   Literal =.. [pred, Var1, Var2, PredName].

cardinality_constraint(Var, [pred(E, Var1, Var2, PredName)], Literal, []) :-
   Var == Var1,
   Literal =.. [pred, Var1, Var2, PredName].


cardinality_constraint(Var2, [prop(S, Var2, PropName), pred(S, Var1, be)], Literal, []) :-
   \+ Var1 == Var2,
   Literal =.. [prop, Var1, Var2, PropName].

cardinality_constraint(Var1, [prop(S, Var2, PropName), pred(S, Var1, be)], Literal, []) :-
   \+ Var1 == Var2,
   Literal =.. [prop, Var1, Var2, PropName].


/*
cardinality_constraint(Var2, [pred(S, Var1, be), prop(S, Var2, PropName)], Literal, []) :-
   \+ Var1 == Var2,
   Literal =.. [prop, Var1, Var2, PropName].

cardinality_constraint(Var1, [pred(S, Var1, be), prop(S, Var2, PropName)], Literal, []) :-
   \+ Var1 == Var2,
   Literal =.. [prop, Var1, Var2, PropName].
*/



cardinality_constraint(Var, [cardinal(Var, eq, Num), object(Var, ObjName, count)|Rest1], Literal1, [Literal2|Rest2]) :-
   Literal2 =.. [inst, Var, ObjName],
   cardinality_constraint(Var, Rest1, Literal1, Rest2).

cardinality_constraint(Var, [cardinal(Var, geq, Num), object(Var, ObjName, count)|Rest1], Literal1, [Literal2|Rest2]) :-
   Literal2 =.. [inst, Var, ObjName],
   cardinality_constraint(Var, Rest1, Literal1, Rest2).
   
cardinality_constraint(Var1, [prop(S, Var2, PropName), pred(S, Var1, be)|Rest1], Literal1, [Literal2|Rest2]) :-
   Literal2 =.. [prop, Var1, Var2, PropName],
   cardinality_constraint(Var1, Rest1, Literal1, Rest2).


reverse_comma([], Z, [','|Z]).

reverse_comma([H|T], Z, Acc) :- 
   reverse_comma(T, Z, [',', H|Acc]).



% -------------------------------------------------------------------------

complex_cond(cstr Drs, Constraints, T1, T2) :-
   drs_to_asp(Drs, Literals, T1, T2),
   compose_constraints(Literals, Constraints).


complex_cond(naf drs([], [neg drs(U, Conds1)]), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, be), prop(E, Prop), prop(E, Var2, location)|RConds]),
   reverse([pred(E, Var1, be), naf, '-prop'(E, Var1, Prop), prop(E, Var2, location)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(naf drs([], [neg drs(U, Conds1)]), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, Pred), prop(E, Var2, location)|RConds]),
   reverse([naf, '-pred'(E, Var1, Pred), prop(E, Var2, location)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(naf drs([], [neg drs(U, Conds1)]), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, Var2, Pred), prop(E, Var3, location)|RConds]),
   reverse([naf, '-pred'(E, Var1, Var2, Pred), prop(E, Var3, location)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(naf drs([], [neg drs(U, Conds1)]), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, Var2, isa), object(Var2, ObjName, count)|RConds]),
   reverse([naf, '-pred'(E, Var1, Var2, isa), object(Var2, ObjName, count)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(naf drs([], [neg drs(U, Conds1)]), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, be), prop(E, O, Prop)|RConds]),
   reverse([pred(E, Var1, be), naf, '-prop'(E, O, Prop)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(naf drs([], [neg drs(U, Conds1)]), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, be), prop(E, Prop)|RConds]),
   reverse([pred(E, Var1, be), naf, '-prop'(E, Prop)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(naf drs([], [neg drs(U, Conds1)]), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, Pred)|RConds]),
   reverse([naf, '-pred'(E, Var1, Pred)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(naf drs([], [neg drs(U, Conds1)]), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, Var2, Pred)|RConds]),
   reverse([naf, '-pred'(E, Var1, Var2, Pred), naf|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(naf drs(U, Conds1), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, be), prop(E, Prop), prop(E, Var2, location)|RConds]),
   reverse([pred(E, Var1, be), naf, prop(E, Var1, Prop), prop(E, Var2, location)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(naf drs(U, Conds1), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, Pred), prop(E, Var2, location)|RConds]),
   reverse([naf, pred(E, Var1, Pred), prop(E, Var2, location)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(naf drs(U, Conds1), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, Var2, Pred), prop(E, Var3, location)|RConds]),
   reverse([naf, pred(E, Var1, Var2, Pred), prop(E, Var3, location)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(naf drs(U, Conds1), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, Var2, isa), object(Var2, ObjName, count)|RConds]),
   reverse([naf, pred(E, Var1, Var2, isa), object(Var2, ObjName, count)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(naf drs(U, Conds1), Literals, T1, T2) :-
   reverse(Conds1, [prop(E, Obj, Prop), pred(E, Var1, Pred)|RConds]),
   reverse([prop(E, Obj, Prop), naf, pred(E, Var1, Pred)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(naf drs(U, Conds1), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, be), prop(E, Var2, Prop)|RConds]),
   reverse([pred(E, Var1, be), naf, prop(E, Var2, Prop)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(naf drs(U, Conds1), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var, be), prop(E, Prop)|RConds]),
   reverse([pred(E, Var, be), naf, prop(E, Prop)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(naf drs(U, Conds1), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, Var2, Pred)|RConds]),
   reverse([naf, pred(E, Var1, Var2, Pred)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(naf drs(U, Conds1), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, Pred)|RConds]),
   reverse([naf, pred(E, Var1, Pred)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


% ---------------------------


complex_cond(neg drs(U, Conds1), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, be), prop(E, Prop)|RConds]),
   reverse([pred(E, Var1, be), '-prop'(E, Prop)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(neg drs(U, Conds1), Literals, T1, T2) :-
   reverse(Conds1, [prop(E, Obj, Prop), pred(E, Var1, be)|RConds]),
   reverse(['-prop'(E, Obj, Prop), pred(E, Var1, be)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(neg drs(U, Conds1), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, be), prop(E, Prop), prop(E, Var2, location)|RConds]),
   reverse([pred(E, Var1, be), '-prop'(E, Var1, Prop), prop(E, Var2, location)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(neg drs(U, Conds1), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, be), prop(E, Var2, Prop), prop(E, Var3, location)|RConds]),
   reverse([pred(E, Var1, be), '-prop'(E, Var2, Prop), prop(E, Var3, location)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(neg drs(U, Conds1), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, Pred), prop(E, Var2, location)|RConds]),
   reverse(['-pred'(E, Var1, Pred), prop(E, Var2, location)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(neg drs(U, Conds1), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, Var2, Pred), prop(E, Var3, location)|RConds]),
   reverse(['-pred'(E, Var1, Var2, Pred), prop(E, Var3, location)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(neg drs(U, Conds1), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, Var2, isa), object(Var2, ObjName, count)|RConds]),
   reverse(['-pred'(E, Var1, Var2, isa), object(Var2, ObjName, count)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(neg drs(U, Conds1), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, be), operator(E, =, Var2)|RConds]),
   reverse([pred(E, Var1, be), operator(E, \=, Var2)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(neg drs(U, Conds1), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, be), prop(E, Var2, PName)|RConds]),
   reverse([pred(E, Var1, be), '-prop'(E, Var2, PName)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(neg drs(U, Conds1), Literals, T1, T2) :-
   reverse(Conds1, [prop(E, Prop)|RConds]),
   reverse(['-prop'(E, Prop)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(neg drs(U, Conds1), Literals, T1, T2) :-
   reverse(Conds1, [prop(Var1, Obj, Prop)|RConds]),
   reverse(['-prop'(Var1, Obj, Prop)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(neg drs(U, Conds1), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, Pred)|RConds]),
   reverse(['-pred'(E, Var1, Pred)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(neg drs(U, Conds1), Literals, T1, T2) :-
   reverse(Conds1, [pred(E, Var1, Var2, Pred)|RConds]),
   reverse(['-pred'(E, Var1, Var2, Pred)|RConds], Conds2),
   drs_to_asp(drs(U, Conds2), Literals, T1, T2).


complex_cond(Drs1 or Drs2, Disjunctions, T1, T3) :-
   drs_to_asp(Drs1, Disj1, T1, T2),
   drs_to_asp(Drs2, Disj2, T2, T3),
   compose_disjunctions(Disj1, Disj2, Disjunctions).
 

complex_cond(drs([U|Us], Conds) ~~> Drs2, Rules, T1, T2) :-
   complex_cond(drs(Us, Conds) ~~> Drs2,  Rules, T1, T2).


complex_cond(drs([], Conds1) ~~> drs(U2, Conds2), Rules, T1, T4) :-
   member(modifier(S, normally), Conds2),
   append(Conds1, Conds2, Conds3),
   drs_to_asp(drs([], Conds3), Formula1, T1, T2),
   drs_to_asp_head(drs(U2, Conds2), Formula2, T2, T3),
   compose_basic_rules(Formula1, Formula2, Rules, T3, T4).


complex_cond(drs([], Conds1) ~~> drs(U2, Conds2), Rules, T1, T4) :-
   drs_to_asp(drs([], Conds1), Formula1, T1, T2),
   drs_to_asp_head(drs(U2, Conds2), Formula2, T2, T3),
   compose_basic_rules(Formula1, Formula2, Rules, T3, T4).


complex_cond(drs([U|Us], Conds) ==> Drs2, Rule, T1, T2) :-
   complex_cond(drs(Us, Conds) ==> Drs2,  Rule, T1, T2).


complex_cond(drs([], Conds) ==> Drs2, Rules, T1, T4) :-
   drs_to_asp(drs([], Conds), Formula1, T1, T2),
   drs_to_asp_head(Drs2, Formula2, T2, T3),
   compose_basic_rules(Formula1, Formula2, Rules, T3, T4).


complex_cond(drs([], Conds) ==> Drs2, Rules, T1, T4) :-
   drs_to_asp(drs([], Conds), Formula1, T1, T2),
   drs_to_asp_head(Drs2, Formula2, T2, T3),
   compose_basic_rules(Formula1, Formula2, Rules, T3, T4).


% ---------------------------------------------------------------------

compose_constraints(Formula, Constraints) :-
   strip_disjunction(Formula, SubFormula, Disjuncts),
   build_constraint(Disjuncts, SubFormula, Constraints).

build_constraint([], Formula, [[':-', Formula]]).

build_constraint([[Disj1, ';', Disj2]], SubFormula, [[':-', Formula]]) :-
   append(SubFormula, Disj1, FormulaIntm),
   append(ForulaIntm, Disj2, Formula).

build_constraint([[Disj, ';'|Disjuncts]|Rest], SubFormula, [[':-', Formula]|Constraints]) :-
   append(SubFormula, Disj, Formula),
   build_constraint([Disjuncts|Rest], SubFormula, Constraints).


% ---------------------------------------------------------------------

compose_basic_rules(Formula1, Formula2, Rules, T1, T2) :-
   strip_disjunction(Formula1, SubFormula, Disjuncts),
   build_basic_rules(Disjuncts, SubFormula, Formula2, Rules, T1, T2).

build_basic_rules([], [inst(X, C1)], [inst(X, C2)], [[[inst(X, C2)], ':-', [inst(X, C1)]], is_subclass(C1, C2)], T1, T2) :-
   ( member(is_subclass, T1) -> T1 = T2 ; T2 = [is_subclass|T1] ).

build_basic_rules([], [inst(I1, C1)], 
                      [inst(I3, C3), ';', inst(I2, C2)|Rest], Result, T1, T2) :-
   collect_superclasses([inst(I3, C3), ';', inst(I2, C2)|Rest], Head, SuperClasses),
   generate_subclass_relations([C1], SuperClasses, SubClassRelations),
   append([[Head, ':-',  [inst(I1, C1)]]], SubClassRelations, Result),
   ( member(is_subclass, T1) -> T1 = T2 ; T2 = [is_subclass|T1] ).

%% build_basic_rules([], Formula2, [Formula1], [[[Formula1], ':-', Formula2]], T, T).
  

% ---------------------------------------------------------------------


collect_superclasses([inst(I2, C2), ';', inst(I1, C1)], [[inst(I2, C2)], ';', [inst(I1, C1)]], [C2, C1]).

collect_superclasses([inst(I, C), ';'|Rest1], [[inst(I, C)], ';'|Rest2], [C|Rest3]) :-
   collect_superclasses(Rest1, Rest2, Rest3).

generate_subclass_relations([C1], [C2], [is_subclass(C1, C2)]).

generate_subclass_relations([C1], [C2|Rest1], [is_subclass(C1, C2)|Rest2]) :-
   generate_subclass_relations([C1], Rest1, Rest2).


% ---------------------------------------------------------------------
%%% Splitting for verbal modifiers in consequent

build_basic_rules([], Formula2, [mod(pred(I1, PName), I2, location), pred(I1, PName)], 
                  [[[mod(pred(I1, PName), I2, location)], ':-', Formula2], [[pred(I1, PName)], ':-', Formula2]], T, T).

build_basic_rules([], Formula2, [mod(pred(I1, I2, PName), I3, location), pred(I1, I2, PName)], 
                  [[[mod(pred(I1, I2, PName), I3, location)], ':-', Formula2], [[pred(I1, I2, PName)], ':-', Formula2]], T, T).


% ---------------------------------------------------------------------

%%% Splitting for local closed world assumption

build_basic_rules([], Formula2, ['-pred'(X, PName)], 
                  [[['-pred'(X, PName)], ':-', [local_cwa(neg_pred(X, PName))]], [[local_cwa(neg_pred(X, PName))], ':-', Formula2]], T, T) :-
   member(pred(X, PName), Formula2).

build_basic_rules([], Formula2, ['-pred'(X, Y, PName)], 
                  [[['-pred'(X, Y, PName)], ':-', [local_cwa(neg_pred(X, Y, PName))]], [[local_cwa(neg_pred(X, Y, PName))], ':-', Formula2]], T, T) :-
  member(pred(X, Y, PName), Formula2).

build_basic_rules([], Formula2, ['-prop'(X, PName)], 
                  [[['-prop'(X, PName)], ':-', [local_cwa(neg_prop(X, PName))]], [[local_cwa(neg_prop(X, PName))], ':-', Formula2]], T, T) :-
  member(prop(X, PName), Formula2).

build_basic_rules([], Formula2, ['-prop'(X, Y, PName)], 
                  [[['-prop'(X, Y, PName)], ':-', [local_cwa(neg_prop(X, Y, PName))]], [[local_cwa(neg_prop(X, Y, PName))], ':-', Formula2]], T, T) :-
 \+ \+  member(prop(X, Y, PName), Formula2).


% -----------------------------------------------------
%%% Addling local closed world assumption to queries

%%% fix this
build_basic_rules([], Formula2, [ans(what, prop(A, C, hold), pos)], 
                  [ans_id(ID, what, pos),
                   [[ans(ID, fluent(C, A), pos, owa)], ':-', Formula2]], T1, T2) :-
  ( member(what, T1) -> T1 = T2 ; T2 = [what|T1] ),
  gensym('no', ID).

build_basic_rules([], Formula2, [ans(what, pred(A, C, hold), pos)], 
                  [ans_id(ID, what, pos),
                   [[ans(ID, fluent(C, A), pos, owa)], ':-', Formula2]], T1, T2) :-
  ( member(what, T1) -> T1 = T2 ; T2 = [what|T1] ),
  gensym('no', ID).
                

% -----------------------------------------------------
% yes no question

build_basic_rules([], Formula2, [ans(yes_no, yes, pos)], 
                  [ans_id(ID, yes_no, pos),
                   [[ans(ID, yes, pos, cwa)], ':-', Formula4], 
                   [[ans(ID, yes, pos, owa)], ':-', Formula5] %%%,
                  %%% [[ans(ID, yes, neg, cwa)], ':-', Formula6], 
                  %%% [[ans(ID, yes, neg, owa)], ':-', Formula7]
                  ], T1, T2) :-
  local_cwa_query(pos, Formula2, Formula3, PosCwa, PosOwa, NegCwa, NegOwa),
  append(Formula2, PosCwa, Formula4),
  append(Formula2, PosOwa, Formula5),
  append(Formula3, NegCwa, Formula6),
  append(Formula3, NegOwa, Formula7),
  ( member(yes_no, T1) -> T1 = T2 ; T2 = [yes_no|T1] ),
  gensym('no', ID).


build_basic_rules([], Formula2, [ans(yes_no, no, neg)], 
                  [ans_id(ID, yes_no, neg),
                   [[ans(ID, no, neg, cwa)], ':-', Formula4], 
                   [[ans(ID, no, neg, owa)], ':-', Formula5] %%% ,
                  %%% [[ans(ID, no, pos, cwa)], ':-', Formula6], 
                  %%% [[ans(ID, no, pos, owa)], ':-', Formula7]
                  ], T1, T2) :-
  local_cwa_query(pos, Formula2, Formula3, PosCwa, PosOwa, NegCwa, NegOwa),
  append(Formula2, NegCwa, Formula4),
  append(Formula2, NegOwa, Formula5),
  append(Formula3, PosCwa, Formula6),
  append(Formula3, PosOwa, Formula7),
  ( member(yes_no, T1) -> T1 = T2 ; T2 = [yes_no|T1] ),
  gensym('no', ID).


% -----------------------------------------------------
% who question

build_basic_rules([], Formula2, [ans(who, inst(I, C), pos)], 
                  [ans_id(ID, who, pos),
                   [[ans(ID, inst(I, C), pos, cwa)], ':-', Formula4], 
                   [[ans(ID, inst(I, C), pos, owa)], ':-', Formula5] %%%,
                  %%% [[ans(ID, inst(I, C), neg, cwa)], ':-', Formula6], 
                  %%% [[ans(ID, inst(I, C), neg, owa)], ':-', Formula7]
                  ], T1, T2) :-
  local_cwa_query(pos, Formula2, Formula3, PosCwa, PosOwa, NegCwa, NegOwa),
  PosCwa \= [],
  append(Formula2, PosCwa, Formula4),
  append(Formula2, PosOwa, Formula5),
  append(Formula3, NegCwa, Formula6),
  append(Formula3, NegOwa, Formula7),
  ( member(who, T1) -> T1 = T2 ; T2 = [who|T1] ),
  gensym('no', ID).


build_basic_rules([], Formula2, [ans(who, inst(I, C), neg)], 
                  [ans_id(ID, who, neg),
                   [[ans(ID, inst(I, C), neg, cwa)], ':-', Formula4], 
                   [[ans(ID, inst(I, C), neg, owa)], ':-', Formula5] %%% ,
                  %%% [[ans(ID, inst(I, C), pos, cwa)], ':-', Formula6], 
                  %%% [[ans(ID, inst(I, C), pos, owa)], ':-', Formula7]
                  ], T1, T2) :-
  local_cwa_query(neg, Formula2, Formula3, PosCwa, PosOwa, NegCwa, NegOwa),
  append(Formula2, NegCwa, Formula4),
  append(Formula2, NegOwa, Formula5),
  append(Formula3, PosCwa, Formula6),
  append(Formula3, PosOwa, Formula7),
  ( member(who, T1) -> T1 = T2 ; T2 = [who|T1] ),
  gensym('no', ID).


build_basic_rules([], Formula2, [ans(who, inst(I, C), pos)], 
                  [ans_id(ID, who, pos),
                   [[ans(ID, inst(I, C), pos, owa)], ':-', Formula2]
                  ], T1, T2) :-
  ( member(who, T1) -> T1 = T2 ; T2 = [who|T1] ),
  gensym('no', ID).


build_basic_rules([], Formula2, [ans(who, inst(I, C), neg)], 
                  [ans_id(ID, who, neg),
                   [[ans(ID, inst(I, C), neg, owa)], ':-', Formula2]
                  ], T1, T2) :-
  ( member(who, T1) -> T1 = T2 ; T2 = [who|T1] ),
  gensym('no', ID).


% -----------------------------------------------------
% who_rel question

build_basic_rules([], Formula2, [ans(who_rel, C, pos)], 
                  [ans_id(ID, who_rel, pos),
                   [[ans(ID, C, pos, cwa)], ':-', Formula4], 
                   [[ans(ID, C, pos, owa)], ':-', Formula5] %%%,
                  %%% [[ans(ID, inst(I, C), neg, cwa)], ':-', Formula6], 
                  %%% [[ans(ID, inst(I, C), neg, owa)], ':-', Formula7]
                  ], T1, T2) :-
  local_cwa_query(pos, Formula2, Formula3, PosCwa, PosOwa, NegCwa, NegOwa),
  append(Formula2, PosCwa, Formula4),
  append(Formula2, PosOwa, Formula5),
  append(Formula3, NegCwa, Formula6),
  append(Formula3, NegOwa, Formula7),
  ( member(who_rel, T1) -> T1 = T2 ; T2 = [who_rel|T1] ),
  gensym('no', ID).


build_basic_rules([], Formula2, [ans(who_rel, C, neg)], 
                  [ans_id(ID, who_rel, neg),
                   [[ans(ID, C, neg, cwa)], ':-', Formula4], 
                   [[ans(ID, C, neg, owa)], ':-', Formula5] %%% ,
                  %%% [[ans(ID, inst(I, C), pos, cwa)], ':-', Formula6], 
                  %%% [[ans(ID, inst(I, C), pos, owa)], ':-', Formula7]
                  ], T1, T2) :-
  local_cwa_query(pos, Formula2, Formula3, PosCwa, PosOwa, NegCwa, NegOwa),
  append(Formula2, NegCwa, Formula4),
  append(Formula2, NegOwa, Formula5),
  append(Formula3, PosCwa, Formula6),
  append(Formula3, PosOwa, Formula7),
  ( member(who_rel, T1) -> T1 = T2 ; T2 = [who_rel|T1] ),
  gensym('no', ID).


% -----------------------------------------------------
% which question

build_basic_rules([], Formula2, [ans(which, C, pos)], 
                  [ans_id(ID, which, pos),
                   [[ans(ID, C, pos, cwa)], ':-', Formula4], 
                   [[ans(ID, C, pos, owa)], ':-', Formula5] %%%,
                  %%% [[ans(ID, inst(I, C), neg, cwa)], ':-', Formula6], 
                  %%% [[ans(ID, inst(I, C), neg, owa)], ':-', Formula7]
                  ], T1, T2) :-
  local_cwa_query(pos, Formula2, Formula3, PosCwa, PosOwa, NegCwa, NegOwa),
  append(Formula2, PosCwa, Formula4),
  append(Formula2, PosOwa, Formula5),
  append(Formula3, NegCwa, Formula6),
  append(Formula3, NegOwa, Formula7),
  ( member(which, T1) -> T1 = T2 ; T2 = [which|T1] ),
  gensym('no', ID).


build_basic_rules([], Formula2, [ans(which, C, neg)], 
                  [ans_id(ID, which, neg),
                   [[ans(ID, C, neg, cwa)], ':-', Formula4], 
                   [[ans(ID, C, neg, owa)], ':-', Formula5] %%% ,
                  %%% [[ans(ID, inst(I, C), pos, cwa)], ':-', Formula6], 
                  %%% [[ans(ID, inst(I, C), pos, owa)], ':-', Formula7]
                  ], T1, T2) :-
  local_cwa_query(neg, Formula2, Formula3, PosCwa, PosOwa, NegCwa, NegOwa),
  append(Formula2, NegCwa, Formula4),
  append(Formula2, NegOwa, Formula5),
  append(Formula3, PosCwa, Formula6),
  append(Formula3, PosOwa, Formula7),
  ( member(which, T1) -> T1 = T2 ; T2 = [which|T1] ),
  gensym('no', ID).


% -----------------------------------------------------
% where question

build_basic_rules([], Formula2, [ans(where, C, pos)], 
                  [ans_id(ID, where, pos),
                   [[ans(ID, C, pos, cwa)], ':-', Formula4], 
                   [[ans(ID, C, pos, owa)], ':-', Formula5] %%%,
                  %%% [[ans(ID, inst(I, C), neg, cwa)], ':-', Formula6], 
                  %%% [[ans(ID, inst(I, C), neg, owa)], ':-', Formula7]
                  ], T1, T2) :-
  local_cwa_query(pos, Formula2, Formula3, PosCwa, PosOwa, NegCwa, NegOwa),
  append(Formula2, PosCwa, Formula4),
  append(Formula2, PosOwa, Formula5),
  append(Formula3, NegCwa, Formula6),
  append(Formula3, NegOwa, Formula7),
  ( member(where, T1) -> T1 = T2 ; T2 = [where|T1] ),
  gensym('no', ID).


build_basic_rules([], Formula2, [ans(where, C, neg)], 
                  [ans_id(ID, where, neg),
                   [[ans(ID, C, neg, cwa)], ':-', Formula4], 
                   [[ans(ID, C, neg, owa)], ':-', Formula5] %%% ,
                  %%% [[ans(ID, inst(I, C), pos, cwa)], ':-', Formula6], 
                  %%% [[ans(ID, inst(I, C), pos, owa)], ':-', Formula7]
                  ], T1, T2) :-
  local_cwa_query(neg, Formula2, Formula3, PosCwa, PosOwa, NegCwa, NegOwa),
  append(Formula2, NegCwa, Formula4),
  append(Formula2, NegOwa, Formula5),
  append(Formula3, PosCwa, Formula6),
  append(Formula3, PosOwa, Formula7),
  ( member(where, T1) -> T1 = T2 ; T2 = [where|T1] ),
  gensym('no', ID).


% -----------------------------------------------------
% most question

build_basic_rules([], Formula2, [eval(most, I, pos)], 
                  [ans_id(ID, most, pos),
                   [[eval(ID, I, pos, cwa)], ':-', Formula4], 
                   [[eval(ID, I, pos, owa)], ':-', Formula5],
                   [[eval(ID, I, neg, cwa)], ':-', Formula6], 
                   [[eval(ID, I, neg, owa)], ':-', Formula7]
                  ], T1, T2) :-
  local_cwa_query(pos, Formula2, Formula3, PosCwa, PosOwa, NegCwa, NegOwa),
  append(Formula2, PosCwa, Formula4),
  append(Formula2, PosOwa, Formula5),
  append(Formula3, NegCwa, Formula6),
  append(Formula3, NegOwa, Formula7),
  ( member(most, T1) -> T1 = T2 ; T2 = [most|T1] ),
  gensym('no', ID).


build_basic_rules([], Formula2, [eval(most, I, neg)], 
                  [ans_id(ID, most, neg),
                   [[eval(ID, I, neg, cwa)], ':-', Formula4], 
                   [[eval(ID, I, neg, owa)], ':-', Formula5],
                   [[eval(ID, I, pos, cwa)], ':-', Formula6], 
                   [[eval(ID, I, pos, owa)], ':-', Formula7]
                  ], T1, T2) :-
  local_cwa_query(neg, Formula2, Formula3, PosCwa, PosOwa, NegCwa, NegOwa),
  append(Formula2, NegCwa, Formula4),
  append(Formula2, NegOwa, Formula5),
  append(Formula3, PosCwa, Formula6),
  append(Formula3, PosOwa, Formula7),
  ( member(most, T1) -> T1 = T2 ; T2 = [most|T1] ),
  gensym('no', ID).


% -----------------------------------------------------
% how many question

build_basic_rules([], Formula2, [eval(how_many, I, pos)], 
                  [ans_id(ID, how_many, pos),
                   [[eval(ID, I, pos, cwa)], ':-', Formula4], 
                   [[eval(ID, I, pos, owa)], ':-', Formula5] %%% ,
                   %%% [[eval(ID, I, neg, cwa)], ':-', Formula6], 
                   %%% [[eval(ID, I, neg, owa)], ':-', Formula7]
                  ], T1, T2) :-
  local_cwa_query(pos, Formula2, Formula3, PosCwa, PosOwa, NegCwa, NegOwa),
  append(Formula2, PosCwa, Formula4),
  append(Formula2, PosOwa, Formula5),
  append(Formula3, NegCwa, Formula6),
  append(Formula3, NegOwa, Formula7),
  ( member(how_many, T1) -> T1 = T2 ; T2 = [how_many|T1] ),
  gensym('no', ID).


build_basic_rules([], Formula2, [eval(how_many, I, neg)], 
                  [ans_id(ID, how_many, neg),
                   [[eval(ID, I, neg, cwa)], ':-', Formula4], 
                   [[eval(ID, I, neg, owa)], ':-', Formula5] %%%,
                   %%% [[eval(ID, I, pos, cwa)], ':-', Formula6], 
                   %%% [[eval(ID, I, pos, owa)], ':-', Formula7]
                  ], T1, T2) :-
  local_cwa_query(neg, Formula2, Formula3, PosCwa, PosOwa, NegCwa, NegOwa),
  append(Formula2, NegCwa, Formula4),
  append(Formula2, NegOwa, Formula5),
  append(Formula3, PosCwa, Formula6),
  append(Formula3, PosOwa, Formula7),
  ( member(how_many, T1) -> T1 = T2 ; T2 = [how_many|T1] ),
  gensym('no', ID).


% -----------------------------------------------------
  
build_basic_rules([], Formula2, [Formula1], [[[Formula1], ':-', Formula2]], T, T).   % :- write('Formula1: '), write(Formula1), nl, nl.
                      
build_basic_rules([], Formula2, Formula1, [[Formula1, ':-', Formula2]], T, T).       % :- write('Formula 2: '), write(Formula2), nl, nl.


% inst(E,martian) ; inst(E,venusian) :- inst(E,person).

build_basic_rules([[Disj1, ';', Disj2]], SubFormula, Formula1, [[Formula1, ':-', Formula2], [Formula1, ':-', Formula3]], T, T) :-
   append(SubFormula, Disj1, Formula2),
   append(SubFormula, Disj2, Formula3).

build_basic_rules([[Disj, ';'|Disjuncts]|Rest], SubFormula, Formula1, [[Formula1, ':-', Formula2]|Rules], T1, T2) :-
   append(SubFormula, Disj, Formula2),
   build_basic_rules([Disjuncts|Rest], SubFormula, Formula1, Rules, T1, T2).


% ---------------------------------------------------------------------

%%% local closed world assumption positive cases

local_cwa_query(Pol, Formula, Subst, PosCwa, PosOwa, NegCwa, NegOwa) :-
  local_cwa_query_2(Pol, Formula, Subst, PosCwa, PosOwa, NegCwa, NegOwa),
  PosCwa \= [].
  

local_cwa_query_2(pos, [], [], [], [], [], []).

local_cwa_query_2(pos, [pred(I, PName)|Formula], 
                     ['-pred'(I, PName)|Subst],
                     [local_cwa(neg_pred('_', PName))|PosCwa], 
                     [not, local_cwa(neg_pred('_', PName))|PosOwa],
                     [local_cwa(neg_pred(I, PName))|NegCwa],
                     [not, local_cwa(neg_pred(I, PName))|NegOwa]) :-
  local_cwa_query_2(pos, Formula, Subst, PosCwa, PosOwa, NegCwa, NegOwa).

local_cwa_query_2(pos, [pred(I1, I2, PName)|Formula], 
                     ['-pred'(I1, I2, PName)|Subst],
                     [local_cwa(neg_pred('_', '_', PName))|PosCwa], 
                     [not, local_cwa(neg_pred('_', '_', PName))|PosOwa],
                     [local_cwa(neg_pred(I1, I2, PName))|NegCwa],
                     [not, local_cwa(neg_pred(I1, I2, PName))|NegOwa]) :-
  local_cwa_query_2(pos, Formula, Subst, PosCwa, PosOwa, NegCwa, NegOwa).

local_cwa_query_2(pos, [prop(I, PName)|Formula], 
                     ['-prop'(I, PName)|Subst],
                     [local_cwa(neg_prop('_', PName))|PosCwa], 
                     [not, local_cwa(neg_prop('_', PName))|PosOwa],
                     [local_cwa(neg_prop(I, PName))|NegCwa],
                     [not, local_cwa(neg_prop(I, PName))|NegOwa]) :-
  local_cwa_query_2(pos, Formula, Subst, PosCwa, PosOwa, NegCwa, NegOwa).

local_cwa_query_2(pos, [prop(I1, I2, PName)|Formula], 
                     ['-prop'(I1, I2, PName)|Subst],
                     [local_cwa(neg_prop('_', '_', PName))|PosCwa], 
                     [not, local_cwa(neg_prop('_', '_', PName))|PosOwa],
                     [local_cwa(neg_prop(I1, I2, PName))|NegCwa],
                     [not, local_cwa(neg_prop(I1, I2, PName))|NegOwa]) :-
  local_cwa_query_2(pos, Formula, Subst, PosCwa, PosOwa, NegCwa, NegOwa).

% local_cwa_query_2(pos, [prop(I1, I2, PName, A)|Formula], 
%                     ['-prop'(I1, I2, PName, A)|Subst],
%                     [local_cwa(neg_prop('_', '_', PName))|PosCwa], 
%                     [not, local_cwa(neg_prop('_', '_', PName))|PosOwa],
%                     [local_cwa(neg_prop(I1, I2, PName))|NegCwa],
%                     [not, local_cwa(neg_prop(I1, I2, PName))|NegOwa]) :-
%  local_cwa_query_2(pos, Formula, Subst, PosCwa, PosOwa, NegCwa, NegOwa).

local_cwa_query_2(pos, [Literal|Literals1], [Literal|Literals2], PosCwa, PosOwa, NegCwa, NegOwa) :-
  local_cwa_query_2(pos, Literals1, Literals2, PosCwa, PosOwa, NegCwa, NegOwa). 


% ---------------------------------------------------------------------

%%% local closed world assumption negative cases


local_cwa_query_2(neg, [], [], [], [], [], []).

local_cwa_query_2(neg, ['-pred'(I, PName)|Formula], 
                     [pred(I, PName)|Subst],
                     [local_cwa(neg_pred('_', PName))|PosCwa], 
                     [not, local_cwa(neg_pred('_', PName))|PosOwa],
                     [local_cwa(neg_pred(I, PName))|NegCwa],
                     [not, local_cwa(neg_pred(I, PName))|NegOwa]) :-
  local_cwa_query_2(neg, Formula, Subst, PosCwa, PosOwa, NegCwa, NegOwa).

local_cwa_query_2(neg, ['-pred'(I1, I2, PName)|Formula], 
                     [pred(I1, I2, PName)|Subst],
                     [local_cwa(neg_pred('_', '_', PName))|PosCwa], 
                     [not, local_cwa(neg_pred('_', '_', PName))|PosOwa],
                     [local_cwa(neg_pred(I1, I2, PName))|NegCwa],
                     [not, local_cwa(neg_pred(I1, I2, PName))|NegOwa]) :-
  local_cwa_query_2(neg, Formula, Subst, PosCwa, PosOwa, NegCwa, NegOwa).

local_cwa_query_2(neg, ['-prop'(I, PName)|Formula], 
                     [prop(I, PName)|Subst],
                     [local_cwa(neg_prop('_', PName))|PosCwa], 
                     [not, local_cwa(neg_prop('_', PName))|PosOwa],
                     [local_cwa(neg_prop(I, PName))|NegCwa],
                     [not, local_cwa(neg_prop(I, PName))|NegOwa]) :-
  local_cwa_query_2(neg, Formula, Subst, PosCwa, PosOwa, NegCwa, NegOwa).

local_cwa_query_2(neg, ['-prop'(I1, I2, PName)|Formula], 
                     [prop(I1, I2, PName)|Subst],
                     [local_cwa(neg_prop('_', '_', PName))|PosCwa], 
                     [not, local_cwa(neg_prop('_', '_', PName))|PosOwa],
                     [local_cwa(neg_prop(I1, I2, PName))|NegCwa],
                     [not, local_cwa(neg_prop(I1, I2, PName))|NegOwa]) :-
  local_cwa_query_2(neg, Formula, Subst, PosCwa, PosOwa, NegCwa, NegOwa).

local_cwa_query_2(neg, [Literal|Literals1], [Literal|Literals2], PosCwa, PosOwa, NegCwa, NegOwa) :-
  local_cwa_query_2(neg, Literals1, Literals2, PosCwa, PosOwa, NegCwa, NegOwa). 


% ---------------------------------------------------------------------

strip_disjunction([], [], []).

strip_disjunction([Element|Elements1], [Element|Elements2], Disjuncts) :-
   \+ is_list(Element),
   strip_disjunction(Elements1, Elements2, Disjuncts).

strip_disjunction([List|Elements1], SubFormula, [List|Disjuncts]) :-
   strip_disjunction(Elements1, SubFormula, Disjuncts).


% ---------------------------------------------------------------------

compose_disjunctions(Disj1, Disj2, [Disjunctions]) :-
   append([Disj1], [';'], Disj3),
   flat_list(Disj2, Disj4),
   append(Disj3, Disj4, Disjunctions).

compose_disjunctions(Disj1, Disj2, [Disjunctions]) :-
   flat_list(Disj2, Disj3),
   append([Disj1], Disj3, Disjunctions).

flat_list(List, FlatList):-
   flat_list(List, [], FlatList).

flat_list([], FlatList, FlatList).

flat_list(';', FlatList, [';'|FlatList]).

flat_list(Item, FlatList, [Item|FlatList]) :-
   list_of_atoms(Item).

flat_list([Item|Tail], List1, Flat) :-
   flat_list(Item, List2, Flat),
   flat_list(Tail, List1, List2).

list_of_atoms([]).

list_of_atoms([Item|Tail]) :-
   \+ is_list(Item),
   list_of_atoms(Tail).


% ========================================================================
% Write Answer Set Program
%
% write_answer_set_program/2
% ========================================================================

write_answer_set_program(Stream, ASP) :-
  write(Stream, '#program base.'),
  nl(Stream),
  nl(Stream),
  write_asp(Stream, ASP).

write_asp(Stream, []).

write_asp(Stream, [[not, Term]|T]) :-
   write(Stream, 'not '),
   write_asp(Stream, Term),
   nl(Stream),
   nl(Stream),
   write_asp(Stream, T).

write_asp(Stream, [[':-', Body]|T]) :-
   write(Stream, ':- '),
   write_asp_body(Stream, Body),
   nl(Stream),
   nl(Stream),
   write_asp(Stream, T).

write_asp(Stream, [[Head, ':-', Body]|T]) :-
   write_asp_head(Stream, Head),
   write(Stream, ' :- '),
   write_asp_body(Stream, Body),
   nl(Stream),
   nl(Stream),
   write_asp(Stream, T).


write_asp(Stream, [[DisjList1, ';', DisjList2|Disjuncts]|T]) :-
   write_asp_disjunction(Stream, [DisjList1, ';', DisjList2|Disjuncts]),
   write_asp(Stream, T).


write_asp_disjunction(Stream, [[Literal1], ';', [Literal2]]) :-
   write(Stream, Literal1),
   write(Stream, ' ; '),
   write(Stream, Literal2),
   write(Stream, '.'),
   nl(Stream),
   nl(Stream).

write_asp_disjunction(Stream, [[Literal], ';'|Disjuncts]) :-
   write(Stream, Literal),
   write(Stream, ' ; '),
   write_asp_disjunction(Stream, Disjuncts).


write_asp(Stream, [H]) :-
   write(Stream, H),
   write(Stream, '.'),
   nl(Stream),
   nl(Stream).

write_asp(Stream, [H|T]) :-
   write(Stream, H),
   write(Stream, '.'),
   nl(Stream),
   nl(Stream),
   write_asp(Stream, T).


write_asp_head(Stream, [[Literal1], ';', [Literal2]]) :-
   write(Stream, Literal1),
   write(Stream, ' ; '),
   write(Stream, Literal2).

write_asp_head(Stream, [[Literal], ';'|Disjuncts]) :-
   write(Stream, Literal),
   write(Stream, ' ; '),
   write_asp_head(Stream, Disjuncts).

write_asp_head(Stream, [[Num1, '{', List1, ',', List2, '}', Num2]]) :-
   write(Stream, Num1),
   write(Stream, ' { '),
   write_asp_head_list(Stream, List1),
   write(Stream, ', '),
   write_asp_head_list(Stream, List2),
   write(Stream, ' } '),
   write(Stream, Num2).

write_asp_head(Stream, [H]) :-
   write(Stream, H).

write_asp_head(Stream, [H|T]) :-
   write(Stream, H),
   write(Stream, ' '),
   write_asp_head(Stream, T).

write_asp_head_list(Stream, [Term]) :-
   write(Stream, Term).


write_asp_head_list(Stream, [Term|Terms]) :-
   write(Stream, '('),
   write_head_list(Stream, [Term|Terms]),
   write(Stream, ')').

write_head_list(Stream, [Term]) :-
   write(Stream, Term).

write_head_list(Stream, [Term|Terms]) :-
   write(Stream, Term),
   write(Stream, ', '),
   write_head_list(Stream, Terms).


write_asp_body(Stream, [arithmetic(Expression)]) :-
   write_arithmetic_expression(Stream, Expression),
   write(Stream, '.').

write_asp_body(Stream, [arithmetic(Expression)|T]) :-
   write_arithmetic_expression(Stream, Expression),
   write(Stream, ', '), 
   write_asp_body(Stream, T).


write_asp_body(Stream, [H]) :-
   write(Stream, H),
   write(Stream, '.').


write_asp_body(Stream, [[Num1, '{', List1, ':', List2, '}']]) :-
   write(Stream, Num1),
   write(Stream, ' { '),
   write_asp_head_list(Stream, List1),  
   write(Stream, ' : '),
   write_asp_head_list(Stream, List2),  
   write(Stream, ' }.').

write_asp_body(Stream, [[Num1, '{', List1, ':', List2, '}']|T]) :-
   write(Stream, Num1),
   write(Stream, ' { '),
   write_asp_head_list(Stream, List1), 
   write(Stream, ' : '),
   write_asp_head_list(Stream, List2),  
   write(Stream, ' }, '),
   write_asp_body(Stream, T).

write_asp_body(Stream, [not|T]) :-
   write(Stream, not),
   write(Stream, ' '),
   write_asp_body(Stream, T).

write_asp_body(Stream, [H|T]) :-
   write(Stream, H),
   write(Stream, ', '), 
  %  nl(Stream),
   write_asp_body(Stream, T).


% ------------------------------------------------------------------------
% write_arithmetic_expression/2
% ------------------------------------------------------------------------

write_arithmetic_expression(Stream, [Term]) :-
   write(Stream, Term).

write_arithmetic_expression(Stream, [Term|Terms]) :-
   write(Stream, Term),
   write(Stream, ' '),
   write_arithmetic_expression(Stream, Terms).


% ------------------------------------------------------------------------
% substitute/4
% ------------------------------------------------------------------------

substitute(Old, List, New, NewList) :-
  substitute_(List, Old, New, NewList).

substitute_([], _, _, []).
substitute_([O|T0], Old, New, [V|T]) :-
  (  
    Old == O
    -> 
    V = New
  ;   
    V = O
  ),
  substitute_(T0, Old, New, T).
