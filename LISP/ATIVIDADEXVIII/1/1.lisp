#|
1. Crie uma estrutura de dados para pontos 2D, a qual deve possuir os campos x e y.
A: Crie uma fun ̧c ̃ao distancia (a b), a qual recebe dois pontos como parˆametro de deve retornar a
distˆancia entre eles.
B: Crie uma fun ̧c ̃ao colineares (a b c), a qual recebe trˆes pontos como parˆametro de deve retornar
se eles s ̃ao colineares ou n ̃ao. DICA: os trˆes pontos ser ̃ao colineares se o determinante de suas
coordenadas for igual a 0.
C: Crie uma fun ̧c ̃ao formaTriangulo (a b c), a qual recebe trˆes pontos como parˆametro de deve retor-
nar se eles podem ser usados para formar um triˆangulo.
|#

(defstruct ponto
	x
	y
)

(setq p1
	(make-ponto
		:x 10
		:y 5
	)
)

(setq p2
	(make-ponto
		:x 7
		:y 12
	)
)

(setq p3
	(make-ponto
		:x 4
		:y 9
	)
)

(defun distancia(a b)
	(sqrt (+ (* (- (ponto-x b) (ponto-x a))(- (ponto-x b) (ponto-x a))) (* (- (ponto-y b) (ponto-y a))(- (ponto-y b) (ponto-y a)))))
)

(defun colineares(a b c)
	(= (- (+ (* (ponto-x a) (ponto-y a)) (* (ponto-x b) (ponto-y b)) (* (ponto-x c) (ponto-y c))) (+ (* (ponto-x a) (ponto-y a)) (* (ponto-x b) (ponto-y b)) (* (ponto-x c) (ponto-y c)))) 0 )
)

(defun formaTriangulo(a b c)
	(if (colineares a b c)
		"Forma"
	"Nao forma"
	)
)

(defun main()
	(write-line (write-to-string(distancia p1 p2)))
	(write-line (write-to-string(colineares p1 p2 p3)))
	(write-line (write-to-string(formaTriangulo p1 p2 p3)))

)

(main)