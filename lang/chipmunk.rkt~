#lang racket

(provide step-chipmunk
         angle
         box 
         box-kinematic
         box-static
         ;*space  ;Uhh.  No...
         x y w h
         (struct-out chipmunk) 
         set-velocity! 
         destroy-chipmunk
         set-presolve!

         get-data
         set-velocity-function!
         set-chipmunk-posn!
         destroyed-chipmunk?
         )  

(require ffi/unsafe) 
  
(provide (all-from-out "./chipmunk-ffi.rkt"))   

(require "./chipmunk-ffi.rkt")



(struct chipmunk (id body shape w h meta data) #:transparent)

(define not-garbage '())

(define (no-gc! c)
  (set! not-garbage (cons c not-garbage))
  c)


(define all-chipmunks '())


(define *gravity
  (cpv 0.0 0.0))

(define *space
  (cpSpaceNew))

(cpSpaceSetGravity *space *gravity)


(define presolve-f #f)
(define (main-presolve arbiter space data)
  (let-values ([(s1 s2) (cpArbiterGetShapes arbiter)])
    
    ;NOTE: This is a good spot to optimize.  Lots of looping through all chipmunks on every frame...
    ;  Index by user data or something...
    (define c1 (findf (curry has-shape? s1) all-chipmunks))
    (define c2 (findf (curry has-shape? s2) all-chipmunks))

    (and (not c1)
         (displayln "Found a null shape"))

    (and (not c2)
         (displayln "Found a null shape2"))
    
    (if (and c1
             c2
             presolve-f
             (presolve-f c1 c2))
        1
        0)))

(define handler
  (cpSpaceAddDefaultCollisionHandler *space))

(set-cpCollisionHandler-cpCollisionPreSolveFunc! handler main-presolve)














;Functions

(define (remember-chipmunk! c)
  (set! all-chipmunks (cons c all-chipmunks))
  c)

(define (has-shape? s)
  (lambda(c)
    (ptr-equal?
     s
     (chipmunk-shape c))))

(define (has-body? s)
  (lambda(c)
    (ptr-equal?
     s
     (chipmunk-body c))))

(define (has-data? n)
  (lambda(c)
    (define d (body->data (chipmunk-body c)))
    (and d (= n d))))

(define (body->data body)
  (define d (cpBodyGetUserData body))
  (if d
      (ptr-ref d _uint)
      #f))

  
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

  (chipmunk-w c))

(define (h c)
  (define bb (cpShapeGetBB (chipmunk-shape c)))

  (chipmunk-h c))



(define current-id -1)
(define (next-id!)
  (set! current-id (add1 current-id))
  current-id)



(define (set-presolve! f)
  (set! presolve-f f))

(define (number->pointer n)
  (define entity-id-ptr
    (malloc 'raw 2))
  (ptr-set! entity-id-ptr _uint n)

  (no-gc! entity-id-ptr))

(define (add-shape body
                   w h v
                   #:friction (friction 0.7)
                   #:meta (meta #f)
                   #:group (group 0))
  
  
  (define shape (cpSpaceAddShape *space (cpBoxShapeNew body
                                                       (real->double-flonum w)
                                                       (real->double-flonum h)
                                                       (cpv 0.0 0.0))))

  (define d (number->pointer (next-id!)))

  (and d
       (cpBodySetUserData body d))

  (and d
       (cpShapeSetUserData shape d))

  (set-cpShape-group! shape group)

  (set-cpShape-e! shape 0.0)
  (set-cpShape-u! shape 0.0)
  
  (cpBodySetPosition body v)
  (cpShapeSetFriction shape friction)
  (remember-chipmunk! (chipmunk (random 100000) body shape w h meta d)))

(define (box x y w h
             #:mass (mass 1.0)
             #:friction (friction 0.7)
             #:meta (meta #f)
             #:group (group 0))

  (define v (cpv x y))
 
  (define body (cpSpaceAddBody *space (cpBodyNew (real->double-flonum mass) +inf.0 #;boxMoment)))

  (add-shape body
             w h v
             #:friction friction
             #:meta meta
             #:group group))


;cpBodyNewKinematic 
(define (box-kinematic x y w h
                       #:friction (friction 0.7)
                       #:meta (meta #f)
                       #:group (group 0))
  
  (define v (cpv x y))
  
  (define body (cpSpaceAddBody *space (cpBodyNewKinematic)))

  (add-shape body
             w h v
             #:friction friction
             #:meta meta
             #:group group))

(define (box-static x y w h
                       #:friction (friction 0.7)
                       #:meta (meta #f))

  (define v (cpv x y))
  
  (define body (cpSpaceAddBody *space (cpBodyNewStatic)))
  
  (define shape (cpSpaceAddShape *space (cpBoxShapeNew body
                                                       (real->double-flonum w)
                                                       (real->double-flonum h)
                                                       (cpv 0.0 0.0))))
  
  (set-cpShape-e! shape 0.0)
  (set-cpShape-u! shape 0.0)

  
  (cpBodySetPosition body v)
  (cpShapeSetFriction shape friction)
  (chipmunk (random 100000) body shape meta w h))


(define (set-velocity! c x y)
  #;(displayln (chipmunk-body c))
  (cpBodySetVelocity (chipmunk-body c)
                     (cpv x y)))

(define (step-chipmunk rate)
  (cpSpaceStep *space rate))


(define (destroy-chipmunk c)
  #;(displayln (~a "Destroying chipmunk... "
                 (map get-data
                      (filter (λ(x)
                                (= (get-data x)
                                   (get-data c))) all-chipmunks))))
  
  (set! all-chipmunks (filter (λ(x)
                                (not (= (get-data x)
                                        (get-data c)))) all-chipmunks))
  
  (cpSpaceRemoveBody *space (chipmunk-body c))
  (cpBodyDestroy (chipmunk-body c))
  #;(cpBodyFree    (chipmunk-body c))

  (cpSpaceRemoveShape *space (chipmunk-shape c))
  (cpShapeDestroy (chipmunk-shape c))
  #;(cpShapeFree    (chipmunk-shape c))




  (struct-copy chipmunk c
               [body #f]
               [shape #f]))

 
(define (get-data c)
  (define d (chipmunk-data c))

  (if d
      (ptr-ref d _uint)
      #f))

(define (set-velocity-function! c f)
  (define wrapper
    (λ(body gravity damping dt)
      (cpointer-push-tag! body 'cpBody)

      ;This findf is another good spot for optimization...
      ;Also, is this the source of all the bugs?  Segfaulting in body->data???
      ;(display (body->data body))
      
      (define d (body->data body))
      (define chipmunk (findf (curry has-data? d) all-chipmunks))

      (and (not chipmunk)
           (displayln (~a "Found a chipmunk with data not in all-chipmunks: "
                          d)))

      ;(cpBodyUpdateVelocity body gravity damping dt)
      ;(cpBodySetVelocity body gravity)

      (and chipmunk
           (f chipmunk
              gravity
              damping
              dt))
      
      _void))

  (let ([body (chipmunk-body c)])
    (parameterize ([current-cpBody body])
      (set-cpBody-velocity_func! body wrapper)
      )))


(define (destroyed-chipmunk? c)
  (not (member c all-chipmunks)))

(define (set-chipmunk-posn! c x y)
  (and (destroyed-chipmunk? c)
       (error "Tried to set a position of a destroyed chipmunk.  You want segfaults?  Cuz that's how you get segfaults."))
  
  (cpBodySetPosition (chipmunk-body c)
                     (cpv x y)))




 



