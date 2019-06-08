#include <QDebug>

#include "matrixbackend.h"

Matrixbackend::Matrixbackend() {

}

void Matrixbackend::speak() {
    qDebug() << "hello world!";
}
