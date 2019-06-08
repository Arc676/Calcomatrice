#include <QtQml>
#include <QtQml/QQmlContext>

#include "plugin.h"
#include "matrixbackend.h"

void MatrixbackendPlugin::registerTypes(const char *uri) {
    //@uri Matrixbackend
    qmlRegisterSingletonType<Matrixbackend>(uri, 1, 0, "Matrixbackend", [](QQmlEngine*, QJSEngine*) -> QObject* { return new Matrixbackend; });
}
