Class {
	#name : #DosteMapTest,
	#superclass : #TestCase,
	#category : #'2tDataStructures'
}

{ #category : #tests }
DosteMapTest >> testMapContainsElement [
	| map emptyMap |
	map := DosteMap new.
	map insertKey: 5 withValue: 'hello'.
	map insertKey: 15 withValue: 'world!'.
	
	self assert: (map contains: 5) equals: true.
	self assert: (map contains: 25) equals: false.
	self assert: (map contains: 15) equals: true.
	
	self assert: (map getValueForKey: 5) equals: 'hello'.
	self assert: (map getValueForKey: 15) equals: 'world!'.
	self assert: (map getValueForKey: 25) equals: nil.
	
	emptyMap := DosteMap new.
	1 to: 10 do: [ :n |  self assert: (emptyMap contains: n) equals: false. ].
]
