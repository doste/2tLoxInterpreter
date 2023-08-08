"
""I represent a Token for the Scanner of the Interpreter.

Internal Representation:

   Instance Variables
		lexeme:		The String literal representing the Token.
		line:		Number of line where this particular Token is found on the source code.
		literal:		The value of the Token for those of Type: Identifier, String or Number.
		type:		The type of this particular Token. Can be: LeftParen, RightParen, LeftBrace, Equal, Minus, Plus, And, Else, If, etc etc.""
"
Class {
	#name : #DosteToken,
	#superclass : #Object,
	#instVars : [
		'type',
		'lexeme',
		'literal',
		'line'
	],
	#category : #'2tLoxInterpreter'
}

{ #category : #'as yet unclassified' }
DosteToken class >> withType: type withLexeme: lexeme withLiteral: literal withLine: line [

		^ (self new) type: type;
							 lexeme: lexeme;
							 literal: literal;
							 line: line;
							 yourself.
]

{ #category : #accessing }
DosteToken >> lexeme [

	^ lexeme
]

{ #category : #accessing }
DosteToken >> lexeme: anObject [

	lexeme := anObject
]

{ #category : #accessing }
DosteToken >> line [

	^ line
]

{ #category : #accessing }
DosteToken >> line: anObject [

	line := anObject
]

{ #category : #accessing }
DosteToken >> literal [

	^ literal
]

{ #category : #accessing }
DosteToken >> literal: anObject [

	literal := anObject
]

{ #category : #printing }
DosteToken >> toString [
		| resultString |
		
		resultString := String new.
		
		resultString := self type.
		
		self lexeme ifNotNil: [ 
				resultString := resultString, ' ',  self lexeme, ' '.
		].
	
		self literal ifNotNil: [ 
				resultString := resultString, ' ', self literal asString.
		].
	
		^ resultString

]

{ #category : #accessing }
DosteToken >> type [

	^ type
]

{ #category : #accessing }
DosteToken >> type: anObject [

	type := anObject
]
