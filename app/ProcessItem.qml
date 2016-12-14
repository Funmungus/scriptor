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
import "Utils.js" as Utils

Item {
	property alias procBuffer: procBuffer
	property alias chkSelected: chkSelected
	property alias btnStart: btnStart
	property alias btnIcon: btnIcon
	property alias editName: editName
	property alias editCmd: editCmd

	height: editColumn.height

	property int margins: units.gu(0.5)
	signal showProcBuffer(var procBuffer)
	ProcessBuffer {
		id: procBuffer
		onError: Utils.showMessage(btnStart, error);
		/* Should this be the data or cache directory? */
		Component.onCompleted: procBuffer.setWorkingDirectory(utils.dataDir())
	}

	CheckBox {
		id: chkSelected
		anchors.left: parent.left
		/* Left of screen, margin already in effect */
//		anchors.margins: margins
		width: windowSettings.unitWidth
		height: parent.height
	}

	ScriptorButton {
		id: btnStart
		anchors.left: chkSelected.right
		anchors.margins: margins
		width: windowSettings.unitWidth << 1
		height: width
		iconName: "media-playback-start"
		onClicked: {
			if (usageSettings.isProcDisplay)
				showProcBuffer(procBuffer);
			if (procBuffer.state() == ProcessNotRunning) {
				procBuffer.reset();
				procBuffer.start(editCmd.text);
			} else {
				procBuffer.outBuffer += i18n.tr("Command is running, so it will be terminated\n");
				procBuffer.makeDead();
			}
		}
	}
	ScriptorButton {
		id: btnIcon
		anchors.left: btnStart.left
		anchors.top: btnStart.bottom
		anchors.topMargin: margins
		width: btnStart.width
		height: windowSettings.unitWidth
		iconName: "insert-image"
	}
	Column {
		id: editColumn
		anchors {
			left: btnStart.right
			top: parent.top
			right: btnView.left
			leftMargin: margins
			rightMargin: margins
		}
		spacing: margins
		TextField {
			id: editName
			width: parent.width
			height: font.pixelSize << 1
			placeholderText: i18n.tr("Name")
			color: colorZ1
			mouseSelectionMode: TextEdit.SelectCharacters
			font.pixelSize: FontUtils.sizeToPixels(windowSettings.fontSize)
		}
		TextForm {
			id: editCmd
			width: parent.width
			placeholderText: i18n.tr("Command")
		}
	}
	ScriptorButton {
		id: btnView
		anchors.right: parent.right
		width: windowSettings.unitWidth
		height: parent.height
		iconName: "note"
		onClicked: showProcBuffer(procBuffer)
	}
}
