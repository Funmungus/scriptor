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
import Ubuntu.DownloadManager 0.1
import Scriptor 1.0

Dialog {
	id: dialogue
	title: i18n.tr("Download File")
	text: i18n.tr("Download Binary: Download and copy to bin folder ") +
		  utils.dataDir() + "/bin\n" +
		  i18n.tr("Download: Only download to ") + dlDir;
	readonly property string dlDir: utils.env("HOME") +
									"/.local/share/ubuntu-download-manager/" +
									applicationName + "/Downloads";
	readonly property var busyboxArchMap: {
		'armhf': 'armv7l',
		'i386': 'i686',
		'x86_64': 'x86_64',
		'amd64': 'x86_64'
	};
	property bool autoStart: false

	TextField {
		id: txtUrl
		text: busyboxUrl()
		placeholderText: i18n.tr("Download URL")
		enabled: !single.downloading
	}
	ProgressBar {
		minimumValue: 0
		maximumValue: 100
		value: single.progress
		SingleDownload {
			id: single
			property bool copyBin: false
		}

		Connections {
			target: single
			onDownloadingChanged: {
				txtStatus.text += "downloading = " + single.downloading + "\n";
			}
			onProgressChanged: {
				txtStatus.text = single.progress + "%\n";
				if (single.progress !== 100)
					return;
				if (single.copyBin) {
					var loc = txtUrl.text;
					var i = loc.lastIndexOf("/");
					if (i >= 0)
						loc = loc.substring(i + 1, loc.length);
					var fromFile = dlDir + "/" + loc;
					var toFile = utils.dataDir() + "/bin/";
					if (loc.substring(0, 7) === "busybox")
						toFile += "busybox";
					else
						toFile += loc;
					if (utils.copyFile(fromFile, toFile)) {
						utils.setPermissions(toFile, utils.binPermissions());
						txtStatus.text = i18n.tr("Download file and copy to bin directory complete!\n");
						txtStatus.text += i18n.tr("Executable is available at ") + toFile + "\n";
					} else {
						txtStatus.text = i18n.tr("Unable to copy file ") + fromFile +
								i18n.tr(" to ") + toFile + "\n";
					}
				} else {
					txtStatus.text = i18n.tr("Download complete!");
				}
				btnCancel.text = i18n.tr("Finish");
			}
		}
	}

	Button {
		id: btnDlBin
		text: i18n.tr("Download Binary")
		enabled: !single.downloading
		onClicked: {
			single.copyBin = true;
			btnCancel.text = i18n.tr("Cancel");
			single.download(txtUrl.text);
		}
	}
	Button {
		id: btnDl
		text: i18n.tr("Download")
		enabled: !single.downloading
		onClicked: {
			single.copyBin = false;
			btnCancel.text = i18n.tr("Cancel");
			single.download(txtUrl.text);
		}
	}
	Button {
		id: btnCancel
		text: i18n.tr("Cancel")
		onClicked: {
			if (single.downloading)
				single.cancel();
			PopupUtils.close(dialogue)
		}
	}
	TextArea {
		id: txtStatus
		height: units.gu(40)
		selectByMouse: true
		readOnly: true
	}

	Component.onCompleted: {
		if (autoStart) {
			txtUrl.text = busyboxUrl();
			single.copyBin = true;
			btnCancel.text = i18n.tr("Cancel");
			single.download(txtUrl.text);
		}
	}

	function busyboxUrl() {
		return "https://busybox.net/downloads/binaries/latest/busybox-" +
				translateArch();
	}

	function translateArch() {
		if (busyboxArchMap[CLICK_ARCH] === undefined)
			return CLICK_ARCH
		return busyboxArchMap[CLICK_ARCH];
	}
}
