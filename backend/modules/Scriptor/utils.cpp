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

#include "utils.h"
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <cstdlib>

Utils::Utils(QObject *parent):
	QObject(parent)
{

}

Utils::~Utils()
{

}

QString Utils::env(const QString &name)
{
	return getenv(name.toStdString().c_str());
}

QString Utils::dataDir()
{
	QString appending = getenv("XDG_DATA_HOME");
	if (appending.isNull() || appending.isEmpty()) {
		appending = getenv("HOME");
		if (appending.isNull() || appending.isEmpty())
			appending = "/home/phablet/.local/share";
		else
			appending += "/.local/share";
	}
	appending += "/scriptor.newparadigmsoftware";
	return appending;
}

bool Utils::fileExists(const QString &filePath)
{
	return QFileInfo::exists(filePath);
}

bool Utils::copyFile(const QString &copyFrom, const QString &copyTo)
{
	QFile from(copyFrom);
	QFile to(copyTo);
	if (from.exists()) {
		if (to.exists())
			to.remove();
		return from.copy(copyTo);
	}
	return false;
}

bool Utils::removeFile(const QString &filePath)
{
	QFileInfo inf(filePath);
	if (inf.exists()) {
		if (inf.isDir()) {
			return QDir(filePath).removeRecursively();
		} else {
			return QFile(filePath).remove();
		}
	}
}
