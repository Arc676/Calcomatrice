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
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import MatrixBackend 1.0

Page {
	id: calculatorUI
	anchors.fill: parent

	header: DefaultHeader {}

	property CalculationHistory calcHist: CalculationHistory {}

	Component {
		id: saveDialog
		SaveDialog {}
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
			bottom: inputField.top
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

	TextField {
		id: inputField
		anchors {
			left: parent.left
			leftMargin: margin
			right: parent.right
			rightMargin: margin
			bottom: calcButton.top
			bottomMargin: margin
		}
	}

	Button {
		id: calcButton
		anchors {
			left: parent.left
			leftMargin: margin
			right: parent.right
			rightMargin: margin
			bottom: parent.bottom
			bottomMargin: margin
		}
		text: "Calculate"
		onClicked: {
			var expr = inputField.text
			var res = MatrixBackend.evaluateExpression(expr)
			calcHist.addCalculation(expr, res)
		}
	}

	Component.onCompleted: {
		MatrixMemory.initMemory()
	}

	Component.onDestruction: {
		MatrixMemory.clearMemory()
	}
}
