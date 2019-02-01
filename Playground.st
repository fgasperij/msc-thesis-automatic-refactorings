!classDefinition: #ExtractToMethodObjectPanel category: #Playground!
SystemWindow subclass: #ExtractToMethodObjectPanel
	instanceVariableNames: 'variablesFormGroup'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Playground'!

!ExtractToMethodObjectPanel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/1/2019 12:34:26'!
buildMorphicWindow

	| classFormGroup variables columnsNames |
	
	self setLabel: 'Extract Method to Method Object Panel'.
	self layoutMorph separation: 10.
	
	classFormGroup := FormGroup withTitle: 'Method Object class'.
	classFormGroup
			addMorph: (LabeledInput withLabel: 'Name') 
			layoutSpec: (LayoutSpec proportionalWidth: 0.95).
	classFormGroup
			addMorph: (LabeledAutocompletedInput withLabel: 'Superclass name') 
			layoutSpec: (LayoutSpec proportionalWidth: 0.95).
	classFormGroup
			addMorph: (LabeledInput withLabel: 'Category') 
			layoutSpec: (LayoutSpec proportionalWidth: 0.95).
		
	self layoutMorph 
		addMorph: classFormGroup layoutSpec: (LayoutSpec proportionalWidth: 0.95).
		
	variablesFormGroup := FormGroup withTitle: 'Variables to parametrize'.
	variables := #(self anInstVar aClassVar).
	columnsNames := #('Inst Var Name' 'Keyword' 'Parameter name').
	variablesFormGroup addMorph: (InputTable withColumns: columnsNames withRows: variables).
	self layoutMorph 
		addMorph: variablesFormGroup layoutSpec: (LayoutSpec proportionalWidth: 0.95 proportionalHeight: 0.3).
	! !


!classDefinition: #FormGroup category: #Playground!
LayoutMorph subclass: #FormGroup
	instanceVariableNames: 'title borderMorph titleContainer titleMorph titleContainerLayoutSpec'
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

!FormGroup methodsFor: 'as yet unclassified' stamp: 'FGJ 1/22/2019 14:25:13'!
initializeWithTitle: aTitle

	title := aTitle.
	
	self separation: 5.
	
	titleMorph := StringMorph 
		contents: title 
		font: (AbstractFont familyName: Preferences defaultFontFamily pointSize: 17)
		emphasis: 1.
	titleContainer := RectangleLikeMorph new color: Color white.
	titleContainer addMorph: titleMorph.
	
	titleContainerLayoutSpec := LayoutSpec fixedHeight: titleMorph morphHeight.
	titleContainerLayoutSpec minorDirectionPadding: #left.
	
	self addMorph: titleContainer layoutSpec: titleContainerLayoutSpec.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FormGroup class' category: #Playground!
FormGroup class
	instanceVariableNames: ''!

!FormGroup class methodsFor: 'as yet unclassified' stamp: 'FGJ 1/18/2019 15:30:14'!
withTitle: aTitle

	^FormGroup newColumn initializeWithTitle: aTitle.! !


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

!LabeledInput methodsFor: 'as yet unclassified' stamp: 'FGJ 1/22/2019 14:13:46'!
withLabel: aLabel

	| labelLayoutSpec inputMorphLayoutSpec |
	
	self separation: 5.
	
	labelMorph := StringMorph contents: aLabel.
	labelLayoutSpec := LayoutSpec 
		fixedWidth: labelMorph morphWidth
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
