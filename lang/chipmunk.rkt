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
         ) 

(require ffi/unsafe) 
  
#;(provide (all-from-out "./chipmunk-ffi.rkt"))   

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
    
    (if (and presolve-f
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
     (chipmunk-shape c)
     )))

(define (has-body? s)
  (lambda(c)
    (ptr-equal?
     s
     (chipmunk-body c))))
  
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







(define (set-presolve! f)
  (set! presolve-f f)
  )

(define (number->pointer n)
  (define entity-id-ptr
    (malloc 'raw 2))
  (ptr-set! entity-id-ptr _uint n)

  (no-gc! entity-id-ptr))

(define (add-shape body
                   w h v
                   #:friction (friction 0.7)
                   #:meta (meta #f)
                   #:user-data (user-data #f)
                   #:group (group 0))
  
  
  (define shape (cpSpaceAddShape *space (cpBoxShapeNew body
                                                       (real->double-flonum w)
                                                       (real->double-flonum h)
                                                       (cpv 0.0 0.0))))

  (define d (if user-data
                (number->pointer user-data)
                #f))

  (and d
       (cpBodySetUserData body (number->pointer user-data)))

  (and d
       (cpShapeSetUserData shape (number->pointer user-data)))

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
             #:user-data (user-data #f)
             #:group (group 0))

  (define v (cpv x y))
 
  (define body (cpSpaceAddBody *space (cpBodyNew (real->double-flonum mass) +inf.0 #;boxMoment)))

  (add-shape body
             w h v
             #:friction friction
             #:meta meta
             #:user-data user-data
             #:group group))


;cpBodyNewKinematic 
(define (box-kinematic x y w h
                       #:friction (friction 0.7)
                       #:meta (meta #f)
                       #:user-data (user-data #f)
                       #:group (group 0))
  
  (define v (cpv x y))
  
  (define body (cpSpaceAddBody *space (cpBodyNewKinematic)))

  (add-shape body
             w h v
             #:friction friction
             #:meta meta
             #:user-data user-data
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
  (cpBodySetVelocity (chipmunk-body c)
                     (cpv x y)))

(define (step-chipmunk rate)
  (cpSpaceStep *space rate))


(define (destroy-chipmunk c)
  #;(displayln "Destroying a chipmunk... Right??")
  
  (cpSpaceRemoveBody *space (chipmunk-body c))
  (cpBodyDestroy (chipmunk-body c))
  (cpBodyFree    (chipmunk-body c))

  (cpSpaceRemoveShape *space (chipmunk-shape c))
  (cpShapeDestroy (chipmunk-shape c))
  (cpShapeFree    (chipmunk-shape c))

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
      ;This findf is another good spot for optimization...
      (f (findf (curry has-body? body) all-chipmunks)
         gravity
         damping
         dt)
      
      _void))

  (let ([body (chipmunk-body c)])
    (parameterize ([current-cpBody body])
      (set-cpBody-velocity_func! body wrapper)))
  )


#;(
   ;The stupid macro....
   (require (for-syntax racket))
   
   (define-syntax (dumb-duplicate stx)
     (syntax-case stx ()
       ((_ id body n)
        #`(define id
            (list
             #,@(map (λ(x) #'body)
                     (range 0 (syntax->datum #'n))))))))

   (define (vel-func body gravity damping dt)
     (ffi:cpointer-push-tag! body 'cpBody)

     (define e (find-entity-by-chipmunk-body body last-game-snapshot))

     (phys:cpBodyUpdateVelocity body gravity damping dt)

     (and e
          (get-component e physical-collider?)
          (phys:cpBodySetVelocity body
                                  (phys:cpv (posn-x (physical-collider-force (get-component e physical-collider?)))
                                            (posn-y (physical-collider-force (get-component e physical-collider?))))))
     ffi:_void)

   (dumb-duplicate fs
                   (λ(a b c d)
                     (vel-func a b c d))
                   10)



   (define (chipmunkify-step2 e)

     (define (set-vel-func-for-sure e)
    
       (define body (phys:chipmunk-body
                     (physical-collider-chipmunk
                      (get-component e physical-collider?))))

       (set! entities-and-bodies (cons (list e body)
                                       entities-and-bodies))
    
       (phys:set-cpBody-velocity_func! body
                                       (first fs))

       (set! fs (rest fs)))


     (define (set-vel-func e)
       (if (is-static? e)
           e
           (set-vel-func-for-sure e)))

  
     (set-vel-func e)
     e)
   )




