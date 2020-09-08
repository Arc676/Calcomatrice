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
import Ubuntu.Components.Popups 1.3

import MatrixBackend 1.0

Dialog {
	id: dialog
	objectName: "inputDialog"

	signal confirm(var input)

	property var confirmText
	property var titleText
	property var msgText

	title: titleText
	text: msgText

	TextField {
		id: inputField
	}

	Button {
		id: confirm
		text: dialog.confirmText
		onClicked: {
			PopupUtils.close(dialog)
			dialog.confirm(inputField.text)
		}
	}

	Button {
		id: cancel
		text: i18n.tr("Cancel")
		onClicked: {
			PopupUtils.close(dialog)
		}
	}
}
