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

#include "memory.h"

Memory* Memory::instance = nullptr;

int Memory::columnCount(const QModelIndex &parent) const {
	return 2;
}

int Memory::rowCount(const QModelIndex &parent) const {
	return storedMatrices.size();
}

QVariant Memory::data(const QModelIndex &index, int role) const {
	int row = index.row();
	if (role == NameCol) {
		return matrixNames[row];
	} else {
		return QVariant::fromValue<MatrixWrapper*>(new MatrixWrapper(storedMatrices[row]));
	}
}

QHash<int, QByteArray> Memory::roleNames() const {
	QHash<int, QByteArray> names;
	names[NameCol] = "matrixName";
	names[MatrixCol] = "matrix";
	return names;
}

void Memory::initMemory() {
	storedMatrices = QVector<Matrix*>();
	matrixNames = QVector<QString>();

	// test matrix
	Matrix* mat = matrix_createMatrixWithElements(2, 2, 1, 2, 3, 4);
	storedMatrices.push_back(mat);
	matrixNames.push_back("Test Matrix");
	reloadTable();
}

void Memory::clearMemory() {
	for (auto it = storedMatrices.begin(); it != storedMatrices.end();) {
		matrix_destroyMatrix(*it);
		it = storedMatrices.erase(it);
	}
	matrixNames.clear();
	reloadTable();
}

bool Memory::matrixExists(QString name) const {
	return matrixNames.indexOf(name) != -1;
}

Matrix* Memory::getMatrixWithName(char* name) const {
	QString qname(name);
	int idx = matrixNames.indexOf(qname);
	if (idx >= 0) {
			return storedMatrices[idx];
	}
	return nullptr;
}

void Memory::eraseMatrixWithName(QString name) {
	int idx = matrixNames.indexOf(name);
	matrixNames.erase(matrixNames.begin() + idx);
	storedMatrices.erase(storedMatrices.begin() + idx);
	reloadTable();
}

void Memory::saveMatrixWithName(QString name, MatrixWrapper* matrix) {
	int idx = matrixNames.indexOf(name);
	Matrix* mat = matrix_copyMatrix(matrix->getMatrix());
	if (idx >= 0) {
		matrix_destroyMatrix(storedMatrices[idx]);
		storedMatrices[idx] = mat;
	} else {
		matrixNames.push_back(name);
		storedMatrices.push_back(mat);
	}
	reloadTable();
}

void Memory::reloadTable() {
	beginResetModel();
	endResetModel();
}
