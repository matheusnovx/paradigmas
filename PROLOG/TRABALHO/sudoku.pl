:- use_module(library(clpfd)).

sudoku(Rows) :-
    length(Rows, 9), maplist(same_length(Rows), Rows), % Criando o sudoku
    append(Rows, Vs), Vs ins 1..9,
    maplist(all_distinct, Rows), % Verificando se todas as linhas são distintas
    transpose(Rows, Columns),
    maplist(all_distinct, Columns), % Verificando se todas as colunas são distintas
    Rows = [As,Bs,Cs,Ds,Es,Fs,Gs,Hs,Is], % Todas as nove linhas
    blocks(As, Bs, Cs), % Criando os 9 blocos
    blocks(Ds, Es, Fs),
    blocks(Gs, Hs, Is).

% Cria os blocos do sudoku
blocks([], [], []).
blocks([N1,N2,N3|Ns1], [N4,N5,N6|Ns2], [N7,N8,N9|Ns3]) :-
        all_distinct([N1,N2,N3,N4,N5,N6,N7,N8,N9]),
        blocks(Ns1, Ns2, Ns3).


% X esquerda de Y
aEsquerda(X,Y,Rows) :- nth0(IndexX,Rows,X), nth0(IndexY,Rows,Y),
                        IndexX < IndexY.

% X direita de Y
aDireita(X,Y,Rows) :- aEsquerda(Y,X,Rows).

% X a baixo de Y
aBaixo(X,Y,Columns) :- nth0(IndexX,Columns,X), nth0(IndexY,Columns,Y),
                        IndexX < IndexY.

% X acima de Y
aCima(X,Y,Columns) :- aBaixo(Y,X,Columns).

% Funções auxiliares para a testar o maior
add(X,[],[X]).
add(X,[H|T],[H|T2]) :- X > H, add(X,T,T2).
add(X,[H|T],[X,H|T]) :- X =< H.

ordenacao([],[]).
ordenacao([H|T],LResultado) :- ordenacao(T,LResultadoCauda), add(H,LResultadoCauda,LResultado).

ultimo([X], X).
ultimo([H,H2|T], X) :- ultimo([H2|T],X).

maior([],0).
maior(L, X) :- ordenacao(L, R), ultimo(R,X).

% -------------------------Tabuleiros-------------------------------

problem(1, [[_,_,_,_,_,_,_,_,_],
            [_,_,_,_,_,_,_,_,_],
            [_,_,_,_,_,_,_,_,_],
            [_,_,_,_,_,_,_,_,_],
            [_,_,_,_,_,_,_,_,_],
            [_,_,_,_,_,_,_,_,_],
            [_,_,_,_,_,_,_,_,_],
            [_,_,_,_,_,_,_,_,_],
            [_,_,_,_,_,_,_,_,_]]).

tabuleiro( [[[3, 1, 3, 1], [2, 1, 3, 2], [2, 3, 3, 1], [3, 1, 3, 2], [2, 2, 3, 2], [1, 3, 3, 2], [3, 1, 3, 1], [2, 2, 3, 1], [1, 3, 3, 2]],
            [[3, 2, 2, 2], [1, 1, 1, 1], [2, 3, 2, 2], [3, 1, 1, 1], [2, 2, 1, 1], [1, 3, 1, 1], [3, 1, 2, 1], [2, 2, 2, 1], [1, 3, 1, 2]],
            [[3, 2, 1, 3], [1, 2, 2, 3], [1, 3, 1, 3], [3, 1, 2, 3], [2, 1, 2, 3], [2, 3, 2, 3], [3, 1, 2, 3], [2, 2, 2, 3], [1, 3, 1, 3]],
            [[3, 2, 3, 1], [1, 1, 3, 1], [2, 3, 3, 1], [3, 2, 3, 2], [1, 2, 3, 2], [1, 3, 3, 2], [3, 2, 3, 2], [1, 1, 3, 1], [2, 3, 3, 1]],
            [[3, 1, 2, 1], [2, 2, 2, 2], [1, 3, 2, 1], [3, 2, 1, 2], [1, 2, 1, 2], [1, 3, 1, 2], [3, 1, 1, 1], [2, 1, 2, 2], [2, 3, 2, 1]],
            [[3, 2, 2, 3], [1, 2, 1, 3], [1, 3, 2, 3], [3, 2, 1, 3], [1, 2, 1, 3], [1, 3, 1, 3], [3, 1, 2, 3], [2, 1, 1, 3], [2, 3, 2, 3]],
            [[3, 1, 3, 1], [2, 2, 3, 2], [1, 3, 3, 1], [3, 2, 3, 2], [1, 1, 3, 2], [2, 3, 3, 2], [3, 2, 3, 1], [1, 1, 3, 1], [2, 3, 3, 1]],
            [[3, 2, 2, 1], [1, 1, 1, 1], [2, 3, 2, 1], [3, 2, 1, 1], [1, 1, 1, 1], [2, 3, 1, 2], [3, 2, 2, 2], [1, 2, 2, 2], [1, 3, 2, 2]],
            [[3, 1, 2, 3], [2, 1, 2, 3], [2, 3, 2, 3], [3, 2, 2, 3], [1, 1, 2, 3], [2, 3, 1, 3], [3, 2, 1, 3], [1, 1, 1, 3], [2, 3, 1, 3]]]).

%----------------------------Main-----------------------------------

:- initialization(main).
main :- problem(1, Rows), sudoku(Rows), maplist(portray_clause, Rows), !.
        
        
