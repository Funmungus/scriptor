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
import Scriptor 1.0

Item {
	property alias chkSelected: chkSelected
	property alias btnSystem: btnSystem
	property alias btnIcon: btnIcon
	property alias editName: editName
	property alias editCmd: editCmd
	System {
		id: sysCmd
	}

	height: units.gu(15)

	CheckBox {
		id: chkSelected
		anchors {
			top: parent.top
			left: parent.left
			bottom: parent.bottom
		}
		width: units.gu(5)
	}

	Button {
		id: btnSystem
		anchors {
			top: parent.top
			left: chkSelected.right
		}
		height: units.gu(10)
		width: height

		color: "#00000000"
		iconName: "media-playback-start"
		onClicked: {
			sysCmd.command = editCmd.text;
			sysCmd.execute();
		}
	}
	Button {
		id: btnIcon
		anchors {
			top: btnSystem.bottom
			bottom: parent.bottom
			left: btnSystem.left
			right: btnSystem.right
		}

		text: i18n.tr("Browse...")
	}
	TextField {
		id: editName
		anchors {
			left: btnSystem.right
			top: parent.top
			right: parent.right
		}
		height: parent.height / 2

		text: ""
		placeholderText: i18n.tr("Name")
		font.pixelSize: height * 2 / 3
	}
	TextField {
		id: editCmd
		anchors {
			right: editName.right
			top: editName.bottom
			left: editName.left
			bottom: parent.bottom
		}

		text: ""
		placeholderText: i18n.tr("Command")
		font.pixelSize: height * 2 / 3
	}
}
