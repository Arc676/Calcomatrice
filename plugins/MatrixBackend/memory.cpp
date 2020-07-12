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
