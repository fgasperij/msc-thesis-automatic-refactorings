!classDefinition: #ExtractToMethodObjectPanel category: #Playground!
SystemWindow subclass: #ExtractToMethodObjectPanel
	instanceVariableNames: 'variablesFormGroup'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Playground'!

!ExtractToMethodObjectPanel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/2/2019 12:19:52'!
buildMorphicWindow

	| classFormGroup variables columnsNames nameInput scrollPane creationMessageFormGroup theLayoutMorph |
	
	self setLabel: 'Extract Method to Method Object Panel'.
	self layoutMorph separation: 10.
	self layoutMorph padding: #top.
	
	scrollPane := PluggableScrollPane initializedInstance.
	self layoutMorph addMorphUseAll: scrollPane.
	
	theLayoutMorph := LayoutMorph newColumn.
	scrollPane addToScroller: theLayoutMorph.
	
	classFormGroup := FormGroup withTitle: 'Method Object class'.
	nameInput := LabeledInput withLabel: 'Name'.
	classFormGroup
			addMorph: nameInput
			layoutSpec: (LayoutSpec proportionalWidth: 0.95 fixedHeight: nameInput morphHeight).
	classFormGroup
			addMorph: (LabeledAutocompletedInput withLabel: 'Superclass name') 
			layoutSpec: (LayoutSpec proportionalWidth: 0.95 fixedHeight: nameInput morphHeight).
	classFormGroup
			addMorph: (LabeledInput withLabel: 'Category') 
			layoutSpec: (LayoutSpec proportionalWidth: 0.95 fixedHeight: nameInput morphHeight).

	classFormGroup layoutSpec: (LayoutSpec proportionalWidth: 0.95 fixedHeight: 180).
	theLayoutMorph 
		addMorph: classFormGroup.

		
	variablesFormGroup := FormGroup 
		withTitle: 'Instance variables names'
		withExplanation: 'Instance, class and pool variables referenced by the method will be passed as collaborators to the MethodObject. The MethodObject will have one instance variable corresponding to each of them. Pick their names:'.
	variables := #(self anInstVar aClassVar).
	variables do: [ :aVariable |
		variablesFormGroup
			addMorph: (LabeledInput withLabel: aVariable ) 
			layoutSpec: (LayoutSpec proportionalWidth: 0.95 fixedHeight: nameInput morphHeight)].
	variablesFormGroup layoutSpec: (LayoutSpec proportionalWidth: 0.95).
	theLayoutMorph 
		addMorph: variablesFormGroup.
	
	
	creationMessageFormGroup := FormGroup 
		withTitle: 'Instance creation message definition'
		withExplanation: 'The collaborators will be passed in the MethodObject instance creation message. Pick the keyword and the formal parameter name corresponding to each collaborator:'.
	variables := #(self anInstVar aClassVar).
	columnsNames := #('Keyword' 'Parameter name').
	creationMessageFormGroup addMorph: (InputTable withColumns: columnsNames withRows: variables).
	creationMessageFormGroup layoutSpec: (LayoutSpec proportionalWidth: 0.95).
	theLayoutMorph 
		addMorph: creationMessageFormGroup.
	! !


!classDefinition: #FormGroup category: #Playground!
LayoutMorph subclass: #FormGroup
	instanceVariableNames: 'title borderMorph titleContainer titleMorph titleContainerLayoutSpec explanation explanationMorph explanationContainer explanationContainerLayoutSpec'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Playground'!

!FormGroup methodsFor: 'as yet unclassified' stamp: 'FGJ 1/22/2019 12:17:03'!
drawOn: aCanvas
	aCanvas
		fillRectangle: self morphLocalBounds
		color: color
		borderWidth: 2
		borderStyleSymbol: #simple
		baseColorForBorder: Color darkGray ! !

!FormGroup methodsFor: 'as yet unclassified' stamp: 'FGJ 2/1/2019 14:53:15'!
initializeWithTitle: aTitle

	self initializeWithTitle: aTitle withExplanation: ''.! !

!FormGroup methodsFor: 'as yet unclassified' stamp: 'FGJ 2/2/2019 11:24:28'!
initializeWithTitle: aTitle withExplanation: anExplanation

	| explanationMorphLayoutSpec |
	
	title := aTitle.
	explanation := anExplanation.
	
	self separation: 5.
	
	titleMorph := StringMorph 
		contents: title 
		font: (AbstractFont familyName: Preferences defaultFontFamily pointSize: 17)
		emphasis: 1.
	titleContainer := RectangleLikeMorph new color: Color white.
	titleContainer addMorph: titleMorph.
	
	titleContainerLayoutSpec := LayoutSpec fixedHeight: titleMorph morphHeight.
	titleContainerLayoutSpec minorDirectionPadding: #left.
	
	self addMorph: titleContainer layoutSpec: titleContainerLayoutSpec.
	
	explanation isEmpty ifFalse: [
		explanationMorph := TextModelMorph withText: anExplanation.
		explanationMorph disableEditing.
		explanationMorph drawKeyboardFocusIndicator: false.
		explanationMorph lock: true.
		explanationMorph hideScrollBarsIndefinitely.
		
		explanationMorphLayoutSpec := LayoutSpec proportionalWidth: 0.95.
		explanationMorphLayoutSpec minorDirectionPadding: #left.
		explanationMorphLayoutSpec useMorphHeight.
		
		self addMorph: explanationMorph layoutSpec: explanationMorphLayoutSpec.
	].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FormGroup class' category: #Playground!
FormGroup class
	instanceVariableNames: ''!

!FormGroup class methodsFor: 'as yet unclassified' stamp: 'FGJ 1/18/2019 15:30:14'!
withTitle: aTitle

	^FormGroup newColumn initializeWithTitle: aTitle.! !

!FormGroup class methodsFor: 'as yet unclassified' stamp: 'FGJ 2/1/2019 14:52:31'!
withTitle: aTitle withExplanation: anExplanation

	^FormGroup newColumn initializeWithTitle: aTitle withExplanation: anExplanation.! !


!classDefinition: #InputTable category: #Playground!
LayoutMorph subclass: #InputTable
	instanceVariableNames: 'title borderMorph titleContainer titleMorph titleContainerLayoutSpec columns'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Playground'!

!InputTable methodsFor: 'as yet unclassified' stamp: 'FGJ 1/22/2019 15:30:47'!
drawOn: aCanvas

	aCanvas
		fillRectangle: self morphLocalBounds
		color: Color lightGray.! !

!InputTable methodsFor: 'as yet unclassified' stamp: 'FGJ 1/22/2019 15:42:13'!
withColumns: columnsTitles withRows: rowsTitles

	| columnTitleLayoutSpec rowsTitlesColumn rowsTitlesTitleContainer |

	rowsTitlesColumn := LayoutMorph newColumn.
	rowsTitlesColumn separation: 4; color: Color lightGray.
	
	title := StringMorph contents: 'Variable Name'.
	rowsTitlesTitleContainer := RectangleLikeMorph new color: Color lightGray.
	rowsTitlesTitleContainer addMorph: title.
	columnTitleLayoutSpec := LayoutSpec fixedWidth: title morphWidth fixedHeight: title morphHeight.
	rowsTitlesColumn addMorph: rowsTitlesTitleContainer layoutSpec: columnTitleLayoutSpec.
	
	rowsTitles do: [:aRowTitle |
		| titleLayoutSpec |
		
		title := StringMorph contents: aRowTitle.
		titleContainer := RectangleLikeMorph new color: Color lightGray.
		titleContainer addMorph: title.
		titleLayoutSpec := LayoutSpec fixedWidth: title morphWidth fixedHeight: title morphHeight.
		rowsTitlesColumn addMorph: titleContainer layoutSpec: titleLayoutSpec.
		
	].
	self addMorph: rowsTitlesColumn.
	
	columns := columnsTitles collect: [:aColumnName |
		| columnMorph columnTitleContainer title |
		
		columnMorph := LayoutMorph newColumn.
		columnMorph separation: 4; color: Color lightGray.
		
		title := StringMorph contents: aColumnName.
		columnTitleContainer := RectangleLikeMorph new color: Color lightGray.
		columnTitleContainer addMorph: title.
		columnTitleLayoutSpec := LayoutSpec fixedWidth: title morphWidth fixedHeight: title morphHeight.
		columnMorph addMorph: columnTitleContainer layoutSpec: columnTitleLayoutSpec.
		
		rowsTitles size timesRepeat: [
			| inputMorph inputMorphLayoutSpec |
			inputMorph := TextModelMorph textProvider: self.
			inputMorph hideScrollBarsIndefinitely.
			inputMorphLayoutSpec := LayoutSpec fixedWidth: 90 fixedHeight: 15.
			columnMorph addMorph: inputMorph layoutSpec: inputMorphLayoutSpec.
		].
	
		columnMorph.
	].
	
	columns do: [:aColumn | self addMorph: aColumn].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InputTable class' category: #Playground!
InputTable class
	instanceVariableNames: ''!

!InputTable class methodsFor: 'as yet unclassified' stamp: 'FGJ 1/22/2019 15:27:46'!
withColumns: columnsTitles withRows: rowsTitles

	^self newRow withColumns: columnsTitles withRows: rowsTitles. 
	
	! !


!classDefinition: #LabeledInput category: #Playground!
LayoutMorph subclass: #LabeledInput
	instanceVariableNames: 'labelMorph inputMorph'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Playground'!

!LabeledInput methodsFor: 'as yet unclassified' stamp: 'FGJ 1/22/2019 13:37:24'!
drawOn: aCanvas
	aCanvas
		fillRectangle: self morphLocalBounds
		color: Color lightGray.! !

!LabeledInput methodsFor: 'as yet unclassified' stamp: 'FGJ 2/1/2019 18:16:32'!
withLabel: aLabel

	| labelLayoutSpec inputMorphLayoutSpec |
	
	self separation: 5.
	
	labelMorph := StringMorph contents: aLabel.
	labelLayoutSpec := LayoutSpec 
		fixedWidth: 120
		fixedHeight: labelMorph morphHeight
		minorDirectionPadding: #center.
	self addMorph: labelMorph layoutSpec: labelLayoutSpec.
	
	"
	result := TextModelMorph
				textProvider: self
				textGetter: #response
				textSetter: #response:
				selectionGetter: #selectionInterval.
	result hasUnacceptedEdits: true.
	result acceptOnCR: acceptBoolean.
	result morphExtent: `18@5` * self sizeUnit.
	self addMorph: result position: `1@2` * self sizeUnit.
	"
	inputMorph := TextModelMorph textProvider: self.
	inputMorph hideScrollBarsIndefinitely.
	inputMorphLayoutSpec := 
		LayoutSpec 
			proportionalWidth: 0.5
			fixedHeight: labelMorph morphHeight + 2.
	self addMorph: inputMorph layoutSpec: inputMorphLayoutSpec.
	
	
	
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LabeledInput class' category: #Playground!
LabeledInput class
	instanceVariableNames: ''!

!LabeledInput class methodsFor: 'as yet unclassified' stamp: 'FGJ 1/18/2019 18:10:59'!
withLabel: aLabel

	^self newRow withLabel: aLabel! !


!classDefinition: #LabeledAutocompletedInput category: #Playground!
LabeledInput subclass: #LabeledAutocompletedInput
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Playground'!

!LabeledAutocompletedInput methodsFor: 'as yet unclassified' stamp: 'FGJ 2/1/2019 12:32:07'!
autoCompleterClassFor: textGetter
	^SmalltalkCompleter! !
