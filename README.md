Keys
====

This library contains key versions of common fuctions. The key versions work much like the originals, but they have another required argument, a key function. Instead of items in a list being passed to a procedure, the result of the key function called with an item is passed to a procedure.

```racket
  ;;; How many lists have an even length?

  (define stuff (map range (range 10)))

  ;; Verbose
  (count (lambda (item)
           (even? (length item)))
         stuff)

  ;; Works pretty well.
  (count (compose even? length) stuff)

  ;; Key solution.
  (count/key even? length stuff)
```


If you pass in the identity function for key then it acts like a non-key function.

```racket
  (foldl/key + 0 identity (range 10))
```


Key functions are best used when something has to be done to a collection of objects based on their properties without losing information. 
```racket
  ;;; Sort lists by length.
  (define stuff (shuffle (map range (range 10))))

  ;; Wrong. Now we have a list of lengths instead of a list of lists.
  (sort (map length stuff) <)

  ;; The behavior is correct, but it's ugly.
  (sort stuff
        (lambda (a b)
          (< (length a) (length b))))

  ;; Pretty.
  (sort/key stuff < length)

  ;; The standard library already handles this one and includes keyword options to tune 
  ;; efficiency, but it's a keyword argument and that might not be convenient.
  (sort stuff < #:key length)
```


Here's another example of the operation based on properties pattern.
```racket
  (struct student (score))

  (define students (map student (range 60 90)))
  (define passing-grade 70)

  ;; This is ugly.
  (filter (lambda (student)
            (<= passing-grade (student-score student)))
          students)

  ;; So is this.
  (filter (compose (curry <= passing-grade) student-score)
          students)

  ;; This is clean.
  (filter/key (curry <= passing-grade) student-score students)
```


Functions that work with the key pattern perfectly.
```racket
  filter/key
  filter-not/key
  partition/key
  count/key
  remove*/key
  remove/key
  sort/key
```


Some benefit from it, but don't really need it.
```racket
  foldl/key
  foldr/key
```


And one couldn't care less. 
```racket
  ;; This is why there's no map/key in the module.
  (map/key add1 identity (range 10))
  (map/key identity add1  (range 10))
```

And this function can be used to replace everything in this library.

(define (on compare transform)
  (lambda (a b)
    (compare (transform a)
             (transform b))))

