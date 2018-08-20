% -----------------------------
% BACKGROUND THEORY: 

subclass(Class1, Class2) :- is_subclass(Class1, Class2).
subclass(Class1, Class3) :- is_subclass(Class1, Class2), subclass(Class2, Class3).

-is_leaf(Class2) :- subclass(Class1, Class2).

is_defined(Instance) :- inst(Instance, Class), not -is_leaf(Class).

query(Instance, who, Class) :- inst(Instance, Class), not -is_leaf(Class).
query(Instance, who, nil)   :- const(Instance), not is_defined(Instance).
