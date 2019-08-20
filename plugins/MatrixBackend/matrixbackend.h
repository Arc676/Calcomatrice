// Copyright (C) 2019 Arc676/Alessandro Vinciguerra

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation (version 3)

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
// See README and LICENSE for more details

#ifndef MATRIXBACKEND_H
#define MATRIXBACKEND_H

#include <QObject>

#include <map>
#include <string>

#include <string.h>
#include <ctype.h>

#include "matrix.h"

#define PARSE_TOKEN(expr, ptr) strtok_r(expr, " ", ptr)

class MatrixBackend: public QObject {
	Q_OBJECT

	Matrix* lastResult = nullptr;
	std::map<std::string, Matrix*> matrixMemory;

	bool isValidMatrixName(char* name);

	Matrix* eval(char* expr, char** progress);

public:
	Q_INVOKABLE void initMemory();

	Q_INVOKABLE void clearMemory();

	Q_INVOKABLE bool evaluateExpression(QVariant expr);
};

#endif
