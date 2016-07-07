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

import QtQuick 2.0
import Ubuntu.Components 1.3

/*
 * Element member: index
 * External dependencies: procList, iconFileDialog
 * procList object: selected, name, command, icon
 */
ProcessItem {
	btnIcon.onClicked: iconFileDialog.iconFile(acceptIcon);

	chkSelected.checked: procList[index].selected
	editName.text: procList[index].name ? procList[index].name : ""
	editCmd.text: procList[index].command ? procList[index].command : ""

	chkSelected.onCheckedChanged: procList[index].selected = chkSelected.checked
	btnStart.onIconSourceChanged: icon = btnStart.iconSource ? btnStart.iconSource : ""
	editName.onTextChanged: procList[index].name = editName.text ? editName.text : ""
	editCmd.onTextChanged: procList[index].command = editCmd.text ? editCmd.text : ""

	// Allow scrolling to view when keyboard is shown
	editName.onActiveFocusChanged: setLastFocus(editName.activeFocus);
	editCmd.onActiveFocusChanged: setLastFocus(editCmd.activeFocus);

        function setLastFocus(isFocused) {
		if (isFocused) {
			lastFocus = index;
		}
	}

	Component.onCompleted: {
		refreshIcon();
	}

	function acceptIcon(iconPath) {
		procList[index].icon = iconPath;
		refreshIcon();
	}

	function refreshIcon() {
		var str = procList[index].icon;
		if (str !== null && !str.isNull && !str.isEmpty) {
			btnStart.iconSource = str;
		} else {
			btnStart.iconName = "media-playback-start";
		}
	}
}