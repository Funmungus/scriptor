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
import Ubuntu.Components.Popups 1.3
import Scriptor 1.0
import "popups.js" as Pops

Item {
	property alias procBuffer: procBuffer
	property alias chkSelected: chkSelected
	property alias btnStart: btnStart
	property alias btnIcon: btnIcon
	property alias editName: editName
	property alias editCmd: editCmd
	property bool isExpanded: false

	height: isExpanded ? units.gu(28) : units.gu(14)

	ProcessBuffer {
		id: procBuffer
		onError: Pops.showMessage(btnStart, error);
		/* Should this be the data or cache directory? */
		Component.onCompleted: procBuffer.setWorkingDirectory(utils.dataDir())
	}

	CheckBox {
		id: chkSelected
		anchors.left: parent.left
		width: units.gu(5)
		height: parent.height
	}

	Button {
		id: btnStart
		anchors.left: chkSelected.right
		height: parent.height
		width: height
		iconName: "media-playback-start"
		color: colorZ0
		onClicked: {
			if (procBuffer.state() == ProcessNotRunning) {
				procBuffer.reset();
				procBuffer.start(editCmd.text);
			} else {
				procBuffer.outBuffer += i18n.tr("Command is running, so it will be terminated\n");
				procBuffer.makeDead();
			}
		}
	}
	Button {
		id: btnIcon
		anchors.left: btnStart.right
		width: units.gu(5)
		height: parent.height
		color: colorSlime
		iconName: "insert-image"
	}
	TextField {
		id: editName
		anchors {
			left: btnIcon.right
			top: parent.top
			right: btnView.left
		}
		height: units.gu(5)
		placeholderText: i18n.tr("Name")
		font.pixelSize: height * 2 / 3
		mouseSelectionMode: TextEdit.SelectCharacters
	}
	TextArea {
		id: editCmd
		anchors {
			right: editName.right
			top: editName.bottom
			left: editName.left
			bottom: parent.bottom
		}
		font.pixelSize: units.gu(3)
		placeholderText: i18n.tr("Command")
		wrapMode: Text.WrapAtWordBoundaryOrAnywhere
		mouseSelectionMode: TextEdit.SelectCharacters
	}
	Button {
		id: btnView
		anchors.right: parent.right
		width: units.gu(5)
		height: parent.height
		color: colorSlime
		iconName: "note"
		onClicked: {
			var fullPop = {
				'contentWidth': mainView.width,
				'contentHeight': mainView.height,
				'text':"Hello all",
				'procBuffer': procBuffer
			};
			PopupUtils.open(Qt.resolvedUrl("Output.qml"), mainView, fullPop);
		}
	}
}
