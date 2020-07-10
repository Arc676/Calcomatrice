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

import MatrixBackend 1.0

PageHeader {
	id: header
	title: i18n.tr("Calcomatrice")

	trailingActionBar {
		actions: [
			Action {
				iconName: "add"
				visible: pageViewer.currentPage !== pageViewer.matrixCreatorPage
				text: i18n.tr("New Matrix")

				onTriggered: pageViewer.push(pageViewer.matrixCreatorPage)
			},
			Action {
				iconName: "view-list-symbolic"
				visible: pageViewer.depth === 1
				text: i18n.tr("View Stored Matrices")

				onTriggered: pageViewer.push(pageViewer.memoryPage)
			},
			Action {
				iconName: "reset"
				visible: true
				text: i18n.tr("Clear Memory")

				onTriggered: PopupUtils.open(confirmClearDialog, pageViewer.currentItem, {})
			},
			Action {
				iconName: "info"
				visible: pageViewer.depth === 1
				text: i18n.tr("About Calcomatrice")

				onTriggered: pageViewer.push(Qt.resolvedUrl("About.qml"))
			},
			Action {
				iconName: "help"
				visible: pageViewer.depth === 1
				text: i18n.tr("Help")

				onTriggered: pageViewer.push(Qt.resolvedUrl("Help.qml"))
			}
		]
	}

	Component {
		id: confirmClearDialog

		ConfirmDialog {
			onClearMemory: {
				MatrixMemory.clearMemory()
			}
		}
	}
}
