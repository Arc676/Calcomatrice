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
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Dialog {
	id: dialog
	objectName: "confirmDialog"

	signal clearMemory()

	text: i18n.tr("Are you sure you want to clear the memory? You will lose all saved matrices.")

	Button {
		id: confirm
		text: i18n.tr("Yes, delete them")
		onClicked: {
			dialog.clearMemory()
			PopupUtils.close(dialog)
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
