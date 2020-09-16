// Copyright (C) 2019-20 Arc676/Alessandro Vinciguerra <alesvinciguerra@gmail.com>

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation (version 3)

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Suru 2.2
import Ubuntu.Components.Themes.Ambiance 1.3
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import MatrixBackend 1.0

Page {
	id: calculatorUI
	anchors.fill: parent

	header: DefaultHeader {}

	property bool isLandscape: root.width > root.height
	property var decimalPoint: Qt.locale().decimalPoint
	property string internalFormula: ""
	property CalculationHistory calcHist: CalculationHistory {}

	property int pressedKey: -1
	property string pressedKeyText: ""

	onIsLandscapeChanged: bottomEdge.collapse()

	function calculate() {
		var expr = internalFormula
		if (expr.length > 0) {
			var res = MatrixBackend.evaluateExpression(expr)
			calcHist.addCalculation(renderFormula(expr), res)
			calcHistory.positionViewAtEnd()
			clearFormula()
		}
	}

	function deleteElementFrom(formula) {
		var lastChar = formula.slice(-1)
		if (/[0-9.]/.test(lastChar)) {
			return formula.substring(0, formula.length - 1).trim()
		} else if (lastChar === '(') {
			var idx = formula.lastIndexOf(' ')
			return formula.substring(0, idx)
		} else {
			// Delete everything after the last parenthesis or the last space and everything that follows
			return formula.replace(/ ?[^ (]+$/, '')
		}
	}

	function deleteLastFormulaElement() {
		alterFormula(function(formula) {
			return deleteElementFrom(formula)
		})
	}

	function addElement(element, formula) {
		if (/^\d$/.test(element)) {
			if (/[0-9.-]$/.test(formula)) {
				formula += String(element)
			} else {
				formula += ' ' + element
			}
		} else if (element === "()") {
			const lastChar = formula.slice(-1)
			if (formula.length === 0 || /[+-]/.test(lastChar) || lastChar === '^' || lastChar === '#' || lastChar === '*') {
				formula += " ("
			} else {
				formula += " )"
			}
		} else if (element === '.') {
			const lastSpace = formula.lastIndexOf(' ')
			const lastWord = formula.substring(lastSpace + 1)
			if (/^-?\d+$/.test(lastWord)) {
				formula += element
			}
		} else {
			formula += ' ' + element
		}
		return formula
	}

	function formulaPush(element) {
		alterFormula(function(formula) {
			return addElement(element, formula)
		})
	}

	function alterFormula(alteringFunction) {
		const cursor = inputField.cursorPosition
		if (cursor === inputField.length) {
			internalFormula = alteringFunction(internalFormula)
			inputField.text = renderFormula(internalFormula)
		} else {
			const rest = internalFormula.trim().substring(cursor).trim()
			const rspace = rest.indexOf(' ')
			const fwr = rspace > 0 ? rest.substring(0, rspace) : rest
			var formula = alteringFunction(internalFormula.trim().substring(0, cursor).trim()).trim()
			const lwf = formula.substring(formula.lastIndexOf(' ') + 1)
			if (!/^\d+\.?\d*$/.test(lwf + fwr)) {
				formula += ' '
			}
			internalFormula = formula + rest
			inputField.text = renderFormula(internalFormula)
			inputField.cursorPosition = formula.length
		}
	}

	function clearFormula() {
		internalFormula = ""
		inputField.text = ""
	}

	function clearHistory() {
		PopupUtils.open(confirmDialog)
	}

	function renderFormula(formula) {
		return formula.replace(/#/g, '•').replace(/\*/g, '×').replace(/\./g, decimalPoint).trim()
	}

	Component {
		id: saveDialog
		InputDialog {
			property var matrix

			titleText: i18n.tr("Save Matrix")
			msgText: i18n.tr("Enter matrix name")
			confirmText: i18n.tr("Save matrix")

			onConfirm: MatrixMemory.saveMatrixWithName(input, matrix)
		}
	}

	Component {
		id: confirmDialog
		ConfirmDialog {
			warningText: i18n.tr("Are you sure you want to clear your calculation history? This cannot be undone.")
			confirmText: i18n.tr("Yes, clear it")
			onConfirm: calcHist.clearAll();
		}
	}

	UbuntuListView {
		id: calcHistory
		clip: true
		anchors {
			top: calculatorUI.header.bottom
			topMargin: margin
			left: parent.left
			leftMargin: margin
			right: parent.right
			rightMargin: margin
			bottom: inputRect.top
			bottomMargin: margin
		}
		model: calcHist
		delegate: ListItem {
			height: visualizer.height

			MatrixVisualizer {
				id: visualizer
				matrix: calcResult
				labelText: calcExpr
				textSize: Label.Medium
				nullText: i18n.tr("Invalid expression")
			}

			leadingActions: ListItemActions {
				actions: [
					Action {
						iconName: "delete"

						onTriggered: calcHist.delCalculation(index)
					}
				]
			}

			trailingActions: ListItemActions {
				actions: [
					Action {
						iconName: "save"
						visible: calcResult !== undefined && calcResult.exists

						onTriggered: PopupUtils.open(saveDialog, calculatorUI, {"matrix": calcResult})
					}
				]
			}
		}
	}

	Rectangle {
		id: inputRect
		anchors {
			left: parent.left
			leftMargin: margin
			right: parent.right
			rightMargin: margin
			bottom: keyboardLoader.top
			bottomMargin: margin
		}
		color: Suru.backgroundColor
		width: parent.width
		height: units.gu(6)

		TextField {
			id: inputField
			height: parent.height
			anchors {
				fill: parent
				leftMargin: margin
				rightMargin: margin
			}
			color: Suru.foregroundColor
			style: TextFieldStyle {
				background: Item {
					UbuntuShape {
						aspect: UbuntuShape.Flat
						color: Suru.secondaryBackgroundColor
						width: parent.width
						height: parent.height
					}
				}
			}
			font.pixelSize: height * 0.7
			onFocusChanged: focus = false
			focus: false
			cursorVisible: true

			Keys.onPressed: keyPress(event)
			Keys.onReleased: keyRelease(event)

			function keyPress(event) {
				keyboardLoader.item.pressedKey = event.key
				keyboardLoader.item.pressedKeyText = event.text
				// For debugging on desktop
				if (event.key == Qt.Key_Up) bottomEdge.commit()
			}

			function keyRelease(event) {
				keyboardLoader.item.pressedKey = -1
				keyboardLoader.item.pressedKeyText = ""
			}
		}

		MouseArea {
			anchors.fill: parent
			propagateComposedEvents: true
			onClicked: inputField.cursorPosition = inputField.positionAt(mouseX, TextInput.CursorOnCharacter)
		}
	}

	Loader {
		id: keyboardLoader
		anchors {
			left: parent.left
			leftMargin: margin
			right: parent.right
			rightMargin: margin
			bottom: parent.bottom
			bottomMargin: margin
		}
		width: parent.width
		active: false
		property bool sizeReady: Window.active
		onSizeReadyChanged: if (sizeReady) keyboardLoader.active = true
		source: isLandscape ? "LandscapeKeyboard.qml" : "PortraitKeyboard.qml"
	}

	BottomEdge {
		id: bottomEdge
		width: parent.width
		height: parent.height / 2
		enabled: !isLandscape
		contentUrl: Qt.resolvedUrl("BottomPane.qml")
		hint.text: i18n.tr("Memory/Functions")
		hint.visible: !isLandscape
	}

	Component.onCompleted: {
		MatrixMemory.initMemory()
	}

	Component.onDestruction: {
		MatrixMemory.writeToDisk()
		MatrixMemory.clearMemory()
		calcHist.clearAll()
	}
}
