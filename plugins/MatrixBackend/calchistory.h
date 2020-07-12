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

#ifndef CALCHISTORY_H
#define CALCHISTORY_H

#include <QAbstractTableModel>
#include <QList>
#include <QString>

#include "matrixwrapper.h"

class CalcHistory : public QAbstractTableModel {
	Q_OBJECT

	enum {
		ExprCol = Qt::UserRole,
		ResCol
	};

	QList<QString> calculations;
	QList<MatrixWrapper*> results;
public:
	int columnCount(const QModelIndex &parent) const;
	int rowCount(const QModelIndex &parent = QModelIndex()) const;
	QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
	QHash<int, QByteArray> roleNames() const;

	Q_INVOKABLE void addCalculation(QString expr, MatrixWrapper* res);
	Q_INVOKABLE void delCalculation(int index);
	Q_INVOKABLE void clearAll();

	Q_INVOKABLE void emitReset();
};

#endif
