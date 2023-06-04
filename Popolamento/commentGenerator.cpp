#include <cstdio>
#include <iostream>
#include <fstream>
#include <ctime>
#include <cstring>
#include <time.h>
#include "dependencies/include/libpq-fe.h"

using namespace std ;

#define PG_HOST "127.0.0.1" //NewServer ? // oppure "localhost" o "postgresql"
#define PG_USER "postgres" // il vostro nome utente
#define PG_DB "project" // il nome del database
#define PG_PASS "davide2002" // la vostra password
#define PG_PORT 5432

void checkResults(PGresult* res, const PGconn* conn) {
    if (PQresultStatus(res) != PGRES_TUPLES_OK) {
        cout << "Risultati inconsistenti! " << PQerrorMessage(conn) << endl;
        PQclear(res);
        exit(1);
    }
}


//queryProcedure(conn, account, video, messaggio, donazione, data);
void queryProcedure(PGconn* conn, string account, string video, string messaggio, string donazione, string data){
    string query = "INSERT INTO commenti(account, id_Video, messaggio, donazione, datacommento, id_risposta) VALUES ($1::int, $2::int, $3::varchar, $4::float, $5::timestamp, $6::int)";
    PGresult* stmt = PQprepare(conn, "query_queryProcedure", query.c_str(), 6, NULL);
    const char* accountC = account.c_str();
    const char* vidC = video.c_str();
    const char* messaggioC = messaggio.c_str();
    const char* donazioneC = donazione.c_str();
    const char* dateC = data.c_str();
    const char* idRispostaC = NULL; // Inserisci qui il valore corrispondente all'id_risposta o NULL se non presente
    const char* paramValues6[6] = {accountC, vidC, messaggioC, donazioneC, dateC, idRispostaC};
    PGresult* res = PQexecPrepared(conn, "query_queryProcedure", 6, paramValues6, NULL, 0, 0);
}



//Funzione d'appoggio per decidere se commento o non, e se donazione o non
int random(int rate){
    return (rand() % 100) <= rate ?  1 : -1;
}



//Se un account ha messo like -> 50% di probabilità che faccia un commento positivo, e se fa commento 30% di possibilità faccia una donazione (Probabilità assoluta donazione: 15%)
//Se un account ha messo dislike -> 30% di probabilità che faccia un commento negativo
int main(){
    string posComm[12] = {"Questo video è davvero ispiratore! Mi ha fatto venire voglia di mettermi all opera.", 
                            "Ottima presentazione! Hai reso il contenuto così facile da capire.", 
                            "Mi sono divertito tantissimo guardando questo video. Continua così!" ,
                            "Complimenti per il tuo talento nel spiegare argomenti complessi in modo semplice e chiaro." ,
                            "Sono rimasto affascinato dall entusiasmo che trasmetti nel video. Bravissimo!", 
                            "Questo video è davvero illuminante! Mi ha dato una nuova prospettiva sull argomento.", 
                            "Grazie per aver condiviso questo video. Mi hai ispirato a provare qualcosa di nuovo!", 
                            "Che video coinvolgente! Non riuscivo a smettere di guardarne un minuto.", 
                            "Mi sono sentito motivato dopo aver visto questo video. Continua a pubblicare contenuti fantastici!", 
                            "Questo video è incredibile! Mi ha aperto gli occhi su un argomento che non conoscevo.", 
                            "Complimenti per l ottima qualità della produzione del video. È professionale e ben curato.", 
                            "Questo video è molto motivante. Mi ha spinto a intraprendere azioni positive nella mia vita."};
    string negComm[12] = {"Mi aspettavo di più da questo video. Non mi ha davvero soddisfatto.", 
                        "Penso che alcune informazioni nel video siano inesatte. Fai attenzione alla precisione.", 
                        "La qualità del suono potrebbe essere migliorata. Era difficile sentire chiaramente.", 
                        "Non mi è piaciuto il tono usato nel video. Sembra un po  troppo arrogante.", 
                        "Questo video è troppo lungo e si dilunga su argomenti non rilevanti.", 
                        "Mi aspettavo di più da questo video. È stato un po  deludente.", 
                        "Ci sono troppe interruzioni nel video, rendendolo difficile da seguire.", 
                        "La qualità del video potrebbe essere migliorata. Era sfocato in alcuni punti.", 
                        "Non mi è piaciuto il tono usato nel video. Sembra mancare di entusiasmo.", 
                        "Ho trovato il video molto noioso e poco interessante. Non è riuscito a catturare la mia attenzione.", 
                        "Mi dispiace dirlo, ma il contenuto del video era confuso e mal strutturato.", 
                        "Ho notato alcuni errori di grammatica nel testo del video. È importante fare una revisione accurata."};
    string rispCommPos[7] = {"Grazie per il tuo commento positivo! Sono felice che il video ti abbia ispirato.", 
                            "Grazie mille! Sono contento/a che ti sia piaciuto. Continua a seguirmi per altri contenuti interessanti!", 
                            "Grazie a te per aver guardato il video e per il tuo supporto! Spero che ti sia stato utile.", 
                            "Grazie per il tuo commento positivo! Sono felice che il video ti abbia dato una nuova prospettiva sull argomento.", 
                            "Grazie per il feedback positivo! Sono contento/a che il video ti sia piaciuto. Se ti interessa, ti invito ad iscriverti al canale per restare aggiornato/a su altri contenuti simili.", 
                            "Apprezzo il tuo commento positivo! Sono felice che il video abbia suscitato il tuo interesse. Ti incoraggio ad iscriverti al canale per non perderti i prossimi video.", 
                            "Grazie mille per il feedback positivo! Sono contento/a che il video ti abbia ispirato. Se desideri, puoi iscriverti al canale per ricevere ulteriori contenuti simili."};
    string rispCommNeg[6] = {"Mi dispiace che il video abbia deluso le tue aspettative. Prenderò nota dei tuoi feedback per migliorare.", 
                            "Apprezzo il tuo feedback sulla qualità del video. Farò del mio meglio per migliorarla.", 
                            "Mi spiace.. Prenderò in considerazione i tuoi suggerimenti per migliorare la struttura", 
                            "Mi dispiace che il video non abbia soddisfatto le tue aspettative. Prendo seriamente il tuo feedback e cercherò di migliorare nelle prossime produzioni.", 
                            "Mi spiace che il video non sia stato di tuo gradimento. Apprezzo il tuo commento e terrò in considerazione le tue critiche per offrire contenuti migliori in futuro.", 
                            "Mi dispiace che il video non ti abbia convinto. Cercherò di capire meglio le tue aspettative e di migliorare la qualità dei miei contenuti. Grazie per il tuo feedback."};
    
    //Connessione database
    char conninfo[250];
    sprintf(conninfo, "user=%s password=%s dbname=%s hostaddr=%s port=%d", PG_USER , PG_PASS , PG_DB , PG_HOST , PG_PORT);

    PGconn* conn = PQconnectdb(conninfo);

    if (PQstatus(conn) != CONNECTION_OK) {
        cout << "Errore di connessione: " << PQerrorMessage(conn) << endl;
        exit(1);
    }

    srand(time(NULL));
    
    PGresult* res ;
res = PQexec(conn, "DELETE FROM commenti");//Da eliminare /////////////////////////////////////////////////////////////////////////////////
    res = PQexec(conn, "SELECT * FROM likevideo");
    checkResults(res, conn);

    string account, video, data, like, messaggio, donazione;
    int tuple = PQntuples(res);

    for(int i=0; i<tuple; i++){
        donazione = "0";
        account = PQgetvalue(res, i, 1);
        video = PQgetvalue(res, i, 2);
        data = PQgetvalue(res, i, 3);
        like = PQgetvalue(res, i, 4);
                
        if(like == "1"){
            if(random(50) == 1){
                if(random(30) == 1)
                    donazione = to_string(rand() % 40);

                messaggio = posComm[rand() % 12];
                queryProcedure(conn, account, video, messaggio, donazione, data);
            }                
        }else{
            if(random(30) == 1){
                messaggio = negComm[rand() % 12];
                queryProcedure(conn, account, video, messaggio, donazione, data);
            }
        }
    }
    
    PQclear(res);
    PQfinish(conn);
    cout << "Completato con successo\n\n";
    return 0;
}