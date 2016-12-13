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

Page {
	property var procBuffer
	property int bufferFlags: {
		return usageSettings.showStdOut ? usageSettings.showStdErr ?
							  3 : 1 :
		usageSettings.showStdErr ? 2 : 0;
	}

	signal settingsClicked
	header: HeaderForm {
		id: pageHeader
		btnOptions.visible: true
		btnOptions.onClicked: settingsClicked()
	}

	Loader {
		width: parent.width
		anchors {
			top: UbuntuApplication.inputMethod.visible ? parent.top : pageHeader.bottom
			bottom: parent.bottom
			bottomMargin: UbuntuApplication.inputMethod.keyboardRectangle.height
		}
		sourceComponent: visible ? pageComponent : undefined
	}

	Component {
		id: pageComponent
		Rectangle {
			color: colorZ1
			anchors.fill: parent
			Rectangle {
				id: rectArea
				color: colorZ0
				anchors.fill: parent
				anchors.margins: 1
			}
			Item {
				id: outOption
				anchors {
					left: rectArea.left
					top: rectArea.top
					right: rectArea.right
					margins: units.gu(2)
				}
				height: chkOut.height > lblOut.height ?
						chkOut.height :
						lblOut.height
				CheckBox {
					id: chkOut
					anchors.left: parent.left
					anchors.verticalCenter: parent.verticalCenter
					width: windowSettings.unitWidth
					height: width
					checked: usageSettings.showStdOut
					onCheckedChanged: {
						usageSettings.showStdOut = checked;
						if (checked)
							bufferFlags |= 1;
						else
							bufferFlags &= 2;
						txtArea.text = getText();
					}
				}
				LabelForm {
					id: lblOut
					anchors {
						verticalCenter: parent.verticalCenter
						left: chkOut.right
						right: parent.right
						leftMargin: units.gu(2)
					}
					text: i18n.tr("Show Standard Output")
				}
			}
			Item {
				id: errOption
				anchors {
					left: rectArea.left
					top: outOption.bottom
					right: rectArea.right
					leftMargin: units.gu(2)
					topMargin: units.gu(0.5)
					rightMargin: units.gu(2)
				}
				height: chkErr.height > lblErr.height ?
						chkErr.height :
						lblErr.height
				CheckBox {
					id: chkErr
					anchors.left: parent.left
					anchors.verticalCenter: parent.verticalCenter
					width: windowSettings.unitWidth
					height: width
					checked: usageSettings.showStdErr
					onCheckedChanged: {
						usageSettings.showStdErr = checked;
						if (checked)
							bufferFlags |= 2;
						else
							bufferFlags &= 1;
						txtArea.text = getText();
					}
				}
				LabelForm {
					id: lblErr
					anchors {
						verticalCenter: parent.verticalCenter
						left: chkErr.right
						right: parent.right
						leftMargin: units.gu(2)
					}
					text: i18n.tr("Show Standard Error")
				}
			}
			LabelForm {
				id: txtArea
				anchors {
					top: errOption.bottom
					left: rectArea.left
					bottom: rectArea.bottom
					right: rectArea.right
					margins: units.gu(2)
				}
			}

			Connections {
				target: procBuffer
				/* When buffer is changed, first wait for it to be updated */
				onOutBufferChanged: setTextDelay.start();
				onErrBufferChanged: setTextDelay.start();
			}
			Timer {
				id: setTextDelay
				interval: 40
				repeat: false
				onTriggered: txtArea.text = getText();
			}
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
