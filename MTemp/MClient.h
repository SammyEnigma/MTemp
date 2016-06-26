#ifndef MCLIENT_H
#define MCLIENT_H

#include <QObject>
#include <QString>
#include <QTcpSocket>
#include <QHostInfo>

#include "mdefs.h"

class MClient : public QObject{

        Q_OBJECT
        Q_PROPERTY(QString address READ address WRITE setAddress NOTIFY addressChanged)
        Q_PROPERTY(quint16 port READ port WRITE setPort NOTIFY portChanged)
        Q_PROPERTY(QString username READ username WRITE setUsername NOTIFY usernameChanged)
        Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY passwordChanged)

    public:

        enum BoardAnswer{
            Fail,
            Error,
            TokenReceived
        };

        enum Commands{
            NoCommand,
            Conf,
            TimeSet,
            TimeGet,
            TempGet,
            RoomStat,
            RoomSet,
            ProgGet,
            ProgSet,
            ForceOn,
            ForceOff
        };

        explicit MClient(QObject *parent = 0);
        ~MClient();
        QString address() const;
        quint16 port() const;
        QString username() const;
        QString password() const;

    signals:
        void addressChanged(QString newAddress);
        void portChanged(quint16 newPort);
        void usernameChanged(QString newUsername);
        void passwordChanged(QString newPassword);
        void connected();
        void disconnected();
        void error(QString lastError);
        void answerReceived(MClient::BoardAnswer res);
        void dataSended();

        /*
         *  FORMATO STRINGA CONF
         *  (CLIENT)        SSID*KEY*IP*PORT*USER*PASSWORD*[CONF]
         */

    public slots:

        Q_INVOKABLE bool connectToHost();
        Q_INVOKABLE bool disconnectFromHost();
        Q_INVOKABLE bool write(const QString & str);
        Q_INVOKABLE bool waitFor(const QString & str);
        Q_INVOKABLE QString dataReceived() const;
        Q_INVOKABLE void bufferClear();
        Q_INVOKABLE QString lastError() const;

        bool setAddress(const QString & addr);
        bool setPort(const quint16 & port);
        bool setUsername(const QString & username);
        bool setPassword(const QString & password);


        Q_INVOKABLE bool conf(const QString & ssid, const QString & key, const quint16 port, const QString &user, const QString &pass);

    private slots:
        void connectedBouncer();
        void diconnectedBouncer();
        void errorBouncer(const QAbstractSocket::SocketError err);
        void rxHandler();
        void txHandler(qint64 bytes);

    private:
        QTcpSocket * m_sock;
        QString      m_addr;
        quint16      m_port;
        QString      m_user;
        QString      m_pass;
        QString      m_buffer;
        QString      m_keyword;
        bool         m_state;
        quint32      m_dataLen;
        Commands     m_currentCommand;
};

#endif // MCLIENT_H
