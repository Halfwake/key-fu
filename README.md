====
Keys

This library has key versions of common fuctions. The key versions work much like the originals, but they have another required argument, a key function. Instead of items in a list being passed to a procedure, the result of the key function called with an item is passed to a procedure.

````
  ;;; How many lists have an even length?

  (define stuff (map range (range 10)))

  ;; Verbose
  (count (lambda (item)
           (even? (length item)))
         stuff)

  ;; Works pretty well.
  (count (compose even? length))

  ;; Key solution.
  (count/key even? length stuff)

If you pass in the identity function for key then it acts like a non-key function.

````
  (foldl + 0 identity (range 10))


Key functions are best used when something has to be done to a collection of objects based on their properties without losing information. 
````
  ;;; Sort lists by length.
  (define stuff (shuffle (map range (range 10))))

  ;; Wrong. Now we have a list of lengths instead of a list of lists.
  (sort < (map length stuff))

  ;; The behavior is correct, but it's ugly.
  (sort < (lambda (a b)
            (< (length a) (length b)))
          lst)

  ;; Pretty.
  (sort/key < length stuff)

  ;; The standard library already handles this one and includes keyword options to tune efficiency, but it's a keyword argument and that might not be convenient.
  (sort < stuff #:key length)
  
Here's another example of the operation based on properties pattern.
````
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

Some benefit from it, but don't really need it.
````
  foldl/key
  foldr/key

Functions that work with the key pattern perfectly.
````
  filter/key
  filter-not/key
  partition/key
  count/key
  remove*/key
  remove/key
  sort/key
 

And one couldn't care less. (This one isn't in the module.)
````
  ;; It already takes a key function.
  (map/key add1 identity (range 10))
  (map/key identity add1  (range 10))


