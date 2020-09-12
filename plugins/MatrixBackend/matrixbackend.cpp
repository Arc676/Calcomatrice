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

#include "matrixbackend.h"

MatrixBackend* MatrixBackend::instance = nullptr;
bool MatrixBackend::evalFailed = false;

int isBinaryOperator(char* str) {
	if (str[1] != 0) return 0;
	char c = str[0];
	return c == '+' || c == '-' || c == '*' || c == '#' || c == '^';
}

int isUnaryOperator(char* str) {
	char c = str[0];
	return c == 'i' || c == 'd' || c == 'm' || c == 'c' || c == 't';
}

void operatorProperties(char* str, int* prec, int* left) {
        switch (str[0]) {
                case '+':
                        *prec = 10;
                        *left = 1;
                        return;
                case '-':
                        *prec = 10;
                        *left = 1;
                        return;
                case '*':
                        *prec = 20;
                        *left = 1;
                        return;
                case '^':
                        *prec = 30;
                        *left = 0;
                        return;
                case '#':
                        *prec = 20;
                        *left = 1;
                        return;
        }
        *prec = 0;
        *left = 0;
}

MatrixWrapper* MatrixBackend::evaluateExpression(QString expr) const {
	expr = Memory::getInstance()->replaceHumanReadableNames(expr);
	expr.replace("invert", "i");
	expr.replace("det", "d");
	expr.replace("minors", "m");
	expr.replace("cofactors", "c");
	expr.replace("transpose", "t");
	expr.replace("identity", "id");
	expr.replace("(", " ( ");
	expr.replace(")", " ) ");
	QByteArray arr = expr.toUtf8();
	char* cexpr = arr.data();
	char* prefix = infixToPrefix(cexpr, isBinaryOperator, isUnaryOperator, operatorProperties);
	Matrix* result = MatrixBackend::eval(prefix, NULL);
	return new MatrixWrapper(result);
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
		case '#':
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
			Matrix* stored = Memory::getInstance()->getMatrixWithName(token);
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
