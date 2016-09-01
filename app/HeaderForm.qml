/*
  Copyright (c) 2016, Jonathan Pelletier
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.

  2. Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.4
import Ubuntu.Components 1.3

PageHeader {
	visible: !UbuntuApplication.inputMethod.visible
	property alias icon: icon
	property alias lblTitle: lblTitle
	property alias btnOptions: btnOptions
	Icon {
		id: icon
		source: Qt.resolvedUrl("qrc:/graphics/Scriptor.png")
		anchors.horizontalCenter: parent.horizontalCenter
		height: parent.height
		width: height
	}
	LabelForm {
		visible: icon.visible
		anchors {
			left: icon.right
			verticalCenter: parent.verticalCenter
		}
		text: i18n.tr("-gooey")
	}
	LabelForm {
		id: lblTitle
		anchors {
			left: parent.left
			leftMargin: units.gu(5)
		}
		height: parent.height
		text: i18n.tr("Scriptor")
		font.pixelSize: height * 2 / 3
	}
	ScriptorButton {
		id: btnOptions
		anchors {
			top: parent.top
			right: parent.right
			bottom: parent.bottom
		}
		width: height
		iconName: "settings"
	}
}
