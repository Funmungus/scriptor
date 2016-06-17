#ifndef SYSTEM_H
#define SYSTEM_H

#include <QObject>

class System : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString command READ command WRITE setCommand
		NOTIFY commandChanged)
public:
	explicit System(QObject *parent = 0);
	~System();

	inline QString command() const
	{ return ""; }
	void setCommand(const QString &command);
signals:
	void commandChanged(const QString &command);
	void error(const QString &error);
public slots:
	void execute();
	void raise(int errorNumber);
private:
	QString _command;
};

#endif // SYSTEM_H
