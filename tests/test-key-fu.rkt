#lang racket

(require rackunit
         "../key-fu.rkt")

(let ([lst (map range (range 10))])
  (test-equal? "foldl/key"
               (foldl/key + 0 length lst)
               (foldl (lambda (item accum)
                        (+ (length item) accum))
                      0
                      lst))
  (test-equal? "foldl/key multiple lists"
               (foldl/key + 0 length lst lst)
               (foldl (lambda (a b accum)
                        (+ (length a) (length b) accum))
                      0
                      lst
                      lst))
  (test-equal? "foldl/key non-associative"
               (foldl/key - 0 length lst)
               (foldl (lambda (item accum)
                        (- (length item) accum))
                      0
                      lst))
  (test-equal? "foldl/key non-associative multiple lists"
               (foldl/key - 0 length lst lst)
               (foldl (lambda (a b accum)
                        (- (length a) (length b) accum))
                      0
                      lst
                      lst)))               

(let [(lst (map range (range 10)))]
  (test-equal? "foldr/key"
               (foldr/key + 0 length lst)
               (foldr (lambda (item accum)
                        (+ accum (length item)))
                      0
                      lst))
  (test-equal? "foldr/key multiple lists"
               (foldr/key + 0 length lst lst)
               (foldr (lambda (a b accum)
                        (+ accum (length a) (length b)))
                      0
                      lst
                      lst))
  (test-equal? "foldr/key non-associative"
               (foldr/key - 0 length lst)
               (foldr (lambda (item accum)
                        (- accum (length item) ))
                      0
                      lst))
  (test-equal? "foldr/key non-associative multiple lists"
               (foldr/key - 0 length lst lst)
               (foldr (lambda (a b accum)
                        (- accum (length a) (length b)))
                      0
                      lst
                      lst)))


(let ([lst (map range (range 10))])
  (test-equal? "filter/key"
               (filter/key (curry > 5) length lst)
               (filter (compose (curry > 5) length) lst)))

(let ([lst (map range (range 10))])
  (test-equal? "filter-not/key"
               (filter-not/key (curry > 5) length lst)
               (filter-not (compose (curry > 5) length) lst)))


(let ([lst (map range (range 10))])
  (test-equal? "partition/key"
               (call-with-values (lambda ()
                                   (partition/key (curry > 5) length lst))
                                 list)
               (call-with-values (lambda ()
                                   (partition (compose (curry > 5) length) lst))
                                 list)))


(let ([lst (append (map range (range 6))
                   (map range (range 8))
                   (map range (range 10)))])
  (test-equal? "count/key"
               (count/key (curry = 7) length lst)
               (count (lambda (item)
                        (= 7 (length item)))
                      lst)))


(let ([lst (append (map range (range 10)))])
  (test-equal? "remove*/key"
               (remove*/key '(3 4 5) = length lst)
               (remove* '(3 4 5) lst (lambda (a b)
                                       (= a (length b))))))

(let ([lst (map range (range 10))])
  (test-equal? "remove/key"
               (remove/key 5 = length lst)
               (remove 5 lst (lambda (a b)
                               (= a (length b))))))

(let ([lst (shuffle (map range (range 10)))])
  (test-equal? "sort/key"
               (sort/key lst < length)
               (sort lst < #:key length)))
               