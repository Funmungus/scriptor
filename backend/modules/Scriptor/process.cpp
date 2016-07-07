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

#include "process.h"
#include <cstdlib>

#define STR_HELPER(x) #x
#define STRINGIFY(x) STR_HELPER(x)

Process::Process(QObject *parent) :
	QProcess(parent)
{
	connect(this, SIGNAL(error(QProcess::ProcessError)), SLOT(onError(QProcess::ProcessError)));
}

Process::~Process()
{
}

QString Process::readAllStandardOutput()
{
	QByteArray arr = QProcess::readAllStandardOutput();
	return QString(arr);
}

QString Process::readAllStandardError()
{
	QByteArray arr = QProcess::readAllStandardError();
	return QString(arr);
}

void Process::raise(int errorNumber) const
{
	if (errorNumber < 0)
		errorNumber *= -1;
	emit error(tr("Process command error ") + QString("%1: %2").
		arg(errorNumber).arg(strerror(errorNumber)));
}

void Process::onError(QProcess::ProcessError procErr)
{
	QString errStr = "";
	switch (procErr) {
	case FailedToStart:
		errStr = tr("Command not found, or cannot start");
		break;
	case Crashed:
//		errStr = tr("");
		raise(exitCode());
		break;
	case Timedout:
		errStr = tr("Timed Out");
		break;
	case ReadError:
		errStr = tr("Read Error");
		break;
	case WriteError:
		errStr = tr("Write Error");
		break;
	case UnknownError:
		errStr = tr("Unknown Error");
		break;
	}
	if (!errStr.isEmpty())
		emit error(errStr);
}
