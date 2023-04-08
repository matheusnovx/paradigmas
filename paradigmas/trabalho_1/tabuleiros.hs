module Tabuleiros where

{-
    region
    Função complementar ao tabuleiro
    Números iguais representam uma mesma região
    Parametros:
        Tamanho do tabuleiro
    Retorno = Matriz de regiões
-}
region::Int -> [[Int]]
region 7 = [
    [0,0,0,0,1,1,1],
    [0,2,2,2,3,1,1],
    [4,2,2,3,3,3,5],
    [4,4,4,6,3,5,5],
    [4,8,6,6,6,5,5],
    [7,8,8,6,9,9,9],
    [7,8,8,9,9,10,10]]

{-
    tabuleiro
    Entrada do programa contendo os números presentes no tabuleiro
    Espaços vazios são representados por zeros
    Parametros:
        Tamanho do tabuleiro desejado
    Retorno = Matriz Tabuleiro
-}
tabuleiro::Int -> [[Int]]
tabuleiro 7 = [
    [3,0,2,0,0,1,2],
    [0,0,0,0,0,0,0],
    [0,0,0,0,0,0,5],
    [0,0,0,0,0,0,1],
    [0,0,0,0,1,0,0],
    [0,0,0,0,0,0,4],
    [0,4,0,0,0,0,0]]