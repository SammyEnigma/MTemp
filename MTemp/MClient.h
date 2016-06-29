#ifndef MCLIENT_H
#define MCLIENT_H

#include <QObject>
#include <QString>
#include <QTcpSocket>
#include <QHostInfo>
#include <QDateTime>
#include <QThread>

#include "mdefs.h"

class MClient : public QObject{

        Q_OBJECT
        Q_PROPERTY(QString address READ address WRITE setAddress NOTIFY addressChanged)
        Q_PROPERTY(quint16 port READ port WRITE setPort NOTIFY portChanged)
        Q_PROPERTY(QString username READ username WRITE setUsername NOTIFY usernameChanged)
        Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY passwordChanged)

    public:

        enum Commands{
            NoCommand,
            Conf,
            TimeGet,
            TimeSet,
            RoomStat,
            RoomSet,
            ProgGet,
            ProgSet,
            TempGet,
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
        void error(QString sockErr);
        void dataSended();

        void boardError();
        void boardFailure();

        //void confOK
        /*
         *  FORMATO STRINGA TIMEGET
         *  (CLIENT)        username*password*[TIMEGET]
         *  (SERVER)        (AA*MM*GG*WD*HH*MM*SS*[OK] || [FAIL] || [ERROR])
         */
        void timeGetData(QString yrs, QString mon, QString day, QString wday, QString hrs, QString min, QString sec);
        void roomStatData(quint32 number, QString roomName, bool state, quint32 mode, quint32 temperature);
        void progGetData(quint32 temp, quint32 wday, QString sh, QString sm, QString eh, QString em, bool en);


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


        Q_INVOKABLE void conf(const QString & ssid, const QString & key, const quint16 port, const QString &user, const QString &pass);
        Q_INVOKABLE void timeget();
        Q_INVOKABLE void timeset(const QString & yrs, const QString & mon, const QString & day, const QString & wday, const QString & hrs, const QString & min, const QString & sec);
        Q_INVOKABLE void roomstat(const quint32 & number);
        Q_INVOKABLE void roomset(const quint32 & number, const QString & roomName, const quint32 & roomMode);
        Q_INVOKABLE void progget(const quint32 & roomNumber, const quint32 & weekday);
        Q_INVOKABLE void progset(const quint32 & roomNumber, const quint32 & weekday, const QString & sh, const QString & sm, const QString & eh, const QString & em, const QString & tt, const bool & en);

    private slots:
        void connectedBouncer();
        void diconnectedBouncer();
        void errorBouncer(const QAbstractSocket::SocketError err);
        void rxHandler();
        void txHandler(qint64 bytes);

        void parseBuffer();
        void parseTimeGet();
        void parseRoomStat();
        void parseProgGet();
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
        quint32      m_currentRoom;
        quint32      m_currentDay;
};

#endif // MCLIENT_H
