% Passageiros
passageiro(cicero).
passageiro(vitor).
passageiro(william).
passageiro(gustavo).

% Cor da mala
mala(azul).
mala(preta).
mala(verde).
mala(vermelha).

% Destino
destino(bahia).
destino(matogrosso).
destino(minasgerais).
destino(para).

% Horario
horario(8).
horario(8.5).
horario(9).
horario(9.5).

% Funcoes 

antes(X, Y, Lista) :- nth0(IndexX, Lista, X), nth0(IndexY, Lista, Y)
                      IndexX < 


todosDiferentes([]).
todosDiferentes([H|T]) :- not(member(H,T)), todosDiferentes(T).


solucao(ListaSolucao) :- 

    ListaSolucao = [
        passageiros(Passageiro1, Mala1, Destino1, Horario1),
        passageiros(Passageiro2, Mala2, Destino2, Horario2),
        passageiros(Passageiro3, Mala3, Destino3, Horario3),
        passageiros(Passageiro4, Mala4, Destino4, Horario4)
    ],

    % William vai para Minas Gerais ou é dono da mala preta
    %member(passageiros(william; preta; minasgerais, _)),

    % O voo do passageiro da mochila verde é meia hora antes do voo do passageiro que vai para 
    % o estado nordestino

    % Cicero vai para Minas
    %member(passageiros(cicero, _, minasgerais, _)),

    % O voo com destino a MG saira antes que o voo do passageiro da mochila verde

    % O voo do passageiro da mala preta é meia hora depois do voo para o pará 

    % O voo do William sairá antes que o voo do passageiro da mala azul 

    % O voo do Vitor sairá depois que o voo para o Pará

    
    
    % Testando as possibilidades

    passageiro(Passageiro1), passageiro(Passageiro2), passageiro(Passageiro3), passageiro(Passageiro4), 
    todosDiferentes([Passageiro1, Passageiro2, Passageiro3, Passageiro4]),

    mala(Mala1), mala(Mala2), mala(Mala3), mala(Mala4), 
    todosDiferentes([Mala1, Mala2, Mala3, Mala4]),

    destino(Destino1), destino(Destino2), destino(Destino3), destino(Destino4),
    todosDiferentes([Destino1, Destino2, Destino3, Destino4]),

    horario(Horario1), horario(Horario2), horario(Horario3), horario(Horario4),
    todosDiferentes([Horario1, Horario2, Horario3, Horario4]).