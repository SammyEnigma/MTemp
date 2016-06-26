#ifndef MDEFS_H
#define MDEFS_H

#define _MTEMP_STANDARD_AP_IP       "192.168.4.1"
#define _MTEMP_STANDARD_AP_PORT     0x1F40

#define _MTEMP_BOARD_OK             "[OK]"
#define _MTEMP_BOARD_FAIL           "[FAIL]"        //errore qualcosa
#define _MTEMP_BOARD_ERROR          "[ERROR]"       //errore login

/*
 *  FORMATO STRINGA CONF
 *  (CLIENT)        SSID*KEY*IP*PORT*USER*PASSWORD*[CONF]
 */

#define _MTEMP_CONF                 "[CONF]"

/*
 *  FORMATO STRINGA TIMESET
 *  (CLIENT)        username*password*AA*MM*GG*WD*HH*MM*SS*[TIMESET]
 */
#define _MTEMP_TIMESET              "[TIMESET]"

/*
 *  FORMATO STRINGA TIMEGET
 *  (CLIENT)        username*password*[TIMEGET]
 *  (SERVER)        (AA*MM*GG*WD*HH*MM*SS*[OK] || [FAIL] || [ERROR])
 */
#define _MTEMP_TIMEGET              "[TIMEGET]"

/*
 *  FORMATO STRINGA TEMPGET
 *  (CLIENT)        username*password*R*[TEMPGET]
 *  (SERVER)        R*TT*([OK] || [FAIL] || [ERROR])
 *  (SERVER-NODO)   SENSOR*[TEMPGET]
 *  (NODO)          (SENSOR*TT*[OK] || [FAIL] || [ERROR])
 */
#define _MTEMP_TEMPGET              "[TEMPGET]"

/*
 *  FORMATO STRINGA ROOMSTAT
 *  (CLIENT)    username*password*R*[ROOMSTAT]
 *  (SERVER)    (R*NAME*ADDRESS*RELAYOUT*STATE*ISFORCEDON*ISFORCEDOFF*TT*[OK] || [FAIL] || [ERROR])
 */
#define _MTEMP_ROOMSTAT             "[ROOMSTAT]"

/*
 *  FORMATO STRINGA ROOMSET
 *  (CLIENT)    username*password*R*NAME*ADDRESS*RELAYOUT*FORCEON*FORCEOFF*AUTO*[ROOMSET]
 *  (SERVER)    ([OK] || [FAIL] || [ERROR])
 */
#define _MTEMP_ROOMSET             "[ROOMSET]"

/*
 *  FORMATO STRINGA PROGGET
 *  (CLIENT)    username*password*R*D*[PROGGET]
 *  (SERVER)    (R*D*HS*MS*HE*ME*TT*E*[OK] || [FAIL] || [ERROR])
 */
#define _MTEMP_PROGGET              "[PROGGET]"

/*
 *  FORMATO STRINGA PROGSET
 *  (CLIENT)    username*password*R*D*HS*MS*HE*ME*TT*E*[PROGSET]
 *  (SERVER)    ([OK] || [FAIL] || [ERROR])
 */
#define _MTEMP_PROGSET              "[PROGSET]"

/*
 *  FORMATO STRINGA FORCEON
 *  (CLIENT)    username*password*R*[FORCEON]
 *  (SERVER)    ([OK] || [FAIL] || [ERROR])
 */
#define _MTEMP_FORCEON              "[FORCEON]"

/*
 *  FORMATO STRINGA FORCEOFF
 *  (CLIENT)    username*password*R*[FORCEOFF]
 *  (SERVER)    ([OK] || [FAIL] || [ERROR])
 */
#define _MTEMP_FORCEOFF             "[FORCEOFF]"

#define _MTEMP_SEP                  '*'
#define _MTEMP_ENABLED              'Y'
#define _MTEMP_DISABLED             'N'

#define _MTEMP_WEEKPROGRAM_VEC_SIZE 0x00000007
#define _MTEMP_ROOM_NAME_VEC_SIZE   0x00000020
#define _MTEMP_ROOM_VEC_SIZE        0x00000008



/*
 *  FORMATO STRINGA PROGRAMMA
 *  0000000000000000111
 *  0123456789ABCDEF012
 *  D*HS*MS*HE*ME*TT*E/
 */

/*
 *  FORMATO STRINGA STANZA
 *  000000000000000011111111111111112222222222222222
 *  0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF
 *  NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN*SSSSSSS*RRRRRRR
 */

#endif // MDEFS_H
