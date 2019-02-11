!classDefinition: #ImmutableTextModelMorph category: #Playground!
TextModelMorph subclass: #ImmutableTextModelMorph
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Playground'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ImmutableTextModelMorph class' category: #Playground!
ImmutableTextModelMorph class
	instanceVariableNames: ''!

!ImmutableTextModelMorph class methodsFor: 'as yet unclassified' stamp: 'FGJ 2/9/2019 19:42:39'!
minimumHeightToDisplay: aString on: aWidth

	| aComposer composition lines aText disregardHeight |
	
	aComposer := TextComposer new.
	aText := Text fromString: aString.
	disregardHeight := 999999.
	composition := aComposer composeLinesFrom: 1 to: aText size delta: 0 into: OrderedCollection new priorLines: Array new atY: 0 text: aText extentForComposing: aWidth @ disregardHeight. 
	lines := composition first asArray size.
	
	^lines * self textHeight! !

!ImmutableTextModelMorph class methodsFor: 'as yet unclassified' stamp: 'FGJ 2/9/2019 19:43:22'!
textHeight
	
	^AbstractFont default height! !

!ImmutableTextModelMorph class methodsFor: 'as yet unclassified' stamp: 'FGJ 2/9/2019 19:42:21'!
withText: aText withColor: aColor withWidth: aWidth

	| anInstance anInstanceLayoutSpec bottomSpaceToAccountForLettersBelowBaseLineLikep |

	anInstance := super withText: aText.
	anInstance color: aColor.
	anInstance disableEditing.
	anInstance drawKeyboardFocusIndicator: false.
	anInstance lock: true.
	anInstance hideScrollBarsIndefinitely.
	
	bottomSpaceToAccountForLettersBelowBaseLineLikep := 5.
	anInstanceLayoutSpec := LayoutSpec 
		proportionalWidth: 0.95
		fixedHeight: (self minimumHeightToDisplay: aText on: aWidth) + bottomSpaceToAccountForLettersBelowBaseLineLikep.
	anInstanceLayoutSpec minorDirectionPadding: #left.
	anInstance layoutSpec: anInstanceLayoutSpec. 
	
	^anInstance! !


!classDefinition: #PreviewTextModelMorph category: #Playground!
TextModelMorph subclass: #PreviewTextModelMorph
	instanceVariableNames: 'previewModel'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Playground'!

!PreviewTextModelMorph methodsFor: 'as yet unclassified' stamp: 'FGJ 2/11/2019 10:40:38'!
innerMorphClass

	^PreviewInnerTextMorph ! !


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
	instanceVariableNames: 'scrollPane formLayout inputTable preview'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Playground'!

!ExtractToMethodObjectPanel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/5/2019 16:25:41'!
backgroundColor

	^Color lightGray! !

!ExtractToMethodObjectPanel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/11/2019 12:56:31'!
buildMorphicWindow

	| classFormGroup requiredExtent columnsNames creationMessageFormGroup variables variablesFormGroup requiredHeight maxLabelWidth inputLayoutSpec previewExplanation previewLayoutSpec |
	
	self setLabel: 'Extract Method to Method Object'.
	
	self initializeScrollableContainer.
	self initializeFormLayout.
	
	"Method object class section"
	classFormGroup := FormGroup withTitle: 'Method Object class' withColor: self backgroundColor.
	maxLabelWidth := self recommendedWidthForLabels: #( 'Name' 'Superclass name' 'Category' 'Evaluation message selector').
	inputLayoutSpec := LayoutSpec proportionalWidth: 0.95 fixedHeight: LabeledInput recommendedHeight.
	classFormGroup addMorph: (LabeledInput withLabel: 'Name' withWidth: maxLabelWidth) layoutSpec: inputLayoutSpec.
	classFormGroup addMorph: (LabeledAutocompletedInput withLabel: 'Superclass name' withWidth: maxLabelWidth) layoutSpec: inputLayoutSpec.
	classFormGroup addMorph: (LabeledInput withLabel: 'Category' withWidth: maxLabelWidth) layoutSpec: inputLayoutSpec.
	classFormGroup addMorph: (LabeledInput withLabel: 'Evaluation message selector' withWidth: maxLabelWidth) layoutSpec: inputLayoutSpec.

	formLayout
		addMorph: classFormGroup
		layoutSpec: (LayoutSpec proportionalWidth: 0.95 fixedHeight: classFormGroup recommendedHeight ).

	
	"Instance variables section"		
	variablesFormGroup := FormGroup 
		withTitle: 'Instance variables names'
		withExplanation: 'Instance, class and pool variables referenced by the method will be passed as collaborators to the MethodObject. The method object will have one instance variable corresponding to each of them. Pick their names:'
		withColor: self backgroundColor.
	variables := #(self anInstVar aClassVar).
	maxLabelWidth := self recommendedWidthForLabels: variables.
	variables do: [ :aVariable |
		variablesFormGroup
			addMorph: (LabeledInput withLabel: aVariable withWidth: maxLabelWidth) 
			layoutSpec: inputLayoutSpec].
	
	formLayout 
		addMorph: variablesFormGroup
		layoutSpec: (LayoutSpec proportionalWidth: 0.95 fixedHeight: variablesFormGroup recommendedHeight ).
	
	
	"Instance creation message section"
	creationMessageFormGroup := FormGroup
		withTitle: 'Instance creation message definition'
		withExplanation: 'The collaborators will be passed in the MethodObject instance creation message. Pick the keyword and the formal parameter name corresponding to each collaborator:'
		withColor: self backgroundColor .
	columnsNames := #('Keyword' 'Parameter name').
	
	inputTable := InputTable withColumns: columnsNames withRows: variables withColor: self backgroundColor withPreviewModel: self.
	creationMessageFormGroup addMorph: inputTable.
	previewExplanation := ImmutableTextModelMorph 
		withText: 'This is how the instance creation message header will look:'
		withColor: self backgroundColor
		withWidth: creationMessageFormGroup width.
	creationMessageFormGroup addMorph: previewExplanation.
	
	preview := TextModelMorph textProvider: self.
	preview model actualContents: 'All the keywords and parameter names must be filled for the preview to appear here'.
	preview color: Color white.
	preview disableEditing.
	preview drawKeyboardFocusIndicator: false.
	preview lock: true.
	
	previewLayoutSpec := LayoutSpec 
		proportionalWidth: 0.95
		fixedHeight: AbstractFont default height * 3.
	previewLayoutSpec minorDirectionPadding: 0.3.
	preview layoutSpec: previewLayoutSpec. 
	
	creationMessageFormGroup addMorph: preview.
	
	formLayout 
		addMorph: creationMessageFormGroup
		layoutSpec: (LayoutSpec proportionalWidth: 0.95 fixedHeight: creationMessageFormGroup recommendedHeight ).
	
	requiredHeight := classFormGroup recommendedHeight + variablesFormGroup recommendedHeight + creationMessageFormGroup recommendedHeight + (formLayout ySeparation * 4).	
	
	requiredExtent := ExtractToMethodObjectPanel recommendedWidth@requiredHeight.
	formLayout morphExtent: requiredExtent.
	scrollPane scroller morphExtent: requiredExtent.! !

!ExtractToMethodObjectPanel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/11/2019 11:34:18'!
buildPreview

	| keywordParamStrings previewContent |
	
	keywordParamStrings := OrderedCollection new.
	inputTable submorphs allButLast do: [:aSubmorph | | keyword parameterName |
		keyword := (aSubmorph submorphs at: 3) model actualContents.
		parameterName := (aSubmorph submorphs at: 2) model actualContents.
		keywordParamStrings addFirst: '', keyword, ': ', parameterName.].
	
	previewContent := ' ' join: keywordParamStrings.
	
	preview model actualContents: previewContent.! !

!ExtractToMethodObjectPanel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/6/2019 13:12:47'!
fontPreferenceChanged
	"Copied from CodePackageListWindow"
	"System fonts have changed; rebuild myself"
	self layoutMorph removeAllMorphs.
	super fontPreferenceChanged.
	self buildMorphicWindow.
! !

!ExtractToMethodObjectPanel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/7/2019 12:52:59'!
initializeFormLayout

	formLayout := LayoutMorph newColumn.
	formLayout separation: 10; color: self backgroundColor.
	scrollPane scroller addMorph: formLayout.! !

!ExtractToMethodObjectPanel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/7/2019 12:52:07'!
initializeScrollableContainer

	scrollPane := ColoredScrollPane initializedInstance.
	scrollPane scroller color: self backgroundColor.
	scrollPane scroller layoutSpec: LayoutSpec useAll.
	scrollPane color: self backgroundColor. 
	self layoutMorph addMorphUseAll: scrollPane.! !

!ExtractToMethodObjectPanel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/7/2019 13:03:15'!
recommendedWidthForLabels: labels

	| rightMargin |
	
	rightMargin := 20.
	^(labels collect: [:aLabel | AbstractFont default widthOfString: aLabel]) max + rightMargin! !

!ExtractToMethodObjectPanel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/10/2019 19:04:21'!
row: aRowIndex wasSwappedWith: anotherRowIndex

	self buildPreview.! !

!ExtractToMethodObjectPanel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/11/2019 13:04:47'!
shouldStyle: text with: anSHTextStyler

	anSHTextStyler classOrMetaClass: Object.
	^true! !

!ExtractToMethodObjectPanel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/11/2019 10:44:42'!
textInputReceivedKeyStroke

	self buildPreview.! !

!ExtractToMethodObjectPanel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/11/2019 12:57:14'!
textStylerClassFor: textGetter

	^SHTextStylerST80 ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ExtractToMethodObjectPanel class' category: #Playground!
ExtractToMethodObjectPanel class
	instanceVariableNames: ''!

!ExtractToMethodObjectPanel class methodsFor: 'as yet unclassified' stamp: 'FGJ 2/7/2019 13:08:41'!
fontProportionalUnitOfReference

	^AbstractFont default widthOf: $A! !

!ExtractToMethodObjectPanel class methodsFor: 'as yet unclassified' stamp: 'FGJ 2/7/2019 13:08:52'!
recommendedWidth

	^self fontProportionalUnitOfReference * 70! !


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

!FormGroup methodsFor: 'as yet unclassified' stamp: 'FGJ 2/6/2019 21:05:18'!
recommendedHeight

	^((self submorphs collect: [:aMorph | aMorph layoutSpec fixedHeight]) sum) + ( (self submorphs size + 1) * self ySeparation)! !

!FormGroup methodsFor: 'as yet unclassified' stamp: 'FGJ 2/7/2019 10:57:14'!
textHeight
	
	^AbstractFont default height! !

!FormGroup methodsFor: 'as yet unclassified' stamp: 'FGJ 2/7/2019 12:07:50'!
width

	^ExtractToMethodObjectPanel recommendedWidth * 0.7! !


!FormGroup methodsFor: 'initialization' stamp: 'FGJ 2/9/2019 19:43:51'!
initializeWithTitle: aTitle withExplanation: anExplanation withColor: aColor

	| titleLayoutSpec |
	
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
		explanationMorph := ImmutableTextModelMorph 
			withText: anExplanation 
			withColor: aColor
			withWidth: self width.
		self addMorph: explanationMorph.
	].! !

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
	instanceVariableNames: 'title borderMorph titleContainer titleMorph titleContainerLayoutSpec columns rowModels previewModel'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Playground'!

!InputTable methodsFor: 'as yet unclassified' stamp: 'FGJ 1/22/2019 15:30:47'!
drawOn: aCanvas

	aCanvas
		fillRectangle: self morphLocalBounds
		color: Color lightGray.! !

!InputTable methodsFor: 'as yet unclassified' stamp: 'FGJ 2/9/2019 17:15:41'!
isBottomRow: aRowIndex

	^aRowIndex == 1! !

!InputTable methodsFor: 'as yet unclassified' stamp: 'FGJ 2/10/2019 18:48:09'!
moveDownRow: aRowIndex

	(self isBottomRow: aRowIndex) ifFalse: [
		self swapRowSubmorph: aRowIndex with: aRowIndex -1.
		self swapRowModel: aRowIndex with: aRowIndex - 1.
		self notifyPreviewModelThat: aRowIndex wasSwappedWith: aRowIndex - 1.
		
		self rowWasMovedDown: aRowIndex - 1.
		self rowWasMovedUp: aRowIndex.].! !

!InputTable methodsFor: 'as yet unclassified' stamp: 'FGJ 2/10/2019 18:50:19'!
moveUpRow: aRowIndex

	aRowIndex <  self numberOfRowsWithoutHeaders ifTrue: [
		self swapRowSubmorph: aRowIndex with: aRowIndex + 1.
		self swapRowModel: aRowIndex with: aRowIndex + 1.
		self notifyPreviewModelThat: aRowIndex wasSwappedWith: aRowIndex + 1.
		
		self rowWasMovedUp: aRowIndex + 1.
		self rowWasMovedDown: aRowIndex.].! !

!InputTable methodsFor: 'as yet unclassified' stamp: 'FGJ 2/10/2019 18:49:07'!
notifyPreviewModelThat: aRowIndex wasSwappedWith: anotherRowIndex

	previewModel row: aRowIndex wasSwappedWith: anotherRowIndex.! !

!InputTable methodsFor: 'as yet unclassified' stamp: 'FGJ 2/9/2019 16:59:36'!
numberOfRowsWithoutHeaders

	^self submorphs size - 1! !

!InputTable methodsFor: 'as yet unclassified' stamp: 'FGJ 2/9/2019 17:20:09'!
rowWasMovedDown: aRowIndex

	(rowModels at: aRowIndex) wasMovedDown.! !

!InputTable methodsFor: 'as yet unclassified' stamp: 'FGJ 2/9/2019 17:20:24'!
rowWasMovedUp: aRowIndex

	(rowModels at: aRowIndex) wasMovedUp.! !

!InputTable methodsFor: 'as yet unclassified' stamp: 'FGJ 2/9/2019 17:16:44'!
swapRowModel: aRowIndex with: anotherRowIndex

	rowModels swap: aRowIndex with: anotherRowIndex.! !

!InputTable methodsFor: 'as yet unclassified' stamp: 'FGJ 2/9/2019 17:48:55'!
swapRowSubmorph: aRowIndex with: anotherRowIndex

	self privateSubmorphs swap: aRowIndex with: anotherRowIndex.
	
	self flag: #todofgj.
	"It seems that the redraw isn't needed. Remove later if that's the case."
	"self redrawNeeded."
	self layoutSubmorphs.! !


!InputTable methodsFor: 'initialization' stamp: 'FGJ 2/11/2019 10:42:24'!
withColumns: inputColumsTitles withRows: rowsTitles withColor: aColor withPreviewModel: aPreviewModel

	| rowsSeparation recommendedHeight textHeight numberOfRows widthForInputs maxRowTitleWidth columnsTitlesRow columnWidths columnsTitles columnSeparation rowsLayoutSpec rowHeight |

	rowModels := OrderedCollection new.
	previewModel := aPreviewModel.

	rowsSeparation := 4.
	self separation: rowsSeparation.
	
	textHeight := AbstractFont default height.
	numberOfRows := (rowsTitles size + 1).
	rowHeight := textHeight * 1.6.
	recommendedHeight :=  rowHeight * numberOfRows + (rowsSeparation * (numberOfRows + 1)).
	self layoutSpec: (LayoutSpec fixedHeight: recommendedHeight).
	
	columnSeparation := 4.
	
	rowsLayoutSpec := LayoutSpec fixedHeight: rowHeight.
	
	
	"Calculate column widths"
	columnWidths := OrderedCollection new.
	
	maxRowTitleWidth := (rowsTitles collect: [:aRowTitle | AbstractFont default widthOfString: aRowTitle]) max + 20.
	columnWidths add: maxRowTitleWidth.
	
	widthForInputs := ExtractToMethodObjectPanel fontProportionalUnitOfReference * 20.
	inputColumsTitles size timesRepeat: [columnWidths add: widthForInputs].
	
	columnWidths add: (AbstractFont default widthOfString: 'Change order').
	
	
	"Buid the columns titles row"
	columnsTitlesRow := LayoutMorph newRow.
	columnsTitlesRow color: aColor; separation: columnSeparation.
	
	columnsTitles := OrderedCollection newFrom: inputColumsTitles.
	columnsTitles addFirst: ''; addLast: 'Change order'.
	columnsTitles withIndexDo: [:aColumnTitle :columnIndex | | columnTitleLayoutSpec titleLayout |
		titleLayout := LayoutMorph newRow.
		titleLayout padding: #center.
		titleLayout addMorph: (StringMorph contents: aColumnTitle).
		columnTitleLayoutSpec := LayoutSpec fixedWidth: (columnWidths at: columnIndex).
		columnsTitlesRow 
			addMorph: titleLayout
			layoutSpec: columnTitleLayoutSpec].
	
	self addMorph: columnsTitlesRow layoutSpec: rowsLayoutSpec.
	
	"Build the input rows"
	rowsTitles withIndexDo: [:aRowTitle :index | | aRow changeOrderModel upButton downButton layoutButtons |
		aRow := LayoutMorph newRow.
		aRow color: aColor; separation: columnSeparation.
		
		aRow 
			addMorph: (StringMorph contents: aRowTitle)
			layoutSpec: (LayoutSpec fixedWidth: (columnWidths at: 1)).
			
		inputColumsTitles withIndexDo: [:ignore :columnIndex | | inputMorph |
			inputMorph := PreviewTextModelMorph textProvider: self.
			inputMorph textMorph previewModel: aPreviewModel.
			inputMorph hideScrollBarsIndefinitely.
			aRow 
				addMorph: inputMorph 
				layoutSpec: (LayoutSpec fixedWidth: (columnWidths at: columnIndex + 1) fixedHeight: rowHeight)].
		
		changeOrderModel := ChangeRowOrderButtonModel for: (rowsTitles size + 1 - index) notifying: self.
		rowModels addFirst: changeOrderModel.
		
		upButton := PluggableButtonMorph new.
		upButton icon: Theme current goUpIcon.
		upButton model: changeOrderModel.
		upButton action: #moveUp.
				
		downButton := PluggableButtonMorph new.
		downButton icon: Theme current goDownIcon.
		downButton model: changeOrderModel.
		downButton action: #moveDown.
		
		layoutButtons := LayoutMorph newRow.
		layoutButtons padding: #center; color: aColor.
		layoutButtons addMorph: downButton; addMorph: upButton.	
		
		aRow
			addMorph: layoutButtons
			layoutSpec: (LayoutSpec fixedWidth: (columnWidths last)).
			
		self addMorph: aRow layoutSpec: rowsLayoutSpec.
	].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InputTable class' category: #Playground!
InputTable class
	instanceVariableNames: ''!

!InputTable class methodsFor: 'as yet unclassified' stamp: 'FGJ 2/10/2019 18:33:48'!
withColumns: columnsTitles withRows: rowsTitles withColor: aColor withPreviewModel: aPreviewModel

	^self newColumn withColumns: columnsTitles withRows: rowsTitles withColor: aColor withPreviewModel: aPreviewModel. 
	
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

!LabeledInput methodsFor: 'as yet unclassified' stamp: 'FGJ 2/7/2019 13:09:13'!
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
			fixedWidth: ExtractToMethodObjectPanel fontProportionalUnitOfReference * 30
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


!classDefinition: #PreviewInnerTextMorph category: #Playground!
InnerTextMorph subclass: #PreviewInnerTextMorph
	instanceVariableNames: 'previewModel'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Playground'!

!PreviewInnerTextMorph methodsFor: 'as yet unclassified' stamp: 'FGJ 2/11/2019 11:24:57'!
keyStroke: aKeyboardEvent
	
	super keyStroke: aKeyboardEvent.
	
	previewModel textInputReceivedKeyStroke.! !

!PreviewInnerTextMorph methodsFor: 'as yet unclassified' stamp: 'FGJ 2/11/2019 10:40:05'!
previewModel: aPreviewModel

	previewModel := aPreviewModel.! !


!classDefinition: #ChangeRowOrderButtonModel category: #Playground!
Object subclass: #ChangeRowOrderButtonModel
	instanceVariableNames: 'tableModel rowPosition'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Playground'!

!ChangeRowOrderButtonModel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/9/2019 18:13:42'!
moveDown

	tableModel moveDownRow: rowPosition.! !

!ChangeRowOrderButtonModel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/9/2019 17:21:03'!
moveUp

	tableModel moveUpRow: rowPosition.! !

!ChangeRowOrderButtonModel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/9/2019 18:13:06'!
wasMovedDown

	rowPosition := rowPosition - 1.! !

!ChangeRowOrderButtonModel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/9/2019 18:13:18'!
wasMovedUp

	rowPosition := rowPosition + 1.! !


!ChangeRowOrderButtonModel methodsFor: 'initialization' stamp: 'FGJ 2/9/2019 16:33:36'!
for: aRowIndex notifying: aTableModel

	rowPosition := aRowIndex.
	tableModel := aTableModel.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ChangeRowOrderButtonModel class' category: #Playground!
ChangeRowOrderButtonModel class
	instanceVariableNames: ''!

!ChangeRowOrderButtonModel class methodsFor: 'as yet unclassified' stamp: 'FGJ 2/8/2019 16:27:13'!
for: aRowIndex notifying: aTableModel

	^self new for: aRowIndex notifying: aTableModel! !
