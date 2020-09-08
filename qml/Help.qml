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
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3

Page {
	id: aboutPage
	header: DefaultHeader {}

	ScrollView {
		id: scroll
		anchors {
			top: header.bottom
			topMargin: margin
			left: parent.left
			leftMargin: margin
			right: parent.right
			rightMargin: margin
			bottom: parent.bottom
		}

		Column {
			width: scroll.width
			spacing: margin

			WrappingLabel {
				text: i18n.tr("Calcomatrice is a matrix calculator application. You can work with matrices of any size. Matrices can be saved in memory for later use under any name that starts with a letter; each matrix must have a unique name.")
			}

			WrappingLabel {
				text: i18n.tr("Use <b>+</b>, <b>-</b> to add or subtract matrices. Use <b>*</b> to multiply matrices together. Scalar multiplication uses <b>.</b> and the scalar must precede the matrix. The caret <b>^</b> represents matrix powers; the matrix must precede the power.")
			}

			WrappingLabel {
				text: i18n.tr("In portrait mode, swipe up from the bottom of the screen to access matrix memory and additional matrix functions. Remember to add the closing parentheses to close off any used functions. In landscape mode, the extended input panel with all inputs is always visible. The additional functions compute the matrix inverse, the determinant, the matrix of minors or cofactors, the transpose, and the identity matrix of the provided size. The matrix inverse, matrix of minors, and matrix of cofactors are only defined for square matrices. The identity matrix function takes an integer as its argument. The other two functions can take any matrix as their argument. Note that the determinant of a nonsquare matrix is always zero.")
			}

			WrappingLabel {
				text: i18n.tr("The toolbar provides access to matrix memory and the matrix editor. The editor is also accessible from matrix memory. From the main calculator view, you can also clear your calculation history.")
			}

			WrappingLabel {
				text: i18n.tr("Swipe right on any entry in the calculation history to and tap the delete button to delete that entry. Swipe left and tap the save button to save the result of the calculation as a new matrix in memory. From matrix memory, swipe right on any entry and tap delete to delete the matrix. Swipe left to access renaming and editing options.")
			}
		}
	}
}
