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

#include "matrixwrapper.h"

MatrixWrapper::MatrixWrapper() : matrix(nullptr) {}

MatrixWrapper::MatrixWrapper(Matrix* mat) : matrix(mat) {
	beginResetModel();
	endResetModel();
	emit matrixChanged();
}

void MatrixWrapper::loadMatrix(MatrixWrapper* mat) {
	beginResetModel();
	if (matrix) matrix_destroyMatrix(matrix);
	matrix = matrix_copyMatrix(mat->getMatrix());
	endResetModel();
	emit matrixChanged();
}

const Matrix* MatrixWrapper::getMatrix() const {
	return matrix;
}

int MatrixWrapper::rowCount(const QModelIndex &parent) const {
	if (matrix) {
		return matrix->rows * matrix->cols;
	}
	return 0;
}

int MatrixWrapper::rows() const {
	if (matrix) {
		return matrix->rows;
	}
	return 0;
}

int MatrixWrapper::cols() const {
	if (matrix) {
		return matrix->cols;
	}
	return 0;
}

QVariant MatrixWrapper::data(const QModelIndex &index, int role) const {
	int idx1D = index.row();
	int row = idx1D / cols();
	int col = idx1D % cols();
	return at(row, col);
}

float MatrixWrapper::at(int row, int col) const {
	if (matrix) {
		return matrix->matrix[row][col];
	}
	return 0;
}

void MatrixWrapper::editEntry(float val, int row, int col) {
	if (matrix) {
		beginResetModel();
		matrix->matrix[row][col] = val;
		endResetModel();
		emit matrixChanged();
	}
}

QHash<int, QByteArray> MatrixWrapper::roleNames() const {
	QHash<int, QByteArray> names;
	names[Qt::UserRole] = "entry";
	return names;
}

void MatrixWrapper::destroyMatrix() {
	if (matrix) {
		beginResetModel();
		matrix_destroyMatrix(matrix);
		endResetModel();
		emit matrixChanged();
	}
}

void MatrixWrapper::createMatrix(int rows, int cols) {
	beginResetModel();
	if (matrix) matrix_destroyMatrix(matrix);
	matrix = matrix_createZeroMatrix(rows, cols);
	endResetModel();
	emit matrixChanged();
}

void MatrixWrapper::makeZeroMatrix() {
	if (matrix) {
		beginResetModel();
		matrix_zeroMatrix(matrix);
		endResetModel();
		emit matrixChanged();
	}
}

void MatrixWrapper::makeIdentityMatrix() {
	if (matrix) {
		beginResetModel();
		matrix_makeIdentity(matrix);
		endResetModel();
		emit matrixChanged();
	}
}
