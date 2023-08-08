"
""I represent a Scanner of the Interpreter.

Internal Representation:

  Instance Variables
		current:		<SmallInteger>
		keywords:		A map to represent the relationship between each keyword and their corresponding TokenType.
		line:			<SmallInteger>
		source:			A String representing all the source code to scan.
		start:			<SmallInteger>
		tokens:			A DosteLinkedList of Tokens

The start and current fields are offsets that index into the string. The start field points to the first character in the lexeme being scanned,
and current points at the character currenty being considered. The line field tracks what source line current is on so we can produce tokens that
know their location.

""
"
Class {
	#name : #DosteScanner,
	#superclass : #Object,
	#instVars : [
		'source',
		'tokens',
		'start',
		'current',
		'line',
		'keywords'
	],
	#category : #'2tLoxInterpreter'
}

{ #category : #accessing }
DosteScanner >> addTokenWithType: type [

		self addTokenWithType: type withLiteral: nil.
]

{ #category : #accessing }
DosteScanner >> addTokenWithType: type withLiteral: literal [

		| text newToken|
		
		text := self source copyFrom: (self start) to: (self current - 1).
		"(self tokens) add: (DosteToken new;
								 		type: type;
										lexeme: text;
										literal: literal;
										line: self line). ESTO NO ANDA"					
		"newToken := DosteToken new.
		newToken type: type.
		newToken lexeme: text.
		newToken literal: literal.
		newToken line: self line."
		
		newToken := DosteToken withType: type withLexeme: text  withLiteral: literal  withLine: self line.
	
		self tokens add: newToken.
		
]

{ #category : #accessing }
DosteScanner >> advance [
		"Consumes the next character in the source file and returns it."
		| charAtCurrentPosition |
		
		charAtCurrentPosition := self source at: (self current).
		
		self current: self current + 1.
		
		^ charAtCurrentPosition 
		
]

{ #category : #accessing }
DosteScanner >> current [

	^ current
]

{ #category : #accessing }
DosteScanner >> current: anObject [

	current := anObject
]

{ #category : #'as yet unclassified' }
DosteScanner >> handleIdentifier [
	| text tokenType |

	[ (self peek) isAlphaNumeric] whileTrue: [ self advance ].

	text := self source copyFrom: (self start) to: (self current - 1).
	
	tokenType := self keywords getValueForKey: text. 
	tokenType ifNil: [ 
			tokenType := #identifier
	].
	self addTokenWithType: tokenType.

]

{ #category : #'as yet unclassified' }
DosteScanner >> handleNumber [
	| charPeeked nextCharPeeked numberInSubstring |

	[(self peek) isNotNil and: [(self peek) isDigit]] whileTrue: [ 
			self advance
	].

	charPeeked := self peek.
	nextCharPeeked := self peekNext.
	(charPeeked isNotNil and: [ charPeeked = $. ]) ifTrue: [ 
		(nextCharPeeked isDigit) ifTrue: [
			"Consume the '.'"
			 self advance.
			
				[(self peek) isDigit] whileTrue: [ 
						self advance.
				 ].
			].
	].

	numberInSubstring := self source copyFrom: (self start) to: (self current - 1).
	self addTokenWithType: #number withLiteral: numberInSubstring asNumber.
	
]

{ #category : #'as yet unclassified' }
DosteScanner >> handleString [
		"Like with comments, we consume characters until we hit the "" that ends the string."
		| stringValue |
		
		[ (self peek) = $" or:[self isAtEnd]] whileFalse: [ 
				((self peek) = String cr) ifTrue: [ 
						self line: self line + 1. 	"For no particular reason, Lox supports multi-line strings."
				].
				self advance.
		].
		
		(self isAtEnd) ifTrue: [ 
				"TODO: error handling!"
				^ nil
		].
	
		self advance.  "The closing quote"
		
		stringValue := self source copyFrom: self start + 1 to: self current - 2.   "Trim the surrounding quotes."
		
		self addTokenWithType:#string withLiteral: stringValue.
]

{ #category : #initialization }
DosteScanner >> initialize [
		super initialize.
		
		start := 1.
		current := 1.
		line := 1.
		
		tokens := DosteLinkedList new.
		
		keywords := DosteMap new.
		
		keywords insertKey: 'and' withValue: #and.
		keywords insertKey: 'class' withValue: #class.
		keywords insertKey: 'else' withValue: #else.
		keywords insertKey: 'false' withValue: #false.
		keywords insertKey: 'for' withValue: #for.
		keywords insertKey: 'fun' withValue: #fun.
		keywords insertKey: 'if' withValue: #if.
		keywords insertKey: 'nil' withValue: #nil.
		keywords insertKey: 'or' withValue: #or.	
		keywords insertKey: 'print' withValue: #print.		
		keywords insertKey: 'return' withValue: #return.		
		keywords insertKey: 'super' withValue: #super.	
		keywords insertKey: 'this' withValue: #this.		
		keywords insertKey: 'true' withValue: #true.		
		keywords insertKey: 'var' withValue: #var.
		keywords insertKey: 'while' withValue: #while.						

		
		
]

{ #category : #testing }
DosteScanner >> isAtEnd [
	
		^  (self current > self source size).
]

{ #category : #accessing }
DosteScanner >> keywords [

	^ keywords
]

{ #category : #accessing }
DosteScanner >> keywords: anObject [

	keywords := anObject
]

{ #category : #accessing }
DosteScanner >> line [

	^ line
]

{ #category : #accessing }
DosteScanner >> line: anObject [

	line := anObject
]

{ #category : #accessing }
DosteScanner >> match: expected [
		"It's like a conditional advance(). We only consume the character if it's what we are looking for."
		
		| charAtCurrentPosition |

		self isAtEnd ifTrue: [ ^ false ].
		
		charAtCurrentPosition := self source at: (self current).
		
		charAtCurrentPosition = expected ifFalse: [ ^ false ].
		
		self current: self current + 1.
		
		^ true.
]

{ #category : #accessing }
DosteScanner >> peek [ 

		| charAtCurrentPosition |

		self isAtEnd ifTrue: [ ^ nil ].
		
		charAtCurrentPosition := self source at: (self current).
		
		^ charAtCurrentPosition.
]

{ #category : #accessing }
DosteScanner >> peekNext [

		| charAtCurrentPosition |
		
		(self current + 1) < (self source size) ifFalse: [ 
				^ nil
		].
		
		charAtCurrentPosition := self source at: (self current + 1).
		
		^ charAtCurrentPosition.
]

{ #category : #'as yet unclassified' }
DosteScanner >> scanToken [

		| currentChar tokenAddedSuccessfully|
		
		currentChar := self advance.
		
		currentChar = $( ifTrue: [ ^ self addTokenWithType: #LeftParen ].
		currentChar = $) ifTrue: [ ^ self addTokenWithType: #RightParen ].
		currentChar = ${ ifTrue: [ ^ self addTokenWithType: #LeftBrace ].
		currentChar = $} ifTrue: [ ^ self addTokenWithType: #RightBrace ].
		currentChar = $, ifTrue: [ ^ self addTokenWithType: #Comma ].	
		currentChar = $. ifTrue: [ ^ self addTokenWithType: #Dot ].
		currentChar = $- ifTrue: [ ^ self addTokenWithType: #Minus ].
		currentChar = $+ ifTrue: [ ^ self addTokenWithType: #Plus ].
		currentChar = $; ifTrue: [ ^ self addTokenWithType: #Semicolon ].
		currentChar = $* ifTrue: [ ^ self addTokenWithType: #Star ].

		tokenAddedSuccessfully := self scanTokenCharacter: currentChar ToMatch: $! With: $= ForOptionTokenType: #BangEqual Or: #Bang.
		tokenAddedSuccessfully ifNotNil: [^ tokenAddedSuccessfully ].
		tokenAddedSuccessfully := self scanTokenCharacter: currentChar ToMatch: $= With: $= ForOptionTokenType: #EqualEqual Or: #Equal.
		tokenAddedSuccessfully ifNotNil: [^ tokenAddedSuccessfully ].
		tokenAddedSuccessfully := self scanTokenCharacter: currentChar ToMatch: $< With: $= ForOptionTokenType: #LessEqual Or: #Less.
		tokenAddedSuccessfully ifNotNil: [^ tokenAddedSuccessfully ].
		tokenAddedSuccessfully := self scanTokenCharacter: currentChar ToMatch: $> With: $= ForOptionTokenType: #GreaterEqual Or: #Greater.
		tokenAddedSuccessfully ifNotNil: [^ tokenAddedSuccessfully ].
		tokenAddedSuccessfully := self scanTokenCharacter: currentChar ToMatch: $/ With: $/ ForOptionTokenType: #Slash Or: nil.
		tokenAddedSuccessfully ifNotNil: [^ tokenAddedSuccessfully ].
		
		currentChar isSpaceSeparator  ifTrue: [ ^ nil ].
		
		(currentChar = String cr) ifTrue: [
				self line: self line + 1.
				^ nil ].
		
		currentChar = $" ifTrue: [ ^ self handleString ].

		currentChar isDigit ifTrue: [ ^ self handleNumber ].
		
		currentChar isLetter ifTrue: [ ^ self handleIdentifier ].
		
		^ nil "TODO: better error handling"
		
		
		
]

{ #category : #'as yet unclassified' }
DosteScanner >> scanTokenCharacter: character ToMatch: firstCharacterToMatch With: secondCharacterToMatch ForOptionTokenType: firstType Or: secondType [

		"If secondCharacterToMatch is '/' it may be for a comment and a comment goes until the end of the line, so when we find a second /, we don't end the token yet. Instead we keep consuming characters until we reach the end of the line."
		character = $/ ifTrue: [ (self match: firstCharacterToMatch) ifTrue: [ 
							[self peek = String cr or: [ self isAtEnd ]] whileTrue: [ 
									^ self advance.
							]
							]ifFalse: [
									^ self addTokenWithType: firstType 
							]
						 ]. 

		character = firstCharacterToMatch ifTrue: [ (self match: secondCharacterToMatch) ifTrue: [ 
																								^ self addTokenWithType: firstType
				 															] ifFalse: [ 
																								^ self addTokenWithType: secondType
																			 ].
		].
	
	
	^ nil
]

{ #category : #'as yet unclassified' }
DosteScanner >> scanTokens [

		| newToken |
		
		[self isAtEnd] whileFalse: [ 
				self start: self current.
				self scanToken.
		].
		
		"Ÿ al final agregamos el token EndOfFile"								
		newToken := DosteToken new.
		newToken type: #EOF.
		newToken lexeme: ''.
		newToken literal: nil.
		newToken line: self line.
	
		self tokens add: newToken.
		
		^ self tokens
]

{ #category : #accessing }
DosteScanner >> source [
		^ source
]

{ #category : #accessing }
DosteScanner >> source: sourceCode [
		source := sourceCode.
]

{ #category : #accessing }
DosteScanner >> start [

	^ start
]

{ #category : #accessing }
DosteScanner >> start: anObject [

	start := anObject
]

{ #category : #accessing }
DosteScanner >> tokens [

	^ tokens
]

{ #category : #accessing }
DosteScanner >> tokens: anObject [

	tokens := anObject
]
