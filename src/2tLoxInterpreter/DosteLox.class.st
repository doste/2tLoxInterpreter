Class {
	#name : #DosteLox,
	#superclass : #Object,
	#instVars : [
		'scanner'
	],
	#category : #'2tLoxInterpreter'
}

{ #category : #'as yet unclassified' }
DosteLox >> debugTokens: tokenList [
		"Returns a string containing one token for line. Just for debugging purposes"

		| stringOfTokens |
		
		stringOfTokens := String new.
		
		tokenList  do:[ :tok | stringOfTokens := stringOfTokens, tok data toString, String cr ].
		
		^ stringOfTokens 
]

{ #category : #running }
DosteLox >> initialize [ 
		super initialize.
		scanner := DosteScanner new.
]

{ #category : #running }
DosteLox >> run: sourceCode [

		| scanner listOfTokens |
		
		scanner := DosteScanner new.
		scanner source: sourceCode.
		
		listOfTokens := scanner scanTokens.
		
	
		^ listOfTokens
]

{ #category : #accessing }
DosteLox >> scanner [

	^ scanner
]

{ #category : #accessing }
DosteLox >> scanner: anObject [

	scanner := anObject
]
