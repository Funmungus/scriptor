#include "system.h"
#include <cstdlib>

System::System(QObject *parent) :
	QObject(parent), _command("")
{

}

System::~System()
{
}

void System::setCommand(const QString &command)
{
	if (command != _command) {
		_command = command;
		emit commandChanged(_command);
	}
}

void System::execute()
{
	if (!_command.isEmpty()) {
		int ret = system(_command.toStdString().c_str());
		if (ret) {
			raise(ret);
		}
	}
}

void System::raise(int errorNumber)
{
	if (errorNumber < 0)
		errorNumber *= -1;
	emit error(QString("System command error %1: %2").
		arg(errorNumber).arg(strerror(errorNumber)));
}
