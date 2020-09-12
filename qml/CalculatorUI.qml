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
	property CalculationHistory calcHist: CalculationHistory {}

	function clearHistory() {
		PopupUtils.open(confirmDialog)
	}

	Component {
		id: saveDialog
		SaveDialog {}
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
			anchors.fill: parent
			anchors.margins: margin
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

	/*
	Button {
		id: calcButton
		text: "Calculate"
		onClicked: {
			var expr = inputField.text
			if (expr.length > 0) {
				var res = MatrixBackend.evaluateExpression(expr)
				calcHist.addCalculation(expr, res)
				inputField.text = ""
			}
		}
	}
	*/

	// For debugging on desktop
	Keys.onReleased: if (event.key == Qt.Key_Up) bottomEdge.commit()

	BottomEdge {
		id: bottomEdge
		width: parent.width
		height: parent.height / 2
		enabled: !isLandscape
		contentUrl: Qt.resolvedUrl("BottomPane.qml")
		hint.text: i18n.tr("Memory/Functions")
		hint.visible: enabled
	}

	Component.onCompleted: {
		MatrixMemory.initMemory()
	}

	Component.onDestruction: {
		MatrixMemory.clearMemory()
		calcHist.clearAll()
	}
}
