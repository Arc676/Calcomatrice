#ifndef MATRIXBACKEND_H
#define MATRIXBACKEND_H

#include <QObject>

class Matrixbackend: public QObject {
    Q_OBJECT

public:
    Matrixbackend();
    ~Matrixbackend() = default;

    Q_INVOKABLE void speak();
};

#endif
