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

#include <QDebug>
#include "matrixbackend.h"

void MatrixBackend::initMemory() {
	matrixMemory = std::map<std::string, Matrix*>();
}

void MatrixBackend::clearMemory() {
	for (auto it = matrixMemory.cbegin(); it != matrixMemory.cend();) {
		matrix_destroyMatrix(it->second);
		matrixMemory.erase(it++);
	}
	emit memoryChanged();
}

Matrix* MatrixBackend::getMatrixWithName(char* name) {
        std::string cppname(name);
        if (matrixMemory.find(cppname) != matrixMemory.end()) {
                return matrixMemory[cppname];
        }
        return nullptr;
}

void MatrixBackend::saveMatrixWithName(char* name, Matrix* m) {
        std::string cppname(name);
        if (matrixMemory.find(cppname) != matrixMemory.end()) {
                matrix_destroyMatrix(matrixMemory[cppname]);
        }
        matrixMemory[cppname] = m;
}

bool MatrixBackend::isValidMatrixName(char* name) {
        char c = name[0];
        if (isalpha(c)) {
                if (c != 'i' && c != 'm' && c != 't'&& c != 'd' && c != 'c') {
                        return true;
                }
        }
        return false;
}

Matrix* MatrixBackend::eval(char* expr, char** progress) {
        evalFailed = false;
        Matrix* res = 0;
        char* saveptr;
        if (progress) {
                saveptr = *progress;
        }
        char* token = progress ? PARSE_TOKEN(NULL, &saveptr) : PARSE_TOKEN(expr, &saveptr);
        switch (token[0]) {
                case '+':
                case '-':
                case '*':
                {
                        Matrix* left = eval(expr, &saveptr);
                        if (evalFailed) return nullptr;

                        Matrix* right = eval(expr, &saveptr);
                        if (evalFailed) {
                                matrix_destroyMatrix(left);
                                return nullptr;
                        }

                        if (token[0] == '-') {
                                matrix_multiplyScalar(right, right, -1);
                        }

                        res = matrix_createMatrix(left->rows, right->cols);
                        if (token[0] == '*') {
                                matrix_multiplyMatrix(res, left, right);
                        } else {
                                matrix_add(res, left, right);
                        }

                        matrix_destroyMatrix(left);
                        matrix_destroyMatrix(right);
                        break;
                }
                case '.':
                {
                        token = PARSE_TOKEN(NULL, &saveptr);
                        double scalar = (double)strtod(token, (char**)NULL);

                        Matrix* m1 = eval(expr, &saveptr);
                        if (evalFailed) return nullptr;

                        res = matrix_createMatrix(m1->rows, m1->cols);
                        matrix_multiplyScalar(res, m1, scalar);
                        matrix_destroyMatrix(m1);
                        break;
                }
                case '^':
                {
                        Matrix* m1 = eval(expr, &saveptr);
                        if (evalFailed) return nullptr;

                        token = PARSE_TOKEN(NULL, &saveptr);
                        int power = (int)strtol(token, (char**)NULL, 0);
                        if (power == 0) {
                                res = matrix_createIdentityMatrix(m1->rows);
                                matrix_destroyMatrix(m1);
                                break;
                        } else if (power < 2) {
                                res = m1;
                                break;
                        }
                        Matrix* m2 = matrix_copyMatrix(m1);
                        Matrix* mp = matrix_copyMatrix(m1);
                        for (int i = 2; i <= power; i++) {
                                matrix_multiplyMatrix(mp, m1, m2);
                                matrix_copyEntries(m1, mp);
                        }
                        res = mp;
                        matrix_destroyMatrix(m1);
                        matrix_destroyMatrix(m2);
                        break;
                }
                case 'm':
                case 'i':
                case 'd':
                case 'c':
                {
                        if (!strcmp(token, "id")) {
                                token = PARSE_TOKEN(NULL, &saveptr);
                                int size = (int)strtol(token, (char**)NULL, 0);
                                res = matrix_createIdentityMatrix(size);
                        } else {
                                Matrix* m1 = eval(expr, &saveptr);
                                if (evalFailed) return nullptr;

                                Matrix* minors = matrix_createMatrix(m1->rows, m1->cols);
                                Matrix* cofactors = matrix_createMatrix(m1->rows, m1->cols);
                                double det = matrix_invert(m1, m1, minors, cofactors);
                                switch (token[0]) {
                                        case 'd':
                                                res = matrix_createMatrixWithElements(1, 1, det);
                                                break;
                                        case 'i':
                                        default:
                                                res = matrix_copyMatrix(m1);
                                                break;
                                        case 'c':
                                                res = matrix_copyMatrix(cofactors);
                                                break;
                                        case 'm':
                                                res = matrix_copyMatrix(minors);
                                                break;
                                }
                                matrix_destroyMatrix(m1);
                                matrix_destroyMatrix(minors);
                                matrix_destroyMatrix(cofactors);
                        }
                        break;
                }
                case 't':
                {
                        Matrix* m1 = eval(expr, &saveptr);
                        if (evalFailed) return nullptr;

                        res = matrix_createMatrix(m1->cols, m1->rows);
                        matrix_transpose(res, m1);
                        matrix_destroyMatrix(m1);
                        break;
                }
                default:
                        if (token[strlen(token) - 1] == '\n') {
                                token[strlen(token) - 1] = '\0';
                        }
                        Matrix* stored = getMatrixWithName(token);
                        if (!stored) {
                                evalFailed = true;
                                return nullptr;
                        }
                        res = matrix_copyMatrix(stored);
                        break;
        }
        if (progress) {
                *progress = saveptr;
        }
        return res;
}
