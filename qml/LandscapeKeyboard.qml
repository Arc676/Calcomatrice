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
import Ubuntu.Components 1.3

Rectangle {
	id: calcKeyboard
	width: parent.width
	height: calculatorUI.height / 2

	PortraitKeyboard {
		id: kbd
		anchors {
			left: parent.left
			top: parent.top
			right: parent.horizontalCenter
			bottom: parent.bottom
		}
	}

	BottomPane {
		width: parent.width / 2
		height: parent.height
		anchors {
			left: parent.horizontalCenter
			top: parent.top
			right: parent.right
			bottom: parent.bottom
		}
	}
}
