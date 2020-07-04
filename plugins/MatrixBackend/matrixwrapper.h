// Copyright (C) 2020 Arc676/Alessandro Vinciguerra

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation (version 3)

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.
// See README and LICENSE for more details

#ifndef MATRIX_WRAPPER_H
#define MATRIX_WRAPPER_H

#include <QObject>

#include "libmatrix.h"

class MatrixWrapper : public QObject {
	Q_OBJECT

	Q_PROPERTY(int rows READ rowCount);
	Q_PROPERTY(int cols READ colCount);

	Matrix* matrix;
public:
	MatrixWrapper();
	MatrixWrapper(Matrix* mat);

	const Matrix* getMatrix() const;

	int rowCount() const;
	int colCount() const;
	Q_INVOKABLE float at(int row, int col) const;
};

#endif
