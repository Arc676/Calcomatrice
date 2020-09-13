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

	function initMatrix() {
		var rows = parseInt(rowField.text)
		var cols = parseInt(colField.text)
		visualizer.matrix.createMatrix(rows, cols)
		return [rows, cols]
	}

	function loadMatrix(matrix) {
		visualizer.matrix.loadMatrix(matrix)
	}

	Component {
		id: nameErrorDialog
		ErrorDialog {
			msg: i18n.tr("Matrix names must start with a letter.")
		}
	}

	Component {
		id: entryCountErrorDialog
		ErrorDialog {
			msg: i18n.tr("The number of entries in the string form must match the number of elements in the matrix.")
		}
	}

	ScrollView {
		id: scroll
		anchors {
			top: header.bottom
			left: parent.left
			right: parent.right
			bottom: parent.bottom
			margins: margin
		}

		Column {
			spacing: margin
			width: scroll.width

			ComboButton {
				id: builderSelection
				width: parent.width
				text: i18n.tr("Visual Matrix Editor")
				property int selectedIndex: 0

				UbuntuListView {
					width: parent.width
					height: builderSelection.comboListHeight
					model: [
						i18n.tr("Visual Matrix Editor"),
						i18n.tr("String Parser"),
					]
					delegate: ListItem {
						ListItemLayout {
							title.text: modelData
						}

						onClicked: {
							builderSelection.expanded = false
							builderSelection.text = modelData
							builderSelection.selectedIndex = index
						}
					}
				}
			}

			Item {
				height: rowField.height
				width: parent.width

				Label {
					id: rowLbl
					text: i18n.tr("Rows")
					anchors {
						left: parent.left
						verticalCenter: rowField.verticalCenter
					}
				}

				TextField {
					id: rowField
					inputMethodHints: Qt.ImhDigitsOnly
					anchors {
						left: rowLbl.right
						leftMargin: margin
						right: parent.right
					}
				}
			}

			Item {
				height: colField.height
				width: parent.width

				Label {
					id: colLbl
					text: i18n.tr("Columns")
					anchors {
						left: parent.left
						verticalCenter: colField.verticalCenter
					}
				}

				TextField {
					id: colField
					inputMethodHints: Qt.ImhDigitsOnly
					anchors {
						left: colLbl.right
						leftMargin: margin
						right: parent.right
					}
				}
			}

			Button {
				text: i18n.tr("Create matrix")
				width: parent.width
				visible: builderSelection.selectedIndex === 0
				onClicked: {
					initMatrix()
				}
			}

			MatrixVisualizer {
				id: visualizer
				labelText: "New matrix"
				matrix: Matrix {}
				editEnabled: true
				textSize: Label.Large
				visible: builderSelection.selectedIndex === 0
			}

			Button {
				width: parent.width
				text: i18n.tr("Zero matrix")
				onClicked: visualizer.matrix.makeZeroMatrix()
				visible: builderSelection.selectedIndex === 0
			}

			Button {
				width: parent.width
				text: i18n.tr("Identity matrix (square matrices only)")
				onClicked: visualizer.matrix.makeIdentityMatrix()
				visible: builderSelection.selectedIndex === 0
			}

			TextArea {
				id: matrixText
				width: parent.width
				height: units.gu(20)
				inputMethodHints: Qt.ImhDigitsOnly
				visible: builderSelection.selectedIndex === 1
			}

			Button {
				width: parent.width
				text: i18n.tr("Parse matrix")
				onClicked: {
					const params = initMatrix()
					const rows = params[0]
					const cols = params[1]
					const count = rows * cols
					const entries = matrixText.text.split(/[^0-9.-]/)
					if (entries.length !== count) {
						PopupUtils.open(entryCountErrorDialog)
						return
					}
					for (var i = 0; i < count; i++) {
						const r = i / cols
						const c = i % cols
						visualizer.matrix.editEntry(parseFloat(entries[i]), r, c)
					}
					builderSelection.selectedIndex = 0
					builderSelection.text = i18n.tr("Visual Matrix Editor")
				}
				visible: builderSelection.selectedIndex === 1
			}

			Item {
				height: matrixName.height
				width: parent.width

				Label {
					id: nameLbl
					text: i18n.tr("Matrix name")
					anchors {
						left: parent.left
						verticalCenter: matrixName.verticalCenter
					}
				}

				TextField {
					id: matrixName
					anchors {
						left: nameLbl.right
						leftMargin: margin
						right: parent.right
					}
				}
			}

			Button {
				text: i18n.tr("Save")
				width: parent.width
				onClicked: {
					var matName = matrixName.text.trim()
					if (matName.length > 0 && /^[a-zA-Z]/.test(matName)) {
						MatrixMemory.saveMatrixWithName(matName, visualizer.matrix)
					} else {
						PopupUtils.open(nameErrorDialog)
					}
				}
			}
		}
	}

	Component.onDestruction: visualizer.matrix.destroyMatrix()
}
