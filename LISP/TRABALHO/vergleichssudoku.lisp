;Matheus Paulon Novais 20203078


; Defino tanto o tabuleiro de entrada quando o tabuleiro zerado como variaveis globais para nao precisar passar como parametro em todas as funcoes
(defvar board
  #2a((0 0 0 0 0 0 0 0 0)
      (0 0 0 0 0 0 0 0 0)
      (0 0 0 0 0 0 0 0 0)
      (0 0 0 0 0 0 0 0 0)
      (0 0 0 0 0 0 0 0 0)
      (0 0 0 0 0 0 0 0 0)
      (0 0 0 0 0 0 0 0 0)
      (0 0 0 0 0 0 0 0 0)
      (0 0 0 0 0 0 0 0 0)))

(defvar entrada (make-array '(9 9) 
   :initial-contents  '(((3  1  3  1)  (2  1  3  2)  (2  3  3  1)  (3  1  3  2)  (2  2  3  2)  (1  3  3  2)  (3  1  3  1)  (2  2  3  1)  (1  3  3  2)) 
                        ((3  2  2  2)  (1  1  1  1)  (2  3  2  2)  (3  1  1  1)  (2  2  1  1)  (1  3  1  1)  (3  1  2  1)  (2  2  2  1)  (1  3  1  2)) 
                        ((3  2  1  3)  (1  2  2  3)  (1  3  1  3)  (3  1  2  3)  (2  1  2  3)  (2  3  2  3)  (3  1  2  3)  (2  2  2  3)  (1  3  1  3)) 
                        ((3  2  3  1)  (1  1  3  1)  (2  3  3  1)  (3  2  3  2)  (1  2  3  2)  (1  3  3  2)  (3  2  3  2)  (1  1  3  1)  (2  3  3  1)) 
                        ((3  1  2  1)  (2  2  2  2)  (1  3  2  1)  (3  2  1  2)  (1  2  1  2)  (1  3  1  2)  (3  1  1  1)  (2  1  2  2)  (2  3  2  1)) 
                        ((3  2  2  3)  (1  2  1  3)  (1  3  2  3)  (3  2  1  3)  (1  2  1  3)  (1  3  1  3)  (3  1  2  3)  (2  1  1  3)  (2  3  2  3)) 
                        ((3  1  3  1)  (2  2  3  2)  (1  3  3  1)  (3  2  3  2)  (1  1  3  2)  (2  3  3  2)  (3  2  3  1)  (1  1  3  1)  (2  3  3  1)) 
                        ((3  2  2  1)  (1  1  1  1)  (2  3  2  1)  (3  2  1  1)  (1  1  1  1)  (2  3  1  2)  (3  2  2  2)  (1  2  2  2)  (1  3  2  2)) 
                        ((3  1  2  3)  (2  1  2  3)  (2  3  2  3)  (3  2  2  3)  (1  1  2  3)  (2  3  1  3)  (3  2  1  3)  (1  1  1  3)  (2  3  1  3)))) ;inicializando a matriz com alguns valores
)

; Chuta o numero que vai ser colocado em cada vasa
(defun guess (index)
    (let ((row (truncate index 9)) ; define a linha e coluna como 9x9(tamanho do tabuleiro)
        (col (mod index 9)))
    (cond
        ((or (>= row 9) (>= col 9)) t)
        ((plusp (aref board row col)) (guess (1+ index))) ; verifica se é maior que zero
        (t
        (dotimes (i 9 (fail row col)) ; insere os numeros no tabuleiro, caso de errado zera o numero e tenta o proximo
        (when (check (1+ i) row col)
            (setf (aref board row col) (1+ i))
            (when (guess (1+ index)) (return t))))))))

; Caso o processo de checagem indique um erro, zera o numero na matriz
(defun fail (row col) 
    (setf (aref board row col) 0)
    nil)

; Processo de checagem, testa linha, coluna, caixa e os simbolos
; retorna NIL(False) caso de errado para poder refazer os passos
(defun check (num row col)
    (let ((r (* (truncate row 3) 3)) ; define as caixas
        (c (* (truncate col 3) 3)))
    (dotimes (i 9 t)
        (when (or (= num (aref board row i))                ; testa linha
                (= num (aref board i col))                  ; testa coluna
                (mapArray num row col)                      ; testa os simbolos
                (= num (aref board (+ r (mod i 3))          ; por ultimo testa as caixas
                                (+ c (truncate i 3)))))
        (return nil)))))

; Usa um mapeamento, a partir de lambda, para validar os simbolos
; passa primeiro o vetor da casa atual do sudoku e usa uma lista de auxilio para identificar as posicoes
(defun mapArray (value i j)
    (map 'list (lambda (a b) (validate a b value i j)) (aref entrada i j) '(1 2 3 4))
)

; Validada os simbolos e utiliza a lista auxiliar para saber se testa esquerda, direita, cima ou baixo da casa atual 
(defun validate (a b value i j) 
    (cond 
        ((= b 1) (cond ; esquerda
                    ((= a 1) (if (inBounds value i (- j 1))
                                (if (< (aref board i j) (aref board i (- j 1))) T NIL)
                                T   
                            )) ; nao pode ser maior
                    ((= a 1) (if (inBounds value i (- j 1))
                                (if (> (aref board i j) (aref board i (- j 1))) T NIL)
                                T   
                            )); nao pode ser menor
                    ((= a 3) T)  ; nada acontece
                 )) 
        ((= b 2) (cond ; direita 
                    ((= a 1) (if (inBounds value i (+ j 1))
                                (if (< (aref board i j) (aref board i (+ j 1))) T NIL)
                                T   
                            )) ; nao pode ser maior
                    ((= a 1) (if (inBounds value i (+ j 1))
                                (if (> (aref board i j) (aref board i (+ j 1))) T NIL)
                                T   
                            )) ; nao pode ser menor
                    ((= a 3) T)  ; nada acontece
                 ))
        ((= b 3) (cond ; cima 
                    ((= a 1) (if (inBounds value (- i 1) j)
                                (if (< (aref board i j) (aref board (- i 1) j)) T NIL)
                                T   
                            )) ; nao pode ser maior
                    ((= a 1) (if (inBounds value (- i 1) j)
                                (if (> (aref board i j) (aref board (- i 1) j)) T NIL)
                                T   
                            )); nao pode ser menor
                    ((= a 3) T)  ; nada acontece
                 ))
        ((= b 4) (cond ; baixo
                    ((= a 1) (if (inBounds value (+ i 1) j)
                                (if (< (aref board i j) (aref board (+ i 1) j)) T NIL)
                                T   
                            )) ; nao pode ser maior
                    ((= a 1) (if (inBounds value (+ i 1) j)
                                (if (> (aref board i j) (aref board (+ i 1) j)) T NIL)
                                T   
                            )); nao pode ser menor
                    ((= a 3) T)  ; nada acontece
                 ))   
    )
)

; Verifica se o vizinho está dentro da matriz
(defun inBounds (value i j)
    (cond
        ((< i 0) NIL)
        ((< j 0) NIL)
        ((>= i (car(array-dimensions board))) NIL)
        ((>= j (car(array-dimensions board))) NIL)
        ((= value (aref board i j)) T)
        (T NIL)
    )
)

; Imprime o tabuleiro ao final de tudo
(defun print-board ()
    (dotimes (r 9)
    (if (zerop (mod r 3))
        (format t " ~%~%") 
        (format t " ~%~%"))
    (dotimes (c 9)
        (if (= 2 (mod c 3))
            (format t " ~a " (aref board r c))
        (format t " ~a  " (aref board r c)))))
    (format t " ~%~%~%"))

; Inicia o processo, chama a impressao do tabuleiro e caso nao tenha solucao informa
(defun solve ()
    (if (guess 0) (print-board)
    (format t "Solução não encontrada")))

(defun main()
    (solve)
)

(main)