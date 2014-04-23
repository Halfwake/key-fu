#lang racket

(require rackunit)

; (foldl proc init lst)

(define (foldl-key proc init key . lists)
  (let iter ([accum init]
             [lists lists])
    (cond [(ormap null? lists) accum]
          [else (iter (apply proc (append (map (compose key first) lists)
                                          (list accum)))
                      (map rest lists))])))

(let ([lst (map range (range 10))])
  (test-equal? "foldl-key"
               (foldl-key + 0 length lst)
               (foldl (lambda (item accum)
                        (+ accum (length item)))
                      0
                      lst))
  (test-equal? "foldl-key multiple lists"
               (foldl-key + 0 length lst lst)
               (foldl (lambda (a b accum)
                        (+ accum (length a) (length b)))
                      0
                      lst
                      lst)))

; (foldr proc init lst)

(define (foldr-key proc init key . lists)
  (apply foldl-key (append (list (lambda (arg . rest)
                                   (define args (cons arg rest))
                                   (apply proc (reverse args)))
                                 init
                                 key)
                           (map reverse lists))))
         
               

(let [(lst (map range (range 10)))]
  (test-equal? "foldr-key"
               (foldr-key + 0 length lst)
               (foldr (lambda (item accum)
                        (+ (length item) accum))
                      0
                      lst))
  (test-equal? "foldr-key multiple lists"
               (foldr-key + 0 length lst lst)
               (foldr (lambda (a b accum)
                        (+ (length a) (length b) accum))
                      0
                      lst
                      lst)))

; (filter pred lst) remove if pred true

(define (filter-key pred key lst)
  (foldr (lambda (item accum)
           (if (pred (key item))
               (cons item accum)
               accum))
         '()
         lst))

(let ([lst (map range (range 10))])
  (test-equal? "filter-key"
               (filter-key (curry > 5) length lst)
               (filter (compose (curry > 5) length) lst)))

; (filter-not pred lst) remove if pred false

(define (filter-not-key pred key lst)
  (filter-key (negate pred) key lst))

(let ([lst (map range (range 10))])
  (test-equal? "filter-not-key"
               (filter-not-key (curry > 5) length lst)
               (filter-not (compose (curry > 5) length) lst)))

; (partition pred lst) same as (values (filter pred lst) (filter (negate pred) lst))

(define (partition-key pred key lst)
  (match-define (list true-list false-list)
    (foldr (lambda (item accum)
             (match-define (list true-list false-list) accum)
             (if (pred (key item))
                 (list (cons item true-list)
                       false-list)
                 (list true-list
                       (cons item false-list))))
           '(() ())
           lst))
  (values true-list false-list))

(let ([lst (map range (range 10))])
  (test-equal? "partition-key"
               (call-with-values (lambda ()
                                   (partition-key (curry > 5) length lst))
                                 list)
               (call-with-values (lambda ()
                                   (partition (compose (curry > 5) length) lst))
                                 list)))
               

; (count proc lst ...+) same as (length (filter proc lst ...))

(define (count-key proc key . lists)
  (define all-items (map key (apply append lists)))
  (length (filter proc all-items)))

(let ([lst (append (map range (range 6))
                   (map range (range 8))
                   (map range (range 10)))])
  (test-equal? "count-key"
               (count-key (curry = 7) length lst)
               (count (lambda (item)
                        (= 7 (length item)))
                      lst)))

; (remove* v-lst lst [proc]) removes every element in v-lst from lst using [proc] to check equality)

(define (remove*-key v-lst proc key lst)
  (filter-key (lambda (item)
                (not (member item v-lst proc)))
              key
              lst))

(let ([lst (append (map range (range 10)))])
  (test-equal? "remove*-key"
               (remove*-key '(3 4 5) = length lst)
               (remove* '(3 4 5) lst (lambda (a b)
                                       (= a (length b))))))

; (remove v lst [proc]) remove if equal to v with [proc] equality

(define (remove-key v proc key lst)
  (remove*-key (list v) proc key lst))

(let ([lst (map range (range 10))])
  (test-equal? "remove-key"
               (remove-key 5 = length lst)
               (remove 5 lst (lambda (a b)
                               (= a (length b))))))