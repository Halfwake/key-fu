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

; (foldr proc init lst)

; (remove v lst [proc]) remove if equal to v with [proc] equality

; (remove* v-lst lst [proc]) removes every element in v-lst from lst using [proc] to check equality)