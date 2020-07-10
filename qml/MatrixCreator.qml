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
import Ubuntu.Components.Popups 1.3

import MatrixBackend 1.0

Page {
	id: matrixCreator
	anchors.fill: parent

	header: DefaultHeader {}

	function loadMatrix(matrix) {
		visualizer.matrix.loadMatrix(matrix)
	}

	Component {
		id: errorDialog
		NameErrorDialog {}
	}

	Column {
		spacing: margin
		anchors {
			top: header.bottom
			topMargin: margin
			left: parent.left
			leftMargin: margin
			right: parent.right
			rightMargin: margin
			bottom: parent.bottom
			bottomMargin: margin
		}

		Row {
			spacing: margin

			Label {
				text: i18n.tr("Rows")
			}

			TextField {
				id: rowField
			}
		}

		Row {
			spacing: margin

			Label {
				text: i18n.tr("Columns")
			}

			TextField {
				id: colField
			}
		}

		Button {
			text: i18n.tr("Create matrix")
			onClicked: {
				var rows = parseInt(rowField.text)
				var cols = parseInt(colField.text)
				visualizer.matrix.createMatrix(rows, cols)
			}
		}

		MatrixVisualizer {
			id: visualizer
			labelText: "New matrix"
			matrix: Matrix {}
			editEnabled: true
			fontSize: 20
		}

		Button {
			width: parent.width
			text: i18n.tr("Zero matrix")
			onClicked: visualizer.matrix.makeZeroMatrix()
		}

		Button {
			width: parent.width
			text: i18n.tr("Identity matrix (square matrices only)")
			onClicked: visualizer.matrix.makeIdentityMatrix()
		}

		Row {
			spacing: margin

			Label {
				text: i18n.tr("Matrix name")
			}

			TextField {
				id: matrixName
			}

			Button {
				text: i18n.tr("Save")
				onClicked: {
					var matName = matrixName.text.trim()
					if (matName.length > 0 && !/^\d/.test(matName)) {
						MatrixMemory.saveMatrixWithName(matName, visualizer.matrix)
					} else {
						PopupUtils.open(errorDialog)
					}
				}
			}
		}
	}
}
