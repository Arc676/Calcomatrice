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

MatrixWrapper::MatrixWrapper() : matrix(nullptr) {}

MatrixWrapper::MatrixWrapper(Matrix* mat) : matrix(mat) {}

int MatrixWrapper::rowCount() const {
	if (matrix) {
		return matrix->rows;
	}
	return 0;
}

int MatrixWrapper::colCount() const {
	if (matrix) {
		return matrix->cols;
	}
	return 0;
}

float MatrixWrapper::at(int row, int col) const {
	if (matrix) {
		return matrix->matrix[row][col];
	}
	return 0;
}
