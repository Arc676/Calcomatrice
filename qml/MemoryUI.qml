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
	id: memoryUI
	anchors.fill: parent

	header: DefaultHeader {}

	Component {
		id: renameDialog
		InputDialog {
			property var oldName

			titleText: i18n.tr("Rename Matrix")
			msgText: i18n.tr("Enter new matrix name")
			confirmText: i18n.tr("Rename matrix")

			onConfirm: MatrixMemory.renameMatrix(oldName, input)
		}
	}

	UbuntuListView {
		id: memoryList
		clip: true
		anchors {
			top: memoryUI.header.bottom
			topMargin: margin
			left: parent.left
			leftMargin: margin
			right: parent.right
			rightMargin: margin
			bottom: clearMemBtn.top
			bottomMargin: margin
		}
		model: MatrixMemory
		delegate: ListItem {
			height: matrixVisualizer.height

			MatrixVisualizer {
				id: matrixVisualizer
				labelText: matrixName
				nullText: i18n.tr("Matrix doesn't seem to exist")
				matrix: matrixValue
			}

			leadingActions: ListItemActions {
				actions: [
					Action {
						iconName: "delete"

						onTriggered: MatrixMemory.eraseMatrixWithName(matrixName)
					}
				]
			}

			trailingActions: ListItemActions {
				actions: [
					Action {
						iconName: "tag"

						onTriggered: {
							PopupUtils.open(renameDialog, memoryUI, {"oldName" : matrixName})
						}
					},
					Action {
						iconName: "edit"

						onTriggered: {
							pageViewer.matrixCreatorPage.loadMatrix(matrixValue)
							pageViewer.push(pageViewer.matrixCreatorPage)
						}
					}
				]
			}
		}
	}

	Button {
		id: clearMemBtn
		anchors {
			left: parent.left
			leftMargin: margin
			right: parent.right
			rightMargin: margin
			bottom: parent.bottom
			bottomMargin: margin
		}
		text: i18n.tr("Clear Memory")
		onClicked: PopupUtils.open(confirmClearDialog)
	}

	Component {
		id: confirmClearDialog

		ConfirmDialog {
			warningText: i18n.tr("Are you sure you want to clear all saved matrices? This cannot be undone.")
			confirmText: i18n.tr("Yes, delete them")
			onConfirm: MatrixMemory.clearMemory()
		}
	}
}
