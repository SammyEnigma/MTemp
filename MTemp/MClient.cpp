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
                                                     m_currentCommand(NoCommand){
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

bool MClient::conf(const QString &ssid, const QString &key, const quint16 port, const QString &user, const QString &pass){
    /*  non è necessario fare controlli perchè il form è a prova di idiota, per cui,                */

    return true;
}

bool MClient::timeget(){
    m_currentCommand = TimeGet;

    write(USRPSW + QString(_MTEMP_TIMEGET));
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
    /*  rimbalzo il segnale                                                                         */
    emit error(m_sock->errorString());
}

void MClient::rxHandler(){
    /*  accodo quanto ricevuto al buffer                                                            */
    m_buffer += m_sock->readAll();
    /*  se il buffer contiene la keyword                                                            */
    if(m_buffer.contains(_MTEMP_BOARD_OK)){
        /*  processo il comando                                                                     */
        parseBuffer();
    /*  se invece contiene la stringa che indica il fallimento dell'operazione                      */
    }else if(m_buffer.contains(_MTEMP_BOARD_FAIL)){
        emit boardFailure();
    /*  se invece contiene la stringa di errore del login                                           */
    }else if(m_buffer.contains(_MTEMP_BOARD_ERROR)){
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
    default:
        break;
    }
    m_currentCommand = NoCommand;
    m_buffer.clear();

}

void MClient::parseTimeGet(){

    QStringList list = m_buffer.split(SEP);
    qDebug() << m_buffer;
    emit timeGetData(list[0], list[1], list[2], list[3], list[4], list[5], list[6]);

}
