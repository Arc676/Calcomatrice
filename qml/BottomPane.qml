// Copyright (C) 2020 Arc676/Alessandro Vinciguerra <alesvinciguerra@gmail.com>

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

import MatrixBackend 1.0

Page {
	width: bottomEdge.width
	height: bottomEdge.height

	Icon {
		width: units.gu(3)
		height: units.gu(1.5)
		visible: !isLandscape
		anchors {
			top: parent.top
			topMargin: units.gu(0.5)
			horizontalCenter: parent.horizontalCenter
		}

		name: "toolkit_bottom-edge-hint"
		rotation: 180

		MouseArea {
			anchors.fill: parent

			onClicked: bottomEdge.collapse()
		}
	}

	Label {
		id: memLbl
		text: i18n.tr("Saved Matrices")
		textSize: Label.XLarge
		anchors {
			top: parent.top
			topMargin: margin
			left: parent.left
			leftMargin: margin
		}
	}

	UbuntuListView {
		clip: true
		anchors {
			top: memLbl.top
			topMargin: margin * 2
			left: parent.left
			leftMargin: margin
			right: parent.horizontalCenter
			rightMargin: margin
			bottom: parent.bottom
			bottomMargin: margin
		}
		model: MatrixMemory
		delegate: ListItem {
			height: lbl.height * 2

			Label {
				id: lbl
				text: matrixName
				textSize: Label.Large
				anchors.centerIn: parent
			}

			MouseArea {
				anchors.fill: parent
				onClicked: {
					formulaPush(matrixName)
					bottomEdge.collapse()
				}
			}
		}
	}

	ScrollView {
		id: scroll
		anchors {
			top: parent.top
			right: parent.right
			left: parent.horizontalCenter
			bottom: parent.bottom
			margins: margin
		}

		CalcKeyboard {
			width: scroll.width
			KeyboardPage {
				columns: 1
				buttonMaxHeight: calculatorUI.height / 20
				keyboardModel: new Array(
					{ text: "Invert", name: "invert", pushText: "invert(" },
					{ text: "Determinant", name: "det", pushText: "det(" },
					{ text: "Minors", name: "minors", pushText: "minors(" },
					{ text: "Cofactors", name: "cofactors", pushText: "cofactors(" },
					{ text: "Transpose", name: "transpose", pushText: "transpose(" },
					{ text: "Identity", name: "identity", pushText: "identity(" }
				)
			}
		}
	}
}
