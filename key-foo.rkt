#lang racket

(require rackunit)

; (foldl proc init lst)

(define (foldl-key proc init key lst)
  (let iter ([accum init]
             [lst lst])
    (cond [(null? lst) accum]
          [else (iter (proc (key (first lst))
                            accum)
                      (rest lst))])))

(let ([lst (map range (range 10))])
  (test-equal? "foldl-key"
               (foldl-key + 0 length lst)
               (foldl (lambda (item accum)
                        (+ accum (length item)))
                      0
                      lst)))

; (filter pred lst) remove if pred true

(define (filter-key pred key lst)
  (foldl (lambda (item accum)
           (if (pred (key item))
               (cons item accum)
               accum))
         '()
         (reverse lst)))

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

; (count proc lst ...+) same as (length (filter proc lst ...))
    
             

; (foldr proc init lst)

; (remove v lst [proc]) remove if equal to v with [proc] equality

; (remove* v-lst lst [proc]) removes every element in v-lst from lst using [proc] to check equality)