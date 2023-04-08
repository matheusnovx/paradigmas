add(X,[],[X]).
add(X,[H|T],[H|T2]) :- X > H, add(X,T,T2).
add(X,[H|T],[X,H|T]) :- X =< H.

ordenacao([],[]).
ordenacao([H|T],LResultado) :- ordenacao(T,LResultadoCauda), add(H,LResultadoCauda,LResultado).

ultimo([X], X).
ultimo([H,H2|T], X) :- ultimo([H2|T],X).

maior([],0).
maior(L, X) :- ordenacao(L, R), ultimo(R,X).