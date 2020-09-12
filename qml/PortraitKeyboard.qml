/*
 * Copyright (C) 2017-2019 UBports
 * Copyright (C) 2015 Canonical Ltd
 *
 * This file is part of Ubuntu Calculator App
 * Modified for use in Calcomatrice
 *
 * Ubuntu Calculator App is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Ubuntu Calculator App is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.4
import Ubuntu.Components 1.3

CalcKeyboard {
    id: calcKeyboard

    KeyboardPage {
        buttonRatio: 0.6
        buttonMaxHeight: calculatorUI.height / 10.0

        keyboardModel: new Array(
            { text: "←", name: "delete", action: "delete", kbdKeys: [Qt.Key_Backspace, Qt.Key_Delete], secondaryAction: "clearFormula", role: "highlight" },
            { text: "( )", name: "universalBracket", pushText: "()", pasteTexts: ["(", ")"], kbdKeys: [Qt.Key_ParenLeft, Qt.Key_ParenRight, Qt.Key_BracketLeft, Qt.Key_BracketRight] },
            { text: "^", name: "power", pushText: "^", kbdKeys: [Qt.Key_AsciiCircum]},
            { text: ".", name: "scalarMul", pushText: ".", kbdKeys: [Qt.Key_Period] },
            { number: 7, name: "seven" },
            { number: 8, name: "eight" },
            { number: 9, name: "nine" },
            { text: "×", name: "multiply", pushText: "*", kbdKeys: [Qt.Key_Asterisk] },
            { number: 4, name: "four" },
            { number: 5, name: "five" },
            { number: 6, name: "six" },
            { text: "−", name: "minus", pushText: "-", kbdKeys: [Qt.Key_Minus] },
            { number: 1, name: "one" },
            { number: 2, name: "two" },
            { number: 3, name: "three" },
            { text: "+", name: "plus", kbdKeys: [Qt.Key_Plus] },
            { text: decimalPoint, name: "point", pushText: "." },
            { number: 0, name: "zero", forceNumber: true },
            { text: "=", name: "equals", wFactor: 2, action: "calculate", kbdKeys: [Qt.Key_Enter, Qt.Key_Return], role: "button" }
        )
    }
}
