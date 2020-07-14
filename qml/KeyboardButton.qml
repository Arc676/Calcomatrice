//Copyright (C) 2020 Arc676/Alessandro Vinciguerra <alesvinciguerra@gmail.com>

//This program is free software: you can redistribute it and/or modify
//it under the terms of the GNU General Public License as published by
//the Free Software Foundation (version 3)

//This program is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//GNU General Public License for more details.

//You should have received a copy of the GNU General Public License
//along with this program. If not, see <http://www.gnu.org/licenses/>.

import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.Controls.Suru 2.2

Rectangle {
	id: kbdBtn
	property var buttonText
	property var pushText
	width: parent.width
	height: btnLbl.height + 2 * margin
	color: mouseArea.pressed ? Suru.secondaryBackgroundColor : Suru.backgroundColor

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		onClicked: inputField.text += kbdBtn.pushText
	}

	Text {
		id: btnLbl
		anchors.centerIn: parent
		text: kbdBtn.buttonText
	}
}
