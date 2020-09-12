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
	QString humanReadableName = matrixNames.keys()[row];
	if (role == NameCol) {
		return humanReadableName;
	} else {
		QString internalName = matrixNames[humanReadableName];
		return QVariant::fromValue<MatrixWrapper*>(new MatrixWrapper(storedMatrices[internalName]));
	}
}

QHash<int, QByteArray> Memory::roleNames() const {
	QHash<int, QByteArray> names;
	names[NameCol] = "matrixName";
	names[MatrixCol] = "matrixValue";
	return names;
}

void Memory::initMemory() {
	storedMatrices = QMap<QString, Matrix*>();
	matrixNames = QMap<QString, QString>();

	QString loc = QStandardPaths::writableLocation(QStandardPaths::CacheLocation);
	QFile matrices(loc + "/matrices");
	if (!matrices.open(QIODevice::ReadOnly)) {
		return;
	}
	QFile names(loc + "/names");
	if (!names.open(QIODevice::ReadOnly)) {
		matrices.close();
		return;
	}

	QTextStream tsMatrices(&matrices);
	QString name;
	while (true) {
		QString tmpName;
		int rows, cols;

		tsMatrices >> tmpName;
		if (tmpName == "") break;
		name = tmpName;

		tsMatrices >> rows;
		tsMatrices >> cols;

		Matrix* mat = matrix_createMatrix(rows, cols);
		for (int r = 0; r < rows; r++) {
			for (int c = 0; c < cols; c++) {
				tsMatrices >> mat->matrix[r][c];
			}
		}

		storedMatrices[name] = mat;
		matrixCount++;
	}
	matrices.close();

	matrixCount = name.right(name.length() - 10).toInt() + 1;

	QDataStream dsNames(&names);
	dsNames.setVersion(QDataStream::Qt_5_3);
	dsNames >> matrixNames;
	names.close();
	reloadTable();
}

void Memory::writeToDisk() const {
	QString loc = QStandardPaths::writableLocation(QStandardPaths::CacheLocation);
	QFile matrices(loc + "/matrices");
	if (!matrices.open(QIODevice::WriteOnly)) {
		return;
	}
	QFile names(loc + "/names");
	if (!names.open(QIODevice::WriteOnly)) {
		matrices.close();
		return;
	}

	QTextStream tsMatrices(&matrices);
	for (auto entry = storedMatrices.cbegin(); entry != storedMatrices.cend(); entry++) {
		const Matrix* mat = entry.value();
		tsMatrices << entry.key() << " " << mat->rows << " " << mat->cols;
		for (int r = 0; r < mat->rows; r++) {
			for (int c = 0; c < mat->cols; c++) {
				tsMatrices << " " << mat->matrix[r][c];
			}
		}
		tsMatrices << "\n";
	}
	matrices.close();

	QDataStream dsNames(&names);
	dsNames.setVersion(QDataStream::Qt_5_3);
	dsNames << matrixNames;
	names.close();
}

void Memory::clearMemory() {
	for (auto it = storedMatrices.begin(); it != storedMatrices.end();) {
		matrix_destroyMatrix(*it);
		it = storedMatrices.erase(it);
	}
	matrixNames.clear();
	matrixCount = 0;
	reloadTable();
}

bool Memory::matrixExists(QString name) const {
	return matrixNames.find(name) != matrixNames.end();
}

Matrix* Memory::getMatrixWithName(char* name) const {
	QString qname(name);
	if (storedMatrices.find(qname) != storedMatrices.end()) {
		return storedMatrices[qname];
	}
	return nullptr;
}

void Memory::eraseMatrixWithName(QString name) {
	QString internalName = matrixNames[name];
	matrixNames.remove(name);
	storedMatrices.remove(internalName);
	reloadTable();
}

void Memory::saveMatrixWithName(QString name, MatrixWrapper* matrix) {
	Matrix* mat = matrix_copyMatrix(matrix->getMatrix());
	if (matrixExists(name)) {
		QString internalName = matrixNames[name];
		matrix_destroyMatrix(storedMatrices[internalName]);
		storedMatrices[internalName] = mat;
	} else {
		QString internalName = QString("UserMatrix%1").arg(matrixCount++);
		matrixNames[name] = internalName;
		storedMatrices[internalName] = mat;
	}
	reloadTable();
}

void Memory::renameMatrix(QString oldName, QString newName) {
	matrixNames[newName] = matrixNames[oldName];
	matrixNames.remove(oldName);
	reloadTable();
}

QString Memory::replaceHumanReadableNames(QString expr) const {
	for (QMap<QString, QString>::const_iterator it = matrixNames.cbegin(); it != matrixNames.cend(); it++) {
		expr.replace(it.key(), it.value());
	}
	return expr;
}

void Memory::reloadTable() {
	beginResetModel();
	endResetModel();
}
