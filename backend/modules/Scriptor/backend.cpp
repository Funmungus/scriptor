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

#include <QtQml>
#include <QtQml/QQmlContext>
#include <QtCore>
#include <cstdlib>
#include "backend.h"
#include "process.h"
#include "utils.h"

#define STR_HELPER(x) #x
#define STRINGIFY(x) STR_HELPER(x)
void BackendPlugin::registerTypes(const char *uri)
{
	Q_ASSERT(uri == QLatin1String("Scriptor"));

	QString path = getenv("PATH");
	QString binDir = Utils::dataDir() + "/bin";
	QDir dirBinDir(binDir);
	std::string strPath;

	if (!dirBinDir.exists() && !dirBinDir.mkpath("."))
		qCritical() << "Not able to create directory " << binDir;
	/* Prepend our bin dir to make sure it is resolved before system */
	if (path.isEmpty() || path.isNull())
		path = binDir;
	else
		path.prepend(binDir + ":");
	strPath = path.toStdString();
	if (setenv("PATH", strPath.c_str(), 1) < 0) {
		qCritical() << "Unable to set PATH to find busybox\n";
	}

	qmlRegisterType<Process>(uri, 1, 0, "Process");
	qmlRegisterType<Utils>(uri, 1, 0, "Utils");
}

void BackendPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
	QQmlExtensionPlugin::initializeEngine(engine, uri);
	QStringList picturePaths = QStandardPaths::standardLocations(QStandardPaths::PicturesLocation);
	if (picturePaths.length() > 0)
		engine->rootContext()->setContextProperty("picturesLocation", picturePaths[0]);
	else
		engine->rootContext()->setContextProperty("picturesLocation", QDir::homePath());
	engine->rootContext()->setContextProperty("ProcessNotRunning", QProcess::NotRunning);
	engine->rootContext()->setContextProperty("ProcessStarting", QProcess::Starting);
	engine->rootContext()->setContextProperty("ProcessRunning", QProcess::Running);
	/* Expose architecture to qml */
#ifdef CLICK_ARCH
	engine->rootContext()->setContextProperty("CLICK_ARCH", STRINGIFY(CLICK_ARCH));
#endif
	engine->rootContext()->setContextProperty("utils", &_utils);
}
