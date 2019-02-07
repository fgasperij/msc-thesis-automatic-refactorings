!classDefinition: #ColoredScrollPane category: #Playground!
PluggableScrollPane subclass: #ColoredScrollPane
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Playground'!

!ColoredScrollPane methodsFor: 'as yet unclassified' stamp: 'FGJ 2/5/2019 16:22:45'!
drawOn: aCanvas

	color := Color lightGray.
	
	super drawOn: aCanvas.! !

!ColoredScrollPane methodsFor: 'as yet unclassified' stamp: 'FGJ 2/5/2019 16:24:51'!
getMenu
	
	^nil! !


!classDefinition: #ExtractToMethodObjectPanel category: #Playground!
SystemWindow subclass: #ExtractToMethodObjectPanel
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Playground'!

!ExtractToMethodObjectPanel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/5/2019 16:25:41'!
backgroundColor

	^Color lightGray! !

!ExtractToMethodObjectPanel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/7/2019 12:44:12'!
buildMorphicWindow

	| classFormGroup scrollPane formLayout requiredExtent columnsNames creationMessageFormGroup variables variablesFormGroup requiredHeight classFormGroupLabels maxLabelWidth |
	
	self setLabel: 'Extract Method to Method Object'.
	
	scrollPane := ColoredScrollPane initializedInstance.
	scrollPane scroller color: self backgroundColor.
	scrollPane scroller layoutSpec: LayoutSpec useAll.
	scrollPane color: self backgroundColor. 
	self layoutMorph addMorphUseAll: scrollPane.
	
	formLayout := LayoutMorph newColumn.
	formLayout separation: 10; color: self backgroundColor.
	scrollPane scroller addMorph: formLayout.
	
	classFormGroup := FormGroup withTitle: 'Method Object class' withColor: self backgroundColor.
	classFormGroupLabels := #( 'Name' 'Superclass name' 'Category').
	maxLabelWidth := (classFormGroupLabels collect: [:aLabel | AbstractFont default widthOfString: aLabel]) max + 20.
	classFormGroup
			addMorph: (LabeledInput withLabel: 'Name' withWidth: maxLabelWidth)
			layoutSpec: (LayoutSpec proportionalWidth: 0.95 fixedHeight: LabeledInput recommendedHeight).
	classFormGroup
			addMorph: (LabeledAutocompletedInput withLabel: 'Superclass name' withWidth: maxLabelWidth) 
			layoutSpec: (LayoutSpec proportionalWidth: 0.95 fixedHeight: LabeledInput recommendedHeight).
	classFormGroup
			addMorph: (LabeledInput withLabel: 'Category' withWidth: maxLabelWidth) 
			layoutSpec: (LayoutSpec proportionalWidth: 0.95 fixedHeight: LabeledInput recommendedHeight).

	formLayout
		addMorph: classFormGroup
		layoutSpec: (LayoutSpec proportionalWidth: 0.95 fixedHeight: classFormGroup recommendedHeight ).

		
	variablesFormGroup := FormGroup 
		withTitle: 'Instance variables names'
		withExplanation: 'Instance, class and pool variables referenced by the method will be passed as collaborators to the MethodObject. The method object will have one instance variable corresponding to each of them. Pick their names:'
		withColor: self backgroundColor.
	variables := #(self anInstVar aClassVar).
	maxLabelWidth := (variables collect: [:aLabel | AbstractFont default widthOfString: aLabel]) max + 20.
	variables do: [ :aVariable |
		variablesFormGroup
			addMorph: (LabeledInput withLabel: aVariable withWidth: maxLabelWidth) 
			layoutSpec: (LayoutSpec proportionalWidth: 0.95 fixedHeight: LabeledInput recommendedHeight )].
	
	formLayout 
		addMorph: variablesFormGroup
		layoutSpec: (LayoutSpec proportionalWidth: 0.95 fixedHeight: variablesFormGroup recommendedHeight ).
	
	
	creationMessageFormGroup := FormGroup
		withTitle: 'Instance creation message definition'
		withExplanation: 'The collaborators will be passed in the MethodObject instance creation message. Pick the keyword and the formal parameter name corresponding to each collaborator:'
		withColor: self backgroundColor .
	variables := #(self anInstVar aClassVar).
	columnsNames := #('Keyword' 'Parameter name').
	creationMessageFormGroup addMorph: (InputTable withColumns: columnsNames withRows: variables withColor: self backgroundColor ).
	
	formLayout 
		addMorph: creationMessageFormGroup
		layoutSpec: (LayoutSpec proportionalWidth: 0.95 fixedHeight: creationMessageFormGroup recommendedHeight ).
	
	requiredHeight := classFormGroup recommendedHeight + variablesFormGroup recommendedHeight + creationMessageFormGroup recommendedHeight + (formLayout ySeparation * 4).	
	
	requiredExtent := ExtractToMethodObjectPanel recommendedWidth@requiredHeight.
	formLayout morphExtent: requiredExtent.
	scrollPane scroller morphExtent: requiredExtent.! !

!ExtractToMethodObjectPanel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/6/2019 13:12:47'!
fontPreferenceChanged
	"Copied from CodePackageListWindow"
	"System fonts have changed; rebuild myself"
	self layoutMorph removeAllMorphs.
	super fontPreferenceChanged.
	self buildMorphicWindow.
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ExtractToMethodObjectPanel class' category: #Playground!
ExtractToMethodObjectPanel class
	instanceVariableNames: ''!

!ExtractToMethodObjectPanel class methodsFor: 'as yet unclassified' stamp: 'FGJ 2/7/2019 12:08:59'!
recommendedWidth

	^(AbstractFont default widthOf: $A) * 70! !


!classDefinition: #FormGroup category: #Playground!
LayoutMorph subclass: #FormGroup
	instanceVariableNames: 'title borderMorph titleContainer titleMorph titleContainerLayoutSpec explanation explanationMorph explanationContainer explanationContainerLayoutSpec'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Playground'!

!FormGroup methodsFor: 'as yet unclassified' stamp: 'FGJ 2/4/2019 12:53:57'!
drawOn: aCanvas
	aCanvas
		fillRectangle: self morphLocalBounds
		color: color
		borderWidth: 2
		borderStyleSymbol: #simple
		baseColorForBorder: Color darkGray ! !

!FormGroup methodsFor: 'as yet unclassified' stamp: 'FGJ 2/7/2019 12:31:22'!
initializeWithTitle: aTitle withExplanation: anExplanation withColor: aColor

	| explanationMorphLayoutSpec bottomSpaceToAccountForLettersBelowBaseLineLikep titleLayoutSpec |
	
	title := aTitle.
	explanation := anExplanation.
	
	self separation: 3.
	self color: aColor.
	
	titleMorph := StringMorph 
		contents: title 
		font: Preferences windowTitleFont 
		emphasis: 1.
	titleLayoutSpec := LayoutSpec 
		fixedWidth: titleMorph morphWidth 
		fixedHeight: titleMorph morphHeight.
	titleLayoutSpec minorDirectionPadding: 0.03.
	
	self addMorph: titleMorph layoutSpec: titleLayoutSpec.
	
	explanation isEmpty ifFalse: [
		explanationMorph := TextModelMorph withText: anExplanation.
		explanationMorph color: aColor.
		explanationMorph disableEditing.
		explanationMorph drawKeyboardFocusIndicator: false.
		explanationMorph lock: true.
		explanationMorph hideScrollBarsIndefinitely.
		
		bottomSpaceToAccountForLettersBelowBaseLineLikep := 5.
		explanationMorphLayoutSpec := LayoutSpec proportionalWidth: 0.95 fixedHeight: (self minimumHeightToDisplay: anExplanation) + bottomSpaceToAccountForLettersBelowBaseLineLikep.
		explanationMorphLayoutSpec minorDirectionPadding: #left.
		
		self addMorph: explanationMorph layoutSpec: explanationMorphLayoutSpec.
	].! !

!FormGroup methodsFor: 'as yet unclassified' stamp: 'FGJ 2/7/2019 10:57:41'!
minimumHeightToDisplay: aString

	| aComposer composition lines aText |
	
	aComposer := TextComposer new.
	aText := Text fromString: aString.
	composition := aComposer composeLinesFrom: 1 to: aText size delta: 0 into: OrderedCollection new priorLines: Array new atY: 0 text: aText extentForComposing: self width @ 999999. 
	lines := composition first asArray size.
	
	^lines * self textHeight! !

!FormGroup methodsFor: 'as yet unclassified' stamp: 'FGJ 2/6/2019 21:05:18'!
recommendedHeight

	^((self submorphs collect: [:aMorph | aMorph layoutSpec fixedHeight]) sum) + ( (self submorphs size + 1) * self ySeparation)! !

!FormGroup methodsFor: 'as yet unclassified' stamp: 'FGJ 2/7/2019 10:57:14'!
textHeight
	
	^AbstractFont default height! !

!FormGroup methodsFor: 'as yet unclassified' stamp: 'FGJ 2/7/2019 12:07:50'!
width

	^ExtractToMethodObjectPanel recommendedWidth * 0.7! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FormGroup class' category: #Playground!
FormGroup class
	instanceVariableNames: ''!

!FormGroup class methodsFor: 'as yet unclassified' stamp: 'FGJ 2/5/2019 17:01:17'!
withTitle: aTitle withColor: aColor

	^self withTitle: aTitle withExplanation: '' withColor: aColor.! !

!FormGroup class methodsFor: 'as yet unclassified' stamp: 'FGJ 2/5/2019 16:59:12'!
withTitle: aTitle withExplanation: anExplanation withColor: aColor

	^FormGroup newColumn initializeWithTitle: aTitle withExplanation: anExplanation withColor: aColor.! !


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

!InputTable methodsFor: 'as yet unclassified' stamp: 'FGJ 2/7/2019 11:48:31'!
withColumns: columnsTitles withRows: rowsTitles withColor: aColor

	| rowsTitlesColumn rowsSeparation recommendedHeight textHeight numberOfRows widthForInputs maxRowTitleWidth |

	rowsSeparation := 4.
	textHeight := AbstractFont default height.
	numberOfRows := (rowsTitles size + 1).
	recommendedHeight := textHeight * numberOfRows + (rowsSeparation * (numberOfRows + 1)).
	self layoutSpec: (LayoutSpec fixedHeight: recommendedHeight).
	
	"Build the row titles column"
	rowsTitlesColumn := LayoutMorph newColumn.
	rowsTitlesColumn separation: rowsSeparation; color: aColor.
	
	title := StringMorph contents: ''.
	rowsTitlesColumn addMorph: title.
	
	rowsTitles do: [:aRowTitle | | titleLayoutSpec |
		title := StringMorph contents: aRowTitle.
		titleLayoutSpec := LayoutSpec new.
		titleLayoutSpec minorDirectionPadding: #left.
		rowsTitlesColumn addMorph: title layoutSpec: titleLayoutSpec.
	].
	maxRowTitleWidth := (rowsTitles collect: [:aRowTitle | AbstractFont default widthOfString: aRowTitle]) max * 1.5.
	self addMorph: rowsTitlesColumn layoutSpec: (LayoutSpec fixedWidth: maxRowTitleWidth).
	
	"Build the input columns"
	columns := columnsTitles collect: [:aColumnName |
		| columnMorph title |
		
		columnMorph := LayoutMorph newColumn.
		columnMorph separation: rowsSeparation; color: aColor.
		widthForInputs := (AbstractFont default widthOf: $A) * 20.
		columnMorph layoutSpec: (LayoutSpec fixedWidth: widthForInputs).
		
		title := StringMorph contents: aColumnName.
		columnMorph addMorph: title.
		
		rowsTitles size timesRepeat: [
			| inputMorph |
			inputMorph := TextModelMorph textProvider: self.
			inputMorph hideScrollBarsIndefinitely.
			columnMorph addMorph: inputMorph layoutSpec: (LayoutSpec fixedWidth: widthForInputs).
		].
	
		columnMorph.
	].
	
	columns do: [:aColumn | self addMorph: aColumn].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InputTable class' category: #Playground!
InputTable class
	instanceVariableNames: ''!

!InputTable class methodsFor: 'as yet unclassified' stamp: 'FGJ 2/7/2019 10:40:49'!
withColumns: columnsTitles withRows: rowsTitles withColor: aColor

	^self newRow withColumns: columnsTitles withRows: rowsTitles withColor: aColor. 
	
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

!LabeledInput methodsFor: 'as yet unclassified' stamp: 'FGJ 2/7/2019 12:38:21'!
withLabel: aLabel withWidth: aWidth

	| labelLayoutSpec inputMorphLayoutSpec |
	
	self separation: 5.
	
	labelMorph := StringMorph contents: aLabel.
	labelLayoutSpec := LayoutSpec 
		fixedWidth: aWidth
		fixedHeight: labelMorph morphHeight
		minorDirectionPadding: #center.
	self addMorph: labelMorph layoutSpec: labelLayoutSpec.
	
	inputMorph := TextModelMorph textProvider: self.
	inputMorph hideScrollBarsIndefinitely.
	inputMorphLayoutSpec := 
		LayoutSpec 
			fixedWidth: (AbstractFont default widthOf: $A) * 30
			fixedHeight: labelMorph morphHeight + 2.
	self addMorph: inputMorph layoutSpec: inputMorphLayoutSpec.
	
	
	
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LabeledInput class' category: #Playground!
LabeledInput class
	instanceVariableNames: ''!

!LabeledInput class methodsFor: 'as yet unclassified' stamp: 'FGJ 2/6/2019 20:39:39'!
recommendedHeight

	^AbstractFont default height * 1.8! !

!LabeledInput class methodsFor: 'as yet unclassified' stamp: 'FGJ 2/7/2019 11:50:57'!
withLabel: aLabel withWidth: aWidth

	^self newRow withLabel: aLabel withWidth: aWidth! !


!classDefinition: #LabeledAutocompletedInput category: #Playground!
LabeledInput subclass: #LabeledAutocompletedInput
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Playground'!

!LabeledAutocompletedInput methodsFor: 'as yet unclassified' stamp: 'FGJ 2/1/2019 12:32:07'!
autoCompleterClassFor: textGetter
	^SmalltalkCompleter! !
