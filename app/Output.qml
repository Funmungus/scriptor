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

/* TODO: Page instead of Popover */
Popover {
	property alias textArea: txtArea
	property var procBuffer
	property int bufferFlags: showStdOut ? showStdErr ? 3 : 1 : showStdErr ? 2 : 0;
	id: rootPopover
	Rectangle {
		id: rectBoundary
		color: colorZ1
		width: contentWidth
		height: contentHeight

		Rectangle {
			id: rectArea
			color: colorZ0
			/* This is the root element, cannot anchor */
			width: contentWidth - units.gu(2)
			height: contentHeight - btnBack.height
			x: units.gu(1)
			y: units.gu(1)
			CheckBox {
				id: chkOut
				anchors {
					top: parent.top
					left: parent.left
				}
				height: units.gu(5)
				width: units.gu(5)
				onCheckedChanged: {
					showStdOut = checked;
					if (checked)
						bufferFlags |= 1;
					else
						bufferFlags &= 2;
					txtArea.text = getText();
				}
			}
			Binding {
				target: chkOut
				property: "checked"
				value: showStdOut
			}
			LabelForm {
				id: txtOut
				anchors {
					top: chkOut.top
					left: chkOut.right
					right: parent.right
				}
				height: chkOut.height
				text: i18n.tr("Show Standard Output")
				color: colorZ1
				font.pixelSize: height * 2 / 3
			}
			CheckBox {
				id: chkErr
				anchors {
					top: chkOut.bottom
					left: parent.left
				}
				height: units.gu(5)
				width: units.gu(5)
				onCheckedChanged: {
					showStdErr = checked;
					if (checked)
						bufferFlags |= 2;
					else
						bufferFlags &= 1;
					txtArea.text = getText();
				}
			}
			Binding {
				target: chkErr
				property: "checked"
				value: showStdErr
			}
			LabelForm {
				id: txtErr
				anchors {
					top: chkErr.top
					left: chkErr.right
					right: parent.right
				}
				height: chkErr.height
				text: i18n.tr("Show Standard Error")
				color: colorZ1
				font.pixelSize: height * 2 / 3
			}

			LabelArea {
				id: txtArea
				anchors {
					top: chkErr.bottom
					left: parent.left
					bottom: parent.bottom
					right: parent.right
				}
				color: colorZ1
				font.pointSize: units.gu(3)
				wrapMode: Text.WrapAtWordBoundaryOrAnywhere
				text: getText()
			}

			Connections {
				target: procBuffer
				onOutBufferChanged: txtArea.text = getText()
				onErrBufferChanged: txtArea.text = getText()
			}
		}

		Button {
			id: btnBack
			anchors {
				bottom: parent.bottom
				left: parent.left
				right: parent.right
			}
			height: units.gu(8)
			text: i18n.tr("Close");
			onClicked: PopupUtils.close(rootPopover);
		}
	}

	function getText() {
		switch (bufferFlags) {
		case 1:
			return procBuffer.outBuffer;
		case 2:
			return procBuffer.errBuffer;
		case 3:
			return procBuffer.combineBuffer;
		}
		return "";
	}
}
