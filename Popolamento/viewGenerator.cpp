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


string queryProcedure(PGconn* conn, string query, string input){
    PGresult* stmt = PQprepare(conn, "query_queryProcedure", query.c_str(), 1, NULL);
    const char* parameter = input.c_str();
    PGresult* res = PQexecPrepared(conn, "query_queryProcedure", 1, &parameter, NULL, 0, 0);
    checkResults(res, conn);
    return PQgetvalue(res, 0, 0);
}



//Funzione d'appoggio per generare alori casuali con tetto massimo max
int random(int max){
    return rand() % max;
}


//viewedFun restituisce l'account visualizzato
string viewedFun(PGconn* conn, string vid){
    string query = "SELECT id_account FROM video WHERE id_video = $1::int";
    return queryProcedure(conn, query, vid);
}


//Ritorna vero se la coppia (account, id_Video) esiste già
bool alreadyViewed(PGconn* conn, string viewer, string vid){
    string query = "SELECT * FROM views WHERE account = $1::int AND id_video = $2::int";
    PGresult* stmt = PQprepare(conn, "query_alreadyViewed", query.c_str(), 2, NULL);

    const char* viewerC = viewer.c_str();
    const char* vidC = vid.c_str();
    const char* paramValues[2] = {viewerC, vidC};
    PGresult* res = PQexecPrepared(conn, "query_alreadyViewed", 2, paramValues, NULL, 0, 0);
    checkResults(res, conn);

    if(PQgetvalue(res, 0, 0) != NULL)
        return false;
    else 
        return true;
}



//Crea il valore timestamp della visualizzazione
void setTime(PGconn* conn, string viewer, string vid){
    //Recupero dataiscrizione di account
    string query = "SELECT dataiscrizione FROM account WHERE id_Account = $1::int";
    PGresult* stmt = PQprepare(conn, "query_setTime1", query.c_str(), 1, NULL);
    const char* parameter = viewer.c_str();
    PGresult* res = PQexecPrepared(conn, "query_setTime1", 1, &parameter, NULL, 0, 0);
    checkResults(res, conn);
    string dateViewer = PQgetvalue(res, 0, 0);

    //Recupero datapubblicazione di video
    query = "SELECT datapubblicazione FROM video WHERE id_video = $1::int";
    stmt = PQprepare(conn, "query_setTime2", query.c_str(), 1, NULL);
    parameter = vid.c_str();
    res = PQexecPrepared(conn, "query_setTime2", 1, &parameter, NULL, 0, 0);
    checkResults(res, conn);
    string dateVid = PQgetvalue(res, 0, 0);

    //Genero un timestamp > dei due valori appena cercati
    query = "SELECT * FROM generate_series('2023-04-01 10:00:00'::timestamp, '2050-12-31 23:59:59', '140821 sec') WHERE generate_series > $1::timestamp AND generate_series > $2::timestamp";
    PQprepare(conn, "query_setTime3", query.c_str(), 2, NULL);
    const char* viewerC = dateViewer.c_str();
    const char* vidC = dateVid.c_str();
    const char* paramValues2[2] = {viewerC, vidC};
    res = PQexecPrepared(conn, "query_setTime3", 2, paramValues2, NULL, 0, 0);
    checkResults(res, conn);
    string dateDef= PQgetvalue(res, 0, 0);


cout << viewer << " / " << vid << " / " << dateDef << endl;
    // Inserisco la tupla (account, id_Video, dataView)
    query = "INSERT INTO views VALUES ($1::int, $2::int, $3::timestamp)";
    PQprepare(conn, "query_setTime4", query.c_str(), 3, NULL);
    viewerC = viewer.c_str();
    vidC = vid.c_str();
    const char* dateC = dateDef.c_str();
    const char* paramValues3[3] = {viewerC, vidC, dateC};
    res = PQexecPrepared(conn, "query_setTime4", 3, paramValues3, NULL, 0, 0);
    //checkResults(res, conn);
}



int main(){
    //Connessione database
    char conninfo[250];
    sprintf(conninfo, "user=%s password=%s dbname=%s hostaddr=%s port=%d", PG_USER , PG_PASS , PG_DB , PG_HOST , PG_PORT);

    PGconn* conn = PQconnectdb(conninfo);

    if (PQstatus(conn) != CONNECTION_OK) {
        cout << "Errore di connessione: " << PQerrorMessage(conn) << endl;
        exit(1);
    }

    string viewed;//Eliminare ?
    int viewer, vid;//viewer->chi guarda / viewed-> chi viene visto

    srand(time(NULL));

    for(int i=0; i<1000; i++){
        //Ciclo controlla che non ci si autovisualizzi (nel caso -> altri valori) o che non si sia già visualizzato quel video (si conta solo la prima views)
        do{
            viewer = random(51); // 51 -1 = numero tot di account -> rand su chi guarda
            vid = random(150); //150 - 1 = numero tot di video -> rand su che video viene visto
        }while(to_string(viewer) == viewedFun(conn, to_string(vid)) && alreadyViewed(conn, to_string(viewer), to_string(vid)) == true); 
        //Ora setto la data
        setTime(conn, to_string(viewer), to_string(vid));     
    }
    PQfinish(conn);
    cout << "Completato con successo\n\n";
    return 0;
}