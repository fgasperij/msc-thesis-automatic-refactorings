!classDefinition: #IndependentlyColoredButton category: #Playground!
PluggableButtonMorph subclass: #IndependentlyColoredButton
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Playground'!

!IndependentlyColoredButton methodsFor: 'as yet unclassified' stamp: 'FGJ 2/13/2019 12:38:30'!
adoptWidgetsColor: paneColor! !


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
	instanceVariableNames: 'scrollPane formLayout inputTable preview variablesToParametrize extractToMethodObjectRequest discardEdits'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Playground'!

!ExtractToMethodObjectPanel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/5/2019 16:25:41'!
backgroundColor

	^Color lightGray! !

!ExtractToMethodObjectPanel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/11/2019 16:59:29'!
buildPreview

	| keywordParamStrings previewContent |
	
	keywordParamStrings := OrderedCollection new.
	inputTable submorphs allButLast do: [:aSubmorph | | keyword parameterName |
		keyword := (aSubmorph submorphs at: 3) model actualContents string withBlanksTrimmed.
		parameterName := (aSubmorph submorphs at: 2) model actualContents string withBlanksTrimmed.
		
		(keyword isEmpty or: [parameterName isEmpty]) ifTrue: [
			preview model actualContents: self previewUnavailableMessage.
			^self].
		
		keywordParamStrings addFirst: '', keyword, ': ', parameterName.].
	
	previewContent := ' ' join: keywordParamStrings.
	
	preview model actualContents: previewContent.! !

!ExtractToMethodObjectPanel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/13/2019 20:07:25'!
layoutSpecForSection: aSection

	^LayoutSpec proportionalWidth: 1.0 fixedHeight: aSection recommendedHeight! !

!ExtractToMethodObjectPanel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/7/2019 13:03:15'!
recommendedWidthForLabels: labels

	| rightMargin |
	
	rightMargin := 20.
	^(labels collect: [:aLabel | AbstractFont default widthOfString: aLabel]) max + rightMargin! !

!ExtractToMethodObjectPanel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/11/2019 16:50:26'!
shouldStyle: text with: anSHTextStyler

	text = self previewUnavailableMessage ifFalse: [
		anSHTextStyler classOrMetaClass: Object.
		^true].
	
	^false.! !

!ExtractToMethodObjectPanel methodsFor: 'as yet unclassified' stamp: 'FGJ 2/11/2019 12:57:14'!
textStylerClassFor: textGetter

	^SHTextStylerST80 ! !


!ExtractToMethodObjectPanel methodsFor: 'GUI building' stamp: 'FGJ 2/13/2019 14:10:54'!
buildActionButtonsSection

	| section sectionLayoutSpec submorphsWidth sectionWidth submorphsHeight |
	
	section := LayoutMorph newRow.
	section separation: 10.
	section color: self backgroundColor.
	
	section addMorph: self buildCancelButton.
	section addMorph: self buildSubmitButton.
	
	submorphsWidth := (section submorphs collect: [:aSubmorph | aSubmorph layoutSpec fixedWidth]) sum.
	sectionWidth := submorphsWidth + (section xSeparation * (section submorphs size + 1)).
	submorphsHeight := (section submorphs collect: [:aSubmorph | aSubmorph layoutSpec fixedHeight]) max.
	sectionLayoutSpec := LayoutSpec fixedWidth: sectionWidth fixedHeight: submorphsHeight * 2.
	sectionLayoutSpec minorDirectionPadding: 0.95.

	section layoutSpec: sectionLayoutSpec.
	
	^section.
	! !

!ExtractToMethodObjectPanel methodsFor: 'GUI building' stamp: 'FGJ 2/13/2019 12:41:09'!
buildCancelButton

	| button buttonLayoutSpec |
	
	button := IndependentlyColoredButton model: self action: #cancelButtonClicked label: 'Cancel'.
	button color: Theme current cancelButton.
	
	buttonLayoutSpec := LayoutSpec 
		fixedWidth: button morphWidth
		fixedHeight: ExtractToMethodObjectPanel fontProportionalUnitOfReferenceForHeight  * 2.
	buttonLayoutSpec minorDirectionPadding: 0.85.
	button layoutSpec: buttonLayoutSpec.
	
	^button! !

!ExtractToMethodObjectPanel methodsFor: 'GUI building' stamp: 'FGJ 2/14/2019 12:20:15'!
buildInstanceCreationMessageSection	
	
	| columnsNames section previewExplanation previewLayoutSpec |
	
	section := FormGroup
		withTitle: 'Instance creation message definition'
		withExplanation: 'The collaborators will be passed in the MethodObject instance creation message. Pick the keyword and the formal parameter name corresponding to each collaborator:'
		withColor: self backgroundColor .
	
	columnsNames := #('Keyword' 'Parameter name').
	inputTable := InputTable 
		withColumns: columnsNames
		withRows: variablesToParametrize
		withColor: self backgroundColor
		withPreviewModel: self
		withRefactoringModel: extractToMethodObjectRequest.
	section addMorph: inputTable.
	
	previewExplanation := ImmutableTextModelMorph 
		withText: 'This is how the instance creation message header will look:'
		withColor: self backgroundColor
		withWidth: section fixedWidthForTexts.
	section addMorph: previewExplanation.
	
	preview := TextModelMorph textProvider: self.
	preview model actualContents: self previewUnavailableMessage.
	preview color: Color white.
	preview disableEditing.
	preview drawKeyboardFocusIndicator: false.
	preview lock: true.
	
	previewLayoutSpec := LayoutSpec 
		proportionalWidth: 0.95
		fixedHeight: ExtractToMethodObjectPanel fontProportionalUnitOfReferenceForHeight * 3.
	previewLayoutSpec minorDirectionPadding: 0.3.
	preview layoutSpec: previewLayoutSpec. 
	
	section addMorph: preview.
	
	section layoutSpec: (self layoutSpecForSection: section).
	
	^section! !

!ExtractToMethodObjectPanel methodsFor: 'GUI building' stamp: 'FGJ 2/14/2019 11:01:33'!
buildInstanceVariablesSection

	| maxLabelWidth section |

	section := FormGroup 
			withTitle: 'Instance variables names'
			withExplanation: 'Instance, class and pool variables referenced by the method will be passed as collaborators to the MethodObject. The method object will have one instance variable corresponding to each of them. Pick their names:'
			withColor: self backgroundColor.
	
	maxLabelWidth := self recommendedWidthForLabels: variablesToParametrize.
	
	variablesToParametrize do: [ :aVariable | | labeledInput |
		labeledInput := LabeledInput withLabel: aVariable withWidth: maxLabelWidth.
		extractToMethodObjectRequest forVariableToParametrize: aVariable nameModel: labeledInput textModel.
		section addMorph: labeledInput].
	
	section layoutSpec: (self layoutSpecForSection: section).
	
	^section
! !

!ExtractToMethodObjectPanel methodsFor: 'GUI building' stamp: 'FGJ 2/14/2019 10:58:22'!
buildMethodObjectClassSection

	| section maxLabelWidth nameInput superclassNameInput categoryInput evaluationMessageSelectorInput |

	section := FormGroup withTitle: 'Method Object class' withColor: self backgroundColor.

	maxLabelWidth := self recommendedWidthForLabels: #( 'Name' 'Superclass name' 'Category' 'Evaluation message selector').

	nameInput := LabeledInput withLabel: 'Name' withWidth: maxLabelWidth.
	extractToMethodObjectRequest methodObjectClassNameModel: nameInput textModel.
	section addMorph: nameInput.
	
	superclassNameInput := LabeledAutocompletedInput withLabel: 'Superclass name' withWidth: maxLabelWidth.
	extractToMethodObjectRequest methodObjectSuperclassNameModel: superclassNameInput textModel.
	section addMorph: superclassNameInput.
	
	categoryInput := LabeledInput withLabel: 'Category' withWidth: maxLabelWidth.
	extractToMethodObjectRequest methodObjectCategoryModel: categoryInput textModel.
	section addMorph: categoryInput.
	
	evaluationMessageSelectorInput := LabeledInput withLabel: 'Evaluation message selector' withWidth: maxLabelWidth.
	extractToMethodObjectRequest 
		methodObjectEvaluationMessageSelectorModel: evaluationMessageSelectorInput textModel.
	section addMorph: evaluationMessageSelectorInput.
	
	section layoutSpec: (self layoutSpecForSection: section).
	
	^section
! !

!ExtractToMethodObjectPanel methodsFor: 'GUI building' stamp: 'FGJ 2/14/2019 20:00:03'!
buildMorphicWindow

	| requiredExtent instanceCreationMessageSection requiredHeight methodObjectClassSection instanceVariablesSection actionButtonsSection requiredWidth sections |
	
	discardEdits := false.
	self setLabel: 'Extract Method to Method Object'.
	variablesToParametrize := model variablesToParametrize.
	
	extractToMethodObjectRequest := ExtractToMethodObjectRequest initializedInstance.
	
	self initializeScrollableContainer.
	self initializeFormLayout.
	scrollPane scroller addMorph: formLayout.
	
	"Method object class section"
	methodObjectClassSection := self buildMethodObjectClassSection.
	formLayout addMorph: methodObjectClassSection.
	
	"Instance variables section"
	instanceVariablesSection := self buildInstanceVariablesSection.
	formLayout addMorph: instanceVariablesSection.
	
	"Instance creation message section"
	instanceCreationMessageSection := self buildInstanceCreationMessageSection.
	formLayout addMorph: instanceCreationMessageSection.

	"Submit & Cancel buttons"
	actionButtonsSection := self buildActionButtonsSection.
	formLayout addMorph: actionButtonsSection.
	
	sections := { methodObjectClassSection. instanceVariablesSection. instanceCreationMessageSection. }.
	requiredHeight := (sections collect: [:aSection | aSection recommendedHeight]) sum 
		+ actionButtonsSection layoutSpec fixedHeight
		+ (formLayout ySeparation * 4).
	requiredWidth := (sections collect: [:aSection | aSection recommendedWidth]) max + (formLayout xSeparation * 2).

	requiredExtent := requiredWidth@requiredHeight.
	formLayout morphExtent: requiredExtent.
	scrollPane scroller morphExtent: requiredExtent.! !

!ExtractToMethodObjectPanel methodsFor: 'GUI building' stamp: 'FGJ 2/13/2019 12:38:47'!
buildSubmitButton

	| submitButton submitButtonLayoutSpec |
	
	submitButton := IndependentlyColoredButton model: self action: #submitButtonClicked label: 'Refactor'.
	submitButton color: Theme current acceptButton.
	
	submitButtonLayoutSpec := LayoutSpec 
		fixedWidth: submitButton morphWidth
		fixedHeight: ExtractToMethodObjectPanel fontProportionalUnitOfReferenceForHeight  * 2.
	submitButtonLayoutSpec minorDirectionPadding: 0.95.
	submitButton layoutSpec: submitButtonLayoutSpec.
	
	^submitButton! !

!ExtractToMethodObjectPanel methodsFor: 'GUI building' stamp: 'FGJ 2/12/2019 15:29:28'!
initializeFormLayout

	formLayout := LayoutMorph newColumn.
	formLayout separation: 10; color: self backgroundColor.! !

!ExtractToMethodObjectPanel methodsFor: 'GUI building' stamp: 'FGJ 2/7/2019 12:52:07'!
initializeScrollableContainer

	scrollPane := ColoredScrollPane initializedInstance.
	scrollPane scroller color: self backgroundColor.
	scrollPane scroller layoutSpec: LayoutSpec useAll.
	scrollPane color: self backgroundColor. 
	self layoutMorph addMorphUseAll: scrollPane.! !


!ExtractToMethodObjectPanel methodsFor: 'messages' stamp: 'FGJ 2/11/2019 16:47:48'!
previewUnavailableMessage

	^'All the keywords and parameter names must be filled for the preview to appear here'! !


!ExtractToMethodObjectPanel methodsFor: 'events' stamp: 'FGJ 2/13/2019 15:29:04'!
cancelButtonClicked
	
	model cancel.! !

!ExtractToMethodObjectPanel methodsFor: 'events' stamp: 'FGJ 2/6/2019 13:12:47'!
fontPreferenceChanged
	"Copied from CodePackageListWindow"
	"System fonts have changed; rebuild myself"
	self layoutMorph removeAllMorphs.
	super fontPreferenceChanged.
	self buildMorphicWindow.
! !

!ExtractToMethodObjectPanel methodsFor: 'events' stamp: 'FGJ 2/14/2019 11:37:10'!
previewTextInputReceivedKeyStroke

	self buildPreview.! !

!ExtractToMethodObjectPanel methodsFor: 'events' stamp: 'FGJ 2/10/2019 19:04:21'!
row: aRowIndex wasSwappedWith: anotherRowIndex

	self buildPreview.! !

!ExtractToMethodObjectPanel methodsFor: 'events' stamp: 'FGJ 2/14/2019 17:41:50'!
submitButtonClicked

	model userSubmitted: extractToMethodObjectRequest.! !


!ExtractToMethodObjectPanel methodsFor: 'open/close' stamp: 'FGJ 2/13/2019 16:00:39'!
closeBoxHit

	model panelWasClosed.! !

!ExtractToMethodObjectPanel methodsFor: 'open/close' stamp: 'FGJ 2/14/2019 19:58:44'!
deleteDiscardingEdits
	
	discardEdits := true.
	super delete.! !

!ExtractToMethodObjectPanel methodsFor: 'open/close' stamp: 'FGJ 2/14/2019 19:59:35'!
okToChange
	
	discardEdits 
		ifTrue: [^true]
		ifFalse: [super okToChange].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ExtractToMethodObjectPanel class' category: #Playground!
ExtractToMethodObjectPanel class
	instanceVariableNames: ''!

!ExtractToMethodObjectPanel class methodsFor: 'as yet unclassified' stamp: 'FGJ 2/11/2019 18:27:41'!
fontProportionalUnitOfReferenceForHeight

	^AbstractFont default height! !

!ExtractToMethodObjectPanel class methodsFor: 'as yet unclassified' stamp: 'FGJ 2/11/2019 18:27:24'!
fontProportionalUnitOfReferenceForWidth

	^AbstractFont default widthOf: $A! !

!ExtractToMethodObjectPanel class methodsFor: 'as yet unclassified' stamp: 'FGJ 2/11/2019 18:27:24'!
recommendedWidth

	^self fontProportionalUnitOfReferenceForWidth * 70! !


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

!FormGroup methodsFor: 'as yet unclassified' stamp: 'FGJ 2/13/2019 18:58:22'!
fixedWidthForTexts

	^ExtractToMethodObjectPanel recommendedWidth * 0.7! !

!FormGroup methodsFor: 'as yet unclassified' stamp: 'FGJ 2/13/2019 18:17:02'!
recommendedHeight

	^((self submorphs collect: [:aMorph | aMorph layoutSpec fixedHeight]) sum) + ( (self submorphs size + 1) * self ySeparation) + self verticalMargins! !

!FormGroup methodsFor: 'as yet unclassified' stamp: 'FGJ 2/13/2019 20:06:15'!
recommendedWidth

	^(self submorphs collect: [:aMorph | aMorph layoutSpec fixedWidth]) max + (self xSeparation * 2)! !

!FormGroup methodsFor: 'as yet unclassified' stamp: 'FGJ 2/7/2019 10:57:14'!
textHeight
	
	^AbstractFont default height! !

!FormGroup methodsFor: 'as yet unclassified' stamp: 'FGJ 2/11/2019 17:14:53'!
verticalMargins

	^20! !


!FormGroup methodsFor: 'initialization' stamp: 'FGJ 2/13/2019 18:57:34'!
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
			withWidth: self fixedWidthForTexts.
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
	instanceVariableNames: 'rowModels previewModel backgroundColor refactoringModel columnWidths'
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

!InputTable methodsFor: 'as yet unclassified' stamp: 'FGJ 2/14/2019 17:01:04'!
moveDownRow: aRowIndex

	(self isBottomRow: aRowIndex) ifFalse: [
		self swapRow: aRowIndex with: aRowIndex -1.
		self rowWasMovedDown: aRowIndex - 1.
		self rowWasMovedUp: aRowIndex.].! !

!InputTable methodsFor: 'as yet unclassified' stamp: 'FGJ 2/14/2019 17:01:10'!
moveUpRow: aRowIndex

	aRowIndex <  self numberOfRowsWithoutHeaders ifTrue: [
		self swapRow: aRowIndex with: aRowIndex + 1.
		self rowWasMovedUp: aRowIndex + 1.
		self rowWasMovedDown: aRowIndex.].! !

!InputTable methodsFor: 'as yet unclassified' stamp: 'FGJ 2/10/2019 18:49:07'!
notifyPreviewModelThat: aRowIndex wasSwappedWith: anotherRowIndex

	previewModel row: aRowIndex wasSwappedWith: anotherRowIndex.! !

!InputTable methodsFor: 'as yet unclassified' stamp: 'FGJ 2/14/2019 17:03:43'!
notifyRefactoringModelThat: aRowIndex wasSwappedWith: anotherRowIndex

	refactoringModel keywordOfIndex: aRowIndex wasSwappedWithKeywordOfIndex: anotherRowIndex.! !

!InputTable methodsFor: 'as yet unclassified' stamp: 'FGJ 2/9/2019 16:59:36'!
numberOfRowsWithoutHeaders

	^self submorphs size - 1! !

!InputTable methodsFor: 'as yet unclassified' stamp: 'FGJ 2/14/2019 17:01:38'!
swapRow: aRowIndex with: anotherRowIndex

	self swapRowSubmorph: aRowIndex with: anotherRowIndex.
	self swapRowModel: aRowIndex with: anotherRowIndex.
	self notifyPreviewModelThat: aRowIndex wasSwappedWith: anotherRowIndex.
	self notifyRefactoringModelThat: aRowIndex wasSwappedWith: anotherRowIndex.! !

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


!InputTable methodsFor: 'initialization' stamp: 'FGJ 2/13/2019 14:16:02'!
backgroundColor

	^backgroundColor ! !

!InputTable methodsFor: 'initialization' stamp: 'FGJ 2/13/2019 14:14:52'!
buildChangeOrderButtonsWith: aModel

	| downButton layoutButtons upButton |
	
	upButton := PluggableButtonMorph new.
	upButton icon: Theme current goUpIcon.
	upButton model: aModel.
	upButton action: #moveUp.
			
	downButton := PluggableButtonMorph new.
	downButton icon: Theme current goDownIcon.
	downButton model: aModel.
	downButton action: #moveDown.
	
	layoutButtons := LayoutMorph newRow.
	layoutButtons padding: #center; color: self backgroundColor.
	layoutButtons addMorph: downButton; addMorph: upButton.	
	
	^layoutButtons! !

!InputTable methodsFor: 'initialization' stamp: 'FGJ 2/14/2019 12:19:23'!
buildColumnTitlesRowFor: inputColumnsTitles

	| columnsTitles row |
	
	row := LayoutMorph newRow.
	row color: self backgroundColor.
	row separation: self columnSeparation.
	
	columnsTitles := OrderedCollection newFrom: inputColumnsTitles.
	columnsTitles addFirst: ''; addLast: 'Change order'.
	columnsTitles withIndexDo: [:aColumnTitle :columnIndex | | columnTitleLayoutSpec titleLayout |
		titleLayout := LayoutMorph newRow.
		titleLayout color: self backgroundColor .
		titleLayout padding: #center.
		titleLayout addMorph: (StringMorph contents: aColumnTitle).
		columnTitleLayoutSpec := LayoutSpec fixedWidth: (columnWidths at: columnIndex).
		row 
			addMorph: titleLayout
			layoutSpec: columnTitleLayoutSpec].
		
	^row
	
	! !

!InputTable methodsFor: 'initialization' stamp: 'FGJ 2/14/2019 14:14:16'!
buildInputMorph

	| inputMorph |
	
	inputMorph := PreviewTextModelMorph textProvider: self.
	inputMorph textMorph previewModel: previewModel.
			
	inputMorph hideScrollBarsIndefinitely.
	
	^inputMorph! !

!InputTable methodsFor: 'initialization' stamp: 'FGJ 2/14/2019 12:14:23'!
columnSeparation

	^4! !

!InputTable methodsFor: 'initialization' stamp: 'FGJ 2/14/2019 11:56:07'!
columnWidthsRequiredForRowTitles: rowsTitles forInputColumns: numberOfInputColumns

	| columnWidths maxRowTitleWidth widthForInputs |
	
	columnWidths := OrderedCollection new.
	
	maxRowTitleWidth := (rowsTitles collect: [:aRowTitle | AbstractFont default widthOfString: aRowTitle]) max + 20.
	columnWidths add: maxRowTitleWidth.
	
	widthForInputs := ExtractToMethodObjectPanel fontProportionalUnitOfReferenceForWidth * 20.
	numberOfInputColumns timesRepeat: [columnWidths add: widthForInputs].
	
	columnWidths add: (AbstractFont default widthOfString: 'Change order').
	
	^columnWidths
	
	! !

!InputTable methodsFor: 'initialization' stamp: 'FGJ 2/14/2019 12:09:59'!
rowHeight

	^AbstractFont default height * 1.6! !

!InputTable methodsFor: 'initialization' stamp: 'FGJ 2/14/2019 12:11:01'!
rowsLayoutSpec

	^LayoutSpec fixedHeight: self rowHeight! !

!InputTable methodsFor: 'initialization' stamp: 'FGJ 2/14/2019 17:23:02'!
withColumns: inputColumnsTitles withRows: rowsTitles withColor: aColor withPreviewModel: aPreviewModel withRefactoringModel: aRefactoringModel

	| rowsSeparation recommendedHeight numberOfRows columnsTitlesRow changeOrderButtons tableWidth |
	
	backgroundColor := aColor.
	rowModels := OrderedCollection new.
	previewModel := aPreviewModel.
	refactoringModel := aRefactoringModel.

	rowsSeparation := 4.
	self separation: rowsSeparation.
	
	"Calculate table height"
	numberOfRows := (rowsTitles size + 1).
	recommendedHeight :=  self rowHeight * numberOfRows + (rowsSeparation * (numberOfRows + 1)).
	
	"Calculate column widths"
	columnWidths := self columnWidthsRequiredForRowTitles: rowsTitles forInputColumns: inputColumnsTitles size.
		
	"Calculate table width"
	tableWidth := columnWidths sum + (self columnSeparation * (columnWidths size + 1)).
	
	self layoutSpec: (LayoutSpec fixedWidth: tableWidth fixedHeight: recommendedHeight).
	
	
	"Buid the columns titles row"
	columnsTitlesRow := self buildColumnTitlesRowFor: inputColumnsTitles.
	self addMorph: columnsTitlesRow layoutSpec: self rowsLayoutSpec.
	
	"Build the input rows"
	rowsTitles withIndexDo: [:aRowTitle :index | | aRow changeOrderModel upButton downButton layoutButtons keywordModel keywordInputMorph inputMorphLayoutSpec parameternameInputMorph |
		aRow := LayoutMorph newRow.
		aRow color: self backgroundColor; separation: self columnSeparation.
		
		aRow 
			addMorph: (StringMorph contents: aRowTitle)
			layoutSpec: (LayoutSpec fixedWidth: (columnWidths at: 1)).
			
		inputMorphLayoutSpec := LayoutSpec fixedWidth: (columnWidths at: 2) fixedHeight: self rowHeight.
		
		keywordInputMorph := self buildInputMorph.
		aRow addMorph: keywordInputMorph layoutSpec: inputMorphLayoutSpec.
		
		parameternameInputMorph := self buildInputMorph.
		aRow addMorph: parameternameInputMorph layoutSpec: inputMorphLayoutSpec.
		
		aRefactoringModel 
			addKeyword: keywordInputMorph model 
			for: aRowTitle
			withParameterName: parameternameInputMorph model.
				
		changeOrderModel := ChangeRowOrderButtonModel for: (rowsTitles size - (index - 1)) notifying: self.
		rowModels addFirst: changeOrderModel.
		
		changeOrderButtons := self buildChangeOrderButtonsWith: changeOrderModel.
		aRow addMorph: changeOrderButtons layoutSpec: (LayoutSpec fixedWidth: (columnWidths last)).
			
		self addMorph: aRow layoutSpec: self rowsLayoutSpec.
	].! !


!InputTable methodsFor: 'events' stamp: 'FGJ 2/9/2019 17:20:09'!
rowWasMovedDown: aRowIndex

	(rowModels at: aRowIndex) wasMovedDown.! !

!InputTable methodsFor: 'events' stamp: 'FGJ 2/9/2019 17:20:24'!
rowWasMovedUp: aRowIndex

	(rowModels at: aRowIndex) wasMovedUp.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'InputTable class' category: #Playground!
InputTable class
	instanceVariableNames: ''!

!InputTable class methodsFor: 'as yet unclassified' stamp: 'FGJ 2/14/2019 12:20:49'!
withColumns: columnsTitles withRows: rowsTitles withColor: aColor withPreviewModel: aPreviewModel withRefactoringModel: aRefactoringModel

	^self newColumn withColumns: columnsTitles withRows: rowsTitles withColor: aColor withPreviewModel: aPreviewModel withRefactoringModel: aRefactoringModel. 
	
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

!LabeledInput methodsFor: 'as yet unclassified' stamp: 'FGJ 2/13/2019 17:11:46'!
textModel

	^inputMorph model! !

!LabeledInput methodsFor: 'as yet unclassified' stamp: 'FGJ 2/12/2019 15:35:40'!
withLabel: aLabel withWidth: aWidth

	| labelLayoutSpec inputMorphLayoutSpec |
	
	self separation: 5.
	layoutSpec := LayoutSpec proportionalWidth: 0.95 fixedHeight: LabeledInput recommendedHeight.
	self layoutSpec: layoutSpec.
	
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
			fixedWidth: ExtractToMethodObjectPanel fontProportionalUnitOfReferenceForWidth * 30
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

!PreviewInnerTextMorph methodsFor: 'as yet unclassified' stamp: 'FGJ 2/14/2019 11:37:10'!
keyStroke: aKeyboardEvent
	
	super keyStroke: aKeyboardEvent.
	
	previewModel previewTextInputReceivedKeyStroke.! !

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


!classDefinition: #ExtractToMethodObjectRequest category: #Playground!
Object subclass: #ExtractToMethodObjectRequest
	instanceVariableNames: 'methodObjectClassNameModel methodObjectCategoryModel methodObjectSuperclassNameModel methodObjectEvaluationMessageSelectorModel variableToParametrizeToInstVarNameModel instanceCreationMessageModels'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Playground'!

!ExtractToMethodObjectRequest methodsFor: 'as yet unclassified' stamp: 'FGJ 2/14/2019 14:19:54'!
addToKeywords: keywordModel

	instanceCreationMessageModels add: keywordModel.! !

!ExtractToMethodObjectRequest methodsFor: 'as yet unclassified' stamp: 'FGJ 2/14/2019 11:02:18'!
forVariableToParametrize: aVariable nameModel: aModel

	variableToParametrizeToInstVarNameModel at: aVariable put: aModel.! !

!ExtractToMethodObjectRequest methodsFor: 'as yet unclassified' stamp: 'FGJ 2/14/2019 11:07:57'!
instVarNameFor: aVariableToParametrize

	^(variableToParametrizeToInstVarNameModel at: aVariableToParametrize) actualContents! !

!ExtractToMethodObjectRequest methodsFor: 'as yet unclassified' stamp: 'FGJ 2/14/2019 17:04:31'!
keywordOfIndex: aKeywordIndex wasSwappedWithKeywordOfIndex: anotherKeywordIndex

	instanceCreationMessageModels swap: aKeywordIndex with: anotherKeywordIndex.! !

!ExtractToMethodObjectRequest methodsFor: 'as yet unclassified' stamp: 'FGJ 2/14/2019 10:59:26'!
methodObjectCategoryModel: aModel

	methodObjectCategoryModel := aModel.! !

!ExtractToMethodObjectRequest methodsFor: 'as yet unclassified' stamp: 'FGJ 2/14/2019 10:58:55'!
methodObjectClassNameModel: aModel
	
	methodObjectClassNameModel := aModel.! !

!ExtractToMethodObjectRequest methodsFor: 'as yet unclassified' stamp: 'FGJ 2/14/2019 11:00:19'!
methodObjectEvaluationMessageSelectorModel: aModel
	
	methodObjectEvaluationMessageSelectorModel := aModel.! !

!ExtractToMethodObjectRequest methodsFor: 'as yet unclassified' stamp: 'FGJ 2/14/2019 10:59:54'!
methodObjectSuperclassNameModel: aModel
	
	methodObjectSuperclassNameModel := aModel.! !


!ExtractToMethodObjectRequest methodsFor: 'accessing' stamp: 'FGJ 2/14/2019 17:48:55'!
keywordToParametrizedVariable

	^instanceCreationMessageModels collect: [:aModel |
		Association 
			key: (aModel at: #keyword) actualContents string
			value: (aModel at: #variableName)]! !

!ExtractToMethodObjectRequest methodsFor: 'accessing' stamp: 'FGJ 2/14/2019 17:49:00'!
methodObjectCategory

	^methodObjectCategoryModel actualContents string! !

!ExtractToMethodObjectRequest methodsFor: 'accessing' stamp: 'FGJ 2/14/2019 17:55:15'!
methodObjectClassName

	^methodObjectClassNameModel actualContents string asSymbol ! !

!ExtractToMethodObjectRequest methodsFor: 'accessing' stamp: 'FGJ 2/14/2019 17:49:10'!
methodObjectEvaluationMessageSelector

	^methodObjectEvaluationMessageSelectorModel actualContents string! !

!ExtractToMethodObjectRequest methodsFor: 'accessing' stamp: 'FGJ 2/14/2019 17:49:16'!
methodObjectSuperclassName

	^methodObjectSuperclassNameModel actualContents string! !

!ExtractToMethodObjectRequest methodsFor: 'accessing' stamp: 'FGJ 2/14/2019 17:49:23'!
variablesToParametrizeToInstanceVariables

	^variableToParametrizeToInstVarNameModel collect: [:aInstVarNameModel | aInstVarNameModel actualContents string]! !


!ExtractToMethodObjectRequest methodsFor: 'initialization' stamp: 'FGJ 2/14/2019 17:25:45'!
addKeyword: aKeywordModel for: aVariableName withParameterName: aParameterNameModel

	| keywordModel |
	
	keywordModel := Dictionary new.
	keywordModel at: #variableName put: aVariableName.
	keywordModel at: #keyword put: aKeywordModel.
	keywordModel at: #parameterName put: aParameterNameModel.
	
	instanceCreationMessageModels add: keywordModel.! !

!ExtractToMethodObjectRequest methodsFor: 'initialization' stamp: 'FGJ 2/14/2019 11:14:55'!
initialize

	variableToParametrizeToInstVarNameModel := Dictionary new.
	instanceCreationMessageModels := OrderedCollection new.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ExtractToMethodObjectRequest class' category: #Playground!
ExtractToMethodObjectRequest class
	instanceVariableNames: ''!

!ExtractToMethodObjectRequest class methodsFor: 'as yet unclassified' stamp: 'FGJ 2/14/2019 11:04:56'!
initializedInstance

	^self new initialize.! !
