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

ListItem {
	id: matrixVisualizer
	height: matrixLabel.height + (grid.count > 0 ? (grid.itemAt(0).height + margin) * matrix.rows : margin)

	property Matrix matrix
	property var labelText
	property bool editEnabled: false
	property real fontSize: 12

	Label {
		id: matrixLabel
		text: labelText
	}

	Repeater {
		id: grid
		model: matrix
		anchors.top: matrixLabel.bottom
		anchors.left: parent.left

		Text {
			text: entry
			font.pointSize: matrixVisualizer.fontSize

			property int row: Math.floor(index / matrix.cols)
			property int col: index % matrix.cols

			anchors {
				top: row > 0 ? grid.itemAt(index - matrix.cols).bottom : parent.top
				left: col > 0 ? grid.itemAt(index - 1).right : parent.left

				topMargin: margin
				leftMargin: margin
				rightMargin: margin
				bottomMargin: margin
			}

			Component {
				id: inputDialog
				InputDialog {
					titleText: i18n.tr("Set Entry")
					msgText: i18n.tr("Element at %1, %2").arg(row + 1).arg(col + 1)
					confirmText: i18n.tr("Confirm")
					inputType: Qt.ImhFormattedNumbersOnly

					onConfirm: matrix.editEntry(parseFloat(input), row, col)
				}
			}

			MouseArea {
				anchors.fill: parent
				onClicked: {
					if (matrixVisualizer.editEnabled) {
						PopupUtils.open(inputDialog)
					}
				}
			}
		}
	}
}
