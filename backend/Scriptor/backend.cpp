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
