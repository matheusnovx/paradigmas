module Main (main) where

import Funcjogo
import Tabuleiros
{-
    printMatrix
    Imprime as linhas da matriz de forma mais legível
    Parametros:
        Matriz
    Retorno = print na tela
-}
printMatrix :: [[Int]] -> IO()
printMatrix [] = print "\n"
printMatrix (a:b) = do
    print a
    printMatrix b

main = do
    printMatrix (backtrackingCaller (tabuleiro 7))