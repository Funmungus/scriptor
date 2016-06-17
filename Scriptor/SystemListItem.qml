import QtQuick 2.0
import Ubuntu.Components 1.3

/*
 * Element member: index
 * External dependencies: systemList, iconFileDialog
 * systemList object: selected, name, command, icon
 */
SystemItem {
	btnIcon.onClicked: {
		iconFileDialog.iconFile(acceptIcon);
		var it = systemList[index];
		console.log(index + " " + it.selected + " " + it.name
			    + " " + it.command + " " + it.icon);
	}

	chkSelected.checked: systemList[index].selected
	editName.text: systemList[index].name
	editCmd.text: systemList[index].command

	chkSelected.onCheckedChanged: systemList[index].selected = chkSelected.checked
	btnSystem.onIconSourceChanged: icon = btnSystem.iconSource
	editName.onTextChanged: systemList[index].name = editName.text
	editCmd.onTextChanged: systemList[index].command = editCmd.text

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
