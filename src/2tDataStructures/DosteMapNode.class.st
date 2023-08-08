Class {
	#name : #DosteMapNode,
	#superclass : #Object,
	#instVars : [
		'key',
		'valueForKey',
		'left',
		'right'
	],
	#category : #'2tDataStructures'
}

{ #category : #accessing }
DosteMapNode >> key [

	^ key
]

{ #category : #accessing }
DosteMapNode >> key: anObject [

	key := anObject
]

{ #category : #accessing }
DosteMapNode >> left [

	^ left
]

{ #category : #accessing }
DosteMapNode >> left: anObject [

	left := anObject
]

{ #category : #accessing }
DosteMapNode >> right [

	^ right
]

{ #category : #accessing }
DosteMapNode >> right: anObject [

	right := anObject
]

{ #category : #accessing }
DosteMapNode >> valueForKey [

	^ valueForKey
]

{ #category : #accessing }
DosteMapNode >> valueForKey: anObject [

	valueForKey := anObject
]
