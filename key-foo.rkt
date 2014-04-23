#lang racket

(require rackunit)

(provide foldl-key
         foldr-key
         filter-key
         filter-not-key
         partition-key
         count-key
         remove*-key
         remove-key)

(define (foldl-key proc init key . lists)
  (let iter ([accum init]
             [lists lists])
    (cond [(ormap null? lists) accum]
          [else (iter (apply proc (append (map (compose key first) lists)
                                          (list accum)))
                      (map rest lists))])))

(define (foldr-key proc init key . lists)
  (apply foldl-key (append (list (lambda (arg . rest)
                                   (define args (cons arg rest))
                                   (apply proc (reverse args)))
                                 init
                                 key)
                           (map reverse lists))))

(define (filter-key pred key lst)
  (foldr (lambda (item accum)
           (if (pred (key item))
               (cons item accum)
               accum))
         '()
         lst))

(define (filter-not-key pred key lst)
  (filter-key (negate pred) key lst))

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

(define (count-key proc key . lists)
  (define all-items (map key (apply append lists)))
  (length (filter proc all-items)))

(define (remove*-key v-lst proc key lst)
  (filter-key (lambda (item)
                (not (member item v-lst proc)))
              key
              lst))

(define (remove-key v proc key lst)
  (remove*-key (list v) proc key lst))
