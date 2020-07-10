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

ListItem {
	id: matrixVisualizer
	height: matrixLabel.height * (1 + matrix.rows) + margin * matrix.rows

	property Matrix matrix
	property var labelText

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

			property int row: Math.floor(index / matrix.rows)
			property int col: index % matrix.rows

			anchors {
				top: row > 0 ? grid.itemAt(index - matrix.cols).bottom : parent.top
				left: col > 0 ? grid.itemAt(index - 1).right : parent.left

				topMargin: margin
				leftMargin: margin
				rightMargin: margin
				bottomMargin: margin
			}
		}
	}

	Component.onCompleted: matrix.emitReset()
}
