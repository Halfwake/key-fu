#lang racket

; (filter pred lst) remove if pred true

; (filter-not pred lst) remove if pred false

; (filter-map proc lst ...+) map and then filters out all #f

; (partition pred lst) same as (values (filter pred lst) (filter (negate pred) lst))

; (count proc lst ...+) same as (length (filter proc lst ...))

; (foldl proc init lst)

; (foldr proc init lst)

; (remove v lst [proc]) remove if equal to v with [proc] equality

; (remove* v-lst lst [proc]) removes every element in v-lst from lst using [proc] to check equality)