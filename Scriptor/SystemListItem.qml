import QtQuick 2.0
import Ubuntu.Components 1.3

/*
 * Element member: index
 * External dependencies: systemList, iconFileDialog
 * systemList object: selected, name, command, icon
 */
SystemItem {
	btnIcon.onClicked: iconFileDialog.iconFile(acceptIcon);

	chkSelected.checked: systemList[index].selected
	editName.text: systemList[index].name ? systemList[index].name : ""
	editCmd.text: systemList[index].command ? systemList[index].command : ""

	chkSelected.onCheckedChanged: systemList[index].selected = chkSelected.checked
	btnSystem.onIconSourceChanged: icon = btnSystem.iconSource ? btnSystem.iconSource : ""
	editName.onTextChanged: systemList[index].name = editName.text ? editName.text : ""
	editCmd.onTextChanged: systemList[index].command = editCmd.text ? editCmd.text : ""

	// Allow scrolling to view when keyboard is shown
	editName.onActiveFocusChanged: setLastFocus(editName.activeFocus);
	editCmd.onActiveFocusChanged: setLastFocus(editCmd.activeFocus);

	function setLastFocus(isFocused) {
		console.log("focusing ? " + index + isFocused)
		if (isFocused) {
			lastFocus = index;
		}
	}

	Component.onCompleted: {
		refreshIcon();
	}

	function acceptIcon(iconPath) {
		systemList[index].icon = iconPath;
		refreshIcon();
	}

	function refreshIcon() {
		var str = systemList[index].icon;
		if (str !== null && !str.isNull && !str.isEmpty) {
			btnSystem.iconSource = str;
		} else {
			btnSystem.iconName = "media-playback-start";
		}
	}
}
