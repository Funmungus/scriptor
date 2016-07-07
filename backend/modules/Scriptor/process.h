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

#ifndef PROCESS_H
#define PROCESS_H

#include <QProcess>

class Process : public QProcess
{
	Q_OBJECT
public:
	explicit Process(QObject *parent = 0);
	~Process();

	Q_INVOKABLE QString readAllStandardOutput();
	Q_INVOKABLE QString readAllStandardError();
	Q_INVOKABLE void start(const QString &command)
	{
		QProcess::start(command);
	}
	Q_INVOKABLE QString workingDirectory() const
	{
		return QProcess::workingDirectory();
	}
	Q_INVOKABLE void setWorkingDirectory(const QString &dir)
	{
		QProcess::setWorkingDirectory(dir);
	}
	Q_INVOKABLE int state() const
	{
		return QProcess::state();
	}
	Q_INVOKABLE int exitCode() const
	{
		return QProcess::exitCode();
	}
	Q_INVOKABLE bool waitForFinished(int msecs = 30000)
	{
		return QProcess::waitForFinished(msecs);
	}

signals:
	void error(const QString &error) const;
public slots:
	void raise(int errorNumber) const;
private slots:
	void onError(QProcess::ProcessError);
};

#endif // PROCESS_H
