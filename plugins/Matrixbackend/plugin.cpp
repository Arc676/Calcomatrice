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

#include <QtQml>
#include <QtQml/QQmlContext>

#include "plugin.h"
#include "matrixbackend.h"

void MatrixBackendPlugin::registerTypes(const char *uri) {
	//@uri MatrixBackend
	qmlRegisterSingletonType<MatrixBackend>(uri, 1, 0, "MatrixBackend", [](QQmlEngine*, QJSEngine*) -> QObject* { return new MatrixBackend; });
}
