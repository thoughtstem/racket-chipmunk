#lang racket

(provide step-chipmunk
         angle
         box
         box-kinematic
         *space
         x y w h
         (struct-out chipmunk)
         )

(provide (all-from-out "./chipmunk-ffi.rkt"))

(require "./chipmunk-ffi.rkt")

(struct chipmunk (body shape meta))

(define (angle c)
  (cpBodyGetAngle (chipmunk-body c)))

(define (x c)
  (define p (cpBodyGetPosition (chipmunk-body c)))
  (cpVect-x p))

(define (y c)
  (define p (cpBodyGetPosition (chipmunk-body c)))
  (cpVect-y p))

(define (w c)
  (define bb (cpShapeGetBB (chipmunk-shape c)))

  (abs (- (cpBB-l bb)
          (cpBB-r bb))))

(define (h c)
  (define bb (cpShapeGetBB (chipmunk-shape c)))

  (abs (- (cpBB-t bb)
          (cpBB-b bb))))


(define *gravity
  (cpv 0.0 100.0))

(define *space
  (cpSpaceNew))

(cpSpaceSetGravity *space *gravity)

(define (box w h v
             #:mass (mass 1.0)
             #:friction (friction 0.7)
             #:meta (meta #f))

  (define boxMoment
    (cpMomentForBox mass 0.0 (real->double-flonum h)))
  
  (define body (cpSpaceAddBody *space (cpBodyNew mass boxMoment)))
  
  (define shape (cpSpaceAddShape *space (cpBoxShapeNew body
                                                       (real->double-flonum w)
                                                       (real->double-flonum h)
                                                       (cpv 0.0 0.0))))
  (cpBodySetPosition body v)
  (cpShapeSetFriction shape friction)
  (chipmunk body shape meta))


;cpBodyNewKinematic 
(define (box-kinematic w h v
                       #:friction (friction 0.7)
                       #:meta (meta #f))
  (define body (cpSpaceAddBody *space (cpBodyNewKinematic)))
  
  (define shape (cpSpaceAddShape *space (cpBoxShapeNew body
                                                       (real->double-flonum w)
                                                       (real->double-flonum h)
                                                       (cpv 0.0 0.0))))
  (cpBodySetPosition body v)
  (cpShapeSetFriction shape friction)
  (chipmunk body shape meta))

(define (step-chipmunk rate)
  (cpSpaceStep *space rate))




