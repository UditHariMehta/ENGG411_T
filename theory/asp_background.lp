% -----------------------------
% BACKGROUND THEORY: 

prop(X, Y) :- pred(X, Y, feature).

#program yes_no.
ans(ID, unknown, Pol, cwa) :- ans_id(ID, yes_no, Pol), not ans(ID, _, Pol, owa), not ans(ID, yes, Pol, cwa), not ans(ID, no, Pol, cwa).
ans(ID, unknown, Pol, owa) :- ans_id(ID, yes_no, Pol), not ans(ID, _, Pol, cwa), not ans(ID, yes, Pol, owa), not ans(ID, no, Pol, owa). 

#program how_many.
ans(ID, Num, Pol, cwa)  :- ans_id(ID, how_many, Pol), not eval(ID, _, Pol, owa), Num > 0, Num = #count { I : eval(ID, I, Pol, cwa) }.
ans(ID, Num, Pol, owa)  :- ans_id(ID, how_many, Pol), not eval(ID, _, Pol, cwa), Num > 0, Num = #count { I : eval(ID, I, Pol, owa) }.
ans(ID, Num, Pol, nil)  :- ans_id(ID, how_many, Pol), Num = 0, Num = #count { I : eval(ID, I, Pol, _) }.

% ans(ID, Num, neg, cwa)      :- ans_id(ID, how_many, neg), Num = #count { I : eval(ID, I, neg, cwa) }.
% ans(ID, Num, neg, owa)      :- ans_id(ID, how_many, neg), Num = #count { I : eval(ID, I, neg, owa) }.

#program most.
ans(ID, yes, pos, cwa) :- ans_id(ID, most, pos), C1 > C2, C1 = #count { I1 : eval(ID, I1, pos, cwa) }, C2 = #count { I2 : eval(ID, I2, neg, cwa) }.
ans(ID, no,  pos, cwa) :- ans_id(ID, most, pos), C1 < C2, C1 = #count { I1 : eval(ID, I1, pos, cwa) }, C2 = #count { I2 : eval(ID, I2, neg, cwa) }.
ans(ID, yes, pos, owa) :- ans_id(ID, most, pos), C1 > C2, C1 = #count { I1 : eval(ID, I1, pos, owa) }, C2 = #count { I2 : eval(ID, I2, neg, owa) }.
ans(ID, no,  pos, owa) :- ans_id(ID, most, pos), C1 < C2, C1 = #count { I1 : eval(ID, I1, pos, owa) }, C2 = #count { I2 : eval(ID, I2, neg, owa) }.
ans(ID, yes, neg, cwa) :- ans_id(ID, most, neg), C1 < C2, C1 = #count { I1 : eval(ID, I1, pos, cwa) }, C2 = #count { I2 : eval(ID, I2, neg, cwa) }.
ans(ID, no,  neg, cwa) :- ans_id(ID, most, neg), C1 > C2, C1 = #count { I1 : eval(ID, I1, pos, cwa) }, C2 = #count { I2 : eval(ID, I2, neg, cwa) }.
ans(ID, yes, neg, owa) :- ans_id(ID, most, neg), C1 < C2, C1 = #count { I1 : eval(ID, I1, pos, owa) }, C2 = #count { I2 : eval(ID, I2, neg, owa) }.
ans(ID, no,  neg, owa) :- ans_id(ID, most, neg), C1 > C2, C1 = #count { I1 : eval(ID, I1, pos, owa) }, C2 = #count { I2 : eval(ID, I2, neg, owa) }.
ans(ID, unknown, Pol, nil)  :- ans_id(ID, most, Pol), not ans(ID, yes, _, _), not ans(ID, no, _, _).

#program what.
ans(ID, unknown, Pol, nil)  :- ans_id(ID, what, Pol), not ans(ID, _, Pol, cwa), not ans(ID, _, Pol, owa).
query(Inst, what, Class)    :- inst(Inst, Class), not -is_leaf(Class).
query(Inst, what, nil)      :- const(Inst), not is_defined(Inst).

#program which.
ans(ID, unknown, Pol, nil) :- ans_id(ID, which, Pol), not ans(ID, _, Pol, cwa), not ans(ID, _, Pol, owa).
ans(ID, inconsistent, Pol, nil) :- ans_id(ID, which, Pol), ans(ID, _, Pol, cwa), ans(ID, _, Pol, owa).

#program who.
ans(ID, unknown, Pol, nil) :- ans_id(ID, who, Pol), not ans(ID, _, Pol, cwa), not ans(ID, _, Pol, owa).
query(Inst, who, Class)    :- inst(Inst, Class), not -is_leaf(Class).
query(Inst, who, nil)      :- const(Inst), not is_defined(Inst).

#program who_rel.
ans(ID, unknown, Pol, nil) :- ans_id(ID, who, Pol), not ans(ID, _, Pol, cwa), not ans(ID, _, Pol, owa).
query(Inst, who, Class) :- inst(Inst, Class), not -is_leaf(Class).
query(Inst, who, nil)   :- const(Inst), not is_defined(Inst).

#program where.
ans(ID, unknown, Pol, nil) :- ans_id(ID, who, Pol), not ans(ID, _, Pol, cwa), not ans(ID, _, Pol, owa).
query(Inst, where, Class)  :- inst(Inst, Class), not -is_leaf(Class).
query(Inst, where, nil)    :- const(Inst), not is_defined(Inst).

#program is_subclass.
subclass(Class1, Class2) :- is_subclass(Class1, Class2).
subclass(Class1, Class3) :- is_subclass(Class1, Class2), subclass(Class2, Class3).
-is_leaf(Class2) :- subclass(Class1, Class2).
is_defined(Inst) :- inst(Inst, Class), not -is_leaf(Class).

#program event_calculus.
holds_at(F, T2)  :- time_point(T1), time_point(T2), initiates(E, F, T1), T1 < T2, not clipped(T1, F, T2).
clipped(T1,F,T2) :- time_point(T), time_point(T1), time_point(T2), terminates(E, F, T), T1 < T, T < T2.
time_point(T+1)  :- initiates(E, F, T+1).  

