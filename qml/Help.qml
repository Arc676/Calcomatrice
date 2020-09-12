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
			left: parent.left
			right: parent.right
			bottom: parent.bottom
			margins: margin
		}

		Column {
			width: scroll.width
			spacing: margin

			WrappingLabel {
				text: i18n.tr("Calcomatrice is a matrix calculator application. You can work with matrices of any size. Matrices can be saved in memory for later use under any name that starts with a letter; each matrix must have a unique name. Matrices are written to disk when the app exits and are restored on app launch. Clear the memory from the memory view to delete the saved matrices.")
			}

			WrappingLabel {
				text: i18n.tr("Use <b>+</b>, <b>-</b> to add or subtract matrices. Use <b>×</b> to multiply matrices together. Scalar multiplication uses <b>•</b> and the scalar must precede the matrix. The caret <b>^</b> represents matrix powers; the matrix must precede the power. If a digit follows the minus operator, these will be parsed together as a negative number. To subtract an expression starting with a digit, add that expression using the opposite number (e.g. to compute <i>A - 2B</i>, write <b>A + -2 • B</b>).")
			}

			WrappingLabel {
				text: i18n.tr("In portrait mode, swipe up from the bottom of the screen to access matrix memory and additional matrix functions. Tap the arrow button to dismiss the extended panel. From the extended panel, tap the name of a matrix to add it to the formula. This will automatically dismiss the panel. Adding functions to the formula will not dismiss the panel. Remember to add the closing parentheses to close off any used functions. In landscape mode, the extended input panel with all inputs is always visible. The additional functions compute the matrix inverse, the determinant, the matrix of minors or cofactors, the transpose, and the identity matrix of the provided size. The matrix inverse, matrix of minors, and matrix of cofactors are only defined for square matrices. The identity matrix function takes an integer as its argument. The other two functions can take any matrix as their argument. Note that the determinant of a nonsquare matrix is always zero. Also note that the determinant is represented internally as a 1x1 matrix and the output of the determinant function cannot be used as a scalar in formulas.")
			}

			WrappingLabel {
				text: i18n.tr("The toolbar provides access to matrix memory and the matrix editor. The editor is also accessible from matrix memory. From the main calculator view, you can also clear your calculation history.")
			}

			WrappingLabel {
				text: i18n.tr("Swipe right on any entry in the calculation history and tap the delete button to delete that entry. Swipe left and tap the save button to save the result of the calculation as a new matrix in memory. From matrix memory, swipe right on any entry and tap delete to delete the matrix. Swipe left to access renaming and editing options.")
			}

			WrappingLabel {
				text: i18n.tr("To create a new matrix, use the matrix editor. Enter the size of the matrix and tap 'Create matrix' to create a new, empty matrix of the given size. Tap the entries to edit them. Shortcuts are provided for the zero matrix and identity matrix. To save the matrix, it needs a unique name. Saving a matrix under the name of an existing matrix will overwrite the old matrix.")
			}
		}
	}
}
