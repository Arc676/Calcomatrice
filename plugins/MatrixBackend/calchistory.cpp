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

#include "calchistory.h"

int CalcHistory::columnCount(const QModelIndex &parent) const {
	return 2;
}

int CalcHistory::rowCount(const QModelIndex &parent) const {
	return calculations.length();
}

QVariant CalcHistory::data(const QModelIndex &index, int role) const {
	int idx = index.row();
	if (role == ExprCol) {
		return calculations[idx];
	} else {
		return QVariant::fromValue<MatrixWrapper*>(results[idx]);
	}
}

QHash<int, QByteArray> CalcHistory::roleNames() const {
	QHash<int, QByteArray> names;
	names[ExprCol] = "calcExpr";
	names[ResCol] = "calcResult";
	return names;
}

void CalcHistory::emitReset() {
	beginResetModel();
	endResetModel();
}

void CalcHistory::addCalculation(QString expr, MatrixWrapper* res) {
	calculations.append(expr);
	results.append(res);
	emitReset();
}

void CalcHistory::delCalculation(int index) {
	calculations.removeAt(index);
	results[index]->destroyMatrix();
	results.removeAt(index);
	emitReset();
}

void CalcHistory::clearAll() {
	calculations.clear();
	for (QList<MatrixWrapper*>::iterator it = results.begin(); it != results.end();) {
		(*it)->destroyMatrix();
		it = results.erase(it);
	}
	emitReset();
}
