;getValue
;(aref a 0 0)  permite acessar uma posição i j da matrix, neste caso acesso a posição 0,0 da matrix a

;setValue
;(nth n list)

(defun replaceline (matrix value i j)
    (setq newMatrix matrix)
    (setq value (aref newMatrix 0 0))
    newMatrix
)

(defun getMatrixMax(matrix)
    (setq maxi 0)
    (dotimes (i (car(array-dimensions matrix)))
        (dotimes (j (car(array-dimensions matrix)))
            (if (> (aref matrix i j) maxi)
                (setq maxi (aref matrix i j))
            )
        )
    )
    maxi
)

(defun getRegionAmount(matrix)
    (+ (getMatrixMax matrix) 1)
)

;getMatrixSize
;(car(array-dimensions matrix))

(defun searchVectorWithMatrixValue(matrix vetor i j)
    (nth (aref matrix i j) vetor)
)

(defun getMatrixOcurrences(matrix value)
    (setq n 0)
    (dotimes (i (car(array-dimensions matrix)))
        (dotimes (j (car(array-dimensions matrix)))
            (if (= (aref matrix i j) value)
                (setq n (+ n 1))
            )
        )
    )
    n
)

(defun makeSizeVector(matrix regionValue regAmount)
    (if (= regionValue regAmount)
        '()
        (append (list (getMatrixOcurrences matrix regionValue)) (makeSizeVector matrix (+ regionValue 1) regAmount))
    )
)

(defun getSizeVector (matrix)
    (setq x (getRegionAmount matrix))
    (if (null matrix)
        '()
        (makeSizeVector matrix 0 x)
    )
)

(defun inBounds (matrix value i j)
    (cond
        ((< i 0) NIL)
        ((< j 0) NIL)
        ((>= i (car(array-dimensions matrix))) NIL)
        ((>= j (car(array-dimensions matrix))) NIL)
        ((= value (aref matrix i j)) T)
        (T NIL)
    )
)

(defun validateNeighbors (matrix value i j)
    (setq a (inBounds matrix value i (- j 1)))
    (setq b (inBounds matrix value i (+ j 1)))
    (setq c (inBounds matrix value (- i 1) j))
    (setq d (inBounds matrix value (+ i 1) j))
    (setq e (inBounds matrix value (- i 1) (- j 1)))
    (setq f (inBounds matrix value (- i 1) (+ j 1)))
    (setq g (inBounds matrix value (+ i 1) (- j 1)))
    (setq h (inBounds matrix value (+ i 1) (+ j 1)))
    (or a b c d e f g h)
)

(defun alreadyInRegionMatrix (tabuleiro regioes regionID value)
    (setq res NIL)
    (dotimes (i (car(array-dimensions tabuleiro)))
        (dotimes (j (car(array-dimensions tabuleiro)))
            (if (and (= (aref regioes i j)) (= (aref tabuleiro i j) value))
                (setq res T)
            )
        )
    )
    res
)

(defun equalMatrix (m1 m2)
    (setq igual T)
    (dotimes (i (car(array-dimensions tabuleiro)))
        (dotimes (j (car(array-dimensions tabuleiro)))
            (if (/= (aref m1 i j) (aref m2 i j))
                (setq igual NIL)
            )
        )
    )
    igual
)

;PARA DEBUG APENAS

(defun main ()
    (setf tabuleiro (make-array '(7 7)
        :initial-contents '(
            (3 0 2 0 0 1 2) 
            (0 0 0 0 0 0 0) 
            (0 0 0 0 0 0 5) 
            (0 0 0 0 0 0 1)
            (0 0 0 0 1 0 0)
            (0 0 0 0 0 0 4)
            (0 4 0 0 0 0 0)
            ))
    )

    (setf tabuleiro2 (make-array '(7 7)
        :initial-contents '(
            (3 0 2 0 0 1 2) 
            (0 0 0 0 0 0 0) 
            (0 0 0 0 0 0 5) 
            (0 0 0 0 0 0 1)
            (0 0 0 0 1 0 0)
            (0 0 0 0 0 0 4)
            (0 4 0 0 0 0 0)
            ))
    )

    
    (setf regioes (make-array '(7 7)
    :initial-contents '(
        (0 0 0 0 1 1 1) 
        (0 2 2 2 3 1 1) 
        (4 2 2 3 3 3 5) 
        (4 4 4 6 3 5 5)
        (4 8 6 6 6 5 5)
        (7 8 8 6 9 9 9)
        (7 8 8 9 9 10 10)
        ))
    )

    (write-line(write-to-string (equalMatrix tabuleiro regioes)))
)

(main)