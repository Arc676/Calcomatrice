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

#include <QAbstractListModel>

#include "libmatrix.h"

class MatrixWrapper : public QAbstractListModel {
	Q_OBJECT

	Q_PROPERTY(int rows READ rows NOTIFY matrixChanged);
	Q_PROPERTY(int cols READ cols NOTIFY matrixChanged);
	int rows() const;
	int cols() const;

	Matrix* matrix;
signals:
	void matrixChanged();
public:
	MatrixWrapper();
	MatrixWrapper(Matrix* mat);
	Q_INVOKABLE void loadMatrix(MatrixWrapper* mat);

	const Matrix* getMatrix() const;

	Q_INVOKABLE float at(int row, int col) const;

	int rowCount(const QModelIndex &parent = QModelIndex()) const;
	QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
	QHash<int, QByteArray> roleNames() const;

	Q_INVOKABLE void emitReset();

	Q_INVOKABLE void destroyMatrix();
	Q_INVOKABLE void createMatrix(int rows, int cols);

	Q_INVOKABLE void makeZeroMatrix();
	Q_INVOKABLE void makeIdentityMatrix();
};
Q_DECLARE_METATYPE(MatrixWrapper*)

#endif
