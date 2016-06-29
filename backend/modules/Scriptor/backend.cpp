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
#include "backend.h"
#include "system.h"

void BackendPlugin::registerTypes(const char *uri)
{
	Q_ASSERT(uri == QLatin1String("Scriptor"));

	qmlRegisterType<System>(uri, 1, 0, "System");
}

void BackendPlugin::initializeEngine(QQmlEngine *engine, const char *uri)
{
	QQmlExtensionPlugin::initializeEngine(engine, uri);
	QStringList picturePaths = QStandardPaths::standardLocations(QStandardPaths::PicturesLocation);
	if (picturePaths.length() > 0)
		engine->rootContext()->setContextProperty("picturesLocation", picturePaths[0]);
	else
		engine->rootContext()->setContextProperty("picturesLocation", QDir::homePath());
}
