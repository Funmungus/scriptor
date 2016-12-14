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
import "Utils.js" as Utils

Dialog {
	id: dialogue
	title: i18n.tr("Download File")
	text: i18n.tr("Download Binary: Download and copy to bin folder ") +
		  utils.dataDir() + "/bin\n\n" +
		  i18n.tr("Download: Only download to download manager");
	readonly property var busyboxArchMap: {
		'armhf': 'armv7l',
		'i386': 'i686',
		'x86_64': 'x86_64',
		'amd64': 'x86_64'
	};
	property bool autoStart: false
	property var single: null
	property bool downloading: single ? single.downloading : false

	TextForm {
		id: txtUrl
		text: busyboxUrl()
		placeholderText: i18n.tr("Download URL")
		enabled: !downloading
	}
	ProgressBar {
		id: progressBar
		height: windowSettings.unitWidth
		minimumValue: 0
		maximumValue: 100
		value: 0
		DownloadManager {
			id: manager
			autoStart: true
			cleanDownloads: true
			property bool copyBin: false
			onDownloadCanceled: {
				txtStatus.text = i18n.tr("Canceled");
				progressBar.progress = 0;
			}
			onDownloadFinished: {
				if (copyBin) {
					var file;
					var i = path.lastIndexOf("/");
					var isBusybox = false;
					if (i >= 0)
						file = path.substring(i + 1, path.length);
					else
						file = path;
					var toFile = utils.dataDir() + "/bin/";
					/* Error no file */
					if (!utils.fileExists(path)) {
						txtStatus.text = i18n.tr("Error no file");
						return;
					}
					if (file.substring(0, 7) === "busybox") {
						/* Congratulations, you have a busybox! */
						isBusybox = true;
						toFile += "busybox";
					} else {
						/* Different binary, do not modify name */
						toFile += file;
					}
					if (utils.copyFile(path, toFile)) {
						utils.setPermissions(toFile, utils.binPermissions());
						txtStatus.text = i18n.tr("Download file and copy to bin directory complete!\n");
						txtStatus.text += i18n.tr("Executable installed to ") + toFile + "\n";
						if (isBusybox) {
							Utils.installBusybox()
							txtStatus.text += i18n.tr("Busybox executables are installed to ") +
									utils.dataDir() + "/bin" + "\n";
						}
					} else {
						txtStatus.text = i18n.tr("Unable to copy file ") + path +
								i18n.tr(" to ") + toFile + "\n";
						return;
					}
				} else {
					txtStatus.text = i18n.tr("Download complete!\nFile: ") + path;
				}
				btnCancel.text = i18n.tr("Finish");
				if (dialogue.autoStart)
					PopupUtils.close(dialogue);
				progressBar.progress = 100;
			}
//			onDownloadCanceledPaused: {}
			onDownloadResumed: {
				single = download;
				download.allowMobileDownload = true;
				txtStatus.text = i18n.tr("Downloading: ") + download.progress + "%\n";
				btnCancel.text = i18n.tr("Cancel");
			}
		}

		Connections {
			target: single
			onProgressChanged: {
				/* At 100 download finish will set completed status */
				if (single.progress !== 100)
					txtStatus.text = i18n.tr("Downloading: ") + single.progress + "%\n";
				progressBar.value = single.progress;
			}
		}
	}

	ScriptorButton {
		id: btnDlBin
		text: i18n.tr("Download Binary")
		enabled: !manager.downloading
		onClicked: {
			manager.copyBin = true;
			btnCancel.text = i18n.tr("Cancel");
			manager.download(txtUrl.text);
		}
	}
	ScriptorButton {
		id: btnDl
		text: i18n.tr("Download")
		enabled: !manager.downloading
		onClicked: {
			manager.copyBin = false;
			btnCancel.text = i18n.tr("Cancel");
			manager.download(txtUrl.text);
		}
	}
	ScriptorButton {
		id: btnCancel
		text: i18n.tr("Cancel")
		onClicked: {
			if (manager.downloading)
				manager.cancel();
			PopupUtils.close(dialogue);
		}
	}
	LabelForm {
		id: txtStatus
	}

	Component.onCompleted: {
		if (dialogue.autoStart) {
			txtUrl.text = busyboxUrl();
			manager.copyBin = true;
			btnCancel.text = i18n.tr("Cancel");
			manager.download(txtUrl.text);
		}
	}

	function busyboxUrl() {
		return "https://busybox.net/downloads/binaries/latest/busybox-" +
				translateArch();
	}

	function translateArch() {
		if (busyboxArchMap[CLICK_ARCH] === undefined)
			return CLICK_ARCH;
		return busyboxArchMap[CLICK_ARCH];
	}
}
