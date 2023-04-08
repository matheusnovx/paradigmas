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

;getValue
;(aref a 0 0)  permite acessar uma posição i j da matrix, neste caso acesso a posição 0,0 da matrix a

;setValue
;(nth n list)

(defun replaceline (matrix value i j)
    (setq newMatrix matrix)
    (setf (aref newMatrix i j) value)
    newMatrix
)

(defun getMatrixMax(matrix)
    (setq maxi -1)
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

(defun getMatrixSize (matrix)
    (car(array-dimensions matrix))
)

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

(defun alreadyInRegionLine (inputVector regionVector regionID value)
    (if (and (null inputVector) (null regionVector))
        NIL
        (if (and (= (car regionVector) regionID) (= (car inputVector) value))
            t
            (alreadyInRegionLine (cdr inputVector) (cdr regionVector) regionID value)
        )
    )
)

(defun alreadyInRegionMatrix (tabuleiro regioes regionID value)
    (dotimes (i (car(array-dimensions tabuleiro)))
        (dotimes (j (car(array-dimensions tabuleiro)))
            (if (and (= (aref regioes i j) regionID) (= (aref tabuleiro i j) value))
                T
            )
        )
    )
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

(defun backtrackingCaller (matrix)
    (setq regionMatrix regioes)
    (setq sizeVector (getSizeVector regionMatrix))
    (backtrackingMain matrix regionMatrix sizeVector 0 0 1)
)

(defun backtrackingMain (inputMatrix regionMatrix regionVector i j testNumber)
    (cond
        ((> testNumber (searchVectorWithMatrixValue regionMatrix regionVector i j)) inputMatrix)
        ((backtrackingCheck inputMatrix regionMatrix i j testNumber) 
            (progn
                (setq newInputMatrix (replaceline inputMatrix testNumber i j))
                (backtrackingFindNextPos inputMatrix newInputMatrix regionMatrix regionVector i j testNumber)
            )
        )
        ((= (aref inputMatrix i j) 0) (backtrackingMain inputMatrix regionMatrix regionVector i j (+ testNumber 1)))
        (t (backtrackingTestNewNumber inputMatrix regionMatrix regionVector i j testNumber))
    )
)

(defun backtrackingCheck (inputMatrix regionMatrix i j testNumber)
    (cond
        ((= (aref inputMatrix i j) 0)
            (progn
                (if (or (validateNeighbors inputMatrix testNumber i j)
                         (alreadyInRegionMatrix inputMatrix regionMatrix (aref regionMatrix i j) testNumber))
                    NIL
                    t
                )
            )
        )
        (t NIL)
    )
)

(defun backtrackingTestNewNumber(inputMatrix regionMatrix regionVector i j testNumber)
    (cond
        ((and (= (+ i 1) (getMatrixSize inputMatrix)) (= (+ j 1) (getMatrixSize inputMatrix)))
            inputMatrix
        )
        ((= (+ i 1) (getMatrixSize inputMatrix))
            (backtrackingMain inputMatrix regionMatrix regionVector 0 (+ j 1) 1)
        )
        (t (backtrackingMain inputMatrix regionMatrix regionVector (+ i 1) j 1))
    )
)

(defun backtrackingValidate (matrix inputMatrix newInputMatrix regionMatrix regionVector i j testNumber)
    (cond
        ((equalMatrix newInputMatrix matrix)
            (backtrackingMain inputMatrix regionMatrix regionVector i j (+ testNumber 1))
        )
        (t matrix)
    )
)

(defun backtrackingFindNextPos(inputMatrix newInputMatrix regionMatrix regionVector i j testNumber)
    (cond
        ((and ( = (+ i 1) (getMatrixSize inputMatrix)) (= (+ j 1) (getMAtrixSize inputMatrix)))
            newInputMatrix
        )
        ((= (+ i 1) (getMatrixSize inputMatrix))
            (backtrackingValidate (backtrackingMain newInputMatrix regionMatrix regionVector 0 (+ j 1) 1)
                                    inputMatrix
                                    newInputMatrix
                                    regionMatrix
                                    regionVector
                                    i
                                    j
                                    testNumber
            )
        )
        (t (backtrackingValidate (backtrackingMain newInputMatrix regionMatrix regionVector (+ i 1) j 1)
                                inputMatrix
                                newInputMatrix
                                regionMatrix
                                regionVector
                                i
                                j
                                testNumber
            )
        )
    )
)

(defun main()
    (write-line (write-to-string (backtrackingCaller tabuleiro)))
)

(main)