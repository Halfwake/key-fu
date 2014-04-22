#lang racket

(require rackunit)

; (foldl proc init lst)

(define (foldl-key proc init lst key)
  (let iter ([accum init]
             [lst lst])
    (cond [(null? lst) accum]
          [else (iter (proc (key (first lst))
                            accum)
                      (rest lst))])))

(let ([lst (map range (range 10))])
  (test-equal? "foldl-key"
               (foldl-key + 0 lst length)
               (foldl (lambda (item accum)
                        (+ accum (length item)))
                      0
                      lst)))

; (filter pred lst) remove if pred true

(define (filter-key pred lst key)
  (foldl-key (lambda (item accum)
               (if (pred item)
                   (cons item accum)
                   accum))
             '()
             (reverse lst)
             key))

(let ([lst (map range (range 10))])
  (test-equal? "filter-key"
               (filter-key (curry > 5)
                           lst
                           length)
               (filter (compose (curry > 5) length)
                       lst)))

; (filter-not pred lst) remove if pred false

; (filter-map proc lst ...+) map and then filters out all #f

; (partition pred lst) same as (values (filter pred lst) (filter (negate pred) lst))

; (count proc lst ...+) same as (length (filter proc lst ...))
    
             

; (foldr proc init lst)

; (remove v lst [proc]) remove if equal to v with [proc] equality

; (remove* v-lst lst [proc]) removes every element in v-lst from lst using [proc] to check equality)