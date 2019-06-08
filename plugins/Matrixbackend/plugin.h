#ifndef MATRIXBACKENDPLUGIN_H
#define MATRIXBACKENDPLUGIN_H

#include <QQmlExtensionPlugin>

class MatrixbackendPlugin : public QQmlExtensionPlugin {
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri);
};

#endif
