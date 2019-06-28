methodsLength := OrderedCollection new.
Smalltalk classes do: [:aClass | aClass methodsDo: [:aMethod | methodsLength add: {aClass name. aMethod selector. aMethod linesOfCode.}]].
methodsLength sort: [:m1 :m2 | (m1 at: 3) < (m2 at: 3)].
methodsLength