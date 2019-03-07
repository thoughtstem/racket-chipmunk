#lang racket

(require racket-chipmunk
         2htdp/image
         2htdp/universe
         lang/posn)

#;(set-presolve!
 (λ(c1 c2)
   (displayln (~a "Presolve "
               (chipmunk-meta c1) " "
               (chipmunk-meta c2)))
   #t))

(set-begin!
 (λ(c1 c2)
   (displayln (~a "Begin "
               (chipmunk-meta c1) " "
               (chipmunk-meta c2)))
   #f))


#;(set-separate! (λ(c1 c2)
                 (displayln (~a "Separate "
                             (chipmunk-meta c1) " "
                             (chipmunk-meta c2)))
                 #t))

#;(set-postsolve! (λ(c1 c2)
                 (displayln (~a "Post-Solve "
                             (chipmunk-meta c1) " "
                             (chipmunk-meta c2)))
                 #t))

(define my-box-1 (box 50 50 10 10 #:meta 1))
(define my-box-2 (box-kinematic 80 50 10 10 #:meta 2))


#;(define (vel-func chipmunk gravity damping dt)
  (cpBodyUpdateVelocity (chipmunk-body chipmunk) gravity damping dt))

;(set-velocity-function! my-box-1 vel-func)
;(set-velocity-function! my-box-2 vel-func)

(set-velocity! my-box-1 50 0)

(define (create-UFO-scene time)
  (step-chipmunk (/ 1 120.0))
  (scale 2
         (place-images (list (UFO "green")
                             (UFO "red"))
                       (list (make-posn (x my-box-1) (y my-box-1))
                             (make-posn (x my-box-2) (y my-box-2)))
                       (rectangle 100 100 "solid" "white")
                       )))
 
(define (UFO c)
  (square 10 'solid c))
 
(animate create-UFO-scene)