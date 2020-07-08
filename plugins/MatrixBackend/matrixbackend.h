// Copyright (C) 2019-20 Arc676/Alessandro Vinciguerra

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

#ifndef MATRIXBACKEND_H
#define MATRIXBACKEND_H

#include <QObject>
#include <QQmlEngine>
#include <QJSEngine>

#include <map>
#include <string>

#include <string.h>
#include <ctype.h>

#include "memory.h"

#define PARSE_TOKEN(expr, ptr) strtok_r(expr, " ", ptr)

class MatrixBackend: public QObject {
	Q_OBJECT

	static MatrixBackend* instance;
	static bool evalFailed;
public:
	static Matrix* eval(char* expr, char** progress);

	static QObject* qmlInstance(QQmlEngine* engine, QJSEngine* jsEngine) {
		if (!MatrixBackend::instance) {
			MatrixBackend::instance = new MatrixBackend;
		}
		return MatrixBackend::instance;
	}
};

#endif
