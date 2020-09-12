/*
 * Copyright (C) 2017-2019 UBports
 * Copyright 2013, 2015 Canonical Ltd.
 *
 * This file is part of ubuntu-calculator-app.
 * Modified for use in Calcomatrice
 *
 * ubuntu-calculator-app is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * ubuntu-calculator-app is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.Controls.Suru 2.2

MouseArea {
    id: buttonRect
    objectName: modelname + "Button"

    property alias text: buttonText.text
    property string role: ""

    readonly property bool kbdPressed: JSON.parse(model.kbdKeys).indexOf(pressedKey) > -1 || (pressedKeyText == text)

    onClicked: {
        //We need to force active focus to hide Favourites tab from bottom edge
        inputField.forceActiveFocus();
    }

    onKbdPressedChanged: {
        if (!kbdPressed) {
            buttonRect.clicked(null);
        }
    }

    Rectangle {
        anchors.fill: parent
        visible: (role != "button")

        color: (buttonRect.pressed || buttonRect.kbdPressed) ? Suru.secondaryBackgroundColor : Suru.backgroundColor

        Behavior on color {
            ColorAnimation {
                duration: UbuntuAnimation.SnapDuration
            }
        }
    }

    UbuntuShape {
        anchors {
            fill: parent
            topMargin: units.gu(0.5)
            bottomMargin: units.gu(0.5)
            leftMargin: units.gu(2.5)
            rightMargin: units.gu(2.5)
        }
        visible: (role == "button")
        aspect: UbuntuShape.Flat

        backgroundColor: (buttonRect.pressed || buttonRect.kbdPressed) ? Qt.darker(Suru.color(Suru.Orange), 1.1) : Suru.color(Suru.Orange)

        Behavior on backgroundColor {
            ColorAnimation {
                duration: UbuntuAnimation.SnapDuration
            }
        }
    }

    Text {
        id: buttonText
        anchors.centerIn: parent
        color: {
            if (role == "highlight") {
                return Suru.color(Suru.Orange);
            }
            else if (role == "button") {
                return Suru.color(Suru.White);
            }

            return Suru.foregroundColor
        }
        font.pixelSize: 0.5 * parent.height
        opacity: enabled ? 1.0 : 0.5
    }
}
