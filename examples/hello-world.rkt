#lang racket

(require racket-chipmunk/lang/chipmunk-ffi)

(define gravity (cpv 0 -100))
(define space (cpSpaceNew))

(cpSpaceSetGravity space gravity)

(define ground 
  (cpSegmentShapeNew 
    (cpSpaceGetStaticBody space)
    (cpv -20 5)
    (cpv 20 -5)
    0.0))

(cpShapeSetFriction ground 1.0)
(cpSpaceAddShape space ground)

(define radius 5.0)
(define mass 1.0)

(define moment (cpMomentForCircle mass 0.0 radius (cpv 0 0)))

(define ballBody (cpSpaceAddBody space (cpBodyNew mass moment)))

(define ballShape (cpSpaceAddShape space (cpCircleShapeNew ballBody radius (cpv 0 0))))

(cpShapeSetFriction ballShape 0.7)

(define timeStep (/ 1 60))

(define time 0)
(let loop ()
  (set! time (+ time timeStep)) 

  (define pos (cpBodyGetPosition ballBody))
  (define vel (cpBodyGetVelocity ballBody))
  
  (displayln (~a "Time is " time ", body at (" (cpVect-x pos) ", " (cpVect-y pos) "), velocity at " vel))

  (cpSpaceStep space (real->double-flonum time))

  (when (< time 2) 
    (loop)))


(cpShapeFree ballShape)
(cpBodyFree ballBody)
(cpShapeFree ground)
(cpSpaceFree space)



