genitor(pam, bob).
genitor(tom, bob).
genitor(tom, liz).

genitor(bob, ana).
genitor(bob, pat).

genitor(liz,bill).

genitor(pat, jim).

mulher(pam).
mulher(liz).
mulher(pat).
mulher(ana).
homem(tom).
homem(bob).
homem(jim).
homem(bill).

pai(X,Y) :- genitor(X,Y), homem(X).
mae(X,Y) :- genitor(X,Y), mulher(X).

%Funcoes novas
tio(X,Y) :- irmao(X,Z), genitor(Z,Y).                                   %tio(X,Y), onde X  ́e o tio de Y.
tia(X,Y) :- irma(X,Z), genitor(Z,Y).                                    %tia(X,Y), onde X  ́e a tia de Y.
primo(X,Y) :- (tia(Z,Y);tio(Z,Y)), (pai(Z,X);mae(Z,X)), homem(X).       %primo(X,Y), onde X  ́e o primo de Y
prima(X,Y) :- (tia(Z,Y);tio(Z,Y)), (pai(Z,X);mae(Z,X)), mulher(X).      %prima(X,Y), onde X  ́e o prima de Y
primos(X,Y) :- (tia(Z,Y);tio(Z,Y)), (pai(Z,X);mae(Z,X)).                %primos(X,Y), onde X  ́e o primo;prima de Y
bisavo(X, Y) :- genitor(X, Z),genitor(Z, S), genitor(S, Y), homem(X).   %bisavo(X,Y), onde X  ́e o bisavˆo de Y
bisavoh(X, Y) :- genitor(X, Z),genitor(Z, S), genitor(S, Y), mulher(X). %bisavo(X,Y), onde X  ́e o bisavˆo de Y

avo(AvoX, X) :- genitor(GenitorX, X), genitor(AvoX, GenitorX), homem(AvoX).
avoh(AvohX, X) :- genitor(GenitorX, X), genitor(AvohX, GenitorX), mulher(AvohX).
irmao(X,Y) :- genitor(PaiAmbos, X), genitor(PaiAmbos, Y), X \== Y, homem(X).
irma(X,Y) :- genitor(PaiAmbos, X), genitor(PaiAmbos, Y), X \== Y, mulher(X).
irmaos(X,Y) :- (irmao(X,Y); irma(X,Y)), X \== Y.

ascendente(X,Y) :- genitor(X,Y). %recursão - caso base
ascendente(X,Y) :- genitor(X, Z), ascendente(Z, Y). %recursão - passo recursivo
