#include "MClient.h"

#define NotConnected false
#define Connected    true
#define SEP          QString(_MTEMP_SEP)
#define USRPSW       (m_user + SEP + m_pass + SEP)

MClient::MClient(QObject *parent) : QObject(parent), m_sock(NULL),
                                                     m_addr(),
                                                     m_port(0),
                                                     m_user(),
                                                     m_pass(),
                                                     m_buffer(),
                                                     m_keyword(),
                                                     m_state(NotConnected),
                                                     m_dataLen(0),
                                                     m_currentCommand(NoCommand),
                                                     m_currentRoom(0),
                                                     m_currentDay(0){
    /*  nulla da commentare                                                                         */
    m_sock = new QTcpSocket(this);
    /*  connetto i segnali della socket                                                             */
    connect(m_sock, SIGNAL(connected())         ,
            this  , SLOT(connectedBouncer())    );
    connect(m_sock, SIGNAL(disconnected())      ,
            this, SLOT(diconnectedBouncer())    );
    connect(m_sock, SIGNAL(readyRead())         ,
            this, SLOT(rxHandler())             );
    connect(m_sock, SIGNAL(bytesWritten(qint64) ),
            this, SLOT(txHandler(qint64))       );
    connect(m_sock, SIGNAL(error(QAbstractSocket::SocketError))   ,
            this, SLOT(errorBouncer(QAbstractSocket::SocketError)));
}

MClient::~MClient(){
    /*  se la socket è allocata                                                                     */
    if(m_sock){
        /*  la chiudo                                                                               */
        m_sock->close();
        /*  e libero la memoria                                                                     */
        delete m_sock;
    }
}

QString MClient::address() const{
    /*  nulla da commentare                                                                         */
    return m_addr;
}

quint16 MClient::port() const{
    /*  nulla da commentare                                                                         */
    return m_port;
}

QString MClient::username() const{
    /*  nulla da commentare                                                                         */
    return m_user;
}

QString MClient::password() const{
    /*  nulla da commentare                                                                         */
    return m_pass;
}

bool MClient::connectToHost(){

    /*  chiudo la socket                                                                            */
    m_sock->close();
    /*  provo a connettermi                                                                         */
    m_sock->connectToHost(m_addr, m_port);
    return true;
}

bool MClient::disconnectFromHost(){
    /*  se non sono connesso                                                                        */
    if(!m_state){
        /*  ritorno false                                                                           */
        return false;
    }
    /*  mi disconnetto                                                                              */
    m_sock->disconnectFromHost();
    /*  ritorno true                                                                                */
    return true;
}

bool MClient::write(const QString &str){
    /*  per trace                                                                                   */
    qDebug() << QString("MClient::write    -> ") + str;
    /*  se non sono connesso                                                                        */
    if(!m_state){
        /*  ritorno false                                                                           */
        return false;
    }
    /*  imposto la dimensione del dato                                                              */
    m_dataLen = str.toLocal8Bit().size();
    /*  scrivo sulla socket                                                                         */
    m_sock->write(str.toLocal8Bit());
    /*  ritorno true                                                                                */
    return true;
}

bool MClient::waitFor(const QString &str){
    /*  se non sono connesso                                                                        */
    if(!m_state){
        /*  ritorno false                                                                           */
        return false;
    }
    /*  imposto la keyword                                                                          */
    m_keyword = str;
    /*  ritorno true                                                                                */
    return true;
}

QString MClient::dataReceived() const{
    /*  ritorno il buffer                                                                           */
    return m_buffer;
}

void MClient::bufferClear(){
    /*  pulisco il buffer                                                                           */
    m_buffer.clear();
}

QString MClient::lastError() const{
    /*  ritorno l'ultimo errore                                                                     */
    return m_sock->errorString();
}

bool MClient::setAddress(const QString &addr){
    /*  se l'indirizzo è diverso da quello precedente                                               */
    if(m_addr != addr){
        /*  cambio l'indirizzo                                                                      */
        m_addr = addr;
        /*  ed emetto il segnale                                                                    */
        emit addressChanged(addr);
        /*  ritorno true                                                                            */
        return true;
    }
    /*  altrimenti ritorno false                                                                    */
    return false;
}

bool MClient::setPort(const quint16 &port){
    /*  se la porta è diverso da quella precedente                                                  */
    if(m_port != port){
        /*  cambio la porta                                                                         */
        m_port = port;
        /*  ed emetto il segnale                                                                    */
        emit portChanged(port);
        /*  ritorno true                                                                            */
        return true;
    }
    /*  altrimenti ritorno false                                                                    */
    return false;
}

bool MClient::setUsername(const QString &username){
    /*  se l'username è diverso da quello precedente                                                */
    if(m_user != username){
        /*  cambio l'username                                                                       */
        m_user = username;
        /*  ed emetto il segnale                                                                    */
        emit usernameChanged(username);
        /*  ritorno true                                                                            */
        return true;
    }
    /*  altrimenti ritorno false                                                                    */
    return false;
}

bool MClient::setPassword(const QString &password){
    /*  se la password è diversa da quello precedente                                               */
    if(m_pass != password){
        /*  cambio la password                                                                      */
        m_pass = password;
        /*  ed emetto il segnale                                                                    */
        emit passwordChanged(password);
        /*  ritorno true                                                                            */
        return true;
    }
    /*  altrimenti ritorno false                                                                    */
    return false;
}

void MClient::conf(const QString &ssid, const QString &key, const quint16 port, const QString &user, const QString &pass){
    /*  non è necessario fare controlli perchè il form è a prova di idiota, per cui,                */
    Q_UNUSED(ssid);
    Q_UNUSED(key);
    Q_UNUSED(port);
    Q_UNUSED(user);
    Q_UNUSED(pass);

}

void MClient::timeget(){
    /*  setto il comando                                                                            */
    m_currentCommand = TimeGet;
    /*  mando il comando                                                                            */
    write(USRPSW + QString(_MTEMP_TIMEGET));
}

void MClient::timeset(const QString &yrs, const QString &mon, const QString &day, const QString &wday, const QString &hrs, const QString &min, const QString &sec){
    QString str;
    /*  setto il comando                                                                            */
    m_currentCommand = TimeSet;
    /*  accodo l'anno                                                                               */
    str += yrs + SEP;
    /*  accodo il mese                                                                              */
    str += mon + SEP;
    /*  accodo il giorno                                                                            */
    str += day + SEP;
    /*  accodo il giorno della settimana incrementato di 1                                          */
    str += QString::number(wday.toUInt() + 1) + SEP;
    /*  accodo le ore                                                                               */
    str += hrs + SEP;
    /*  accodo i minuti                                                                             */
    str += min + SEP;
    /*  accodo i secondi                                                                            */
    str += sec + SEP;
    /*  mando il comando                                                                            */
    write(USRPSW + str + QString(_MTEMP_TIMESET));
}

void MClient::roomstat(const quint32 &number){
    /*  setto il comando                                                                            */
    m_currentCommand = RoomStat;
    /*  mando il comando                                                                            */
    write(USRPSW + QString::number(number) + SEP + QString(_MTEMP_ROOMSTAT));
}

void MClient::roomset(const quint32 & number, const QString & roomName, const quint32 & roomMode){

    QString str;
    /*  setto il comando                                                                            */
    m_currentCommand = RoomSet;
    /*  imposto la stanza corrente                                                                  */
    m_currentRoom = number;
    /*  accodo il numero della stanza                                                               */
    str += QString::number(number) + SEP;
    /*  accodo il nome                                                                              */
    str += roomName + SEP;
    /*  accodo la modalità                                                                          */
    switch (roomMode) {
    case 1:
        str += QString(_MTEMP_ENABLED)  + SEP + QString(_MTEMP_DISABLED) + SEP + QString(_MTEMP_DISABLED) + SEP;
        break;
    case 2:
        str += QString(_MTEMP_DISABLED) + SEP + QString(_MTEMP_ENABLED)  + SEP + QString(_MTEMP_DISABLED) + SEP;
        break;
    default:
        str += QString(_MTEMP_DISABLED) + SEP + QString(_MTEMP_DISABLED) + SEP + QString(_MTEMP_ENABLED)  + SEP;
        break;
    }
    /*  mando il comando                                                                            */
    write(USRPSW + str + QString(_MTEMP_ROOMSET));
}

void MClient::progget(const quint32 & roomNumber, const quint32 & weekday){

    QString str;
    /*  setto il comando                                                                            */
    m_currentCommand = ProgGet;
    /*  imposto la stanza corrente                                                                  */
    m_currentRoom = roomNumber;
    /*  imposto il giorno corrente                                                                  */
    m_currentDay = weekday;
    /*  accodo il numero della stanza                                                               */
    str += QString::number(roomNumber) + SEP;
    /*  accodo il giorno                                                                            */
    str += QString::number(weekday + 1) + SEP;
    /*  mando il comando                                                                            */
    write(USRPSW + str + QString(_MTEMP_PROGGET));
}

void MClient::progset(const quint32 &roomNumber, const quint32 &weekday, const QString &sh, const QString &sm, const QString &eh, const QString &em, const QString &tt, const bool &en){

//  username*password*R*D*HS*MS*HE*ME*TT*E*[PROGSET]
    QString str;
    /*  setto il comando                                                                            */
    m_currentCommand = ProgSet;
    /*  imposto la stanza corrente                                                                  */
    m_currentRoom = roomNumber;
    /*  imposto il giorno corrente                                                                  */
    m_currentDay = weekday;
    /*  accodo il numero della stanza                                                               */
    str += QString::number(roomNumber) + SEP;
    /*  accodo il giorno                                                                            */
    str += QString::number(weekday + 1) + SEP;

    str += (sh.length() == 1 ? QString("0") + sh : sh) + SEP;

    str += (sm.length() == 1 ? QString("0") + sm : sm) + SEP;

    str += (eh.length() == 1 ? QString("0") + eh : eh) + SEP;

    str += (em.length() == 1 ? QString("0") + em : em) + SEP;

    str += (tt.length() == 1 ? QString("0") + tt : tt) + SEP;

    str += (en ? _MTEMP_ENABLED : _MTEMP_DISABLED) + SEP;

    /*  mando il comando                                                                            */
    write(USRPSW + str + QString(_MTEMP_PROGSET));
}


void MClient::connectedBouncer(){
    /*  imposto il flag di connessione                                                              */
    m_state = Connected;
    /*  emetto il segnale                                                                           */
    emit connected();
}

void MClient::diconnectedBouncer(){
    /*  imposto il flag di connessione                                                              */
    m_state = NotConnected;
    /*  emetto il segnale                                                                           */
    emit disconnected();
}

void MClient::errorBouncer(const QAbstractSocket::SocketError err){
    Q_UNUSED(err);
    /*  rimbalzo il segnale                                                                         */
    emit error(m_sock->errorString());
}

void MClient::rxHandler(){
    /*  accodo quanto ricevuto al buffer                                                            */
    m_buffer += m_sock->readAll();

    /*  per trace                                                                                   */
    qDebug() << QString("MClient::rxHandler -> ") + m_buffer;

    /*  se il buffer contiene la keyword                                                            */
    if(m_buffer.contains(_MTEMP_BOARD_OK)){
        /*  processo il comando                                                                     */
        parseBuffer();
    /*  se invece contiene la stringa che indica il fallimento dell'operazione                      */
    }else if(m_buffer.contains(_MTEMP_BOARD_FAIL)){
        /*  pulisco il buffer                                                                       */
        m_buffer.clear();
        /*  emetto il segnale                                                                       */
        emit boardFailure();
    /*  se invece contiene la stringa di errore del login                                           */
    }else if(m_buffer.contains(_MTEMP_BOARD_ERROR)){
        /*  pulisco il buffer                                                                       */
        m_buffer.clear();
        /*  emetto il segnale                                                                       */
        emit boardError();
    }
}

void MClient::txHandler(qint64 bytes){
    /*  decremento il contatore dei bytes                                                           */
    m_dataLen -= bytes;
    /*  se ho finito di inviare                                                                     */
    if(!m_dataLen){
        /*  emetto il segnale                                                                       */
        emit dataSended();
    }
}

void MClient::parseBuffer(){

    m_buffer.remove(SEP + QString(_MTEMP_BOARD_OK));

    switch (m_currentCommand) {
    case Conf:
        //per ora nulla;
        break;
    case TimeGet:
        parseTimeGet();
        break;
    case TimeSet:
        QThread::msleep(250);
        m_currentCommand = NoCommand;
        m_buffer.clear();
        timeget();
        return;
    case RoomStat:
        parseRoomStat();
        break;
    case RoomSet:
        QThread::msleep(250);
        m_currentCommand = NoCommand;
        m_buffer.clear();
        roomstat(m_currentRoom);
        return;
    case ProgGet:
        parseProgGet();
        break;
    case ProgSet:
        QThread::msleep(250);
        m_currentCommand = NoCommand;
        m_buffer.clear();
        progget(m_currentRoom, m_currentDay);
        return;
    default:
        break;
    }
    m_currentCommand = NoCommand;
    m_buffer.clear();

}

void MClient::parseTimeGet(){

    QStringList list = m_buffer.split(SEP);
    emit timeGetData(list[0], list[1], list[2], list[3], list[4], list[5], list[6]);

}

void MClient::parseRoomStat(){


    quint32 mode = 0;

    QStringList list = m_buffer.split(SEP);


    if(      list[3] == QString(_MTEMP_DISABLED) && list[4] == QString(_MTEMP_DISABLED)){
        mode = 0;
    }else if(list[3] == QString(_MTEMP_ENABLED)  && list[4] == QString(_MTEMP_DISABLED)){
        mode = 1;
    }else if(list[3] == QString(_MTEMP_DISABLED) && list[4] == QString(_MTEMP_ENABLED)){
        mode = 2;
    }else{
        emit boardError();
    }

    m_currentRoom = 0;

    emit roomStatData(list[0].toUInt(), list[1],(list[2] == QString(_MTEMP_ENABLED)), mode, list[5].toUInt());
}

void MClient::parseProgGet(){

    QStringList list = m_buffer.split(SEP);

    m_currentRoom = 0;
    m_currentDay = 0;

    emit progGetData(list[6].toUInt(), list[1].toUInt() - 1, list[2], list[3], list[4], list[5], list[7] == QString(_MTEMP_ENABLED));
}
