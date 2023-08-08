"
""This implementation of Map is basen on the DosteABBSet, but it supports adding values for each key in the Dictionary.

It's very basic (for example it doesn't support deleting nodes), but that is because it's targeted to use with the 2tLoxInterpreter (for the Scanner specially) so I needed to support just inserting keys and retrieving its corresponding values""
"
Class {
	#name : #DosteMap,
	#superclass : #Object,
	#instVars : [
		'root'
	],
	#category : #'2tDataStructures'
}

{ #category : #accessing }
DosteMap >> contains: key [
		| nodeIterator |

		nodeIterator := self root.
		
		nodeIterator ifNil: [ ^ false ].
		
		(nodeIterator key) = key ifTrue: [ ^ true ].
		
		[nodeIterator isNotNil and:[(nodeIterator key = key) not]] whileTrue: [ 
		 		 (nodeIterator key > key ) ifTrue: [    "nodeIterator > key entonces voy al subarbol izq"
							nodeIterator := nodeIterator left
					] ifFalse: [   															 "nodeIterator < key entonces voy al subarbol der"
							nodeIterator := nodeIterator right
					]
		].
	
		nodeIterator isNil ifTrue: [ 
				^ false
		] ifFalse: [ 					"si nodeIterator no es Nil, entonces salio del while porque nodeIterator data = key entonces key SI esta"									
				^ true
		]
		
		
]

{ #category : #accessing }
DosteMap >> findParent: key [
		| nodeIterator nodeParent|
		
		nodeIterator := root.
		nodeParent := nil.
		
		[ nodeIterator isNil ] whileFalse: [ 
					nodeParent := nodeIterator.
					( key < nodeIterator key ) ifTrue: [ 
								nodeIterator := nodeIterator left
					 ] ifFalse: [
								nodeIterator := nodeIterator right
					].
		 ].
	
		 ^ nodeParent
]

{ #category : #'as yet unclassified' }
DosteMap >> getValueForKey: key [ 
		"Inserta un elemento en el conjunto. Si este ya existe, el conjunto no se modifica."
		| nodeIterator |
		
		(self contains: key) ifFalse: [         									
				^ nil
		
		] ifTrue: [ 
				nodeIterator := self root.
		
				(nodeIterator key) = key ifTrue: [ ^ nodeIterator valueForKey ].
				
				[nodeIterator isNotNil and:[(nodeIterator key = key) not]] whileTrue: [ 
		 		 (nodeIterator key > key ) ifTrue: [    						 "nodeIterator > key entonces voy al subarbol izq"
							nodeIterator := nodeIterator left
					] ifFalse: [   															 "nodeIterator < key entonces voy al subarbol der"
							nodeIterator := nodeIterator right
					]
				].
			
				nodeIterator isNil ifTrue: [ 
						^ nil
				] ifFalse: [ 					"si nodeIterator no es Nil, entonces salio del while porque nodeIterator data = key entonces key SI esta"									
						^ nodeIterator valueForKey.
				]
		].
	

		
		
		
		
		
]

{ #category : #'as yet unclassified' }
DosteMap >> insertKey: key withValue: value [
		"Inserta un elemento en el conjunto. Si este ya existe, el conjunto no se modifica."
		| nodeIterator nodeToInsert nodeParent|
		
		(self contains: key) ifTrue: [ " si prev es nullptr es porque actual es nullptr y nunca entro al while
           											eso significa que el arbol era vacio. asique solo seteo la raiz con la clave pasada "
				^ nil
		
		] ifFalse: [ 
		
				nodeToInsert := DosteMapNode new.
				nodeToInsert key: key.
				nodeToInsert valueForKey: value.
				nodeToInsert left: nil.
				nodeToInsert right: nil.
				
				nodeIterator := self root.
				nodeParent := self findParent: key.
				
				nodeParent isNil ifTrue: [ 						"si prev es nullptr es porque actual es nullptr y nunca entro al while"
						nodeParent := nodeToInsert.				"eso significa que el arbol era vacio. asique solo seteo la raiz con la clave pasada"
						self root: nodeParent.
				] ifFalse: [ 
						(key < nodeParent key) ifTrue: [   "nodeParent seria el padre del nodo a insertar . si la clave es mayor:"
								nodeParent left: nodeToInsert.     "lo inserto como hijo izquierdo"
						] ifFalse:  [
								nodeParent right: nodeToInsert.    "y si la clave es menor, como hijo derecho"
						]
			
				].
				
		].
		
		
		
		
]

{ #category : #accessing }
DosteMap >> root [

	^ root
]

{ #category : #accessing }
DosteMap >> root: anObject [

	root := anObject
]
