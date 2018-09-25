#lang racket

(require 2htdp/image
         lang/posn)
(require 2htdp/universe)
(require racket-chipmunk)

(begin

  (define ground
    (box-kinematic 25 100 25 5 
                   #:meta 'black))

  (define ground2
    (box-kinematic 50 100 25 5 
                   #:meta 'gray))

  (set-velocity-function! ground (λ(chipmunk gravity damping dt)
                                   (set-velocity! chipmunk 0 -10)))

  (set-velocity-function! ground2 (λ(chipmunk gravity damping dt)
                                    (set-velocity! chipmunk 0 -5)))


  (define boxes
    (list
     (box  60.0 22.0 3 3 #:meta 'green)
     (box  61.0 21.0 3 3 #:meta 'blue)
     (box  62.0 20.0 3 3
           #:meta 'yellow)
     (box  63.0 16.0 3 3) ; #:user-data 42)
     (box  63.0 17.0 3 3)
     (box  63.0 18.0 3 3)
     (box  63.0 19.0 3 3)
     (box  63.0 70.0 3 3 #:meta 'orange)
     ground
     ground2))

  (define (on-collide c1 c2)
    #;(displayln (list c1 c2))
    #t)

  (set-presolve! (lambda(c1 c2)
                   (displayln (map get-data (list c1 c2)))))

  (define *tick-rate* (/ 1 120.0))
  (define *canvas* (square 100 'solid 'white))

  (define (box->color b)
    (or (chipmunk-meta b) 'red))

  (define (render-box b)
    (rotate (* -57.29 (angle b))
            (rectangle (w b) (h b) 'solid (box->color b))))

  (define (box->posn b)
    (make-posn (x b)
               (y b)))

  (big-bang
      0
    [on-tick (lambda (state)
               (step-chipmunk *tick-rate*)
               (+ state 1))
             *tick-rate*]
    [on-draw (lambda (state)
               (scale 6
                      (place-images
                       (map render-box boxes)
                       (map box->posn boxes)
                       *canvas*)))]))


