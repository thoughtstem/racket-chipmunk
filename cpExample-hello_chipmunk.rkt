#lang racket

(require 2htdp/image
         lang/posn)
(require 2htdp/universe)
(require "chipmunk-ffi.rkt")


(define *gravity
  (cpv 0.0 100.0))

(define *space
  (cpSpaceNew))

(cpSpaceSetGravity *space *gravity)

(define *ground-start* (cpv 40.0 85.0))
(define *ground-end* (cpv 80.0 95.0))

(define *ground
  (cpSegmentShapeNew (cpSpaceGetStaticBody *space) *ground-start* *ground-end* 0.0))

(cpShapeSetFriction *ground 1.0)

(void (cpSpaceAddShape *space *ground))

(define radius 2.5)
(define mass 1.0)

(define moment
  (cpMomentForCircle mass 0.0 radius (cpv 0.0 0.0)))

(define boxMoment
  (cpMomentForBox mass 0.0 radius ))

(define (new-ball v)
  (define body (cpSpaceAddBody *space (cpBodyNew mass moment)))
  (define shape (cpSpaceAddShape *space (cpCircleShapeNew body radius (cpv 0.0 0.0))))
  (cpBodySetPosition body v)
  (cpShapeSetFriction shape 0.7)
  body)

(define *boxBody
  (cpSpaceAddBody *space (cpBodyNew mass moment)))

(cpBodySetPosition *boxBody   (cpv 60.0 12.0))



(define *boxShape
  (cpSpaceAddShape *space (cpBoxShapeNew *boxBody radius radius (cpv 0.0 0.0))))


(define balls
  (list
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))

    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))
    (new-ball (cpv 60.0 15.0))))

(define boxes
  (list
   *boxBody))



(define *tick-rate* (/ 1 120.0))
(define *canvas* (empty-scene 100.0 100.0))

(define (render-ball b)
  (circle radius 'solid 'blue))

(define (render-box b)
  (rotate (cpBodyGetAngle b)
          (square radius 'solid 'orange)))

(define (ball->posn b)
  (define p (cpBodyGetPosition b))
  (make-posn (cpVect-x p)
             (cpVect-y p)))

(define box->posn ball->posn)


(big-bang
 0
 [on-tick (lambda (state)
            (cpSpaceStep *space *tick-rate*)
            (+ state 1))
          *tick-rate*]
 [on-draw (lambda (state)
            
            (scale 6
                   (add-line
                    (place-images
                     (append
                      (map render-ball balls)
                      (map render-box boxes))
                     (append
                      (map ball->posn balls)
                      (map box->posn boxes))
                     *canvas*)
                    (cpVect-x *ground-start*)
                    (cpVect-y *ground-start*)
                    (cpVect-x *ground-end*)
                    (cpVect-y *ground-end*)
                    'green)))])


#;(cpShapeFree *ballShape)
#;(cpBodyFree *ballBody)


(cpShapeFree *ground)
(cpSpaceFree *space)




