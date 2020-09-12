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

#ifndef MEMORY_H
#define MEMORY_H

#include <QAbstractTableModel>
#include <QMap>
#include <QString>
#include <QVariant>
#include <QStandardPaths>
#include <QFile>
#include <QDataStream>
#include <QTextStream>

#include <QQmlEngine>
#include <QJSEngine>

#include "matrixwrapper.h"

class Memory : public QAbstractTableModel {
	Q_OBJECT

	QMap<QString, Matrix*> storedMatrices;
	QMap<QString, QString> matrixNames;
	int matrixCount = 0;

	enum {
		NameCol = Qt::UserRole,
		MatrixCol
	};

	static Memory* instance;
public:
	static QObject* qmlInstance(QQmlEngine* engine, QJSEngine* jsEngine) {
		if (!Memory::instance) {
			Memory::instance = new Memory;
		}
		return Memory::instance;
	}

	static Memory* getInstance() {
		return Memory::instance;
	}

	int columnCount(const QModelIndex &parent) const;
	int rowCount(const QModelIndex &parent = QModelIndex()) const;
	QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
	QHash<int, QByteArray> roleNames() const;

	QString replaceHumanReadableNames(QString expr) const;

	Q_INVOKABLE bool matrixExists(QString name) const;
	Q_INVOKABLE void saveMatrixWithName(QString name, MatrixWrapper* matrix);
	Q_INVOKABLE void eraseMatrixWithName(QString name);

	Q_INVOKABLE void renameMatrix(QString oldName, QString newName);

	Matrix* getMatrixWithName(char* name) const;

	Q_INVOKABLE void initMemory();
	Q_INVOKABLE void writeToDisk() const;
	Q_INVOKABLE void clearMemory();

	Q_INVOKABLE void reloadTable();
};

#endif
